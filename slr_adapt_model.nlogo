;To-do on Friday: Get the VC system (as it stands) over into the new code
;re-run all RA


;how to deal with cost cap:

;step 1 max cost (can refine later)
;boston mun annual = 20M (https://www.wbur.org/news/2021/06/16/boston-seaport-fort-point-climate-change-sea-level)
;quincy mun annual = 2.72 M based on ratio above (https://cms7files1.revize.com/quincyma/FY2023%20Adopted%20Budget.pdf)
;Winthrop mun annual = 0.56 M

;for property_owners, assume cost cap = 5% building value = 15,000k/year
;for MBTA,
;for BOS Logan + food dist (50 M/year?) - should be very high
;if cost is too high, then agents are assumed to 'save'



;these are necessary to load the map, process csvs, incorporate python, and track the time functions take to run
;let's plan maintenance feed
   ;maybe add extra adaptation outcomes
   ;rather than assuming adaptation cooperation, add an evaluation metric here with the maintenance fee where cost <= planned cost independently
extensions [ gis
  csv
  py
  profiler]


globals[
  harbor-coopertative-construct-list
  mbta-adapt-cost-test
  model-thirty-year-damage-list
  model-thirty-year-damage-sw-list
  o-m-cost-ra
  o-m-cost-cum-ra
  storm-elevation
  slr-array
  ;Maco-7 and tac-7 are used to track MBTA damages but must be globals due to nature of mbta having multiple methods
  maco-7
  tac-7
  ;tracks which segments of MBTA are cooperative
  mbta-coop-construct-list
  ;tracks delay of each mbta-segment
  mbta-permit-delay-list
  ;tracks total adaptation cost of each segment (note: this will be = to mbta-adaptation-cost-list unless future possible adaptation options are added in the future
  mbta-total-adaptation-cost-list
  ;used as a placeholder to independently evaluate each MBTA segment- not saved to a particular region
  segment-ben-cost-ratio
  ;an array of the % of total MBTA damage that would occur in each segment - ie maybe Boston has 80% of the assets so the value for Boston is 0.8
  mbta-damage-proportion-list
  ;an array of the % of total adaptaiton costs that are in each segment - Boston may be 70% of total adaptation costs so the value would be 0.7
  mbta-cost-proportion-list
  ;list of adaptaitons for each segment according to MBTA
  mbta-adaptation-list
  ;list of adaptation-intention for each segment of MBTA adaptation
  mbta-adaptation-intention-list
  ;list of cost for adaptations in each MBTA segment
  mbta-adaptation-cost-list
  ;tracks mbta ben-cost ratio for each possible segment
  mbta-benefit-cost-ratio-list
  ;keeps track of the planned adaptation cost once the intention is there for the T
  mbta-planned-adaptation-cost-list
  ;tracks available mbta budget- needs to be a global due to the multiple methods
  available-budget-mbta
  ;tracks how much mbta has contributed to coalition costs
  mbta-costs-current
  ;three globals below aid in mbta o+m tracking
  mbta-base-adaptation-cost-list
  mbta-o-m-cost-list
  mbta-o-m-cum-cost-list
  ;tracks height that a structure is protected to
  protect-height
  ;signifies if other agents are waiting for municipalities to adapt while they raise funds or wait for permits
  hold-adaptation?
  ;adaptation costs spent by the total coalitions
  vc-total-adaptation-costs
  ;tracks step-by-step adaptation costs in the coalition formation process
  total-mbta-paid-so-far
  ;singular value that MBTA contributes to coalition and list below that
  mbta-cooperative-adaptation-contribution
  mbta-cooperative-adaptation-contribution-list
  ;the mbta damage array for boston alone
  mbta-damage-list-boston
  ;total mbta damage array
  mbta-damage-list-ra
  ;tracks the permit delays that are ongoing across the region
  ra-permit-delay-list
  ;tracks the permit delays that are ongoing across boston
  boston-permit-delay-list
  ;the behavioral modifier for the regional authority
  ra-behave-modifier
  ;track base adaptation cost for ra
  ra-base-adaptation-cost
  ;used for prioritization
  used-list
  ;prioritization method
  ranked-list-nums ;test variable only
  ;prioritization method
  empty-list ;test variable only
  ;prioritization method
  ranked-list-num
  ;placeholder
  num
  ;tracks total insurance payouts over time
  insurance-payout-total-list
  ;maintains list of total insurance payouts
  insurance-payout-list
  ;total damages acutally paid by property_owners
  damages-paid-total-list
  ;list of damages paid by property_owners
  damages-paid-list
  ;list of expected damages given a seawall for each segment of Boston
  annual-expected-damage-boston-list-sw
  annual-expected-damage-boston-list-sw-in-place
  ;current adaptation as a placeholder
  current-adapt
  ;list in order of boston neighborhoods
  boston-neighborhood-list
  ;by segment for the regional authority of money spent on adaptations
  ra-total-adaptation-cost-list
  ;for metrics at the end- total adaptation cost list
  model-cumulative-adaptation-cost-list
  ;for metrics at end- damages across all agents
  model-cumulative-damage-list
  ;metrics at end- adaptations for all agents
  model-adaptation-list
  ;metrics at end- adapation cost for time step across all agents
  model-adaptation-cost-list
  ;metrics at end and for GUI- the number of adaptations implemented at any given time step
  model-adaptation-count-list
  ;count o-m-costs total
  model_o_m_costs
  ;count cum om costs
  model_o_m_cum_costs
  ;total damage across boston neighbodhoods in a list
  boston-total-damage-list
  ;not used - I think we can remove
  current-adapt-30-year-estimates-boston-list
  ;list of expected damages with a seawall for Boston neighborhoods
  boston-thirty-year-damage-sw-list
  ;list of expected damages without a seawall for Boston neighborhoods
  boston-thirty-year-damage-list
  ;for metrics at end- time step damage for all agents
  model-time-step-damage-list
  ;adaptation costs for each segment of the RA version (includes permitting)
  ra-adaptation-cost-list
  ;adaptation-cost-list-with-om
  ra-adaptation-cost-list-om
  ;adaptation costs among all time for RA by segment
  ra-total-adaptation-cost
  ;adaptation intention for each segment of the RA region
  ra-adaptation-intention-list
  ;adaptation for total regional area
  ra-adaptation-list
  ;benefit-cost ratio for entire RA region by segment
  ra-benefit-cost-ratio-list
  ;if adaptation is planned for an RA segment, the cost is placed in the list below
  ra-planned-adaptation-cost-list
  ;list of CRS discounts for each egment of the RA (if seawall is in place, assume that this discount is 30%)
  ra-crs-discount-list
  ;tracks overall budget for the regional authority
  ra-available-budget
  ;available budget for the regional authority
  ra-annual-budget
  ;budget with the discount
  ra-an-budget-discount
  ;used to help calculate relative cost
  ra-relative-damage-avoided
  ;placeholder for a benefit-cost-ratio
  b-c-ratio
  ;damage estimates for South shore without a seawall
  thirty_year_damage_ss_mun
  ;damage estimates for South shore with a seawall
  thirty_year_damage_ss_sw_mun
  ;damage estimates for North shore without a seawall
  thirty_year_damage_ns_mun
  ;damage estimates for North shore without a seawall
  thirty_year_damage_ns_sw_mun
  ;list of the benefit-cost ratios for boston segments alone
  cost-benefit-seawall-bos
  ;true/false about which linkages to include (Residual from a previous model version)
  include-linkages
  ;placeholder for when we go through lists
  pos
  ;placeholder for the current adaptation of a region being calculated
  neigh-adapt
  ;total costs spent in a single time step
  time-step-costs
  ;placeholder for list work
  test-pos
  ;below used for for GIS
  projection
  south-shore
  boston-mun
  north-shore
  total-harbor
  mbta-route
  mbta-station
  boston-logan
  flood-height
  ;tracks year of simulation
  year
  ;keeps fiirst year of simulation in mind
  year-start
  ;the sea level in the start of the simulation (base elevation in NAV88)
  slr_zero
  ;The AEP intervals we have for Boston
  harbor-aep-list
  ;used to ID regions that property_owners live in
  loc-test-dev
  ;all of the following are sourced form the outer harbor barrier study and are arrays of damage according to the AEPs for each neighborhood
     ;they correspond to damages with and without a 15 ft seawall
  allston-dam-0
  allston-dam-1
  allston-dam-3
  allston-dam-5
  allston-dam-0-sw
  allston-dam-1-sw
  allston-dam-3-sw
  allston-dam-5-sw
  allston-dam-list
  backbay-dam-0
  backbay-dam-1
  backbay-dam-3
  backbay-dam-5
  backbay-dam-0-sw
  backbay-dam-1-sw
  backbay-dam-3-sw
  backbay-dam-5-sw
  backbay-dam-list
  charlestown-dam-0
  charlestown-dam-1
  charlestown-dam-3
  charlestown-dam-5
  charlestown-dam-0-sw
  charlestown-dam-1-sw
  charlestown-dam-3-sw
  charlestown-dam-5-sw
  charlestown-dam-list
  downtown-dam-0
  downtown-dam-1
  downtown-dam-3
  downtown-dam-5
  downtown-dam-0-sw
  downtown-dam-1-sw
  downtown-dam-3-sw
  downtown-dam-5-sw
  downtown-dam-list
  eastboston-dam-0
  eastboston-dam-1
  eastboston-dam-3
  eastboston-dam-5
  eastboston-dam-0-sw
  eastboston-dam-1-sw
  eastboston-dam-3-sw
  eastboston-dam-5-sw
  eastboston-dam-list
  fenway-dam-0
  fenway-dam-1
  fenway-dam-3
  fenway-dam-5
  fenway-dam-0-sw
  fenway-dam-1-sw
  fenway-dam-3-sw
  fenway-dam-5-sw
  fenway-dam-list
  jamaicaplain-dam-0
  jamaicaplain-dam-1
  jamaicaplain-dam-3
  jamaicaplain-dam-5
  jamaicaplain-dam-0-sw
  jamaicaplain-dam-1-sw
  jamaicaplain-dam-3-sw
  jamaicaplain-dam-5-sw
  jamaicaplain-dam-list
  ndorchester-dam-0
  ndorchester-dam-1
  ndorchester-dam-3
  ndorchester-dam-5
  ndorchester-dam-0-sw
  ndorchester-dam-1-sw
  ndorchester-dam-3-sw
  ndorchester-dam-5-sw
  ndorchester-dam-list
  ndorchester-combined-dam-0
  ndorchester-combined-dam-1
  ndorchester-combined-dam-3
  ndorchester-combined-dam-5
  ndorchester-combined-dam-0-sw
  ndorchester-combined-dam-1-sw
  ndorchester-combined-dam-3-sw
  ndorchester-combined-dam-5-sw
  ndorchester-combined-dam-list
  roxbury-dam-0
  roxbury-dam-1
  roxbury-dam-3
  roxbury-dam-5
  roxbury-dam-0-sw
  roxbury-dam-1-sw
  roxbury-dam-3-sw
  roxbury-dam-5-sw
  roxbury-dam-list
  sboston-dam-0
  sboston-dam-1
  sboston-dam-3
  sboston-dam-5
  sboston-dam-0-sw
  sboston-dam-1-sw
  sboston-dam-3-sw
  sboston-dam-5-sw
  sboston-dam-list
  sboston-combined-dam-0
  sboston-combined-dam-1
  sboston-combined-dam-3
  sboston-combined-dam-5
  sboston-combined-dam-0-sw
  sboston-combined-dam-1-sw
  sboston-combined-dam-3-sw
  sboston-combined-dam-5-sw
  sboston-combined-dam-list
  sdorchester-dam-0
  sdorchester-dam-1
  sdorchester-dam-3
  sdorchester-dam-5
  sdorchester-dam-0-sw
  sdorchester-dam-1-sw
  sdorchester-dam-3-sw
  sdorchester-dam-5-sw
  sdorchester-dam-list
  southend-dam-0
  southend-dam-1
  southend-dam-3
  southend-dam-5
  southend-dam-0-sw
  southend-dam-1-sw
  southend-dam-3-sw
  southend-dam-5-sw
  southend-dam-list
  ;an array of the total coastline legnth for each segment
  coastline-length-list
  ;adaptation list for boston segments
  boston-adaptation-list
  ;for boston total adaptation cost by segment
  boston-total-adaptation-cost-list
  ;adaptation intetnion for each boston neighborhood
  boston-adaptation-intention-list
  ;potential seawall cost for each of the Boston segments
  boston-seawall-cost-list
  ;list of costsa voided for each segment that would come from the seawall cosntruction
  boston-seawall-costs-avoided-list
  ;benefit-cost list for each Boston neighborhood
  boston-seawall-cost-benefit-list
  ;planned adaptation cost for each segmenet of boston at each time step
  boston-planned-adaptation-cost-list
  ;list of adaptation costs for boston in each time step
  boston-adaptation-costs-list
  ;three globals below aid in mbta o+m tracking
  boston-base-adaptation-cost-list
  boston-o-m-cost-list
  boston-o-m-cum-cost-list
  ;tracks height that a structur
  ;the variables below track time step and total damages for each neighborhood in boston
  time-step-damage-allston
  total-damage-allston
  time-step-damage-backbay
  total-damage-backbay
  time-step-damage-charlestown
  total-damage-charlestown
  time-step-damage-downtown
  total-damage-downtown
  time-step-damage-eboston
  total-damage-eboston
  time-step-damage-fenway
  total-damage-fenway
  time-step-damage-ndorchester
  total-damage-ndorchester
  time-step-damage-sboston
  total-damage-sboston
  time-step-damage-sdorchester
  total-damage-sdorchester
  ;expected damage, time step damage, and total damages for each neighborhood in Boston
  annual-expected-damage-boston-list
  boston-time-step-damages-list
  boston-total-damages-list
  ;value of insurance premiums paid in each time step
  insurance-premium-time-step
  ;value of insurance premiums paid totally
  insurance-premium-total
  ;benefit-cost-list once the behaviorla modifier is included
  benefit_cost_list_behavior
  ;base benefit-cost-list
  benefit_cost_list
  ;placeholder for a single option's benefit
  option-benefit
  ;helps to track things
  identifier
  ;crs discount aacross boston region
  boston-crs-discount-list
  ;tracks which of the boston neighborhoods would form a coalition
  boston-coop-construct-list
  ;discount rate of agents who overpay
  boston-vc-discount-rate-list
  ;used for voluntary cooperation cost estimates
  cost-deduction-property_owners
  cost-deduction-mbta
  wait-for-permit-boston
  mbta-cooperative-adaptation-contribution-proposed
  mbta-cooperative-adaptation-contribution-list-proposed
  segment-discount ;used in cost-sharing process
  mbta-vc-costs
  mbta-vc-total-costs
  ;list of EJ weights for the region
  harbor-region-EJ-weights
  ej-weight
  boston-planned-adaptation-cost-list-om
  seawall-cost-cooperative-boston-list
  seawall-cost-benefit-cooperative-boston-list
]

patches-own[
  ;following help with GIS
  town
  airport?
  mbta-station-name
  mbta-route-name
  region]

;sets up total agent type and linkages for the map on the GUI
breed [municipalities municipality]
breed [private-assets private-asset]
breed [MBTA-agents MBTA-agent]
breed [property_owners property_owner]
directed-link-breed [exchanges exchange]
breed [regional-authorities regional-authority]

;applies to North Shore (Winthrop), South Shore (Quincy) and Boston
;Note: most 'Boston' variables have to be globals based on how NetLogo operates
municipalities-own[
  ;whether or not the municipality will act cooperatively
  cooperative-construct?
  ;used in voluntary-cooperation-to-indicate-agents-to-wait
  wait-for-permit
  ;how long the municipality has been waiting for a permit
  permit-delay-count
  ;CRS value
  crs-discount
  ;how long agents project forward for benefit-cost calculations
  foresight
  ;otudated variable
  ratio-links
  ;estimate of 30 year damages with current adaptation
  current-adapt-30-year-estimates
  ;cost of potentially constructing a seawall
  potential-sw-cost
  ;damage projection without sw
  thirty_year_damage
  ;damage projection with se
  thirty_year_damage_sw
  ;next years damage no sw
  annual-expected-damage
  ;next years damage with sw
  annual-expected-damage-sw
  ;the following are due to the delay mechanism and track the in place adaptation
  annual-expected-damage-sw-in-place
  ;figuring out best method
  python-output
  ;outdated- tracker of last 10 floods
  flood-memory
  ;damage in the signle time step
  damage-time-step
  ;all time damage
  total-damage
  ;name of the region
  name
  ;projection of an annual flood height
  ;flood-height-proj
  ;total-proj-damage
  ;damage-proj
  ;desired adaptation of municipalities
  adaptation-intention
  ;exisitng adaptation
  adaptation
  ;adaptation-test
  ;cumulative adaptation cost
  total-adaptation-cost
  ;time step adaptation cost
  adaptation-cost
  ;adaptation cost before implemented
  planned-adaptation-cost
  ;benefit-cost ratio
  cost-benefit-ratio
  ;length of coastline
  coastline
  ;data we have for AEP
  mun-aep-list
  ;array of damages with and without seawalls for diffferent scenarios of SLR- corresponds to AEP list above
  dam-0
  dam-1
  dam-3
  dam-5
  dam-0-sw
  dam-1-sw
  dam-3-sw
  dam-5-sw
  ;counts adaptation over time
  adaptation-count
  ;residual variable
  linked-damages
  ;residual variable
  o-m-cost
  ;budget available to adapt
  available-budget
  ;annual budget
  annual-budget
  ;discounted annual budget
  an-budget-discount
  ;residual method
  linked-damages
  ;benefit-cost of a seawall
  cost-benefit-seawall
  ;used to set the discount rate for ns + ss
  segment-discount-mun
  ;used for permitting costs
   potential-sw-cost-perm
  ;used for sw + perm + om costs
   potential-sw-cost-all
  ;track cum o+m costs
  o-m-cost-cum
  seawall-cost-cooperative
  seawall-cost-benefit-cooperative
]

private-assets-own[
  ;asset value total
  property_value
  ;willingness to form coalition in voluntary
  cooperative-construct?
  ;how long they have been waiting for a permit
  permit-delay-count
  ;how hight the building is protected from a flood
  flood-protect-height
  ;exepcted damages from this year
  annual-expected-damage
  ;expected damges this year if I had a seawall
  annual-expected-damage-sw
  ;what adaptation does the municipality have
  adapt-test-mun
  ;distance of projected damages
  foresight
  ;not sure- outdated I believe
  ratio-links
  ;residual variable
  current-adapt-30-year-estimates
  ;seawall cost
  potential-sw-cost
  ;expected damage in a single year
  annual-expected-damage
  annual-expected-damage-sw-in-place
  ;figuring out best method
  python-output
  ;benefit-cost ratio of seawall construction
  cost-benefit-seawall
  ;floodmemory- not used by anything but could be used for flood tolerance in the future
  flood-memory
  ;base elevation
  elevation
  ;damage occurring in a given time step
  damage-time-step
  ;total damage occurring over time
  total-damage
  ;name of the agent
  name
  ;adaptation in place
  adaptation
  ;intended adaptation
  adaptation-intention
  ;used to explore options
  adaptation-test
  ;cumulative adaptation cost
  total-adaptation-cost
  ;given adaptation cost
  adaptation-cost
  ;adaptaiton cost of planned adaptation
  planned-adaptation-cost
  ;benefit-cost ratio of the adaptation
  cost-benefit-ratio
  ;adapataiton of the municipality where this resided
  mun-adapt
  ;array of exceedance probabilityies used to calculate damages
  dev-aep-list
  ;benefit-cost for seawall cosntruction
  cost-benefit-seawall
  ;benefit-cost for aquafence cosntruction
  cost-benefit-aquafence
  ;used to set region
  loc
  ;tracks number of adaptations implemented
  adaptation-count
  ;tracks op and maitnenance costs- old version
  o-m-cost
  ;budget that can be used in a given time step
  available-budget
  ;budget addition each year
  annual-budget
  ;annual budget accounting for discount rate
  an-budget-discount
  ;outdated
  linked-damages
  ;damages estimates for the next 30 years
  thirty_year_damage
  ;damage estimates for next 30 years with sw
  thirty_year_damage_sw
  ;notes which boston sw segment the asset exists within
  boston-sw-segment
  ;number of that neighborhood
  boston-sw-segment-num
  ;t/f whether or not municipality has a sw there
  municipal-sw?
  ;track cum o+m costs
  o-m-cost-cum
]

MBTA-agents-own[
  ;should correspond to the same variables above
  cooperative-construct?
  permit-delay-count
  foresight
  ratio-links
  current-adapt-30-year-estimates
  potential-sw-costg
  annual-expected-damage
  annual-expected-damage-region
  annual-expected-damage-sw
  annual-expected-damage-sw-in-place
  ;figuring out best method
  python-output
  cost-benefit-seawall
  additional-damage
  damage-component
  flood-memory
  total-damage
  damage-time-step
  netlogo_proj_list
  flood-height-proj
  total-proj-damage
  damage-proj
  adaptation
  adaptation-intention
  adaptation-test
  total-adaptation-cost
  adaptation-cost
  planned-adaptation-cost
  none-proj
  local-seawall-proj
  total-proj-damage-test
  flood-more-than-3-count
  flood-more-than-15-count
  cost-benefit-ratio
  mbta-aep-list
  dam-0
  dam-0.23
  dam-1.41
  dam-2.59
  dam-4.41
  dam-sw-0
  dam-sw-0.23
  dam-sw-1.41
  dam-sw-2.59
  dam-sw-4.41
  adaptation-count
  o-m-cost
  available-budget
  annual-budget
  an-budget-discount
  linked-damages
  max-damage
  thirty_year_damage
  thirty_year_damage_sw
  potential-sw-cost
  ;track cum o+m costs
  o-m-cost-cum
]

property_owners-own[
  ;should correspond to variables above
  ;estimates property line length
  perimeter
  ;determines if they are commercial property or just a single homeowner -
  sector
  ;max amount NFIP will pay
  max-flood-insurance-coverage
  seawall-cost
  aquafence-cost
  cooperative-construct?
  permit-delay-count
  annual-budget-percent
  foresight
  flood-protect-height
  forsight
  ratio-links
  boston-sw-segment
  boston-sw-segment-num
  current-adapt-30-year-estimates
  potential-sw-cost
  potential-af-cost
  annual-expected-damage
  annual-expected-damage-af
  annual-expected-damage-sw
  annual-expected-damage-af-in-place
  annual-expected-damage-sw-in-place
  ;figuring out best method
  python-output
  flood-memory
  elevation
  dev-region
  damage-time-step
  total-damage
  netlogo_proj_list
  flood-height-proj
  total-proj-damage
  damage-proj
  damage-percent
  adaptation
  adaptation-intention
  adaptation-test
  planned-adaptation-cost
  total-adaptation-cost
  adaptation-cost
  none-proj
  local-seawall-proj
  fence-proj
  total-proj-damage-test
  flood-more-than-3-count
  flood-more-than-15-count
  cost-benefit-ratio
  mun-adapt
  dev-aep-list
  cost-benefit-seawall
  cost-benefit-aquafence
  loc
  adaptation-count
  linked-damages
  o-m-cost
  deployment-cost
  available-budget
  annual-budget
  an-budget-discount
  thirty_year_damage_sw
  thirty_year_damage_af
  thirty_year_damage
  adapt-test-mun
  municipal-sw?
  insurance?
  premium
  deductible
  damages-paid
  damages-paid-total
  insurance-damages-covered
  insurance-damages-covered-total
  premium_2022
  insurance-damages
  insurance-af-damages
  insurance-sw-damages
  insurance-intention
  insurance-cost
  insurance-af-cost
  insurance-sw-cost
  aquafence-cost
  aquafence-cost-perm
  aquafence-cost-all
  seawall-cost-perm
  seawall-cost-all
  seawall-cost
  aquafence-cost-discount-perm
  aquafence-cost-discount-all
  aquafence-cost-discount
  seawall-cost-discount-perm
  seawall-cost-discount-all
  seawall-cost-discount
  crs-discount
  premium-adjusted
  mandatory-insurance?
  damages-paid-property_owner
  damages-paid-property_owner-total
  damages-paid-insurance
  damages-paid-insurance-total
  ins-ben-cost
  property_value
  ;track cum o+m costs
  o-m-cost-cum

]


regional-authorities-own[
  foresight
  adaptation-cost-list
  total-adaptation-cost
  adaptation-intention-list
  adaptation-list
  adaptation-test-list
  annual-expected-damage
  annual-expected-damage-sw-in-place
  flood-memory
  thirty_year_damage_ss
  thirty_year_damage_ss_sw
  thirty_year_damage_ns
  thirty_year_damage_ns_sw
  thirty_year_damage_boston
  thirty_year_damage_boston_sw
  thirty_year_damge_boston_dev
  thirty_year_damge_ns_dev
  thirty_year_damge_ss_dev
  thirty_year_damge_boston_dev_mun_sw
  thirty_year_damge_ns_dev_mun_sw
  thirty_year_damge_ss_dev_mun_sw
  thirty_year_damge_boston_dev_af
  thirty_year_damge_ns_dev_af
  thirty_year_damge_ss_dev_af
  thirty_year_damge_boston_dev_onsite
  thirty_year_damge_ns_dev_onsite
  thirty_year_damge_ss_dev_onsite
  thirty_year_damage_mbta
  thirty_year_damage_mbta_sw
  thirty_year_damage_bos_logan
  thirty_year_damage_bos_logan_onsite
  thirty_year_damage_bos_logan_mun_sw
  thirty_year_damage_food_dist
  thirty_year_damage_food_dist_onsite
  thirty_year_damage_food_dist_mun_sw
  mun-aep-list]




links-own [
  other-end-damage-effect
  cumulative-damage
  ratio-source-end-damages
  other-end-expected-damages
  node-damages
  end-damages]

to setup-behavior-space
  clear-all
end


to setup-patches

  ;the following commands clear and reset the amp
  clear-ticks
  clear-turtles
  clear-all-plots
  clear-output
  reset-ticks


  ;tests for the existance of a map already for behavior space - if there is a map, then time is reset and if not, a map is generated (saves time between consecutive model runs)
  ifelse any? patches with [town = "BOSTON"]
  [ ;map exists, no need to run GIS again
    set year 2021
  set year-start 2021
    (py:run "new_loc = 6.438656963108146"
      "new_scale=0.44264718007554776"
      "new_mu = 6.69415"
      "new_var= .3223"
      "new_stdev = new_var ** 0.5")
  ]

  [ ;need to set everything up from scratch

  setup-python
  (py:run "new_loc = 6.438656963108146"
      "new_scale=0.44264718007554776"
      "new_mu = 6.69415"
      "new_var= .3223"
      "new_stdev = new_var ** 0.5")
  set-patch-size 0.5
  resize-world 0 500 0 500
  set projection "WGS_84_Geographic"
  set total-harbor gis:load-dataset "total_harbor.shp"
  ;set mbta-route gis:load-dataset "full_map.shp"
  set boston-logan gis:load-dataset "boston_logan_maybe.shp"
  gis:set-world-envelope
  (gis:envelope-union-of
    (gis:envelope-of total-harbor)
    ;(gis:envelope-of mbta-route)
    )
  gis:set-drawing-color green
  gis:fill total-harbor 1
  ;gis:set-drawing-color brown
  ;gis:draw mbta-route 1
  gis:set-drawing-color green + 3
  gis:fill boston-logan 1
  gis:apply-coverage total-harbor "TOWN" town
  gis:apply-coverage boston-logan "PARCEL" airport?
  ;gis:apply-coverage mbta-route "LINE" mbta-route-name
  ;code below sorts many regions into the three we use for this section
  ask patches[
    if town = "BOSTON"[
      set region "boston"]
    if town = "HINGHAM"[
      set region "south-shore"]
    if town = "HULL"[
      set region "south-shore"]
    if town ="WEYMOUTH"[
      set region "south-shore"]
    if town = "QUINCY"[
      set region "south-shore"]
    if town = "BRAINTREE"[
      set region "south-shore"]
    if town = "LYNN"[
      set region "north-shore"]
    if town = "MEDFORD"[
      set region "north-shore"]
    if town = "NAHANT"[
      set region "north-shore"]
    if town = "REVERE"[
      set region "north-shore"]
    if town = "SAUGUS"[
      set region "north-shore"]
    if town = "SOMERVILLE"[
      set region "north-shore"]
    if town = "WINTHROP"[
      set region "north-shore"]
    if town = "CHELSEA"[
      set region "north-shore"]
    if town = "EVERETT"[
      set region "north-shore"]
  ]
  ]


end

to setup-agents
  clear-globals
  ;resets regional authority adaptation costs at 0 for each considered segment of seawall
  set harbor-region-ej-weights [1.00 0.91 1.45 0.51 0.50 0.67 1.24 1.84 1.45 1.11 1.35]
  set boston-coop-construct-list [false false false false false false false false false]
  set ra-permit-delay-list [0 0 0 0 0 0 0 0 0 0 0]
  set boston-permit-delay-list [0 0 0 0 0 0 0 0 0]
  set boston-neighborhood-list (list "allston" "backbay" "charlestown" "downtown" "east boston" "fenway" "north dorchester" "south boston" "south dorchester")
  set ra-total-adaptation-cost-list [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  set ra-planned-adaptation-cost-list [0 0 0 0 0 0 0 0 0 0 0]
  set ra-crs-discount-list [0 0 0 0 0 0 0 0 0 0 0]
  set ra-available-budget 0
  ;sets total regional authority costs to 0
  set ra-total-adaptation-cost 0
  ;sets all boston damages at 0 to start
  set boston-thirty-year-damage-sw-list [0 0 0 0 0 0 0 0 0]
  set boston-thirty-year-damage-list [0 0 0 0 0 0 0 0 0]
  ;flood elevations according to AEPs for 0 ft of SLR (current approximations)
  set slr_zero [10.95 10.54 9.99 9.58 9.17 8.61 8.17 7.7 7.54]
  ;AEPs for flood elevations above
  set harbor-aep-list [0.001 0.002 0.005 0.01 0.02 0.05 0.1 0.2 0.25]
  ;the following lists provide information about the damages for each AEP used for agent expected and experienced damages. If it is an empty array, the agent experiences no damage at that amount of slr. Arrays are both w/ and w/out a seawall.
  set allston-dam-0 [0 0 0 0 0]
  set allston-dam-1 [0 0 0 0 0]
  set allston-dam-3 [207000000 122164444 16120000 9020000 9020000]
  set allston-dam-5 [509000000 422777777 315000000 197000000 133000000]
  set allston-dam-0-sw [0 0 0 0 0]
  set allston-dam-1-sw [0 0 0 0 0]
  set allston-dam-3-sw [0 0 0 0 0]
  set allston-dam-5-sw [509000000 422777777 0 0 0]
  ;this creates a list of lists (so that one variable stores all information for allston
  set allston-dam-list (list allston-dam-0 allston-dam-1 allston-dam-3 allston-dam-5 allston-dam-0-sw allston-dam-1-sw allston-dam-3-sw allston-dam-5-sw)
  ;same for each of the bsoton neighborhoods below
  set backbay-dam-0 [0 0 0 0 0]
  set backbay-dam-1 [0 0 0 0 0]
  set backbay-dam-3 [397000000 331814814 67000000 13200000 13200000]
  set backbay-dam-5 [1569000000 1455666666 1314000000 1138000000 835000000]
  set backbay-dam-0-sw [0 0 0 0 0]
  set backbay-dam-1-sw [0 0 0 0 0]
  set backbay-dam-3-sw [0 0 0 0 0]
  set backbay-dam-5-sw [1569000000 1455666666 0 0 0]
  set backbay-dam-list (list backbay-dam-0 backbay-dam-1 backbay-dam-3 backbay-dam-5 backbay-dam-0-sw backbay-dam-1-sw backbay-dam-3-sw backbay-dam-5-sw)
  set charlestown-dam-0 [84000000 64000000 39000000 23380000 14300000]
  set charlestown-dam-1 [252000000 197333333 129000000 122000000 29120000]
  set charlestown-dam-3 [696000000 653333333 600000000 528000000 435000000]
  set charlestown-dam-5 [959000000 864333333 746000000 720000000 474000000]
  set charlestown-dam-0-sw [0 0 0 0 0]
  set charlestown-dam-1-sw [0 0 0 0 0]
  set charlestown-dam-3-sw [0 0 0 0 0]
  set charlestown-dam-5-sw [959000000 864333333 0 0 0]
  set charlestown-dam-list (list charlestown-dam-0 charlestown-dam-1 charlestown-dam-3 charlestown-dam-5 charlestown-dam-0-sw charlestown-dam-1-sw charlestown-dam-3-sw charlestown-dam-5-sw)
  set downtown-dam-0 [203000000 137222222 55000000 7220000 7220000]
  set downtown-dam-1 [542000000 431333333 293000000 293000000 120000000]
  set downtown-dam-3 [2524000000 2318222222 2061000000 1608000000 1287000000]
  set downtown-dam-5 [3629000000 3398333333 3110000000 3035000000 2388000000]
  set downtown-dam-0-sw [0 0 0 0 0]
  set downtown-dam-1-sw [0 0 0 0 0]
  set downtown-dam-3-sw [0 0 0 0 0]
  set downtown-dam-5-sw [3629000000 3398333333 0 0 0]
  set downtown-dam-list (list downtown-dam-0 downtown-dam-1 downtown-dam-3 downtown-dam-5 downtown-dam-0-sw downtown-dam-1-sw downtown-dam-3-sw downtown-dam-5-sw)
  set eastboston-dam-0 [281000000 241888888 193000000 62000000 37370000]
  set eastboston-dam-1 [691000000 614555555 519000000 517000000 87000000]
  set eastboston-dam-3 [2104000000 2006222222 1884000000 1709000000 1527000000]
  set eastboston-dam-5 [2674000000 2456666666 2185000000 2009000000 1687000000]
  set eastboston-dam-0-sw [0 0 0 0 0]
  set eastboston-dam-1-sw [0 0 0 0 0]
  set eastboston-dam-3-sw [0 0 0 0 0]
  set eastboston-dam-5-sw [2674000000 2456666666 0 0 0]
  set eastboston-dam-list (list eastboston-dam-0 eastboston-dam-1 eastboston-dam-3 eastboston-dam-5 eastboston-dam-0-sw eastboston-dam-1-sw eastboston-dam-3-sw eastboston-dam-5-sw)
  set fenway-dam-0 [0 0 0 0 0]
  set fenway-dam-1 [3000000 3000000 3000000 3000000 3000000]
  set fenway-dam-3 [700000000 399586666 24070000 8030000 7030000]
  set fenway-dam-5 [2010000000 1836666666 1620000000 1416000000 863000000]
  set fenway-dam-0-sw [0 0 0 0 0]
  set fenway-dam-1-sw [0 0 0 0 0]
  set fenway-dam-3-sw [0 0 0 0 0]
  set fenway-dam-5-sw [2010000000 1836666666 0 0 0]
  set fenway-dam-list (list fenway-dam-0 fenway-dam-1 fenway-dam-3 fenway-dam-5 fenway-dam-0-sw fenway-dam-1-sw fenway-dam-3-sw fenway-dam-5-sw)
  set jamaicaplain-dam-0 [0 0 0 0 0]
  set jamaicaplain-dam-1 [0 0 0 0 0]
  set jamaicaplain-dam-3 [22000000 12222222 0 0 0]
  set jamaicaplain-dam-5 [229000000 187844444 136400000 93400000 30000000]
  set jamaicaplain-dam-0-sw [0 0 0 0 0]
  set jamaicaplain-dam-1-sw [0 0 0 0 0]
  set jamaicaplain-dam-3-sw [0 0 0 0 0]
  set jamaicaplain-dam-5-sw [229000000 187844444 0 0 0]
  set jamaicaplain-dam-list (list jamaicaplain-dam-0 jamaicaplain-dam-1 jamaicaplain-dam-3 jamaicaplain-dam-5 jamaicaplain-dam-0-sw jamaicaplain-dam-1-sw jamaicaplain-dam-3-sw jamaicaplain-dam-5-sw)
  set ndorchester-dam-0 [47000000 29226666 7010000 2000000 2000000]
  set ndorchester-dam-1 [293000000 225000000 140000000 139000000 7010000]
  set ndorchester-dam-3 [427000000 375000000 310000000 198000000 163000000]
  set ndorchester-dam-5 [815000000 709666666 578000000 494000000 270000000]
  set ndorchester-dam-0-sw [0 0 0 0 0]
  set ndorchester-dam-1-sw [0 0 0 0 0]
  set ndorchester-dam-3-sw [0 0 0 0 0]
  set ndorchester-dam-5-sw [815000000 709666666 0 0 0]
  set ndorchester-dam-list (list ndorchester-dam-0 ndorchester-dam-1 ndorchester-dam-3 ndorchester-dam-5 ndorchester-dam-0-sw ndorchester-dam-1-sw ndorchester-dam-3-sw ndorchester-dam-5-sw)
  set roxbury-dam-0 [0 0 0 0 0]
  set roxbury-dam-1 [0 0 0 0 0]
  set roxbury-dam-3 [441000000 327222222 185000000 57000000 39000000]
  set roxbury-dam-5 [1144000000 920888888 642000000 510000000 301000000]
  set roxbury-dam-0-sw [0 0 0 0 0]
  set roxbury-dam-1-sw [0 0 0 0 0]
  set roxbury-dam-3-sw [0 0 0 0 0]
  set roxbury-dam-5-sw [1144000000 920888888 0 0 0]
  set roxbury-dam-list (list roxbury-dam-0 roxbury-dam-1 roxbury-dam-3 roxbury-dam-5 roxbury-dam-0-sw roxbury-dam-1-sw roxbury-dam-3-sw roxbury-dam-5-sw)
  set sboston-dam-0 [598000000 457555555 282000000 100000000 99000000]
  set sboston-dam-1 [971000000 781666666 545000000 543000000 221000000]
  set sboston-dam-3 [1948000000 1824000000 1669000000 1431000000 1334000000]
  set sboston-dam-5 [2520000000 2312444444 2053000000 1853000000 1544000000]
  set sboston-dam-0-sw [0 0 0 0 0]
  set sboston-dam-1-sw [0 0 0 0 0]
  set sboston-dam-3-sw [0 0 0 0 0]
  set sboston-dam-5-sw [2520000000 2312444444 0 0 0]
  set sboston-dam-list (list sboston-dam-0 sboston-dam-1 sboston-dam-3 sboston-dam-5 sboston-dam-0-sw sboston-dam-1-sw sboston-dam-3-sw sboston-dam-5-sw)
  ;takes into account that sboston protects regions outside of just south boston that don't have seawall access (roxbury)
  set sboston-combined-dam-0 [598000000 457555555 282000000 100000000 99000000]
  set sboston-combined-dam-1 [971000000 781666666 545000000 543000000 221000000]
  set sboston-combined-dam-3 [3516000000 3108888888 2600000000 1959000000 1579260000]
  set sboston-combined-dam-5 [5492000000 4888888887 4135000000 3696000000 2801000000]
  set sboston-combined-dam-0-sw [0 0 0 0 0]
  set sboston-combined-dam-1-sw [0 0 0 0 0]
  set sboston-combined-dam-3-sw [0 0 0 0 0]
  set sboston-combined-dam-5-sw [5492000000 4888888887 0 0 0]
  set sboston-combined-dam-list (list sboston-combined-dam-0 sboston-combined-dam-1 sboston-combined-dam-3 sboston-combined-dam-5 sboston-combined-dam-0-sw sboston-combined-dam-1-sw sboston-combined-dam-3-sw sboston-combined-dam-5-sw)
  set sdorchester-dam-0 [65000000 42386666 14120000 12100000 10100000]
  set sdorchester-dam-1 [228000000 163111111 82000000 80000000 57000000]
  set sdorchester-dam-3 [510000000 467333333 414000000 355000000 285000000]
  set sdorchester-dam-5 [935000000 832333333 704000000 599000000 446000000]
  set sdorchester-dam-0-sw [0 0 0 0 0]
  set sdorchester-dam-1-sw [0 0 0 0 0]
  set sdorchester-dam-3-sw [0 0 0 0 0]
  set sdorchester-dam-5-sw [935000000 832333333 0 0 0]
  set sdorchester-dam-list (list sdorchester-dam-0 sdorchester-dam-1 sdorchester-dam-3 sdorchester-dam-5 sdorchester-dam-0-sw sdorchester-dam-1-sw sdorchester-dam-3-sw sdorchester-dam-5-sw)
  set southend-dam-0 [0 0 0 0 0]
  set southend-dam-1 [0 0 0 0 0]
  set southend-dam-3 [1127000000 957666666 746000000 471000000 206260000]
  set southend-dam-5 [1828000000 1655555555 1440000000 1333000000 956000000]
  set southend-dam-0-sw [0 0 0 0 0]
  set southend-dam-1-sw [0 0 0 0 0]
  set southend-dam-3-sw [0 0 0 0 0]
  set southend-dam-5 [1828000000 1655555555 0 0 0]
  set southend-dam-list (list southend-dam-0 southend-dam-1 southend-dam-3 southend-dam-5 southend-dam-0-sw southend-dam-1-sw southend-dam-3-sw southend-dam-5-sw)
  set ndorchester-combined-dam-0 [47000000 29226666 7010000 2000000 2000000]
  set ndorchester-combined-dam-1 [293000000 225000000 140000000 139000000 7010000]
  set ndorchester-combined-dam-3 [890000000 714444444 495000000 255000000 202000000]
  set ndorchester-combined-dam-5 [2188000000 1818399998 1356400000 1097400000 601000000]
  set ndorchester-combined-dam-0-sw [0 0 0 0 0]
  set ndorchester-combined-dam-1-sw [0 0 0 0 0]
  set ndorchester-combined-dam-3-sw [0 0 0 0 0]
  set ndorchester-combined-dam-5-sw [2188000000 1818399998 0 0 0]
  set ndorchester-combined-dam-list (list ndorchester-combined-dam-0 ndorchester-combined-dam-1 ndorchester-combined-dam-3 ndorchester-combined-dam-5 ndorchester-combined-dam-0-sw ndorchester-combined-dam-1-sw ndorchester-combined-dam-3-sw ndorchester-combined-dam-5-sw)
  set annual-expected-damage-boston-list-sw [0 0 0 0 0 0 0 0 0]
  set annual-expected-damage-boston-list [0 0 0 0 0 0 0 0 0]
  ;coastline is in order [Allston Backbay Charlestown Downtown EB Fenway N.Dorchester SBoston S.Dorchester]
  set coastline-length-list [14505 4146 16676 13842 73993 5428 20811 44647 20811]
  ;initialize no adaptations in boston
  set boston-adaptation-list ["none" "none" "none" "none" "none" "none" "none" "none" "none"]
  ;initialize no adaptation intention in boston
  set boston-adaptation-intention-list ["none" "none" "none" "none" "none" "none" "none" "none" "none"]
  set boston-crs-discount-list [0 0 0 0 0 0 0 0 0]
  ;set boston-seawall-cost-list [0 0 0 0 0 0 0 0 0]
  set boston-seawall-costs-avoided-list [0 0 0 0 0 0 0 0 0]
  set boston-seawall-cost-benefit-list [0 0 0 0 0 0 0 0 0]
  set boston-planned-adaptation-cost-list [0 0 0 0 0 0 0 0 0]
  set boston-planned-adaptation-cost-list-om [0 0 0 0 0 0 0 0 0]
  set boston-adaptation-costs-list [0 0 0 0 0 0 0 0 0]
  ;below is from the nocoop version, not sure if this is used any differnt from the top, but we can see
  set boston-total-adaptation-cost-list [0 0 0 0 0 0 0 0 0]
  ;set all damages to 0 for time step and total times
  set time-step-damage-allston 0
  set total-damage-allston 0
  set time-step-damage-backbay 0
  set total-damage-backbay 0
  set time-step-damage-charlestown 0
  set total-damage-charlestown 0
  set time-step-damage-downtown 0
  set total-damage-downtown 0
  set time-step-damage-eboston 0
  set total-damage-eboston 0
  set time-step-damage-fenway 0
  set total-damage-fenway 0
  set time-step-damage-ndorchester 0
  set total-damage-ndorchester 0
  set time-step-damage-sboston 0
  set total-damage-sboston 0
  set time-step-damage-sdorchester 0
  set total-damage-sdorchester 0
  ;set global lists for the mbta + boston o+m costs
  set boston-base-adaptation-cost-list [0 0 0 0 0 0 0 0 0]
  set boston-o-m-cost-list [0 0 0 0 0 0 0 0 0]
  set boston-o-m-cum-cost-list [0 0 0 0 0 0 0 0 0]
  set mbta-base-adaptation-cost-list [0 0 0 0 0 0 0 0 0 0 0]
  set mbta-o-m-cost-list [0 0 0 0 0 0 0 0 0 0 0]
  set mbta-o-m-cum-cost-list [0 0 0 0 0 0 0 0 0 0 0]
  set ra-base-adaptation-cost [0 0 0 0 0 0 0 0 0 0 0]
  set o-m-cost-cum-ra 0
  set o-m-cost-ra 0
  set seawall-cost-cooperative-boston-list [0 0 0 0 0 0 0 0 0]
  set seawall-cost-benefit-cooperative-boston-list [0 0 0 0 0 0 0 0 0]


  ;remove any turtles and plots that may have been lingering
  clear-turtles
  clear-all-plots
  ;set the start year as 2021
  set year 2021
  ;record the start year as 2021 (this stays constant throughout the model run)
  set year-start 2021
  ;create BOS airport agent
    ask n-of 1 patches with [airport? = "4126"][
    sprout-private-assets 1 [set color yellow
      set size 21
      ;assume no existing adaptation
      set adaptation "none"
      ;no desire to adapt
      set adaptation-intention "none"
      set shape "airplane"
      set name "BOS-air"
       ;estimate an approximate elevation (in this case of structures, not runways)
      set elevation 18.7
      ;assume no budent existing
      set available-budget 0
      ;assumes a very high annual budget- partly inspired by MassPort Climate Adaptation plans
      set annual-budget 50000000
      ;no sawall constructed
      set municipal-sw? False
      ;links the airport to a corresponding seawall segment
      set boston-sw-segment "east boston"
      set boston-sw-segment-num 4
      ;makesure we start with no o-m cost
      set o-m-cost 0
      set o-m-cost-cum 0]
  ]
  ;create food distribution agent
  ask n-of 1 patches with [town = "CHELSEA"][
  sprout-private-assets 1 [set color yellow
      set shape "truck"
      set size 20
      set name "food dist"
      set adaptation "none"
      set adaptation-intention "none"
      set elevation 22
      set available-budget 0
      set annual-budget 50000000
      set municipal-sw? False
      set boston-sw-segment "charleston"
      set boston-sw-segment-num 2
    ;makesure we start with no o-m cost
      set o-m-cost 0
      set o-m-cost-cum 0]
  ]
    ;create MBTA agent
    ask n-of 1 patches with [town = "BOSTON"][
    ;damages come from Michael Martello Thesis
    sprout-MBTA-agents 1 [set color violet
      set size 20
      set shape "bus"
      set mbta-aep-list [.001 .005 .01 .067 .1]
      set adaptation "none"
      set adaptation-intention "none"
      set mbta-adaptation-list ["none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none"]
      set mbta-adaptation-intention-list ["none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none"]
      set mbta-coop-construct-list [False False False False False False False False False False False]
      set mbta-adaptation-cost-list [0 0 0 0 0 0 0 0 0 0 0]
      set mbta-benefit-cost-ratio-list [0 0 0 0 0 0 0 0 0 0 0]
      set mbta-planned-adaptation-cost-list [0 0 0 0 0 0 0 0 0 0 0]
      set mbta-cost-proportion-list [0.025 0.025 0.05 0.05 0.1 0.25 0.25 0.05 0.025 0.15 0.025]
      set mbta-total-adaptation-cost-list [0 0 0 0 0 0 0 0 0 0 0]
      set mbta-permit-delay-list [0 0 0 0 0 0 0 0 0 0 0]
      ;below is a super estimate
      set dam-0 [8964444444 70000000 11500000 0 0 ]
      set dam-0.23 [1500000000 864444444 70000000 11500000 0 ]
      set dam-1.41  [5000000000 3266666666 1100000000 900000000 500000000]
      set dam-2.59  [7000000000 6333333333 5500000000 2600000000 2500000000]
      set dam-4.41  [10000000000 9644444444 9200000000 9000000000 8000000000]
      set dam-sw-0 [0 0 0 0 0]
      set dam-sw-0.23 [0 0 0 0 0]
      set dam-sw-1.41 [0 0 0 0 0]
      set dam-sw-2.59 [0 0 0 0 0]
      set dam-sw-4.41 [10000000000 0 0 0 0]
      set available-budget 0
      set annual-budget 40000000 ;twice estimate?
      ;makesure we start with no o-m cost
      set o-m-cost 0
      set o-m-cost-cum 0
      ]
]
  ask n-of 1 patches with [town = "LYNN"] [
    sprout-municipalities 1 [
  ; set north-shore-characteristics
      ;Damage curves for municipalities and Boston Neighborhoods from Kirshen et al Outer Harbor Barrier assessment (https://bpb-us-w2.wpmucdn.com/blogs.umb.edu/dist/5/3685/files/2018/07/umb_rpt_BosHarbor_5.18_15-optimized-2dxu5cr.pdf)
  set color red
  set size 18
  set shape "person"
  set name "north-shore"
  set label "north-shore"
  set coastline 54530
  set dam-0 [176000000 153333333 125000000 41000000 34000000]
  set dam-1 [272000000 249777777 222000000 181000000 91000000]
  set dam-3 [636000000 599555555 554000000 500000000 421000000]
  set dam-5 [827000000 777666666 716000000 670000000 610000000]
  set dam-0-sw [0 0 0 0 0]
  set dam-1-sw [0 0 0 0 0]
  set dam-3-sw [0 0 0 0 0]
  set dam-5-sw [827000000 777666666 0 0 0]
  set available-budget 0
  set annual-budget 560000
  set adaptation "none"
  set adaptation-intention "none"
      ;makesure we start with no o-m cost
      set o-m-cost 0
      set o-m-cost-cum 0
  ]]

  ask n-of 1 patches with [town = "BOSTON"] [
    sprout-municipalities 1 [set color red
  set size 18
  set shape "person"
  set name "boston"
  set label "boston"
  set coastline 156927
  set dam-0 [1278000000 972280000 590130000 206700000 169990000]
  set dam-1 [2980000000 2416000000 1711000000 1697000000 524130000]
  set dam-3 [11103000000 9713306666 7976190000 6387250000 5776510000]
  set dam-5 [18821000000 17053177777 14843400000 13398400000 9927000000]
  set dam-0-sw [0 0 0 0 0]
  set dam-1-sw [0 0 0 0 0]
  set dam-3-sw [0 0 0 0 0]
  set dam-5-sw [18821000000 17053177777 0 0 0]
  set available-budget 0
  set annual-budget 20000000
      ;makesure we start with no o-m cost
      set o-m-cost 0
      set o-m-cost-cum 0
  ]]

  ask n-of 1 patches with [town = "BRAINTREE"] [
    sprout-municipalities 1 [set color red
  set size 18
  set shape "person"
  set name "south-shore"
  set label "south-shore"
  set coastline 105324
  set dam-0 [754000000 638444444 494000000 402000000 372000000]
  set dam-1 [1057000000 851222222 594000000 567000000 490000000]
  set dam-3 [1952000000 1788000000 1583000000 1396000000 1171000000]
  set dam-5 [2483000000 2320777777 2118000000 2029000000 1737000000]
  set dam-0-sw [0 0 0 0 0]
  set dam-1-sw [0 0 0 0 0]
  set dam-3-sw [0 0 0 0 0]
  set dam-5-sw [2483000000 2320777777 0 0 0]
  set available-budget 0
  set annual-budget 2720000
      set adaptation "none"
  set adaptation-intention "none"
      ;makesure we start with no o-m cost
      set o-m-cost 0
      set o-m-cost-cum 0
  ]]
ask n-of 3 patches with [town = "LYNN"] [
    sprout-property_owners 1 [set color violet
  set sector "homeowners"
  set max-flood-insurance-coverage 3500000
  set property_value 1000000
  set perimeter 200
  set size 18
  set shape "house"
  set elevation 10
  set adaptation "none"
  set adaptation-intention "none"
  ;set elevation 0
  set total-proj-damage 0
  set available-budget 0
      ;Assumption: annual budget for climate adaptation is 10% proeprty value
  set annual-budget-percent 0.1
  set dev-region "north-shore"
  set municipal-sw? False
  ;makesure we start with no o-m cost
      set o-m-cost 0
      set o-m-cost-cum 0]]

  ask n-of 3 patches with [town = "BOSTON"] [
    sprout-property_owners 1 [set color violet
  set sector "homeowners"
      set max-flood-insurance-coverage 3500000
      set property_value 1000000
  set perimeter 200
  set size 18
  set shape "house"
  set adaptation "none"
  set adaptation-intention "none"
  set elevation 10
  set available-budget 0
  set annual-budget-percent 0.1
  set dev-region "boston"
  set municipal-sw? False
  set boston-sw-segment "downtown"
  set boston-sw-segment-num 3
  ;makesure we start with no o-m cost
      set o-m-cost 0
      set o-m-cost-cum 0]]
ask n-of 3 patches with [town = "BRAINTREE"] [
    sprout-property_owners 1 [set color violet
  set sector "homeowners"
      set max-flood-insurance-coverage 3500000
      set property_value 1000000
  set perimeter 200
  set size 18
  set shape "house"
  set elevation 10
  set adaptation "none"
  set adaptation-intention "none"
  set available-budget 0
  set annual-budget-percent 0.1
  set dev-region "south-shore"
  set municipal-sw? False
  ;makesure we start with no o-m cost
      set o-m-cost 0
      set o-m-cost-cum 0]]

  ask n-of 3 patches with [town = "LYNN"] [
    sprout-property_owners 1 [set color blue
  set sector "commercial"
      set max-flood-insurance-coverage 1000000
      set property_value 8000000
  set size 18
  set perimeter 600
  set shape "house two story"
  set elevation 10
  set adaptation "none"
  set adaptation-intention "none"
  ;set elevation 0
  set total-proj-damage 0
  set available-budget 0
      ;Assumption: annual budget for climate adaptation is 10% proeprty value
  set annual-budget-percent 0.1
  set dev-region "north-shore"
  set municipal-sw? False
  ;makesure we start with no o-m cost
      set o-m-cost 0
      set o-m-cost-cum 0]]

  ask n-of 3 patches with [town = "BOSTON"] [
    sprout-property_owners 1 [set color blue
  set sector "commercial"
      set max-flood-insurance-coverage 1000000
      set property_value 8000000
  set perimeter 600
  set size 18
  set shape "house two story"
  set adaptation "none"
  set adaptation-intention "none"
  set elevation 10
  set available-budget 0
  set annual-budget-percent 0.1
  set dev-region "boston"
  set municipal-sw? False
  set boston-sw-segment "downtown"
  set boston-sw-segment-num 3
  ;makesure we start with no o-m cost
      set o-m-cost 0
      set o-m-cost-cum 0]]

ask n-of 3 patches with [town = "BRAINTREE"] [
    sprout-property_owners 1 [set color blue
  set sector "commercial"
      set max-flood-insurance-coverage 1000000
      set property_value 8000000
  set perimeter 600
  set size 18
  set shape "house two story"
  set elevation 10
  set adaptation "none"
  set adaptation-intention "none"
  set available-budget 0
  set annual-budget-percent 0.1
  set dev-region "south-shore"
  set municipal-sw? False
  ;makesure we start with no o-m cost
      set o-m-cost 0
      set o-m-cost-cum 0]]

  ;this creates linkages between agents depending on what is running (easy to change)
  if model-version = "no cooperation" [
    set include-linkages False]
  if model-version = "voluntary cooperation" [
    set include-linkages True
    generate-linkages]
  if model-version = "regional authority" [
    set include-linkages False]

  ask turtles[
    set adaptation-count 0
  ]

   if model-version = "regional authority" [
    set ra-total-adaptation-cost 0
    set ra-adaptation-cost-list [0 0 0 0 0 0 0 0 0 0 0]
    set ra-adaptation-intention-list (list "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none")
    set ra-adaptation-list (list "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none")
    ask n-of 1 patches[
      sprout-regional-authorities 1[
        ;makesure we start with no o-m cost
        set color red
        set size 30
        set shape "person"
        set mun-aep-list [0.001 0.005 0.01 0.02 0.1]
        set flood-memory [8.66000028 8.49000027 7.24000023 7.27900023 7.84000025 6.93100022 7.33200023 7.13100023 6.55100021 7.29500023 7.31800023 7.92500025 7.93500025 7.07900023 8.11900026 8.05700026 8.25000026 7.16800023 7.38100024 8.14200026 7.56500024 8.06300026 7.50900024 8.28300027 8.12600026 7.44300024 7.67600025 9.5170003  7.65000024 7.67600025]
  ]
    ]

  ]

ask municipalities [
    ;assumes damage at year 0 = 0
    set total-damage 0
    ;no plan to adapt in year 1
    set adaptation-intention "none"
    ;used to calculate area under curve for annual expected damages
    set mun-aep-list [0.001 0.005 0.01 0.02 0.1]
    ;no existing adaptation -> no existing adaptation costs
    set total-adaptation-cost 0
    ;no existing adaptation plan -> no planned existing adaptation costs
    set planned-adaptation-cost 0
    ;no adaptation cost this time step
    set adaptation-cost 0
    ;no damages exist before a flood
    set damage-time-step 0
    ;no seawalls exist, therefore no crs discount
    set crs-discount 0
    ;this measures the delay from planned adaptation to implementing due to permitting delays
    set permit-delay-count 0
    ;used only in vc to tell toehr agents to wait
    set wait-for-permit False
    set seawall-cost-cooperative 0
    set seawall-cost-benefit-cooperative 0
  ]
ask property_owners [

    set permit-delay-count 0
    ;code below determines if the property_owner requires mandatory insurance
    set num (random 100)
    set ins-ben-cost 0
    if insurance-module? = false[
    ;set mandatory-insurance false to have no agents assumed to be forced to pay - indicates high hazard/flood area according to FEMA + is a mortgage condition - this can also be used to turn off insurance module
      set mandatory-insurance? false]
    if insurance-module? = true[
      ;code below preps to use insurance module
    ifelse sector = "homeowners" [
    set premium 1482
        set premium_2022 2541]
    [;sector = "commercial"
        set premium 4224
        set premium_2022 7242]
    set insurance-damages-covered 0
    set insurance-premium-total 0
    set damages-paid-property_owner 0
    set damages-paid-property_owner-total 0
    set damages-paid-insurance 0
    set damages-paid-insurance-total 0
    ;note in theory this should change to reflect SLR over time, but for now can be static
    ifelse elevation < 9.58 [
      ifelse num <= 43 [
        set mandatory-insurance? true]
      [set mandatory-insurance? false]
    ]
    [set mandatory-insurance? false]
    ;code below initializes so that some agents begin with insurance- random process because this is not important for the actual results but for troubleshooting
    let val random 10
    ifelse val < 5 [
      set insurance? true]
    [set insurance? false]
    set deductible .10
    set damages-paid 0
     set damages-paid-total 0]
    ;sets zero existing damage
    set damage-time-step 0
    set total-damage 0
    ;used to calculate area under damage furce
    set dev-aep-list [.001 .002 .005 .01 .02 .05 .1 .2 .25 .8]
  set total-adaptation-cost 0
    set planned-adaptation-cost 0
    set adaptation-cost 0
  ]
ask MBTA-agents[
    set permit-delay-count 0
    set damage-time-step 0
    set total-damage 0
  set total-adaptation-cost 0
    set planned-adaptation-cost 0
    set adaptation-cost 0]
ask private-assets[
    set permit-delay-count 0
    set damage-time-step 0
    set total-damage 0
  set total-adaptation-cost 0
    set planned-adaptation-cost 0
    set adaptation-cost 0]
ask links[
    set cumulative-damage 0]
  ;setup-python
  set ra-annual-budget sum ([annual-budget] of municipalities) + sum ([annual-budget] of mbta-agents) + sum ([annual-budget] of private-assets)

  ;open the files according to sea level rise if the method = behavior space
  if Method = "behavior space" [
     ;1st two not done yeat
  if storm-surge-method = "random" [
    if sea-level-rise = "no trend" [
      file-close-all
      file-open "slr_long_flood.csv"
      set slr-array csv:from-file "slr_long_flood.csv"
    ]
    if sea-level-rise = "fit trend" [
      file-close-all
      file-open "slr_long_flood.csv"
      set slr-array csv:from-file "slr_long_flood.csv"
    ]
    if sea-level-rise = 0 [
      file-close-all
      file-open "storm_surge_pattern_slr_0.csv"
      set slr-array csv:from-file "storm_surge_pattern_slr_0.csv"
    ]
    if sea-level-rise = 1 [
      file-close-all
      file-open "storm_surge_pattern_slr_1.csv"
      set slr-array csv:from-file "storm_surge_pattern_slr_1.csv"
    ]
    if sea-level-rise = 3 [
      file-close-all
      file-open "storm_surge_pattern_slr_3.csv"
      set slr-array csv:from-file "storm_surge_pattern_slr_3.csv"
    ]
    if sea-level-rise = 5 [
      file-close-all
      file-open "storm_surge_pattern_slr_5.csv"
      set slr-array csv:from-file "storm_surge_pattern_slr_5.csv"
    ]
  ]
  ]
end


to setup-python
  ;this code preps python module
  set year 2021
  set year-start 2021
  clear-output
  py:setup py:python
  py:run "import sys"
  py:run "from scipy import stats"
  py:run "from scipy import interpolate"
  py:run "from scipy import integrate"
  py:run "from scipy.stats import gumbel_r"
  py:set "multiplier" multiplier_storms_annual_mean
  ;this allows for the changing distribution over time- shifts the distribution parameeters into python terms
(py:run "new_loc = 6.438656963108146"
      "new_scale = 0.44264718007554776"
      "new_mu = 6.69415"
      "new_var= .3223"
      "new_stdev = new_var ** 0.5")


end


to generate-linkages
  ;creates illustrative linkages of the agents that would cooperate on a shared seawall - only applies visually
  if include-linkages = True[
    ;MBTA links to all other agents since all gaents benefit
    set link-value 0.01
    ask mbta-agents [
      create-exchanges-to other turtles [
      set color red
      set node-damages 0
      set end-damages 0
      set ratio-source-end-damages 0
      set other-end-expected-damages 0]
  ]
    ask property_owners [
      ;property_owners all connect to municipality
      let region-test dev-region
      create-exchanges-to municipalities with [name = region-test] [
      set color red
      set node-damages 0
      set end-damages 0
      set ratio-source-end-damages 0
      set other-end-expected-damages 0]
  ]
     ask private-assets[
      ;private assets also link to their municipality
      create-exchanges-to municipalities with [name = "boston"] [
      set color red
      set node-damages 0
      set end-damages 0
      set ratio-source-end-damages 0
      set other-end-expected-damages 0]
  ]
  ]
end

to go

  if model-version = "no adaptation" [
    ;must generate floods
  if Method = "normal" [
      generate-flood-gev]
  if Method = "behavior space"[
    generate-flood-from-csv]
    ;function to calculate damage
  calculate-damage
    output-print(flood-height)
    output-print([damage-time-step] of municipalities with [name = "south-shore"])
    output-print([damage-time-step] of municipalities with [name = "boston"])
  ;ask everybody to update damages to include the current year
   ask municipalities [
      set total-damage total-damage + damage-time-step]
   ask private-assets[
      set total-damage total-damage + damage-time-step]
   ask MBTA-agents[
      set total-damage total-damage + damage-time-step]
   ask property_owners[
      set total-damage total-damage + damage-time-step]
   metrics
    ;no adaptation so no need for adaptation functions
  ]


  if model-version = "no cooperation"[
    ;indicates setting premium function if insurance is on
    if insurance-module? = true [
      calculate-new-premium]
    ;calculates flood
  if Method = "normal" [
      generate-flood-gev]
  if Method = "behavior space"[
    generate-flood-from-csv]
    ;calcualtes damage
  calculate-damage
  ;ask everybody to update damage
   ask municipalities [
      set total-damage total-damage + damage-time-step]
   ask private-assets[
      set total-damage total-damage + damage-time-step]
   ask MBTA-agents[
      set total-damage total-damage + damage-time-step]
   ask property_owners[
      set total-damage total-damage + damage-time-step]
  ;all agents undergo benefit-cost assessment
  adaptation-decision
  ;agents assess whether or not they can implement an action
  adaptation-implementation
  ;track o-m-costs
  add_o_m_costs
  ;crs is updated if seawalls are constructed
  set-crs-discount
  ;updates budget
  ask municipalities[
    set an-budget-discount annual-budget / ((1 + discount) ^ (year - 2021))
    set available-budget available-budget + an-budget-discount]
  ask MBTA-agents[
    set an-budget-discount annual-budget / ((1 + discount) ^ (year - 2021))
    set available-budget available-budget + an-budget-discount]
  ask property_owners[
    set an-budget-discount (annual-budget-percent * property_value) / ((1 + discount) ^ (year - 2021))
    set available-budget available-budget + an-budget-discount]
  ask private-assets[
    set an-budget-discount annual-budget / ((1 + discount) ^ (year - 2021))
    set available-budget available-budget + an-budget-discount]
  metrics
  ]

  if model-version = "voluntary cooperation" [
    set vc-total-adaptation-costs 0
    calculate-new-premium
    if Method = "normal" [
      generate-flood-gev]
   if Method = "behavior space"[
    generate-flood-from-csv]
    calculate-damage
    ;add-discount-budget
   ask municipalities [
      set total-damage total-damage + damage-time-step]
   ask private-assets[
      set total-damage total-damage + damage-time-step]
   ask MBTA-agents[
      set total-damage total-damage + damage-time-step]
   ask property_owners[
      set total-damage total-damage + damage-time-step]
   adaptation-decision-voluntary-cooperation
   set-crs-discount
   updated-vc-11-28
    ;track o-m-costs
  add_o_m_costs
    ask municipalities[
    set an-budget-discount annual-budget / ((1 + discount) ^ (year - 2021))
    set available-budget available-budget + an-budget-discount]
  ask MBTA-agents[
    set an-budget-discount annual-budget / ((1 + discount) ^ (year - 2021))
    set available-budget available-budget + an-budget-discount]
  ask property_owners[
    set an-budget-discount (annual-budget-percent * property_value) / ((1 + discount) ^ (year - 2021))
    set available-budget available-budget + an-budget-discount]
  ask private-assets[
    set an-budget-discount annual-budget / ((1 + discount) ^ (year - 2021))
    set available-budget available-budget + an-budget-discount]
   metrics
  ]



    if model-version = "regional authority" [
    set  ra-benefit-cost-ratio-list [0 0 0 0 0 0 0 0 0 0 0]
    if insurance-module? = true [
      calculate-new-premium]
    if Method = "normal" [
      generate-flood-gev]
    if Method = "behavior space"[
    generate-flood-from-csv]
    calculate-damage
    ;add-discount-budget
   ask municipalities [
      set total-damage total-damage + damage-time-step]
   ask private-assets[
      set total-damage total-damage + damage-time-step]
   ask MBTA-agents[
      set total-damage total-damage + damage-time-step]
   ask property_owners[
      set total-damage total-damage + damage-time-step]
   adaptation-decision-regional-authority
   set-crs-discount
   adaptation-implementation-regional-authority
    ;track o-m-costs
  add_o_m_costs
   ask municipalities[
    set an-budget-discount annual-budget / ((1 + discount) ^ (year - 2021))
    set available-budget available-budget + an-budget-discount]
  ask MBTA-agents[
    set an-budget-discount annual-budget / ((1 + discount) ^ (year - 2021))
    set available-budget available-budget + an-budget-discount]
  ask property_owners[
    set an-budget-discount (annual-budget-percent * property_value) / ((1 + discount) ^ (year - 2021))
    set available-budget available-budget + an-budget-discount]
  ask private-assets[
    set an-budget-discount annual-budget / ((1 + discount) ^ (year - 2021))
    set available-budget available-budget + an-budget-discount]
    ;setting total budget = sum agents individual budget
   set ra-an-budget-discount ra-annual-budget / ((1 + discount) ^ (year - 2021))
   set ra-available-budget ra-available-budget + ra-an-budget-discount
   metrics
  ]

  ;this applies to each process
  set year year + 1
  tick ;do we want to model annual? Is that easiest based on our data?
end

to generate-flood-from-csv
  let storm-surge-pattern item (flood-pattern - 1) slr-array
  let year-flood ticks
  set flood-height item (year-flood + 1) storm-surge-pattern
end

to generate-flood-gev
  ;code used to generate new storms in each time step, not to use pre-generated data
  ;code below is if there is no SLR trend (data was intentionally detrended, then we project)
  if storm-surge-method = "random" [
  if sea-level-rise = "no trend"[
    py:set "multiplier" multiplier_storms_annual_mean
    (py:run
      "sample= gumbel_r.rvs(new_loc, new_scale, size=1,random_state=None)[0]"
      "sample = sample + (.0123 * (2021-1921))"
      "new_mu = new_mu * multiplier"
      "new_stdev = new_stdev * multiplier"
      "new_var = new_stdev ** 2"
      "new_scale = ((6*new_var)/(3.14159265**2))**0.5"
      "new_loc = new_mu - (.5772 * new_scale)")
    set flood-height py:runresult "sample"
  ]

  if sea-level-rise = "fit trend" [
    ;builds on trend based on historical data
    py:set "multiplier" multiplier_storms_annual_mean
    (py:run
      "sample= gumbel_r.rvs(new_loc, new_scale, size=1,random_state=None)[0]"
      "sample = sample + (.0123 * (2021-1921))"
      "new_mu = new_mu * multiplier"
      "new_stdev = new_stdev * multiplier"
      "new_var = new_stdev ** 2"
      "new_scale = ((6*new_var)/(3.14159265**2))**0.5"
      "new_loc = new_mu - (.5772 * new_scale)")
    let flood-height-step1 py:runresult "sample"
    set flood-height flood-height-step1 + ((year - 2021) * 0.0123)
    set flood-height flood-height
  ]

    if (sea-level-rise = 0) or (sea-level-rise = 1) or (sea-level-rise = 3) or (sea-level-rise = 5) [
      ;sets python variables from netlogo ones and then runs with the python engine
    py:set "multiplier" multiplier_storms_annual_mean
    (py:run
      "sample= gumbel_r.rvs(new_loc, new_scale, size=1,random_state=None)[0]"
      ;add trend back in from 1921 to equalize starting point to 2021
      "sample = sample + (.0123 * (2021-1921))"
        ;adjust distribution for any storm intensification
      "new_mu = new_mu * multiplier"
      "new_stdev = new_stdev * multiplier"
      "new_var = new_stdev ** 2"
      "new_scale = ((6*new_var)/(3.14159265**2))**0.5"
      "new_loc = new_mu - (.5772 * new_scale)")
    let flood-height-step1 py:runresult "sample"
    ;7.825 is the heigh of the fit distribution in 2021
    set flood-height flood-height-step1 + (((sea-level-rise) / 80) * (year - 2021))
    set flood-height flood-height
    ]

  ]

  ;method below ensures that there is no extreme storm ever occurring
    if storm-surge-method = "no extreme" [
    let avg_storm 7
    let thousand_year 10.95
      let base_storm avg_storm
      set flood-height base_storm + (((sea-level-rise) / 80) * (year - 2021))

  ]

  ;ensures one thousand year storm occurs in 2050
  if storm-surge-method = "1 extreme" [
    let avg_storm 7
    let thousand_year 10.95
      ifelse year != 2050 [
      let base_storm avg_storm
        set flood-height base_storm + (((sea-level-rise) / 80) * (year - 2021))]
      [let base_storm thousand_year
        set flood-height base_storm + (((sea-level-rise) / 80) * (year - 2021))]
  ]

  ;ensures one thousand-year storm in 2025 and one in 2075
   if storm-surge-method = "2 extreme" [
    let avg_storm 7
    let thousand_year 10.95
      ifelse year != 2025 and year != 2075[
      let base_storm avg_storm
        set flood-height base_storm + (((sea-level-rise) / 80) * (year - 2021))]
      [let base_storm thousand_year
        set flood-height base_storm + (((sea-level-rise) / 80) * (year - 2021))]
  ]
end

to calculate-new-premium
  ;this is before risk-rating 2.0 goes into effect
  ask property_owners [
    ifelse year < 2022 [
      ;gives average cost to all properties, unsure how these were set in the past so is an assumption for the first two years
      ifelse sector = "homeowners" [
    set premium 1482]
    [;sector = "commercial"
        set premium 4224
    ]
    ]
    [;complete is year is 2022+
      ;preps python function
      setup-property_owner-python
    py:set "year" year
    ;sets python premium variable to the premium from last year
    py:set "premium" premium
      ;updates so this value is now saved as the 'old' premium
    py:set "old_premium" premium
      ;elevation impacts risk -> is also loaded into python
    py:set "elevation" elevation
           (py:run
        ;projects expected damage
            "rise_per_year = slr_proj/100"
            "total_rise = rise_per_year * (year - 2000)"
            "annual_proj_damage = []"
            "proj_list_wout_discount = []"
            "slr_fit = [x + total_rise for x in slr_zero]"
            "percent_damage_list_for_aep = []"
            "for j in range(0, len(slr_fit)):"
            "   inundation = slr_fit[j] - elevation"
            "   if inundation <= 0:"
            "      damage_val = 0"
            "   else:"
            "      damage_val = (.0001826*inundation**3) - (.00511655*inundation**2) + (.0745843*inundation) - .00078322"
            "   percent_damage_list_for_aep.append(damage_val)"
            "   aep_damage_list= [property_value * x for x in percent_damage_list_for_aep]"
            "area=integrate.trapezoid(aep_damage_list, x= AEP_list)"
            "annual_damage= area/((1 + discount) ** (year-2021))"
        ;if in SFHA, ratio of damages that is incorporated in the premium is higher than not in the hazard area
            "if elevation < 9.58:"
            "   ratio = 1"
            "else:"
            "    ratio = 1"
        ;the new premium is set based on that damage * ratio
            "premium_adjust = annual_damage * ratio"
        ;max 18% increase in a year so this is capped
            "eighteen = premium * 1.18"
            "if eighteen < premium_adjust:"
            "    premium = eighteen"
            "else:"
            "    premium = premium_adjust"
    )
    set premium py:runresult "premium"
    if premium < 100 [
        set premium 100]
    ]
  ]

end

;Functions below calculate damage based on the annual flood height
;Curves are fitted from damages calculated in Feasibility Study for Outer Harber Barrier as Shown in the ODD Protocol

to calculate-damage-allston
  ;damage curves taken from python notebook fitting other damages
  ifelse neigh-adapt = "seawall" [
    ifelse flood-height < municipal-sw-height [
      set time-step-damage-allston 0]
    [set time-step-damage-allston ((12823878.7 * (flood-height ^ 2)) + (-225286309 * flood-height) + 849733092)
    ]
  ]
  [ifelse flood-height < 11.95[
    set time-step-damage-allston 0]
    [
      set time-step-damage-allston ((12823878.7 * (flood-height ^ 2)) + (-225286309 * flood-height) + 849733092)]
  ]
  if time-step-damage-allston < 0 [
    set time-step-damage-allston 0]
  set total-damage-allston total-damage-allston + time-step-damage-allston
end

to calculate-damage-backbay
    ifelse neigh-adapt = "seawall" [
    ifelse flood-height < municipal-sw-height [
      set time-step-damage-backbay 0]
    [set time-step-damage-backbay ((-11488756 * (flood-height ^ 2)) + (754140427 * flood-height) - 7453875990)
    ]
  ]
  [ifelse flood-height < 11.95[
    set time-step-damage-backbay 0]
    [
      set time-step-damage-backbay ((-11488756 * (flood-height ^ 2)) + (754140427 * flood-height) - 7453875990)]
  ]
  if time-step-damage-backbay < 0 [
    set time-step-damage-backbay 0]
  set total-damage-backbay total-damage-backbay + time-step-damage-backbay
end

to calculate-damage-charlestown
     ifelse neigh-adapt = "seawall" [
    ifelse flood-height < municipal-sw-height [
      set time-step-damage-charlestown 0]
    [set time-step-damage-charlestown ((5359715.81 * (flood-height ^ 2)) + (9448382.90 * flood-height) - 513525136)
    ]

  ]
  [set time-step-damage-charlestown ((5359715.81 * (flood-height ^ 2)) + (9448382.90 * flood-height) - 513525136)]
  if time-step-damage-charlestown < 0 [
    set time-step-damage-charlestown 0]
  set total-damage-charlestown total-damage-charlestown + time-step-damage-charlestown
end

to calculate-damage-downtown
   ifelse neigh-adapt = "seawall" [
    ifelse flood-height < municipal-sw-height [
      set time-step-damage-downtown 0]
    [set time-step-damage-downtown ((37060418.4 * (flood-height ^ 2)) + (-328847126 * flood-height) - 128737070)
    ]
  ]
  [set time-step-damage-downtown ((37060418.4 * (flood-height ^ 2)) + (-328847126 * flood-height) - 128737070)
  ]
  if time-step-damage-downtown < 0 [
    set time-step-damage-downtown 0]
  set total-damage-downtown total-damage-downtown + time-step-damage-downtown
end

to calculate-damage-eastboston
  ifelse neigh-adapt = "seawall" [
    ifelse flood-height < municipal-sw-height [
      set time-step-damage-eboston 0]
    [set time-step-damage-eboston ((1588969.24 * (flood-height ^ 2)) + (355971842 * flood-height) - 3290961950)
    ]
  ]
  [set time-step-damage-eboston ((1588969.24 * (flood-height ^ 2)) + (355971842 * flood-height) - 3290961950)]
  if time-step-damage-eboston <= 0 [
    set time-step-damage-eboston 0]
  set total-damage-eboston total-damage-eboston + time-step-damage-eboston

end

to calculate-damage-fenway
   ifelse neigh-adapt = "seawall" [
    ifelse flood-height < municipal-sw-height [
      set time-step-damage-fenway 0]
    [set time-step-damage-fenway (( 58689408.7 * (flood-height ^ 2)) + (-1106842340 * flood-height) - 4959202070)
    ]
  ]
  [ifelse flood-height < 10.95[
    set time-step-damage-fenway 0]
    [
      set time-step-damage-fenway (( 58689408.7 * (flood-height ^ 2)) + (-1106842340 * flood-height) - 4959202070)]
  ]
  if time-step-damage-fenway < 0 [
    set time-step-damage-fenway 0]
  set total-damage-fenway total-damage-fenway + time-step-damage-fenway

end

to calculate-damage-ndorchester
  ifelse neigh-adapt = "seawall" [
    ifelse flood-height < municipal-sw-height [
      set time-step-damage-ndorchester 0]
    [set time-step-damage-ndorchester ((4063317.82 * (flood-height ^ 3)) + (-94120657.4 * (flood-height ^ 2)) + (722578347 * flood-height) - 1832067600)
    ]
  ]
  [set time-step-damage-ndorchester ((4063317.82 * (flood-height ^ 3)) + (-94120657.4 * (flood-height ^ 2)) + (722578347 * flood-height) - 1832067600)]
  if time-step-damage-ndorchester < 0 [
    set time-step-damage-ndorchester 0]
  set total-damage-ndorchester total-damage-ndorchester + time-step-damage-ndorchester
end

to calculate-damage-sboston
    ifelse neigh-adapt = "seawall" [
    ifelse flood-height < municipal-sw-height [
      set time-step-damage-sboston 0]
    [set time-step-damage-sboston ((72584024.5 * (flood-height ^ 2)) + (-995243174 * flood-height) + 3155029260)
    ]
  ]
  [set time-step-damage-sboston ((72584024.5 * (flood-height ^ 2)) + (-995243174 * flood-height) + 3155029260)]
  if time-step-damage-sboston < 0 [
    set time-step-damage-sboston 0]
  set total-damage-sboston total-damage-sboston + time-step-damage-sboston
end

to calculate-damage-sdorchester
   ifelse neigh-adapt = "seawall" [
    ifelse flood-height < municipal-sw-height [
      set time-step-damage-sdorchester 0]
    [set time-step-damage-sdorchester ((12615110.8 * (flood-height ^ 2)) + (-178159082 * flood-height) + 591614661)
    ]
  ]
  [set time-step-damage-sdorchester ((12615110.8 * (flood-height ^ 2)) + (-178159082 * flood-height) + 591614661)]
  if time-step-damage-sdorchester < 0 [
    set time-step-damage-sdorchester 0]
  set total-damage-sdorchester total-damage-sdorchester + time-step-damage-sdorchester
end


to calculate-damage-boston
  ;boston-adaptation-list is damages according to time setp
  ;neighborhoods are in order ["allston" "backbay" "charlestown" "downtown" "east boston" "fenway" "northdorchester" "south dorchester" "south boston"]
  ;pos is used as an item identifier

  set pos 0
  foreach boston-adaptation-list [
    ;set neigh-adapt to be item i in the boston adaptation list, so it will be set for each neighborhood
    [x] -> set neigh-adapt x
    ;according to the neighborhood, do the calculation
    if pos =  0 [calculate-damage-allston]
    if pos = 1 [calculate-damage-backbay]
    if pos = 2 [calculate-damage-charlestown]
    if pos = 3 [calculate-damage-downtown]
    if pos = 4 [calculate-damage-eastboston]
    if pos = 5 [calculate-damage-fenway]
    if pos = 6 [calculate-damage-ndorchester]
    if pos = 7 [calculate-damage-sdorchester]
    if pos = 8 [calculate-damage-sboston]
    set pos pos + 1
  ]
  ;track each of the damages individually and cumulatively
 set boston-time-step-damages-list (list time-step-damage-allston time-step-damage-backbay time-step-damage-charlestown time-step-damage-downtown time-step-damage-eboston time-step-damage-fenway time-step-damage-ndorchester time-step-damage-sboston time-step-damage-sdorchester)
 set boston-total-damages-list (list total-damage-allston total-damage-backbay total-damage-charlestown total-damage-downtown total-damage-eboston total-damage-fenway total-damage-ndorchester total-damage-sboston total-damage-sdorchester)
 set damage-time-step (time-step-damage-allston + time-step-damage-backbay + time-step-damage-charlestown + time-step-damage-downtown + time-step-damage-eboston + time-step-damage-fenway + time-step-damage-ndorchester + time-step-damage-sboston + time-step-damage-sdorchester)

end

to calculate-damage-ss
  set damage-time-step 0
  ;calculate damages for the south shore
  if flood-height = 0 [
    set flood-height 0.000001]
  ifelse adaptation = "seawall" [
    if flood-height <= municipal-sw-height[
      set damage-time-step 0]
    if flood-height > municipal-sw-height[
      ;original damage function:
      ;set damage-time-step (286343 * (flood-height ^ 3.359))
      ;new damage function:
      set damage-time-step (4 * 10 ^ 9)  * (ln flood-height) - (8 * 10 ^ 9)

    set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2021))]
  ]
  [
    ;if adaptation = "none"
    ;set damage-time-step (286343 * (flood-height ^ 3.359))
    set damage-time-step (4 * 10 ^ 9)  * (ln flood-height) - (8 * 10 ^ 9)
    set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2021))]
  if damage-time-step < 0 [
    set damage-time-step 0]
end

to calculate-damage-ns
;calculate damages for the north shore
  ifelse adaptation = "seawall" [
    if flood-height <= municipal-sw-height[
      set damage-time-step 0]
    if flood-height > municipal-sw-height[
      set damage-time-step (1345.8 * (flood-height ^ 4.9862))
    set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2021))]
  ]
 ;    if adaptation = "none"
  [
  set damage-time-step (1345.8 * (flood-height ^ 4.9862))
  set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2021))]

end

to calc-damage-for-dev-mun-adapt-none
  ;calculates damages for the property_owner when there is no municipal adaptation (seawall)
   if adaptation = "none" [
    ;uses unaltered depth-damage curve
          let inundation (flood-height - elevation)
          ifelse inundation < 1 [
            set damage-time-step 0]
         [ if inundation > 1 [
            set damage-percent .05]
          if inundation > 2[
            set damage-percent .16]
          if inundation > 3 [
            set damage-percent .19]
          if inundation > 4[
            set damage-percent .21]
          if inundation > 5[
            set damage-percent .25]
          if inundation > 6 [
            set damage-percent .30]
          if inundation > 7[
            set damage-percent .35]
          if inundation > 8[
            set damage-percent .37]
          if inundation > 9 [
            set damage-percent .38]
      ;assumes property value is 300,000 (probably a super low ball given the cost of property in Boston area)
          set damage-time-step property_value * damage-percent
      set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2020))]
        ]
        if adaptation = "aquafence"[
    ;no damages occur under 3 feet, as the aquafence protects up to this height
          let inundation (flood-height - elevation)
          ifelse inundation <= 3 [
            set damage-percent 0
            set damage-time-step 0]
          [if inundation >= 3 [
            set damage-percent .19]
          if inundation > 4[
            set damage-percent .21]
          if inundation > 5[
            set damage-percent .25]
          if inundation > 6 [
            set damage-percent .30]
          if inundation > 7[
            set damage-percent .35]
          if inundation > 8[
            set damage-percent .37]
          if inundation > 9 [
            set damage-percent .38]
          set damage-time-step property_value * damage-percent
      set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2021))]
            ]
        if adaptation = "local-seawall" [
    ;assumes local seawall adds 15 feet of protection
          let inundation (flood-height - elevation)
          ifelse inundation <= 15 [
            set damage-time-step 0
            set damage-percent 0]
          [if inundation > 15 [
            set damage-percent .70]
        set damage-time-step property_value * damage-percent
      set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2021))]
      ]

end

to calc-damage-for-dev-mun-adapt-seawall
  ;this calculates damages for property_owners given municipal seawalls in place
  if adaptation = "none" [
           ifelse flood-height < municipal-sw-height[
            set damage-time-step 0]
           [if flood-height >= municipal-sw-height[
            let inundation flood-height - elevation
            if inundation < 1 [
            set damage-percent 0]
          if inundation > 1 [
            set damage-percent .05]
          if inundation > 2[
            set damage-percent .16]
          if inundation > 3 [
            set damage-percent .19]
          if inundation > 4[
            set damage-percent .21]
          if inundation > 5[
            set damage-percent .25]
          if inundation > 6 [
            set damage-percent .30]
          if inundation > 7[
            set damage-percent .35]
          if inundation > 8[
            set damage-percent .37]
          if inundation > 9 [
            set damage-percent .38]
          ]
          set damage-time-step property_value * damage-percent
      set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2021))]
        ]
        if adaptation = "aquafence"[
          ifelse flood-height < municipal-sw-height[
            let inundation 0
            set damage-time-step 0]

          [
          let inundation flood-height - elevation
            if inundation < 1 [
            set damage-percent 0]
          if inundation > 1 [
            set damage-percent 0]
          if inundation > 2[
            set damage-percent 0]
          if inundation > 3 [
            set damage-percent .19]
          if inundation > 4[
            set damage-percent .21]
          if inundation > 5[
            set damage-percent .25]
          if inundation > 6 [
            set damage-percent .30]
          if inundation > 7[
            set damage-percent .35]
          if inundation > 8[
            set damage-percent .37]
          if inundation > 9 [
            set damage-percent .38]
          set damage-time-step property_value * damage-percent
          set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2021))
    ]
            ]
        if adaptation = "local-seawall" [
          ifelse flood-height < municipal-sw-height[
            set damage-time-step 0]
          [ let inundation flood-height - elevation
            if inundation < 1 [
            set damage-percent 0]
          if inundation > 1 [
            set damage-percent 0]
          if inundation > 2[
            set damage-percent 0]
          if inundation > 3 [
            set damage-percent .19]
          if inundation > 4[
            set damage-percent .21]
          if inundation > 5[
            set damage-percent .25]
          if inundation > 6 [
            set damage-percent .30]
          if inundation > 7[
            set damage-percent .35]
          if inundation > 8[
            set damage-percent .37]
          if inundation > 9 [
            set damage-percent .38]

          set damage-time-step property_value * damage-percent
      set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2021))]
      ]
end


to calculate-damage
      ask municipalities with [name = "boston" ] [
        set damage-time-step 0
    ;separate code for boston municipality (much cleaner given the 9 neighborhoods)
        calculate-damage-boston]
      ask municipalities with [name = "south-shore"][
        calculate-damage-ss]
      ask municipalities with [name = "north-shore"][
        calculate-damage-ns]


  ask MBTA-agents[
    if mbta-adaptation-method = "all-at-once" [
      mbta-damages-all-at-once
    ]
    if mbta-adaptation-method = "segments" [
      mbta-damages-segments
    ]
  ]

  ask property_owners[
    ;identify where they are located to test for a seawall
    ;set loc [region] of patch-here
    if dev-region = "boston"[
      ;list-index is temp variable describing the position of the sw segment that would protect the property_owner in the list of possible seawalls (as an identifier)
      let list-index position boston-sw-segment boston-neighborhood-list
      if item list-index boston-adaptation-list = "none" [
        ;used when downtown boston lacks a seawall
         calc-damage-for-dev-mun-adapt-none
      ]
       if item list-index boston-adaptation-list = "seawall" [
        ;used when downtown boston does have a seawall
          calc-damage-for-dev-mun-adapt-seawall
    ]
    ]
    ;process repeats for property_owners in NS or SS
    let dev-test dev-region
    ifelse first [adaptation] of municipalities with [label = dev-test] = "seawall" [
      calc-damage-for-dev-mun-adapt-seawall]
    ;otherwise no seawall
    [calc-damage-for-dev-mun-adapt-none]

    if insurance-module? = true[
  if insurance? = false [
      set damages-paid damage-time-step
      set damages-paid-total damages-paid-total + damage-time-step
    ]
  if insurance? = true [
      ;assumption of property only for residential properties (for now)
      ifelse damage-time-step < max-flood-insurance-coverage [
        set damages-paid damage-time-step * deductible
        set damages-paid-total damages-paid-total + damages-paid
        set insurance-damages-covered ((1 - deductible) * damage-time-step)
        set insurance-damages-covered-total insurance-damages-covered-total + insurance-damages-covered ]
      [set damages-paid (damage-time-step * deductible + ( damage-time-step - max-flood-insurance-coverage))
       set damages-paid-total damages-paid-total + damages-paid
       set insurance-damages-covered insurance-damages-covered + ((1 - deductible) * max-flood-insurance-coverage)
       set insurance-damages-covered-total insurance-damages-covered-total + insurance-damages-covered
        ]
    ]
    ]
  ]

  ask private-assets with [name = "BOS-air"][
      ifelse item 4 boston-adaptation-list = "seawall"[
      ;a seawall in east boston would protect Logan
      let inundation (flood-height - elevation)
        ifelse flood-height < municipal-sw-height [
          set damage-time-step 0]
        [
        ifelse inundation <= 3 [
          set damage-time-step 0]
        [;big inundation
        set damage-time-step 1000000000
        set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2021))
        ]
        ]
      ]

      [;no seawall protection
      ifelse adaptation = "none" [
        let inundation (flood-height - elevation)
        ifelse inundation <= 3 [
          set damage-time-step 0]
        [set damage-time-step 1000000000
          set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2021))]
      ]

        [;has a seawall
          ifelse flood-height < 15 [
          set damage-time-step 0]
        [;flood height is greater than 15
        let inundation (flood-height - elevation)
        ifelse inundation <= 3 [
          set damage-time-step 0]
        [;big inundation
        set damage-time-step 1000000000
        set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2021))
        ]
        ]
        ]
      ]
  ]


  ask private-assets with [name = "food dist"][
      let inundation1 (flood-height - elevation)
    ;seawall would be in the north shore
    ifelse first [adaptation] of municipalities with [name = "north-shore"] = "seawall"[
      let inundation (flood-height - elevation)
        ifelse flood-height < municipal-sw-height [
          set damage-time-step 0]
        [;flood height is greater than 15

        ifelse inundation1 <= 3 [
          set damage-time-step 0]
        [;big inundation
        set damage-time-step 1000000000
        set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2021))
        ]
        ]
      ]

      [;no seawall protection
      ifelse adaptation = "none" [
        ;let inundation1 (flood-height - elevation)
        ifelse inundation1 <= 3 [
          set damage-time-step 0]
        [set damage-time-step 1000000000
          set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2021))]
      ]

        [;has a seawall
          ifelse flood-height < 15 [
          set damage-time-step 0]
        [;flood height is greater than 15
        ;let inundation (flood-height - elevation)
        ifelse inundation1 <= 3 [
          set damage-time-step 0]
        [;big inundation
        set damage-time-step 1000000000
        set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2021))
        ]
        ]
        ]
      ]
      ]
end

to mbta-damages-all-at-once
   ;assume 10% of damage in NS, 10% in SS, 2% allston, 2% backbay, 2% in Charlestown, 10%downtown, 15% in EB, 2% fenway, 5% ndorchester, 40% in Sboston, 2% sdorchester
    ;MBTA damages depend on municipal protections across Bostn, NS, and SS
    ;list below corresponds to the damages in the 9 boston neighborhoods listed above in comments
    set mbta-damage-list-boston (list 0.02 0.02 0.02 0.10 0.15 0.02 0.05 0.40 0.02)
    set damage-component 0
    ;max-damage represents the damage calculated if there are no seawalls at all, given by the fitted damage curve
    set max-damage (1521183828.66 * flood-height - 12723896004.9)
    ;if damage is negative, set it to 0
    if max-damage < 0 [
      set max-damage 0]
    if adaptation = "none"[
        ;here, the adaptation of mbta is none
      if flood-height <= 8.365 [
          ;no damage if the flood is small enought
        set max-damage 0]
       ;add discount
      set max-damage (max-damage)/((1 + discount) ^ (year - 2021))
      ;The next section adds damages consecutively according to the total damage possible, proportion from that seawall segement, and the presence or absence of the segment
      ;no protection from north shore = full proportional ns damage
      ;damage = damage from NS
      ifelse first [adaptation] of municipalities with [name = "north-shore"] = "none" [
        ;damage is full - no protection from ns or from mbta
        set damage-component damage-component + max-damage * 0.10]
      [;ns has a seawall- protected up to 15 ft NAV88
        ifelse flood-height >= municipal-sw-height [
        set damage-component damage-component + max-damage * 0.10]
        [set damage-component damage-component + 0]
      ]
      ;damage = damage from NS + damage from SS
      ifelse first [adaptation] of municipalities with [name = "south-shore"] = "none" [
        set damage-component damage-component + max-damage * 0.10]
      [ifelse flood-height >= municipal-sw-height [
        set damage-component damage-component + max-damage * 0.10]
        [set damage-component damage-component + 0]
      ]
      ;damage = damage from NS + damage from SS + damage from Boston segments
      set test-pos 0
      foreach boston-adaptation-list[
        [x]-> set current-adapt x
        let percent item test-pos mbta-damage-list-boston
        ifelse current-adapt = "none"[
          set damage-component damage-component + max-damage * percent]
        [;there is a seawall
          ifelse flood-height >= municipal-sw-height [
        set damage-component damage-component + max-damage * percent]
        [set damage-component damage-component + 0]]
        set test-pos test-pos + 1
        ;output-print(damage-component)
      ]
      set damage-time-step damage-component
    ]
    ;code below is if MBTA has their own adaptaion
    if adaptation = "on-site-seawall" [
      let bigger-height max (list 15 municipal-sw-height)
       ifelse flood-height <= bigger-height [
        set damage-time-step 0]
      [set damage-time-step (1521183828.66 * flood-height - 12723896004.9)
      set damage-time-step (damage-time-step)/((1 + discount) ^ (year - 2021))]

    ]
end

to mbta-damages-segments
  ;PICK UP HERE
 set mbta-damage-list-boston (list 0.02 0.02 0.02 0.10 0.15 0.02 0.05 0.40 0.02)
  set mbta-cost-proportion-list [0.025 0.025 0.05 0.05 0.1 0.25 0.25 0.05 0.025 0.15 0.025]
  set mbta-damage-proportion-list (list 0.10 0.10 0.02 0.02 0.02 0.10 0.15 0.02 0.05 0.40 0.02)
  set damage-time-step 0
  ;create mbta-damage-list-boston with ra

    set damage-component 0
    ;max-damage represents the damage calculated if there are no seawalls at all, given by the fitted damage curve
    set max-damage (1521183828.66 * flood-height - 12723896004.9)
    set max-damage (max-damage)/((1 + discount) ^ (year - 2021))
    ;if damage is negative, set it to 0
    if max-damage < 0 [
      set max-damage 0]
    set max-damage (max-damage)/((1 + discount) ^ (year - 2021))


  ;now we need to do a foreach where we have the following scenarios:
     ;1) MBTA has adapted but mun. has not -> protection according to MBTA sw
     ;2) MBTA has not adapted and mun has not -> no protection
     ;3) MBTA has adapted and mun has -> protection according to whichever is higher
     ;4) mbta has not adapted and mun has -> protection according to mun

  ;1) assemble list of adaptations across the harbor - we can borrow ra-adaptation-list
  if model-version != "regional authority" [
    set ra-adaptation-list boston-adaptation-list
    let target-adaptation first [adaptation] of municipalities with [name = "south-shore"]
    set ra-adaptation-list insert-item 0 ra-adaptation-list target-adaptation
    let target-adaptation-2 first [adaptation] of municipalities with [name = "north-shore"]
    set ra-adaptation-list insert-item 0 ra-adaptation-list target-adaptation-2
    ;output-print(ra-adaptation-list)
  ]

  ;2) now we go through and actually get the damages
  set test-pos 0
  foreach ra-adaptation-list [
    ;set neigh-adapt to be item i in the boston adaptation list, so it will be set for each neighborhood
    [x] -> set neigh-adapt x
    let mbta-adapt-section item test-pos mbta-adaptation-list
    let damage-proportion item test-pos mbta-damage-proportion-list
    ;possibility 1
    if (mbta-adapt-section = "seawall") and (neigh-adapt = "none") [
      set protect-height 15
    ]
    ;possibility 2
    if (mbta-adapt-section = "none") and (neigh-adapt = "none") [
      set protect-height 8.365
      ;note: this is not 0, but the base elevation required for the MTBA to experience flooding damages according to our methodology
    ]
    ;possibility 3
    if (mbta-adapt-section = "seawall") and (neigh-adapt = "seawall") [
      set protect-height max (list 15 municipal-sw-height)
    ]
    ;possibility 4
    if (mbta-adapt-section = "none") and (neigh-adapt = "seawall") [
      set protect-height municipal-sw-height
    ]

    ;check to see if flood passed the minimum flooding elecation
    ifelse flood-height <= protect-height [
          ;no damage if the flood is small enought
        set damage-component 0]
    [;there is a flood
      set damage-component max-damage * damage-proportion
      set damage-time-step damage-time-step + damage-component]

    set test-pos test-pos + 1
  ]

end


to adaptation-decision


  ask municipalities[
    ;set parameter for the legnth of time to predict
    set foresight foresight-mun-pas-mbta
    ;if the region is boston, other processes needed
     ifelse name = "boston" [
      adaptation-decision-boston]
    [;for municipalities other than boston

      ;if there is no other adaptation (only calculate if we are considering adaptation)
      ifelse adaptation = "none" [
        ;step 1: calculate annual-expected-damage
        setup-municipal-python
        py:set "year" year
        py:set "max_range" 1
        municipality-projected-damages
        set annual-expected-damage python-output
        ;step 2: calculate the damages that would happen without a seawall in place
        setup-municipal-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        municipality-projected-damages
        set thirty_year_damage python-output
        ;step 3: calculate damages that would occur with a seawall in place
        setup-municipal-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        municipality-projected-damages
        let damage_wout_adaptation python-output
        setup-municipal-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - (permitting-delay)
        municipality-projected-damages-sw
        let damage_w_adaptation python-output
        set thirty_year_damage_sw (damage_wout_adaptation + damage_w_adaptation)

        ;OLD CODE BELOW 10_25
        ;calculate projected damages through n years without a sw, where n is given by 'foresight'
        ;municipality-projected-damages
        ;calculate projected damages through n years with a sw, where n is given by 'foresight'
        ;municipality-projected-damages-sw

        ;write code that adjusts benefits according to EJ weighting
        ifelse prioritization-method = "EJ" [
          ifelse name = "north-shore" [
            set ej-weight item 0 harbor-region-EJ-weights
          ]
          [set ej-weight item 1 harbor-region-EJ-weights
          ]
        ]
        [set ej-weight 1]
        ;the benefit of the seawall is given by damages avoided
        let seawall-benefit (thirty_year_damage - thirty_year_damage_sw) * ej-weight
        ;if overall benefit is larger than 0
        if seawall-benefit > 0 [
          ;calculate seawall cost
          let cost-2020-pt-1 coastline * 7500
          ;add permitting
          let cost-2020-perm cost-2020-pt-1 + (cost-2020-pt-1 * permitting-cost-proportion)
          ;add o+m
          let cost-2020-all cost-2020-perm + (cost-2020-pt-1 * O_M_proportion * foresight)

          ;discount cost to whatever year we are in
          let cost-discount-perm (cost-2020-perm)/((1 + discount) ^ (year - 2021))
          let cost-discount-all (cost-2020-all)/((1 + discount) ^ (year - 2021))

          let cost-perm cost-discount-perm * (1 - external-financing-percent)
          let cost-all cost-discount-all * (1 - external-financing-percent)

          ;set cost benefit seawall damages avoided / cost
          set cost-benefit-seawall seawall-benefit / cost-all
          ;if we have the behavioral modification on, then
          if flood-reaction-municipalities = True [
            ;we can set a modification between what we experienced and expected to experience
            let behave-ratio damage-time-step / annual-expected-damage
            ;this in turn will change our seawall benefit
            set cost-benefit-seawall cost-benefit-seawall * behave-ratio
           ]
          ;if the best option is to make the seawall,
          if cost-benefit-seawall > 1
          [
            ;then plan to build it!
            set adaptation-intention "seawall"
            set planned-adaptation-cost cost-perm]
          ]
      ]
      [
      set planned-adaptation-cost 0
      ]
    ]

  ]

  ask property_owners[
    ;right now set to a default of 30 years
    set foresight foresight-property_owners
    let loc-test [region] of patch-here
    ;assumes location in downtown if we are located in boston - NEEDS TO BE CHANGED IN TIME
    ifelse dev-region = "boston" [
    set adapt-test-mun item 4 boston-adaptation-list
    set crs-discount item 4 boston-crs-discount-list
    set premium-adjusted premium * (1 - crs-discount)
     ifelse prioritization-method = "EJ" [
        set ej-weight item 6 harbor-region-EJ-weights]
      [set ej-weight 1]
    ]
    ;otherwise we are protected or not by municipal sw
   [set adapt-test-mun first [adaptation] of municipalities with [label = loc-test]
      set crs-discount first [crs-discount] of municipalities with [label = loc-test]
      ifelse prioritization-method = "EJ" [
    ifelse dev-region = "north-shore" [
        set ej-weight item 0 harbor-region-EJ-weights]
        [set ej-weight item 1 harbor-region-EJ-weights]]
      [set ej-weight 1]
    ]
    ;code below is to test without municipal sws being possible


   ifelse adapt-test-mun = "seawall" [
    set flood-protect-height municipal-sw-height
  ]
  [set flood-protect-height 0]
    set premium-adjusted premium * (1 - crs-discount)
     if insurance-module? = false [
    if adaptation = "none" [

        ;step 1: get the annual-expected-damage
        py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        property_owner-projected-damages
        set annual-expected-damage python-output

        ;step 2: get the baseline without any adaptation
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        property_owner-projected-damages
        set thirty_year_damage python-output

        ;step 3: get aquafence baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages
        let no_adapt_damages python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-af
        let af_damages python-output
        set thirty_year_damage_af no_adapt_damages + af_damages

        ;step 4: get seawall baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages
        let no_adapt_damages_1 python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages_1 + sw_damages


      ;option 4: aquafence alone - projects for length of 'foresight'
      let aquafence-benefit (thirty_year_damage - thirty_year_damage_af) * ej-weight
      let aquafence-cost-2020-pt-1  500000 + (foresight * 40000)
      let aquafence-cost-2020-perm aquafence-cost-2020-pt-1 + (aquafence-cost-2020-pt-1 * permitting-cost-proportion)
      let aquafence-cost-2020-all aquafence-cost-2020-perm + (aquafence-cost-2020-pt-1 * foresight * O_M_proportion)

      set aquafence-cost-discount-perm (aquafence-cost-2020-perm)/((1 + discount) ^ (year - 2021))
      set aquafence-cost-discount-all (aquafence-cost-2020-all)/((1 + discount) ^ (year - 2021))

      set aquafence-cost-perm aquafence-cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
      set aquafence-cost-all aquafence-cost-discount-all * ((1 - external-financing-percent) * reduction-funding-access)



      ;option 5: seawall alone - projects for length of 'foresight'
      let seawall-benefit (thirty_year_damage - thirty_year_damage_sw) * ej-weight
      let seawall-cost-2020-pt-1 (5300 * perimeter)
      let seawall-cost-2020-perm seawall-cost-2020-pt-1 + (seawall-cost-2020-pt-1 * permitting-cost-proportion)
      let seawall-cost-2020-all seawall-cost-2020-perm + (seawall-cost-2020-pt-1 * O_M_proportion * foresight)


      set seawall-cost-discount-perm (seawall-cost-2020-perm)/((1 + discount) ^ (year - 2021))
      set seawall-cost-discount-all (seawall-cost-2020-all)/((1 + discount) ^ (year - 2021))

      set seawall-cost-perm seawall-cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
      set seawall-cost-all seawall-cost-discount-all * ((1 - external-financing-percent) * reduction-funding-access)

      let cost_list (list aquafence-cost-all seawall-cost-all)
      let benefit_list (list aquafence-benefit seawall-benefit)
      let cost_list_perm (list aquafence-cost-perm seawall-cost-perm)
        set benefit_cost_list [0 0]
      set benefit_cost_list_behavior [0 0]
      set test-pos 0
      foreach cost_list[
        [x]-> let option-cost x
        set option-benefit item test-pos benefit_list
        ifelse option-benefit > 0 [
          set benefit_cost_list replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ifelse flood-reaction-property_owners = True [
             ifelse annual-expected-damage > 0 [
                if annual-expected-damage = 0 [
                  ;output-print("failure 1")
                ]
              let behave-ratio damage-time-step / annual-expected-damage
                if option-cost = 0[
                  ;output-print("failure 2")
                ]
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio]
            [;no damage expected- less likely to adapt (assume 50% here)
              let behave-ratio .50
                if option-cost = 0[
                  ;output-print("failure 3")
                ]
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio
            ]
          ]

          [if option-cost = 0[
                  ;output-print("failure 4")
              ]
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ]
        ]
        [set benefit_cost_list replace-item test-pos benefit_cost_list 0
          set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior 0
        ]
        set test-pos test-pos + 1
      ]

      let best-ratio max benefit_cost_list_behavior
      set identifier position best-ratio benefit_cost_list_behavior
      ;NOTE 2/27 ASSUMES PLANNED ADAPTATION COST INDICATES COST OF ADAPTATIONS ADN INSURANCE BOTH
      ;CHANGE BELOW FOR TEST
      if best-ratio = 0 [
        set identifier 5]

       if identifier = 0[
        set insurance-intention False
        set adaptation-intention "aquafence"
        set planned-adaptation-cost aquafence-cost-perm
      ]
;      if identifier = 4[
       if identifier = 1[
        set insurance-intention False
        set adaptation-intention "local-seawall"
        set planned-adaptation-cost seawall-cost-perm
      ]
;      if identifier = 5[
       if identifier = 2[
        ; no adaptation
        set insurance-intention False
        ]
    ]


    if adaptation = "aquafence" [

      ;step 1: get the annual-expected-damage
        py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        property_owner-projected-damages-af
        set annual-expected-damage python-output

        ;step 2: get the baseline without any adaptation
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        property_owner-projected-damages-af
        set thirty_year_damage python-output


        ;step 4: get seawall baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages-af
        let no_adapt_damages_1 python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages_1 + sw_damages


      ;option 3: build seawall alone

      let seawall-benefit (thirty_year_damage - thirty_year_damage_sw) * ej-weight
      let seawall-cost-2020-pt-1 (5300 * perimeter)
      let seawall-cost-2020-perm seawall-cost-2020-pt-1 + (seawall-cost-2020-pt-1 * permitting-cost-proportion)
      let seawall-cost-2020-all seawall-cost-2020-perm + (seawall-cost-2020-pt-1 * O_M_proportion * foresight)


      set seawall-cost-discount-perm (seawall-cost-2020-perm)/((1 + discount) ^ (year - 2021))
      set seawall-cost-discount-all (seawall-cost-2020-all)/((1 + discount) ^ (year - 2021))

      set seawall-cost-perm seawall-cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
      set seawall-cost-all seawall-cost-discount-all * ((1 - external-financing-percent) * reduction-funding-access)


      let cost_list (list seawall-cost-all)
      let benefit_list (list seawall-benefit)
      set benefit_cost_list [0]
      set benefit_cost_list_behavior [0]
      set test-pos 0
      foreach cost_list[
        [x]-> let option-cost x
        set option-benefit item test-pos benefit_list
        ifelse option-benefit > 0 [
          set benefit_cost_list replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ifelse flood-reaction-property_owners = True [
             ifelse annual-expected-damage > 0 [
                if annual-expected-damage  = 0[
                  ;output-print("failure 5")
                ]
              let behave-ratio damage-time-step / annual-expected-damage
                if option-cost = 0[
                  ;output-print("failure 6")
                ]
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio]
            [;no damage expected- less likely to adapt (assume 50% here)
              let behave-ratio .50
                if option-cost = 0[
                  ;output-print("failure 7")
                ]
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio
            ]
          ]

          [if option-cost = 0[
                  ;output-print("failure 8")
              ]
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ]
        ]
        [set benefit_cost_list replace-item test-pos benefit_cost_list 0
          set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior 0
        ]
        set test-pos test-pos + 1
      ]

      let best-ratio max benefit_cost_list_behavior
      set identifier position best-ratio benefit_cost_list_behavior
      ;NOTE 2/27 ASSUMES PLANNED ADAPTATION COST INDICATES COST OF ADAPTATIONS ADN INSURANCE BOTH


       if identifier = 0[
        set insurance-intention False
        set adaptation-intention "local-seawall"
        set planned-adaptation-cost seawall-cost-perm
      ]
;      if identifier = 5[
       if identifier = 1[
        ; no adaptation
        set insurance-intention False
        ]
    ]
        if adaptation = "local-seawall"[
    ; no further adaptation that can be done- nothing left

    ]
    ]
    if insurance-module? = true [
       ifelse mandatory-insurance? = false [
          if adaptation = "none" [
             ;calculate property_owner damags without any adaptation

             ;step 1: get the annual-expected-damage
        py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        property_owner-projected-damages
        set annual-expected-damage python-output

        ;step 2: get the baseline without any adaptation
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        property_owner-projected-damages
        set thirty_year_damage python-output

        ;step 3: get aquafence baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages
        let no_adapt_damages python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-af
        let af_damages python-output
        set thirty_year_damage_af no_adapt_damages + af_damages

        ;step 4: get seawall baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages
        let no_adapt_damages_1 python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages_1 + sw_damages

             ;option 1: insurance alone - 1 year time step
             ;Comment out options 1, 2, and 3 BELOW FOR TEST
             let insurance-coverage (1 - deductible) * annual-expected-damage
             ifelse insurance-coverage > max-flood-insurance-coverage [
              set insurance-damages max-flood-insurance-coverage
             ]
             [set insurance-damages insurance-coverage]
             set insurance-damages (insurance-damages)/((1 + discount) ^ (year - 2021))
             let insurance-benefit (annual-expected-damage - (annual-expected-damage - insurance-damages)) * ej-weight
             set insurance-cost premium-adjusted / ((1 + discount) ^ (year - 2021))

             ;option 2: insurance with an aquafence - projects for length of 'foresight'
             ;damages with both are assumed to be 10% of aquafence damage
             let aquafence-cost-2020-ins-pt-1  500000 + (foresight * 40000)
             let aquafence-cost-2020-ins-perm aquafence-cost-2020-ins-pt-1 + (aquafence-cost-2020-ins-pt-1 * permitting-cost-proportion)
             let aquafence-cost-2020-ins-all aquafence-cost-2020-ins-perm + (aquafence-cost-2020-ins-pt-1 * foresight * O_M_proportion)

             let aquafence-cost-ins-discount-perm (aquafence-cost-2020-ins-perm)/((1 + discount) ^ (year - 2021))
             let aquafence-cost-ins-discount-all (aquafence-cost-2020-ins-all)/((1 + discount) ^ (year - 2021))

             let aquafence-cost-ins-perm aquafence-cost-ins-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
             let aquafence-cost-ins-all aquafence-cost-ins-discount-all * ((1 - external-financing-percent) * reduction-funding-access)

             let premium-estimates foresight *  premium-adjusted
             let premium-estimates-discount (premium-estimates) / ((1 + discount) ^ (year - 2021))
             set insurance-af-cost aquafence-cost-ins-all + premium-estimates-discount
             ;really this should be discounted
             let max-insurance-coverage max-flood-insurance-coverage * foresight
             ifelse thirty_year_damage_af * (1 - deductible) > max-insurance-coverage [
             set insurance-af-damages max-insurance-coverage]
             [set insurance-af-damages thirty_year_damage_af * (1 - deductible)]
             ;insruance-af-damages is the component of damages that insurance pays
             let insurance-af-benefits (thirty_year_damage - (thirty_year_damage_af - insurance-af-damages)) * ej-weight


             ;option 3: insurance with a seawall - projects for length of 'foresight'
             let seawall-cost-2020-ins-pt-1  (5300 * perimeter)
             let seawall-cost-2020-ins-perm seawall-cost-2020-ins-pt-1 + (seawall-cost-2020-ins-pt-1 * permitting-cost-proportion)
             let seawall-cost-2020-ins-all seawall-cost-2020-ins-perm + (seawall-cost-2020-ins-pt-1 * foresight * O_M_proportion)

             let seawall-cost-ins-discount-perm (seawall-cost-2020-ins-perm)/((1 + discount) ^ (year - 2021))
             let seawall-cost-ins-discount-all (seawall-cost-2020-ins-all)/((1 + discount) ^ (year - 2021))

             let seawall-cost-ins-perm seawall-cost-ins-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
             let seawall-cost-ins-all seawall-cost-ins-discount-all * ((1 - external-financing-percent) * reduction-funding-access)

             let premium-estimates-sw foresight * premium-adjusted
             let premium-estimates-sw-discount (premium-estimates-sw)/((1 + discount) ^ (year - 2021))
             set insurance-sw-cost seawall-cost-ins-all + premium-estimates-sw-discount
             let max-insurance-coverage-sw max-flood-insurance-coverage * foresight
             ifelse thirty_year_damage_sw * (1 - deductible) > max-insurance-coverage-sw [
             set insurance-sw-damages max-insurance-coverage-sw]
             [set insurance-sw-damages thirty_year_damage_sw * (1 - deductible)]
             ;insruance-af-damages is the component of damages that insurance pays
             let insurance-sw-benefits (thirty_year_damage - (thirty_year_damage_sw - insurance-sw-damages)) * ej-weight


            ;option 4: aquafence alone - projects for length of 'foresight'
            let aquafence-benefit (thirty_year_damage - thirty_year_damage_af) * ej-weight
             let aquafence-cost-2020-pt-1  500000 + (foresight * 40000)
             let aquafence-cost-2020-perm aquafence-cost-2020-pt-1 + (aquafence-cost-2020-pt-1 * permitting-cost-proportion)
             let aquafence-cost-2020-all aquafence-cost-2020-perm + (aquafence-cost-2020-pt-1 * foresight * O_M_proportion)

             set aquafence-cost-discount-perm (aquafence-cost-2020-perm)/((1 + discount) ^ (year - 2021))
             set aquafence-cost-discount-all (aquafence-cost-2020-all)/((1 + discount) ^ (year - 2021))

             set aquafence-cost-perm aquafence-cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
             set aquafence-cost-all aquafence-cost-discount-all * ((1 - external-financing-percent) * reduction-funding-access)



            ;option 5: seawall alone - projects for length of 'foresight'
            let seawall-benefit (thirty_year_damage - thirty_year_damage_sw) * ej-weight
             let seawall-cost-2020-pt-1  (5300 * perimeter)
             let seawall-cost-2020-perm seawall-cost-2020-pt-1 + (seawall-cost-2020-pt-1 * permitting-cost-proportion)
             let seawall-cost-2020-all seawall-cost-2020-perm + (seawall-cost-2020-pt-1 * foresight * O_M_proportion)

             set seawall-cost-discount-perm (seawall-cost-2020-perm)/((1 + discount) ^ (year - 2021))
             set seawall-cost-discount-all (seawall-cost-2020-all)/((1 + discount) ^ (year - 2021))

             set seawall-cost-perm seawall-cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
             set seawall-cost-all seawall-cost-discount-all * ((1 - external-financing-percent) * reduction-funding-access)


      ;now we need to set ratios.....
         ;the following are our parameters:
           ;insurance-cost, insurance-benefit
           ;insurance-af-cost, insurance-af-benefit
           ;insurance-sw-cost, insurance-sw-benefit
           ;aquafence-cost, aquafence-benefit
           ;seawall-cost, seawall-benefit
;CHANGE BELOW FOR TEST
      let cost_list (list insurance-cost insurance-af-cost insurance-sw-cost aquafence-cost-all seawall-cost-all)
      let benefit_list (list insurance-benefit insurance-af-benefits insurance-sw-benefits aquafence-benefit seawall-benefit)
      set benefit_cost_list [0 0 0 0 0]
      set benefit_cost_list_behavior [0 0 0 0 0]

;      let cost_list (list aquafence-cost seawall-cost)
;      let benefit_list (list aquafence-benefit seawall-benefit)
;        set benefit_cost_list [0 0]
;      set benefit_cost_list_behavior [0 0]
      set test-pos 0
      foreach cost_list[
        [x]-> let option-cost x
            ;output-print(test-pos)
            ;output-print(option-cost)
        set option-benefit item test-pos benefit_list
        ifelse option-benefit > 0 [
          set benefit_cost_list replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ifelse flood-reaction-property_owners = True [
                ;output-print(option-cost)
             ifelse annual-expected-damage > 0 [
                  ;output-print(annual-expected-damage)
              let behave-ratio damage-time-step / annual-expected-damage
                  if option-cost = 0 [
                    ;output-print("failure 10")
                  ]
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio]
            [;no damage expected- less likely to adapt (assume 50% here)
              let behave-ratio .50
              let altered_ratio (option-benefit / option-cost) * behave-ratio
                  if option-cost = 0 [
                    ;output-print("failure 11")
                  ]
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio
            ]
          ]

          [if option-cost = 0 [
                    ;output-print("failure 12")
                ]
                set benefit_cost_list_behavior replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ]
        ]
        [set benefit_cost_list replace-item test-pos benefit_cost_list 0
          set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior 0
        ]
        set test-pos test-pos + 1
      ]

      let best-ratio max benefit_cost_list_behavior
      set identifier position best-ratio benefit_cost_list_behavior
      ;NOTE 2/27 ASSUMES PLANNED ADAPTATION COST INDICATES COST OF ADAPTATIONS ADN INSURANCE BOTH
      ;CHANGE BELOW FOR TEST
      if best-ratio = 0 [
        set identifier 5]
      if identifier = 0 [
        set insurance-intention True
        set planned-adaptation-cost insurance-cost
      ]
      if identifier = 1[
        set insurance-intention True
        set adaptation-intention "aquafence"
        set planned-adaptation-cost insurance-cost + aquafence-cost-perm
      ]
      if identifier = 2[
        set insurance-intention True
        set adaptation-intention "local-seawall"
        set planned-adaptation-cost insurance-cost + seawall-cost-perm
      ]
      if identifier = 3[
;       if identifier = 0[
        set insurance-intention False
        set adaptation-intention "aquafence"
        set planned-adaptation-cost aquafence-cost-perm
      ]
      if identifier = 4[
;       if identifier = 1[
        set insurance-intention False
        set adaptation-intention "local-seawall"
        set planned-adaptation-cost seawall-cost-perm
      ]
      if identifier = 5[
;       if identifier = 2[
        ; no adaptation
        set insurance-intention False
        ]
    ]


    if adaptation = "aquafence" [
      ;step 1: get the annual-expected-damage
        py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        property_owner-projected-damages-af
        set annual-expected-damage python-output

        ;step 2: get the baseline without any adaptation
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        property_owner-projected-damages-af
        set thirty_year_damage_af python-output

        ;step 4: get seawall baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages-af
        let no_adapt_damages_1 python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages_1 + sw_damages
      ;CHANGE BELOW FOR TEST
      ;option 1: purchase insurance
      let insurance-coverage (1 - deductible) * annual-expected-damage-af
             ifelse insurance-coverage > max-flood-insurance-coverage [
              set insurance-damages max-flood-insurance-coverage
             ]
             [set insurance-damages insurance-coverage]

      set insurance-damages (insurance-damages)/((1 + discount) ^ (year - 2021))
      let insurance-benefit (annual-expected-damage-af - (annual-expected-damage-af - insurance-damages)) * ej-weight
      set insurance-cost premium-adjusted / ((1 + discount) ^ (year - 2021))

      ;option 2: purchase insurance and build seawall
      let seawall-cost-2020-ins-pt-1  (5300 * perimeter)
      let seawall-cost-2020-ins-perm seawall-cost-2020-ins-pt-1 + (seawall-cost-2020-ins-pt-1 * permitting-cost-proportion)
      let seawall-cost-2020-ins-all seawall-cost-2020-ins-perm + (seawall-cost-2020-ins-pt-1 * foresight * O_M_proportion)

      let seawall-cost-ins-discount-perm (seawall-cost-2020-ins-perm)/((1 + discount) ^ (year - 2021))
      let seawall-cost-ins-discount-all (seawall-cost-2020-ins-all)/((1 + discount) ^ (year - 2021))

      let seawall-cost-ins-perm seawall-cost-ins-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
      let seawall-cost-ins-all seawall-cost-ins-discount-all * ((1 - external-financing-percent) * reduction-funding-access)


      let premium-estimates-sw foresight * premium-adjusted
      let premium-estimates-sw-discount (premium-estimates-sw)/((1 + discount) ^ (year - 2021))
      set insurance-sw-cost seawall-cost-ins-all + premium-estimates-sw-discount
      let max-insurance-coverage-sw max-flood-insurance-coverage * foresight
      ifelse thirty_year_damage_sw * (1 - deductible) > max-insurance-coverage-sw [
        set insurance-sw-damages max-insurance-coverage-sw]
      [set insurance-sw-damages thirty_year_damage_sw * (1 - deductible)]
      ;insruance-af-damages is the component of damages that insurance pays
      let insurance-sw-benefits (thirty_year_damage_af - (thirty_year_damage_sw - insurance-sw-damages)) * ej-weight


      ;option 3: build seawall alone
      let seawall-benefit (thirty_year_damage_af - thirty_year_damage_sw) * ej-weight
      let seawall-cost-2020-pt-1  (5300 * perimeter)
      let seawall-cost-2020-perm seawall-cost-2020-pt-1 + (seawall-cost-2020-pt-1 * permitting-cost-proportion)
      let seawall-cost-2020-all seawall-cost-2020-perm + (seawall-cost-2020-pt-1 * foresight * O_M_proportion)

      set seawall-cost-discount-perm (seawall-cost-2020-perm)/((1 + discount) ^ (year - 2021))
      set seawall-cost-discount-all (seawall-cost-2020-all)/((1 + discount) ^ (year - 2021))

      set seawall-cost-perm seawall-cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
      set seawall-cost-all seawall-cost-discount-all * ((1 - external-financing-percent) * reduction-funding-access)


      ;option 4: Do nothing

;COMMENT OUT BELOW FOR TEST
      let cost_list (list insurance-cost insurance-sw-cost seawall-cost-all)
      let benefit_list (list insurance-benefit insurance-sw-benefits seawall-benefit)
      set benefit_cost_list [0 0 0]
      set benefit_cost_list_behavior [0 0 0]
;      let cost_list (list seawall-cost)
;      let benefit_list (list seawall-benefit)
;      set benefit_cost_list [0]
;      set benefit_cost_list_behavior [0]
      set test-pos 0
      foreach cost_list[
        [x]-> let option-cost x
        set option-benefit item test-pos benefit_list
        ifelse option-benefit > 0 [
          set benefit_cost_list replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ifelse flood-reaction-property_owners = True [
             ifelse annual-expected-damage > 0 [
              let behave-ratio damage-time-step / annual-expected-damage
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio]
            [;no damage expected- less likely to adapt (assume 50% here)
              let behave-ratio .50
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio
            ]
          ]

          [set benefit_cost_list_behavior replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ]
        ]
        [set benefit_cost_list replace-item test-pos benefit_cost_list 0
          set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior 0
        ]
        set test-pos test-pos + 1
      ]

      let best-ratio max benefit_cost_list_behavior
      set identifier position best-ratio benefit_cost_list_behavior
      ;NOTE 2/27 ASSUMES PLANNED ADAPTATION COST INDICATES COST OF ADAPTATIONS ADN INSURANCE BOTH

;COMMENT OUT BELOW FOR TEST
      if best-ratio = 0 [
        set identifier 5]
      if identifier = 0 [
        set insurance-intention True
        set planned-adaptation-cost insurance-cost
      ]
      if identifier = 1[
        set insurance-intention True
        set adaptation-intention "local-seawall"
        set planned-adaptation-cost insurance-cost + seawall-cost-perm
      ]

      if identifier = 2[
;       if identifier = 0[
        set insurance-intention False
        set adaptation-intention "local-seawall"
        set planned-adaptation-cost seawall-cost-perm
      ]
      if identifier = 5[
;       if identifier = 1[
        ; no adaptation
        set insurance-intention False
        ]
    ]
        if adaptation = "local-seawall"[
        ;COMMENT OUT ALL CODE BELOW FOR TEST

          py:set "year" year
          property_owner-projected-damages-sw
      ;option 1: purchase insurance
      let insurance-coverage (1 - deductible) * annual-expected-damage-sw
      ifelse insurance-coverage > max-flood-insurance-coverage [
        set insurance-damages max-flood-insurance-coverage
      ]
      [set insurance-damages insurance-coverage]
      set insurance-damages (insurance-damages)/((1 + discount) ^ (year - 2021))
      let insurance-benefit (annual-expected-damage-sw - (annual-expected-damage-sw - insurance-damages)) * ej-weight
      set insurance-cost premium-adjusted / ((1 + discount) ^ (year - 2021))
      ifelse insurance-benefit > 0 [
        ifelse flood-reaction-property_owners = True [
            ifelse annual-expected-damage > 0[
          let behave-ratio damage-time-step / annual-expected-damage
              let altered_ratio (insurance-benefit / insurance-cost) * behave-ratio
          ifelse altered_ratio > 1 [
            set insurance-intention True
            set planned-adaptation-cost insurance-cost
        ]
          [set insurance-intention False]
        ]
            [let altered_ratio (insurance-benefit / insurance-cost) * 1
              ifelse altered_ratio > 1 [
            set insurance-intention True
                set planned-adaptation-cost insurance-cost]

          [set insurance-intention False]
          ]]
        [;no flood reaction
          let benefit-ratio insurance-benefit / insurance-cost
            ifelse benefit-ratio > 1[
              set insurance-intention True
              set planned-adaptation-cost insurance-cost
        ]
            [set insurance-intention False
            ]
      ]
        ]
      [;less than 0 benefit -> no adaptation
      ]

    ]
  ]
    [;mandatory-insurance = true
      if adaptation = "none" [
      ;calculate property_owner damags without any adaptation
      ;step 1: get the annual-expected-damage
        py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        property_owner-projected-damages
        set annual-expected-damage python-output

        ;step 2: get the baseline without any adaptation
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        property_owner-projected-damages
        set thirty_year_damage python-output

        ;step 3: get aquafence baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages
        let no_adapt_damages python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-af
        let af_damages python-output
        set thirty_year_damage_af no_adapt_damages + af_damages

        ;step 4: get seawall baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages
        let no_adapt_damages_1 python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages_1 + sw_damages


      ;option 1: insurance alone - 1 year time step
      let insurance-coverage (1 - deductible) * annual-expected-damage
      ifelse insurance-coverage > max-flood-insurance-coverage [
        set insurance-damages max-flood-insurance-coverage
      ]
      [set insurance-damages insurance-coverage]
      set insurance-damages (insurance-damages)/((1 + discount) ^ (year - 2021))
      let insurance-benefit (annual-expected-damage - (annual-expected-damage - insurance-damages)) * ej-weight
      set insurance-cost premium-adjusted / ((1 + discount) ^ (year - 2021))

      ;option 2: insurance with an aquafence - projects for length of 'foresight'
         ;damages with both are assumed to be 10% of aquafence damage

        let aquafence-cost-2020-ins-pt-1  500000 + (foresight * 40000)
             let aquafence-cost-2020-ins-perm aquafence-cost-2020-ins-pt-1 + (aquafence-cost-2020-ins-pt-1 * permitting-cost-proportion)
             let aquafence-cost-2020-ins-all aquafence-cost-2020-ins-perm + (aquafence-cost-2020-ins-pt-1 * foresight * O_M_proportion)

             let aquafence-cost-ins-discount-perm (aquafence-cost-2020-ins-perm)/((1 + discount) ^ (year - 2021))
             let aquafence-cost-ins-discount-all (aquafence-cost-2020-ins-all)/((1 + discount) ^ (year - 2021))

             let aquafence-cost-ins-perm aquafence-cost-ins-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
             let aquafence-cost-ins-all aquafence-cost-ins-discount-all * ((1 - external-financing-percent) * reduction-funding-access)

             let premium-estimates foresight *  premium-adjusted
             let premium-estimates-discount (premium-estimates) / ((1 + discount) ^ (year - 2021))
             set insurance-af-cost aquafence-cost-ins-all + premium-estimates-discount
             ;really this should be discounted
             let max-insurance-coverage max-flood-insurance-coverage * foresight
             ifelse thirty_year_damage_af * (1 - deductible) > max-insurance-coverage [
             set insurance-af-damages max-insurance-coverage]
             [set insurance-af-damages thirty_year_damage_af * (1 - deductible)]
             ;insruance-af-damages is the component of damages that insurance pays
             let insurance-af-benefits (thirty_year_damage - (thirty_year_damage_af - insurance-af-damages)) * ej-weight




      ;option 3: insurance with a seawall - projects for length of 'foresight'
          let seawall-cost-2020-ins-pt-1  (5300 * perimeter)
             let seawall-cost-2020-ins-perm seawall-cost-2020-ins-pt-1 + (seawall-cost-2020-ins-pt-1 * permitting-cost-proportion)
             let seawall-cost-2020-ins-all seawall-cost-2020-ins-perm + (seawall-cost-2020-ins-pt-1 * foresight * O_M_proportion)

             let seawall-cost-ins-discount-perm (seawall-cost-2020-ins-perm)/((1 + discount) ^ (year - 2021))
             let seawall-cost-ins-discount-all (seawall-cost-2020-ins-all)/((1 + discount) ^ (year - 2021))

             let seawall-cost-ins-perm seawall-cost-ins-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
             let seawall-cost-ins-all seawall-cost-ins-discount-all * ((1 - external-financing-percent) * reduction-funding-access)

             let premium-estimates-sw foresight * premium-adjusted
             let premium-estimates-sw-discount (premium-estimates-sw)/((1 + discount) ^ (year - 2021))
             set insurance-sw-cost seawall-cost-ins-all + premium-estimates-sw-discount
             let max-insurance-coverage-sw max-flood-insurance-coverage * foresight
             ifelse thirty_year_damage_sw * (1 - deductible) > max-insurance-coverage-sw [
             set insurance-sw-damages max-insurance-coverage-sw]
             [set insurance-sw-damages thirty_year_damage_sw * (1 - deductible)]
             ;insruance-af-damages is the component of damages that insurance pays
             let insurance-sw-benefits (thirty_year_damage - (thirty_year_damage_sw - insurance-sw-damages)) * ej-weight


      ;now we need to set ratios.....
         ;the following are our parameters:
           ;insurance-cost, insurance-benefit
           ;insurance-af-cost, insurance-af-benefit
           ;insurance-sw-cost, insurance-sw-benefit
           ;aquafence-cost, aquafence-benefit
           ;seawall-cost, seawall-benefit

      let cost_list (list insurance-cost insurance-af-cost insurance-sw-cost)
      let benefit_list (list insurance-benefit insurance-af-benefits insurance-sw-benefits)
      set benefit_cost_list [0 0 0]
      set benefit_cost_list_behavior [0 0 0]
      set test-pos 0
      foreach cost_list[
        [x]-> let option-cost x
        set option-benefit item test-pos benefit_list
        ifelse option-benefit > 0 [
          set benefit_cost_list replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ifelse flood-reaction-property_owners = True [
             ifelse annual-expected-damage > 0 [
              let behave-ratio damage-time-step / annual-expected-damage
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio]
            [;no damage expected- less likely to adapt (assume 50% here)
              let behave-ratio .50
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio
            ]
          ]

          [set benefit_cost_list_behavior replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ]
        ]
        [set benefit_cost_list replace-item test-pos benefit_cost_list 0
          set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior 0
        ]
        set test-pos test-pos + 1
      ]

      let best-ratio max benefit_cost_list_behavior
      set identifier position best-ratio benefit_cost_list_behavior
      ;NOTE 2/27 ASSUMES PLANNED ADAPTATION COST INDICATES COST OF ADAPTATIONS ADN INSURANCE BOTH
      if best-ratio = 0 [
        set identifier 5]
      if identifier = 0 [
        set insurance-intention True
        set planned-adaptation-cost insurance-cost
      ]
      if identifier = 1[
        set insurance-intention True
        set adaptation-intention "aquafence"
        set planned-adaptation-cost insurance-cost + aquafence-cost-ins-perm
      ]
      if identifier = 2[
        set insurance-intention True
        set adaptation-intention "local-seawall"
        set planned-adaptation-cost insurance-cost + seawall-cost-ins-perm
      ]
      if identifier = 5[
        ; no adaptation
        set insurance-intention true
        set planned-adaptation-cost insurance-cost
        ]
    ]


    if adaptation = "aquafence" [
      ;step 1: get the annual-expected-damage
        py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        property_owner-projected-damages-af
        set annual-expected-damage python-output

        ;step 2: get the baseline without any adaptation
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        property_owner-projected-damages-af
        set thirty_year_damage_af python-output

        ;step 4: get seawall baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages-af
        let no_adapt_damages_1 python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages_1 + sw_damages

      ;option 1: purchase insurance
      let insurance-coverage (1 - deductible) * annual-expected-damage-af
      ifelse insurance-coverage > max-flood-insurance-coverage [
        set insurance-damages max-flood-insurance-coverage
      ]
      [set insurance-damages insurance-coverage]
      set insurance-damages (insurance-damages)/((1 + discount) ^ (year - 2021))
      let insurance-benefit (annual-expected-damage-af - (annual-expected-damage-af - insurance-damages)) * ej-weight
      set insurance-cost premium-adjusted / ((1 + discount) ^ (year - 2021))

      ;option 2: purchase insurance and build seawall

      let seawall-cost-2020-ins-pt-1  (5300 * perimeter)
             let seawall-cost-2020-ins-perm seawall-cost-2020-ins-pt-1 + (seawall-cost-2020-ins-pt-1 * permitting-cost-proportion)
             let seawall-cost-2020-ins-all seawall-cost-2020-ins-perm + (seawall-cost-2020-ins-pt-1 * foresight * O_M_proportion)

             let seawall-cost-ins-discount-perm (seawall-cost-2020-ins-perm)/((1 + discount) ^ (year - 2021))
             let seawall-cost-ins-discount-all (seawall-cost-2020-ins-all)/((1 + discount) ^ (year - 2021))

             let seawall-cost-ins-perm seawall-cost-ins-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
             let seawall-cost-ins-all seawall-cost-ins-discount-all * ((1 - external-financing-percent) * reduction-funding-access)

             let premium-estimates-sw foresight * premium-adjusted
             let premium-estimates-sw-discount (premium-estimates-sw)/((1 + discount) ^ (year - 2021))
             set insurance-sw-cost seawall-cost-ins-all + premium-estimates-sw-discount
             let max-insurance-coverage-sw max-flood-insurance-coverage * foresight
             ifelse thirty_year_damage_sw * (1 - deductible) > max-insurance-coverage-sw [
             set insurance-sw-damages max-insurance-coverage-sw]
             [set insurance-sw-damages thirty_year_damage_sw * (1 - deductible)]
             ;insruance-af-damages is the component of damages that insurance pays
             let insurance-sw-benefits (thirty_year_damage - (thirty_year_damage_sw - insurance-sw-damages)) * ej-weight


      let cost_list (list insurance-cost insurance-sw-cost)
      let benefit_list (list insurance-benefit insurance-sw-benefits)
      set benefit_cost_list [0 0]
      set benefit_cost_list_behavior [0 0]
      set test-pos 0
      foreach cost_list[
        [x]-> let option-cost x
        set option-benefit item test-pos benefit_list
        ifelse option-benefit > 0 [
          set benefit_cost_list replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ifelse flood-reaction-property_owners = True [
             ifelse annual-expected-damage > 0 [
              let behave-ratio damage-time-step / annual-expected-damage
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio]
            [;no damage expected- less likely to adapt (assume 50% here)
              let behave-ratio 1
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio
            ]
          ]

          [set benefit_cost_list_behavior replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ]
        ]
        [set benefit_cost_list replace-item test-pos benefit_cost_list 0
          set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior 0
        ]
        set test-pos test-pos + 1
      ]

      let best-ratio max benefit_cost_list_behavior
      set identifier position best-ratio benefit_cost_list_behavior
      ;NOTE 2/27 ASSUMES PLANNED ADAPTATION COST INDICATES COST OF ADAPTATIONS ADN INSURANCE BOTH
      if best-ratio = 0 [
        set identifier 0]
      if identifier = 0 [
        set insurance-intention True
        set planned-adaptation-cost insurance-cost
      ]
      if identifier = 1[
        set insurance-intention True
        set adaptation-intention "local-seawall"
        set planned-adaptation-cost insurance-cost + seawall-cost-ins-perm
      ]

    ]
        if adaptation = "local-seawall"[
          py:set "year" year
          property_owner-projected-damages-sw
      ;option 1: purchase insurance
      let insurance-coverage (1 - deductible) * annual-expected-damage-sw
      ifelse insurance-coverage > max-flood-insurance-coverage [
        set insurance-damages max-flood-insurance-coverage
      ]
      [set insurance-damages insurance-coverage]
      set insurance-damages (insurance-damages)/((1 + discount) ^ (year - 2021))
      let insurance-benefit (annual-expected-damage-sw - (annual-expected-damage-sw - insurance-damages)) * ej-weight
      set insurance-cost premium-adjusted / ((1 + discount) ^ (year - 2021))
      ifelse insurance-benefit > 0 [
        ifelse flood-reaction-property_owners = True [
          ifelse annual-expected-damage > 0 [
          let behave-ratio damage-time-step / annual-expected-damage
          let altered_ratio (insurance-benefit / insurance-cost) * behave-ratio
          ifelse altered_ratio > 1 [
            set insurance-intention True
            set planned-adaptation-cost insurance-cost
        ]
          [set insurance-intention True
              set planned-adaptation-cost insurance-cost]
          ]
          [
          let altered_ratio (insurance-benefit / insurance-cost) * 1
          ifelse altered_ratio > 1 [
            set insurance-intention True
            set planned-adaptation-cost insurance-cost
        ]
          [set insurance-intention True
              set planned-adaptation-cost insurance-cost]
            ]


          ]
        [;no flood reaction
          let benefit-ratio insurance-benefit / insurance-cost
            ifelse benefit-ratio > 1[
              set insurance-intention True
              set planned-adaptation-cost insurance-cost
        ]
            [set insurance-intention True
              set planned-adaptation-cost insurance-cost
            ]
      ]
        ]
      [;less than 0 benefit -> no adaptation
      ]

  ]
    ]
    ]
  ]

  ask MBTA-agents[
    ifelse mbta-adaptation-method = "all-at-once" [
      mbta-adaptation-decision-all-at-once]
    [mbta-adaptation-decision-segments
    ]
  ]


  ask private-assets [
    set foresight foresight-mun-pas-mbta
    if name = "BOS-air" [
      set adapt-test-mun item 4 boston-adaptation-list
    ifelse prioritization-method = "EJ" [
      set ej-weight item 6 harbor-region-EJ-weights]
      [set ej-weight 1]
    ]
    if name = "BOS-air" [
      set adapt-test-mun first [adaptation] of municipalities with [label = "north-shore"]
      ifelse prioritization-method = "EJ" [
      set ej-weight item 0 harbor-region-EJ-weights]
      [set ej-weight 1]
    ]


    ;note that this process is the same for property_owners + pas
    ifelse adapt-test-mun = "seawall" [
    set flood-protect-height municipal-sw-height]
    [set flood-protect-height 0]

    ifelse adaptation = "none" [
      ;step 1 get annual damages
      py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        PA-projected-damages
        set annual-expected-damage python-output

        ;step 2: get the baseline without any adaptation
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        PA-projected-damages
        set thirty_year_damage python-output

        ;step 3: get aquafence baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        PA-projected-damages
        let no_adapt_damages python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        PA-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages + sw_damages


      let seawall-benefit (thirty_year_damage - thirty_year_damage_sw) * ej-weight
           if seawall-benefit > 0 [
           let cost-2020-pt-1 (5300 * perimeter)
           let cost-2020-perm cost-2020-pt-1 + (cost-2020-pt-1 * permitting-cost-proportion)
           let cost-2020-all cost-2020-perm + (cost-2020-pt-1 * foresight * O_M_proportion)
           let cost-discount-perm (cost-2020-perm)/((1 + discount) ^ (year - 2021))
           let cost-discount-all (cost-2020-all)/((1 + discount) ^ (year - 2021))
           let cost-perm cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
           let cost-all cost-discount-all * ((1 - external-financing-percent) * reduction-funding-access)
           set cost-benefit-seawall seawall-benefit / cost-all
           if flood-reaction-property_owners = True [
          if annual-expected-damage > 0 [
               let behave-ratio damage-time-step / annual-expected-damage-af
            set cost-benefit-seawall cost-benefit-seawall * behave-ratio]
           ]

           if cost-benefit-seawall > 1[
             set adaptation-intention "on-site-seawall"
             set planned-adaptation-cost cost-perm]
        ]
    ]

    [;there is already an on-site seawall- nothing to do...
    ]
  ]

end

to mbta-adaptation-decision-all-at-once
  ;Note: No EJ weighting beaucause it is relative to the whole region and the entire system would be adapted at once

    set foresight foresight-mun-pas-mbta

  ;step 1: get the annual-expected-damage
  py:set "year" year
  py:set "max_range" 1
  setup-python-calcs-mbta
  mbta-projected-damages
  set annual-expected-damage python-output

  py:set "year" year
  py:set "max_range" 1
  setup-python-calcs-mbta
  mbta-projected-damages-sw
  set annual-expected-damage-sw python-output

  ;step 2: get the baseline without any adaptation
        setup-python-calcs-mbta
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        mbta-projected-damages
        set thirty_year_damage python-output

        ;step 3: get sw baseline
        setup-python-calcs-mbta
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        mbta-projected-damages
        let no_adapt_damages python-output
        setup-python-calcs-mbta
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        mbta-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages + sw_damages

    set additional-damage 0
    set annual-expected-damage-region 0
    set test-pos 0
    let adaptation-list-start boston-adaptation-list
    ;list below is damages according to [NS SS Allston Backbay Charlestown Downtown East-Boston Fenway north-dorchester south-boston south-dorchester]
    let adaptation-ns first [adaptation] of municipalities with [name = "north-shore"]
    let adaptation-ss first [adaptation] of municipalities with [name = "south-shore"]
    let adaptation-list-with-ss insert-item 0 adaptation-list-start adaptation-ss
    let adaptation-list-full insert-item 0 adaptation-list-with-ss adaptation-ns
    set mbta-damage-list-ra (list 0.10 0.10 0.02 0.02 0.02 0.10 0.15 0.02 0.05 0.40 0.02)
    if adaptation = "none" [
    set test-pos 0
    foreach adaptation-list-full[
      [x]-> set current-adapt x
      let percent-dam item test-pos mbta-damage-list-ra

      if current-adapt = "none"[
        let damage-from-region percent-dam * thirty_year_damage
        set additional-damage additional-damage + damage-from-region
        let annual-expected-component percent-dam * annual-expected-damage
        set annual-expected-damage-region annual-expected-damage-region + annual-expected-component
      ]
      if current-adapt = "seawall" [
        ;damage is expected to be for more than 15 feet
        let damage-from-region percent-dam * thirty_year_damage_sw
        set additional-damage additional-damage + damage-from-region
        let annual-expected-component percent-dam * annual-expected-damage-sw
        set annual-expected-damage-region annual-expected-damage-region + annual-expected-component
  ]
      set test-pos test-pos + 1
  ]
    let seawall-benefit (additional-damage - thirty_year_damage_sw)
;        ;;;output-print("Benefit of Seawall")
;        ;;;output-print(seawall-benefit)
        ifelse seawall-benefit > 0 [
          ;let cost-2020 6600000000
        let cost-2020 mbta-cost-2020
        let cost-2020-perm cost-2020 + (cost-2020 * permitting-cost-proportion)
        let cost-2020-all cost-2020-perm + (cost-2020 * foresight * O_M_proportion)
        let cost-discount-perm (cost-2020-perm)/((1 + discount) ^ (year - 2021))
        let cost-discount-all (cost-2020-all)/((1 + discount) ^ (year - 2021))
          let cost-perm cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
      let cost-all cost-discount-all * ((1 - external-financing-percent) * reduction-funding-access)
          set potential-sw-cost cost-all
;          ;;;output-print("Cost/Benefit ratio")
;          ;;;output-print(cost / seawall-benefit)
          set cost-benefit-seawall seawall-benefit / potential-sw-cost
      ;careful that this is let not set
          if flood-reaction-mbta = True [
           if annual-expected-damage > 0[
            let behave-ratio damage-time-step / annual-expected-damage
          set cost-benefit-seawall cost-benefit-seawall * behave-ratio]
      ]
          ifelse cost-benefit-seawall > 1 [
             set adaptation-intention "on-site-seawall"
             set planned-adaptation-cost cost-perm]
             [;cost-benefit < 1
              set adaptation-intention "none"
              set planned-adaptation-cost 0]
          ]
    [;seawall-benefit < 0
      set adaptation-intention "none"
      set planned-adaptation-cost 0]
  ]


  if adaptation = "on-site-seawall"[
    ;nothing else to do
  ]

end

to mbta-adaptation-decision-segments
    ;we have one damage expected damage calculation so we can start as normal there, then go through segement by segment
    set foresight foresight-mun-pas-mbta
    setup-python-calcs-mbta
    mbta-projected-damages
    mbta-projected-damages-sw
set foresight foresight-mun-pas-mbta

  ;step 1: get the annual-expected-damage
  py:set "year" year
  py:set "max_range" 1
  setup-python-calcs-mbta
  mbta-projected-damages
  set annual-expected-damage python-output

  py:set "year" year
  py:set "max_range" 1
  setup-python-calcs-mbta
  mbta-projected-damages-sw
  set annual-expected-damage-sw python-output

  ;step 2: get the baseline without any adaptation
        setup-python-calcs-mbta
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        mbta-projected-damages
        set thirty_year_damage python-output

        ;step 3: get sw baseline
        setup-python-calcs-mbta
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        mbta-projected-damages
        let no_adapt_damages python-output
        setup-python-calcs-mbta
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        mbta-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages + sw_damages
    ;we have the following lists:
   ; mbta-adaptation-list
   ;mbta-adaptation-intention-list
   ;mbta-adaptation-cost-list
   ;mbta-benefit-cost-ratio-list
   ;mbta-planned-adaptation-cost-list
  set mbta-cost-proportion-list [0.025 0.025 0.05 0.05 0.1 0.25 0.25 0.05 0.025 0.15 0.025]
  set mbta-damage-proportion-list (list 0.10 0.10 0.02 0.02 0.02 0.10 0.15 0.02 0.05 0.40 0.02)

    let adaptation-list-start boston-adaptation-list
    ;list below is damages according to [NS SS Allston Backbay Charlestown Downtown East-Boston Fenway north-dorchester south-boston south-dorchester]
    let adaptation-ns first [adaptation] of municipalities with [name = "north-shore"]
    let adaptation-ss first [adaptation] of municipalities with [name = "south-shore"]
    let adaptation-list-with-ss insert-item 0 adaptation-list-start adaptation-ss
    let adaptation-list-full insert-item 0 adaptation-list-with-ss adaptation-ns
    set mbta-damage-list-ra (list 0.10 0.10 0.02 0.02 0.02 0.10 0.15 0.02 0.05 0.40 0.02)

   ;for each segment of mbta we have to
     ;1) evaluate if mbta has a sw segment there -> nothing else to do if so
     ;2) evaluate if a municipal sw is there
        ;3) evaluate no-sw damage
        ;4) evaluate sw-damage
        ;5) calculate cost to protect that segment (according to cost-proportion from max cost)
        ;6) calcualte benefit-cost-ratio for each section
        ;7) determine adaptation intention

 set test-pos 0
  ;need to calculate annual-expected-damage that takes into account whether or not the Seawall is there for that section of the T- need to think about this one....not so easy to do...
 foreach adaptation-list-full [
    [x] -> set current-adapt x
    let mbta-segment-adapt item test-pos mbta-adaptation-list
    let mbta-adaptation-cost-percent item test-pos mbta-cost-proportion-list
    let mbta-damage-prop item test-pos mbta-damage-proportion-list
    ;for the point of getting this across, let's assume that all sws are constructed to 15 ft NAV-88
    ifelse prioritization-method = "EJ" [
      set ej-weight item test-pos harbor-region-EJ-weights]
    [set ej-weight 1]
    ifelse mbta-segment-adapt = "none" [
      ifelse current-adapt = "none" [
        ;no mbta protection and no municipal protection
      let damage-in-region mbta-damage-prop * thirty_year_damage
      let damage-with-seawall mbta-damage-prop * thirty_year_damage_sw
      let cost-in-region mbta-adaptation-cost-percent * mbta-cost-2020
      let cost-in-region-perm cost-in-region + (cost-in-region * permitting-cost-proportion)
      let cost-in-region-all cost-in-region-perm + (cost-in-region * foresight * O_M_proportion)
      let cost-discount-perm (cost-in-region-perm)/((1 + discount) ^ (year - 2021))
      let cost-discount-all (cost-in-region-all)/((1 + discount) ^ (year - 2021))
      let cost-perm cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
      let cost-all cost-discount-all * ((1 - external-financing-percent) * reduction-funding-access)
      let sw-benefit (thirty_year_damage - thirty_year_damage_sw) * ej-weight
      set segment-ben-cost-ratio sw-benefit / cost-all
      set mbta-planned-adaptation-cost-list replace-item test-pos mbta-planned-adaptation-cost-list cost-perm

      if flood-reaction-mbta = True [
           ifelse annual-expected-damage > 0[
            let behave-ratio (damage-time-step) / annual-expected-damage
            set segment-ben-cost-ratio segment-ben-cost-ratio * behave-ratio]
          [let behave-ratio 0.5
            set segment-ben-cost-ratio segment-ben-cost-ratio * behave-ratio]
      ]
        set mbta-benefit-cost-ratio-list replace-item test-pos mbta-benefit-cost-ratio-list segment-ben-cost-ratio
        if segment-ben-cost-ratio > 1 [
          set mbta-adaptation-intention-list replace-item test-pos mbta-adaptation-intention-list "seawall"
        ]
      ]
      [;municipal seawall is in place
        ;no point in adapting- protection is already to 15 ft NAV88, which is established max
      ]
      ;general adaptation directions go here if we incorporate the sw height problem fully
    ]
    [;nothing else to do - sw is in place for the MBTA- there should be no directions below
    ]
    set test-pos test-pos + 1
  ]
end


to adaptation-decision-regional-authority
  ask municipalities [
    set foresight foresight-mun-pas-mbta
    ifelse name = "boston" [
      py:set "slr_proj" mun-slr-proj
      py:set "year" year
      py:set "discount" discount
      py:set "AEP" mun-aep-list
      adaptation-decision-boston-ra
    ]
    [;not for boston
       setup-municipal-python
        py:set "year" year
        py:set "max_range" 1
        municipality-projected-damages
        set annual-expected-damage python-output
        ;step 2: calculate the damages that would happen without a seawall in place
        setup-municipal-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        municipality-projected-damages
        set thirty_year_damage python-output
        ;step 3: calculate damages that would occur with a seawall in place
        setup-municipal-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        municipality-projected-damages
        let damage_wout_adaptation python-output
        setup-municipal-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - (permitting-delay)
        municipality-projected-damages-sw
        let damage_w_adaptation python-output
        set thirty_year_damage_sw (damage_wout_adaptation + damage_w_adaptation)
      let cost-2020 coastline * 7500
      let cost-2020-perm cost-2020 + (cost-2020 * permitting-cost-proportion) + (cost-2020 * maintenance-fee)
      let cost-2020-all cost-2020-perm + (cost-2020 * foresight * O_M_proportion)
      let potential-sw-cost-perm-discount (cost-2020-perm)/((1 + discount) ^ (year - 2021))
      let potential-sw-cost-all-discount (cost-2020-all)/((1 + discount) ^ (year - 2021))
      set potential-sw-cost-perm potential-sw-cost-perm-discount * (1 - external-financing-percent)
      set potential-sw-cost-all potential-sw-cost-all-discount * (1 - external-financing-percent)
    ]
  ]

  ask property_owners[
    set foresight foresight-property_owners
    setup-property_owner-python
    let loc-test [region] of patch-here
    ;assumes location in downtown if we are located in boston - NEEDS TO BE CHANGED IN TIME
    ifelse dev-region = "boston" [
    set adapt-test-mun item 4 boston-adaptation-list
    set premium-adjusted premium * (1 - crs-discount)

    ]


    ;otherwise we are protected or not by municipal sw
   [set adapt-test-mun first [adaptation] of municipalities with [label = loc-test]]

    ;calculate EJ weights

    ifelse prioritization-method = "EJ" [
      if loc-test = "north-shore" [
        set ej-weight item 0 harbor-region-EJ-weights]
      if loc-test = "south-shore" [
        set ej-weight item 1 harbor-region-EJ-weights]
      if loc-test = "boston" [
        set ej-weight item 6 harbor-region-EJ-weights]]
    [set ej-weight 1]


    ifelse adapt-test-mun = "seawall" [
      set crs-discount 0.3
    set flood-protect-height municipal-sw-height

    ]
    [set flood-protect-height 0
    set crs-discount 0.0]
    set premium-adjusted premium * (1 - crs-discount)

    ifelse insurance-module? = False [
      ;do nothing- there are no independent adaptations (insurance)
    ]
    [;insurance module is true
     ifelse mandatory-insurance? = false [
        ;output-print("no mandatory insurance")
             ;calculate property_owner damags without any adaptation
        ;step 1: get the annual-expected-damage
        py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        property_owner-projected-damages
        set annual-expected-damage python-output

        ;step 2: get the baseline without any adaptation
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        property_owner-projected-damages
        set thirty_year_damage python-output

        ;step 4: get seawall baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages
        let no_adapt_damages_1 python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages_1 + sw_damages
;

;             property_owner-projected-damages
;             py:set "year" year
             ;option 1: insurance alone - 1 year time step
             let insurance-coverage (1 - deductible) * annual-expected-damage
             ifelse insurance-coverage > max-flood-insurance-coverage [
             set insurance-damages max-flood-insurance-coverage
             ]
             [set insurance-damages insurance-coverage]
             set insurance-damages (insurance-damages)/((1 + discount) ^ (year - 2021))
             let insurance-benefit (annual-expected-damage - (annual-expected-damage - insurance-damages)) * ej-weight
             set insurance-cost premium-adjusted / ((1 + discount) ^ (year - 2021))

      ifelse flood-reaction-property_owners = True [
              ifelse annual-expected-damage > 0 [
            ;output-print("made it this far")
              let behave-ratio damage-time-step / annual-expected-damage
              let altered_ratio (insurance-benefit / insurance-cost) * behave-ratio
            set ins-ben-cost altered_ratio]
            [;no damage expected- less likely to adapt (assume 50% here)
              let behave-ratio 1
              let altered_ratio (insurance-benefit / insurance-cost) * behave-ratio
            set ins-ben-cost altered_ratio]
            ]

        [;flood reaction is not happening= benefit-cost-ratio remains
          set ins-ben-cost insurance-benefit / insurance-cost
        ]
        ifelse ins-ben-cost > 1 [
            set insurance-intention True
            set planned-adaptation-cost insurance-cost
        ]
        [;insurance not worth it
          set insurance-intention False
          set planned-adaptation-cost 0
        ]

      ]
      [;mandatory insurance is true
        set insurance-intention True
        set insurance-cost premium-adjusted / ((1 + discount) ^ (year - 2021))
        set planned-adaptation-cost insurance-cost

      ]

    ]

  ]

  ask MBTA-agents[
    set foresight foresight-mun-pas-mbta
    set additional-damage 0
    set annual-expected-damage-region 0
    set annual-expected-damage 0
    set test-pos 0
    let adaptation-list-start boston-adaptation-list
    ;list below is damages according to [NS SS Allston Backbay Charlestown Downtown East-Boston Fenway north-dorchester south-boston south-dorchester]
    let adaptation-ns first [adaptation] of municipalities with [name = "north-shore"]
    let adaptation-ss first [adaptation] of municipalities with [name = "south-shore"]
    let adaptation-list-with-ss insert-item 0 adaptation-list-start adaptation-ss
    let adaptation-list-full insert-item 0 adaptation-list-with-ss adaptation-ns
    set mbta-damage-list-ra (list 0.10 0.10 0.02 0.02 0.02 0.10 0.15 0.02 0.05 0.40 0.02)
    setup-python-calcs-mbta

  ;step 1: get the annual-expected-damage
  py:set "year" year
  py:set "max_range" 1
  setup-python-calcs-mbta
  mbta-projected-damages
  set annual-expected-damage python-output

  py:set "year" year
  py:set "max_range" 1
  setup-python-calcs-mbta
  mbta-projected-damages-sw
  set annual-expected-damage-sw python-output

  ;step 2: get the baseline without any adaptation
        setup-python-calcs-mbta
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        mbta-projected-damages
        set thirty_year_damage python-output

        ;step 3: get sw baseline
        setup-python-calcs-mbta
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        mbta-projected-damages
        let no_adapt_damages python-output
        setup-python-calcs-mbta
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        mbta-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages + sw_damages

    set test-pos 0
    foreach adaptation-list-full[
      [x]-> set current-adapt x
      let percent-dam item test-pos mbta-damage-list-ra
        let damage-from-region percent-dam * thirty_year_damage
        set additional-damage additional-damage + damage-from-region
        let annual-expected-component percent-dam * annual-expected-damage
        set annual-expected-damage-region annual-expected-damage-region + annual-expected-component
        set test-pos test-pos + 1
  ]
  ]

  ask private-assets [
    set foresight foresight-mun-pas-mbta
      py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        PA-projected-damages
        set annual-expected-damage python-output

        ;step 2: get the baseline without any adaptation
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        PA-projected-damages
        set thirty_year_damage python-output

        ;step 3: get aquafence baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        PA-projected-damages
        let no_adapt_damages python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        PA-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages + sw_damages

  ]

  ;Now, let's assemble all of the damages into something useful

  ;sets global for NS 30-year damage
  set thirty_year_damage_ns_mun first [thirty_year_damage] of municipalities with [name = "north-shore"]
  ;sets global for NS 30-year damage with seawall in place
  set thirty_year_damage_ns_sw_mun first [thirty_year_damage_sw] of municipalities with [name = "north-shore"]
  ;sets temp variable for seawall beneift for the NS municipality
  let sw_benefit_ns_mun thirty_year_damage_ns_mun - thirty_year_damage_ns_sw_mun
  ;repeats for SS municipality
  set thirty_year_damage_ss_mun first [thirty_year_damage] of municipalities with [name = "south-shore"]
  set thirty_year_damage_ns_sw_mun first [thirty_year_damage_sw] of municipalities with [name = "south-shore"]
  let sw_benefit_ss_mun thirty_year_damage_ss_mun - thirty_year_damage_ss_sw_mun
  ;and for boston-logan
  let bos-logan_thirty_year first [thirty_year_damage] of private-assets with [name = "BOS-air"]
  let bos-logan_thirty_year_sw first [thirty_year_damage_sw] of private-assets with [name = "BOS-air"]
  let sw_benefit_bos_logan bos-logan_thirty_year - bos-logan_thirty_year_sw
  ;and food distribution
  let food_dist_thirty_year first [thirty_year_damage] of private-assets with [name = "food dist"]
  let food_dist_thirty_year_sw first [thirty_year_damage_sw] of private-assets with [name = "food dist"]
  let sw_benefit_food_dist food_dist_thirty_year - food_dist_thirty_year_sw
  ;and mbta
  let mbta_thirty_year first [thirty_year_damage] of MBTA-agents
  let mbta_thirty_year_sw first [thirty_year_damage_sw] of MBTA-agents
  let mbta_damage_avoided mbta_thirty_year - mbta_thirty_year_sw
  ;and ns property_owner
  let thirty_year_damage_ns_dev sum [thirty_year_damage] of property_owners with [dev-region = "north-shore"]
  let thirty_year_damage_ns_sw_dev sum [thirty_year_damage_sw] of property_owners with [dev-region = "north-shore"]
  let sw_benefit_ns_dev thirty_year_damage_ns_dev - thirty_year_damage_ns_sw_dev
  ;and ss property_owner
  let thirty_year_damage_ss_dev sum [thirty_year_damage] of property_owners with [dev-region = "south-shore"]
  let thirty_year_damage_ss_sw_dev sum [thirty_year_damage_sw] of property_owners with [dev-region = "south-shore"]
  let sw_benefit_ss_dev thirty_year_damage_ns_dev - thirty_year_damage_ss_sw_dev
  ;and boston property_owner
  let thirty_year_damage_bos_dev sum [thirty_year_damage] of property_owners with [dev-region = "boston"]
  let thirty_year_damage_bos_sw_dev sum [thirty_year_damage_sw] of property_owners with [dev-region = "boston"]
  let sw_benefit_bos_dev thirty_year_damage_bos_dev - thirty_year_damage_bos_sw_dev


  set test-pos 0
  ;for i in boston-thirty-year-damage list
  foreach boston-thirty-year-damage-list [
    ;no-sw-damage = boston-thirty-year-damage-list[i]
    [x]-> let no-sw-damage x
    ;sw-damage = boston-thirty-year-damage-sw-list[i]
    let sw-damage item test-pos boston-thirty-year-damage-sw-list
    ;calculate costs-avoided for i
    let costs-avoided no-sw-damage - sw-damage
    ;set the costs avoided in the list
    ;NOTE (1/30): 'test-pos' used to read 0 -> check this process
    set boston-seawall-costs-avoided-list replace-item test-pos boston-seawall-costs-avoided-list costs-avoided
    set test-pos test-pos + 1]

  ;the code below looks at each segment of seawall independently
  ;note: with lots of property_owners, we will have to think about how to do this...some cheats were done in the code because there were only 3 property_owners (1/30)

  ;Let's calculate a local or regional behavior ratio?
  ;let regional-damage sum [damage-time-step] of turtles
  ;set behave-ratio-ra 0

  let expected-mun-damages sum [annual-expected-damage] of municipalities
  let expected-dev-damages sum [annual-expected-damage] of property_owners

  ;Calculate adjustment if need

  ifelse flood-reaction-municipalities = True[
    let ra-total-annual-expected-damage (sum([annual-expected-damage] of municipalities) + sum([annual-expected-damage] of mbta-agents) + sum([annual-expected-damage] of private-assets) + sum([annual-expected-damage] of property_owners))
    ifelse ra-total-annual-expected-damage > 0[
        ;output-print(ra-total-annual-expected-damage)
        let ra-total-experienced-damage  (sum([damage-time-step] of municipalities) + sum([damage-time-step] of mbta-agents) + sum([damage-time-step] of private-assets) + sum([damage-time-step] of property_owners))
        set ra-behave-modifier ra-total-experienced-damage / ra-total-annual-expected-damage
      ;output-print("new time step")
      ;output-print(ra-total-experienced-damage)
      ;output-print(ra-total-annual-expected-damage)
     ; output-print(ra-behave-modifier)
      ]
      [;expected damages are less than 1
      set ra-behave-modifier 0.0001
      ]


;        if annual-expected-damage > 0 [
;        let behave-ratio (first [damage-time-step] of municipalities with [name = "boston"]) / annual-expected-damage
;          set cost-benefit-seawall-bos cost-benefit-seawall-bos * behave-ratio]
        ]
  [set ra-behave-modifier 1]

  ;NS
  ;add all agents protected by a NS seawall up together (note: could do this with patch)
  ifelse prioritization-method = "EJ" [
    set ej-weight item 0 harbor-region-EJ-weights]
  [set ej-weight 1]
  let ns_damages_avoided (sw_benefit_ns_mun + 0.1 * mbta_damage_avoided + sw_benefit_ns_dev + sw_benefit_food_dist) * ej-weight
  ;seawall cost was estimated with municipality
  let ns_cost first [potential-sw-cost-all] of municipalities with [name = "north-shore"]
  let ns_cost_perm first [potential-sw-cost-perm] of municipalities with [name = "north-shore"]
  if ns_cost > 0 [
    set b-c-ratio (ns_damages_avoided /  ns_cost) * ra-behave-modifier]
  ;not sure why I did this...should be impossible for a negative cost (1/30)
  if ns_cost < 0 [
    ;set b-c-ratio ns_damages_avoided /  .00001
    set b-c-ratio 0]
  set ra-benefit-cost-ratio-list (replace-item 0 ra-benefit-cost-ratio-list b-c-ratio)
  if b-c-ratio > 1 [
    ;change adaptation-intention if the calculations show benefit is worth it
    set ra-adaptation-intention-list (replace-item 0 ra-adaptation-intention-list "seawall")
    set ra-planned-adaptation-cost-list replace-item 0 ra-planned-adaptation-cost-list ns_cost_perm]


  ;ss
  ifelse prioritization-method = "EJ" [
    set ej-weight item 1 harbor-region-EJ-weights]
  [set ej-weight 1]
  let ss_damages_avoided (sw_benefit_ss_mun +  0.1 * mbta_damage_avoided + sw_benefit_ss_dev ) * ej-weight
  let ss_cost first [potential-sw-cost-all] of municipalities with [name = "south-shore"]
  let ss_cost_perm first [potential-sw-cost-perm] of municipalities with [name = "south-shore"]
  if ss_cost > 0 [
    set b-c-ratio (ss_damages_avoided /  ss_cost) * ra-behave-modifier]
  if ss_cost < 0 [
    ;set b-c-ratio ss_damages_avoided /  .00001]
    set b-c-ratio 0]
  set ra-benefit-cost-ratio-list (replace-item 1 ra-benefit-cost-ratio-list b-c-ratio)
  if b-c-ratio > 1 [
    set ra-adaptation-intention-list replace-item 1 ra-adaptation-intention-list "seawall"
    set ra-planned-adaptation-cost-list replace-item 1 ra-planned-adaptation-cost-list ss_cost_perm]

  ;NOTE:maintenance fee for boston is added bellow in boston adaptation decision function
  ;allston
  ifelse prioritization-method = "EJ" [
    set ej-weight item 2 harbor-region-EJ-weights]
  [set ej-weight 1]
  let allston_damage_avoided ((item 0 boston-seawall-costs-avoided-list) + .02 * mbta_damage_avoided) * ej-weight
  let allston_cost item 0 boston-planned-adaptation-cost-list-om
   if allston_cost > 0 [
    set b-c-ratio (allston_damage_avoided / allston_cost) * ra-behave-modifier]
  if allston_cost < 0 [
    ;set b-c-ratio allston_damage_avoided /  .00001]
    set b-c-ratio 0]
  set ra-benefit-cost-ratio-list (replace-item 2 ra-benefit-cost-ratio-list b-c-ratio)
  if b-c-ratio > 1 [
    set ra-adaptation-intention-list replace-item 2 ra-adaptation-intention-list "seawall"
    let sw-cost item 0 boston-planned-adaptation-cost-list
    set ra-planned-adaptation-cost-list replace-item 2 ra-planned-adaptation-cost-list sw-cost
    set boston-adaptation-intention-list replace-item 0 boston-adaptation-intention-list "seawall"]


  ;backbay
  ifelse prioritization-method = "EJ" [
    set ej-weight item 3 harbor-region-EJ-weights]
  [set ej-weight 1]
  let backbay_damage_avoided ((item 1 boston-seawall-costs-avoided-list) + .02 * mbta_damage_avoided) * ej-weight
  let backbay_cost item 1 boston-planned-adaptation-cost-list-om
  if backbay_cost > 0 [
    set b-c-ratio (backbay_damage_avoided / backbay_cost) * ra-behave-modifier]
  if backbay_cost < 0 [
    ;set b-c-ratio backbay_damage_avoided /  .00001]
    set b-c-ratio 0]
  set ra-benefit-cost-ratio-list (replace-item 3 ra-benefit-cost-ratio-list b-c-ratio)
  if b-c-ratio > 1 [
    set ra-adaptation-intention-list replace-item 3 ra-adaptation-intention-list "seawall"
    let sw-cost item 1 boston-planned-adaptation-cost-list
    set ra-planned-adaptation-cost-list replace-item 3 ra-planned-adaptation-cost-list sw-cost
    set boston-adaptation-intention-list replace-item 1 boston-adaptation-intention-list "seawall"
  ]

  ;charelstown
  ifelse prioritization-method = "EJ" [
    set ej-weight item 4 harbor-region-EJ-weights]
  [set ej-weight 1]
  let charlestown_damage_avoided ((item 2 boston-seawall-costs-avoided-list) + .02 * mbta_damage_avoided ) * ej-weight
  let charlestown_cost item 2 boston-planned-adaptation-cost-list-om
  if charlestown_cost > 0 [
    set b-c-ratio (charlestown_damage_avoided / charlestown_cost) * ra-behave-modifier]
  if charlestown_cost < 0 [
    ;set b-c-ratio charlestown_damage_avoided /  .00001]
    set b-c-ratio 0]
  set ra-benefit-cost-ratio-list (replace-item 4 ra-benefit-cost-ratio-list b-c-ratio)
  if b-c-ratio > 1 [
    set ra-adaptation-intention-list replace-item 4 ra-adaptation-intention-list "seawall"
    let sw-cost item 2 boston-planned-adaptation-cost-list
    set ra-planned-adaptation-cost-list replace-item 4 ra-planned-adaptation-cost-list sw-cost
    set boston-adaptation-intention-list replace-item 2 boston-adaptation-intention-list "seawall"
    ]

  ;downtown
  ifelse prioritization-method = "EJ" [
    set ej-weight item 5 harbor-region-EJ-weights]
  [set ej-weight 1]
  let downtown_damage_avoided ((item 3 boston-seawall-costs-avoided-list) + .10 * mbta_damage_avoided + sw_benefit_bos_dev) * ej-weight
  let downtown_cost item 3 boston-planned-adaptation-cost-list-om
  if downtown_cost > 0 [
    set b-c-ratio (downtown_damage_avoided / downtown_cost) * ra-behave-modifier]
  if downtown_cost  < 0 [
    ;set b-c-ratio downtown_damage_avoided /  .00001]
    set b-c-ratio 0]
  set ra-benefit-cost-ratio-list (replace-item 5 ra-benefit-cost-ratio-list b-c-ratio)
  if b-c-ratio > 1 [
    set ra-adaptation-intention-list replace-item 5 ra-adaptation-intention-list "seawall"
    let sw-cost item 3 boston-planned-adaptation-cost-list
    set ra-planned-adaptation-cost-list replace-item 5 ra-planned-adaptation-cost-list sw-cost
  set boston-adaptation-intention-list replace-item 3 boston-adaptation-intention-list "seawall"
  ]

  ;eboston
  ifelse prioritization-method = "EJ" [
    set ej-weight item 6 harbor-region-EJ-weights]
  [set ej-weight 1]
  let eboston_damage_avoided ((item 4 boston-seawall-costs-avoided-list) + .15 * mbta_damage_avoided + sw_benefit_bos_logan) * ej-weight
  let eboston_cost item 4 boston-planned-adaptation-cost-list-om
  if eboston_cost > 0 [
    set b-c-ratio (eboston_damage_avoided  / eboston_cost) * ra-behave-modifier]
  if eboston_cost  < 0 [
    ;set b-c-ratio eboston_damage_avoided /  .00001]
    set b-c-ratio 0]
  set ra-benefit-cost-ratio-list (replace-item 6 ra-benefit-cost-ratio-list b-c-ratio)
  if b-c-ratio > 1 [
    set ra-adaptation-intention-list replace-item 6 ra-adaptation-intention-list "seawall"
    let sw-cost item 4 boston-planned-adaptation-cost-list
    set ra-planned-adaptation-cost-list replace-item 6 ra-planned-adaptation-cost-list sw-cost
  set boston-adaptation-intention-list replace-item 4 boston-adaptation-intention-list "seawall"
  ]


  ;fenway
  ifelse prioritization-method = "EJ" [
    set ej-weight item 7 harbor-region-EJ-weights]
  [set ej-weight 1]
  let fenway_damage_avoided ((item 5 boston-seawall-costs-avoided-list) + .02 * mbta_damage_avoided) * ej-weight
  let fenway_cost item 5 boston-planned-adaptation-cost-list-om
  if fenway_cost > 0 [
    set b-c-ratio (fenway_damage_avoided  / fenway_cost) * ra-behave-modifier]
  if fenway_cost  < 0 [
    ;set b-c-ratio fenway_damage_avoided /  .00001]
    set b-c-ratio 0]
  set ra-benefit-cost-ratio-list (replace-item 7 ra-benefit-cost-ratio-list b-c-ratio)
  if b-c-ratio > 1 [
   set ra-adaptation-intention-list replace-item 7 ra-adaptation-intention-list "seawall"
    let sw-cost item 5 boston-planned-adaptation-cost-list
    set ra-planned-adaptation-cost-list replace-item 7 ra-planned-adaptation-cost-list sw-cost
  set boston-adaptation-intention-list replace-item 5 boston-adaptation-intention-list "seawall"
  ]

  ;ndorchester
  ifelse prioritization-method = "EJ" [
    set ej-weight item 8 harbor-region-EJ-weights]
  [set ej-weight 1]
  let ndorchester_damage_avoided ((item 6 boston-seawall-costs-avoided-list) + .05 * mbta_damage_avoided) * ej-weight
  let ndorchester_cost item 6 boston-planned-adaptation-cost-list-om
  if ndorchester_cost > 0 [
    set b-c-ratio (ndorchester_damage_avoided  / ndorchester_cost) * ra-behave-modifier]
  if ndorchester_cost < 0 [
    ;set b-c-ratio ndorchester_damage_avoided  /  .00001]
    set b-c-ratio 0]
  set ra-benefit-cost-ratio-list (replace-item 8 ra-benefit-cost-ratio-list b-c-ratio)
  if b-c-ratio > 1 [
    set ra-adaptation-intention-list replace-item 8 ra-adaptation-intention-list "seawall"
    let sw-cost item 6 boston-planned-adaptation-cost-list
    set ra-planned-adaptation-cost-list replace-item 8 ra-planned-adaptation-cost-list sw-cost
  set boston-adaptation-intention-list replace-item 6 boston-adaptation-intention-list "seawall"
  ]


  ;sboston
  ifelse prioritization-method = "EJ" [
    set ej-weight item 9 harbor-region-EJ-weights]
  [set ej-weight 1]
  let sboston_damage_avoided ((item 7 boston-seawall-costs-avoided-list) + .40 * mbta_damage_avoided) * ej-weight
  let sboston_cost item 7 boston-planned-adaptation-cost-list-om
  if sboston_cost > 0 [
    set b-c-ratio (sboston_damage_avoided   / sboston_cost) * ra-behave-modifier]
  if sboston_cost < 0 [
    ;set b-c-ratio sboston_damage_avoided  /  .00001]
    set b-c-ratio 0]
  set ra-benefit-cost-ratio-list (replace-item 9 ra-benefit-cost-ratio-list b-c-ratio)
  if b-c-ratio > 1 [
    set ra-adaptation-intention-list replace-item 9 ra-adaptation-intention-list "seawall"
    let sw-cost item 7 boston-planned-adaptation-cost-list
    set ra-planned-adaptation-cost-list replace-item 9 ra-planned-adaptation-cost-list sw-cost
  set boston-adaptation-intention-list replace-item 7 boston-adaptation-intention-list "seawall"
  ]


  ;sdorchester
  ifelse prioritization-method = "EJ" [
    set ej-weight item 10 harbor-region-EJ-weights]
  [set ej-weight 1]
  let sdorchester_damage_avoided ((item 8 boston-seawall-costs-avoided-list) + .02 * mbta_damage_avoided) * ej-weight
  let sdorchester_cost item 8 boston-planned-adaptation-cost-list-om
  if sdorchester_cost > 0 [
    set b-c-ratio (sdorchester_damage_avoided / sdorchester_cost) * ra-behave-modifier]
  if sdorchester_cost < 0 [
    ;set b-c-ratio sdorchester_damage_avoided /  .00001]
    set b-c-ratio 0]
  set ra-benefit-cost-ratio-list (replace-item 10 ra-benefit-cost-ratio-list b-c-ratio)
  if b-c-ratio > 1 [
    set ra-adaptation-intention-list replace-item 10 ra-adaptation-intention-list "seawall"
    let sw-cost item 8 boston-planned-adaptation-cost-list
    set ra-planned-adaptation-cost-list replace-item 10 ra-planned-adaptation-cost-list sw-cost
    set boston-adaptation-intention-list replace-item 8 boston-adaptation-intention-list "seawall"
  ]

end


to adaptation-decision-voluntary-cooperation
  ;new rules:
      ;municipalities: assume that buy-in from other agents always makes sense- otherwise absolutely no incentivee to cooperate
      ;mbta: can either adapt togetger or indepepndent
      ;need to track cost-cooperative and cost-benefit-cooperative


  ;First, we need to calculate all of the expected costs and benefits

  ;ask municipalities about seawall benefits
  ask municipalities[

  set foresight foresight-mun-pas-mbta
    ;if the region is boston, other processes needed
     ifelse name = "boston" [
      adaptation-decision-boston-vc]
      [;for municipalities other than boston
      ifelse prioritization-method = "EJ" [
         ifelse name = "north-shore" [
    set ej-weight item 0 harbor-region-EJ-weights]
        [set ej-weight item 1 harbor-region-EJ-weights]]
      [set ej-weight 1]

      ;if there is no other adaptation (only calculate if we are considering adaptation)
      ifelse adaptation = "none" [
        setup-municipal-python
        py:set "year" year
        py:set "max_range" 1
        municipality-projected-damages
        set annual-expected-damage python-output
        ;step 2: calculate the damages that would happen without a seawall in place
        setup-municipal-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        municipality-projected-damages
        set thirty_year_damage python-output
        ;step 3: calculate damages that would occur with a seawall in place
        setup-municipal-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        municipality-projected-damages
        let damage_wout_adaptation python-output
        setup-municipal-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - (permitting-delay)
        municipality-projected-damages-sw
        let damage_w_adaptation python-output
        set thirty_year_damage_sw (damage_wout_adaptation + damage_w_adaptation)


        ;the benefit of the seawall is given by damages avoided
        let seawall-benefit (thirty_year_damage - thirty_year_damage_sw) * ej-weight
        ;if overall benefit is larger than 0
        if seawall-benefit > 0 [
          ;calculate seawall cost
          let cost-2020 coastline * 7500
          let cost-2020-perm cost-2020 + (cost-2020 * permitting-cost-proportion)
          let cost-2020-all cost-2020-perm + (cost-2020 * foresight * O_M_proportion)
          ;discount cost to whatever year we are in
          ;COMME BACK HERES
          let cost-2020-with-maintenance-fee-perm ((cost-2020 * (1 + maintenance-fee)) + (cost-2020 * permitting-cost-proportion))
          let cost-2020-with-maintenance-fee-all (cost-2020-with-maintenance-fee-perm + (cost-2020 * foresight * O_M_proportion))

          let cost-discount-perm (cost-2020-perm)/((1 + discount) ^ (year - 2021))
          let cost-discount-all (cost-2020-all)/((1 + discount) ^ (year - 2021))
          let cost-with-maintenance-fee-perm ((cost-2020-with-maintenance-fee-perm)/((1 + discount) ^ (year - 2021))) * (1 - external-financing-percent)
          let cost-with-maintenance-fee-all ((cost-2020-with-maintenance-fee-all)/((1 + discount) ^ (year - 2021))) * (1 - external-financing-percent)
          let cost-perm cost-discount-perm * (1 - external-financing-percent)
          let cost-all cost-discount-all * (1 - external-financing-percent)
          ;set cost benefit seawall damages avoided / cost
          set cost-benefit-seawall seawall-benefit / cost-all
          set seawall-cost-benefit-cooperative seawall-benefit / cost-with-maintenance-fee-all
          ;if we have the behavioral modification on, then
          if flood-reaction-municipalities = True [
            ;we can set a modification between what we experienced and expected to experience
            let behave-ratio damage-time-step / annual-expected-damage
            ;this in turn will change our seawall benefit
            set cost-benefit-seawall cost-benefit-seawall * behave-ratio
            set seawall-cost-benefit-cooperative seawall-cost-benefit-cooperative * behave-ratio

           ]
          ;if the best option is to make the seawall,
          if cost-benefit-seawall > 1
          [
            ;then plan to build it!
            set adaptation-intention "seawall"
            set planned-adaptation-cost cost-perm
            set seawall-cost-cooperative cost-with-maintenance-fee-perm]
          ]
      ]
      [
      set planned-adaptation-cost 0
      ]
    ]

  ]

ask property_owners[
    ;right now set to a default of 30 years
    set foresight foresight-property_owners
    setup-property_owner-python
    let loc-test [region] of patch-here
    ;assumes location in downtown if we are located in boston - NEEDS TO BE CHANGED IN TIME
    ifelse dev-region = "boston" [
    set adapt-test-mun item 4 boston-adaptation-list
    set crs-discount item 4 boston-crs-discount-list
    set premium-adjusted premium * (1 - crs-discount)
    ifelse prioritization-method = "EJ" [
        set ej-weight item 6 harbor-region-EJ-weights]
      [set ej-weight 1]
    ]
    ;otherwise we are protected or not by municipal sw
   [set adapt-test-mun first [adaptation] of municipalities with [label = loc-test]
      set crs-discount first [crs-discount] of municipalities with [label = loc-test]
      ;code below is to test without municipal sws being possible
    ifelse prioritization-method = "EJ" [
      ifelse loc-test = "north-shore" [
        set ej-weight item 0 harbor-region-EJ-weights]
        [set ej-weight item 1 harbor-region-EJ-weights]
    ]
      [set ej-weight 1]
    ]


   ifelse adapt-test-mun = "seawall" [
    set flood-protect-height municipal-sw-height
  ]
  [set flood-protect-height 0]
    set premium-adjusted premium * (1 - crs-discount)
     if insurance-module? = false [
    if adaptation = "none" [

      ;step 1: get the annual-expected-damage
        py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        property_owner-projected-damages
        set annual-expected-damage python-output

        ;step 2: get the baseline without any adaptation
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        property_owner-projected-damages
        set thirty_year_damage python-output

        ;step 3: get aquafence baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages
        let no_adapt_damages python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-af
        let af_damages python-output
        set thirty_year_damage_af no_adapt_damages + af_damages

        ;step 4: get seawall baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages
        let no_adapt_damages_1 python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages_1 + sw_damages




      ;option 4: aquafence alone - projects for length of 'foresight'
      let aquafence-benefit (thirty_year_damage - thirty_year_damage_af) * ej-weight
      let aquafence-cost-2020  500000 + (foresight * 40000)
      let aquafence-cost-2020-perm aquafence-cost-2020 + (aquafence-cost-2020 * permitting-cost-proportion)
      let aquafence-cost-2020-all aquafence-cost-perm + (aquafence-cost-2020 * foresight * O_M_proportion)
      set aquafence-cost-discount-perm (aquafence-cost-2020-perm)/((1 + discount) ^ (year - 2021))
      set aquafence-cost-discount-all (aquafence-cost-2020-all)/((1 + discount) ^ (year - 2021))
      set aquafence-cost-perm aquafence-cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
      set aquafence-cost-all aquafence-cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)


      ;option 5: seawall alone - projects for length of 'foresight'
      let seawall-benefit (thirty_year_damage - thirty_year_damage_sw) * ej-weight
      let seawall-cost-2020 (5300 * perimeter)
      let seawall-cost-2020-perm seawall-cost-2020 + (seawall-cost-2020 * permitting-cost-proportion)
      let seawall-cost-2020-all seawall-cost-2020-perm + (seawall-cost-2020 * foresight * O_M_proportion)
      set seawall-cost-discount-perm (seawall-cost-2020-perm)/((1 + discount) ^ (year - 2021))
      set seawall-cost-discount-all (seawall-cost-2020-all)/((1 + discount) ^ (year - 2021))
      set seawall-cost-perm seawall-cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
      set seawall-cost-all seawall-cost-discount-all * ((1 - external-financing-percent) * reduction-funding-access)

      let cost_list (list aquafence-cost-all seawall-cost-all)
      let benefit_list (list aquafence-benefit seawall-benefit)
        set benefit_cost_list [0 0]
      set benefit_cost_list_behavior [0 0]
      set test-pos 0
      foreach cost_list[
        [x]-> let option-cost x
        set option-benefit item test-pos benefit_list
        ifelse option-benefit > 0 [
          set benefit_cost_list replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ifelse flood-reaction-property_owners = True [
             ifelse annual-expected-damage > 0 [
                if annual-expected-damage = 0 [
                  ;output-print("failure 1")
                ]
              let behave-ratio damage-time-step / annual-expected-damage
                if option-cost = 0[
                  ;output-print("failure 2")
                ]
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio]
            [;no damage expected- less likely to adapt (assume 50% here)
              let behave-ratio .50
                if option-cost = 0[
                  ;output-print("failure 3")
                ]
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio
            ]
          ]

          [if option-cost = 0[
                  output-print("failure 4")]
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ]
        ]
        [set benefit_cost_list replace-item test-pos benefit_cost_list 0
          set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior 0
        ]
        set test-pos test-pos + 1
      ]

      let best-ratio max benefit_cost_list_behavior
      set identifier position best-ratio benefit_cost_list_behavior
      ;NOTE 2/27 ASSUMES PLANNED ADAPTATION COST INDICATES COST OF ADAPTATIONS ADN INSURANCE BOTH
      ;CHANGE BELOW FOR TEST
      if best-ratio = 0 [
        set identifier 5]

       if identifier = 0[
        set insurance-intention False
        set adaptation-intention "aquafence"
        set planned-adaptation-cost aquafence-cost-perm
      ]
;      if identifier = 4[
       if identifier = 1[
        set insurance-intention False
        set adaptation-intention "local-seawall"
        set planned-adaptation-cost seawall-cost-perm
      ]
;      if identifier = 5[
       if identifier = 2[
        ; no adaptation
        set insurance-intention False
        ]
    ]


    if adaptation = "aquafence" [
     ;step 1: get the annual-expected-damage
        py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        property_owner-projected-damages-af
        set annual-expected-damage python-output

        ;step 2: get the baseline without any adaptation
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        property_owner-projected-damages-af
        set thirty_year_damage python-output


        ;step 4: get seawall baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages-af
        let no_adapt_damages_1 python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages_1 + sw_damages



      ;option 3: build seawall alone
      let seawall-benefit (thirty_year_damage - thirty_year_damage_sw) * ej-weight
      let seawall-cost-2020 (5300 * perimeter)
      let seawall-cost-2020-perm seawall-cost-2020 + (seawall-cost-2020 * permitting-cost-proportion)
      let seawall-cost-2020-all seawall-cost-2020-perm + (seawall-cost-2020 * foresight * O_M_proportion)
      set seawall-cost-discount-perm (seawall-cost-2020-perm)/((1 + discount) ^ (year - 2021))
      set seawall-cost-discount-all (seawall-cost-2020-all)/((1 + discount) ^ (year - 2021))
      set seawall-cost-perm seawall-cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
      set seawall-cost-all seawall-cost-discount-all * ((1 - external-financing-percent) * reduction-funding-access)


      let cost_list (list seawall-cost-all)
      let benefit_list (list seawall-benefit)
      set benefit_cost_list [0]
      set benefit_cost_list_behavior [0]
      set test-pos 0
      foreach cost_list[
        [x]-> let option-cost x
        set option-benefit item test-pos benefit_list
        ifelse option-benefit > 0 [
          set benefit_cost_list replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ifelse flood-reaction-property_owners = True [
             ifelse annual-expected-damage > 0 [
                if annual-expected-damage  = 0[
                  ;output-print("failure 5")
                ]
              let behave-ratio damage-time-step / annual-expected-damage
                if option-cost = 0[
                  ;output-print("failure 6")
                ]
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio]
            [;no damage expected- less likely to adapt (assume 50% here)
              let behave-ratio .50
                if option-cost = 0[
                  ;output-print("failure 7")
                ]
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio
            ]
          ]

          [if option-cost = 0[
                  ;output-print("failure 8")
              ]
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ]
        ]
        [set benefit_cost_list replace-item test-pos benefit_cost_list 0
          set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior 0
        ]
        set test-pos test-pos + 1
      ]

      let best-ratio max benefit_cost_list_behavior
      set identifier position best-ratio benefit_cost_list_behavior
      ;NOTE 2/27 ASSUMES PLANNED ADAPTATION COST INDICATES COST OF ADAPTATIONS ADN INSURANCE BOTH


       if identifier = 0[
        set insurance-intention False
        set adaptation-intention "local-seawall"
        set planned-adaptation-cost seawall-cost-perm
      ]
;      if identifier = 5[
       if identifier = 1[
        ; no adaptation
        set insurance-intention False
        ]
    ]
        if adaptation = "local-seawall"[
    ; no further adaptation that can be done- nothing left

    ]
    ]
    if insurance-module? = true [
       ifelse mandatory-insurance? = false [
          if adaptation = "none" [
             ;step 1: get the annual-expected-damage
        py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        property_owner-projected-damages
        set annual-expected-damage python-output

        ;step 2: get the baseline without any adaptation
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        property_owner-projected-damages
        set thirty_year_damage python-output

        ;step 3: get aquafence baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages
        let no_adapt_damages python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-af
        let af_damages python-output
        set thirty_year_damage_af no_adapt_damages + af_damages

        ;step 4: get seawall baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages
        let no_adapt_damages_1 python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages_1 + sw_damages



             ;option 1: insurance alone - 1 year time step
             ;Comment out options 1, 2, and 3 BELOW FOR TEST
             let insurance-coverage (1 - deductible) * annual-expected-damage
             ifelse insurance-coverage > max-flood-insurance-coverage [
             set insurance-damages max-flood-insurance-coverage
             ]
             [set insurance-damages insurance-coverage]
             set insurance-damages (insurance-damages)/((1 + discount) ^ (year - 2021))
             let insurance-benefit (annual-expected-damage - (annual-expected-damage - insurance-damages)) * ej-weight
             set insurance-cost premium-adjusted / ((1 + discount) ^ (year - 2021))

             ;option 2: insurance with an aquafence - projects for length of 'foresight'
             ;damages with both are assumed to be 10% of aquafence damage
             let aquafence-cost-2020-ins-pt-1  500000 + (foresight * 40000)
             let aquafence-cost-2020-ins-perm aquafence-cost-2020-ins-pt-1 + (aquafence-cost-2020-ins-pt-1 * permitting-cost-proportion)
             let aquafence-cost-2020-ins-all aquafence-cost-2020-ins-perm + (aquafence-cost-2020-ins-pt-1 * foresight * O_M_proportion)

             let aquafence-cost-ins-discount-perm (aquafence-cost-2020-ins-perm)/((1 + discount) ^ (year - 2021))
             let aquafence-cost-ins-discount-all (aquafence-cost-2020-ins-all)/((1 + discount) ^ (year - 2021))

             let aquafence-cost-ins-perm aquafence-cost-ins-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
             let aquafence-cost-ins-all aquafence-cost-ins-discount-all * ((1 - external-financing-percent) * reduction-funding-access)

             let premium-estimates foresight *  premium-adjusted
             let premium-estimates-discount (premium-estimates) / ((1 + discount) ^ (year - 2021))
             set insurance-af-cost aquafence-cost-ins-all + premium-estimates-discount
             ;really this should be discounted
             let max-insurance-coverage max-flood-insurance-coverage * foresight
             ifelse thirty_year_damage_af * (1 - deductible) > max-insurance-coverage [
             set insurance-af-damages max-insurance-coverage]
             [set insurance-af-damages thirty_year_damage_af * (1 - deductible)]
             ;insruance-af-damages is the component of damages that insurance pays
             let insurance-af-benefits (thirty_year_damage - (thirty_year_damage_af - insurance-af-damages)) * ej-weight


             ;option 3: insurance with a seawall - projects for length of 'foresight'
             let seawall-cost-2020-ins-pt-1  (5300 * perimeter)
             let seawall-cost-2020-ins-perm seawall-cost-2020-ins-pt-1 + (seawall-cost-2020-ins-pt-1 * permitting-cost-proportion)
             let seawall-cost-2020-ins-all seawall-cost-2020-ins-perm + (seawall-cost-2020-ins-pt-1 * foresight * O_M_proportion)

             let seawall-cost-ins-discount-perm (seawall-cost-2020-ins-perm)/((1 + discount) ^ (year - 2021))
             let seawall-cost-ins-discount-all (seawall-cost-2020-ins-all)/((1 + discount) ^ (year - 2021))

             let seawall-cost-ins-perm seawall-cost-ins-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
             let seawall-cost-ins-all seawall-cost-ins-discount-all * ((1 - external-financing-percent) * reduction-funding-access)

             let premium-estimates-sw foresight * premium-adjusted
             let premium-estimates-sw-discount (premium-estimates-sw)/((1 + discount) ^ (year - 2021))
             set insurance-sw-cost seawall-cost-ins-all + premium-estimates-sw-discount
             let max-insurance-coverage-sw max-flood-insurance-coverage * foresight
             ifelse thirty_year_damage_sw * (1 - deductible) > max-insurance-coverage-sw [
             set insurance-sw-damages max-insurance-coverage-sw]
             [set insurance-sw-damages thirty_year_damage_sw * (1 - deductible)]
             ;insruance-af-damages is the component of damages that insurance pays
             let insurance-sw-benefits (thirty_year_damage - (thirty_year_damage_sw - insurance-sw-damages)) * ej-weight



            ;option 4: aquafence alone - projects for length of 'foresight'
            let aquafence-benefit (thirty_year_damage - thirty_year_damage_af) * ej-weight
            let aquafence-cost-2020  500000 + (foresight * 40000)
            let aquafence-cost-2020-perm aquafence-cost-2020 + (aquafence-cost-2020 * permitting-cost-proportion)
            let aquafence-cost-2020-all aquafence-cost-2020-perm + (aquafence-cost-2020 * foresight * O_M_proportion)
            set aquafence-cost-discount-perm (aquafence-cost-2020-perm)/((1 + discount) ^ (year - 2021))
            set aquafence-cost-discount-all (aquafence-cost-2020-all)/((1 + discount) ^ (year - 2021))
            set aquafence-cost-perm aquafence-cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
            set aquafence-cost-all aquafence-cost-discount-all * ((1 - external-financing-percent) * reduction-funding-access)


            ;option 5: seawall alone - projects for length of 'foresight'
            let seawall-benefit (thirty_year_damage - thirty_year_damage_sw) * ej-weight
            let seawall-cost-2020 (5300 * perimeter)
            let seawall-cost-2020-perm seawall-cost-2020 + (seawall-cost-2020 * permitting-cost-proportion)
            let seawall-cost-2020-all seawall-cost-perm + (seawall-cost-2020 * foresight * O_M_proportion)
            set seawall-cost-discount-perm (seawall-cost-2020-perm)/((1 + discount) ^ (year - 2021))
            set seawall-cost-discount-all (seawall-cost-2020-all)/((1 + discount) ^ (year - 2021))
            set seawall-cost-perm seawall-cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
            set seawall-cost-all seawall-cost-discount-all * ((1 - external-financing-percent) * reduction-funding-access)


      let cost_list (list insurance-cost insurance-af-cost insurance-sw-cost aquafence-cost-all seawall-cost-all)
      let benefit_list (list insurance-benefit insurance-af-benefits insurance-sw-benefits aquafence-benefit seawall-benefit)
      set benefit_cost_list [0 0 0 0 0]
      set benefit_cost_list_behavior [0 0 0 0 0]


      set test-pos 0
      foreach cost_list[
        [x]-> let option-cost x
            ;output-print(test-pos)
            ;output-print(option-cost)
        set option-benefit item test-pos benefit_list
        ifelse option-benefit > 0 [
          set benefit_cost_list replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ifelse flood-reaction-property_owners = True [
                ;output-print(option-cost)
             ifelse annual-expected-damage > 0 [
                  ;output-print(annual-expected-damage)
              let behave-ratio damage-time-step / annual-expected-damage
                  if option-cost = 0 [
                    ;output-print("failure 10")
                  ]
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio]
            [;no damage expected- less likely to adapt (assume 50% here)
              let behave-ratio .50
              let altered_ratio (option-benefit / option-cost) * behave-ratio
                  if option-cost = 0 [
                    ;output-print("failure 11")
                  ]
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio
            ]
          ]

          [if option-cost = 0 [
                    ;output-print("failure 12")
                ]
                set benefit_cost_list_behavior replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ]
        ]
        [set benefit_cost_list replace-item test-pos benefit_cost_list 0
          set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior 0
        ]
        set test-pos test-pos + 1
      ]

      let best-ratio max benefit_cost_list_behavior
      set identifier position best-ratio benefit_cost_list_behavior
      ;NOTE 2/27 ASSUMES PLANNED ADAPTATION COST INDICATES COST OF ADAPTATIONS ADN INSURANCE BOTH
      ;CHANGE BELOW FOR TEST
      if best-ratio = 0 [
        set identifier 5]
      if identifier = 0 [
        set insurance-intention True
        set planned-adaptation-cost insurance-cost
      ]
      if identifier = 1[
        set insurance-intention True
        set adaptation-intention "aquafence"
        set planned-adaptation-cost insurance-cost + aquafence-cost-perm
      ]
      if identifier = 2[
        set insurance-intention True
        set adaptation-intention "local-seawall"
        set planned-adaptation-cost insurance-cost + seawall-cost-perm
      ]
      if identifier = 3[
;       if identifier = 0[
        set insurance-intention False
        set adaptation-intention "aquafence"
        set planned-adaptation-cost aquafence-cost-perm
      ]
      if identifier = 4[
;       if identifier = 1[
        set insurance-intention False
        set adaptation-intention "local-seawall"
        set planned-adaptation-cost seawall-cost-perm
      ]
      if identifier = 5[
;       if identifier = 2[
        ; no adaptation
        set insurance-intention False
        ]
    ]


    if adaptation = "aquafence" [
      ;step 1: get the annual-expected-damage
        py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        property_owner-projected-damages-af
        set annual-expected-damage python-output

        ;step 2: get the baseline without any adaptation
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        property_owner-projected-damages-af
        set thirty_year_damage python-output


        ;step 4: get seawall baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages-af
        let no_adapt_damages_1 python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages_1 + sw_damages



      ;CHANGE BELOW FOR TEST
      ;option 1: purchase insurance
      let insurance-coverage (1 - deductible) * annual-expected-damage-af
      ifelse insurance-coverage > max-flood-insurance-coverage [
        set insurance-damages max-flood-insurance-coverage
      ]
      [set insurance-damages insurance-coverage]
      set insurance-damages (insurance-damages)/((1 + discount) ^ (year - 2021))
      let insurance-benefit (annual-expected-damage-af - (annual-expected-damage-af - insurance-damages)) * ej-weight
      set insurance-cost premium-adjusted / ((1 + discount) ^ (year - 2021))

      ;option 2: purchase insurance and build seawall
      let seawall-cost-2020-ins-pt-1  (5300 * perimeter)
             let seawall-cost-2020-ins-perm seawall-cost-2020-ins-pt-1 + (seawall-cost-2020-ins-pt-1 * permitting-cost-proportion)
             let seawall-cost-2020-ins-all seawall-cost-2020-ins-perm + (seawall-cost-2020-ins-pt-1 * foresight * O_M_proportion)

             let seawall-cost-ins-discount-perm (seawall-cost-2020-ins-perm)/((1 + discount) ^ (year - 2021))
             let seawall-cost-ins-discount-all (seawall-cost-2020-ins-all)/((1 + discount) ^ (year - 2021))

             let seawall-cost-ins-perm seawall-cost-ins-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
             let seawall-cost-ins-all seawall-cost-ins-discount-all * ((1 - external-financing-percent) * reduction-funding-access)

             let premium-estimates-sw foresight * premium-adjusted
             let premium-estimates-sw-discount (premium-estimates-sw)/((1 + discount) ^ (year - 2021))
             set insurance-sw-cost seawall-cost-ins-all + premium-estimates-sw-discount
             let max-insurance-coverage-sw max-flood-insurance-coverage * foresight
             ifelse thirty_year_damage_sw * (1 - deductible) > max-insurance-coverage-sw [
             set insurance-sw-damages max-insurance-coverage-sw]
             [set insurance-sw-damages thirty_year_damage_sw * (1 - deductible)]
             ;insruance-af-damages is the component of damages that insurance pays
             let insurance-sw-benefits (thirty_year_damage - (thirty_year_damage_sw - insurance-sw-damages)) * ej-weight



      ;option 3: build seawall alone
       let seawall-benefit (thirty_year_damage - thirty_year_damage_sw) * ej-weight
            let seawall-cost-2020 (5300 * perimeter)
            let seawall-cost-2020-perm seawall-cost-2020 + (seawall-cost-2020 * permitting-cost-proportion)
            let seawall-cost-2020-all seawall-cost-perm + (seawall-cost-2020 * foresight * O_M_proportion)
            set seawall-cost-discount-perm (seawall-cost-2020-perm)/((1 + discount) ^ (year - 2021))
            set seawall-cost-discount-all (seawall-cost-2020-all)/((1 + discount) ^ (year - 2021))
            set seawall-cost-perm seawall-cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
            set seawall-cost-all seawall-cost-discount-all * ((1 - external-financing-percent) * reduction-funding-access)

      ;option 4: Do nothing

;COMMENT OUT BELOW FOR TEST
      let cost_list (list insurance-cost insurance-sw-cost seawall-cost-all)
      let benefit_list (list insurance-benefit insurance-sw-benefits seawall-benefit)
      set benefit_cost_list [0 0 0]
      set benefit_cost_list_behavior [0 0 0]
;      let cost_list (list seawall-cost)
;      let benefit_list (list seawall-benefit)
;      set benefit_cost_list [0]
;      set benefit_cost_list_behavior [0]
      set test-pos 0
      foreach cost_list[
        [x]-> let option-cost x
        set option-benefit item test-pos benefit_list
        ifelse option-benefit > 0 [
          set benefit_cost_list replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ifelse flood-reaction-property_owners = True [
             ifelse annual-expected-damage > 0 [
              let behave-ratio damage-time-step / annual-expected-damage
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio]
            [;no damage expected- less likely to adapt (assume 50% here)
              let behave-ratio .50
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio
            ]
          ]

          [set benefit_cost_list_behavior replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ]
        ]
        [set benefit_cost_list replace-item test-pos benefit_cost_list 0
          set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior 0
        ]
        set test-pos test-pos + 1
      ]

      let best-ratio max benefit_cost_list_behavior
      set identifier position best-ratio benefit_cost_list_behavior
      ;NOTE 2/27 ASSUMES PLANNED ADAPTATION COST INDICATES COST OF ADAPTATIONS ADN INSURANCE BOTH

;COMMENT OUT BELOW FOR TEST
      if best-ratio = 0 [
        set identifier 5]
      if identifier = 0 [
        set insurance-intention True
        set planned-adaptation-cost insurance-cost
      ]
      if identifier = 1[
        set insurance-intention True
        set adaptation-intention "local-seawall"
        set planned-adaptation-cost insurance-cost + seawall-cost-perm
      ]

      if identifier = 2[
;       if identifier = 0[
        set insurance-intention False
        set adaptation-intention "local-seawall"
        set planned-adaptation-cost seawall-cost-perm
      ]
      if identifier = 5[
;       if identifier = 1[
        ; no adaptation
        set insurance-intention False
        ]
    ]
        if adaptation = "local-seawall"[
        ;COMMENT OUT ALL CODE BELOW FOR TEST

          py:set "year" year
          ;step 1: get the annual-expected-damage
        py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        property_owner-projected-damages-sw
        set annual-expected-damage-sw python-output


          property_owner-projected-damages-sw
      ;option 1: purchase insurance
      let insurance-coverage (1 - deductible) * annual-expected-damage-sw
      ifelse insurance-coverage > max-flood-insurance-coverage [
        set insurance-damages max-flood-insurance-coverage
      ]
      [set insurance-damages insurance-coverage]
      set insurance-damages (insurance-damages)/((1 + discount) ^ (year - 2021))
      let insurance-benefit (annual-expected-damage-sw - (annual-expected-damage-sw - insurance-damages))
      set insurance-cost premium-adjusted / ((1 + discount) ^ (year - 2021))
      ifelse insurance-benefit > 0 [
        ifelse flood-reaction-property_owners = True [
            ifelse annual-expected-damage > 0[
          let behave-ratio damage-time-step / annual-expected-damage
              let altered_ratio (insurance-benefit / insurance-cost) * behave-ratio
          ifelse altered_ratio > 1 [
            set insurance-intention True
            set planned-adaptation-cost insurance-cost
        ]
          [set insurance-intention False]
        ]
            [let altered_ratio (insurance-benefit / insurance-cost) * 1
              ifelse altered_ratio > 1 [
            set insurance-intention True
                set planned-adaptation-cost insurance-cost]

          [set insurance-intention False]
          ]]
        [;no flood reaction
          let benefit-ratio insurance-benefit / insurance-cost
            ifelse benefit-ratio > 1[
              set insurance-intention True
              set planned-adaptation-cost insurance-cost
        ]
            [set insurance-intention False
            ]
      ]
        ]
      [;less than 0 benefit -> no adaptation
      ]

    ]
  ]
    [;mandatory-insurance = true
      if adaptation = "none" [
      ;calculate property_owner damags without any adaptation
         ;step 1: get the annual-expected-damage
        py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        property_owner-projected-damages
        set annual-expected-damage python-output

        ;step 2: get the baseline without any adaptation
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        property_owner-projected-damages
        set thirty_year_damage python-output

        ;step 3: get aquafence baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages
        let no_adapt_damages python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-af
        let af_damages python-output
        set thirty_year_damage_af no_adapt_damages + af_damages

        ;step 4: get seawall baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages
        let no_adapt_damages_1 python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages_1 + sw_damages


      ;option 1: insurance alone - 1 year time step
      let insurance-coverage (1 - deductible) * annual-expected-damage
      ifelse insurance-coverage > max-flood-insurance-coverage [
        set insurance-damages max-flood-insurance-coverage
      ]
      [set insurance-damages insurance-coverage]
      set insurance-damages (insurance-damages)/((1 + discount) ^ (year - 2021))
      let insurance-benefit (annual-expected-damage - (annual-expected-damage - insurance-damages)) * ej-weight
      set insurance-cost premium-adjusted / ((1 + discount) ^ (year - 2021))

      ;option 2: insurance with an aquafence - projects for length of 'foresight'
         ;damages with both are assumed to be 10% of aquafence damage
      let aquafence-cost-2020-ins-pt-1  500000 + (foresight * 40000)
             let aquafence-cost-2020-ins-perm aquafence-cost-2020-ins-pt-1 + (aquafence-cost-2020-ins-pt-1 * permitting-cost-proportion)
             let aquafence-cost-2020-ins-all aquafence-cost-2020-ins-perm + (aquafence-cost-2020-ins-pt-1 * foresight * O_M_proportion)

             let aquafence-cost-ins-discount-perm (aquafence-cost-2020-ins-perm)/((1 + discount) ^ (year - 2021))
             let aquafence-cost-ins-discount-all (aquafence-cost-2020-ins-all)/((1 + discount) ^ (year - 2021))

             let aquafence-cost-ins-perm aquafence-cost-ins-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
             let aquafence-cost-ins-all aquafence-cost-ins-discount-all * ((1 - external-financing-percent) * reduction-funding-access)

             let premium-estimates foresight *  premium-adjusted
             let premium-estimates-discount (premium-estimates) / ((1 + discount) ^ (year - 2021))
             set insurance-af-cost aquafence-cost-ins-all + premium-estimates-discount
             ;really this should be discounted
             let max-insurance-coverage max-flood-insurance-coverage * foresight
             ifelse thirty_year_damage_af * (1 - deductible) > max-insurance-coverage [
             set insurance-af-damages max-insurance-coverage]
             [set insurance-af-damages thirty_year_damage_af * (1 - deductible)]
             ;insruance-af-damages is the component of damages that insurance pays
             let insurance-af-benefits (thirty_year_damage - (thirty_year_damage_af - insurance-af-damages)) * ej-weight


      ;option 3: insurance with a seawall - projects for length of 'foresight'
     let seawall-cost-2020-ins-pt-1  (5300 * perimeter)
             let seawall-cost-2020-ins-perm seawall-cost-2020-ins-pt-1 + (seawall-cost-2020-ins-pt-1 * permitting-cost-proportion)
             let seawall-cost-2020-ins-all seawall-cost-2020-ins-perm + (seawall-cost-2020-ins-pt-1 * foresight * O_M_proportion)

             let seawall-cost-ins-discount-perm (seawall-cost-2020-ins-perm)/((1 + discount) ^ (year - 2021))
             let seawall-cost-ins-discount-all (seawall-cost-2020-ins-all)/((1 + discount) ^ (year - 2021))

             let seawall-cost-ins-perm seawall-cost-ins-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
             let seawall-cost-ins-all seawall-cost-ins-discount-all * ((1 - external-financing-percent) * reduction-funding-access)

             let premium-estimates-sw foresight * premium-adjusted
             let premium-estimates-sw-discount (premium-estimates-sw)/((1 + discount) ^ (year - 2021))
             set insurance-sw-cost seawall-cost-ins-all + premium-estimates-sw-discount
             let max-insurance-coverage-sw max-flood-insurance-coverage * foresight
             ifelse thirty_year_damage_sw * (1 - deductible) > max-insurance-coverage-sw [
             set insurance-sw-damages max-insurance-coverage-sw]
             [set insurance-sw-damages thirty_year_damage_sw * (1 - deductible)]
             ;insruance-af-damages is the component of damages that insurance pays
             let insurance-sw-benefits (thirty_year_damage - (thirty_year_damage_sw - insurance-sw-damages)) * ej-weight


      let cost_list (list insurance-cost insurance-af-cost insurance-sw-cost)
      let benefit_list (list insurance-benefit insurance-af-benefits insurance-sw-benefits)
      set benefit_cost_list [0 0 0]
      set benefit_cost_list_behavior [0 0 0]
      set test-pos 0
      foreach cost_list[
        [x]-> let option-cost x
        set option-benefit item test-pos benefit_list
        ifelse option-benefit > 0 [
          set benefit_cost_list replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ifelse flood-reaction-property_owners = True [
             ifelse annual-expected-damage > 0 [
              let behave-ratio damage-time-step / annual-expected-damage
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio]
            [;no damage expected- less likely to adapt (assume 50% here)
              let behave-ratio .50
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio
            ]
          ]

          [set benefit_cost_list_behavior replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ]
        ]
        [set benefit_cost_list replace-item test-pos benefit_cost_list 0
          set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior 0
        ]
        set test-pos test-pos + 1
      ]

      let best-ratio max benefit_cost_list_behavior
      set identifier position best-ratio benefit_cost_list_behavior
      ;NOTE 2/27 ASSUMES PLANNED ADAPTATION COST INDICATES COST OF ADAPTATIONS ADN INSURANCE BOTH
      if best-ratio = 0 [
        set identifier 5]
      if identifier = 0 [
        set insurance-intention True
        set planned-adaptation-cost insurance-cost
      ]
      if identifier = 1[
        set insurance-intention True
        set adaptation-intention "aquafence"
        set planned-adaptation-cost insurance-cost + aquafence-cost-ins-perm
      ]
      if identifier = 2[
        set insurance-intention True
        set adaptation-intention "local-seawall"
        set planned-adaptation-cost insurance-cost + seawall-cost-ins-perm
      ]
      if identifier = 5[
        ; no adaptation
        set insurance-intention true
        set planned-adaptation-cost insurance-cost
        ]
    ]


    if adaptation = "aquafence" [
      py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        property_owner-projected-damages-af
        set annual-expected-damage python-output

        ;step 2: get the baseline without any adaptation
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        property_owner-projected-damages-af
        set thirty_year_damage python-output


        ;step 4: get seawall baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        property_owner-projected-damages-af
        let no_adapt_damages_1 python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        property_owner-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages_1 + sw_damages

      ;option 1: purchase insurance
      let insurance-coverage (1 - deductible) * annual-expected-damage-af
      ifelse insurance-coverage > max-flood-insurance-coverage [
        set insurance-damages max-flood-insurance-coverage
      ]
      [set insurance-damages insurance-coverage]
      set insurance-damages (insurance-damages)/((1 + discount) ^ (year - 2021))
      let insurance-benefit (annual-expected-damage - (annual-expected-damage - insurance-damages)) * ej-weight
      set insurance-cost premium-adjusted / ((1 + discount) ^ (year - 2021))

      ;option 2: purchase insurance and build seawall
       let seawall-cost-2020-ins-pt-1  (5300 * perimeter)
             let seawall-cost-2020-ins-perm seawall-cost-2020-ins-pt-1 + (seawall-cost-2020-ins-pt-1 * permitting-cost-proportion)
             let seawall-cost-2020-ins-all seawall-cost-2020-ins-perm + (seawall-cost-2020-ins-pt-1 * foresight * O_M_proportion)

             let seawall-cost-ins-discount-perm (seawall-cost-2020-ins-perm)/((1 + discount) ^ (year - 2021))
             let seawall-cost-ins-discount-all (seawall-cost-2020-ins-all)/((1 + discount) ^ (year - 2021))

             let seawall-cost-ins-perm seawall-cost-ins-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
             let seawall-cost-ins-all seawall-cost-ins-discount-all * ((1 - external-financing-percent) * reduction-funding-access)

             let premium-estimates-sw foresight * premium-adjusted
             let premium-estimates-sw-discount (premium-estimates-sw)/((1 + discount) ^ (year - 2021))
             set insurance-sw-cost seawall-cost-ins-all + premium-estimates-sw-discount
             let max-insurance-coverage-sw max-flood-insurance-coverage * foresight
             ifelse thirty_year_damage_sw * (1 - deductible) > max-insurance-coverage-sw [
             set insurance-sw-damages max-insurance-coverage-sw]
             [set insurance-sw-damages thirty_year_damage_sw * (1 - deductible)]
             ;insruance-af-damages is the component of damages that insurance pays
             let insurance-sw-benefits (thirty_year_damage - (thirty_year_damage_sw - insurance-sw-damages)) * ej-weight

      let cost_list (list insurance-cost insurance-sw-cost)
      let benefit_list (list insurance-benefit insurance-sw-benefits)
      set benefit_cost_list [0 0]
      set benefit_cost_list_behavior [0 0]
      set test-pos 0
      foreach cost_list[
        [x]-> let option-cost x
        set option-benefit item test-pos benefit_list
        ifelse option-benefit > 0 [
          set benefit_cost_list replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ifelse flood-reaction-property_owners = True [
             ifelse annual-expected-damage > 0 [
              let behave-ratio damage-time-step / annual-expected-damage
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio]
            [;no damage expected- less likely to adapt (assume 50% here)
              let behave-ratio 1
              let altered_ratio (option-benefit / option-cost) * behave-ratio
              set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior altered_ratio
            ]
          ]

          [set benefit_cost_list_behavior replace-item test-pos benefit_cost_list (option-benefit / option-cost)
          ]
        ]
        [set benefit_cost_list replace-item test-pos benefit_cost_list 0
          set benefit_cost_list_behavior replace-item test-pos benefit_cost_list_behavior 0
        ]
        set test-pos test-pos + 1
      ]

      let best-ratio max benefit_cost_list_behavior
      set identifier position best-ratio benefit_cost_list_behavior
      ;NOTE 2/27 ASSUMES PLANNED ADAPTATION COST INDICATES COST OF ADAPTATIONS ADN INSURANCE BOTH
      if best-ratio = 0 [
        set identifier 0]
      if identifier = 0 [
        set insurance-intention True
        set planned-adaptation-cost insurance-cost
      ]
      if identifier = 1[
        set insurance-intention True
        set adaptation-intention "local-seawall"
        set planned-adaptation-cost insurance-cost + seawall-cost-ins-perm
      ]

    ]
        if adaptation = "local-seawall"[
          py:set "year" year
          ;step 1: get the annual-expected-damage
        py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        property_owner-projected-damages-sw
        set annual-expected-damage-sw python-output
      ;option 1: purchase insurance
      let insurance-coverage (1 - deductible) * annual-expected-damage-sw
      ifelse insurance-coverage > max-flood-insurance-coverage [
        set insurance-damages max-flood-insurance-coverage
      ]
      [set insurance-damages insurance-coverage]
      set insurance-damages (insurance-damages)/((1 + discount) ^ (year - 2021))
      let insurance-benefit (annual-expected-damage-sw - (annual-expected-damage-sw - insurance-damages)) * ej-weight
      set insurance-cost premium-adjusted / ((1 + discount) ^ (year - 2021))
      ifelse insurance-benefit > 0 [
        ifelse flood-reaction-property_owners = True [
          ifelse annual-expected-damage > 0 [
          let behave-ratio damage-time-step / annual-expected-damage
          let altered_ratio (insurance-benefit / insurance-cost) * behave-ratio
          ifelse altered_ratio > 1 [
            set insurance-intention True
            set planned-adaptation-cost insurance-cost
        ]
          [set insurance-intention True
              set planned-adaptation-cost insurance-cost]
          ]
          [
          let altered_ratio (insurance-benefit / insurance-cost) * 1
          ifelse altered_ratio > 1 [
            set insurance-intention True
            set planned-adaptation-cost insurance-cost
        ]
          [set insurance-intention True
              set planned-adaptation-cost insurance-cost]
            ]


          ]
        [;no flood reaction
          let benefit-ratio insurance-benefit / insurance-cost
            ifelse benefit-ratio > 1[
              set insurance-intention True
              set planned-adaptation-cost insurance-cost
        ]
            [set insurance-intention True
              set planned-adaptation-cost insurance-cost
            ]
      ]
        ]
      [;less than 0 benefit -> no adaptation
      ]

  ]
    ]
    ]
  ]



  ask MBTA-agents[
    if mbta-adaptation-method = "all-at-once" [
      mbta-adaptation-decision-all-at-once
    ]
    if mbta-adaptation-method = "segments" [
      mbta-adaptation-decision-segments
    ]
  ]

  ask private-assets [
    set foresight foresight-mun-pas-mbta
    if name = "BOS-air" [
      set adapt-test-mun item 4 boston-adaptation-list]
    if name = "food-dist" [
      set adapt-test-mun first [adaptation] of municipalities with [label = "north-shore"]
    ]
    ifelse prioritization-method = "EJ" [
      ifelse name = "BOS-air" [
        set ej-weight item 6 harbor-region-EJ-weights]
      [set ej-weight item 0 harbor-region-EJ-weights]

    ]
    [set ej-weight 1]
    ;note that this process is the same for property_owners + pas
    setup-property_owner-python
    ifelse adapt-test-mun = "seawall" [
    set flood-protect-height municipal-sw-height]
    [set flood-protect-height 0]

    ifelse adaptation = "none" [
      py:set "year" year
        py:set "max_range" 1
        setup-property_owner-python
        PA-projected-damages
        set annual-expected-damage python-output

        ;step 2: get the baseline without any adaptation
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        PA-projected-damages
        set thirty_year_damage python-output

        ;step 4: get seawall baseline
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        PA-projected-damages
        let no_adapt_damages_1 python-output
        setup-property_owner-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - permitting-delay
        PA-projected-damages-sw
        let sw_damages python-output
        set thirty_year_damage_sw no_adapt_damages_1 + sw_damages

      let seawall-benefit (thirty_year_damage - thirty_year_damage_sw) * ej-weight
           if seawall-benefit > 0 [
           let cost-2020 (5300 * perimeter)
           let cost-2020-perm cost-2020 + (cost-2020 * permitting-cost-proportion)
           let cost-2020-all cost-2020-perm + (cost-2020 * foresight * O_M_proportion)
           let cost-discount-perm (cost-2020-perm)/((1 + discount) ^ (year - 2021))
           let cost-discount-all (cost-2020-all)/((1 + discount) ^ (year - 2021))
           let cost-perm cost-discount-perm * ((1 - external-financing-percent) * reduction-funding-access)
           let cost-all cost-discount-all * ((1 - external-financing-percent) * reduction-funding-access)
           set cost-benefit-seawall seawall-benefit / cost-all
           if flood-reaction-property_owners = True [
          if annual-expected-damage > 0 [
               let behave-ratio damage-time-step / annual-expected-damage-af
            set cost-benefit-seawall cost-benefit-seawall * behave-ratio]
           ]

           if cost-benefit-seawall > 1[
             set adaptation-intention "on-site-seawall"
             set planned-adaptation-cost cost-perm]
        ]
    ]

    [;there is already an on-site seawall- nothing to do...
    ]
  ]




end


to setup-python-calcs-mbta
  ;py:set "max_range" foresight
  py:set "slr_proj" mun-slr-proj
  ;py:set "year" year
  py:set "discount" discount
  py:set "slr_0" dam-0
  py:set "slr_1" dam-0.23
  py:set "slr_2" dam-1.41
  py:set "slr_3" dam-2.59
  py:set "slr_4" dam-4.41
  py:set "slr_0_sw" dam-sw-0
  py:set "slr_1_sw" dam-sw-0.23
  py:set "slr_2_sw" dam-sw-1.41
  py:set "slr_3_sw" dam-sw-2.59
  py:set "slr_4_sw" dam-sw-4.41
  py:set "AEP" mbta-aep-list
  py:set "permitting_delay" permitting-delay
end


to setup-property_owner-python
    py:set "AEP_list" harbor-aep-list
    py:set "slr_zero" slr_zero
    py:set "elevation" elevation
    py:set "slr_proj" mun-slr-proj
    ;py:set "year" year
    py:set "discount" discount
    ;py:set "max_range" foresight
    py:set "property_value" property_value
    py:set "permitting_delay" permitting-delay

end





to setup-municipal-python
        ;py:set "max_range" foresight
        py:set "slr_proj" mun-slr-proj
        ;py:set "year" year
        py:set "discount" discount
        py:set "quincy_0" dam-0
        py:set "quincy_1" dam-1
        py:set "quincy_3" dam-3
        py:set "quincy_5" dam-5
        py:set "quincy_0_sw" dam-0-sw
        py:set "quincy_1_sw" dam-1-sw
        py:set "quincy_3_sw" dam-3-sw
        py:set "quincy_5_sw" dam-5-sw
        py:set "AEP" mun-aep-list
        py:set "permitting_delay" permitting-delay
end

to municipality-projected-damages
  ;py:set "year" (year + planning-horizon-delay)
  (py:run
          "rise_per_year = slr_proj/100"
          "annual_proj_damage=[]"
          "proj_list_wout_discount=[]"
          "total_rise_list = []"
          "for i in range(0, max_range):"
          "   total_rise = rise_per_year * (year - 2000)"
          "   total_rise_list.append(total_rise)"
          "   if total_rise < 1:"
          "      slr_list=[0,1]"
          "      low_damage = quincy_0"
          "      high_damage=quincy_1"
          "   if total_rise >= 1 and total_rise < 3:"
          "      slr_list=[1,3]"
          "      low_damage = quincy_1"
          "      high_damage=quincy_3"
          "   if total_rise >= 3:"
          "      slr_list=[3,5]"
          "      low_damage = quincy_3"
          "      high_damage=quincy_5"
          "   new_damages=[]"
          "   for j in range(0, len(low_damage)):"
          "      x = slr_list"
          "      y=[low_damage[j], high_damage[j]]"
          "      f = interpolate.interp1d(x,y,fill_value='extrapolate')"
          "      proj=float(f(total_rise))"
          "      new_damages.append(proj)"
          "   area=integrate.trapezoid(new_damages, x= AEP)"
          "   proj_list_wout_discount.append(area)"
          "   annual_damage= area/((1 + discount) ** (year - 2021))"
          "   annual_proj_damage.append(annual_damage)"
          "   year += 1"
    ;print("annual damage list", annual_proj_damage)
          ;"   if i == 0:"
          ;"      this_year_damage = annual_damage"
          "thirty_year_damage=sum(annual_proj_damage)")
          ;set annual-expected-damage py:runresult "this_year_damage"
          set python-output py:runresult "thirty_year_damage"


end

to municipality-projected-damages-sw
  ;py:set "year" (year + planning-horizon-delay)
  py:set "permitting_delay" permitting-delay
      (py:run
          "rise_per_year = slr_proj/100"
          "annual_proj_damage_sw=[]"
          "proj_list_wout_discount_sw=[]"
          "total_rise_list = []"
     ;We need to calculate damages without adaptation for lenght of permitting process
          "for i in range(0, max_range):"
     ;if i < permitting delay, we must calculate without adaptation option
          "   total_rise = rise_per_year * (year - 2000)"
          "   total_rise_list.append(total_rise)"
          "   if total_rise < 1:"
          "      slr_list=[0,1]"
          "      low_damage = quincy_0_sw"
          "      high_damage=quincy_1_sw"
          "   if total_rise >= 1 and total_rise < 3:"
          "      slr_list=[1,3]"
          "      low_damage = quincy_1_sw"
          "      high_damage=quincy_3_sw"
          "   if total_rise >= 3:"
          "      slr_list=[3,5]"
          "      low_damage = quincy_3_sw"
          "      high_damage=quincy_5_sw"
          "   new_damages_sw=[]"
          "   for j in range(0, len(low_damage)):"
          "      x = slr_list"
          "      y=[low_damage[j], high_damage[j]]"
          "      f = interpolate.interp1d(x,y,fill_value='extrapolate')"
          "      proj=float(f(total_rise))"
          "      new_damages_sw.append(proj)"
          "   area=integrate.trapezoid(new_damages_sw, x= AEP)"
          "   proj_list_wout_discount_sw.append(area)"
          "   annual_damage_sw= area/((1 + discount) ** (year - 2021))"
          "   annual_proj_damage_sw.append(annual_damage_sw)"
          "   year += 1"
          ;"   if i == 0:"
          ;"      this_year_damage_sw = annual_damage_sw"
          "thirty_year_damage_sw=sum(annual_proj_damage_sw)")
           set python-output py:runresult "thirty_year_damage_sw"
           ;set python-output py:runresult "this_year_damage_sw"
end

to pa-projected-damages
  py:set "flood_protect_height" flood-protect-height
  ; py:set "year" (year + planning-horizon-delay)
           (py:run
            "rise_per_year = slr_proj/100"
            "annual_proj_damage=[]"
            "proj_list_wout_discount=[]"
            "total_rise_list = []"
            "for i in range(0, max_range):"
            "   total_rise = rise_per_year * (year - 2000)"
            "   total_rise_list.append(total_rise)"
            "   aep_damage_list = []"
            "   slr_fit = [x + total_rise for x in slr_zero]"
            "   for j in range(0, len(slr_fit)):"
            "      inundation = slr_fit[j] - elevation"
            "      if flood_protect_height > elevation:"
            "         if slr_fit[j] < flood_protect_height:"
            "            damage_val = 0"
            "         else:"
            "            damage_val = 1000000000"
            "      else:"
            "         if inundation <= 3:"
            "            damage_val = 0"
            "         if inundation > 3:"
            "            damage_val = 1000000000"
            "      aep_damage_list.append(damage_val)"
            "   area=integrate.trapezoid(aep_damage_list, x= AEP_list)"
            "   proj_list_wout_discount.append(area)"
            "   annual_damage= area/((1 + discount) ** (year-2021))"
            "   annual_proj_damage.append(annual_damage)"
            "   year += 1"
            "   if i == 0:"
            "      this_year_damage = annual_damage"
            "thirty_year_damage=sum(annual_proj_damage)")
           set annual-expected-damage py:runresult "this_year_damage"
           set thirty_year_damage py:runresult "thirty_year_damage"
end

to pa-projected-damages-sw
   py:set "flood_protect_height" flood-protect-height
   ;py:set "year" (year + planning-horizon-delay)
           (py:run
            "rise_per_year = slr_proj/100"
            "annual_proj_damage_sw=[]"
            "proj_list_wout_discount_sw=[]"
            "total_rise_list = []"
            "for i in range(0, max_range):"
            "   total_rise = rise_per_year * (year - 2000)"
            "   total_rise_list.append(total_rise)"
            "   aep_damage_list_sw = []"
            "   slr_fit = [x + total_rise for x in slr_zero]"
            "   for j in range(0, len(slr_fit)):"
            "      inundation = slr_fit[j] - elevation"
            "      if flood_protect_height > elevation:"
            "         if slr_fit[j] < flood_protect_height:"
            "            damage_val = 0"
            "         else:"
            "            damage_val = 1000000000"
            "      else:"
            "         if inundation <= 3:"
            "            damage_val = 0"
            "         if inundation > 3:"
            "            damage_val = 1000000000"
            "      aep_damage_list_sw.append(damage_val)"
            "   area=integrate.trapezoid(aep_damage_list_sw, x= AEP_list)"
            "   proj_list_wout_discount_sw.append(area)"
            "   annual_damage_sw= area/((1 + discount) ** (year-2021))"
            "   annual_proj_damage_sw.append(annual_damage_sw)"
            "   year += 1"
            "   if i == 0:"
            "      this_year_damage_sw = annual_damage_sw"
            "thirty_year_damage_sw=sum(annual_proj_damage_sw)")
           set thirty_year_damage_sw py:runresult "thirty_year_damage_sw"
           set annual-expected-damage-sw py:runresult "this_year_damage_sw"
end



to property_owner-projected-damages
  ;adapt-test-mun marks adapatation of municipality

   py:set "flood_protect_height" flood-protect-height
   py:set "property_value" property_value
   ;py:set "year" (year + planning-horizon-delay)
           (py:run
            "rise_per_year = slr_proj/100"
            "annual_proj_damage=[]"
            "proj_list_wout_discount=[]"
            "total_rise_list = []"
            "for i in range(0, max_range):"
            "   total_rise = rise_per_year * (year - 2000)"
            "   total_rise_list.append(total_rise)"
            "   percent_damage_list_for_aep = []"
            "   slr_fit = [x + total_rise for x in slr_zero]"
            "   for j in range(0, len(slr_fit)):"
            "      inundation = slr_fit[j] - elevation"
            "      if flood_protect_height > elevation:"
            "         if slr_fit[j] < flood_protect_height:"
            "            damage_val = 0"
            "         else:"
            "            damage_val = (.0001826*inundation**3) - (.00511655*inundation**2) + (.0745843*inundation) - .00078322"
            "      else:"
            "         if inundation <= 0:"
            "            damage_val = 0"
            "         if inundation > 0:"
            "            damage_val = (.0001826*inundation**3) - (.00511655*inundation**2) + (.0745843*inundation) - .00078322"
            "      percent_damage_list_for_aep.append(damage_val)"
            "      aep_damage_list= [property_value * x for x in percent_damage_list_for_aep]"
            "   area=integrate.trapezoid(aep_damage_list, x= AEP_list)"
            "   proj_list_wout_discount.append(area)"
            "   annual_damage= area/((1 + discount) ** (year-2021))"
            "   annual_proj_damage.append(annual_damage)"
            "   year += 1"
            ;"   if i == 0:"
            ;"      this_year_damage = annual_damage"
            "thirty_year_damage = sum(annual_proj_damage)")
           ;set annual-expected-damage py:runresult "this_year_damage"
           set python-output py:runresult "thirty_year_damage"


end

to property_owner-projected-damages-af
  ;adapt-test-mun marks adapatation of municipality
   py:set "flood_protect_height" flood-protect-height
   ;py:set "year" (year + planning-horizon-delay)
 (py:run
            "rise_per_year = slr_proj/100"
            "annual_proj_damage_af=[]"
            "proj_list_wout_discount=[]"
            "total_rise_list = []"
            "for i in range(0, max_range):"
            "   total_rise = rise_per_year * (year - 2000)"
            "   total_rise_list.append(total_rise)"
            "   percent_damage_list_for_aep = []"
            "   slr_fit = [x + total_rise for x in slr_zero]"
            "   for j in range(0, len(slr_fit)):"
            "      inundation = slr_fit[j] - elevation"
            "      if flood_protect_height > elevation:"
            "         if slr_fit[j] < flood_protect_height:"
            "            damage_val = 0"
            "         else:"
            "            damage_val = (.0001826*inundation**3) - (.00511655*inundation**2) + (.0745843*inundation) - .00078322"
            "      else:"
            "         if inundation <= 3:"
            "            damage_val = 0"
            "         if inundation > 3:"
            "            damage_val = (.0001826*inundation**3) - (.00511655*inundation**2) + (.0745843*inundation) - .00078322"
            "      percent_damage_list_for_aep.append(damage_val)"
            "      aep_damage_list= [property_value * x for x in percent_damage_list_for_aep]"
            "   area=integrate.trapezoid(aep_damage_list, x= AEP_list)"
            "   proj_list_wout_discount.append(area)"
            "   annual_damage= area/((1 + discount) ** (year-2021))"
            "   annual_proj_damage_af.append(annual_damage)"
            "   year += 1"
            ;"   if i == 0:"
            ;"      this_year_damage_af = annual_damage"
            "thirty_year_damage_af = sum(annual_proj_damage_af)")

           ;set annual-expected-damage-af py:runresult "this_year_damage_af"
           set python-output py:runresult "thirty_year_damage_af"
end

to property_owner-projected-damages-sw
  ;adapt-test-mun marks adapatation of municipality
  py:set "flood_protect_height" flood-protect-height
  ;py:set "year" (year + planning-horizon-delay)
(py:run
            "rise_per_year = slr_proj/100"
            "annual_proj_damage_sw=[]"
            "proj_list_wout_discount=[]"
            "total_rise_list = []"
            "for i in range(0, max_range):"
            "   total_rise = rise_per_year * (year - 2000)"
            "   total_rise_list.append(total_rise)"
            "   percent_damage_list_for_aep = []"
            "   slr_fit = [x + total_rise for x in slr_zero]"
            "   for j in range(0, len(slr_fit)):"
            "      inundation = slr_fit[j] - elevation"
            "      if flood_protect_height > elevation:"
            "         if slr_fit[j] < flood_protect_height:"
            "            damage_val = 0"
            "         else:"
            "            damage_val = (.0001826*inundation**3) - (.00511655*inundation**2) + (.0745843*inundation) - .00078322"
            "      else:"
   ;assumes on site seawall height of 15 ft above elevation -> not an accurate assumption -> need to improve
            "         if inundation <= 15:"
            "            damage_val = 0"
            "         if inundation > 15:"
            "            damage_val = (.0001826*inundation**3) - (.00511655*inundation**2) + (.0745843*inundation) - .00078322"
            "      percent_damage_list_for_aep.append(damage_val)"
            "      aep_damage_list= [property_value * x for x in percent_damage_list_for_aep]"
            "   area=integrate.trapezoid(aep_damage_list, x= AEP_list)"
            "   proj_list_wout_discount.append(area)"
            "   annual_damage= area/((1 + discount) ** (year-2021))"
            "   annual_proj_damage_sw.append(annual_damage)"
            "   year += 1"
            ;"   if i == 0:"
            ;"      this_year_damage_sw = annual_damage"
            "thirty_year_damage_sw = sum(annual_proj_damage_sw)")
           ;set annual-expected-damage-sw py:runresult "this_year_damage_sw"
           set python-output py:runresult "thirty_year_damage_sw"
end

to mbta-projected-damages
  ;py:set "year" (year + planning-horizon-delay)
  (py:run
          "rise_per_year = slr_proj/100"
          "annual_proj_damage=[]"
          "proj_list_wout_discount=[]"
          "total_rise_list = []"
          "for i in range(0, max_range):"
          "   total_rise = rise_per_year * (year - 2000)"
          "   total_rise_list.append(total_rise)"
          "   if total_rise < 0.23:"
          "      slr_list=[0,.23]"
          "      low_damage = slr_0"
          "      high_damage=slr_1"
          "   if total_rise >= .23 and total_rise < 1.41:"
          "      slr_list=[.23,1.41]"
          "      low_damage = slr_1"
          "      high_damage=slr_2"
          "   if total_rise >= 1.41 and total_rise < 2.59:"
          "      slr_list=[1.41, 2.49]"
          "      low_damage = slr_2"
          "      high_damage= slr_3"
          "   if total_rise >= 2.59:"
          "      slr_list=[2.59, 4.41]"
          "      low_damage = slr_3"
          "      high_damage= slr_4"
          "   new_damages=[]"
          "   for j in range(0, len(low_damage)):"
          "      x = slr_list"
          "      y=[low_damage[j], high_damage[j]]"
          "      f = interpolate.interp1d(x,y,fill_value='extrapolate')"
          "      proj=float(f(total_rise))"
          "      new_damages.append(proj)"
          "   area=integrate.trapezoid(new_damages, x= AEP)"
          "   proj_list_wout_discount.append(area)"
          "   annual_damage= area/((1 + discount) ** (year-2021))"
          "   annual_proj_damage.append(annual_damage)"
          "   year += 1"
    ;print("annual damage list", annual_proj_damage)
          "   if i == 0:"
          "      this_year_damage = annual_damage"
          "thirty_year_damage=sum(annual_proj_damage)")
           set annual-expected-damage py:runresult "this_year_damage"
           set thirty_year_damage py:runresult "thirty_year_damage"
end

to mbta-projected-damages-sw
  ;py:set "year" (year + planning-horizon-delay)
        (py:run
          "rise_per_year = slr_proj/100"
          "annual_proj_damage_sw=[]"
          "proj_list_wout_discount_sw=[]"
          "total_rise_list_sw = []"
          "for i in range(0, max_range):"
          "   total_rise = rise_per_year * (year - 2000)"
          "   total_rise_list_sw.append(total_rise)"
          "   if total_rise < 0.23:"
          "      slr_list=[0 , 0.23]"
          "      low_damage = slr_0_sw"
          "      high_damage=slr_1_sw"
          "   if total_rise >= .23 and total_rise < 1.41:"
          "      slr_list=[.23, 1.41]"
          "      low_damage = slr_1_sw"
          "      high_damage=slr_2_sw"
          "   if total_rise >= 1.41 and total_rise < 2.59:"
          "      slr_list=[1.41, 2.49]"
          "      low_damage = slr_2_sw"
          "      high_damage= slr_3_sw"
          "   if total_rise >= 2.59:"
          "      slr_list=[2.59, 4.41]"
          "      low_damage = slr_3_sw"
          "      high_damage= slr_4_sw"
          "   new_damages_sw=[]"
          "   for j in range(0, len(low_damage)):"
          "      x = slr_list"
          "      y=[low_damage[j], high_damage[j]]"
          "      f = interpolate.interp1d(x,y,fill_value='extrapolate')"
          "      proj=float(f(total_rise))"
          "      new_damages_sw.append(proj)"
          "   area=integrate.trapezoid(new_damages_sw, x= AEP)"
          "   proj_list_wout_discount_sw.append(area)"
          "   annual_damage= area/((1 + discount) ** (year-2021))"
          "   annual_proj_damage_sw.append(annual_damage)"
          "   year += 1"
    ;print("annual damage list", annual_proj_damage)
          "   if i == 0:"
          "      this_year_damage_sw = annual_damage"
          "thirty_year_damage_sw=sum(annual_proj_damage_sw)")
           set annual-expected-damage-sw py:runresult "this_year_damage_sw"
           set thirty_year_damage_sw py:runresult "thirty_year_damage_sw"
end


to adaptation-decision-boston
  py:set "slr_proj" mun-slr-proj
  py:set "discount" discount
  py:set "AEP" mun-aep-list
  ;py:set "max_range" foresight
  py:set "permitting_delay" permitting-delay
  let damage-list (list allston-dam-list backbay-dam-list charlestown-dam-list downtown-dam-list eastboston-dam-list fenway-dam-list ndorchester-combined-dam-list sboston-combined-dam-list sdorchester-dam-list)
  ;coastline-length-list
  ;boston-adaptation-list
  set test-pos 0
  ;set annual-expected-damage-boston-list (list 0 0 0 0 0 0 0 0 0)

  foreach boston-adaptation-list [
    [x]-> set current-adapt x

    ifelse current-adapt = "none"[
      let coast-test item test-pos coastline-length-list
      ;let damagelist [[0 0 0 0] [0 0 0 0 0] [0 0 0 0 0] [0 0 0 0 0] [0 0 0 0 0] [0 0 0 0 0] [0 0 0 0 0] [0 0 0 0 0] [0 0 0 0 0]]
      let damagelist item test-pos damage-list
      ;;;;output-print(damagelist)
      py:set "quincy_0" item 0 damagelist
      py:set "quincy_1" item 1 damagelist
      py:set "quincy_3" item 2 damagelist
      py:set "quincy_5" item 3 damagelist
      py:set "quincy_0_sw" item 4 damagelist
      py:set "quincy_1_sw" item 5 damagelist
      py:set "quincy_3_sw" item 6 damagelist
      py:set "quincy_5_sw" item 7 damagelist
      py:set "max_range" foresight

       setup-municipal-python
        py:set "year" year
        py:set "max_range" 1
        municipality-projected-damages
        set annual-expected-damage python-output
        ;step 2: calculate the damages that would happen without a seawall in place
        setup-municipal-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        municipality-projected-damages
        set thirty_year_damage python-output
        ;step 3: calculate damages that would occur with a seawall in place
        setup-municipal-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        municipality-projected-damages
        let damage_wout_adaptation python-output
        setup-municipal-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - (permitting-delay)
        municipality-projected-damages-sw
        let damage_w_adaptation python-output
        set thirty_year_damage_sw (damage_wout_adaptation + damage_w_adaptation)


      ;municipality-projected-damages
      ;py:set "year" year
      ;municipality-projected-damages-sw
      let seawall-benefit (thirty_year_damage - thirty_year_damage_sw)
      set boston-thirty-year-damage-sw-list replace-item test-pos boston-thirty-year-damage-sw-list thirty_year_damage_sw
      set boston-thirty-year-damage-list replace-item test-pos boston-thirty-year-damage-list thirty_year_damage
      set boston-seawall-costs-avoided-list replace-item test-pos boston-seawall-costs-avoided-list seawall-benefit
      set annual-expected-damage-boston-list replace-item test-pos annual-expected-damage-boston-list annual-expected-damage
      set annual-expected-damage-boston-list-sw replace-item test-pos annual-expected-damage-boston-list-sw annual-expected-damage-sw
      ;write code that will call the correct weight for EJ weighting, or leave it as 1 if the prioritization is 'normal'
      ifelse prioritization-method = "EJ" [
        set ej-weight item (test-pos + 2) harbor-region-EJ-weights
      ]
      [set ej-weight 1]


      if seawall-benefit > 0 [
        ;let coast-test 500
        let cost-2020 coast-test * 7500
        let cost-2020-perm cost-2020 + (cost-2020 * permitting-cost-proportion)
        let cost-2020-all cost-2020-perm + (cost-2020 * foresight * O_M_proportion)
        let cost-discount-perm (cost-2020-perm)/((1 + discount) ^ (year - 2021))
        let cost-discount-all (cost-2020-all)/((1 + discount) ^ (year - 2021))
        let cost-perm cost-discount-perm * (1 - external-financing-percent)
        let cost-all cost-discount-all * (1 - external-financing-percent)
        set cost-benefit-seawall-bos ((seawall-benefit * ej-weight) / cost-all)
        if flood-reaction-municipalities = True[
        if annual-expected-damage > 0 [
        let behave-ratio (first [damage-time-step] of municipalities with [name = "boston"]) / annual-expected-damage
          set cost-benefit-seawall-bos cost-benefit-seawall-bos * behave-ratio]
        ]
        set boston-seawall-cost-benefit-list replace-item test-pos boston-seawall-cost-benefit-list cost-benefit-seawall-bos
        if cost-benefit-seawall-bos > 1[
          ;;;;output-print("building seawall")
        let adapt-intent "seawall"
        set boston-adaptation-intention-list replace-item test-pos boston-adaptation-intention-list adapt-intent
        set boston-planned-adaptation-cost-list replace-item test-pos boston-planned-adaptation-cost-list cost-perm
          ]
          ]

    ]
    [ ;nothing else to do- these is something here

    ]
    set test-pos test-pos + 1
  ]
end

to adaptation-decision-boston-ra
  ;py:set "max_range" foresight
  py:set "slr_proj" mun-slr-proj
  ;py:set "year" (year + planning-horizon-delay)
  py:set "discount" discount
  py:set "AEP" mun-aep-list
  set potential-sw-cost (list 0 0 0 0 0 0 0 0 0)
  let damage-list (list allston-dam-list backbay-dam-list charlestown-dam-list downtown-dam-list eastboston-dam-list fenway-dam-list ndorchester-combined-dam-list sboston-combined-dam-list sdorchester-dam-list)
  ;coastline-length-list
  ;boston-adaptation-list
  set test-pos 0
  ;set annual-expected-damage-boston-list (list 0 0 0 0 0 0 0 0 0)
set boston-total-damage-list (list allston-dam-list backbay-dam-list charlestown-dam-list downtown-dam-list eastboston-dam-list fenway-dam-list ndorchester-combined-dam-list sboston-combined-dam-list sdorchester-dam-list)
  foreach boston-adaptation-list [
    [x]-> set current-adapt x
      let coast-test item test-pos coastline-length-list
      let damagelist item test-pos boston-total-damage-list
      ;;;;output-print(damagelist)
      py:set "quincy_0" item 0 damagelist
      py:set "quincy_1" item 1 damagelist
      py:set "quincy_3" item 2 damagelist
      py:set "quincy_5" item 3 damagelist
      py:set "quincy_0_sw" item 4 damagelist
      py:set "quincy_1_sw" item 5 damagelist
      py:set "quincy_3_sw" item 6 damagelist
      py:set "quincy_5_sw" item 7 damagelist

      setup-municipal-python
        py:set "year" year
        py:set "max_range" 1
        municipality-projected-damages
        set annual-expected-damage python-output
        ;step 2: calculate the damages that would happen without a seawall in place
        setup-municipal-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        municipality-projected-damages
        set thirty_year_damage python-output
        ;step 3: calculate damages that would occur with a seawall in place
        setup-municipal-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        municipality-projected-damages
        let damage_wout_adaptation python-output
        setup-municipal-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - (permitting-delay)
        municipality-projected-damages-sw
        let damage_w_adaptation python-output
        set thirty_year_damage_sw (damage_wout_adaptation + damage_w_adaptation)

      ;set annual-expected-damage py:runresult "this_year_damage"
      set annual-expected-damage-boston-list replace-item test-pos annual-expected-damage-boston-list annual-expected-damage
      set annual-expected-damage-boston-list-sw replace-item test-pos annual-expected-damage-boston-list-sw annual-expected-damage-sw
      ;set thirty_year_damage py:runresult "thirty_year_damage"
      set boston-thirty-year-damage-list replace-item test-pos boston-thirty-year-damage-list thirty_year_damage
     ; set thirty_year_damage_sw py:runresult "thirty_year_damage_sw"
      set boston-thirty-year-damage-sw-list replace-item test-pos boston-thirty-year-damage-sw-list thirty_year_damage_sw
    ;write code that will call the correct weight for EJ weighting, or leave it as 1 if the prioritization is 'normal'
      ifelse prioritization-method = "EJ" [
        set ej-weight item (test-pos + 2) harbor-region-EJ-weights
      ]
      [set ej-weight 1]
        ;set boston-seawall-costs-avoided-list replace-item test-pos boston-seawall-costs-avoided-list seawall-benefit
       let cost-2020 coast-test * 7500
       let cost-2020-perm cost-2020 + (cost-2020 * permitting-cost-proportion) + (cost-2020 * maintenance-fee)
       let cost-2020-all cost-2020-perm + (cost-2020 * foresight * O_M_proportion)
       let cost-discount-perm (cost-2020-perm)/((1 + discount) ^ (year - 2021))
       let cost-discount-all (cost-2020-all)/((1 + discount) ^ (year - 2021))
       let cost-perm cost-discount-perm * (1 - external-financing-percent)
       let cost-all cost-discount-all * (1 - external-financing-percent)
       set boston-planned-adaptation-cost-list replace-item test-pos boston-planned-adaptation-cost-list cost-perm
       set boston-planned-adaptation-cost-list-om replace-item test-pos boston-planned-adaptation-cost-list-om cost-all
       set test-pos test-pos + 1]

end


to adaptation-decision-boston-vc
  ;py:set "max_range" foresight
  py:set "slr_proj" mun-slr-proj
  py:set "year" (year + planning-horizon-delay)
  py:set "discount" discount
  py:set "AEP" mun-aep-list
  let damage-list (list allston-dam-list backbay-dam-list charlestown-dam-list downtown-dam-list eastboston-dam-list fenway-dam-list ndorchester-combined-dam-list sboston-combined-dam-list sdorchester-dam-list)
  set test-pos 0
  set annual-expected-damage-boston-list (list 0 0 0 0 0 0 0 0 0)
  foreach boston-adaptation-list [
    [x]-> set current-adapt x
    ;;output-print("test-pos")
    ;;output-print(test-pos)
    ifelse current-adapt = "none"[
      let coast-test item test-pos coastline-length-list
      let damagelist item test-pos damage-list
      ;;;;output-print(damagelist)
      py:set "quincy_0" item 0 damagelist
      ;;output-print(py:runresult "quincy_0")
      py:set "quincy_1" item 1 damagelist
      ;;output-print(py:runresult "quincy_1")
      py:set "quincy_3" item 2 damagelist
      ;;output-print(py:runresult "quincy_3")
      py:set "quincy_5" item 3 damagelist
      ;;output-print(py:runresult "quincy_5")
      py:set "quincy_0_sw" item 4 damagelist
      ;;output-print(py:runresult "quincy_0_sw")
      py:set "quincy_1_sw" item 5 damagelist
      ;;output-print(py:runresult "quincy_1_sw")
      py:set "quincy_3_sw" item 6 damagelist
      ;;output-print(py:runresult "quincy_3_sw")
      py:set "quincy_5_sw" item 7 damagelist
      ;;output-print(py:runresult "quincy_5_sw")
      setup-municipal-python
        py:set "year" year
        py:set "max_range" 1
        municipality-projected-damages
        set annual-expected-damage python-output
        ;step 2: calculate the damages that would happen without a seawall in place
        setup-municipal-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" foresight
        municipality-projected-damages
        set thirty_year_damage python-output
        ;step 3: calculate damages that would occur with a seawall in place
        setup-municipal-python
        py:set "year" year + planning-horizon-delay
        py:set "max_range" permitting-delay + 1
        municipality-projected-damages
        let damage_wout_adaptation python-output
        setup-municipal-python
        py:set "year" year + planning-horizon-delay + permitting-delay
        py:set "max_range" foresight - (permitting-delay)
        municipality-projected-damages-sw
        let damage_w_adaptation python-output
        set thirty_year_damage_sw (damage_wout_adaptation + damage_w_adaptation)

       if vc-linked-damages-dm = True[
        let link-adjustment (count(my-out-links) * link-value * thirty_year_damage)
        let link-adjustment-sw (count(my-out-links) * link-value * thirty_year_damage_sw)
        set thirty_year_damage thirty_year_damage + link-adjustment
        set thirty_year_damage_sw thirty_year_damage_sw + link-adjustment-sw]
        ;;;;output-print("30-year Damage without seawall")
        ;;;;output-print(thirty_year_damage)
        ;;;;output-print("30-year Damage with seawall")
        ;;;;output-print(thirty_year_damage_sw)
      ;write code that will call the correct weight for EJ weighting, or leave it as 1 if the prioritization is 'normal'
      ifelse prioritization-method = "EJ" [
        set ej-weight item (test-pos + 2) harbor-region-EJ-weights
      ]
      [set ej-weight 1]
        let seawall-benefit (thirty_year_damage - thirty_year_damage_sw) * ej-weight
        set boston-thirty-year-damage-sw-list replace-item test-pos boston-thirty-year-damage-sw-list thirty_year_damage_sw
        set boston-thirty-year-damage-list replace-item test-pos boston-thirty-year-damage-list thirty_year_damage
        set boston-seawall-costs-avoided-list replace-item test-pos boston-seawall-costs-avoided-list seawall-benefit
        set annual-expected-damage-boston-list replace-item test-pos annual-expected-damage-boston-list annual-expected-damage
        set annual-expected-damage-boston-list-sw replace-item test-pos annual-expected-damage-boston-list-sw annual-expected-damage-sw
      ;;;;output-print("Benefit of Seawall")
        ;;;;output-print(seawall-benefit)
        if seawall-benefit > 0 [
        let cost-2020 coast-test * 7500
        let cost-2020-perm cost-2020 + (cost-2020 * permitting-cost-proportion)
        let cost-2020-all cost-2020-perm + (cost-2020 * foresight * O_M_proportion)
        let cost-2020-perm-with-maintainance-fee (cost-2020 * (1 + maintenance-fee)) + (cost-2020 * permitting-cost-proportion)
        let cost-2020-all-with-maintainance-fee cost-2020-perm-with-maintainance-fee + (cost-2020 * foresight * O_M_proportion)

        let cost-perm-with-maintenance-fee (cost-2020-perm-with-maintainance-fee)/((1 + discount) ^ (year - 2021)) * (1 - external-financing-percent)
        let cost-all-with-maintenance-fee (cost-2020-all-with-maintainance-fee)/((1 + discount) ^ (year - 2021)) * (1 - external-financing-percent)


        let cost-discount-perm (cost-2020-perm)/((1 + discount) ^ (year - 2021))
        let cost-discount-all (cost-2020-all)/((1 + discount) ^ (year - 2021))
        let cost-perm cost-discount-perm * (1 - external-financing-percent)
        let cost-all cost-discount-all * (1 - external-financing-percent)

        set cost-benefit-seawall-bos ((seawall-benefit) / cost-all)
        set seawall-cost-benefit-cooperative (seawall-benefit / cost-all-with-maintenance-fee)
        ;output-print(cost-benefit-seawall-bos)
        ;output-print(seawall-cost-benefit-cooperative)
          if flood-reaction-municipalities = True[
          let behave-ratio (first [damage-time-step] of municipalities with [name = "boston"]) / annual-expected-damage
              set cost-benefit-seawall-bos cost-benefit-seawall-bos * behave-ratio
              set seawall-cost-benefit-cooperative seawall-cost-benefit-cooperative * behave-ratio
        ]

          set boston-seawall-cost-benefit-list replace-item test-pos boston-seawall-cost-benefit-list cost-benefit-seawall-bos
         set seawall-cost-benefit-cooperative-boston-list replace-item test-pos seawall-cost-benefit-cooperative-boston-list seawall-cost-benefit-cooperative
          if cost-benefit-seawall-bos > 1[
          ;;;;output-print("building seawall")
          let adapt-intent "seawall"
          set boston-adaptation-intention-list replace-item test-pos boston-adaptation-intention-list adapt-intent
          set boston-planned-adaptation-cost-list replace-item test-pos boston-planned-adaptation-cost-list cost-perm
          set seawall-cost-cooperative-boston-list replace-item test-pos seawall-cost-cooperative-boston-list cost-perm-with-maintenance-fee

          ]
          ]
    ]
      [;seawall already in place
      ]
    set test-pos test-pos + 1
  ]
end



to adaptation-implementation-regional-authority

  ;property_owners only have the option of purchasing insurance here- different suite of adaptations
  ask property_owners[

    ;for insurance purposes- assuming no financial cap, agents will purchase it if it makes sense for them beacuse they won't be able to pay damages otherwise
    ifelse insurance-intention = True [
      set insurance? True
      set adaptation-cost planned-adaptation-cost
      set total-adaptation-cost total-adaptation-cost + adaptation-cost]
    [;agent has no intention to purchase insurance
      set insurance? False
    set adaptation-cost 0
    set total-adaptation-cost total-adaptation-cost + adaptation-cost]]

ask regional-authorities [

  ifelse funding-cap = False [
      ;this section has no budget constraints
  set test-pos 0
      ;code below goes through each sw segment to evaluate and implement it
  foreach ra-adaptation-intention-list [
    [x]-> let adapt-intent x
    let adapt item test-pos ra-adaptation-list
    let cost item test-pos ra-adaptation-cost-list
    let neigh-permit-count item test-pos ra-permit-delay-list
        ;check there is a desire to adapt
    ifelse adapt != adapt-intent [
          ;check permitting delay
          ifelse neigh-permit-count >= permitting-delay[
            ;adapt
      set ra-total-adaptation-cost ra-total-adaptation-cost + cost
      set ra-adaptation-list replace-item test-pos ra-adaptation-list adapt-intent
      set ra-total-adaptation-cost-list replace-item test-pos ra-total-adaptation-cost-list cost
      set ra-base-adaptation-cost replace-item test-pos ra-base-adaptation-cost cost
      set ra-adaptation-cost-list replace-item test-pos ra-adaptation-cost-list cost
      set ra-permit-delay-list replace-item test-pos ra-permit-delay-list 0
      ;code below assigns agents to specific adaptations for the damage calculations - this is our way to link this version back to the 'no cooperation' version
          if test-pos = 0 [
        ask municipalities with [name = "north-shore"] [
           set adaptation "seawall"]
      ]
      if test-pos = 1 [
        ask municipalities with [name = "south-shore"] [
         set adaptation "seawall"]
      ]
      if test-pos = 2[ set boston-adaptation-list replace-item 0 boston-adaptation-list "seawall"
      ]
      if test-pos = 3[set boston-adaptation-list replace-item 1 boston-adaptation-list "seawall"
      ]
      if test-pos = 4[set boston-adaptation-list replace-item 2 boston-adaptation-list "seawall"
      ]
      if test-pos = 5[set boston-adaptation-list replace-item 3 boston-adaptation-list "seawall"
      ]
      if test-pos = 6[set boston-adaptation-list replace-item 4 boston-adaptation-list "seawall"
      ]
      if test-pos = 7[set boston-adaptation-list replace-item 5 boston-adaptation-list "seawall"
      ]
      if test-pos = 8[set boston-adaptation-list replace-item 6 boston-adaptation-list "seawall"
      ]
      if test-pos = 9[set boston-adaptation-list replace-item 7 boston-adaptation-list "seawall"
      ]
      if test-pos = 10[set boston-adaptation-list replace-item 8 boston-adaptation-list "seawall"
      ]
    ]
          [;neigh-permit-count < permitting-delay
            set ra-adaptation-cost-list replace-item test-pos ra-adaptation-cost-list 0
            set ra-permit-delay-list replace-item test-pos ra-permit-delay-list (neigh-permit-count + 1)
          ]
        ]
        [;no desire to adapt
          set ra-adaptation-cost-list replace-item test-pos ra-adaptation-cost-list 0]
  ;continues to next sw segment
  set test-pos test-pos + 1
    ]
    ]


  [;funding-cap = True -> we need to prioritize where and when our spending goes
      ;1st method: best benefit-cost ratio
    ;ifelse prioritization-method = "normal" [
    set hold-adaptation? False
    ;ra-benefit-cost-ratio-list
    let sorted sort ra-benefit-cost-ratio-list
    ;create a list that maps the ranks of b-c ratios back to their initial position in sw segment list
    set ranked-list-nums map [ n -> position n sorted ] ra-benefit-cost-ratio-list
    ;create two empty lists to be used to process the data
    set empty-list []
    set used-list []
    ;reset variable that is used to ensure we work through each value in a list
    set test-pos 0
      foreach ranked-list-nums [
        ;assigns variable 'ranktest' for the ranks of b-c ratio in order of seawall segment
        [z] -> let ranktest z
        ;checks that value to see if it has been used so far
        ifelse member? z used-list [
          ;check how many times this value has been used so far
          let count-ranktest filter [ i -> i = ranktest ] used-list
          let val-count-ranktest length count-ranktest
          ;build new list that adjusts for when there are identical b-c rankings
          set empty-list lput (val-count-ranktest + ranktest ) empty-list
          ;build another list that maintains the original list over time
          set used-list lput (ranktest) used-list

        ]
        [;no duplicate rankings- can continue to use as nomal
          set empty-list lput (ranktest) empty-list
          set used-list lput (ranktest) used-list
        ]

        ;allows us to continue to keep track of how many loops we have done
          set test-pos test-pos + 1
      ]

      ;now we map the lists back to each other
      set time-step-costs 0
      ;this sets us up so that the 8th largest b-c starts, then 7th, then ....
      foreach reverse [0 1 2 3 4 5 6 7 8 9 10] [ ;this list has to be a list of the total number of rank positions
        [x] -> let rank-search x
        ;get the position value of the needed rank based on the list of final rankings in the positions of the sw segments
        let cb-item-order position rank-search empty-list
        ;using the sw-position value, get the final cost-benefit value
        let cb-item item cb-item-order  ra-benefit-cost-ratio-list
        ;they should always descend

        ;now we can start with the tests to actually implement an adaptation, in order of importance
        ;get adaptation intention of each regioin
        let adapt-intention item cb-item-order ra-adaptation-intention-list
        ;check existing adaptation
        let neighborhood-adapt item cb-item-order ra-adaptation-list
        ;get corresponding cost for the planned adaptation
        let cost-test item cb-item-order ra-planned-adaptation-cost-list
        let total-adapt-cost-region item cb-item-order ra-total-adaptation-cost-list
        let neigh-permit-count item cb-item-order ra-permit-delay-list


        ifelse neighborhood-adapt != adapt-intention [
            ifelse hold-adaptation? = false [
          let plan-cost-again item cb-item-order ra-planned-adaptation-cost-list
          let down-payment 0.10
          ifelse ra-available-budget > plan-cost-again * down-payment [
            ifelse neigh-permit-count >= permitting-delay[
            set ra-adaptation-list replace-item cb-item-order ra-adaptation-list adapt-intention
            set ra-available-budget ra-available-budget - plan-cost-again
            set ra-adaptation-cost-list replace-item cb-item-order ra-adaptation-cost-list plan-cost-again
            set ra-total-adaptation-cost-list replace-item cb-item-order ra-total-adaptation-cost-list plan-cost-again
            set ra-base-adaptation-cost replace-item cb-item-order ra-base-adaptation-cost plan-cost-again
            set ra-permit-delay-list replace-item cb-item-order ra-permit-delay-list 0
            set hold-adaptation? false

            ]
            [;permitting delay stops adaptation
              set ra-adaptation-cost-list replace-item cb-item-order ra-adaptation-cost-list 0
              set ra-permit-delay-list replace-item cb-item-order ra-permit-delay-list (neigh-permit-count + 1)
                  set hold-adaptation? false
            ]
            ]
          [
            ;not enough budget to adapt here
            set ra-adaptation-cost-list replace-item cb-item-order ra-adaptation-cost-list 0
            set ra-permit-delay-list replace-item cb-item-order ra-permit-delay-list (neigh-permit-count + 1)
                set hold-adaptation? true
             ]
          ]
            [;hold adaptation is true
              set ra-adaptation-cost-list replace-item cb-item-order ra-adaptation-cost-list 0
            set ra-permit-delay-list replace-item cb-item-order ra-permit-delay-list (neigh-permit-count + 1)
              set hold-adaptation? true
            ]
          ]
        [
          ;the proposed adaptation is already in place - no change to adaptation and no new money spent
          set ra-adaptation-cost-list replace-item cb-item-order ra-adaptation-cost-list 0
            set hold-adaptation? false
      ]
          ]

    ]
  ]

end

to updated-vc-11-28
  ;Note this is written assuming funding is capped and mbta is in segments
   set mbta-cooperative-adaptation-contribution-proposed 0
  set mbta-cooperative-adaptation-contribution 0
  ;sets a list for all 1 regions of mbta contributions and proposed contributions - these lines make sure this is fresh each time step
  set mbta-cooperative-adaptation-contribution-list [0 0 0 0 0 0 0 0 0 0 0]
  set mbta-cooperative-adaptation-contribution-list-proposed [0 0 0 0 0 0 0 0 0 0 0]
  ;start process by assuming cooperation does not occur- this is then checked for every agent
  ask turtles [
    set cooperative-construct? False
  ]
  set boston-coop-construct-list [false false false false false false false false false]
  set mbta-coop-construct-list [false false false false false false false false false false false]
  ;the following lines of code explore whether or not cooperative construction is a possibility- need to be needing to adapt
  ask property_owners [
    ifelse adaptation-intention != adaptation [
      if adaptation-intention = "aquafence" [
        ifelse elevation + 3 <= 15 [
          set cooperative-construct? True
        ]
        [set cooperative-construct? False]
      ]
      if adaptation-intention = "local-seawall" [
        set cooperative-construct? True]
    ]
    [set cooperative-construct? False]
  ]
  ask private-assets [
    ifelse adaptation-intention != adaptation [
      set cooperative-construct? True]
    [set cooperative-construct? False]
  ]

  ask mbta-agents [
    if mbta-adaptation-method = "all-at-once" [
    ifelse adaptation-intention != adaptation [
      set cooperative-construct? True]
    [set cooperative-construct? False]
    ]

    if mbta-adaptation-method = "segments" [
      set test-pos 0
      foreach mbta-adaptation-intention-list[
        [x] -> let adapt-intent-mbta-segment x
        let existing-mbta-adaptation item test-pos mbta-adaptation-list
        ifelse adapt-intent-mbta-segment != existing-mbta-adaptation [
          set mbta-coop-construct-list replace-item test-pos mbta-coop-construct-list True]
        [set mbta-coop-construct-list replace-item test-pos mbta-coop-construct-list False]
        set test-pos test-pos + 1
        ]
    ]
  ]


  ;Now, all agents either want to adapt (they have interest in cooperating with others, or not at all and this is marked with a true/false
  ;if a municipality/neighborhood is not interested in a joint seawall, then no cooperation will occur'

    ;without funding cap, all work should be cooperative
    ;Assumption: no municipality adaptation, no interest in cooperation among other agents
      ;not sure of this line 11/28
  ask municipalities with [name != "boston"] [
     if adaptation = adaptation-intention [
      let mun-name name
      ask property_owners with [dev-region = mun-name] [
      set cooperative-construct?  False ]
      if mbta-adaptation-method = "segments" [
      if name = "north-shore" [
        set mbta-coop-construct-list replace-item 0 mbta-coop-construct-list False]
     if name = "south-shore" [
        set mbta-coop-construct-list replace-item 1 mbta-coop-construct-list False]]
    ]
  ]

      let dt-adapt item 3 boston-adaptation-list
      let dt-adapt-intent item 3 boston-adaptation-intention-list
      let eb-adapt-intent item 4 boston-adaptation-intention-list
      let eb-adapt item 4 boston-adaptation-list
      let charles-adapt-intent item 2 boston-adaptation-intention-list
      let charles-adapt item 2 boston-adaptation-list
      if dt-adapt = dt-adapt-intent [
    ask property_owners with [dev-region = "boston"] [
      set cooperative-construct? False]]
      if eb-adapt-intent = eb-adapt[
      ask private-assets with [name = "BOS-air"] [
      set cooperative-construct? False] ]
      if charles-adapt-intent = charles-adapt [
      ask private-assets with [name = "food dist"] [
      set cooperative-construct? False] ]


      ;for each seawall segment
      ;if municipality has cooperative construction, add up the others
          ;if collaborative-cost + planned-cosntruction > cost + cost of collaboration
              ;stay collaborative
          ;don't be collaborative
               ;do this alone
               ;municipality operates alone

      ;calculate cooperative incentive for the north shore
      ;north shore contributions is mbta + north shore + property owners in the north shore
      ask municipalities with [name != "boston"] [
    ifelse adaptation-intention != adaptation [
        let reg name
        ifelse name = "north-shore" [
          set test-pos 0]
        [set test-pos 1]
        ;cooperative seawall cost is seawall-cost-cooperative
        ;check 1: is the municipality willing to cooperate
        ifelse seawall-cost-benefit-cooperative > 1 [
          ;we can continue the process- check what the planned cost of the adaptations of property owners is
          let cost-property_owners-with-insurance sum ([planned-adaptation-cost - insurance-cost] of property_owners with [cooperative-construct? = True and dev-region = reg and insurance-intention = True])
          let cost-property_owners-without-insurance sum ([planned-adaptation-cost] of property_owners with [cooperative-construct? = True and dev-region = reg and insurance-intention = False])
          let cost-property_owners cost-property_owners-with-insurance + cost-property_owners-without-insurance
          set cost-deduction-property_owners cost-property_owners
          ifelse item test-pos mbta-coop-construct-list = True [
            set mbta-adapt-cost-test item test-pos mbta-planned-adaptation-cost-list
          ]
          [set mbta-adapt-cost-test 0]
          let total_regional_contributions cost-deduction-property_owners + mbta-adapt-cost-test + planned-adaptation-cost
          ifelse total_regional_contributions > seawall-cost-cooperative [
            set cooperative-construct? True
          ]
          [ set cooperative-construct? False
          ]
        ]
        [;municipality is unwilling to adapt
          set cooperative-construct? False]
    ]
    [set cooperative-construct? False]
  ]

  ask municipalities with [name = "boston"] [
        set test-pos 0
        set cost-deduction-property_owners 0
        foreach seawall-cost-benefit-cooperative-boston-list [
        [x] -> let reg-coop-cost-ben x
        let planned-adapt item test-pos boston-adaptation-intention-list
        let adapt item test-pos boston-adaptation-list
      ifelse planned-adapt != adapt [

          ifelse reg-coop-cost-ben > 1[
          ;output-print("work")
            ;developers are all assumed to be downtown
        ;lets sum the potential contributed cost of developers and private assets
          ifelse test-pos = 3[
          let cost-property_owners-with-insurance sum ([planned-adaptation-cost - insurance-cost] of property_owners with [cooperative-construct? = True and dev-region = "boston" and insurance-intention = True])
          let cost-property_owners-without-insurance sum ([planned-adaptation-cost] of property_owners with [cooperative-construct? = True and dev-region = "boston" and insurance-intention = False])
          ;let cost-property_owners-with-insurance 0
          ;let cost-property_owners 0
            let cost-property_owners cost-property_owners-with-insurance + cost-property_owners-without-insurance
            set cost-deduction-property_owners cost-property_owners]
            [set cost-deduction-property_owners 0]
          if test-pos = 4 [
            if any? private-assets with [cooperative-construct? = True and name = "BOS-air"] [
            let airport-contribution sum([planned-adaptation-cost] of private-assets with [cooperative-construct? = True and name = "BOS-air"])
              ;let airport-contribution 0
          set cost-deduction-property_owners cost-deduction-property_owners + airport-contribution
           ;set cost-deduction-property_owners 0
          ]]
          if test-pos = 3 [
            if any? private-assets with [cooperative-construct? = True and name = "food dist"][
            let food-contribution sum([planned-adaptation-cost] of private-assets with [cooperative-construct? = True and name = "food dist"])
            ;let airport-contribution 0
            set cost-deduction-property_owners cost-deduction-property_owners + food-contribution
            ;set cost-deduction-property_owners 0
        ]]
          ;now we need to get estimated contribution of the mbta
          ifelse item (test-pos + 2) mbta-coop-construct-list = True [
          set mbta-costs-current item (test-pos + 2) mbta-planned-adaptation-cost-list]
        [set mbta-costs-current 0]

          ;now we compare the costs of cumulartive adaptation to the expensive seawall cost
        let bos-sw-segment-cost item test-pos boston-planned-adaptation-cost-list
          ;CHECK HERE 11/29
        ifelse (bos-sw-segment-cost + cost-deduction-property_owners + mbta-costs-current) > (item test-pos seawall-cost-cooperative-boston-list) [
            set boston-coop-construct-list replace-item test-pos boston-coop-construct-list True]
          [set boston-coop-construct-list replace-item test-pos boston-coop-construct-list False]

          ]
          [;no cooperation is desired sicne the cost-benefit ratio > 1
            set boston-coop-construct-list replace-item test-pos boston-coop-construct-list False
          ]

        ]
    [set boston-coop-construct-list replace-item test-pos boston-coop-construct-list False]
      set test-pos test-pos + 1
    ]

      ]


  ;We need to see if agents are wwilling toa dapt based on their new cost benefit based on the changed level of financing


  ;Now... based on the municipality being will to cooperate, we can re-evaluate the other agents cooperating
  ;Agents in north shore + south shore
  ask property_owners with [dev-region != "boston"] [
    let reg dev-region
    ifelse reg = "north-shore" [
      set test-pos 0]
    [set test-pos 1]
    let mun-coop-const [cooperative-construct?] of municipalities with [name = reg]
    if mun-coop-const = False [
      set cooperative-construct? False
      set mbta-coop-construct-list replace-item test-pos mbta-coop-construct-list False
      ]
  ]
  ;agents in downtown boston
  ask property_owners with [dev-region = "boston"] [
    let mun-coop-const item 3 boston-coop-construct-list
    if mun-coop-const = False [
      set cooperative-construct? False]
  ]
  ;Boston Airport
  ask private-assets with [name = "BOS-air"] [
    let mun-coop-const item 4 boston-coop-construct-list
    if mun-coop-const = False [
      set cooperative-construct? False]
  ]
  ;Food distribution
    ask private-assets with [name = "food dist"] [
    let mun-coop-const item 2 boston-coop-construct-list
    if mun-coop-const = False [
      set cooperative-construct? False]
  ]
 ;mbta
  set test-pos 0
   foreach boston-coop-construct-list[
        [x] -> let boston-coop x
        if x = False [
            set mbta-coop-construct-list replace-item (test-pos + 2) mbta-coop-construct-list False
    ]
        set test-pos test-pos + 1
        ]

  vc-pt-2-11-29
end

to vc-pt-2-11-29

  ;Start the process of assessing cooperative efforts seawall by seawall- here we start with NS and SS

  ask municipalities with [name != "boston"] [
    ;CODE HERE ONLY WORKS IF FUNDING CAP IS OFF
    if funding-cap = True [
       ;start only if there is a need to adapt
      ifelse cooperative-construct? = True [
        ;output-print("coop construct munn = true")
       ifelse adaptation != adaptation-intention [
        ;check permitting delay
        ifelse permit-delay-count >= permitting-delay [
          ;step 1: figure out how much property_owners are willing to contribute
          let reg-name name
          let cost-property_owners-with-insurance sum ([planned-adaptation-cost - insurance-cost] of property_owners with [cooperative-construct? = True and dev-region = reg-name and insurance-intention = True])
          let cost-property_owners-without-insurance sum ([planned-adaptation-cost] of property_owners with [cooperative-construct? = True and dev-region = reg-name and insurance-intention = False])
          let cost-property_owners cost-property_owners-with-insurance + cost-property_owners-without-insurance
              ;set a global variable for this so we can use it outside of the statements
          set cost-deduction-property_owners cost-property_owners
          let available-budget-property_owners sum ([available-budget] of property_owners with [cooperative-construct? = True and dev-region = reg-name])
            if name = "north-shore" [
              set pos 0]
            if name = "south-shore" [
              set pos 1]
      ; [;let's actually put mbta-method = segments here!
              ifelse item pos mbta-coop-construct-list = True [
              ;calculate proposed mbta contributions
          let cost-mbta-wout-discount item pos mbta-planned-adaptation-cost-list
          let total-contributions ((planned-adaptation-cost) + cost-mbta-wout-discount + cost-deduction-property_owners)
            ;output of segment-discount is the ratio of planned costs that are still paid for
             ;figure out what this discount is
          ifelse total-contributions > (planned-adaptation-cost * (1 + maintenance-fee)) [
                let segment-discount-pt-1 (total-contributions - (planned-adaptation-cost * (1 + maintenance-fee))) / (planned-adaptation-cost * (1 + maintenance-fee))
                set segment-discount-mun (1 / (segment-discount-pt-1 + 1))
              ]
              [;total-contributions < sw-segment-cost
                set segment-discount-mun 1
              ]
              ;mbta costs are updated to reflect the segment discount
            set mbta-cooperative-adaptation-contribution-proposed mbta-cooperative-adaptation-contribution-proposed + (cost-mbta-wout-discount * segment-discount-mun)
            ifelse reg-name = "north-shore" [
              set mbta-cooperative-adaptation-contribution-list-proposed replace-item 0 mbta-cooperative-adaptation-contribution-list-proposed (cost-mbta-wout-discount * segment-discount-mun)]
            [set mbta-cooperative-adaptation-contribution-list-proposed replace-item 1 mbta-cooperative-adaptation-contribution-list-proposed (cost-mbta-wout-discount * segment-discount-mun)]
          ;adaptation-cost now is lower- it is what the other agents would pay -> assume they go ahead and contribute (or are able to pay in later and take loans from municipality now)
           set available-budget-mbta (sum([available-budget] of mbta-agents)) * (item pos mbta-cost-proportion-list)
           ]

          [;item mbta-coop-construct-list = False -> the T is not cooperating for that segment, property_owners may still be cooperative
            let cost-mbta 0
            set mbta-cooperative-adaptation-contribution-proposed mbta-cooperative-adaptation-contribution-proposed + cost-mbta
            let total-contributions (planned-adaptation-cost + cost-property_owners)
            ;output of segment-discount is the ratio of planned costs that are still paid for
             ;figure out what this discount is
          ifelse total-contributions > (planned-adaptation-cost * (1 + maintenance-fee)) [
                let segment-discount-pt-1 (total-contributions - (planned-adaptation-cost * (1 + maintenance-fee))) / (planned-adaptation-cost * (1 + maintenance-fee))
                set segment-discount-mun (1 / (segment-discount-pt-1 + 1))
              ]
              [;total-contributions < sw-segment-cost
                set segment-discount-mun 1
              ]
              ;mbta costs are not updated to reflect 0 contributions- this only changes list
            ifelse reg-name = "north-shore" [
              set mbta-cooperative-adaptation-contribution-list-proposed replace-item 0 mbta-cooperative-adaptation-contribution-list-proposed 0]
            [set mbta-cooperative-adaptation-contribution-list-proposed replace-item 1 mbta-cooperative-adaptation-contribution-list-proposed 0]
          ;adaptation-cost now is lower- it is what the other agents would pay -> assume they go ahead and contribute (or are able to pay in later and take loans from municipality now
                  ;if mbta isn't willing to cooperate, they will contribute 0
                  set available-budget-mbta 0
            ]
         ; ]
            ;budget checks
            let down-payment .1
            ;add municipality, property_owners, and mbta cost together
            ;budget checks - all agents need to create sufficient funding
            ifelse (available-budget + available-budget-mbta + available-budget-property_owners)  >= ((planned-adaptation-cost * (1 + maintenance-fee)) * down-payment) [
              ;get default proposed mbta costs
                let mbta-proposed-costs item pos mbta-cooperative-adaptation-contribution-list-proposed
                set mbta-cooperative-adaptation-contribution mbta-cooperative-adaptation-contribution + mbta-proposed-costs
                set mbta-cooperative-adaptation-contribution-list replace-item pos mbta-cooperative-adaptation-contribution-list mbta-proposed-costs
                set adaptation adaptation-intention
                set available-budget available-budget - ((planned-adaptation-cost * (1 + maintenance-fee)) * segment-discount-mun)
                set adaptation-count adaptation-count + 1
                ;municipality gets to pay reduced costs
                set adaptation-cost ((planned-adaptation-cost * (1 + maintenance-fee)) * segment-discount-mun)
            ;vc-total-adaptation-costs tracks the total payment (does not factor in other things)
                set vc-total-adaptation-costs vc-total-adaptation-costs + planned-adaptation-cost
                set total-adaptation-cost total-adaptation-cost + adaptation-cost
                set wait-for-permit False
                set cooperative-construct? True
                ifelse adaptation = "seawall" [
                  set crs-discount 0.3]
                [set crs-discount 0]
                set permit-delay-count 0
            ]
            [;budget is not successful
                set adaptation-cost 0
                set total-adaptation-cost total-adaptation-cost + adaptation-cost
                set permit-delay-count permit-delay-count + 1
                set cooperative-construct? False
                set wait-for-permit False
                set mbta-cooperative-adaptation-contribution-list replace-item pos mbta-cooperative-adaptation-contribution-list 0
            ]
            ]
        [;permit delay has not been met, other agents will wait for permitting delay
          set adaptation-cost 0
          set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set permit-delay-count permit-delay-count + 1
          set cooperative-construct? True
          set wait-for-permit True
          set mbta-cooperative-adaptation-contribution-list replace-item pos mbta-cooperative-adaptation-contribution-list 0
        ]
      ]
      [;adaptation = adaptation-intention -> no deed to adapt
            set adaptation-cost 0
            set total-adaptation-cost total-adaptation-cost + adaptation-cost
            set permit-delay-count 0
            set cooperative-construct? False
            set wait-for-permit False
            set mbta-cooperative-adaptation-contribution-list replace-item pos mbta-cooperative-adaptation-contribution-list 0
      ]
    ]
      [;cooperative-construct = False
        ;do noncooperative adaptation
        municipality-adaptation-noncooperative
       ; output-print("municipality non cooperative")
      ]
      ]
  ]

  ;now we do it for boston
  boston-adaptation-implementation-vc

   ;Now, all other agents tack onto the municipalities- if they are cooperative and the agents are cooperative, they adapt

  ask property_owners with [cooperative-construct? = False] [
;this happens if the agent is not cooperative
    property_owner-adaptation-implementation-noncooperative
  ]

  ask property_owners with [cooperative-construct? = True] [
    if dev-region != "boston" [
      ;3 options here: the municipality wants ot cooperate and can cooperate, the municipality wants to cooperate, but can't, or the mun doesn't want to cooperate
      let region-name dev-region
      (ifelse first [cooperative-construct?] of municipalities with [name = region-name] = True and [wait-for-permit] of municipalities with [name = region-name] = False [
        ifelse insurance-intention = True [
         set insurance? True
          set adaptation-cost planned-adaptation-cost * ([segment-discount-mun] of municipalities with [name = dev-region])
        ]
         [set insurance? False
        ;set adaptation-cost 0
          set adaptation-cost planned-adaptation-cost * ([segment-discount-mun] of municipalities with [name = dev-region])
        ]
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
      set adaptation-intention "none"
        set permit-delay-count 0
      ]
      first [cooperative-construct?] of municipalities with [name = region-name] = True and [wait-for-permit] of municipalities with [name = region-name] = True [
        ;do nothing - we are waiting
        ifelse insurance-intention = True [
         set insurance? True
         set adaptation-cost insurance-cost
        ]
         [set insurance? False
        ;set adaptation-cost 0
          set adaptation-cost 0
        ]
        set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
      set adaptation-intention "none"
        set permit-delay-count 0
      ]
      first [cooperative-construct?] of municipalities with [name = region-name] = False
      [;output-print("property_owner cooperative but mun not")
      property_owner-adaptation-implementation-noncooperative])
    ]
    if dev-region = "boston" [
      let coop-test item boston-sw-segment-num boston-coop-construct-list
      let bos-permit-wait item boston-sw-segment-num wait-for-permit-boston
      ;now we have the same three options as above - the agent follows the sw adaptation, the agent waits for the permit process, or acts independently (the munciipality is not cooperative)
      (ifelse coop-test = True and bos-permit-wait = False [
         ifelse insurance-intention = True [
          set adaptation-cost adaptation-cost
          ;output-print("property_owner and boston region cooperative")
         set insurance? True]
         [set insurance? False
        set adaptation-cost adaptation-cost]
        let discount-payment item boston-sw-segment-num boston-vc-discount-rate-list
      set adaptation-cost planned-adaptation-cost * (discount-payment)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
        set adaptation-intention "none"
      set permit-delay-count 0]
      coop-test = True and bos-permit-wait = True[
           ifelse insurance-intention = True [
         set insurance? True
         set adaptation-cost insurance-cost
        ]
         [set insurance? False
        ;set adaptation-cost 0
          set adaptation-cost 0
        ]
        let discount-payment item boston-sw-segment-num boston-vc-discount-rate-list
      set adaptation-cost planned-adaptation-cost * (discount-payment)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
        set adaptation-intention "none"
          set permit-delay-count 0
        ]

      [;output-print("property_owner cooeprative and boston region not")
      property_owner-adaptation-implementation-noncooperative])
    ]
  ]

  ask private-assets with [cooperative-construct? = False] [
    ;output-print("private assets with no cooperation")
    ;do normal adaptation
    ;both for funding cap and no funding cap
    pa-adaptation-implementation-noncooperative
  ]

  ask private-assets with [cooperative-construct? = True] [

      let coop-test item boston-sw-segment-num boston-coop-construct-list
      let bos-permit-wait item boston-sw-segment-num wait-for-permit-boston
      ;now we have the same three options as above - the agent follows the sw adaptation, the agent waits for the permit process, or acts independently (the munciipality is not cooperative)
      (ifelse coop-test = True and bos-permit-wait = False [
      ;we are adapting together
         ;assume budget does not have to be readily available and the permitting is done through the RA
       let discount-payment item boston-sw-segment-num boston-vc-discount-rate-list
      set adaptation-cost planned-adaptation-cost * (discount-payment)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
      set adaptation-intention "none"
       set permit-delay-count 0]
      coop-test = True and bos-permit-wait = True[
        ;no adaptation yet because they are waiting for the agents to get permitting together
        set adaptation-cost 0
        set adaptation-intention "none"
         set permit-delay-count 0
        ]

      [;output-print("property_owner cooeprative and boston region not")
        ;municipalitiy is not adapting so need to go on their own
      pa-adaptation-implementation-noncooperative])

  ]

   ifelse mbta-adaptation-method = "all-at-once" [
    ask mbta-agents with [cooperative-construct? = False] [
      mbta-adaptation-implementation-noncooperative]
    ask mbta-agents with [cooperative-construct? = True] [
      mbta-adaptation-decision-all-at-once
  ]
  ]

  [;mbta-adaptation-method = "segments"
    ask mbta-agents [
      mbta-adaptation-decision-segments]
  ]

if mbta-adaptation-method = "all-at-once"[
ask mbta-agents with [cooperative-construct? = True] [
  ;[;funding-cap = true


    ifelse adaptation != adaptation-intention[
        ifelse permit-delay-count >= permitting-delay[
          ;need to calculate the total cost of things

      set total-mbta-paid-so-far sum(mbta-cooperative-adaptation-contribution-list)
      set available-budget available-budget - total-mbta-paid-so-far
      ifelse available-budget > planned-adaptation-cost * .1 [
      ;ifelse 4 > 2 [
      set adaptation adaptation-intention
      set adaptation-count adaptation-count + 1
              ;changed this 8/5
      set adaptation-cost planned-adaptation-cost + sum(mbta-cooperative-adaptation-contribution-list)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
      set permit-delay-count 0

  ]
    [

      set adaptation-cost sum(mbta-cooperative-adaptation-contribution-list)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set permit-delay-count permit-delay-count + 1
    ]
        ]
        [;permit-delay-count < permitting-delay
          set adaptation-cost sum(mbta-cooperative-adaptation-contribution-list)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set permit-delay-count permit-delay-count + 1
        ]
    ]
    [set adaptation-cost sum(mbta-cooperative-adaptation-contribution-list)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
    ]
    ]
  ]



    if mbta-adaptation-method = "segments" [
    ask mbta-agents [

      ;[;FUNDING-CAP is true

        ;code below adjusts existing mbta budget
      set test-pos 0
      set total-mbta-paid-so-far sum(mbta-cooperative-adaptation-contribution-list)

       set available-budget available-budget - total-mbta-paid-so-far

      ;code below from individual with funding cap
      ;sort the c-b list by largest to smallest
      let sorted sort mbta-benefit-cost-ratio-list
      ;output-print(sorted)
      ;create a list that maps the ranks of b-c ratios back to their initial position in sw segment list
      set ranked-list-nums map [ n -> position n sorted ] mbta-benefit-cost-ratio-list
      ;output-print(ranked-list-nums)
      ;create two empty lists to be used to process the data
      set empty-list []
      set used-list []
      ;reset variable that is used to ensure we work through each value in a list
      set test-pos 0
      foreach ranked-list-nums [
        ;assigns variable 'ranktest' for the ranks of b-c ratio in order of seawall segment
        [z] -> let ranktest z
        ;checks that value to see if it has been used so far
        ifelse member? z used-list [
          ;check how many times this value has been used so far
          let count-ranktest filter [ i -> i = ranktest ] used-list
          let val-count-ranktest length count-ranktest
          ;build new list that adjusts for when there are identical b-c rankings
          set empty-list lput (val-count-ranktest + ranktest ) empty-list
          ;adjust the origincal ranked-list list
          ;set ranked-list-nums replace-item test-pos ranked-list-nums (val-count-ranktest)
          ;build another list that maintains the original list over time
          set used-list lput (ranktest) used-list

        ]
        [;no duplicate rankings- can continue to use as nomal
          set empty-list lput (ranktest) empty-list
          set used-list lput (ranktest) used-list
        ]
        ;allows us to continue to keep track of how many loops we have done
          set test-pos test-pos + 1
      ]


      ;now we map the lists back to each other
      set time-step-costs 0
        set hold-adaptation? false
      ;this sets us up so that the 8th largest b-c starts, then 7th, then ....
      foreach reverse [0 1 2 3 4 5 6 7 8] [ ;this list has to be a list of the total number of rank positions
        [x] -> let rank-search x
        ;get the position value of the needed rank based on the list of final rankings in the positions of the sw segments
        let cb-item-order position rank-search empty-list
        ;using the sw-position value, get the final cost-benefit value
        let cb-item item cb-item-order mbta-benefit-cost-ratio-list
        ;now we can start with the tests to actually implement an adaptation, in order of importance
        ;get adaptation intention of each regioin
        let adapt-intention item cb-item-order mbta-adaptation-intention-list
        ;check existing adaptation
        let neighborhood-adapt item cb-item-order mbta-adaptation-list
        ;get corresponding cost for the planned adaptation
        let cost-test item cb-item-order mbta-planned-adaptation-cost-list
        let total-adapt-cost-region item cb-item-order mbta-total-adaptation-cost-list
        let neigh-permit-delay item cb-item-order mbta-permit-delay-list


        ifelse neighborhood-adapt != adapt-intention [
            ifelse hold-adaptation? = false [
          ;assign plan cost and down payment
          let plan-cost-again item cb-item-order mbta-planned-adaptation-cost-list
          let down-payment 0.10
          ;check plan cost
          ifelse available-budget > plan-cost-again * down-payment [
            ;check permitting
            ifelse neigh-permit-delay >= permitting-delay [
              ;adapt
            set mbta-adaptation-list replace-item cb-item-order mbta-adaptation-list adapt-intention
            set available-budget available-budget - plan-cost-again
            set adaptation-count adaptation-count + 1
            set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list plan-cost-again
            set mbta-total-adaptation-cost-list replace-item cb-item-order mbta-total-adaptation-cost-list plan-cost-again
            set time-step-costs time-step-costs + plan-cost-again
            set mbta-permit-delay-list replace-item cb-item-order mbta-permit-delay-list 0
            set hold-adaptation? false

            ]
            [;neigh-permit-delay < permitting-delay
              set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list 0
              set mbta-permit-delay-list replace-item cb-item-order mbta-permit-delay-list (neigh-permit-delay + 1)
              set hold-adaptation? false
            ]
          ]
          [            ;not enough budget to adapt here
            set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list 0
            set mbta-permit-delay-list replace-item cb-item-order mbta-permit-delay-list (neigh-permit-delay + 1)
            set hold-adaptation? true
             ]
        ]
            [; hold-adaptation? = true
              set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list 0
              set mbta-permit-delay-list replace-item cb-item-order mbta-permit-delay-list (neigh-permit-delay + 1)
              set hold-adaptation? true
            ]
          ]
        [
          ;the proposed adaptation is already in place - no change to adaptation and no new money spent
          set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list 0
            set hold-adaptation? false
      ]
    ]
      ;sum total costs for boston
      set total-adaptation-cost total-adaptation-cost + time-step-costs
      set mbta-vc-costs time-step-costs + sum(mbta-cooperative-adaptation-contribution-list)
      set mbta-vc-total-costs mbta-vc-total-costs + mbta-vc-costs
      ;]
    ]
  ]

  if mbta-adaptation-method = "segments" [
    ask mbta-agents [
      set adaptation-cost mbta-vc-costs]
  ]
end

to municipality-adaptation-noncooperative
  ;municipalities go through this process when they are uncooperative
  ask municipalities with [name != "boston"][
    ;check adaptation is desired
    ifelse adaptation != adaptation-intention [
        ;check permits have been waited for
        ifelse permit-delay-count >= permitting-delay [
      let down-payment .1
          ;check funding
      ifelse available-budget >= planned-adaptation-cost * down-payment[
      set adaptation adaptation-intention
      set available-budget available-budget - planned-adaptation-cost
      set adaptation-count adaptation-count + 1
      set adaptation-cost planned-adaptation-cost
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      ifelse adaptation = "seawall" [
        set crs-discount 0.3]
      [set crs-discount 0]
       set permit-delay-count 0
  ]
  [;not enough funding
      set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set permit-delay-count permit-delay-count + 1
    ]

        ]
        [;permit-delay-count < permitting-delay
          set adaptation-cost 0
          set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set permit-delay-count permit-delay-count + 1
        ]
        ]
    [;no desire to adapt
        set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set permit-delay-count 0
    ]
  ]


end


to line-by-line-adaptation-implementation-vc
  ;sets mbta time step contributions and proposed contributions to 0 so we start fresh in each time step
  set mbta-cooperative-adaptation-contribution-proposed 0
  set mbta-cooperative-adaptation-contribution 0
  ;sets a list for all 1 regions of mbta contributions and proposed contributions - these lines make sure this is fresh each time step
  set mbta-cooperative-adaptation-contribution-list [0 0 0 0 0 0 0 0 0 0 0]
  set mbta-cooperative-adaptation-contribution-list-proposed [0 0 0 0 0 0 0 0 0 0 0]
  ;start process by assuming cooperation does not occur- this is then checked for every agent
  set boston-coop-construct-list [false false false false false false false false false]
  ;the following lines of code explore whether or not cooperative construction is a possibility- need to be needing to adapt
  ask property_owners [
    ifelse adaptation-intention != adaptation [
      if adaptation-intention = "aquafence" [
        ifelse elevation + 3 <= 15 [
          set cooperative-construct? True
        ]
        [set cooperative-construct? False]
      ]
      if adaptation-intention = "local-seawall" [
        set cooperative-construct? True]
    ]
    [set cooperative-construct? False]
  ]
  ask private-assets [
    ifelse adaptation-intention != adaptation [
      set cooperative-construct? True]
    [set cooperative-construct? False]
  ]

  ask mbta-agents [
    if mbta-adaptation-method = "all-at-once" [
    ifelse adaptation-intention != adaptation [
      set cooperative-construct? True]
    [set cooperative-construct? False]
    ]

    if mbta-adaptation-method = "segments" [
      set test-pos 0
      foreach mbta-adaptation-intention-list[
        [x] -> let adapt-intent-mbta-segment x
        let existing-mbta-adaptation item test-pos mbta-adaptation-list
        ifelse adapt-intent-mbta-segment != existing-mbta-adaptation [
          set mbta-coop-construct-list replace-item test-pos mbta-coop-construct-list True]
        [set mbta-coop-construct-list replace-item test-pos mbta-coop-construct-list False]
        set test-pos test-pos + 1
        ]
    ]
  ]

  ;Now, all agents either want to adapt (they have interest in cooperating with others, or not at all and this is marked with a true/false

  ;Start the process of assessing cooperative efforts seawall by seawall- here we start with NS and SS
  ask municipalities with [name != "boston"] [
    ;without funding cap, all work should be cooperative
    if funding-cap = False [
      ;check that the municipality is adapting
      ifelse adaptation != adaptation-intention [
        ;check that there is no permit delay
        ifelse permit-delay-count > permitting-delay [
          ;create a variable that reflects the name of the municipality
          let reg-name name
          ;municipalities start adapting since there is no funding limit
          set adaptation adaptation-intention
          set adaptation-count adaptation-count + 1
          ;calculate how much money property_owners contribute -what the cooperative ones would pay for their own adaptations
          let cost-property_owners-with-insurance sum ([planned-adaptation-cost - insurance-cost] of property_owners with [cooperative-construct? = True and dev-region = reg-name and insurance-intention = True])
          let cost-property_owners-without-insurance sum ([planned-adaptation-cost] of property_owners with [cooperative-construct? = True and dev-region = reg-name and insurance-intention = False])
          let cost-property_owners cost-property_owners-with-insurance + cost-property_owners-without-insurance
          ;calculate how much money the mbta constributes
          let cost-mbta-without-discount sum([planned-adaptation-cost] of mbta-agents with [cooperative-construct? = True]) * (item pos mbta-cost-proportion-list)
          ;set variable pos based on whether we are calculating for north shore or south-shore
          ;Note: there is never a calculated reduction....
          ifelse mbta-adaptation-method = "all-at-once" [
            if name = "north-shore" [
              set pos 0]
            if name = "south-shore" [
              set pos 1]
            ;now we need to figure out if there is a discount of any kind
          let total-contributions (planned-adaptation-cost + cost-mbta-without-discount + cost-property_owners)
            ;output of segment-discount is the ratio of planned costs that are still paid for
          ifelse total-contributions > planned-adaptation-cost [
                let segment-discount-pt-1 (total-contributions - planned-adaptation-cost) / planned-adaptation-cost
                set segment-discount-mun (1 / (segment-discount-pt-1 + 1))
              ]
              [;total-contributions < sw-segment-cost ->set to 1 because each agent is assumed to pay full amount
                set segment-discount-mun 1
              ]
            ;update proposed mbta funding with the segment discount
            set mbta-cooperative-adaptation-contribution-proposed mbta-cooperative-adaptation-contribution-proposed + (cost-mbta-without-discount * segment-discount-mun)
            ;update the proposed mbta funding list based on if the municipality is north-shore or south shore
            ifelse reg-name = "north-shore" [
              set mbta-cooperative-adaptation-contribution-list-proposed replace-item 0 mbta-cooperative-adaptation-contribution-list-proposed (cost-mbta-without-discount * segment-discount-mun)]
            [set mbta-cooperative-adaptation-contribution-list-proposed replace-item 1 mbta-cooperative-adaptation-contribution-list-proposed (cost-mbta-without-discount * segment-discount-mun)]
          ;adaptation-cost now is lower- it is what the other agents would pay -> assume they go ahead and contribute (or are able to pay in later and take loans from municipality now)
         ;update adaptation cost for the municipality
            set adaptation-cost planned-adaptation-cost * segment-discount-mun]

          [;here mbta is determined in segments, so it is a slightly different procedure based on if the T is cooperative for a specific segment
            if name = "north-shore" [
              set pos 0]
            if name = "south-shore" [
              set pos 1]
            ;now we need to figure out if there is a discount of any kind
            ;1st check- is the T cooperative?
          ifelse item pos mbta-coop-construct-list = True [
              ;calculate proposed mbta contributions
          let cost-mbta-wout-discount item pos mbta-planned-adaptation-cost-list
          let total-contributions (planned-adaptation-cost + cost-mbta-wout-discount + cost-property_owners)
            ;output of segment-discount is the ratio of planned costs that are still paid for
             ;figure out what this discount is
          ifelse total-contributions > planned-adaptation-cost [
                let segment-discount-pt-1 (total-contributions - planned-adaptation-cost) / planned-adaptation-cost
                set segment-discount-mun (1 / (segment-discount-pt-1 + 1))
              ]
              [;total-contributions < sw-segment-cost
                set segment-discount-mun 1
              ]
              ;mbta costs are updated to reflect the segment discount
            set mbta-cooperative-adaptation-contribution-proposed mbta-cooperative-adaptation-contribution-proposed + (cost-mbta-wout-discount * segment-discount-mun)
            ifelse reg-name = "north-shore" [
              set mbta-cooperative-adaptation-contribution-list-proposed replace-item 0 mbta-cooperative-adaptation-contribution-list-proposed (cost-mbta-wout-discount * segment-discount-mun)]
            [set mbta-cooperative-adaptation-contribution-list-proposed replace-item 1 mbta-cooperative-adaptation-contribution-list-proposed (cost-mbta-wout-discount * segment-discount-mun)]
          ;adaptation-cost now is lower- it is what the other agents would pay -> assume they go ahead and contribute (or are able to pay in later and take loans from municipality now)

              set adaptation-cost planned-adaptation-cost * segment-discount-mun]

          [;item mbta-coop-construct-list = False -> the T is not cooperating for that segment, property_owners may still be cooperative
            let cost-mbta 0
            set mbta-cooperative-adaptation-contribution-proposed mbta-cooperative-adaptation-contribution-proposed + cost-mbta
            let total-contributions (planned-adaptation-cost + cost-property_owners)
            ;output of segment-discount is the ratio of planned costs that are still paid for
             ;figure out what this discount is
          ifelse total-contributions > planned-adaptation-cost [
                let segment-discount-pt-1 (total-contributions - planned-adaptation-cost) / planned-adaptation-cost
                set segment-discount-mun (1 / (segment-discount-pt-1 + 1))
              ]
              [;total-contributions < sw-segment-cost
                set segment-discount-mun 1
              ]
              ;mbta costs are not updated to reflect 0 contributions- this only changes list
            ifelse reg-name = "north-shore" [
              set mbta-cooperative-adaptation-contribution-list-proposed replace-item 0 mbta-cooperative-adaptation-contribution-list-proposed 0]
            [set mbta-cooperative-adaptation-contribution-list-proposed replace-item 1 mbta-cooperative-adaptation-contribution-list-proposed 0]
          ;adaptation-cost now is lower- it is what the other agents would pay -> assume they go ahead and contribute (or are able to pay in later and take loans from municipality now
              set adaptation-cost planned-adaptation-cost * segment-discount-mun
            ]
          ]

         ;Because funding cap is false, we assume adaptation goes ahead
          ;set vc-total-adaptation-costs for the municipality
          set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set permit-delay-count 0
          set cooperative-construct? True
          set wait-for-permit False
          ;track which mbta funds actually went to constructing barriers
          let cost-this-round item pos mbta-cooperative-adaptation-contribution-list-proposed
          set mbta-cooperative-adaptation-contribution mbta-cooperative-adaptation-contribution + cost-this-round
          set mbta-cooperative-adaptation-contribution-list replace-item pos mbta-cooperative-adaptation-contribution-list cost-this-round
      ]
        [ ;waiting for permitting-delay only - here we assume that there is still a possibility that other agents will wait for municipalities to adapt
          set permit-delay-count permit-delay-count + 1
          set adaptation-cost 0
          set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set cooperative-construct? True
          set wait-for-permit True
          set mbta-cooperative-adaptation-contribution-list replace-item pos mbta-cooperative-adaptation-contribution-list 0
        ]
      ]
     [;adaptation = adaptation-intention -> there is no reason to adapt
        set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
        ;Assume: agents will not wait for financing
      set cooperative-construct? False
      set wait-for-permit False
      set mbta-cooperative-adaptation-contribution-list replace-item pos mbta-cooperative-adaptation-contribution-list 0
      ]
    ;update CRS according to the adaptation that is put into place
    ifelse adaptation = "seawall" [
        ;if the adaptation occurs, then we will update the discount
        set crs-discount 0.3]
      [set crs-discount 0]
    ]

;here, funding is limited...which complicates the whole process- this is only for South shore and north shore municipalities
    ;pick up here 8/16 after 12

    if funding-cap = True [
       ;start only if there is a need to adapt
       ifelse adaptation != adaptation-intention [
        ;check permitting delay
        ifelse permit-delay-count >= permitting-delay [
          ;step 1: figure out how much property_owners are willing to contribute
          let reg-name name
          let cost-property_owners-with-insurance sum ([planned-adaptation-cost - insurance-cost] of property_owners with [cooperative-construct? = True and dev-region = reg-name and insurance-intention = True])
          let cost-property_owners-without-insurance sum ([planned-adaptation-cost] of property_owners with [cooperative-construct? = True and dev-region = reg-name and insurance-intention = False])
          let cost-property_owners cost-property_owners-with-insurance + cost-property_owners-without-insurance
              ;set a global variable for this so we can use it outside of the statements
          set cost-deduction-property_owners cost-property_owners
          let available-budget-property_owners sum ([available-budget] of property_owners with [cooperative-construct? = True and dev-region = reg-name])
            if name = "north-shore" [
              set pos 0]
            if name = "south-shore" [
              set pos 1]

    ifelse mbta-adaptation-method = "all-at-once" [
    ;now we can break-out baed on mbta- method
          ifelse any? mbta-agents with [cooperative-construct? = True] [
          let cost-mbta-without-discount sum([planned-adaptation-cost] of mbta-agents with [cooperative-construct? = True]) * (item pos mbta-cost-proportion-list)
            ;now we need to figure out if there is a discount of any kind
          let total-contributions (planned-adaptation-cost + cost-mbta-without-discount + cost-property_owners)
            ;output of segment-discount is the ratio of planned costs that are still paid for
          ifelse total-contributions > planned-adaptation-cost [
                let segment-discount-pt-1 (total-contributions - planned-adaptation-cost) / planned-adaptation-cost
                set segment-discount-mun (1 / (segment-discount-pt-1 + 1))
              ]
              [;total-contributions < sw-segment-cost ->set to 1 because each agent is assumed to pay full amount
                set segment-discount-mun 1
              ]
            set available-budget-mbta (sum ([available-budget] of mbta-agents with [cooperative-construct? = True])) * (item pos mbta-cost-proportion-list)
            set mbta-cooperative-adaptation-contribution-list-proposed replace-item pos mbta-cooperative-adaptation-contribution-list-proposed (cost-mbta-without-discount * segment-discount-mun)
            ]
            [;there are no cooperative mbta agents
              let total-contributions (planned-adaptation-cost + cost-deduction-property_owners)
            ;output of segment-discount is the ratio of planned costs that are still paid for
             ifelse total-contributions > planned-adaptation-cost [
                let segment-discount-pt-1 (total-contributions - planned-adaptation-cost) / planned-adaptation-cost
                set segment-discount-mun (1 / (segment-discount-pt-1 + 1))
              ]
              [;total-contributions < sw-segment-cost ->set to 1 because each agent is assumed to pay full amount
                set segment-discount-mun 1
              ]
            set available-budget-mbta 0
            set mbta-cooperative-adaptation-contribution-list-proposed replace-item pos mbta-cooperative-adaptation-contribution-list-proposed 0
            ]
          ]
       [;let's actually put mbta-method = segments here!
              ifelse item pos mbta-coop-construct-list = True [
              ;calculate proposed mbta contributions
          let cost-mbta-wout-discount item pos mbta-planned-adaptation-cost-list
          let total-contributions (planned-adaptation-cost + cost-mbta-wout-discount + cost-deduction-property_owners)
            ;output of segment-discount is the ratio of planned costs that are still paid for
             ;figure out what this discount is
          ifelse total-contributions > planned-adaptation-cost [
                let segment-discount-pt-1 (total-contributions - planned-adaptation-cost) / planned-adaptation-cost
                set segment-discount-mun (1 / (segment-discount-pt-1 + 1))
              ]
              [;total-contributions < sw-segment-cost
                set segment-discount-mun 1
              ]
              ;mbta costs are updated to reflect the segment discount
            set mbta-cooperative-adaptation-contribution-proposed mbta-cooperative-adaptation-contribution-proposed + (cost-mbta-wout-discount * segment-discount-mun)
            ifelse reg-name = "north-shore" [
              set mbta-cooperative-adaptation-contribution-list-proposed replace-item 0 mbta-cooperative-adaptation-contribution-list-proposed (cost-mbta-wout-discount * segment-discount-mun)]
            [set mbta-cooperative-adaptation-contribution-list-proposed replace-item 1 mbta-cooperative-adaptation-contribution-list-proposed (cost-mbta-wout-discount * segment-discount-mun)]
          ;adaptation-cost now is lower- it is what the other agents would pay -> assume they go ahead and contribute (or are able to pay in later and take loans from municipality now)
           set available-budget-mbta (sum([available-budget] of mbta-agents)) * (item pos mbta-cost-proportion-list)
           ]

          [;item mbta-coop-construct-list = False -> the T is not cooperating for that segment, property_owners may still be cooperative
            let cost-mbta 0
            set mbta-cooperative-adaptation-contribution-proposed mbta-cooperative-adaptation-contribution-proposed + cost-mbta
            let total-contributions (planned-adaptation-cost + cost-property_owners)
            ;output of segment-discount is the ratio of planned costs that are still paid for
             ;figure out what this discount is
          ifelse total-contributions > planned-adaptation-cost [
                let segment-discount-pt-1 (total-contributions - planned-adaptation-cost) / planned-adaptation-cost
                set segment-discount-mun (1 / (segment-discount-pt-1 + 1))
              ]
              [;total-contributions < sw-segment-cost
                set segment-discount-mun 1
              ]
              ;mbta costs are not updated to reflect 0 contributions- this only changes list
            ifelse reg-name = "north-shore" [
              set mbta-cooperative-adaptation-contribution-list-proposed replace-item 0 mbta-cooperative-adaptation-contribution-list-proposed 0]
            [set mbta-cooperative-adaptation-contribution-list-proposed replace-item 1 mbta-cooperative-adaptation-contribution-list-proposed 0]
          ;adaptation-cost now is lower- it is what the other agents would pay -> assume they go ahead and contribute (or are able to pay in later and take loans from municipality now
                  ;if mbta isn't willing to cooperate, they will contribute 0
                  set available-budget-mbta 0
            ]
          ]
            ;budget checks
            let down-payment .1
            ;add municipality, property_owners, and mbta cost together
            ;budget checks - all agents need to create sufficient funding
            ifelse (available-budget + available-budget-mbta + available-budget-property_owners)  >= (planned-adaptation-cost * down-payment) [
              ;get default proposed mbta costs
                let mbta-proposed-costs item pos mbta-cooperative-adaptation-contribution-list-proposed
                set mbta-cooperative-adaptation-contribution mbta-cooperative-adaptation-contribution + mbta-proposed-costs
                set mbta-cooperative-adaptation-contribution-list replace-item pos mbta-cooperative-adaptation-contribution-list mbta-proposed-costs
                set adaptation adaptation-intention
                set available-budget available-budget - (planned-adaptation-cost * segment-discount-mun)
                set adaptation-count adaptation-count + 1
                ;municipality gets to pay reduced costs
                set adaptation-cost (planned-adaptation-cost * segment-discount-mun)
            ;vc-total-adaptation-costs tracks the total payment (does not factor in other things)
                set vc-total-adaptation-costs vc-total-adaptation-costs + planned-adaptation-cost
                set total-adaptation-cost total-adaptation-cost + adaptation-cost
                set wait-for-permit False
                set cooperative-construct? True
                ifelse adaptation = "seawall" [
                  set crs-discount 0.3]
                [set crs-discount 0]
                set permit-delay-count 0
            ]
            [;budget is not successful
                set adaptation-cost 0
                set total-adaptation-cost total-adaptation-cost + adaptation-cost
                set permit-delay-count permit-delay-count + 1
                set cooperative-construct? False
                set wait-for-permit False
                set mbta-cooperative-adaptation-contribution-list replace-item pos mbta-cooperative-adaptation-contribution-list 0
            ]
            ]
        [;permit delay has not been met, other agents will wait for permitting delay
          set adaptation-cost 0
          set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set permit-delay-count permit-delay-count + 1
          set cooperative-construct? True
          set wait-for-permit True
          set mbta-cooperative-adaptation-contribution-list replace-item pos mbta-cooperative-adaptation-contribution-list 0
        ]
      ]
      [;adaptation = adaptation-intention -> no deed to adapt
            set adaptation-cost 0
            set total-adaptation-cost total-adaptation-cost + adaptation-cost
            set permit-delay-count 0
            set cooperative-construct? False
            set wait-for-permit False
            set mbta-cooperative-adaptation-contribution-list replace-item pos mbta-cooperative-adaptation-contribution-list 0
      ]
    ]
      ]




  ;now we do it for boston
  boston-adaptation-implementation-vc



   ;Now, all other agents tack onto the municipalities- if they are cooperative and the agents are cooperative, they adapt

  ask property_owners with [cooperative-construct? = False] [
;this happens if the agent is not cooperative
    property_owner-adaptation-implementation-noncooperative
  ]

  ask property_owners with [cooperative-construct? = True] [
    if dev-region != "boston" [
      ;3 options here: the municipality wants ot cooperate and can cooperate, the municipality wants to cooperate, but can't, or the mun doesn't want to cooperate
      let region-name dev-region
      (ifelse first [cooperative-construct?] of municipalities with [name = region-name] = True and [wait-for-permit] of municipalities with [name = region-name] = False [
        ifelse insurance-intention = True [
         set insurance? True
          set adaptation-cost planned-adaptation-cost * ([segment-discount-mun] of municipalities with [name = dev-region])
        ]
         [set insurance? False
        ;set adaptation-cost 0
          set adaptation-cost planned-adaptation-cost * ([segment-discount-mun] of municipalities with [name = dev-region])
        ]
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
      set adaptation-intention "none"
        set permit-delay-count 0
      ]
      first [cooperative-construct?] of municipalities with [name = region-name] = True and [wait-for-permit] of municipalities with [name = region-name] = True [
        ;do nothing - we are waiting
        ifelse insurance-intention = True [
         set insurance? True
         set adaptation-cost insurance-cost
        ]
         [set insurance? False
        ;set adaptation-cost 0
          set adaptation-cost 0
        ]
        set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
      set adaptation-intention "none"
        set permit-delay-count 0
      ]
      first [cooperative-construct?] of municipalities with [name = region-name] = False
      [;output-print("property_owner cooperative but mun not")
      property_owner-adaptation-implementation-noncooperative])
    ]
    if dev-region = "boston" [
      let coop-test item boston-sw-segment-num boston-coop-construct-list
      let bos-permit-wait item boston-sw-segment-num wait-for-permit-boston
      ;now we have the same three options as above - the agent follows the sw adaptation, the agent waits for the permit process, or acts independently (the munciipality is not cooperative)
      (ifelse coop-test = True and bos-permit-wait = False [
         ifelse insurance-intention = True [
          set adaptation-cost adaptation-cost
          ;output-print("property_owner and boston region cooperative")
         set insurance? True]
         [set insurance? False
        set adaptation-cost adaptation-cost]
        let discount-payment item boston-sw-segment-num boston-vc-discount-rate-list
      set adaptation-cost planned-adaptation-cost * (discount-payment)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
        set adaptation-intention "none"
      set permit-delay-count 0]
      coop-test = True and bos-permit-wait = True[
           ifelse insurance-intention = True [
         set insurance? True
         set adaptation-cost insurance-cost
        ]
         [set insurance? False
        ;set adaptation-cost 0
          set adaptation-cost 0
        ]
        let discount-payment item boston-sw-segment-num boston-vc-discount-rate-list
      set adaptation-cost planned-adaptation-cost * (discount-payment)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
        set adaptation-intention "none"
          set permit-delay-count 0
        ]

      [;output-print("property_owner cooeprative and boston region not")
      property_owner-adaptation-implementation-noncooperative])
    ]
  ]

  ask private-assets with [cooperative-construct? = False] [
    ;output-print("private assets with no cooperation")
    ;do normal adaptation
    ;both for funding cap and no funding cap
    pa-adaptation-implementation-noncooperative
  ]

  ask private-assets with [cooperative-construct? = True] [

      let coop-test item boston-sw-segment-num boston-coop-construct-list
      let bos-permit-wait item boston-sw-segment-num wait-for-permit-boston
      ;now we have the same three options as above - the agent follows the sw adaptation, the agent waits for the permit process, or acts independently (the munciipality is not cooperative)
      (ifelse coop-test = True and bos-permit-wait = False [
      ;we are adapting together
         ;assume budget does not have to be readily available and the permitting is done through the RA
       let discount-payment item boston-sw-segment-num boston-vc-discount-rate-list
      set adaptation-cost planned-adaptation-cost * (discount-payment)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
      set adaptation-intention "none"
       set permit-delay-count 0]
      coop-test = True and bos-permit-wait = True[
        ;no adaptation yet because they are waiting for the agents to get permitting together
        set adaptation-cost 0
        set adaptation-intention "none"
         set permit-delay-count 0
        ]

      [;output-print("property_owner cooeprative and boston region not")
        ;municipalitiy is not adapting so need to go on their own
      property_owner-adaptation-implementation-noncooperative])

  ]

   ifelse mbta-adaptation-method = "all-at-once" [
    ask mbta-agents with [cooperative-construct? = False] [
      mbta-adaptation-implementation-noncooperative]
    ask mbta-agents with [cooperative-construct? = True] [
      mbta-adaptation-decision-all-at-once
  ]
  ]

  [;mbta-adaptation-method = "segments"
    ask mbta-agents [
      mbta-adaptation-decision-segments]
  ]

if mbta-adaptation-method = "all-at-once"[
ask mbta-agents with [cooperative-construct? = True] [

  ifelse funding-cap = False[
    ifelse adaptation != adaptation-intention[
        ifelse permit-delay-count >= permitting-delay[
      ;ifelse available-budget > planned-adaptation-cost * .1 [
      ifelse 4 > 2 [
      set adaptation adaptation-intention
      set adaptation-count adaptation-count + 1
      set adaptation-cost planned-adaptation-cost + sum(mbta-cooperative-adaptation-contribution-list)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost - sum(mbta-cooperative-adaptation-contribution-list)
      set permit-delay-count 0
  ]
    [
      ;o&m work
      set adaptation-cost sum(mbta-cooperative-adaptation-contribution-list)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set permit-delay-count permit-delay-count + 1
    ]
        ]
        [;permit-delay-count < permitting-delay
          set adaptation-cost sum(mbta-cooperative-adaptation-contribution-list)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set permit-delay-count permit-delay-count + 1
        ]
    ]
    [set adaptation-cost sum(mbta-cooperative-adaptation-contribution-list)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
  ]]
  [;funding-cap = true


    ifelse adaptation != adaptation-intention[
        ifelse permit-delay-count >= permitting-delay[
          ;need to calculate the total cost of things

      set total-mbta-paid-so-far sum(mbta-cooperative-adaptation-contribution-list)
      set available-budget available-budget - total-mbta-paid-so-far
      ifelse available-budget > planned-adaptation-cost * .1 [
      ;ifelse 4 > 2 [
      set adaptation adaptation-intention
      set adaptation-count adaptation-count + 1
              ;changed this 8/5
      set adaptation-cost planned-adaptation-cost + sum(mbta-cooperative-adaptation-contribution-list)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
      set permit-delay-count 0

  ]
    [

      set adaptation-cost sum(mbta-cooperative-adaptation-contribution-list)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set permit-delay-count permit-delay-count + 1
    ]
        ]
        [;permit-delay-count < permitting-delay
          set adaptation-cost sum(mbta-cooperative-adaptation-contribution-list)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set permit-delay-count permit-delay-count + 1
        ]
    ]
    [set adaptation-cost sum(mbta-cooperative-adaptation-contribution-list)
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
    ]
  ]
    ]
  ]



    if mbta-adaptation-method = "segments" [
    ask mbta-agents [
      ifelse funding-cap = False [
        set test-pos 0
        set time-step-costs 0
    ;code below calulates for each neighbodhood in boston
        foreach mbta-adaptation-intention-list [
       ;sets adapt-intention as the neighborhood adaptation intention
      [x] -> let adapt-intention x
       ;assigns variable to the actual neighborhood adaptation
      let neighborhood-adapt item test-pos mbta-adaptation-list
       ;assigns variable representing seawall cost
      let plan-cost item test-pos mbta-planned-adaptation-cost-list
        ;assigns variable representing total neighborhood cost
      let total-adapt-cost-region item test-pos mbta-total-adaptation-cost-list
        ;assigns variable tracking the permit delay on each segment of seawall
      let neigh-permit-delay item test-pos mbta-permit-delay-list
        ;check that there is a desire to adaptat that does not eaqual the intention (ie an adaptation is desired)
      ifelse neighborhood-adapt != adapt-intention[
          ;check that the permit delay has been fulfilled
          ifelse neigh-permit-delay >= permitting-delay [
            ;lost this variable with the new brackets- reassign
      let plan-cost-again item test-pos mbta-planned-adaptation-cost-list
           ;assumption about down payment required
      set mbta-adaptation-list replace-item test-pos mbta-adaptation-list x
      set available-budget available-budget - plan-cost
      set adaptation-count adaptation-count + 1
      set mbta-adaptation-cost-list replace-item test-pos mbta-adaptation-cost-list plan-cost
      set mbta-total-adaptation-cost-list replace-item test-pos mbta-total-adaptation-cost-list plan-cost
      set time-step-costs time-step-costs + plan-cost
      set mbta-permit-delay-list replace-item test-pos mbta-permit-delay-list 0
        ]
          [;neigh-permit-delay != permitting-delay
            set mbta-adaptation-cost-list replace-item test-pos mbta-adaptation-cost-list 0
            set mbta-permit-delay-list replace-item test-pos mbta-permit-delay-list (neigh-permit-delay + 1)
          ]
        ]
      [;neighborhood-adapt == adapt-intention, no adaptation desired
        set mbta-adaptation-cost-list replace-item test-pos mbta-adaptation-cost-list 0
      ]
        ;triggers repetition for the rest of boston
     set test-pos test-pos + 1
    ]
      ;tracks total municipality adaptation costs
      set total-adaptation-cost total-adaptation-cost + time-step-costs
      set mbta-vc-costs sum(mbta-adaptation-cost-list) + sum(mbta-cooperative-adaptation-contribution-list)
      set mbta-vc-total-costs mbta-vc-total-costs + mbta-vc-costs
      ]


      [;FUNDING-CAP is true

        ;code below adjusts existing mbta budget
      set test-pos 0
      set total-mbta-paid-so-far sum(mbta-cooperative-adaptation-contribution-list)

       set available-budget available-budget - total-mbta-paid-so-far

      ;code below from individual with funding cap
      ;sort the c-b list by largest to smallest
      let sorted sort mbta-benefit-cost-ratio-list
      ;output-print(sorted)
      ;create a list that maps the ranks of b-c ratios back to their initial position in sw segment list
      set ranked-list-nums map [ n -> position n sorted ] mbta-benefit-cost-ratio-list
      ;output-print(ranked-list-nums)
      ;create two empty lists to be used to process the data
      set empty-list []
      set used-list []
      ;reset variable that is used to ensure we work through each value in a list
      set test-pos 0
      foreach ranked-list-nums [
        ;assigns variable 'ranktest' for the ranks of b-c ratio in order of seawall segment
        [z] -> let ranktest z
        ;checks that value to see if it has been used so far
        ifelse member? z used-list [
          ;check how many times this value has been used so far
          let count-ranktest filter [ i -> i = ranktest ] used-list
          let val-count-ranktest length count-ranktest
          ;build new list that adjusts for when there are identical b-c rankings
          set empty-list lput (val-count-ranktest + ranktest ) empty-list
          ;adjust the origincal ranked-list list
          ;set ranked-list-nums replace-item test-pos ranked-list-nums (val-count-ranktest)
          ;build another list that maintains the original list over time
          set used-list lput (ranktest) used-list

        ]
        [;no duplicate rankings- can continue to use as nomal
          set empty-list lput (ranktest) empty-list
          set used-list lput (ranktest) used-list
        ]
        ;allows us to continue to keep track of how many loops we have done
          set test-pos test-pos + 1
      ]


      ;now we map the lists back to each other
      set time-step-costs 0
        set hold-adaptation? false
      ;this sets us up so that the 8th largest b-c starts, then 7th, then ....
      foreach reverse [0 1 2 3 4 5 6 7 8] [ ;this list has to be a list of the total number of rank positions
        [x] -> let rank-search x
        ;get the position value of the needed rank based on the list of final rankings in the positions of the sw segments
        let cb-item-order position rank-search empty-list
        ;using the sw-position value, get the final cost-benefit value
        let cb-item item cb-item-order mbta-benefit-cost-ratio-list
        ;now we can start with the tests to actually implement an adaptation, in order of importance
        ;get adaptation intention of each regioin
        let adapt-intention item cb-item-order mbta-adaptation-intention-list
        ;check existing adaptation
        let neighborhood-adapt item cb-item-order mbta-adaptation-list
        ;get corresponding cost for the planned adaptation
        let cost-test item cb-item-order mbta-planned-adaptation-cost-list
        let total-adapt-cost-region item cb-item-order mbta-total-adaptation-cost-list
        let neigh-permit-delay item cb-item-order mbta-permit-delay-list


        ifelse neighborhood-adapt != adapt-intention [
            ifelse hold-adaptation? = false [
          ;assign plan cost and down payment
          let plan-cost-again item cb-item-order mbta-planned-adaptation-cost-list
          let down-payment 0.10
          ;check plan cost
          ifelse available-budget > plan-cost-again * down-payment [
            ;check permitting
            ifelse neigh-permit-delay >= permitting-delay [
              ;adapt
            set mbta-adaptation-list replace-item cb-item-order mbta-adaptation-list adapt-intention
            set available-budget available-budget - plan-cost-again
            set adaptation-count adaptation-count + 1
            set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list plan-cost-again
            set mbta-total-adaptation-cost-list replace-item cb-item-order mbta-total-adaptation-cost-list plan-cost-again
            set time-step-costs time-step-costs + plan-cost-again
            set mbta-permit-delay-list replace-item cb-item-order mbta-permit-delay-list 0
            set hold-adaptation? false

            ]
            [;neigh-permit-delay < permitting-delay
              set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list 0
              set mbta-permit-delay-list replace-item cb-item-order mbta-permit-delay-list (neigh-permit-delay + 1)
              set hold-adaptation? false
            ]
          ]
          [            ;not enough budget to adapt here
            set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list 0
            set mbta-permit-delay-list replace-item cb-item-order mbta-permit-delay-list (neigh-permit-delay + 1)
            set hold-adaptation? true
             ]
        ]
            [; hold-adaptation? = true
              set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list 0
              set mbta-permit-delay-list replace-item cb-item-order mbta-permit-delay-list (neigh-permit-delay + 1)
              set hold-adaptation? true
            ]
          ]
        [
          ;the proposed adaptation is already in place - no change to adaptation and no new money spent
          set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list 0
            set hold-adaptation? false
      ]
    ]
      ;sum total costs for boston
      set total-adaptation-cost total-adaptation-cost + time-step-costs
      set mbta-vc-costs time-step-costs + sum(mbta-cooperative-adaptation-contribution-list)
      set mbta-vc-total-costs mbta-vc-total-costs + mbta-vc-costs
      ]
    ]
  ]

  if mbta-adaptation-method = "segments" [
    ask mbta-agents [
      set adaptation-cost mbta-vc-costs]
  ]
end

to boston-adaptation-implementation-vc
  ;now we do a similar process for boston
  set boston-vc-discount-rate-list [1 1 1 1 1 1 1 1 1]
  set wait-for-permit-boston [false false false false false false false false false]
  ask municipalities with [name = "boston"] [
    ;start with no funding cap
    ifelse funding-cap = false [
      ;7/22 ADD MBTA SEGMENTS HERE - THIS WON'T WORK CODE OUTDATED AS OF 11/29/24
    set test-pos 0
    set time-step-costs 0
    ;checks each boston seawall segment in series
    foreach boston-adaptation-intention-list[
      [x] -> let adapt-intention x
        let cb-item item test-pos boston-seawall-cost-benefit-list
        ;now we can start with the tests to actually implement an adaptation, in order of importance
        ;check existing adaptation
        let neighborhood-adapt item test-pos boston-adaptation-list
        ;get corresponding cost for the planned adaptation
        let cost-test item test-pos boston-planned-adaptation-cost-list
        let total-adapt-cost-region item test-pos boston-total-adaptation-cost-list
        let neigh-permit-delay item test-pos boston-permit-delay-list

        ifelse neighborhood-adapt != adapt-intention [
            ifelse hold-adaptation? = false [
              ifelse mbta-adaptation-method = "all-at-once" [
           let mbta-percent item test-pos mbta-damage-list-boston
           let mbta-cost-percent item (test-pos + 2) mbta-cost-proportion-list
                ;replaced damage percent with cost percent below so the max amount that the mbta will provide is what they would have contributed to that seawall to begin with
           set mbta-costs-current sum([planned-adaptation-cost] of mbta-agents with [cooperative-construct? = True]) * mbta-cost-percent
                ;8/13 code check - SOMETHING IS HAPPENING HERE SO THAT MONEY IS LEAVING THE T BUT NOT BEING ACCOUNTED FOR?
               ; output-print("mbta-costs that would be max pay")
               ; output-print([mbta-costs-current] of mbta-agents)
           set mbta-cooperative-adaptation-contribution-proposed mbta-cooperative-adaptation-contribution-proposed + mbta-costs-current
           set mbta-cooperative-adaptation-contribution-list-proposed replace-item (test-pos + 2) mbta-cooperative-adaptation-contribution-list-proposed mbta-costs-current
           set available-budget-mbta sum([available-budget] of mbta-agents with [cooperative-construct? = True])]
              [;mbta-adaptation-method = "segments"
                let mbta-percent item test-pos mbta-damage-list-boston
                ifelse item (test-pos + 2) mbta-coop-construct-list = True [
                 set mbta-costs-current item (test-pos + 2) mbta-planned-adaptation-cost-list
                 set mbta-cooperative-adaptation-contribution-proposed mbta-cooperative-adaptation-contribution-proposed + mbta-costs-current
                 set mbta-cooperative-adaptation-contribution-list-proposed replace-item (test-pos + 2) mbta-cooperative-adaptation-contribution-list-proposed mbta-costs-current
                 set available-budget-mbta sum([available-budget] of mbta-agents with [cooperative-construct? = True])
                ]
                [;item cb-item-order mbta-coop-construct-list = False
                  set mbta-costs-current 0
                  set mbta-cooperative-adaptation-contribution-proposed mbta-cooperative-adaptation-contribution-proposed + mbta-costs-current
                  set mbta-cooperative-adaptation-contribution-list-proposed replace-item (test-pos + 2) mbta-cooperative-adaptation-contribution-list-proposed mbta-costs-current
                  set available-budget-mbta 0
                ]
              ]
           ;calculate the potential inputs of property_owner agents
           let cost-property_owners-with-insurance sum ([planned-adaptation-cost - insurance-cost] of property_owners with [cooperative-construct? = True and boston-sw-segment-num = test-pos and insurance-intention = True])
          let cost-property_owners-without-insurance sum ([planned-adaptation-cost] of property_owners with [cooperative-construct? = True and boston-sw-segment-num = test-pos and insurance-intention = False])
          let dev-costs cost-property_owners-with-insurance + cost-property_owners-without-insurance
          let dev-budget sum([available-budget] of property_owners with [cooperative-construct? = True and boston-sw-segment-num = test-pos])

          ;calculate the potential inputs of private asset agebts
          let private-assets-cost sum ([planned-adaptation-cost] of private-assets with [cooperative-construct? = True and boston-sw-segment-num = test-pos])
          let pa-budget sum ([available-budget] of private-assets with [cooperative-construct? = True and boston-sw-segment-num = test-pos])

          ;calculate discount
          let sw-segment-cost item test-pos boston-planned-adaptation-cost-list
          let total-contributions (sw-segment-cost + mbta-costs-current + dev-costs + private-assets-cost)
          ifelse total-contributions > (sw-segment-cost * (1 + maintenance-fee)) [
                let segment-discount-pt-1 (total-contributions - (sw-segment-cost * (1 + maintenance-fee))) / (sw-segment-cost * (1 + maintenance-fee))
                set segment-discount (1 / (segment-discount-pt-1 + 1))
              ]
              [;total-contributions < sw-segment-cost
                set segment-discount 1
              ]
          set boston-vc-discount-rate-list replace-item test-pos boston-vc-discount-rate-list segment-discount
          let down-payment 0.10
            ;ifelse available-budget + available-budget-mbta + dev-budget + pa-budget > sw-segment-cost * down-payment [
          ifelse neigh-permit-delay >= permitting-delay [
                  ;Check 3: Do we have more than enough financing? (Municipality pays less
                ;output-print("is this error? 1")
            set boston-adaptation-list replace-item test-pos boston-adaptation-list adapt-intention
            set available-budget available-budget - ((sw-segment-cost * (1 + maintenance-fee)) * (segment-discount))
            set adaptation-count adaptation-count + 1
            set boston-adaptation-costs-list replace-item test-pos boston-adaptation-costs-list ((sw-segment-cost * (1 + maintenance-fee)) * (segment-discount))
            set boston-total-adaptation-cost-list replace-item test-pos boston-total-adaptation-cost-list ((sw-segment-cost * (1 + maintenance-fee)) * (segment-discount))
            set time-step-costs time-step-costs + ((sw-segment-cost * (1 + maintenance-fee)) * (segment-discount))
            set boston-crs-discount-list replace-item test-pos boston-crs-discount-list 0.3
            set boston-permit-delay-list replace-item test-pos boston-permit-delay-list 0
            set boston-coop-construct-list replace-item test-pos boston-coop-construct-list True
            ;set boston-vc-discount-rate-list replace-item cb-item-order boston-vc-discount-rate-list 0
            set wait-for-permit-boston replace-item test-pos wait-for-permit-boston false
            let proposed-mbta-cost (item (test-pos + 2) mbta-cooperative-adaptation-contribution-list-proposed)
            let proposed-mbta-cost-with-discount proposed-mbta-cost * (segment-discount)
            set mbta-cooperative-adaptation-contribution-list replace-item (test-pos + 2) mbta-cooperative-adaptation-contribution-list proposed-mbta-cost-with-discount
                  ;output-print(mbta-cooperative-adaptation-contribution-list)

                  set hold-adaptation? false
            ]
            [;neigh-permit-delay < permitting-delay
              set boston-adaptation-costs-list replace-item test-pos boston-adaptation-costs-list 0
              set boston-permit-delay-list replace-item test-pos boston-permit-delay-list (neigh-permit-delay + 1)
              set boston-coop-construct-list replace-item test-pos boston-coop-construct-list True
              set boston-vc-discount-rate-list replace-item test-pos boston-vc-discount-rate-list 0
              set hold-adaptation? false
              set wait-for-permit-boston replace-item test-pos wait-for-permit-boston True
              set mbta-cooperative-adaptation-contribution-list replace-item (test-pos + 2) mbta-cooperative-adaptation-contribution-list 0
            ]

        ]
            [;hold-adaptation = true
            set boston-permit-delay-list replace-item test-pos boston-permit-delay-list (neigh-permit-delay + 1)
            set boston-adaptation-costs-list replace-item test-pos boston-adaptation-costs-list 0
            set boston-coop-construct-list replace-item test-pos boston-coop-construct-list False
            set boston-vc-discount-rate-list replace-item test-pos boston-vc-discount-rate-list 0
            set hold-adaptation? true
            set wait-for-permit-boston replace-item test-pos wait-for-permit-boston false
            set mbta-cooperative-adaptation-contribution-list replace-item (test-pos + 2) mbta-cooperative-adaptation-contribution-list 0
            ]
          ]
        [
          ;the proposed adaptation is already in place - no change to adaptation and no new money spent
          set boston-adaptation-costs-list replace-item test-pos boston-adaptation-costs-list 0
          set boston-coop-construct-list replace-item test-pos boston-coop-construct-list False
          set boston-vc-discount-rate-list replace-item test-pos boston-vc-discount-rate-list 0
          set hold-adaptation? false
          set wait-for-permit-boston replace-item test-pos wait-for-permit-boston false
          set mbta-cooperative-adaptation-contribution-list replace-item (test-pos + 2) mbta-cooperative-adaptation-contribution-list 0
      ]

      set test-pos test-pos + 1
      set total-adaptation-cost total-adaptation-cost + time-step-costs
      ]
    ]
    [;funding-cap is true.....
      ;ifelse prioritization-method = "normal" [
      set hold-adaptation? false
      ;sort the c-b list by largest to smallest
      let sorted sort boston-seawall-cost-benefit-list
      ;create a list that maps the ranks of b-c ratios back to their initial position in sw segment list
      set ranked-list-nums map [ n -> position n sorted ] boston-seawall-cost-benefit-list
      ;output-print(ranked-list-nums)
      ;create two empty lists to be used to process the data
      set empty-list []
      set used-list []
      ;reset variable that is used to ensure we work through each value in a list
      set test-pos 0
      foreach ranked-list-nums [
        ;assigns variable 'ranktest' for the ranks of b-c ratio in order of seawall segment
        [z] -> let ranktest z
        ;checks that value to see if it has been used so far
        ifelse member? z used-list [
          ;check how many times this value has been used so far
          let count-ranktest filter [ i -> i = ranktest ] used-list
          let val-count-ranktest length count-ranktest
          ;build new list that adjusts for when there are identical b-c rankings
          set empty-list lput (val-count-ranktest + ranktest ) empty-list
          ;build another list that maintains the original list over time
          set used-list lput (ranktest) used-list

        ]
        [;no duplicate rankings- can continue to use as nomal
          set empty-list lput (ranktest) empty-list
          set used-list lput (ranktest) used-list
        ]
        ;allows us to continue to keep track of how many loops we have done
          set test-pos test-pos + 1
      ]


      ;now we map the lists back to each other
      set time-step-costs 0
      ;this sets us up so that the 8th largest b-c starts, then 7th, then ....
      foreach reverse [0 1 2 3 4 5 6 7 8] [ ;this list has to be a list of the total number of rank positions
        [x] -> let rank-search x
        ;get the position value of the needed rank based on the list of final rankings in the positions of the sw segments
        let cb-item-order position rank-search empty-list
        ;using the sw-position value, get the final cost-benefit value
        let cb-item item cb-item-order boston-seawall-cost-benefit-list
        ;now we can start with the tests to actually implement an adaptation, in order of importance
        ;get adaptation intention of each regioin
        let adapt-intention item cb-item-order boston-adaptation-intention-list
        ;check existing adaptation
        let neighborhood-adapt item cb-item-order boston-adaptation-list
        ;get corresponding cost for the planned adaptation
        let cost-test item cb-item-order boston-planned-adaptation-cost-list
        let total-adapt-cost-region item cb-item-order boston-total-adaptation-cost-list
        let neigh-permit-delay item cb-item-order boston-permit-delay-list
        let coop-plan item cb-item-order boston-coop-construct-list

        ifelse neighborhood-adapt != adapt-intention [
          ifelse coop-plan = True[
            ifelse hold-adaptation? = false [
              ifelse mbta-adaptation-method = "all-at-once" [
           let mbta-percent item cb-item-order mbta-damage-list-boston
           let mbta-cost-percent item (cb-item-order + 2) mbta-cost-proportion-list
                ;replaced damage percent with cost percent below so the max amount that the mbta will provide is what they would have contributed to that seawall to begin with
           set mbta-costs-current sum([planned-adaptation-cost] of mbta-agents with [cooperative-construct? = True]) * mbta-cost-percent
           set mbta-cooperative-adaptation-contribution-proposed mbta-cooperative-adaptation-contribution-proposed + mbta-costs-current
           set mbta-cooperative-adaptation-contribution-list-proposed replace-item (cb-item-order + 2) mbta-cooperative-adaptation-contribution-list-proposed mbta-costs-current
           set available-budget-mbta sum([available-budget] of mbta-agents with [cooperative-construct? = True])]
              [;mbta-adaptation-method = "segments"
                let mbta-percent item cb-item-order mbta-damage-list-boston
                ifelse item (cb-item-order + 2) mbta-coop-construct-list = True [
                 set mbta-costs-current item (cb-item-order + 2) mbta-planned-adaptation-cost-list
                 set mbta-cooperative-adaptation-contribution-proposed mbta-cooperative-adaptation-contribution-proposed + mbta-costs-current
                 set mbta-cooperative-adaptation-contribution-list-proposed replace-item (cb-item-order + 2) mbta-cooperative-adaptation-contribution-list-proposed mbta-costs-current
                 set available-budget-mbta sum([available-budget] of mbta-agents with [cooperative-construct? = True])
                ]
                [;item cb-item-order mbta-coop-construct-list = False
                  set mbta-costs-current 0
                  set mbta-cooperative-adaptation-contribution-proposed mbta-cooperative-adaptation-contribution-proposed + mbta-costs-current
                  set mbta-cooperative-adaptation-contribution-list-proposed replace-item (cb-item-order + 2) mbta-cooperative-adaptation-contribution-list-proposed mbta-costs-current
                  set available-budget-mbta 0
                ]
              ]
           ;calculate the potential inputs of property_owner agents
           let cost-property_owners-with-insurance sum ([planned-adaptation-cost - insurance-cost] of property_owners with [cooperative-construct? = True and boston-sw-segment-num = cb-item-order and insurance-intention = True])
          let cost-property_owners-without-insurance sum ([planned-adaptation-cost] of property_owners with [cooperative-construct? = True and boston-sw-segment-num = cb-item-order and insurance-intention = False])
          let dev-costs cost-property_owners-with-insurance + cost-property_owners-without-insurance
          let dev-budget sum([available-budget] of property_owners with [cooperative-construct? = True and boston-sw-segment-num = cb-item-order])

          ;calculate the potential inputs of private asset agebts
          let private-assets-cost sum ([planned-adaptation-cost] of private-assets with [cooperative-construct? = True and boston-sw-segment-num = cb-item-order])
          let pa-budget sum ([available-budget] of private-assets with [cooperative-construct? = True and boston-sw-segment-num = cb-item-order])

          ;calculate discount
          let sw-segment-cost item cb-item-order boston-planned-adaptation-cost-list
          let total-contributions (sw-segment-cost + mbta-costs-current + dev-costs + private-assets-cost)
          ifelse total-contributions > (sw-segment-cost * (1 + maintenance-fee)) [
                let segment-discount-pt-1 (total-contributions - (sw-segment-cost * (1 + maintenance-fee))) / (sw-segment-cost * (1 + maintenance-fee))
                set segment-discount (1 / (segment-discount-pt-1 + 1))

                ;output-print("segment-discount")
                ;output-print(segment-discount)
              ]
              [;total-contributions < sw-segment-cost
                set segment-discount 1
              ]
          set boston-vc-discount-rate-list replace-item cb-item-order boston-vc-discount-rate-list segment-discount
          let down-payment 0.10
            ifelse available-budget + available-budget-mbta + dev-budget + pa-budget > (sw-segment-cost * (1 + maintenance-fee)) * down-payment [
          ifelse neigh-permit-delay >= permitting-delay [
                  ;Check 3: Do we have more than enough financing? (Municipality pays less
                ;output-print("is this error? 1")
            set boston-adaptation-list replace-item cb-item-order boston-adaptation-list adapt-intention
            set available-budget available-budget - ((sw-segment-cost * (1 + maintenance-fee)) * (segment-discount))
            set adaptation-count adaptation-count + 1
            set boston-adaptation-costs-list replace-item cb-item-order boston-adaptation-costs-list ((sw-segment-cost * (1 + maintenance-fee)) * (segment-discount))
            set boston-total-adaptation-cost-list replace-item cb-item-order boston-total-adaptation-cost-list ((sw-segment-cost * (1 + maintenance-fee)) * (segment-discount))
            set time-step-costs time-step-costs + ((sw-segment-cost * (1 + maintenance-fee)) * (segment-discount))
            set boston-crs-discount-list replace-item cb-item-order boston-crs-discount-list 0.3
            set boston-permit-delay-list replace-item cb-item-order boston-permit-delay-list 0
            set boston-coop-construct-list replace-item cb-item-order boston-coop-construct-list True
            ;set boston-vc-discount-rate-list replace-item cb-item-order boston-vc-discount-rate-list 0
            set wait-for-permit-boston replace-item cb-item-order wait-for-permit-boston false
            let proposed-mbta-cost (item (cb-item-order + 2) mbta-cooperative-adaptation-contribution-list-proposed)
                 ; output-print("proposed-mbta-cost")
                  ;output-print(proposed-mbta-cost)
            let proposed-mbta-cost-with-discount proposed-mbta-cost * (segment-discount)
            set mbta-cooperative-adaptation-contribution-list replace-item (cb-item-order + 2) mbta-cooperative-adaptation-contribution-list proposed-mbta-cost-with-discount
                  ;output-print(mbta-cooperative-adaptation-contribution-list)


;              ]
                  set hold-adaptation? false
            ]
            [;neigh-permit-delay < permitting-delay
              set boston-adaptation-costs-list replace-item cb-item-order boston-adaptation-costs-list 0
              set boston-permit-delay-list replace-item cb-item-order boston-permit-delay-list (neigh-permit-delay + 1)
              set boston-coop-construct-list replace-item cb-item-order boston-coop-construct-list True
              set boston-vc-discount-rate-list replace-item cb-item-order boston-vc-discount-rate-list 0
              set hold-adaptation? false
              set wait-for-permit-boston replace-item cb-item-order wait-for-permit-boston True
              set mbta-cooperative-adaptation-contribution-list replace-item (cb-item-order + 2) mbta-cooperative-adaptation-contribution-list 0
            ]
          ]
          [
            ;not enough budget to adapt here
            set boston-permit-delay-list replace-item cb-item-order boston-permit-delay-list (neigh-permit-delay + 1)
            set boston-adaptation-costs-list replace-item cb-item-order boston-adaptation-costs-list 0
            set boston-coop-construct-list replace-item cb-item-order boston-coop-construct-list False
            set boston-vc-discount-rate-list replace-item cb-item-order boston-vc-discount-rate-list 0
            set hold-adaptation? true
            set wait-for-permit-boston replace-item cb-item-order wait-for-permit-boston false
            set mbta-cooperative-adaptation-contribution-list replace-item (cb-item-order + 2) mbta-cooperative-adaptation-contribution-list 0


             ]
        ]
            [;hold-adaptation = true
            set boston-permit-delay-list replace-item cb-item-order boston-permit-delay-list (neigh-permit-delay + 1)
            set boston-adaptation-costs-list replace-item cb-item-order boston-adaptation-costs-list 0
            set boston-coop-construct-list replace-item cb-item-order boston-coop-construct-list False
            set boston-vc-discount-rate-list replace-item cb-item-order boston-vc-discount-rate-list 0
            set hold-adaptation? true
            set wait-for-permit-boston replace-item cb-item-order wait-for-permit-boston false
            set mbta-cooperative-adaptation-contribution-list replace-item (cb-item-order + 2) mbta-cooperative-adaptation-contribution-list 0
            ]
          ]
          [;coop-plan = False
            ifelse hold-adaptation? = false [
          ;assign plan cost and down payment
          let plan-cost-again item cb-item-order boston-planned-adaptation-cost-list
          let down-payment 0.10
          ;check plan cost
          ifelse available-budget > plan-cost-again * down-payment [
            ;check permitting
            ifelse neigh-permit-delay >= permitting-delay [
              ;adapt
            set boston-adaptation-list replace-item cb-item-order boston-adaptation-list adapt-intention
            set available-budget available-budget - plan-cost-again
            set adaptation-count adaptation-count + 1
            set boston-adaptation-costs-list replace-item cb-item-order boston-adaptation-costs-list plan-cost-again
            set boston-total-adaptation-cost-list replace-item cb-item-order boston-total-adaptation-cost-list plan-cost-again
            set boston-base-adaptation-cost-list replace-item cb-item-order boston-adaptation-costs-list plan-cost-again
            set time-step-costs time-step-costs + plan-cost-again
            set boston-crs-discount-list replace-item cb-item-order boston-crs-discount-list 0.3
            set boston-permit-delay-list replace-item cb-item-order boston-permit-delay-list 0
            set hold-adaptation? false

            ]
            [;neigh-permit-delay < permitting-delay
              set boston-adaptation-costs-list replace-item cb-item-order boston-adaptation-costs-list 0
              set boston-permit-delay-list replace-item cb-item-order boston-permit-delay-list (neigh-permit-delay + 1)
              set hold-adaptation? false
            ]
          ]
          [            ;not enough budget to adapt here
            set boston-adaptation-costs-list replace-item cb-item-order boston-adaptation-costs-list 0
            set boston-permit-delay-list replace-item cb-item-order boston-permit-delay-list (neigh-permit-delay + 1)
            set hold-adaptation? true
             ]
        ]
            [; hold-adaptation? = true
              set boston-adaptation-costs-list replace-item cb-item-order boston-adaptation-costs-list 0
              set boston-permit-delay-list replace-item cb-item-order boston-permit-delay-list (neigh-permit-delay + 1)
              set hold-adaptation? true
            ]

          ]
        ]
        [
          ;the proposed adaptation is already in place - no change to adaptation and no new money spent
          set boston-adaptation-costs-list replace-item cb-item-order boston-adaptation-costs-list 0
          set boston-coop-construct-list replace-item cb-item-order boston-coop-construct-list False
          set boston-vc-discount-rate-list replace-item cb-item-order boston-vc-discount-rate-list 0
          set hold-adaptation? false
          set wait-for-permit-boston replace-item cb-item-order wait-for-permit-boston false
          set mbta-cooperative-adaptation-contribution-list replace-item (cb-item-order + 2) mbta-cooperative-adaptation-contribution-list 0
      ]

    ;]
      set total-adaptation-cost total-adaptation-cost + time-step-costs
      ]

    ]
  ]

end


to property_owner-adaptation-implementation-noncooperative
  if funding-cap = False [
        ;Assume property_owners will buy insurance regardless of cost as a % of household value FOR NOW - adaptations beyond that are funding dependent
    ifelse insurance-intention = True [
      set insurance? True]
    [set insurance? False]
    ifelse adaptation != adaptation-intention[
        ifelse permit-delay-count = permitting-delay [
      ;assume need 60% down payment
      ifelse 4 > 2 [
      set adaptation adaptation-intention
      set adaptation-count adaptation-count + 1
      set adaptation-cost planned-adaptation-cost
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
  ]
    [
      ;o&m work

      ifelse insurance-intention = True [
      ;set total-adaptation-cost total-adaptation-cost + sum ([premium] of property_owners with [insurance? = True])
            set adaptation-cost insurance-cost]
          [set adaptation-cost 0]
          set total-adaptation-cost adaptation-cost + total-adaptation-cost

      ]
       set permit-delay-count 0
        ]

      [;permit-delay-count != permitting-delay
        ifelse insurance-intention = True [
          ;set total-adaptation-cost total-adaptation-cost + sum ([premium] of property_owners with [insurance? = True])
            set adaptation-cost insurance-cost]
          [set adaptation-cost 0]
          set total-adaptation-cost adaptation-cost + total-adaptation-cost
        set permit-delay-count permit-delay-count + 1

      ]
      ]
    [ifelse insurance-intention = True [
      set insurance? True
      set adaptation-cost insurance-cost]
      [set adaptation-cost 0
      set insurance? False]
      set total-adaptation-cost adaptation-cost + total-adaptation-cost
      ;set total-adaptation-cost total-adaptation-cost + sum ([premium] of property_owners with [insurance? = True])
    ]
  ]
  if funding-cap = True [
    ifelse insurance-intention = True [
      set insurance? True]
    [set insurance? False]
    ifelse adaptation != adaptation-intention[
        ifelse permit-delay-count >= permitting-delay [
      ;assume need 60% down payment
      ;FOR TEST CHANGE LINE BELOW TO SOMETHING OBVI SO ADAPTATION HAS TO HAPPER
      ifelse available-budget > planned-adaptation-cost * .6 [
      ;ifelse 4 > 2 [
      set adaptation adaptation-intention
      set adaptation-count adaptation-count + 1
      set adaptation-cost planned-adaptation-cost
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
      set permit-delay-count 0

  ]
    [
      ;not enough bodget
      set permit-delay-count permit-delay-count + 1
      ifelse insurance-intention = True [
      ;set total-adaptation-cost total-adaptation-cost + sum ([premium] of property_owners with [insurance? = True])
            set adaptation-cost insurance-cost]
          [set adaptation-cost 0]
          set total-adaptation-cost adaptation-cost + total-adaptation-cost
    ]
        ]
        [;permit-delay-count < permitting-delay
          ifelse insurance-intention = True [
      ;set total-adaptation-cost total-adaptation-cost + sum ([premium] of property_owners with [insurance? = True])
            set adaptation-cost insurance-cost]
          [set adaptation-cost 0]
          set total-adaptation-cost adaptation-cost + total-adaptation-cost
          set permit-delay-count permit-delay-count + 1
        ]
      ]
    [ifelse insurance-intention = True [
      set adaptation-cost insurance-cost
      set insurance? True]
      [set adaptation-cost 0
      set insurance? False]
      set total-adaptation-cost adaptation-cost + total-adaptation-cost
    ]
  ]
end

to pa-adaptation-implementation-noncooperative
  ifelse funding-cap = False [
    ifelse adaptation != adaptation-intention[
        ifelse permit-delay-count = permitting-delay [
      ifelse 4 > 2 [
      set adaptation adaptation-intention
        set adaptation-count adaptation-count + 1
        set adaptation-cost planned-adaptation-cost
        set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost

  ]
    [
      ;o&m work
      set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
  ]
          set permit-delay-count 0
        ]
        [;permit-delay-count != permitting-delay
          set adaptation-cost 0
          set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set permit-delay-count permit-delay-count + 1
        ]
      ]
      [set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
  ]
]
  [;funding-cap = true
     ifelse adaptation != adaptation-intention[
        ifelse permit-delay-count >= permitting-delay[
      ;TEST CHANGE LINE BELOW TO FORCE ADAPTATION
      ifelse available-budget > planned-adaptation-cost * 0.3 [
     ; ifelse 4 > planned-adaptation-cost * 0.3 [
      set adaptation adaptation-intention
        set adaptation-count adaptation-count + 1
        set adaptation-cost planned-adaptation-cost
        set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost

      set permit-delay-count 0
  ]
    [
      ;not enough funding
      set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set permit-delay-count permit-delay-count + 1
  ]
        ]
        [;permit-delay-count < permitting-delay
          set adaptation-cost 0
          set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set permit-delay-count permit-delay-count + 1

        ]


        ]
      [set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
  ]
  ]

end

to mbta-adaptation-implementation-noncooperative

  if mbta-adaptation-method = "all-at-once" [
  ifelse funding-cap = False[
    ifelse adaptation != adaptation-intention[
        ifelse permit-delay-count >= permitting-delay[
      ;assum 30% as down-payment
      ifelse 4 > 2 [
      set adaptation adaptation-intention
      set adaptation-count adaptation-count + 1
      set adaptation-cost planned-adaptation-cost
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
      set permit-delay-count 0
  ]
    [
      ;o&m work
      set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set permit-delay-count permit-delay-count + 1
    ]
        ]
        [;permit-delay-count < permitting-delay
          set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set permit-delay-count permit-delay-count + 1
        ]
    ]
    [set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
  ]]
  [;funding-cap = true
    ifelse adaptation != adaptation-intention[
        ifelse permit-delay-count >= permitting-delay[
      ;assum 30% as down-payment
      ;CHANGE LINE BELOW FOR TEST TO FORCE ADAPTAION
      ifelse available-budget > planned-adaptation-cost * .1 [
      ;ifelse 4 > 2 [
      set adaptation adaptation-intention
      set adaptation-count adaptation-count + 1
      set adaptation-cost planned-adaptation-cost
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
      set permit-delay-count 0

  ]
    [
      ;o&m work
      set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set permit-delay-count permit-delay-count + 1
    ]
        ]
        [;permit-delay-count < permitting-delay
          set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set permit-delay-count permit-delay-count + 1
        ]
    ]
    [set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
    ]
  ]
  ]

;  ]
end



to adaptation-implementation
;probability of accomplishing- in future can input things like costs, time, etc

  ;first we check that there is no funding cap -> everything desired is implemented
  ifelse funding-cap = False [
    ;start with north-shore and south-shore mun
  ask municipalities with [name != "boston"][
      ;check that current adaptation does not match the planned adaptation
     ifelse adaptation != adaptation-intention [
        ;check that the time required to fill permits has been completed
        ifelse permit-delay-count >= permitting-delay [
          ;implement the new adaptation
          set adaptation adaptation-intention
          set adaptation-count adaptation-count + 1
          set adaptation-cost planned-adaptation-cost
          set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set permit-delay-count 0
      ]
        [ ;waiting for permitting-delay
          set permit-delay-count permit-delay-count + 1
          set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost]
      ]
    [;here, adaptation = adaptation-intention
        set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost]
      ;code below updates crs discount according to whether or not the municipality has a seawall
    ifelse adaptation = "seawall" [
        set crs-discount 0.3]
      [set crs-discount 0]
  ; end of implementation for ns and ss municipalities without a funding cap
  ]

   ask municipalities with [name = "boston"][
    set test-pos 0
    set time-step-costs 0
    ;code below calulates for each neighbodhood in boston
    foreach boston-adaptation-intention-list[
       ;sets adapt-intention as the neighborhood adaptation intention
      [x] -> let adapt-intention x
       ;assigns variable to the actual neighborhood adaptation
      let neighborhood-adapt item test-pos boston-adaptation-list
       ;assigns variable representing seawall cost
      let plan-cost item test-pos boston-planned-adaptation-cost-list
        ;assigns variable representing total neighborhood cost
      let total-adapt-cost-region item test-pos boston-total-adaptation-cost-list
        ;assigns variable tracking the permit delay on each segment of seawall
      let neigh-permit-delay item test-pos boston-permit-delay-list
        ;check that there is a desire to adaptat that does not eaqual the intention (ie an adaptation is desired)
      ifelse neighborhood-adapt != adapt-intention[
          ;check that the permit delay has been fulfilled
          ifelse neigh-permit-delay >= permitting-delay [
            ;lost this variable with the new brackets- reassign
      let plan-cost-again item test-pos boston-planned-adaptation-cost-list
           ;assumption about down payment required
      let down-payment 0.10
            ;check that there are sufficient funds
      ifelse available-budget > plan-cost-again * down-payment [
              ;adapt and update metrics
      set boston-adaptation-list replace-item test-pos boston-adaptation-list x
      set available-budget available-budget - plan-cost
      set adaptation-count adaptation-count + 1
      set boston-adaptation-costs-list replace-item test-pos boston-adaptation-costs-list plan-cost
      set boston-base-adaptation-cost-list replace-item test-pos boston-adaptation-costs-list plan-cost
      set boston-total-adaptation-cost-list replace-item test-pos boston-total-adaptation-cost-list plan-cost
      set time-step-costs time-step-costs + plan-cost
      set boston-crs-discount-list replace-item test-pos boston-crs-discount-list 0.3]
       [;same code as above, because the funding cap is supposed to be off so there should be no money dependence
          set boston-adaptation-list replace-item test-pos boston-adaptation-list x
      set available-budget available-budget - plan-cost
      set adaptation-count adaptation-count + 1
      set boston-adaptation-costs-list replace-item test-pos boston-adaptation-costs-list plan-cost
      set boston-base-adaptation-cost-list replace-item test-pos boston-adaptation-costs-list plan-cost
      set boston-total-adaptation-cost-list replace-item test-pos boston-total-adaptation-cost-list plan-cost
      set time-step-costs time-step-costs + plan-cost
      set boston-crs-discount-list replace-item test-pos boston-crs-discount-list 0.3

    ]
            ;regardless of funding, the adaptation is placed and the crs is affected
            set boston-permit-delay-list replace-item test-pos boston-permit-delay-list 0
        ]
          [;neigh-permit-delay != permitting-delay
            set boston-adaptation-costs-list replace-item test-pos boston-adaptation-costs-list 0
            set boston-permit-delay-list replace-item test-pos boston-permit-delay-list (neigh-permit-delay + 1)
          ]
        ]
      [;neighborhood-adapt == adapt-intention, no adaptation desired
        set boston-adaptation-costs-list replace-item test-pos boston-adaptation-costs-list 0
      ]
        ;triggers repetition for the rest of boston
     set test-pos test-pos + 1
    ]
      ;tracks total municipality adaptation costs
      set total-adaptation-cost total-adaptation-cost + time-step-costs
  ]

  ask property_owners[
    ;Assume property_owners will buy insurance regardless of cost as a % of household value FOR NOW - adaptations beyond that are funding dependent
    ifelse insurance-intention = True [
      set insurance? True]
    [set insurance? False]
    ifelse adaptation != adaptation-intention[
         ifelse permit-delay-count >= permitting-delay [
      ;ifelse available-budget > planned-adaptation-cost * .6 [
          ;becuase there is no funding cap this 4 > 2 ensures adaptation (funding cap has statement above in place)
      ifelse 4 > 2 [
      set adaptation adaptation-intention
      set adaptation-count adaptation-count + 1
      set adaptation-cost planned-adaptation-cost
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
  ]
    [;code should never reach this block- the false of the true statement
            ifelse insurance-intention = True [
      ;set total-adaptation-cost total-adaptation-cost + sum ([premium] of property_owners with [insurance? = True])
            set adaptation-cost insurance-cost]
          [set adaptation-cost 0]
          set total-adaptation-cost adaptation-cost + total-adaptation-cost
      ]
       set permit-delay-count 0
        ]

      [;permit-delay-count != permitting-delay
          ifelse insurance-intention = True [
      ;set total-adaptation-cost total-adaptation-cost + sum ([premium] of property_owners with [insurance? = True])
            set adaptation-cost insurance-cost]
          [set adaptation-cost 0]
          set total-adaptation-cost adaptation-cost + total-adaptation-cost
        set adaptation-cost 0
          ;CHECK BLOCKING THIS OUT 7/18
        ;set total-adaptation-cost total-adaptation-cost + sum ([premium] of property_owners with [insurance? = True])
        set permit-delay-count permit-delay-count + 1
      ]
      ]
    [;no adaptation is desired
        ifelse insurance-intention = True[
          set adaptation-cost insurance-cost
          set insurance? True]
        [set insurance? False
          set adaptation-cost 0]
      set total-adaptation-cost adaptation-cost + total-adaptation-cost
    ]

  ]
  ask MBTA-agents[
      if mbta-adaptation-method = "all-at-once" [
    ifelse adaptation != adaptation-intention[
        ifelse permit-delay-count = permitting-delay [
      ;assum 30% as down-payment
      ;CHANGE LINE BELOW FOR TEST TO FORCE ADAPTAION
;      ifelse available-budget > planned-adaptation-cost * .3 [
          ;line below forces adaptation (Again)
      ifelse 4 > 2 [
      set adaptation adaptation-intention
      set adaptation-count adaptation-count + 1
      set adaptation-cost planned-adaptation-cost
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost

  ]
    [;no funding - code should never reach this point because funding is false
      set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
    ]
      set permit-delay-count 0
    ]
        [;permit-delay-count != permitting-delay
          set permit-delay-count permit-delay-count + 1
          set adaptation-cost 0
          set total-adaptation-cost total-adaptation-cost + adaptation-cost
        ]
      ]
    [;no desire for adaptation
        set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
    ]
  ]
   if mbta-adaptation-method = "segments"[
        ;no funding cap: there is no need to prioritize anything as long as the other criteria are met
        set test-pos 0
        set time-step-costs 0
    ;code below calulates for each neighbodhood in boston
        foreach mbta-adaptation-intention-list[
       ;sets adapt-intention as the neighborhood adaptation intention
      [x] -> let adapt-intention x
       ;assigns variable to the actual neighborhood adaptation
      let neighborhood-adapt item test-pos mbta-adaptation-list
       ;assigns variable representing seawall cost
      let plan-cost item test-pos mbta-planned-adaptation-cost-list
        ;assigns variable representing total neighborhood cost
      let total-adapt-cost-region item test-pos mbta-total-adaptation-cost-list
        ;assigns variable tracking the permit delay on each segment of seawall
      let neigh-permit-delay item test-pos mbta-permit-delay-list
        ;check that there is a desire to adaptat that does not eaqual the intention (ie an adaptation is desired)
      ifelse neighborhood-adapt != adapt-intention[
          ;check that the permit delay has been fulfilled
          ifelse neigh-permit-delay >= permitting-delay [
            ;lost this variable with the new brackets- reassign
      let plan-cost-again item test-pos mbta-planned-adaptation-cost-list
           ;assumption about down payment required
      set mbta-adaptation-list replace-item test-pos mbta-adaptation-list x
      set available-budget available-budget - plan-cost
      set adaptation-count adaptation-count + 1
      set mbta-adaptation-cost-list replace-item test-pos mbta-adaptation-cost-list plan-cost
      set mbta-total-adaptation-cost-list replace-item test-pos mbta-total-adaptation-cost-list plan-cost
      set mbta-base-adaptation-cost-list replace-item test-pos mbta-base-adaptation-cost-list plan-cost
      set time-step-costs time-step-costs + plan-cost
      set mbta-permit-delay-list replace-item test-pos mbta-permit-delay-list 0
        ]
          [;neigh-permit-delay != permitting-delay
            set mbta-adaptation-cost-list replace-item test-pos mbta-adaptation-cost-list 0
            set mbta-permit-delay-list replace-item test-pos mbta-permit-delay-list (neigh-permit-delay + 1)
          ]
        ]
      [;neighborhood-adapt == adapt-intention, no adaptation desired
        set mbta-adaptation-cost-list replace-item test-pos mbta-adaptation-cost-list 0
      ]
        ;triggers repetition for the rest of boston
     set test-pos test-pos + 1
    ]
      ;tracks total municipality adaptation costs
      set total-adaptation-cost total-adaptation-cost + time-step-costs


      ]

 ]

    ;process pretty much repeats for them
  ask private-assets[
    ifelse adaptation != adaptation-intention[
        ifelse permit-delay-count = permitting-delay [
      ;TEST CHANGE LINE BELOW TO FORCE ADAPTATION
      ;ifelse available-budget > planned-adaptation-cost * 0.3 [
      ifelse 4 > 2 [
      set adaptation adaptation-intention
        set adaptation-count adaptation-count + 1
        set adaptation-cost planned-adaptation-cost
        set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost

  ]
    [
      ;o&m work
      set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
  ]
          set permit-delay-count 0
        ]
        [;permit-delay-count != permitting-delay
          set adaptation-cost 0
          set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set permit-delay-count permit-delay-count + 1
        ]
      ]
      [set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
  ]
  ]
  ]

  [;funding cap = true, now there are limits on funding and financing
    ask municipalities with [name != "boston"][
      ;check adaptation is desired
    ifelse adaptation != adaptation-intention [
        ;check permits have been waited for
        ifelse permit-delay-count >= permitting-delay [
      let down-payment .1
          ;check funding
      ifelse available-budget >= planned-adaptation-cost * down-payment[
      set adaptation adaptation-intention
      set available-budget available-budget - planned-adaptation-cost
      set adaptation-count adaptation-count + 1
      set adaptation-cost planned-adaptation-cost
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      ifelse adaptation = "seawall" [
        set crs-discount 0.3]
      [set crs-discount 0]
       set permit-delay-count 0
  ]
  [;not enough funding
      set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set permit-delay-count permit-delay-count + 1
    ]

        ]
        [;permit-delay-count < permitting-delay
          set adaptation-cost 0
          set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set permit-delay-count permit-delay-count + 1
        ]
        ]
    [;no desire to adapt
        set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set permit-delay-count 0
    ]

  ]

   ask municipalities with [name = "boston"][
      ;ifelse prioritization-method = "normal" [
      ;sort the c-b list by largest to smallest
      let sorted sort boston-seawall-cost-benefit-list
      ;output-print(sorted)
      ;create a list that maps the ranks of b-c ratios back to their initial position in sw segment list
      set ranked-list-nums map [ n -> position n sorted ] boston-seawall-cost-benefit-list
      ;output-print(ranked-list-nums)
      ;create two empty lists to be used to process the data
      set empty-list []
      set used-list []
      ;reset variable that is used to ensure we work through each value in a list
      set test-pos 0
      foreach ranked-list-nums [
        ;assigns variable 'ranktest' for the ranks of b-c ratio in order of seawall segment
        [z] -> let ranktest z
        ;checks that value to see if it has been used so far
        ifelse member? z used-list [
          ;check how many times this value has been used so far
          let count-ranktest filter [ i -> i = ranktest ] used-list
          let val-count-ranktest length count-ranktest
          ;build new list that adjusts for when there are identical b-c rankings
          set empty-list lput (val-count-ranktest + ranktest ) empty-list
          ;adjust the origincal ranked-list list
          ;set ranked-list-nums replace-item test-pos ranked-list-nums (val-count-ranktest)
          ;build another list that maintains the original list over time
          set used-list lput (ranktest) used-list

        ]
        [;no duplicate rankings- can continue to use as nomal
          set empty-list lput (ranktest) empty-list
          set used-list lput (ranktest) used-list
        ]
        ;allows us to continue to keep track of how many loops we have done
          set test-pos test-pos + 1
      ]


      ;now we map the lists back to each other
      set time-step-costs 0
        set hold-adaptation? false
      ;this sets us up so that the 8th largest b-c starts, then 7th, then ....
      foreach reverse [0 1 2 3 4 5 6 7 8] [ ;this list has to be a list of the total number of rank positions
        [x] -> let rank-search x
        ;get the position value of the needed rank based on the list of final rankings in the positions of the sw segments
        let cb-item-order position rank-search empty-list
        ;using the sw-position value, get the final cost-benefit value
        let cb-item item cb-item-order boston-seawall-cost-benefit-list
        ;now we can start with the tests to actually implement an adaptation, in order of importance
        ;get adaptation intention of each regioin
        let adapt-intention item cb-item-order boston-adaptation-intention-list
        ;check existing adaptation
        let neighborhood-adapt item cb-item-order boston-adaptation-list
        ;get corresponding cost for the planned adaptation
        let cost-test item cb-item-order boston-planned-adaptation-cost-list
        let total-adapt-cost-region item cb-item-order boston-total-adaptation-cost-list
        let neigh-permit-delay item cb-item-order boston-permit-delay-list


        ifelse neighborhood-adapt != adapt-intention [
            ifelse hold-adaptation? = false [
          ;assign plan cost and down payment
          let plan-cost-again item cb-item-order boston-planned-adaptation-cost-list
          let down-payment 0.10
          ;check plan cost
          ifelse available-budget > plan-cost-again * down-payment [
            ;check permitting
            ifelse neigh-permit-delay >= permitting-delay [
              ;adapt
            set boston-adaptation-list replace-item cb-item-order boston-adaptation-list adapt-intention
            set available-budget available-budget - plan-cost-again
            set adaptation-count adaptation-count + 1
            set boston-adaptation-costs-list replace-item cb-item-order boston-adaptation-costs-list plan-cost-again
            set boston-total-adaptation-cost-list replace-item cb-item-order boston-total-adaptation-cost-list plan-cost-again
            set boston-base-adaptation-cost-list replace-item cb-item-order boston-adaptation-costs-list plan-cost-again
            set time-step-costs time-step-costs + plan-cost-again
            set boston-crs-discount-list replace-item cb-item-order boston-crs-discount-list 0.3
            set boston-permit-delay-list replace-item cb-item-order boston-permit-delay-list 0
            set hold-adaptation? false

            ]
            [;neigh-permit-delay < permitting-delay
              set boston-adaptation-costs-list replace-item cb-item-order boston-adaptation-costs-list 0
              set boston-permit-delay-list replace-item cb-item-order boston-permit-delay-list (neigh-permit-delay + 1)
              set hold-adaptation? false
            ]
          ]
          [            ;not enough budget to adapt here
            set boston-adaptation-costs-list replace-item cb-item-order boston-adaptation-costs-list 0
            set boston-permit-delay-list replace-item cb-item-order boston-permit-delay-list (neigh-permit-delay + 1)
            set hold-adaptation? true
             ]
        ]
            [; hold-adaptation? = true
              set boston-adaptation-costs-list replace-item cb-item-order boston-adaptation-costs-list 0
              set boston-permit-delay-list replace-item cb-item-order boston-permit-delay-list (neigh-permit-delay + 1)
              set hold-adaptation? true
            ]
          ]
        [
          ;the proposed adaptation is already in place - no change to adaptation and no new money spent
          set boston-adaptation-costs-list replace-item cb-item-order boston-adaptation-costs-list 0
            set hold-adaptation? false
      ]
    ]
      ;sum total costs for boston
      set total-adaptation-cost total-adaptation-cost + time-step-costs
     ; ]

      ]
  ]

  ask property_owners[
    ;Assume property_owners will buy insurance regardless of cost as a % of household value FOR NOW - adaptations beyond that are funding dependent
    ifelse insurance-intention = True [
      set insurance? True]
    [set insurance? False]
    ifelse adaptation != adaptation-intention[
        ifelse permit-delay-count >= permitting-delay [
      ;assume need 60% down payment
      ifelse available-budget > planned-adaptation-cost * .6 [
      set adaptation adaptation-intention
      set adaptation-count adaptation-count + 1
      set adaptation-cost planned-adaptation-cost
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
      set permit-delay-count 0

  ]
    [

      ;not enough bodget
      ifelse insurance-intention = True [
      ;set total-adaptation-cost total-adaptation-cost + sum ([premium] of property_owners with [insurance? = True])
            set adaptation-cost insurance-cost]
          [set adaptation-cost 0]
          set total-adaptation-cost adaptation-cost + total-adaptation-cost
      set permit-delay-count permit-delay-count + 1
    ]
        ]
        [;permit-delay-count < permitting-delay
          ifelse insurance-intention = True [
      ;set total-adaptation-cost total-adaptation-cost + sum ([premium] of property_owners with [insurance? = True])
            set adaptation-cost insurance-cost]
          [set adaptation-cost 0]
          set total-adaptation-cost adaptation-cost + total-adaptation-cost
          set permit-delay-count permit-delay-count + 1
        ]
      ]
    [ifelse insurance-intention = True [
      ;set total-adaptation-cost total-adaptation-cost + sum ([premium] of property_owners with [insurance? = True])
            set adaptation-cost insurance-cost]
          [set adaptation-cost 0]
          set total-adaptation-cost adaptation-cost + total-adaptation-cost
      ;set total-adaptation-cost total-adaptation-cost + sum ([premium] of property_owners with [insurance? = True])
    ]

  ]
  ask MBTA-agents[
    if mbta-adaptation-method = "all-at-once" [
    ifelse adaptation != adaptation-intention[
        ifelse permit-delay-count >= permitting-delay[
      ;assum 30% as down-payment
      ifelse available-budget > planned-adaptation-cost * .1 [
      set adaptation adaptation-intention
      set adaptation-count adaptation-count + 1
      set adaptation-cost planned-adaptation-cost
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
      set permit-delay-count 0
  ]
    [;budget constraints
      set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set permit-delay-count permit-delay-count + 1
    ]
        ]
        [;permit-delay-count < permitting-delay
          set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set permit-delay-count permit-delay-count + 1
        ]
    ]
    [set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
    ]
  ]

  if mbta-adaptation-method = "segments" [
       ifelse prioritization-method = "normal" [
      ;sort the c-b list by largest to smallest
      let sorted sort mbta-benefit-cost-ratio-list
      ;output-print(sorted)
      ;create a list that maps the ranks of b-c ratios back to their initial position in sw segment list
      set ranked-list-nums map [ n -> position n sorted ] mbta-benefit-cost-ratio-list
      ;output-print(ranked-list-nums)
      ;create two empty lists to be used to process the data
      set empty-list []
      set used-list []
      ;reset variable that is used to ensure we work through each value in a list
      set test-pos 0
      foreach ranked-list-nums [
        ;assigns variable 'ranktest' for the ranks of b-c ratio in order of seawall segment
        [z] -> let ranktest z
        ;checks that value to see if it has been used so far
        ifelse member? z used-list [
          ;check how many times this value has been used so far
          let count-ranktest filter [ i -> i = ranktest ] used-list
          let val-count-ranktest length count-ranktest
          ;build new list that adjusts for when there are identical b-c rankings
          set empty-list lput (val-count-ranktest + ranktest ) empty-list
          ;adjust the origincal ranked-list list
          ;set ranked-list-nums replace-item test-pos ranked-list-nums (val-count-ranktest)
          ;build another list that maintains the original list over time
          set used-list lput (ranktest) used-list

        ]
        [;no duplicate rankings- can continue to use as nomal
          set empty-list lput (ranktest) empty-list
          set used-list lput (ranktest) used-list
        ]
        ;allows us to continue to keep track of how many loops we have done
          set test-pos test-pos + 1
      ]


      ;now we map the lists back to each other
      set time-step-costs 0
        set hold-adaptation? false
      ;this sets us up so that the 8th largest b-c starts, then 7th, then ....
      foreach reverse [0 1 2 3 4 5 6 7 8] [ ;this list has to be a list of the total number of rank positions
        [x] -> let rank-search x
        ;get the position value of the needed rank based on the list of final rankings in the positions of the sw segments
        let cb-item-order position rank-search empty-list
        ;using the sw-position value, get the final cost-benefit value
        let cb-item item cb-item-order mbta-benefit-cost-ratio-list
        ;now we can start with the tests to actually implement an adaptation, in order of importance
        ;get adaptation intention of each regioin
        let adapt-intention item cb-item-order mbta-adaptation-intention-list
        ;check existing adaptation
        let neighborhood-adapt item cb-item-order mbta-adaptation-list
        ;get corresponding cost for the planned adaptation
        let cost-test item cb-item-order mbta-planned-adaptation-cost-list
        let total-adapt-cost-region item cb-item-order mbta-total-adaptation-cost-list
        let neigh-permit-delay item cb-item-order mbta-permit-delay-list


        ifelse neighborhood-adapt != adapt-intention [
            ifelse hold-adaptation? = false [
          ;assign plan cost and down payment
          let plan-cost-again item cb-item-order mbta-planned-adaptation-cost-list
          let down-payment 0.10
          ;check plan cost
          ifelse available-budget > plan-cost-again * down-payment [
            ;check permitting
            ifelse neigh-permit-delay >= permitting-delay [
              ;adapt
            set mbta-adaptation-list replace-item cb-item-order mbta-adaptation-list adapt-intention
            set available-budget available-budget - plan-cost-again
            set adaptation-count adaptation-count + 1
            set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list plan-cost-again
            set mbta-total-adaptation-cost-list replace-item cb-item-order mbta-total-adaptation-cost-list plan-cost-again
            set mbta-base-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list plan-cost-again
            set time-step-costs time-step-costs + plan-cost-again
            set mbta-permit-delay-list replace-item cb-item-order mbta-permit-delay-list 0
            set hold-adaptation? false

            ]
            [;neigh-permit-delay < permitting-delay
              set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list 0
              set mbta-permit-delay-list replace-item cb-item-order mbta-permit-delay-list (neigh-permit-delay + 1)
              set hold-adaptation? false
            ]
          ]
          [            ;not enough budget to adapt here
            set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list 0
            set mbta-permit-delay-list replace-item cb-item-order mbta-permit-delay-list (neigh-permit-delay + 1)
            set hold-adaptation? true
             ]
        ]
            [; hold-adaptation? = true
              set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list 0
              set mbta-permit-delay-list replace-item cb-item-order mbta-permit-delay-list (neigh-permit-delay + 1)
              set hold-adaptation? true
            ]
          ]
        [
          ;the proposed adaptation is already in place - no change to adaptation and no new money spent
          set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list 0
            set hold-adaptation? false
      ]
    ]
      ;sum total costs for boston
      set total-adaptation-cost total-adaptation-cost + time-step-costs
      set adaptation-cost time-step-costs
      ]
      [;prioritization is based on EJ communities
      ;empty-list is represents the prioritization order of boston municipalities based on their EJ characteristics
        set hold-adaptation? false
        ;output-print("EJ")
        set empty-list [5 4 6 3 0 7 2 8 1]
      ;now we map the lists back to each other
      set time-step-costs 0
      ;this sets us up so that the 8th largest b-c starts, then 7th, then ....
      foreach [0 1 2 3 4 5 6 7 8] [ ;this list has to be a list of the total number of rank positions

        [x] -> let rank-search x
        ;get the position value of the needed rank based on the list of final rankings in the positions of the sw segments
        let cb-item-order position rank-search empty-list
        ;output-print(cb-item-order)

        ;using the sw-position value, get the final cost-benefit value
        let cb-item item cb-item-order mbta-benefit-cost-ratio-list
        ;now we can start with the tests to actually implement an adaptation, in order of importance
        ;get adaptation intention of each regioin
        let adapt-intention item cb-item-order mbta-adaptation-intention-list
        ;check existing adaptation
        let neighborhood-adapt item cb-item-order mbta-adaptation-list
        ;get corresponding cost for the planned adaptation
        let cost-test item cb-item-order mbta-planned-adaptation-cost-list
        let total-adapt-cost-region item cb-item-order mbta-total-adaptation-cost-list
        let neigh-permit-delay item cb-item-order mbta-permit-delay-list

        ifelse neighborhood-adapt != adapt-intention [
            ifelse hold-adaptation? = false[
          ;assign plan cost and down payment
          let plan-cost-again item cb-item-order mbta-planned-adaptation-cost-list
          let down-payment 0.10
          ;check plan cost
          ifelse available-budget > plan-cost-again * down-payment [
            ;check permitting
            ifelse neigh-permit-delay >= permitting-delay [
              ;adapt
            set mbta-adaptation-list replace-item cb-item-order mbta-adaptation-list adapt-intention
            set available-budget available-budget - plan-cost-again
            set adaptation-count adaptation-count + 1
            set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list plan-cost-again
            set mbta-total-adaptation-cost-list replace-item cb-item-order mbta-total-adaptation-cost-list plan-cost-again
            set mbta-base-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list plan-cost-again
            set time-step-costs time-step-costs + plan-cost-again
            set mbta-permit-delay-list replace-item cb-item-order mbta-permit-delay-list 0
            set hold-adaptation? false

            ]
            [;neigh-permit-delay < permitting-delay
              set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list 0
              set mbta-permit-delay-list replace-item cb-item-order mbta-permit-delay-list (neigh-permit-delay + 1)
              set hold-adaptation? false
            ]
          ]
          [            ;not enough budget to adapt here
              set hold-adaptation? true
            set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list 0
            set mbta-permit-delay-list replace-item cb-item-order mbta-permit-delay-list (neigh-permit-delay + 1)
             ]
        ]
            [;hold-adaptation = true
               set hold-adaptation? true
            set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list 0
            set mbta-permit-delay-list replace-item cb-item-order mbta-permit-delay-list (neigh-permit-delay + 1)
            ]
          ]

        [
          ;the proposed adaptation is already in place - no change to adaptation and no new money spent
          set hold-adaptation? false
          set mbta-adaptation-cost-list replace-item cb-item-order mbta-adaptation-cost-list 0
      ]
          ]
      ;sum total costs for boston
      set total-adaptation-cost total-adaptation-cost + time-step-costs
        set adaptation-cost time-step-costs
      ]
      ]
  ]

  ask private-assets[
    ifelse adaptation != adaptation-intention[
        ifelse permit-delay-count >= permitting-delay[
      ifelse available-budget > planned-adaptation-cost * 0.3 [
      set adaptation adaptation-intention
        set adaptation-count adaptation-count + 1
        set adaptation-cost planned-adaptation-cost
        set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set available-budget available-budget - adaptation-cost
      set permit-delay-count 0
  ]
    [
      ;not enough funding
      set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
      set permit-delay-count permit-delay-count + 1
  ]
        ]
        [;permit-delay-count < permitting-delay
          set adaptation-cost 0
          set total-adaptation-cost total-adaptation-cost + adaptation-cost
          set permit-delay-count permit-delay-count + 1
        ]
        ]
      [set adaptation-cost 0
      set total-adaptation-cost total-adaptation-cost + adaptation-cost
  ]
  ]

end

to set-crs-discount
  ask municipalities[
    if adaptation = "seawall" [
      set crs-discount .30
    ]
  ]
end

to time-step-damage-list
  let tsd-1 boston-time-step-damages-list
  let tsd-2 first [damage-time-step] of municipalities with [name = "south-shore"]
  let tsd-3 first [damage-time-step] of municipalities with [name = "north-shore"]
  let tsd-4 sum([damage-time-step] of property_owners with [dev-region = "boston" and sector = "homeowners"])
  let tsd-5 sum([damage-time-step] of property_owners with [dev-region = "south-shore" and sector = "homeowners"])
  let tsd-6 sum([damage-time-step] of property_owners with [dev-region = "north-shore" and sector = "homeowners"])
  let tsd-7 sum([damage-time-step] of property_owners with [dev-region = "boston" and sector = "commercial"])
  let tsd-8 sum([damage-time-step] of property_owners with [dev-region = "south-shore" and sector = "commercial"])
  let tsd-9 sum([damage-time-step] of property_owners with [dev-region = "north-shore" and sector = "comercial"])
  let tsd-10 first [damage-time-step] of MBTA-agents
  let tsd-11 first [damage-time-step] of private-assets with [name = "food dist"]
  let tsd-12 first [damage-time-step] of private-assets with [name = "BOS-air"]
  set model-time-step-damage-list (list tsd-1 tsd-2 tsd-3 tsd-4 tsd-5 tsd-6 tsd-7 tsd-8 tsd-9 tsd-10 tsd-11 tsd-12)
end

to cumulative-damage-list

  let cds-1 boston-total-damages-list
  let cds-2 first [total-damage] of municipalities with [name = "south-shore"]
  let cds-3 first [total-damage] of municipalities with [name = "north-shore"]
  let cds-4 sum([total-damage] of property_owners with [dev-region = "boston" and sector = "homeowners"])
  let cds-5 sum([total-damage] of property_owners with [dev-region = "south-shore" and sector = "homeowners"])
  let cds-6 sum([total-damage] of property_owners with [dev-region = "north-shore" and sector = "homeowners"])
  let cds-7 sum([total-damage] of property_owners with [dev-region = "boston" and sector = "commercial"])
  let cds-8 sum([total-damage] of property_owners with [dev-region = "south-shore" and sector = "commercial"])
  let cds-9 sum([total-damage] of property_owners with [dev-region = "north-shore" and sector = "comercial"])
  let cds-10 first [total-damage] of MBTA-agents
  let cds-11 first [total-damage] of private-assets with [name = "food dist"]
  let cds-12 first [total-damage] of private-assets with [name = "BOS-air"]
  set model-cumulative-damage-list (list cds-1 cds-2 cds-3 cds-4 cds-5 cds-6 cds-7 cds-8 cds-9 cds-10 cds-11 cds-12)
end


to o_m_costs_track
  let cds-1 boston-o-m-cost-list
  let cds-2 first [o-m-cost] of municipalities with [name = "south-shore"]
  let cds-3 first [o-m-cost] of municipalities with [name = "north-shore"]
  let cds-4 sum([o-m-cost] of property_owners with [dev-region = "boston" and sector = "homeowners"])
  let cds-5 sum([o-m-cost] of property_owners with [dev-region = "south-shore" and sector = "homeowners"])
  let cds-6 sum([o-m-cost] of property_owners with [dev-region = "north-shore" and sector = "homeowners"])
  let cds-7 sum([o-m-cost] of property_owners with [dev-region = "boston" and sector = "commercial"])
  let cds-8 sum([o-m-cost] of property_owners with [dev-region = "south-shore" and sector = "commercial"])
  let cds-9 sum([o-m-cost] of property_owners with [dev-region = "north-shore" and sector = "comercial"])
  let cds-10 first [o-m-cost] of MBTA-agents
  let cds-11 first [o-m-cost] of private-assets with [name = "food dist"]
  let cds-12 first [o-m-cost] of private-assets with [name = "BOS-air"]
  set model_o_m_costs (list cds-1 cds-2 cds-3 cds-4 cds-5 cds-6 cds-7 cds-8 cds-9 cds-10 cds-11 cds-12)
end


to o_m_costs_cum_track
  let cds-1 boston-o-m-cum-cost-list
  let cds-2 first [o-m-cost-cum] of municipalities with [name = "south-shore"]
  let cds-3 first [o-m-cost-cum] of municipalities with [name = "north-shore"]
  let cds-4 sum([o-m-cost-cum] of property_owners with [dev-region = "boston" and sector = "homeowners"])
  let cds-5 sum([o-m-cost-cum] of property_owners with [dev-region = "south-shore" and sector = "homeowners"])
  let cds-6 sum([o-m-cost-cum] of property_owners with [dev-region = "north-shore" and sector = "homeowners"])
  let cds-7 sum([o-m-cost-cum] of property_owners with [dev-region = "boston" and sector = "commercial"])
  let cds-8 sum([o-m-cost-cum] of property_owners with [dev-region = "south-shore" and sector = "commercial"])
  let cds-9 sum([o-m-cost-cum] of property_owners with [dev-region = "north-shore" and sector = "comercial"])
  let cds-10 first [o-m-cost-cum] of MBTA-agents
  let cds-11 first [o-m-cost-cum] of private-assets with [name = "food dist"]
  let cds-12 first [o-m-cost-cum] of private-assets with [name = "BOS-air"]
  set model_o_m_cum_costs (list cds-1 cds-2 cds-3 cds-4 cds-5 cds-6 cds-7 cds-8 cds-9 cds-10 cds-11 cds-12)
end

to track_adaptation
  let cds-1 boston-adaptation-list
  let cds-2 first [adaptation] of municipalities with [name = "south-shore"]
  let cds-3 first [adaptation] of municipalities with [name = "north-shore"]
  let cds-4 [adaptation] of property_owners with [dev-region = "boston" and sector = "homeowners"]
  let cds-5 [adaptation] of property_owners with [dev-region = "south-shore" and sector = "homeowners"]
  let cds-6 [adaptation] of property_owners with [dev-region = "north-shore" and sector = "homeowners"]
  let cds-7 [adaptation] of property_owners with [dev-region = "boston" and sector = "commercial"]
  let cds-8 [adaptation] of property_owners with [dev-region = "south-shore" and sector = "commercial"]
  let cds-9 [adaptation] of property_owners with [dev-region = "north-shore" and sector = "comercial"]
  let cds-10 first [adaptation] of MBTA-agents
  let cds-11 first [adaptation] of private-assets with [name = "food dist"]
  let cds-12 first [adaptation] of private-assets with [name = "BOS-air"]
  set model-adaptation-list (list cds-1 cds-2 cds-3 cds-4 cds-5 cds-6 cds-7 cds-8 cds-9 cds-10 cds-11 cds-12)
end

to track_adapt_costs
  let cds-1 boston-adaptation-costs-list
  let cds-2 first [adaptation-cost] of municipalities with [name = "south-shore"]
  let cds-3 first [adaptation-cost] of municipalities with [name = "north-shore"]
  let cds-4 sum([adaptation-cost] of property_owners with [dev-region = "boston" and sector = "homeowners"])
  let cds-5 sum([adaptation-cost] of property_owners with [dev-region = "south-shore" and sector = "homeowners"])
  let cds-6 sum([adaptation-cost] of property_owners with [dev-region = "north-shore" and sector = "homeowners"])
  let cds-7 sum([adaptation-cost] of property_owners with [dev-region = "boston" and sector = "commercial"])
  let cds-8 sum([adaptation-cost] of property_owners with [dev-region = "south-shore" and sector = "commercial"])
  let cds-9 sum([adaptation-cost] of property_owners with [dev-region = "north-shore" and sector = "comercial"])
  let cds-10 first [adaptation-cost] of MBTA-agents
  let cds-11 first [adaptation-cost] of private-assets with [name = "food dist"]
  let cds-12 first [adaptation-cost] of private-assets with [name = "BOS-air"]
  set model-adaptation-cost-list (list cds-1 cds-2 cds-3 cds-4 cds-5 cds-6 cds-7 cds-8 cds-9 cds-10 cds-11 cds-12)
end

to track_total_adaptation_costs
  let cds-1 boston-total-adaptation-cost-list
  let cds-2 first [total-adaptation-cost] of municipalities with [name = "south-shore"]
  let cds-3 first [total-adaptation-cost] of municipalities with [name = "north-shore"]
  let cds-4 sum([total-adaptation-cost] of property_owners with [dev-region = "boston" and sector = "homeowners"])
  let cds-5 sum([total-adaptation-cost] of property_owners with [dev-region = "south-shore" and sector = "homeowners"])
  let cds-6 sum([total-adaptation-cost] of property_owners with [dev-region = "north-shore" and sector = "homeowners"])
  let cds-7 sum([total-adaptation-cost] of property_owners with [dev-region = "boston" and sector = "commercial"])
  let cds-8 sum([total-adaptation-cost] of property_owners with [dev-region = "south-shore" and sector = "commercial"])
  let cds-9 sum([total-adaptation-cost] of property_owners with [dev-region = "north-shore" and sector = "comercial"])
  let cds-10 first [total-adaptation-cost] of MBTA-agents
  let cds-11 first [total-adaptation-cost] of private-assets with [name = "food dist"]
  let cds-12 first [total-adaptation-cost] of private-assets with [name = "BOS-air"]
  set model-cumulative-adaptation-cost-list (list cds-1 cds-2 cds-3 cds-4 cds-5 cds-6 cds-7 cds-8 cds-9 cds-10 cds-11 cds-12)
end

to track_insurance_payout
end






to metrics
  if model-version = "no adaptation" [
  time-step-damage-list
  cumulative-damage-list
  ]

  if model-version = "no cooperation" [
    track_adaptation
    track_adapt_costs
    time-step-damage-list
    cumulative-damage-list
    track_total_adaptation_costs
  let insurance-payout-total-boston-home sum [insurance-damages-covered-total] of property_owners with [dev-region = "boston" and sector = "homeowners"]
  let insurance-payout-total-ns-home sum [insurance-damages-covered-total] of property_owners with [dev-region = "north-shore" and sector = "homeowners"]
  let insurance-payout-total-ss-home sum [insurance-damages-covered-total] of property_owners with [dev-region = "south-shore" and sector = "homeowners"]
  let insurance-payout-time-step-boston-home sum [insurance-damages-covered] of property_owners with [dev-region = "boston" and sector = "homeowners"]
  let insurance-payout-time-step-ns-home sum [insurance-damages-covered] of property_owners with [dev-region = "north-shore" and sector = "homeowners"]
  let insurance-payout-time-step-ss-home sum [insurance-damages-covered] of property_owners with [dev-region = "south-shore" and sector = "homeowners"]
  let damages-paid-boston-home sum [damages-paid] of property_owners with [dev-region = "boston" and sector = "homeowners"]
  let damages-paid-ns-home sum [damages-paid] of property_owners with [dev-region = "north-shore" and sector = "homeowners"]
  let damages-paid-ss-home sum [damages-paid] of property_owners with [dev-region = "south-shore" and sector = "homeowners"]
  let damages-paid-total-boston-home sum [damages-paid-total] of property_owners with [dev-region = "boston" and sector = "homeowners"]
  let damages-paid-total-ns-home sum [damages-paid-total] of property_owners with [dev-region = "north-shore" and sector = "homeowners"]
  let damages-paid-total-ss-home sum [damages-paid-total] of property_owners with [dev-region = "south-shore" and sector = "homeowners"]
  let insurance-payout-total-boston-com sum [insurance-damages-covered-total] of property_owners with [dev-region = "boston" and sector = "commercial"]
  let insurance-payout-total-ns-com sum [insurance-damages-covered-total] of property_owners with [dev-region = "north-shore" and sector = "commercial"]
  let insurance-payout-total-ss-com sum [insurance-damages-covered-total] of property_owners with [dev-region = "south-shore" and sector = "commercial"]
  let insurance-payout-time-step-boston-com sum [insurance-damages-covered] of property_owners with [dev-region = "boston" and sector = "commercial"]
  let insurance-payout-time-step-ns-com sum [insurance-damages-covered] of property_owners with [dev-region = "north-shore" and sector = "commercial"]
  let insurance-payout-time-step-ss-com sum [insurance-damages-covered] of property_owners with [dev-region = "south-shore" and sector = "commercial"]
  let damages-paid-boston-com sum [damages-paid] of property_owners with [dev-region = "boston" and sector = "commercial"]
  let damages-paid-ns-com sum [damages-paid] of property_owners with [dev-region = "north-shore" and sector = "commercial"]
  let damages-paid-ss-com sum [damages-paid] of property_owners with [dev-region = "south-shore" and sector = "commercial"]
  let damages-paid-total-boston-com sum [damages-paid-total] of property_owners with [dev-region = "boston" and sector = "commercial"]
  let damages-paid-total-ns-com sum [damages-paid-total] of property_owners with [dev-region = "north-shore" and sector = "commercial"]
  let damages-paid-total-ss-com sum [damages-paid-total] of property_owners with [dev-region = "south-shore" and sector = "commercial"]


    set insurance-payout-total-list (list insurance-payout-total-boston-home insurance-payout-total-ns-home insurance-payout-total-ss-home insurance-payout-total-boston-com insurance-payout-total-ns-com insurance-payout-total-ss-com)
  set insurance-payout-list (list insurance-payout-time-step-boston-home insurance-payout-time-step-ns-home insurance-payout-time-step-ss-home insurance-payout-time-step-boston-com insurance-payout-time-step-ns-com insurance-payout-time-step-ss-com)
  set damages-paid-total-list (list damages-paid-total-boston-home damages-paid-total-ns-home damages-paid-total-ss-home damages-paid-total-boston-com damages-paid-total-ns-com damages-paid-total-ss-com)
  set damages-paid-list (list damages-paid-boston-home damages-paid-ns-home damages-paid-ss-home damages-paid-boston-com damages-paid-ns-com damages-paid-ss-com)
  set harbor-coopertative-construct-list 0
  ]

  if model-version = "voluntary cooperation" [
  track_total_adaptation_costs
  time-step-damage-list
  track_adaptation
  track_adapt_costs
  cumulative-damage-list
 let insurance-payout-total-boston-home sum [insurance-damages-covered-total] of property_owners with [dev-region = "boston" and sector = "homeowners"]
  let insurance-payout-total-ns-home sum [insurance-damages-covered-total] of property_owners with [dev-region = "north-shore" and sector = "homeowners"]
  let insurance-payout-total-ss-home sum [insurance-damages-covered-total] of property_owners with [dev-region = "south-shore" and sector = "homeowners"]
  let insurance-payout-time-step-boston-home sum [insurance-damages-covered] of property_owners with [dev-region = "boston" and sector = "homeowners"]
  let insurance-payout-time-step-ns-home sum [insurance-damages-covered] of property_owners with [dev-region = "north-shore" and sector = "homeowners"]
  let insurance-payout-time-step-ss-home sum [insurance-damages-covered] of property_owners with [dev-region = "south-shore" and sector = "homeowners"]
  let damages-paid-boston-home sum [damages-paid] of property_owners with [dev-region = "boston" and sector = "homeowners"]
  let damages-paid-ns-home sum [damages-paid] of property_owners with [dev-region = "north-shore" and sector = "homeowners"]
  let damages-paid-ss-home sum [damages-paid] of property_owners with [dev-region = "south-shore" and sector = "homeowners"]
  let damages-paid-total-boston-home sum [damages-paid-total] of property_owners with [dev-region = "boston" and sector = "homeowners"]
  let damages-paid-total-ns-home sum [damages-paid-total] of property_owners with [dev-region = "north-shore" and sector = "homeowners"]
  let damages-paid-total-ss-home sum [damages-paid-total] of property_owners with [dev-region = "south-shore" and sector = "homeowners"]
  let insurance-payout-total-boston-com sum [insurance-damages-covered-total] of property_owners with [dev-region = "boston" and sector = "commercial"]
  let insurance-payout-total-ns-com sum [insurance-damages-covered-total] of property_owners with [dev-region = "north-shore" and sector = "commercial"]
  let insurance-payout-total-ss-com sum [insurance-damages-covered-total] of property_owners with [dev-region = "south-shore" and sector = "commercial"]
  let insurance-payout-time-step-boston-com sum [insurance-damages-covered] of property_owners with [dev-region = "boston" and sector = "commercial"]
  let insurance-payout-time-step-ns-com sum [insurance-damages-covered] of property_owners with [dev-region = "north-shore" and sector = "commercial"]
  let insurance-payout-time-step-ss-com sum [insurance-damages-covered] of property_owners with [dev-region = "south-shore" and sector = "commercial"]
  let damages-paid-boston-com sum [damages-paid] of property_owners with [dev-region = "boston" and sector = "commercial"]
  let damages-paid-ns-com sum [damages-paid] of property_owners with [dev-region = "north-shore" and sector = "commercial"]
  let damages-paid-ss-com sum [damages-paid] of property_owners with [dev-region = "south-shore" and sector = "commercial"]
  let damages-paid-total-boston-com sum [damages-paid-total] of property_owners with [dev-region = "boston" and sector = "commercial"]
  let damages-paid-total-ns-com sum [damages-paid-total] of property_owners with [dev-region = "north-shore" and sector = "commercial"]
  let damages-paid-total-ss-com sum [damages-paid-total] of property_owners with [dev-region = "south-shore" and sector = "commercial"]

  set insurance-payout-total-list (list insurance-payout-total-boston-home insurance-payout-total-ns-home insurance-payout-total-ss-home insurance-payout-total-boston-com insurance-payout-total-ns-com insurance-payout-total-ss-com)
  set insurance-payout-list (list insurance-payout-time-step-boston-home insurance-payout-time-step-ns-home insurance-payout-time-step-ss-home insurance-payout-time-step-boston-com insurance-payout-time-step-ns-com insurance-payout-time-step-ss-com)
  set damages-paid-total-list (list damages-paid-total-boston-home damages-paid-total-ns-home damages-paid-total-ss-home damages-paid-total-boston-com damages-paid-total-ns-com damages-paid-total-ss-com)
  set damages-paid-list (list damages-paid-boston-home damages-paid-ns-home damages-paid-ss-home damages-paid-boston-com damages-paid-ns-com damages-paid-ss-com)

  let coop-construct-list-home-boston (list [cooperative-construct?] of property_owners with [dev-region = "boston" and sector = "homeowners"])
  let coop-construct-list-home-ns (list [cooperative-construct?] of property_owners with [dev-region = "north-shore" and sector = "homeowners"])
  let coop-construct-list-home-ss (list [cooperative-construct?] of property_owners with [dev-region = "south-shore" and sector = "homeowners"])
  let coop-construct-list-com-boston (list [cooperative-construct?] of property_owners with [dev-region = "boston" and sector = "commercial"])
  let coop-construct-list-com-ns (list [cooperative-construct?] of property_owners with [dev-region = "north-shore" and sector = "commercial"])
  let coop-construct-list-com-ss (list [cooperative-construct?] of property_owners with [dev-region = "south-shore" and sector = "commercial"])
    set harbor-coopertative-construct-list (list boston-coop-construct-list ([cooperative-construct?] of municipalities with [name = "north-shore"]) ([cooperative-construct?] of municipalities with [name = "south-shore"]) coop-construct-list-home-boston coop-construct-list-home-ns coop-construct-list-home-ss coop-construct-list-com-boston coop-construct-list-com-ns coop-construct-list-com-ss mbta-coop-construct-list ([cooperative-construct?] of private-assets with [name = "BOS-air"]) ([cooperative-construct?] of private-assets with [name = "food dist"]))
  ]

  if model-version = "regional authority" [

    ask municipalities with [name = "north-shore"] [
      set adaptation item 0 ra-adaptation-list]
    ask municipalities with [name = "south-shore"] [
      set adaptation item 1 ra-adaptation-list]

    foreach [2 3 4 5 6 7 8 9 10] [
      [x] -> let position-var x
      let sw-test item position-var ra-adaptation-list
      set boston-adaptation-list replace-item (position-var - 2) boston-adaptation-list sw-test]

    ;create model-time-step-damage-list to track damages at each step
  time-step-damage-list

    ;create model-cumulative-damage-step to track damages
  cumulative-damage-list

    ;ra-model-adaptation-list tracks adaptations over time
    ;ra-total-adaptation-cost tracks total adaptation costs
    ;ra-adaptation-cost-list tracks adaptation over time

  let insurance-payout-total-boston-home sum [insurance-damages-covered-total] of property_owners with [dev-region = "boston" and sector = "homeowners"]
  let insurance-payout-total-ns-home sum [insurance-damages-covered-total] of property_owners with [dev-region = "north-shore" and sector = "homeowners"]
  let insurance-payout-total-ss-home sum [insurance-damages-covered-total] of property_owners with [dev-region = "south-shore" and sector = "homeowners"]
  let insurance-payout-time-step-boston-home sum [insurance-damages-covered] of property_owners with [dev-region = "boston" and sector = "homeowners"]
  let insurance-payout-time-step-ns-home sum [insurance-damages-covered] of property_owners with [dev-region = "north-shore" and sector = "homeowners"]
  let insurance-payout-time-step-ss-home sum [insurance-damages-covered] of property_owners with [dev-region = "south-shore" and sector = "homeowners"]
  let damages-paid-boston-home sum [damages-paid] of property_owners with [dev-region = "boston" and sector = "homeowners"]
  let damages-paid-ns-home sum [damages-paid] of property_owners with [dev-region = "north-shore" and sector = "homeowners"]
  let damages-paid-ss-home sum [damages-paid] of property_owners with [dev-region = "south-shore" and sector = "homeowners"]
  let damages-paid-total-boston-home sum [damages-paid-total] of property_owners with [dev-region = "boston" and sector = "homeowners"]
  let damages-paid-total-ns-home sum [damages-paid-total] of property_owners with [dev-region = "north-shore" and sector = "homeowners"]
  let damages-paid-total-ss-home sum [damages-paid-total] of property_owners with [dev-region = "south-shore" and sector = "homeowners"]
  let insurance-payout-total-boston-com sum [insurance-damages-covered-total] of property_owners with [dev-region = "boston" and sector = "commercial"]
  let insurance-payout-total-ns-com sum [insurance-damages-covered-total] of property_owners with [dev-region = "north-shore" and sector = "commercial"]
  let insurance-payout-total-ss-com sum [insurance-damages-covered-total] of property_owners with [dev-region = "south-shore" and sector = "commercial"]
  let insurance-payout-time-step-boston-com sum [insurance-damages-covered] of property_owners with [dev-region = "boston" and sector = "commercial"]
  let insurance-payout-time-step-ns-com sum [insurance-damages-covered] of property_owners with [dev-region = "north-shore" and sector = "commercial"]
  let insurance-payout-time-step-ss-com sum [insurance-damages-covered] of property_owners with [dev-region = "south-shore" and sector = "commercial"]
  let damages-paid-boston-com sum [damages-paid] of property_owners with [dev-region = "boston" and sector = "commercial"]
  let damages-paid-ns-com sum [damages-paid] of property_owners with [dev-region = "north-shore" and sector = "commercial"]
  let damages-paid-ss-com sum [damages-paid] of property_owners with [dev-region = "south-shore" and sector = "commercial"]
  let damages-paid-total-boston-com sum [damages-paid-total] of property_owners with [dev-region = "boston" and sector = "commercial"]
  let damages-paid-total-ns-com sum [damages-paid-total] of property_owners with [dev-region = "north-shore" and sector = "commercial"]
  let damages-paid-total-ss-com sum [damages-paid-total] of property_owners with [dev-region = "south-shore" and sector = "commercial"]


    set insurance-payout-total-list (list insurance-payout-total-boston-home insurance-payout-total-ns-home insurance-payout-total-ss-home insurance-payout-total-boston-com insurance-payout-total-ns-com insurance-payout-total-ss-com)
  set insurance-payout-list (list insurance-payout-time-step-boston-home insurance-payout-time-step-ns-home insurance-payout-time-step-ss-home insurance-payout-time-step-boston-com insurance-payout-time-step-ns-com insurance-payout-time-step-ss-com)
  set damages-paid-total-list (list damages-paid-total-boston-home damages-paid-total-ns-home damages-paid-total-ss-home damages-paid-total-boston-com damages-paid-total-ns-com damages-paid-total-ss-com)
  set damages-paid-list (list damages-paid-boston-home damages-paid-ns-home damages-paid-ss-home damages-paid-boston-com damages-paid-ns-com damages-paid-ss-com)

   ;try to track contribution values - need thirty year damage and thirty year damage sw
    let cds-1 boston-thirty-year-damage-list
    let cds-2 first [thirty_year_damage] of municipalities with [name = "south-shore"]
    let cds-3 first [thirty_year_damage] of municipalities with [name = "north-shore"]
  let cds-4 sum([thirty_year_damage] of property_owners with [dev-region = "boston" and sector = "homeowners"])
  let cds-5 sum([thirty_year_damage] of property_owners with [dev-region = "south-shore" and sector = "homeowners"])
  let cds-6 sum([thirty_year_damage] of property_owners with [dev-region = "north-shore" and sector = "homeowners"])
  let cds-7 sum([thirty_year_damage] of property_owners with [dev-region = "boston" and sector = "commercial"])
  let cds-8 sum([thirty_year_damage] of property_owners with [dev-region = "south-shore" and sector = "commercial"])
  let cds-9 sum([thirty_year_damage] of property_owners with [dev-region = "north-shore" and sector = "comercial"])
  let cds-10 first [thirty_year_damage] of MBTA-agents
  let cds-11 first [thirty_year_damage] of private-assets with [name = "food dist"]
  let cds-12 first [thirty_year_damage] of private-assets with [name = "BOS-air"]
  let exp2 lput cds-2 boston-thirty-year-damage-list
    let exp3 lput cds-3 exp2
    let exp4 lput cds-4 exp3
    let exp5 lput cds-5 exp4
    let exp6 lput cds-6 exp5
    let exp7 lput cds-7 exp6
    let exp8 lput cds-8 exp7
    let exp9 lput cds-9 exp8
    let exp10 lput cds-10 exp9
    let exp11 lput cds-11 exp10
    set model-thirty-year-damage-list lput cds-12 exp11

    let ds-1 boston-thirty-year-damage-sw-list
    let ds-2 first [thirty_year_damage_sw] of municipalities with [name = "south-shore"]
    let ds-3 first [thirty_year_damage_sw] of municipalities with [name = "north-shore"]
  let ds-4 sum([thirty_year_damage_sw] of property_owners with [dev-region = "boston" and sector = "homeowners"])
  let ds-5 sum([thirty_year_damage_sw] of property_owners with [dev-region = "south-shore" and sector = "homeowners"])
  let ds-6 sum([thirty_year_damage_sw] of property_owners with [dev-region = "north-shore" and sector = "homeowners"])
  let ds-7 sum([thirty_year_damage_sw] of property_owners with [dev-region = "boston" and sector = "commercial"])
  let ds-8 sum([thirty_year_damage_sw] of property_owners with [dev-region = "south-shore" and sector = "commercial"])
  let ds-9 sum([thirty_year_damage_sw] of property_owners with [dev-region = "north-shore" and sector = "comercial"])
  let ds-10 first [thirty_year_damage_sw] of MBTA-agents
  let ds-11 first [thirty_year_damage_sw] of private-assets with [name = "food dist"]
  let ds-12 first [thirty_year_damage_sw] of private-assets with [name = "BOS-air"]
  let xp2 lput ds-2 boston-thirty-year-damage-sw-list
    let xp3 lput ds-3 xp2
    let xp4 lput ds-4 xp3
    let xp5 lput ds-5 xp4
    let xp6 lput ds-6 xp5
    let xp7 lput ds-7 xp6
    let xp8 lput ds-8 xp7
    let xp9 lput ds-9 xp8
    let xp10 lput ds-10 xp9
    let xp11 lput ds-11 xp10
    set model-thirty-year-damage-sw-list lput cds-12 xp11

  set test-pos 0
    set ra-relative-damage-avoided [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  foreach model-thirty-year-damage-list [
      [x] -> let val x
      let val_sw item test-pos model-thirty-year-damage-sw-list
      let sw-benefit val - val_sw
      set ra-relative-damage-avoided replace-item test-pos ra-relative-damage-avoided sw-benefit
       ;ra-relative-damage-avoided
  set harbor-coopertative-construct-list 0
    ]

  ]
end

to add_o_m_costs
  if "model-version" != "regional authority" [
  ;;assume o&m = 1%
  ask municipalities[
    ifelse name != "boston" [
      ifelse adaptation = "none" [
        ;no o+m costs
        set o-m-cost 0
      ]
      [;if adaptation = "seawall" [
        let cost-2020-pt-1 coastline * 7500
        set o-m-cost (cost-2020-pt-1 * O_M_proportion)/((1 + discount) ^ (year - 2021))
        set o-m-cost-cum o-m-cost-cum + o-m-cost
    ]
      set available-budget available-budget - o-m-cost
    ]
    [;name = Boston, new process required
      set test-pos 0
      foreach boston-base-adaptation-cost-list[
        [x] -> let adapt-cost-base x
        let o-m-cost-section (adapt-cost-base * O_M_proportion)/((1 + discount) ^ (year - 2021))
        let cum-o-m-cost-section item test-pos boston-o-m-cum-cost-list
        set boston-o-m-cost-list replace-item test-pos boston-o-m-cost-list o-m-cost-section
        set boston-o-m-cum-cost-list replace-item test-pos boston-o-m-cum-cost-list (cum-o-m-cost-section + o-m-cost-section)
        set test-pos test-pos + 1
      ]
      set available-budget available-budget - (sum(boston-o-m-cost-list))
    ]
    ]

  ask private-assets[
    if adaptation = "none"[
      ;no o&m costs
      set o-m-cost 0
    ]
    if adaptation = "on-site-seawall"[
      let cost-2020 ((5300 * perimeter))
      set o-m-cost (cost-2020 * O_M_proportion)/((1 + discount) ^ (year - 2021))
      set o-m-cost-cum o-m-cost-cum + o-m-cost
    ]
    set available-budget available-budget - o-m-cost
  ]


  ask MBTA-agents[
    ifelse mbta-adaptation-method = "all-at-once"[
       if adaptation = "none"[
      ;no o&m costs
      set o-m-cost 0
    ]
    if adaptation = "on-site seawall"[
      ;let cost-2020 6600000000
      let cost-2020 mbta-cost-2020
      set o-m-cost (cost-2020 * O_M_proportion)/((1 + discount) ^ (year - 2021))
      set o-m-cost-cum o-m-cost-cum + o-m-cost
    ]
    set available-budget available-budget - o-m-cost
    ]
    [;mbta-adaptation-method = "segments"
     let total-cost-to-date sum mbta-base-adaptation-cost-list
     set o-m-cost (total-cost-to-date * O_M_proportion)/((1 + discount) ^ (year - 2021))
     set o-m-cost-cum o-m-cost-cum + o-m-cost
     set available-budget available-budget - o-m-cost
    ]
  ]


  ask property_owners[
    if adaptation = "none"[
      ;no o&m costs
      set o-m-cost 0
    ]
    if adaptation = "aquafence"[
      let aquafence-cost-2020  500000
      let o-m-cost-pt-1 (aquafence-cost-2020 * O_M_proportion)/((1 + discount) ^ (year - 2021))

      let inundation (flood-height - elevation)
      ifelse inundation > 0 [
        set deployment-cost 4000]
      [set deployment-cost 0]
      set o-m-cost o-m-cost-pt-1 + (deployment-cost / ((1 + discount) ^ (year - 2021)))
      set o-m-cost-cum o-m-cost-cum + o-m-cost
    ]
    if adaptation = "local seawall"[
      let seawall-cost-2020 ((5300 * perimeter))
      set seawall-cost (seawall-cost-2020 * O_M_proportion)/((1 + discount) ^ (year - 2021))
      set o-m-cost-cum o-m-cost-cum + o-m-cost

    ]
    set available-budget available-budget - o-m-cost
    set adaptation-cost adaptation-cost + o-m-cost
  ]
  ]

  if "model-version" = "regional authority" [
    let total-base-adapt-cost sum(ra-base-adaptation-cost)
    set o-m-cost-ra (total-base-adapt-cost * O_M_proportion)/((1 + discount) ^ (year - 2021))
    set o-m-cost-cum-ra o-m-cost-cum-ra + o-m-cost-ra
  ]




end

to add-discount-budget
  ask municipalities[
    set available-budget (available-budget / (1 + discount))]
  ask private-assets[
    set available-budget (available-budget / (1 + discount))]
  ask property_owners[
    set available-budget (available-budget / (1 + discount))]
  ask MBTA-agents[
    set available-budget (available-budget / (1 + discount))]


end


to test-profile-with-setup-patches
  setup-patches
  setup-agents
  go
end

to test
end



to profile
  setup-patches
  setup-agents
  profiler:start
  repeat 1 [test-profile-with-setup-patches]
  profiler:stop
  csv:to-file "profiler_Data_with-setup-desktop.csv" profiler:data
  profiler:reset
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
711
520
-1
-1
0.5
1
10
1
1
1
0
1
1
1
0
500
0
500
0
0
1
ticks
30.0

BUTTON
17
17
128
50
NIL
setup-patches
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
19
58
124
91
NIL
setup-agents
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
19
96
96
129
go-once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
134
103
197
136
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
23
141
194
186
model-version
model-version
"no cooperation" "voluntary cooperation" "regional authority" "no adaptation"
0

CHOOSER
41
226
179
271
sea-level-rise
sea-level-rise
0 1 3 5 "no trend" "fit trend"
3

PLOT
736
19
1159
205
Time-Step Damage Municipality
Years
Damage
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"NS Mun" 1.0 0 -10873583 true "" "plot first [damage-time-step] of municipalities with [label = \"north-shore\"]"
"SS Mun" 1.0 0 -5298144 true "" "plot first [damage-time-step] of municipalities with [label = \"south-shore\"]"
"Boston Mun" 1.0 0 -2139308 true "" "plot first [damage-time-step] of municipalities with [label = \"boston\"]"
"NS Dev" 1.0 0 -14333415 true "" "plot sum [damage-time-step] of property_owners with [dev-region = \"north-shore\"]"
"SS Dev" 1.0 0 -14439633 true "" "plot sum [damage-time-step] of property_owners with [dev-region = \"south-shore\"]"
"Boston Dev" 1.0 0 -6565750 true "" "plot sum [damage-time-step] of property_owners with [dev-region = \"boston\"]"
"MBTA" 1.0 0 -8630108 true "" "plot first [damage-time-step] of MBTA-agents"
"Bos Logan" 1.0 0 -13791810 true "" "plot first [damage-time-step] of private-assets with [name = \"BOS-air\"]"
"Food Center" 1.0 0 -6759204 true "" "plot first [damage-time-step] of private-assets with [name = \"food dist\"]"

PLOT
4
368
204
518
Flood Height (NAVD88)
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"pen-1" 1.0 0 -14454117 true "" "plot flood-height"

MONITOR
22
315
102
360
NIL
flood-height
17
1
11

OUTPUT
1194
350
1623
470
11

MONITOR
159
535
267
580
MBTA Adaptation
first [adaptation] of MBTA-agents
17
1
11

MONITOR
420
583
522
628
BOS adaptation
first [adaptation] of private-assets with [name = \"BOS-air\"]
17
1
11

MONITOR
138
584
286
629
Food Center Adaptation
first [adaptation] of private-assets with [name = \"food dist\"]
17
1
11

MONITOR
8
584
138
629
NS Mun Adaptation
first [adaptation] of municipalities with [label = \"north-shore\"]
17
1
11

MONITOR
284
583
416
628
SS Mun Adaptation
[adaptation] of municipalities with [label = \"south-shore\"]
17
1
11

CHOOSER
1162
60
1300
105
mun-slr-proj
mun-slr-proj
0 1 3 5
3

MONITOR
8
532
138
577
NS Mun Adapt Intent
first [adaptation-intention] of municipalities with [label = \"north-shore\"]
17
1
11

MONITOR
284
533
413
578
SS Mun Adapt Intent
first [adaptation-intention] of municipalities with [label = \"south-shore\"]
17
1
11

SLIDER
1186
236
1511
269
multiplier_storms_annual_mean
multiplier_storms_annual_mean
1
1.1
1.0
.0005
1
NIL
HORIZONTAL

PLOT
740
390
1165
576
Adaptation Time
NIL
Num Adaptations
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"NS Mun" 1.0 0 -10873583 true "" "plot first [adaptation-count] of municipalities with [label = \"north-shore\"]"
"SS MUN" 1.0 0 -5298144 true "" "plot first [adaptation-count] of municipalities with [label = \"south-shore\"]"
"Boston Mun" 1.0 0 -2139308 true "" "plot first [adaptation-count] of municipalities with [label = \"boston\"]"
"NS Dev" 1.0 0 -14333415 true "" "plot sum [adaptation-count] of property_owners with [dev-region = \"north-shore\"]"
"SS Dev" 1.0 0 -10899396 true "" "plot sum [adaptation-count] of property_owners with [dev-region = \"south-shore\"]"
"Boston Dev" 1.0 0 -6565750 true "" "plot sum [adaptation-count] of property_owners with [dev-region = \"boston\"]"
"MBTA" 1.0 0 -10141563 true "" "plot first [adaptation-count] of MBTA-agents"
"BOS Logan" 1.0 0 -13791810 true "" "plot first [adaptation-count] of private-assets with [name = \"BOS-air\"]"
"Food Center" 1.0 0 -5516827 true "" "plot first [adaptation-count] of private-assets with [name = \"food dist\"]"

PLOT
739
205
1164
393
Cumulative Damage
NIL
$
0.0
10.0
0.0
1.0E10
true
true
"" ""
PENS
"NS Mun" 1.0 0 -10873583 true "" "plot first [total-damage] of municipalities with [label = \"north-shore\"]"
"SS Mun" 1.0 0 -5298144 true "" "plot first [total-damage] of municipalities with [label = \"south-shore\"]"
"Boston Mun" 1.0 0 -2139308 true "" "plot first [total-damage] of municipalities with [label = \"boston\"]"
"NS Dev" 1.0 0 -14333415 true "" "plot sum [total-damage] of property_owners with [dev-region = \"north-shore\"]"
"SS Dev" 1.0 0 -14439633 true "" "plot sum [total-damage] of property_owners with [dev-region = \"south-shore\"]"
"Boston Dev" 1.0 0 -5509967 true "" "plot sum [total-damage] of property_owners with [dev-region = \"boston\"]"
"MBTA" 1.0 0 -8630108 true "" "plot first [total-damage] of MBTA-agents"
"Bos Logan" 1.0 0 -13791810 true "" "plot first [total-damage] of private-assets with [name = \"BOS-air\"]"
"Food Center" 1.0 0 -8275240 true "" "plot first [total-damage] of private-assets with [name = \"food dist\"]"

MONITOR
9
635
138
680
NS Dev Adaptation
[adaptation] of property_owners with [dev-region = \"north-shore\"]
17
1
11

MONITOR
145
634
278
679
Bos Dev Adaptation
[adaptation] of property_owners with [dev-region = \"boston\"]
17
1
11

MONITOR
285
633
414
678
SS Dev Adaptation
[adaptation] of property_owners with [dev-region = \"south-shore\"]
17
1
11

SLIDER
1162
25
1335
58
link-value
link-value
0
1
0.01
.01
1
NIL
HORIZONTAL

CHOOSER
1162
109
1301
154
discount
discount
0.03 0.07 0 0.25
2

PLOT
740
575
1166
763
Adaptation Cost
NIL
USD
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"NS Mun" 1.0 0 -10873583 true "" "plot first [total-adaptation-cost] of municipalities with [label = \"north-shore\"]"
"SS Mun" 1.0 0 -5298144 true "" "plot first [total-adaptation-cost] of municipalities with [label = \"south-shore\"]"
"Boston Mun" 1.0 0 -2139308 true "" "plot sum [boston-total-adaptation-cost-list] of municipalities with [label = \"boston\"]"
"NS Dev" 1.0 0 -14333415 true "" "plot sum [total-adaptation-cost] of property_owners with [dev-region = \"north-shore\"]"
"SS Dev" 1.0 0 -10899396 true "" "plot sum [total-adaptation-cost] of property_owners with [dev-region = \"south-shore\"]"
"Boston Dev" 1.0 0 -4399183 true "" "plot sum [total-adaptation-cost] of property_owners with [dev-region = \"boston\"]"
"MBTA" 1.0 0 -8630108 true "" "plot first [total-adaptation-cost] of MBTA-agents"
"BOS Logan" 1.0 0 -13791810 true "" "plot first [total-adaptation-cost] of private-assets with [name = \"BOS-air\"]"
"Food Center" 1.0 0 -5516827 true "" "plot first [total-adaptation-cost] of private-assets with [name = \"food dist\"]"

BUTTON
34
189
186
222
NIL
setup-behavior-space
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
136
24
202
57
NIL
profile
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
422
533
592
578
Seawall cost boston
first [planned-adaptation-cost] of municipalities with [label = \"boston\"]
17
1
11

MONITOR
596
532
736
577
Available $ Boston
first [available-budget] of municipalities with [label = \"boston\"]
17
1
11

MONITOR
529
587
587
632
NIL
year
17
1
11

BUTTON
135
65
198
98
NIL
test
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
420
634
681
679
NIL
first [adaptation-intention] of MBTA-agents
17
1
11

MONITOR
12
688
506
733
Adaptations Boston Neighborhoods
boston-adaptation-list
17
1
11

MONITOR
13
738
506
783
Adaptation Intention Boston Neighborhoods
boston-adaptation-intention-list
17
1
11

SWITCH
1352
57
1582
90
flood-reaction-property_owners
flood-reaction-property_owners
0
1
-1000

SWITCH
1352
91
1557
124
flood-reaction-municipalities
flood-reaction-municipalities
0
1
-1000

SWITCH
1353
127
1565
160
flood-reaction-private-assets
flood-reaction-private-assets
0
1
-1000

SWITCH
1355
161
1515
194
flood-reaction-mbta
flood-reaction-mbta
0
1
-1000

SWITCH
1352
23
1534
56
vc-linked-damages-dm
vc-linked-damages-dm
1
1
-1000

SLIDER
1196
496
1383
529
foresight-mun-pas-mbta
foresight-mun-pas-mbta
0
50
30.0
1
1
NIL
HORIZONTAL

SLIDER
1196
537
1391
570
foresight-property_owners
foresight-property_owners
0
30
30.0
1
1
NIL
HORIZONTAL

SLIDER
1203
588
1375
621
municipal-sw-height
municipal-sw-height
0
20
15.0
1
1
NIL
HORIZONTAL

MONITOR
1276
641
1516
686
NIL
[premium] of property_owners
17
1
11

MONITOR
1214
640
1272
685
NIL
year
17
1
11

SWITCH
1406
539
1527
572
funding-cap
funding-cap
0
1
-1000

CHOOSER
1166
158
1304
203
storm-surge-method
storm-surge-method
"random" "no extreme" "1 extreme" "2 extreme"
0

SWITCH
1375
284
1533
317
insurance-module?
insurance-module?
0
1
-1000

MONITOR
511
685
776
730
NIL
[mandatory-insurance?] of property_owners
17
1
11

SLIDER
1400
496
1595
529
external-financing-percent
external-financing-percent
0
1
0.3
.1
1
NIL
HORIZONTAL

MONITOR
519
807
1228
852
NIL
ra-adaptation-list
17
1
11

MONITOR
519
758
1225
803
NIL
ra-adaptation-intention-list
17
1
11

SWITCH
1362
199
1510
232
flood-reaction-ra
flood-reaction-ra
0
1
-1000

MONITOR
15
793
118
838
ss ins
[insurance?] of property_owners with [region = \"south-shore\"]
17
1
11

MONITOR
1213
695
1323
740
ns dev mand ins
[mandatory-insurance?] of property_owners with [region = \"north-shore\"]
17
1
11

MONITOR
1332
697
1437
742
ss dev mand ins
[mandatory-insurance?] of property_owners with [region = \"south-shore\"]
17
1
11

MONITOR
1447
694
1560
739
bos dev mand ins
[mandatory-insurance?] of property_owners with [region = \"boston\"]
17
1
11

MONITOR
124
793
248
838
ns ins
[insurance?] of property_owners with [region = \"north-shore\"]
17
1
11

MONITOR
255
793
364
838
bos ins
[insurance?] of property_owners with [region = \"boston\"]
17
1
11

MONITOR
1244
760
1504
805
NIL
[insurance?] of property_owners
17
1
11

MONITOR
1578
644
1653
689
ins policies
count property_owners with [insurance? = True]
17
1
11

TEXTBOX
1519
759
1707
814
insurance looking crazy is because the order of the reporter is constantly changing- it is a static parameter
11
0.0
1

MONITOR
1588
702
1669
747
mand ins pol
count property_owners with [mandatory-insurance? = True]
17
1
11

SLIDER
1523
195
1695
228
planning-horizon-delay
planning-horizon-delay
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
1523
235
1695
268
permitting-delay
permitting-delay
0
20
10.0
1
1
NIL
HORIZONTAL

CHOOSER
1593
33
1732
78
mbta-cost-2020
mbta-cost-2020
6600000000 3300000000
0

CHOOSER
1555
286
1694
331
prioritization-method
prioritization-method
"normal" "EJ"
0

CHOOSER
1410
594
1573
639
mbta-adaptation-method
mbta-adaptation-method
"all-at-once" "segments"
1

MONITOR
1637
354
1877
399
NIL
[total-adaptation-cost] of mbta-agents
17
1
11

MONITOR
1613
493
1720
538
Total adapt cost
sum(model-cumulative-adaptation-cost-list)
17
1
11

CHOOSER
1595
92
1733
137
Method
Method
"normal" "behavior space"
0

SLIDER
19
273
191
306
flood-pattern
flood-pattern
1
200
10.0
1
1
NIL
HORIZONTAL

SLIDER
1598
151
1798
184
permitting-cost-proportion
permitting-cost-proportion
0
1
0.2
.05
1
NIL
HORIZONTAL

SLIDER
1713
199
1885
232
O_M_proportion
O_M_proportion
0
1
0.01
.01
1
NIL
HORIZONTAL

SLIDER
1640
410
1813
443
maintenance-fee
maintenance-fee
0
1
0.1
.1
1
NIL
HORIZONTAL

SLIDER
1585
597
1772
630
reduction-funding-access
reduction-funding-access
0
1
0.5
.5
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

boat
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 33 230 157 182 150 169 151 157 156
Polygon -7500403 true true 149 55 88 143 103 139 111 136 117 139 126 145 130 147 139 147 146 146 149 55

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

bus
false
0
Polygon -7500403 true true 15 206 15 150 15 120 30 105 270 105 285 120 285 135 285 206 270 210 30 210
Rectangle -16777216 true false 36 126 231 159
Line -7500403 false 60 135 60 165
Line -7500403 false 60 120 60 165
Line -7500403 false 90 120 90 165
Line -7500403 false 120 120 120 165
Line -7500403 false 150 120 150 165
Line -7500403 false 180 120 180 165
Line -7500403 false 210 120 210 165
Line -7500403 false 240 135 240 165
Rectangle -16777216 true false 15 174 285 182
Circle -16777216 true false 48 187 42
Rectangle -16777216 true false 240 127 276 205
Circle -16777216 true false 195 187 42
Line -7500403 false 257 120 257 207

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

drop
false
0
Circle -7500403 true true 73 133 152
Polygon -7500403 true true 219 181 205 152 185 120 174 95 163 64 156 37 149 7 147 166
Polygon -7500403 true true 79 182 95 152 115 120 126 95 137 64 144 37 150 6 154 165

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

house two story
false
0
Polygon -7500403 true true 2 180 227 180 152 150 32 150
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 75 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 90 150 135 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Rectangle -7500403 true true 15 180 75 255
Polygon -7500403 true true 60 135 285 135 240 90 105 90
Line -16777216 false 75 135 75 180
Rectangle -16777216 true false 30 195 93 240
Line -16777216 false 60 135 285 135
Line -16777216 false 255 105 285 135
Line -16777216 false 0 180 75 180
Line -7500403 true 60 195 60 240
Line -7500403 true 154 195 154 255

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="future-thinking-exp-slr-1-slrproj-1-ra-mbtacorrect-6-1" repetitions="3" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-adaptation-list</metric>
    <metric>model-adaptation-cost-list</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <metric>model-cumulative-adaptation-cost-list</metric>
    <metric>ra-adaptation-list</metric>
    <metric>ra-total-adaptation-cost-list</metric>
    <metric>ra-adaptation-cost-list</metric>
    <metric>count (developers with [insurance? = True])</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;regional authority&quot;"/>
      <value value="&quot;no cooperation&quot;"/>
      <value value="&quot;voluntary cooperation&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="link-value">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0.03"/>
      <value value="0.07"/>
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vc-linked-damages-dm">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-developers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="voluntary-coop-cost-subsidy">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-developers">
      <value value="30"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0.3"/>
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="0"/>
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="base_runs" repetitions="200" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-adaptation-list</metric>
    <metric>model-adaptation-cost-list</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <metric>model-cumulative-adaptation-cost-list</metric>
    <metric>ra-adaptation-list</metric>
    <metric>ra-total-adaptation-cost-list</metric>
    <metric>ra-adaptation-cost-list</metric>
    <metric>insurance-payout-total-list</metric>
    <metric>insurance-payout-list</metric>
    <metric>damages-paid-total-list</metric>
    <metric>damages-paid-list</metric>
    <metric>[insurance?] of developers with [dev-region = "boston"]</metric>
    <metric>[insurance?] of developers with [dev-region = "north-shore"]</metric>
    <metric>[insurance?] of developers with [dev-region = "south-shore"]</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;no adaptation&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="link-value">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vc-linked-damages-dm">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-developers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="voluntary-coop-cost-subsidy">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-developers">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-method">
      <value value="&quot;all-at-once&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="widespread exps" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-adaptation-list</metric>
    <metric>model-adaptation-cost-list</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <metric>model-cumulative-adaptation-cost-list</metric>
    <metric>ra-adaptation-list</metric>
    <metric>ra-total-adaptation-cost-list</metric>
    <metric>ra-adaptation-cost-list</metric>
    <metric>insurance-payout-total-list</metric>
    <metric>insurance-payout-list</metric>
    <metric>damages-paid-total-list</metric>
    <metric>damages-paid-list</metric>
    <metric>[insurance?] of developers with [dev-region = "boston"]</metric>
    <metric>[insurance?] of developers with [dev-region = "north-shore"]</metric>
    <metric>[insurance?] of developers with [dev-region = "south-shore"]</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;voluntary cooperation&quot;"/>
      <value value="&quot;regional authority&quot;"/>
      <value value="&quot;no cooperation&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0"/>
      <value value="0.07"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vc-linked-damages-dm">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-developers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="voluntary-coop-cost-subsidy">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-developers">
      <value value="30"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0"/>
      <value value="0.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="0"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-strategy">
      <value value="&quot;all-at-once&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="base_runs_big_mbta_test" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-adaptation-list</metric>
    <metric>model-adaptation-cost-list</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <metric>model-cumulative-adaptation-cost-list</metric>
    <metric>ra-adaptation-list</metric>
    <metric>ra-total-adaptation-cost-list</metric>
    <metric>ra-adaptation-cost-list</metric>
    <metric>insurance-payout-total-list</metric>
    <metric>insurance-payout-list</metric>
    <metric>damages-paid-total-list</metric>
    <metric>damages-paid-list</metric>
    <metric>[insurance?] of developers with [dev-region = "boston"]</metric>
    <metric>[insurance?] of developers with [dev-region = "north-shore"]</metric>
    <metric>[insurance?] of developers with [dev-region = "south-shore"]</metric>
    <metric>[total-adaptation-cost] of mbta-agents</metric>
    <metric>mbta-cooperative-adaptation-contribution-list</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;regional authority&quot;"/>
      <value value="&quot;voluntary cooperation&quot;"/>
      <value value="&quot;no cooperation&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="link-value">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vc-linked-damages-dm">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-developers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="voluntary-coop-cost-subsidy">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-developers">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-method">
      <value value="&quot;all-at-once&quot;"/>
      <value value="&quot;segments&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="widespread exps for mbta" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-adaptation-list</metric>
    <metric>model-adaptation-cost-list</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <metric>model-cumulative-adaptation-cost-list</metric>
    <metric>ra-adaptation-list</metric>
    <metric>ra-total-adaptation-cost-list</metric>
    <metric>ra-adaptation-cost-list</metric>
    <metric>insurance-payout-total-list</metric>
    <metric>insurance-payout-list</metric>
    <metric>damages-paid-total-list</metric>
    <metric>damages-paid-list</metric>
    <metric>[insurance?] of developers with [dev-region = "boston"]</metric>
    <metric>[insurance?] of developers with [dev-region = "north-shore"]</metric>
    <metric>[insurance?] of developers with [dev-region = "south-shore"]</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;voluntary cooperation&quot;"/>
      <value value="&quot;no cooperation&quot;"/>
      <value value="&quot;regional authority&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0"/>
      <value value="0.07"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vc-linked-damages-dm">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-developers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="voluntary-coop-cost-subsidy">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-developers">
      <value value="30"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0.2"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="0"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-method">
      <value value="&quot;all-at-once&quot;"/>
      <value value="&quot;segments&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="slr2_fin2_proj1_d1" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-adaptation-list</metric>
    <metric>model-adaptation-cost-list</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <metric>model-cumulative-adaptation-cost-list</metric>
    <metric>ra-adaptation-list</metric>
    <metric>ra-total-adaptation-cost-list</metric>
    <metric>ra-adaptation-cost-list</metric>
    <metric>insurance-payout-total-list</metric>
    <metric>insurance-payout-list</metric>
    <metric>damages-paid-total-list</metric>
    <metric>damages-paid-list</metric>
    <metric>[insurance?] of developers with [dev-region = "boston"]</metric>
    <metric>[insurance?] of developers with [dev-region = "north-shore"]</metric>
    <metric>[insurance?] of developers with [dev-region = "south-shore"]</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;voluntary cooperation&quot;"/>
      <value value="&quot;no cooperation&quot;"/>
      <value value="&quot;regional authority&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="0"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0"/>
      <value value="0.07"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vc-linked-damages-dm">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-developers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="voluntary-coop-cost-subsidy">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-developers">
      <value value="30"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0.2"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="0"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-method">
      <value value="&quot;all-at-once&quot;"/>
      <value value="&quot;segments&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="slr2_fin2_proj2_d1" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-adaptation-list</metric>
    <metric>model-adaptation-cost-list</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <metric>model-cumulative-adaptation-cost-list</metric>
    <metric>ra-adaptation-list</metric>
    <metric>ra-total-adaptation-cost-list</metric>
    <metric>ra-adaptation-cost-list</metric>
    <metric>insurance-payout-total-list</metric>
    <metric>insurance-payout-list</metric>
    <metric>damages-paid-total-list</metric>
    <metric>damages-paid-list</metric>
    <metric>[insurance?] of developers with [dev-region = "boston"]</metric>
    <metric>[insurance?] of developers with [dev-region = "north-shore"]</metric>
    <metric>[insurance?] of developers with [dev-region = "south-shore"]</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;voluntary cooperation&quot;"/>
      <value value="&quot;no cooperation&quot;"/>
      <value value="&quot;regional authority&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="0"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="0"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0"/>
      <value value="0.07"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vc-linked-damages-dm">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-developers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="voluntary-coop-cost-subsidy">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-developers">
      <value value="30"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0.2"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="0"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-method">
      <value value="&quot;all-at-once&quot;"/>
      <value value="&quot;segments&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="slr2_fin1_proj2_d1" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-adaptation-list</metric>
    <metric>model-adaptation-cost-list</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <metric>model-cumulative-adaptation-cost-list</metric>
    <metric>ra-adaptation-list</metric>
    <metric>ra-total-adaptation-cost-list</metric>
    <metric>ra-adaptation-cost-list</metric>
    <metric>insurance-payout-total-list</metric>
    <metric>insurance-payout-list</metric>
    <metric>damages-paid-total-list</metric>
    <metric>damages-paid-list</metric>
    <metric>[insurance?] of developers with [dev-region = "boston"]</metric>
    <metric>[insurance?] of developers with [dev-region = "north-shore"]</metric>
    <metric>[insurance?] of developers with [dev-region = "south-shore"]</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;voluntary cooperation&quot;"/>
      <value value="&quot;no cooperation&quot;"/>
      <value value="&quot;regional authority&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="0"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="0"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0"/>
      <value value="0.07"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vc-linked-damages-dm">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-developers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="voluntary-coop-cost-subsidy">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-developers">
      <value value="30"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0"/>
      <value value="0.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="0"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-method">
      <value value="&quot;all-at-once&quot;"/>
      <value value="&quot;segments&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="EJ_VC_RA" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-adaptation-list</metric>
    <metric>model-adaptation-cost-list</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <metric>model-cumulative-adaptation-cost-list</metric>
    <metric>ra-adaptation-list</metric>
    <metric>ra-total-adaptation-cost-list</metric>
    <metric>ra-adaptation-cost-list</metric>
    <metric>insurance-payout-total-list</metric>
    <metric>insurance-payout-list</metric>
    <metric>damages-paid-total-list</metric>
    <metric>damages-paid-list</metric>
    <metric>[insurance?] of developers with [dev-region = "boston"]</metric>
    <metric>[insurance?] of developers with [dev-region = "north-shore"]</metric>
    <metric>[insurance?] of developers with [dev-region = "south-shore"]</metric>
    <metric>[total-adaptation-cost] of mbta-agents</metric>
    <metric>mbta-cooperative-adaptation-contribution-list</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;voluntary cooperation&quot;"/>
      <value value="&quot;regional authority&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="link-value">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vc-linked-damages-dm">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-developers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="voluntary-coop-cost-subsidy">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-developers">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;EJ&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-method">
      <value value="&quot;all-at-once&quot;"/>
      <value value="&quot;segments&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="example_damages_each_agent_no_Adapt" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>first [damage-time-step] of municipalities with [name = "north-shore"]</metric>
    <metric>first [damage-time-step] of municipalities with [name = "south-shore"]</metric>
    <metric>first [damage-time-step] of municipalities with [name = "boston"]</metric>
    <metric>first [damage-time-step] of mbta-agents</metric>
    <metric>first [damage-time-step] of private-assets with [name = "food dist"]</metric>
    <metric>first [damage-time-step] of private-assets with [name = "BOS-air"]</metric>
    <metric>sum [damage-time-step] of developers with [dev-region = "boston"]</metric>
    <metric>sum [damage-time-step] of developers with [dev-region = "north-shore"]</metric>
    <metric>sum [damage-time-step] of developers with [dev-region = "south-shore"]</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;no adaptation&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="1"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="link-value">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vc-linked-damages-dm">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-developers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="voluntary-coop-cost-subsidy">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-developers">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-method">
      <value value="&quot;all-at-once&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Method">
      <value value="&quot;behavior space&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="flood-pattern" first="1" step="1" last="15"/>
  </experiment>
  <experiment name="Base_runs_for_paper_ra" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-adaptation-list</metric>
    <metric>model-adaptation-cost-list</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <metric>model-cumulative-adaptation-cost-list</metric>
    <metric>ra-adaptation-list</metric>
    <metric>ra-total-adaptation-cost-list</metric>
    <metric>ra-adaptation-cost-list</metric>
    <metric>insurance-payout-total-list</metric>
    <metric>insurance-payout-list</metric>
    <metric>damages-paid-total-list</metric>
    <metric>damages-paid-list</metric>
    <metric>[insurance?] of property_owners with [dev-region = "boston"]</metric>
    <metric>[insurance?] of property_owners with [dev-region = "north-shore"]</metric>
    <metric>[insurance?] of property_owners with [dev-region = "south-shore"]</metric>
    <metric>[total-adaptation-cost] of mbta-agents</metric>
    <metric>mbta-cooperative-adaptation-contribution-list</metric>
    <metric>mbta-adaptation-list</metric>
    <metric>model_o_m_costs</metric>
    <metric>model_o_m_cum_costs</metric>
    <metric>o-m-cost-ra</metric>
    <metric>o-m-cost-cum-ra</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;no cooperation&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="link-value">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-property_owners">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-property_owners">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-method">
      <value value="&quot;segments&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Method">
      <value value="&quot;behavior space&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="flood-pattern" first="1" step="1" last="200"/>
    <enumeratedValueSet variable="reduction-funding-access">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-cost-proportion">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-cost-2020">
      <value value="6600000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="O_M_proportion">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maintenance-fee">
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Base_runs_for_paper_na" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;no adaptation&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="link-value">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-property_owners">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-property_owners">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-method">
      <value value="&quot;segments&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Method">
      <value value="&quot;behavior space&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="flood-pattern" first="1" step="1" last="200"/>
    <enumeratedValueSet variable="reduction-funding-access">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-cost-proportion">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-cost-2020">
      <value value="6600000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="O_M_proportion">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="wide_runs_for_paper_ra_v1" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-adaptation-list</metric>
    <metric>model-adaptation-cost-list</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <metric>model-cumulative-adaptation-cost-list</metric>
    <metric>ra-adaptation-list</metric>
    <metric>ra-total-adaptation-cost-list</metric>
    <metric>ra-adaptation-cost-list</metric>
    <metric>insurance-payout-total-list</metric>
    <metric>insurance-payout-list</metric>
    <metric>damages-paid-total-list</metric>
    <metric>damages-paid-list</metric>
    <metric>[insurance?] of property_owners with [dev-region = "boston"]</metric>
    <metric>[insurance?] of property_owners with [dev-region = "north-shore"]</metric>
    <metric>[insurance?] of property_owners with [dev-region = "south-shore"]</metric>
    <metric>[total-adaptation-cost] of mbta-agents</metric>
    <metric>mbta-cooperative-adaptation-contribution-list</metric>
    <metric>mbta-adaptation-list</metric>
    <metric>model_o_m_costs</metric>
    <metric>model_o_m_cum_costs</metric>
    <metric>o-m-cost-ra</metric>
    <metric>o-m-cost-cum-ra</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;regional authority&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="link-value">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0.03"/>
      <value value="0.07"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-property_owners">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-property_owners">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0.3"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-method">
      <value value="&quot;segments&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Method">
      <value value="&quot;behavior space&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="flood-pattern" first="1" step="1" last="10"/>
    <enumeratedValueSet variable="reduction-funding-access">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-cost-proportion">
      <value value="0.1"/>
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-cost-2020">
      <value value="6600000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="O_M_proportion">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maintenance-fee">
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="ra_no_main" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-adaptation-list</metric>
    <metric>model-adaptation-cost-list</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <metric>model-cumulative-adaptation-cost-list</metric>
    <metric>ra-adaptation-list</metric>
    <metric>ra-total-adaptation-cost-list</metric>
    <metric>ra-adaptation-cost-list</metric>
    <metric>insurance-payout-total-list</metric>
    <metric>insurance-payout-list</metric>
    <metric>damages-paid-total-list</metric>
    <metric>damages-paid-list</metric>
    <metric>[insurance?] of property_owners with [dev-region = "boston"]</metric>
    <metric>[insurance?] of property_owners with [dev-region = "north-shore"]</metric>
    <metric>[insurance?] of property_owners with [dev-region = "south-shore"]</metric>
    <metric>[total-adaptation-cost] of mbta-agents</metric>
    <metric>mbta-cooperative-adaptation-contribution-list</metric>
    <metric>mbta-adaptation-list</metric>
    <metric>model_o_m_costs</metric>
    <metric>model_o_m_cum_costs</metric>
    <metric>o-m-cost-ra</metric>
    <metric>o-m-cost-cum-ra</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;regional authority&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="link-value">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0.03"/>
      <value value="0.07"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-property_owners">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-property_owners">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0.3"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-method">
      <value value="&quot;segments&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Method">
      <value value="&quot;behavior space&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="flood-pattern" first="1" step="1" last="10"/>
    <enumeratedValueSet variable="reduction-funding-access">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-cost-proportion">
      <value value="0.1"/>
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-cost-2020">
      <value value="6600000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="O_M_proportion">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maintenance-fee">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="TREY RUN THIS" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-adaptation-list</metric>
    <metric>model-adaptation-cost-list</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <metric>model-cumulative-adaptation-cost-list</metric>
    <metric>ra-adaptation-list</metric>
    <metric>ra-total-adaptation-cost-list</metric>
    <metric>ra-adaptation-cost-list</metric>
    <metric>insurance-payout-total-list</metric>
    <metric>insurance-payout-list</metric>
    <metric>damages-paid-total-list</metric>
    <metric>damages-paid-list</metric>
    <metric>[insurance?] of property_owners with [dev-region = "boston"]</metric>
    <metric>[insurance?] of property_owners with [dev-region = "north-shore"]</metric>
    <metric>[insurance?] of property_owners with [dev-region = "south-shore"]</metric>
    <metric>[total-adaptation-cost] of mbta-agents</metric>
    <metric>mbta-cooperative-adaptation-contribution-list</metric>
    <metric>mbta-adaptation-list</metric>
    <metric>model_o_m_costs</metric>
    <metric>model_o_m_cum_costs</metric>
    <metric>o-m-cost-ra</metric>
    <metric>o-m-cost-cum-ra</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;regional authority&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="link-value">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0.03"/>
      <value value="0.07"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-property_owners">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-property_owners">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0.3"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-method">
      <value value="&quot;segments&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Method">
      <value value="&quot;behavior space&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="flood-pattern" first="1" step="1" last="10"/>
    <enumeratedValueSet variable="reduction-funding-access">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-cost-proportion">
      <value value="0.1"/>
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-cost-2020">
      <value value="6600000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="O_M_proportion">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maintenance-fee">
      <value value="0"/>
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test_ss_adaptation" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-adaptation-list</metric>
    <metric>model-adaptation-cost-list</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <metric>model-cumulative-adaptation-cost-list</metric>
    <metric>ra-adaptation-list</metric>
    <metric>ra-total-adaptation-cost-list</metric>
    <metric>ra-adaptation-cost-list</metric>
    <metric>insurance-payout-total-list</metric>
    <metric>insurance-payout-list</metric>
    <metric>damages-paid-total-list</metric>
    <metric>damages-paid-list</metric>
    <metric>[insurance?] of property_owners with [dev-region = "boston"]</metric>
    <metric>[insurance?] of property_owners with [dev-region = "north-shore"]</metric>
    <metric>[insurance?] of property_owners with [dev-region = "south-shore"]</metric>
    <metric>[total-adaptation-cost] of mbta-agents</metric>
    <metric>mbta-cooperative-adaptation-contribution-list</metric>
    <metric>mbta-adaptation-list</metric>
    <metric>model_o_m_costs</metric>
    <metric>model_o_m_cum_costs</metric>
    <metric>o-m-cost-ra</metric>
    <metric>o-m-cost-cum-ra</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;no adaptation&quot;"/>
      <value value="&quot;no cooperation&quot;"/>
      <value value="&quot;voluntary cooperation&quot;"/>
      <value value="&quot;regional authority&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="link-value">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-property_owners">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-property_owners">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-method">
      <value value="&quot;segments&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Method">
      <value value="&quot;behavior space&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="flood-pattern" first="1" step="1" last="2"/>
    <enumeratedValueSet variable="reduction-funding-access">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-cost-proportion">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-cost-2020">
      <value value="6600000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="O_M_proportion">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maintenance-fee">
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="coalition formation tracking" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-adaptation-list</metric>
    <metric>model-adaptation-cost-list</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <metric>model-cumulative-adaptation-cost-list</metric>
    <metric>ra-adaptation-list</metric>
    <metric>ra-total-adaptation-cost-list</metric>
    <metric>ra-adaptation-cost-list</metric>
    <metric>insurance-payout-total-list</metric>
    <metric>insurance-payout-list</metric>
    <metric>damages-paid-total-list</metric>
    <metric>damages-paid-list</metric>
    <metric>[insurance?] of property_owners with [dev-region = "boston"]</metric>
    <metric>[insurance?] of property_owners with [dev-region = "north-shore"]</metric>
    <metric>[insurance?] of property_owners with [dev-region = "south-shore"]</metric>
    <metric>[total-adaptation-cost] of mbta-agents</metric>
    <metric>mbta-cooperative-adaptation-contribution-list</metric>
    <metric>mbta-adaptation-list</metric>
    <metric>model_o_m_costs</metric>
    <metric>model_o_m_cum_costs</metric>
    <metric>o-m-cost-ra</metric>
    <metric>o-m-cost-cum-ra</metric>
    <metric>harbor-coopertative-construct-list</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;voluntary cooperation&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="link-value">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-property_owners">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-property_owners">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0.3"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-method">
      <value value="&quot;segments&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Method">
      <value value="&quot;behavior space&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="flood-pattern" first="1" step="1" last="5"/>
    <enumeratedValueSet variable="reduction-funding-access">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-cost-proportion">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-cost-2020">
      <value value="6600000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="O_M_proportion">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maintenance-fee">
      <value value="0"/>
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Base_runs_subset_fixed_mbta_discount" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup-patches
setup-python
setup-agents</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>year</metric>
    <metric>flood-height</metric>
    <metric>model-adaptation-list</metric>
    <metric>model-adaptation-cost-list</metric>
    <metric>model-time-step-damage-list</metric>
    <metric>model-cumulative-damage-list</metric>
    <metric>model-cumulative-adaptation-cost-list</metric>
    <metric>ra-adaptation-list</metric>
    <metric>ra-total-adaptation-cost-list</metric>
    <metric>ra-adaptation-cost-list</metric>
    <metric>insurance-payout-total-list</metric>
    <metric>insurance-payout-list</metric>
    <metric>damages-paid-total-list</metric>
    <metric>damages-paid-list</metric>
    <metric>[insurance?] of property_owners with [dev-region = "boston"]</metric>
    <metric>[insurance?] of property_owners with [dev-region = "north-shore"]</metric>
    <metric>[insurance?] of property_owners with [dev-region = "south-shore"]</metric>
    <metric>[total-adaptation-cost] of mbta-agents</metric>
    <metric>mbta-cooperative-adaptation-contribution-list</metric>
    <metric>mbta-adaptation-list</metric>
    <metric>model_o_m_costs</metric>
    <metric>model_o_m_cum_costs</metric>
    <metric>o-m-cost-ra</metric>
    <metric>o-m-cost-cum-ra</metric>
    <enumeratedValueSet variable="model-version">
      <value value="&quot;no cooperation&quot;"/>
      <value value="&quot;voluntary cooperation&quot;"/>
      <value value="&quot;regional authority&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sea-level-rise">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="link-value">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mun-slr-proj">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="storm-surge-method">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-property_owners">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-municipalities">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-private-assets">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-mbta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="flood-reaction-ra">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="multiplier_storms_annual_mean">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="insurance-module?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-mun-pas-mbta">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foresight-property_owners">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="municipal-sw-height">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-financing-percent">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-cap">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritization-method">
      <value value="&quot;normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-adaptation-method">
      <value value="&quot;segments&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="planning-horizon-delay">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-delay">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Method">
      <value value="&quot;behavior space&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="flood-pattern" first="1" step="1" last="50"/>
    <enumeratedValueSet variable="reduction-funding-access">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="permitting-cost-proportion">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mbta-cost-2020">
      <value value="6600000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="O_M_proportion">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maintenance-fee">
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
