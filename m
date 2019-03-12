Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8275DC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 04:36:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CA222087C
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 04:36:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="GB0abNTQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbfCLEge (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 00:36:34 -0400
Received: from mail-eopbgr760084.outbound.protection.outlook.com ([40.107.76.84]:23064
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725832AbfCLEgd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 00:36:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+XesU69SEvfNJfoH6UWs00wCdDz3t2t5+kYHY409Uyk=;
 b=GB0abNTQJ4IWQb35vxJBKWdWT94Hw588EpwD/sj/OtA4t/CIWqYHHLqxUDxUn2O2zKIN3U+UWaYSVWq1viBjChIQqd7HpLRA1jCBNr1uw4/O9K7HIWpT2ylg5ErAN29eXuOhO65FE3Q4RNZF5YFyQ45O7sngIB53wj7/+M26tOk=
Received: from CY4PR02MB2709.namprd02.prod.outlook.com (10.175.80.9) by
 CY4PR02MB3253.namprd02.prod.outlook.com (10.165.88.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1686.18; Tue, 12 Mar 2019 04:36:29 +0000
Received: from CY4PR02MB2709.namprd02.prod.outlook.com
 ([fe80::bc8d:c1a1:e7d9:2983]) by CY4PR02MB2709.namprd02.prod.outlook.com
 ([fe80::bc8d:c1a1:e7d9:2983%11]) with mapi id 15.20.1686.021; Tue, 12 Mar
 2019 04:36:29 +0000
From:   Vishal Sagar <vsagar@xilinx.com>
To:     Luca Ceresoli <luca@lucaceresoli.net>,
        Vishal Sagar <vishal.sagar@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        Michal Simek <michals@xilinx.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dinesh Kumar <dineshk@xilinx.com>,
        Sandip Kothari <sandipk@xilinx.com>
Subject: RE: [PATCH v3 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI
 CSI-2 Rx Subsystem
Thread-Topic: [PATCH v3 1/2] media: dt-bindings: media: xilinx: Add Xilinx
 MIPI CSI-2 Rx Subsystem
Thread-Index: AQHUui2firlCePorTEqZepvuAcjfSKXaeICAgCfB/uCABFdSAIABEaDA
Date:   Tue, 12 Mar 2019 04:36:28 +0000
Message-ID: <CY4PR02MB2709BECF081E32B5D4EA5354A7490@CY4PR02MB2709.namprd02.prod.outlook.com>
References: <1549025766-135037-1-git-send-email-vishal.sagar@xilinx.com>
 <1549025766-135037-2-git-send-email-vishal.sagar@xilinx.com>
 <fe975327-2746-28d4-1340-5ad1e71858f1@lucaceresoli.net>
 <CY4PR02MB27098AB5D144C74AE6553699A74D0@CY4PR02MB2709.namprd02.prod.outlook.com>
 <1f698576-89b2-e264-387e-6db4c5a4713a@lucaceresoli.net>
In-Reply-To: <1f698576-89b2-e264-387e-6db4c5a4713a@lucaceresoli.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vsagar@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0cb550da-a8fd-4e34-eaf6-08d6a6a44b8d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:CY4PR02MB3253;
x-ms-traffictypediagnostic: CY4PR02MB3253:
x-microsoft-exchange-diagnostics: =?utf-8?B?MTtDWTRQUjAyTUIzMjUzOzIzOjZKZ21uWnowVTVoRzNjNzFKZVpmUGNGL0lN?=
 =?utf-8?B?K2dmcE1sejhhdkNRb2Frakk5aDNmd3BMWnRMcC9CUmxINGlJczNqMWpRbTJs?=
 =?utf-8?B?MysreGZXNC9EaFZLeElFYU9RYUN6NnBUeVVsSy9CMnkzQXd5L0lHeklBbWdy?=
 =?utf-8?B?NFAzY0ZQREtIaktZcXhHRGtpVnk1ZE11dWgxNjF5VldaVFZwYmYvSjZScVZP?=
 =?utf-8?B?bjR1YUtMSVlxREVnL2lkN2dQZThaMnpldGhuYVlvTll0VG5JK1phb1lQb1FB?=
 =?utf-8?B?UW9SNHhzbDdSL3hXZFEwQVFUZXBEeDUyNG9ML2tJeWlFWjhVdytScThXaVRU?=
 =?utf-8?B?cVgzL2xxUTQ1MUlWaDZSTlRhRnRlbGtxMUtuT29jV1k4cWRvU2FoR1FFdkRP?=
 =?utf-8?B?eVRwUDdqK2ZNc3Z5cnI0VXkzVmJncU15NHZ2VThuNC9oMW5DVEM3ck5xaFRO?=
 =?utf-8?B?bG5vV0FZd254RTVHNEVxMGZ1aDR6bTg0aGdBcS9XVUdnb2RSUGx6UVZHK0hL?=
 =?utf-8?B?NEtBSjBvRU93ampzZUJ1NHIxd201RlMvbVQ3anNKNHBNZ3FZMlNnOUF4Z0VG?=
 =?utf-8?B?SkcrYSthM090RElTdUQ3djc3Z2xyUml3VUZKSlNPVXVPUFpRbzlCNTdkLzhL?=
 =?utf-8?B?TWJWeXpDRkJGTVd2NFlxa00ydjc5Uk9rVHlRbksvMzNqU3BGQnF5MjBzTGV6?=
 =?utf-8?B?SWowZFkycnZwbUk5eWttZzM4TVNxOFhQTnY5TlBKM0ZJT0ZDeFJiUTMwcm45?=
 =?utf-8?B?MVo3ZSt4SlBsV3FBQkZEZkFmMFdiMFlJSzRvNnZhaXpCWTJHYThRL2VWV1VQ?=
 =?utf-8?B?RFEwOWZiRGtXaXJ4T2tYQUJyUGd6L3FYSDYxdXdpVVZWRDZGNjgxbFBMYWxn?=
 =?utf-8?B?ZnROckJqVUt0K0M0bUd5Rkw2Mmp1Z2hFYThBaFdxaEtDUTl2SHo4SUorZHhr?=
 =?utf-8?B?elVlV0lUN3FFMXV4Q2pXbHIrcXNXdElRSWJkUGYvMWlJdG1VeGVMNWdRTU5P?=
 =?utf-8?B?djE2TVB0YmYranl1eDYzcjJFOU45THpFR25KSlgxMEoveVErekZZTElOYW1r?=
 =?utf-8?B?T0Q5M3YwMFNUL0RFMWM0R25NM2oxbEZqTHVvckV0SDJyZUpIWUl2WkZDTXh3?=
 =?utf-8?B?QkxpM0NOZUR6WEhkbXlzdm9LcFZvOUFGYXdGUEhxbzVpTEJ1NDZpcXZaT2dz?=
 =?utf-8?B?UHFZRHZJbzVyeU54YTRPb1BycnNtZDczd3hIMnhzVnpmRzNxOXhsb09UQ2RW?=
 =?utf-8?B?Nmh6emJLc04vMWRxV3lqejUrUUxoc2ZWMzdsUng4RzY1WExKSjk2dUo1bU9K?=
 =?utf-8?B?Ri9XbUR4TDA2c2RQTUg2NDg3NXY3K2NRSkxMNTI0Qkx2TnM3TzRmQVdlbDFy?=
 =?utf-8?B?dU1kYTVySnZCZzJBeUdtMEZuRWpsVHR3N3ZRbmZGN2dUSTNJUDBlcHVwdHpy?=
 =?utf-8?B?ZXhFTU8rWTk4NUZUTS9GeE82cWNtcC9jVEdabE5xaStJQ01WbUVsQjc2dWxY?=
 =?utf-8?B?VFBMZkFTWEhtd0NNT1ZodWN5VXFOU3BlMzFTbGY1SytYV3Qvc2NoMm5FbVFz?=
 =?utf-8?B?TWdqRm5FcmVveVdXQW1teFQ2U3lZNW8rK0FoMnZ2VHhDcWp3TWhVandaeUI5?=
 =?utf-8?B?dkZyY3BNMWNPWjIwN004Y0EzZ3laNVovQVZTcU1FM3p2OFdRc0pLaFBjbXh2?=
 =?utf-8?B?bnRCTS9qSVFHVDIwSzc4WlMrNVV6RGRWeHo3RHRrTHA3VGY5NHB5TFNtTmZM?=
 =?utf-8?B?SjdVVk95MXJIN0VYQnNyRXRRaTl4b3N0dmU4dUZ4dDVrVTBuTm9US3dTVWo2?=
 =?utf-8?B?TG9ERmtJQmNSM1VQWUhXWVM3T2FDTXoxYmhHU09WcmxIM1E9PQ==?=
x-microsoft-antispam-prvs: <CY4PR02MB3253CE557F5B34E843A0D56AA7490@CY4PR02MB3253.namprd02.prod.outlook.com>
x-forefront-prvs: 09749A275C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(39850400004)(136003)(366004)(376002)(199004)(189003)(13464003)(26005)(11346002)(316002)(6246003)(7416002)(2906002)(446003)(7736002)(105586002)(6636002)(186003)(25786009)(14454004)(106356001)(68736007)(8676002)(74316002)(305945005)(8936002)(81156014)(81166006)(99286004)(478600001)(486006)(33656002)(476003)(102836004)(3846002)(6116002)(7696005)(229853002)(76176011)(66066001)(53546011)(6506007)(97736004)(6436002)(110136005)(86362001)(5660300002)(256004)(93886005)(2501003)(53936002)(14444005)(71190400001)(71200400001)(9686003)(52536013)(55016002)(2201001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR02MB3253;H:CY4PR02MB2709.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jjOrMHtacKtaeaW/3uMTAMzk1E3wQsuqcUmlmev/pr5qe6vC9yd3mKNIGa9PH1LC06ARCgB/jvSusnOpoIoZ7bsxE/jJezeqI2Lk5Ipxo0prZt+se0Lc0/ptWtc5+G0pKKIDDqlbRIB5LrqTSSxPm4MK4FD9HBBxHbzrmZgxviURAjDrMeWrovHw3J6sTwW7aAdkSInyCm+QIA/nrxOHkWefeyQmcyw/7PrWLSAsjM3BJVyrZL0I8lNqtxHBZLZ4j4arut6Kg1tYXHYHfAJikgHqVCqqWIUTXLuBfLIeCRFPvmUI/zbifXheYsQPQZQxKuFJ7rXOCpVqIaxp8BYpX6K6mabdjhosCpv4hXcP5SWLmpbpvHLVCBdYcrFARtTzPu7yRmS0A6zVqzsfLEK+YhxnjbAjtZB1hi6IVdaAXfk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb550da-a8fd-4e34-eaf6-08d6a6a44b8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2019 04:36:29.0101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR02MB3253
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGkgTHVjYSwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBMdWNhIENl
cmVzb2xpIFttYWlsdG86bHVjYUBsdWNhY2VyZXNvbGkubmV0XQ0KPiBTZW50OiBNb25kYXksIE1h
cmNoIDExLCAyMDE5IDU6MzggUE0NCj4gVG86IFZpc2hhbCBTYWdhciA8dnNhZ2FyQHhpbGlueC5j
b20+OyBWaXNoYWwgU2FnYXIgPHZpc2hhbC5zYWdhckB4aWxpbnguY29tPjsNCj4gSHl1biBLd29u
IDxoeXVua0B4aWxpbnguY29tPjsgbGF1cmVudC5waW5jaGFydEBpZGVhc29uYm9hcmQuY29tOw0K
PiBtY2hlaGFiQGtlcm5lbC5vcmc7IHJvYmgrZHRAa2VybmVsLm9yZzsgbWFyay5ydXRsYW5kQGFy
bS5jb207IE1pY2hhbA0KPiBTaW1layA8bWljaGFsc0B4aWxpbnguY29tPjsgbGludXgtbWVkaWFA
dmdlci5rZXJuZWwub3JnOw0KPiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgc2FrYXJpLmFp
bHVzQGxpbnV4LmludGVsLmNvbTsNCj4gaGFucy52ZXJrdWlsQGNpc2NvLmNvbTsgbGludXgtYXJt
LWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVs
Lm9yZzsgRGluZXNoIEt1bWFyIDxkaW5lc2hrQHhpbGlueC5jb20+OyBTYW5kaXAgS290aGFyaQ0K
PiA8c2FuZGlwa0B4aWxpbnguY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYzIDEvMl0gbWVk
aWE6IGR0LWJpbmRpbmdzOiBtZWRpYTogeGlsaW54OiBBZGQgWGlsaW54IE1JUEkNCj4gQ1NJLTIg
UnggU3Vic3lzdGVtDQo+IA0KPiBIaSBWaXNoYWwsDQo+IA0KPiBPbiAwOC8wMy8xOSAyMDowNCwg
VmlzaGFsIFNhZ2FyIHdyb3RlOg0KPiA+Pj4gK09wdGlvbmFsIHByb3BlcnRpZXM6DQo+ID4+PiAr
LS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPj4+ICstIHhsbngsdmZiOiBUaGlzIGlzIHByZXNlbnQg
d2hlbiBWaWRlbyBGb3JtYXQgQnJpZGdlIGlzIGVuYWJsZWQuDQo+ID4+PiArICBXaXRob3V0IHRo
aXMgcHJvcGVydHkgdGhlIGRyaXZlciB3b24ndCBiZSBsb2FkZWQgYXMgSVAgd29uJ3QgYmUgYWJs
ZSB0bw0KPiA+PiBnZW5lcmF0ZQ0KPiA+Pj4gKyAgbWVkaWEgYnVzIGZvcm1hdCBjb21wbGlhbnQg
c3RyZWFtIG91dHB1dC4NCj4gPj4+ICstIHhsbngsZW4tY3NpLXYyLTA6IFByZXNlbnQgaWYgQ1NJ
IHYyIGlzIGVuYWJsZWQgaW4gSVAgY29uZmlndXJhdGlvbi4NCj4gPj4+ICstIHhsbngsZW4tdmN4
OiBXaGVuIHByZXNlbnQsIHRoZXJlIGFyZSBtYXhpbXVtIDE2IHZpcnR1YWwgY2hhbm5lbHMsIGVs
c2UNCj4gPj4+ICsgIG9ubHkgNC4gVGhpcyBpcyBwcmVzZW50IG9ubHkgaWYgeGxueCxlbi1jc2kt
djItMCBpcyBwcmVzZW50Lg0KPiA+Pj4gKy0geGxueCxlbi1hY3RpdmUtbGFuZXM6IEVuYWJsZSBB
Y3RpdmUgbGFuZXMgY29uZmlndXJhdGlvbiBpbiBQcm90b2NvbA0KPiA+Pj4gKyAgQ29uZmlndXJh
dGlvbiBSZWdpc3Rlci4NCj4gPj4NCj4gPj4gVGhpcyBkb2Vzbid0IHNlZW0gdmVyeSBjbGVhciB0
byBtZS4gQWNjb3JkaW5nIHRvIG15IHVuZGVyc3RhbmRpbmcgb2YgdGhlDQo+ID4+IElQIGFuZCBk
cml2ZXIsIEknZCByYXRoZXIgcmVwaHJhc2UgYXM6DQo+ID4+DQo+ID4+IC0geGxueCxlbi1hY3Rp
dmUtbGFuZXM6IHByZXNlbnQgaWYgdGhlIG51bWJlciBvZiBhY3RpdmUgbGFuZXMgY2FuIGJlDQo+
ID4+ICAgcmVjb25maWd1cmVkIGF0IHJ1bnRpbWUgaW4gdGhlIFByb3RvY29sIENvbmZpZ3VyYXRp
b24gUmVnaXN0ZXIuDQo+ID4+ICAgSWYgcHJlc2VudCwgdGhlIFY0TDJfQ0lEX1hJTElOWF9NSVBJ
Q1NJU1NfQUNUX0xBTkVTIGlzIGFkZGVkLg0KPiA+PiAgIE90aGVyd2lzZSBhbGwgbGFuZXMgYXJl
IGFsd2F5cyBhY3RpdmUuDQo+ID4+DQo+ID4NCj4gPiBZb3VyIGRlc2NyaXB0aW9uIGlzIGJldHRl
ci4gSSB3aWxsIHVwZGF0ZSB3aXRoIHRoaXMgaW4gbmV4dCB2ZXJzaW9uLg0KPiANCj4gT2ssIHRo
YW5rcy4gQnV0IEkganVzdCBub3RpY2VkIGFuIGVycm9yIGluIG15IG93biB3b3Jkcy4uLg0KPiAi
VjRMMl9DSURfWElMSU5YX01JUElDU0lTU19BQ1RfTEFORVMgaXMgYWRkZWQiIC0+DQo+ICJWNEwy
X0NJRF9YSUxJTlhfTUlQSUNTSVNTX0FDVF9MQU5FUyBjb250cm9sIGlzIGFkZGVkIi4NCj4gDQo+
IC0tDQo+IEx1Y2ENCg0KT2sgSSB3aWxsIGRvIHRoaXMgaW4gbmV4dCByb3VuZCBvZiBwYXRjaC4N
Cg0KUmVnYXJkcw0KVmlzaGFsIFNhZ2FyDQo=
