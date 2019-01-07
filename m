Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10D7C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 02:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5881520859
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 02:27:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=Sony.onmicrosoft.com header.i=@Sony.onmicrosoft.com header.b="GZdVVDic"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfAGC1H (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 6 Jan 2019 21:27:07 -0500
Received: from mail-eopbgr740107.outbound.protection.outlook.com ([40.107.74.107]:12422
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726180AbfAGC1G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 6 Jan 2019 21:27:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Sony.onmicrosoft.com;
 s=selector1-Sony-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vchjiN6cKELd4TY3qb8LRBxQmjbV+0c4Yvas7x3uTFQ=;
 b=GZdVVDicThziShOOCJs3f1IlhCdj9U0XcQ1yfk8/1USfrVYF7POskfbGyImw2yTEUvzD85p8nlsf8GoozWquO0H+M+kSk1LP8UYeePus0rdjH1fj8o92KZsx2ixwaMjHMBj4M4ANP+tNphHgZveBSR5fOuV1UW29FxikjvXvZTA=
Received: from CY4PR13CA0040.namprd13.prod.outlook.com (2603:10b6:903:99::26)
 by DM5PR13MB1420.namprd13.prod.outlook.com (2603:10b6:3:123::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1516.4; Mon, 7 Jan
 2019 02:25:10 +0000
Received: from SN1NAM02FT036.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::200) by CY4PR13CA0040.outlook.office365.com
 (2603:10b6:903:99::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1516.4 via Frontend
 Transport; Mon, 7 Jan 2019 02:25:10 +0000
Authentication-Results: spf=pass (sender IP is 117.103.190.42)
 smtp.mailfrom=sony.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=sony.com;
Received-SPF: Pass (protection.outlook.com: domain of sony.com designates
 117.103.190.42 as permitted sender) receiver=protection.outlook.com;
 client-ip=117.103.190.42; helo=jp.sony.com;
Received: from jp.sony.com (117.103.190.42) by
 SN1NAM02FT036.mail.protection.outlook.com (10.152.72.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1446.11 via Frontend Transport; Mon, 7 Jan 2019 02:25:08 +0000
Received: from JPYOKXHT103.jp.sony.com (117.103.191.50) by
 JPYOKXEG102.jp.sony.com (117.103.190.42) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 7 Jan 2019 02:25:03 +0000
Received: from JPYOKXMS113.jp.sony.com ([169.254.3.191]) by
 JPYOKXHT103.jp.sony.com ([117.103.191.50]) with mapi id 14.03.0415.000; Mon,
 7 Jan 2019 02:25:03 +0000
From:   <Yasunari.Takiguchi@sony.com>
To:     <colin.king@canonical.com>, <mchehab@kernel.org>,
        <linux-media@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Yasunari.Takiguchi@sony.com>
Subject: RE: [PATCH][next] media: cxd2880-spi: fix two memory leaks of
 dvb_spi
Thread-Topic: [PATCH][next] media: cxd2880-spi: fix two memory leaks of
 dvb_spi
Thread-Index: AQHUmgBxia1KcEEqKE69KZVLIYnEv6WjKxRg
Date:   Mon, 7 Jan 2019 02:25:03 +0000
Message-ID: <02699364973B424C83A42A84B04FDA850B34D9CB@JPYOKXMS113.jp.sony.com>
References: <20181222141226.15775-1-colin.king@canonical.com>
In-Reply-To: <20181222141226.15775-1-colin.king@canonical.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:cf8:1:aec:0:dddd:19e1:c008]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:117.103.190.42;IPV:NLI;CTRY:JP;EFV:NLI;SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(346002)(136003)(2980300002)(13464003)(199004)(189003)(106002)(47776003)(316002)(2201001)(107886003)(4326008)(110136005)(6246003)(2486003)(23676004)(54906003)(7696005)(106466001)(356004)(2906002)(50466002)(2876002)(5660300001)(76176011)(26005)(8936002)(186003)(53546011)(86152003)(33656002)(426003)(336012)(446003)(55016002)(11346002)(436003)(476003)(126002)(102836004)(77096007)(55846006)(486006)(8676002)(246002)(72206003)(6116002)(7736002)(86362001)(305945005)(229853002)(7636002)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR13MB1420;H:jp.sony.com;FPR:;SPF:Pass;LANG:en;PTR:jpyokxeg102.jp.sony.com;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;SN1NAM02FT036;1:MqTUVot7SIeDv6ZPtfuykxYsyHDulbJyUcwa2/El2HL4N0UJ7g6WNpn5tTZTnIwqSrmD44xAKLvBunJJ6+RIyRip6Q2Tn1PE/c4y8Bap7Xqos8NNZPBpZ/C1gdqw6hGy
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4398174-2f80-4b71-f3cb-08d674475927
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4608076)(4709027)(2017052603328)(7193020);SRVR:DM5PR13MB1420;
X-Microsoft-Exchange-Diagnostics: 1;DM5PR13MB1420;3:MHwLEhlIqZSr6YUNUS1cAlqP6pvPZjMzwFaY7dRcw44WdbyZ7etgeZgvCux6q0qrvqWO/wgKiWRQpRQUsLTXV7VPg7zu9O5CEpKsJF3hNifkpBWBJ3336ST9Xrcs56xjTBGzOg3v/YtbVP03fXhFv4TUR7p9l4eTD/qvNQXw3po4NCQHEoR2j7fQVgNvupfme5zW+dmA+24evNei0TY101C4edbJGA9/HAhf1srh3gkK0AOPNsNENg/HYwFQ+KkTTapkAFgUbGqM9WMzhvsEfWyH1g1gGqV7rBKkbkPPZHtt3QJADDggJL7gBi6cXPuSdi9sRJTr7VBNMQJO2wPADQpCkZIJ/L+piS1wNAvGl8XCjUivvX3eLJRy2r9D1FI6;25:vCXPaC+xNRiDuKZwhLqOH3XrgoRo0/H9vsN6J5TvlC2/mGLu868eT/qoT0UmWLESqcfXv8fLOup9kfZ/gk0abEJyrfLIxtR5kbTk6vaMHrqBUcNqgYXVeH7G5kWUVzrPNwQRf49DLiEqSUP7C7TKBHZlhDIUdkl3KKPGYjdVl5MOKzWLV8ZFrukLbfMQI1s6LTido06DwPSIPusnfsVDGIjybiPtfeXILA6/cLytA1wR3NXxUG5J/Rr4wJGffGQPKBXJSj2zG1aI1XhjHHKEzN+nO2WZ0MV6n3HOp8BpPovo8z0PQHTHtSW0uKyNPn67wLHN/4R/ZXBsaV9V8eW/ZQ==
X-MS-TrafficTypeDiagnostic: DM5PR13MB1420:
X-Microsoft-Exchange-Diagnostics: 1;DM5PR13MB1420;31:/alUgeiFlVaFGxGoFG/h8N1GAe0G6ZldZvF+GkYr5oMhzWsS3MfScXENatNTri/pGN/5dQe37fr8hI90p+gwQ6E3XMr1VNw8VyZYvJg8WBNEsOW8oV0OzyNRUlztC0ICZjn1gv9Pe+bwehbJiTfVyp/wz7joTrLBSBYi+QgYxJ3pgkQbuz7d/IQt0P8mK+PvH7vZnMLKci/I0QoBq3mXLtbrIqWfMTOZ/mEVLuDp2nU=;20:ONTiJHc+nC5Lg7fD8Zx0BW3ZPD5tl2C+gjLPubaIClvBEco6l/zp/DQBHE6tZbIwPJyEkQ32qUT0oyONjYmCr+jA9yc55SkJu+BlVWh8h/a0cmXJXIEbcGOHnY4wDyVMaDUUY1V5nrBawXQ3ZIWQeFSWEEXU0w0LqCo2DJ79D2GzkJDwn+LKuSAr4a2ER/aTYmKzZuDRpAZ2vCdgt1+hQRl1W1riDNg4RqSj24aIg8PCEiulIh15LJN1B8gSIooKChPd/aVua4oVHHGfuYjPfaql/N9XWe3TX+AwPrEyGQGE1O14qJpnM6zXVclNY6Rj8fTeALrPOIV9R84gleo1yi20yutJ6OkJBFmdI6neK+yhQMBI/N1V4L3TR1QtIJxJ4EpEdcfHSvwVD+ZKchMRWCQ2MZnPCBbiZ6DYKVeYprCL860mTuva/4ua6SRPqTiLIx9aT7QKCc9333Itpx7F7MZUrtn8W3JBfcTN3h+xWCxFEqUoprqcmV2a1SwXcgio
X-Microsoft-Antispam-PRVS: <DM5PR13MB14206AA935523F9F2F2146D4FD890@DM5PR13MB1420.namprd13.prod.outlook.com>
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(8211001083)(3230021)(908002)(999002)(11241501185)(5005026)(6040522)(8220060)(2401047)(8121501046)(3002001)(3231475)(944501520)(52105112)(10201501046)(93006095)(93004095)(6055026)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:DM5PR13MB1420;BCL:0;PCL:0;RULEID:;SRVR:DM5PR13MB1420;
X-Microsoft-Exchange-Diagnostics: 1;DM5PR13MB1420;4:KyiTQ1lm+OmxMcbnSv4Qd1NBv9TyjEevR9kV8zNBC0xRIe9AE84ZPw0hiRvfpoZ7skDwfUc6tz6KgwOQ5P9MaaNVM2R3yRRJRALqNJ9dyJrUzTuCVM06cmofDYs858j7cbVkCWkzxRiMPtzWuJ/fmRzn40VhZGhgW9gJpdw3BzvWEHGb+glWcZYI/QrKvx3Hb5q9hfQEfpwoWnNP40rOZAwTCwoTu20TcOEyoX0O/d5Jw4ADzS41zCQz8zTll8illKMaXJYWPtT+WgunI3/Bz0QXs7Fx3RLs5BqeAu+M81c=
X-Forefront-PRVS: 0910AAF391
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtETTVQUjEzTUIxNDIwOzIzOkpZNVNrMm1mTG1HclFZRjFwbDVBTGhBazcv?=
 =?utf-8?B?ZGVIQ1p6T1VxV0tjU0NmbzZ1MWptdGVKSHRlVlZHWHR1anVNUEZaNDdsZUE0?=
 =?utf-8?B?WnhTU1NJcHlDZ3g4L3NvdjRyZmJycC8wQUFUMHJzT3MxRW5UbXVDQWowbG1E?=
 =?utf-8?B?UUF0YjRBYmdXblQ5RlZkS1dlMWdsNlBCZTA4c1FleXhiZXJpRTBmbnFSVHhj?=
 =?utf-8?B?WkxIZkR0QlZyTEdKck5KNnlNU2dwSFFGUlZrQndNamhWTng1T1RtZm5ZTmc0?=
 =?utf-8?B?MTdpOEczV0VYbm5lVHZWeDV3TGRIOTlVZDhWbmVIQUdJYXVNSDd4Q1JEaVFN?=
 =?utf-8?B?QVBQbGVxWTdka3ZSYTRlTFhITFN5bUFCR2ExM0lSQzNnWmtFcFVMT2FWcjdv?=
 =?utf-8?B?NVI1YnVQZ1IwNlFrUVNkbHFHZjlsRjZ4OXNyby9Za3J6RXk1V1FRayttMCtH?=
 =?utf-8?B?RGRlMDZYcVEvNEZKWk81V2pkSStwNXV3cmowZU5zbXhiTGkwd0gvK0dKazZE?=
 =?utf-8?B?OHRBY2lTUXE0ekVsTnA0SHhtNWE0NnNpcnFpZHFQYkhiYnJCL0wyL2pRYmg4?=
 =?utf-8?B?VDZxY2ppbS9QV3ZrRWJkWUs4b2ZyTzFQMHN5aUlvNm1aeHphN3UzN2NaRXc2?=
 =?utf-8?B?V3A3V0hIZ0gwcDdpSkE1alJYOGQzK2NJOXZSeU5LbWhuU2R6VzN2cWh3ZDhu?=
 =?utf-8?B?Rk40RkNwSDN3dDlqYzdrTTBRRnZMdGgwSUhNUzVoUkRXcVQ5eGVqTG9lcHRv?=
 =?utf-8?B?YzhLT3lLdnE3dDB6V3c3QkVnWHA3THdTc2FGZEtvR2lQTG9kMXc2YzNWZy9w?=
 =?utf-8?B?Rm93cVRSUVpiV0w3dHN0RUdSUmlVKzFGQ3VuSGRGODM0R0EvOXRGZlhQQnhw?=
 =?utf-8?B?bFg1cWhkVjJOOWszT0RSVTMrb3J4c1lVejVGVXJEMjlVcmZRYjdJQ1hKbGNz?=
 =?utf-8?B?azlHRnB0YUpFSmhjajEyOS9SZ3ZlVUNHU2pjSXhrQ1hFbVFvejhoWTBPTUNs?=
 =?utf-8?B?T3FCbUhWUTV2M2dzOVE1ZUwrSGo1b0UzY0h5cUczb2lIRmMzaE9pZ1Q2VzJj?=
 =?utf-8?B?Y3N3R2VRZVo1b21oaFNocmswelhyZUE4S1dtZW4zT0pqU3VsRXFwdERxY1Mz?=
 =?utf-8?B?czB6Y1lxZkZMbjB0THZrL3lBSnpVZ2hsMWx2Q3Y4RGJoTFl0dXZpWEVKN05G?=
 =?utf-8?B?b0RrZkdZanI2bEs0RERSOElZcUFId2hyWUF3cUxGMFZ6eVA4Z2FYbDVINFpI?=
 =?utf-8?B?dC81TzJXdVVFM0k5UktIVmVqM0dlTmQ3Vk9CQTZrYlI4bFpDd1VsNjdHK1Nx?=
 =?utf-8?B?NERWeDNQUksvTEkrVGVOVCtKclBRbVdqTDdGaGhHZjR6c3JDWHI4bFB4dFVv?=
 =?utf-8?B?Y0pWYkVmeDdxY2xQVitrUVBOVjkzOW9XZE9BRHltWnVreVVDVmkvclc5VW1X?=
 =?utf-8?B?S0oyQ2xRVWVtWjZKK0xtUjVHNHZHa2tzc1hiSDNxV0dYMzlVM3Zka3BZaTlQ?=
 =?utf-8?B?ZEpINEJ5TUxUemRyeVUvc3ljV2R2eFBHeWJSV1c0dXVQVFZPbE9rMFU4UzVK?=
 =?utf-8?B?MXZUQzFQNDM2M2ViV0llUE8wZjhJMk90WVNJSlBtczJmWEl6MTVzNEFIaG05?=
 =?utf-8?B?MmVHZWlCelZrS3c3aEI2dG5lbkJyVHVXbkN3UnpOY3hvT0hiT3g5Z1hBPT0=?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: KTjeZc5SQwMyOVZQDRseiRWklILSjJsdGR8kVryP/QcCfgl7XvzW+GyaPMMTnnOwHVfsRvh878DR8fqmMmQFqFl0EYy8g1ScsNUQ726D6HDfnCsIvXaQy9r+Lz9QPe1JA+K+ZpKXpIJAQ46h4oX6Ahfy/FqfIldJgdV7BzWPKB5yDyc+B2FV8KfcIS66LVtOL1FzMiUBHnLi8/qMLoHrrar0qvh7507HkVKzzQfFCZfzwTxazcHoUzKSO3he/HaiMKOf4h8r0aBlaf1LghHnQy8UxEo31mImKiNbT4Ts1U6CPOJQHilu5fGLDLYHWW9z
X-Microsoft-Exchange-Diagnostics: 1;DM5PR13MB1420;6:qNgWl9XxWgh6dFA7WOUZdR6ztMQ+08KdT7z1TY4KnkRXKoski2w8oBnjdnWy/e4WMsafrphT2C+uGCMRorUpz4P+iMZ+TBifaZpArRhOXfmohJtdoS3dtWf2BO9XxI3ltqRRVcJ5UEXkOjCYivGlFmB0rOWDyubu+0XG9cJoEFqxn2C7S4YVDTwnOLLdY7H2lIlnhgdXEoVIp1jEeAIQmrtYOpqfSbO0T4yb1WNi51j+B2RDE5u5icZFY9ZGr2gPtsW37ZXtEtYzU4DyrfLYvmBDR4H0fkPV6ULb/2wdbbvpER5yHXFLEq/kHlWsHCeqWCGBY1sFNTOP8600nWW79pXXK6SuEXzNo/Sirbj5Rif6/bXeqjqkvKTRjX4o2zNxFGXN0gJdv05AQ64juiYV6daTEcmztj5AFh0hkS90pEtDjq1XBLQEPXsgqZuSbeyCP/A37Huh+htkh9PCGNgj9g==;5:1zS1469yu3LXuGcsTmwtdUdd5T5e9FIOdlsCzVvHI7+PVxzxC+MHGLpPCzb6x+CLFMrM4VwHpkKPCbuZ/9sE9cr0MsXfGMBMopN2tbk2GI+rzIrwFfPunQQU4R+6lnNSW1ohuWxbe6pUuf6HmpMOuMtIrokPV0+eTwA3K59Yt1Q3BK7r4Lr+8zSktJv6d/4B2Vs99vtoc9ed6Lfg1wYRYg==;7:MTS1vwBtXwSBliPhnojh/neXjAPSVSwMlBsKR3i7m5+m8LY8iiwn+79xVLw57GW96YnzIRHCG54FLvaH3Gvy1akMocsxRTfAt7Pode58K5kOzELkfWTfCD3mco2oxUntsWtQ2EsUcNA9kJ+CVMppKA==
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2019 02:25:08.9294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4398174-2f80-4b71-f3cb-08d674475927
X-MS-Exchange-CrossTenant-Id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=66c65d8a-9158-4521-a2d8-664963db48e4;Ip=[117.103.190.42];Helo=[jp.sony.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1420
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGkgQ29saW4NCg0KVGhhbmtzIGZvciBmaW5kaW5nIHRoYXQuDQpBY2tlZC1ieTogWWFzdW5hcmkg
VGFraWd1Y2hpIDxZYXN1bmFyaS5UYWtpZ3VjaGlAc29ueS5jb20+44CADQoNClRha2lndWNoaQ0K
DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IENvbGluIEtpbmcgW21haWx0
bzpjb2xpbi5raW5nQGNhbm9uaWNhbC5jb21dDQo+IFNlbnQ6IFNhdHVyZGF5LCBEZWNlbWJlciAy
MiwgMjAxOCAxMToxMiBQTQ0KPiBUbzogVGFraWd1Y2hpLCBZYXN1bmFyaSAoU1NTKTsgTWF1cm8g
Q2FydmFsaG8gQ2hlaGFiOw0KPiBsaW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGtl
cm5lbC1qYW5pdG9yc0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmcNCj4gU3ViamVjdDogW1BBVENIXVtuZXh0XSBtZWRpYTogY3hkMjg4MC1zcGk6IGZpeCB0d28g
bWVtb3J5IGxlYWtzIG9mIGR2Yl9zcGkNCj4gDQo+IEZyb206IENvbGluIElhbiBLaW5nIDxjb2xp
bi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IA0KPiBUaGVyZSBhcmUgdHdvIHJldHVybiBwYXRocyB0
aGF0IGRvIG5vdCBrZnJlZSBkdmJfc3BpLiBGaXggdGhlIG1lbW9yeQ0KPiBsZWFrcyBieSByZXR1
cm5pbmcgdmlhIHRoZSBleGl0IGxhYmVsIGZhaWxfYWRhcHRlciB0aGF0IHdpbGwgZnJlZQ0KPiBk
dmlfc3BpLg0KPiANCj4gRGV0ZWN0ZWQgYnkgQ292ZXJpdHlTY2FuLCBDSUQjMTQ3NTk5MSAoIlJl
c291cmNlIExlYWsiKQ0KPiANCj4gRml4ZXM6IGNiNDk2Y2Q0NzJhZiAoIm1lZGlhOiBjeGQyODgw
LXNwaTogQWRkIG9wdGlvbmFsIHZjYyByZWd1bGF0b3IiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xp
biBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMv
bWVkaWEvc3BpL2N4ZDI4ODAtc3BpLmMgfCAxMCArKysrKystLS0tDQo+ICAxIGZpbGUgY2hhbmdl
ZCwgNiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbWVkaWEvc3BpL2N4ZDI4ODAtc3BpLmMNCj4gYi9kcml2ZXJzL21lZGlhL3NwaS9jeGQy
ODgwLXNwaS5jDQo+IGluZGV4IGQ1YzQzM2UyMGQ0YS4uMzQ5OWM5MGRjNjk1IDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL21lZGlhL3NwaS9jeGQyODgwLXNwaS5jDQo+ICsrKyBiL2RyaXZlcnMvbWVk
aWEvc3BpL2N4ZDI4ODAtc3BpLmMNCj4gQEAgLTUyMiwxMyArNTIyLDE1IEBAIGN4ZDI4ODBfc3Bp
X3Byb2JlKHN0cnVjdCBzcGlfZGV2aWNlICpzcGkpDQo+IA0KPiAgCWR2Yl9zcGktPnZjY19zdXBw
bHkgPSBkZXZtX3JlZ3VsYXRvcl9nZXRfb3B0aW9uYWwoJnNwaS0+ZGV2LA0KPiAidmNjIik7DQo+
ICAJaWYgKElTX0VSUihkdmJfc3BpLT52Y2Nfc3VwcGx5KSkgew0KPiAtCQlpZiAoUFRSX0VSUihk
dmJfc3BpLT52Y2Nfc3VwcGx5KSA9PSAtRVBST0JFX0RFRkVSKQ0KPiAtCQkJcmV0dXJuIC1FUFJP
QkVfREVGRVI7DQo+ICsJCWlmIChQVFJfRVJSKGR2Yl9zcGktPnZjY19zdXBwbHkpID09IC1FUFJP
QkVfREVGRVIpIHsNCj4gKwkJCXJldCA9IC1FUFJPQkVfREVGRVI7DQo+ICsJCQlnb3RvIGZhaWxf
YWRhcHRlcjsNCj4gKwkJfQ0KPiAgCQlkdmJfc3BpLT52Y2Nfc3VwcGx5ID0gTlVMTDsNCj4gIAl9
IGVsc2Ugew0KPiAgCQlyZXQgPSByZWd1bGF0b3JfZW5hYmxlKGR2Yl9zcGktPnZjY19zdXBwbHkp
Ow0KPiAtCQlpZiAocmV0KQ0KPiAtCQkJcmV0dXJuIHJldDsNCj4gKwkJaWYgKHJldCkNCj4gKwkJ
CWdvdG8gZmFpbF9hZGFwdGVyOw0KPiAgCX0NCj4gDQo+ICAJZHZiX3NwaS0+c3BpID0gc3BpOw0K
PiAtLQ0KPiAyLjE5LjENCg0K
