
IF NOT EXISTS(SELECT * FROM sys.sysusers WHERE [name] = '[edc2019-common]')
    EXEC('CREATE USER [edc2019-common] FROM EXTERNAL PROVIDER')


IF NOT EXISTS(SELECT * FROM sys.sysusers WHERE [name] = '[omnia - edc2019]')
    EXEC('CREATE USER [omnia - edc2019] FROM EXTERNAL PROVIDER')

GRANT SELECT, UPDATE, INSERT, DELETE ON SCHEMA::dbo TO [edc2019-common]
GO

GRANT SELECT, UPDATE, INSERT, DELETE ON SCHEMA::dbo TO [omnia - edc2019]
GO

IF NOT EXISTS(SELECT * FROM sys.tables WHERE [name] = 'Wellbore')
BEGIN
    CREATE TABLE [dbo].[Wellbore](
        [wlbWellboreName] [nvarchar](13) NOT NULL,
        [wlbWell] [nvarchar](10) NOT NULL,
        [wlbDrillingOperator] [nvarchar](47) NOT NULL,
        [wlbProductionLicence] [nvarchar](6) NOT NULL,
        [wlbPurpose] [nvarchar](9) NOT NULL,
        [wlbStatus] [nvarchar](21) NULL,
        [wlbContent] [nvarchar](18) NULL,
        [wlbWellType] [nvarchar](11) NOT NULL,
        [wlbSubSea] [nvarchar](2) NOT NULL,
        [wlbEntryDate] [varchar](10) NULL,
        [wlbCompletionDate] [varchar](10) NULL,
        [wlbField] [nvarchar](16) NULL,
        [wlbDrillPermit] [nvarchar](7) NOT NULL,
        [wlbDiscovery] [nvarchar](28) NULL,
        [wlbDiscoveryWellbore] [nvarchar](3) NOT NULL,
        [wlbBottomHoleTemperature] [nvarchar](500) NULL,
        [wlbSeismicLocation] [nvarchar](94) NULL,
        [wlbMaxInclation] [nvarchar](500) NULL,
        [wlbKellyBushElevation] [nvarchar](500) NOT NULL,
        [wlbFinalVerticalDepth] [nvarchar](500) NULL,
        [wlbTotalDepth] [nvarchar](500) NOT NULL,
        [wlbWaterDepth] [nvarchar](500) NOT NULL,
        [wlbKickOffPoint] [nvarchar](500) NULL,
        [wlbAgeAtTd] [nvarchar](20) NULL,
        [wlbFormationAtTd] [nvarchar](20) NULL,
        [wlbMainArea] [nvarchar](13) NOT NULL,
        [wlbDrillingFacility] [nvarchar](22) NULL,
        [wlbFacilityTypeDrilling] [nvarchar](16) NULL,
        [wlbDrillingFacilityFixedOrMoveable] [nvarchar](8) NULL,
        [wlbLicensingActivity] [nvarchar](34) NOT NULL,
        [wlbMultilateral] [nvarchar](2) NOT NULL,
        [wlbPurposePlanned] [nvarchar](9) NULL,
        [wlbEntryYear] [nvarchar](500) NOT NULL,
        [wlbCompletionYear] [nvarchar](500) NOT NULL,
        [wlbReclassFromWellbore] [nvarchar](14) NULL,
        [wlbReentryExplorationActivity] [nvarchar](25) NULL,
        [wlbPlotSymbol] [nvarchar](500) NOT NULL,
        [wlbFormationWithHc1] [nvarchar](20) NULL,
        [wlbAgeWithHc1] [nvarchar](17) NULL,
        [wlbFormationWithHc2] [nvarchar](19) NULL,
        [wlbAgeWithHc2] [nvarchar](17) NULL,
        [wlbFormationWithHc3] [nvarchar](18) NULL,
        [wlbAgeWithHc3] [nvarchar](17) NULL,
        [wlbDrillingDays] [nvarchar](500) NOT NULL,
        [wlbReentry] [nvarchar](3) NOT NULL,
        [wlbGeodeticDatum] [nvarchar](4) NULL,
        [wlbNsDeg] [nvarchar](500) NOT NULL,
        [wlbNsMin] [nvarchar](500) NOT NULL,
        [wlbNsSec] [nvarchar](500) NOT NULL,
        [wlbNsCode] [nvarchar](1) NOT NULL,
        [wlbEwDeg] [nvarchar](500) NOT NULL,
        [wlbEwMin] [nvarchar](500) NOT NULL,
        [wlbEwSec] [nvarchar](500) NOT NULL,
        [wlbEwCode] [nvarchar](1) NOT NULL,
        [wlbNsDecDeg] [nvarchar](500) NOT NULL,
        [wlbEwDesDeg] [nvarchar](500) NOT NULL,
        [wlbNsUtm] [nvarchar](500) NOT NULL,
        [wlbEwUtm] [nvarchar](500) NOT NULL,
        [wlbUtmZone] [nvarchar](500) NOT NULL,
        [wlbNamePart1] [nvarchar](500) NOT NULL,
        [wlbNamePart2] [nvarchar](500) NOT NULL,
        [wlbNamePart3] [nvarchar](30) NULL,
        [wlbNamePart4] [nvarchar](500) NOT NULL,
        [wlbNamePart5] [nvarchar](2) NULL,
        [wlbNamePart6] [nvarchar](30) NULL,
        [wlbPressReleaseUrl] [nvarchar](153) NULL,
        [wlbFactPageUrl] [nvarchar](100) NOT NULL,
        [wlbFactMapUrl] [nvarchar](82) NOT NULL,
        [wlbDiskosWellboreType] [nvarchar](9) NOT NULL,
        [wlbDiskosWellboreParent] [nvarchar](12) NULL,
        [wlbWdssQcDate] [varchar](10) NULL,
        [wlbReleasedDate] [varchar](10) NULL,
        [wlbNpdidWellbore] [nvarchar](500) NOT NULL,
        [dscNpdidDiscovery] [nvarchar](500) NULL,
        [fldNpdidField] [nvarchar](500) NULL,
        [fclNpdidFacilityDrilling] [nvarchar](500) NULL,
        [wlbNpdidWellboreReclass] [nvarchar](500) NOT NULL,
        [prlNpdidProductionLicence] [nvarchar](500) NOT NULL,
        [wlbDateUpdated] [varchar](10) NOT NULL,
        [wlbDateUpdatedMax] [varchar](10) NOT NULL,
        [datesyncNPD] [varchar](10) NOT NULL
    )
END
GO