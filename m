Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6613DC282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 08:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 199DE222B5
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 08:02:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="PUhO4cPX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388534AbfBMICW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 03:02:22 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:61220 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfBMICW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 03:02:22 -0500
X-IronPort-AV: E=Sophos;i="5.58,365,1544511600"; 
   d="scan'208";a="26650401"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 13 Feb 2019 01:02:20 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Wed, 13 Feb 2019 01:02:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/COWUzB+Zax9N3w5V+Du28FIycwdAlJIofmoFVuuCU=;
 b=PUhO4cPXMzXSD+s/rHBCjDX5a4dywpIQ++IfHLjklklRXvAI4qvG9q98WVsb4WAD9AB5F2IoF5MAXF97z0cMJs6MRtPbJpDIh14VnqMN4m82aRFwzYh4T35Tj35VLhccaQgFKbqCgEiComJwF/rqRxWzvEUoXmFYYRfgDUu3VyM=
Received: from DM5PR11MB1242.namprd11.prod.outlook.com (10.168.108.8) by
 DM5PR11MB1625.namprd11.prod.outlook.com (10.172.37.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.22; Wed, 13 Feb 2019 08:02:19 +0000
Received: from DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::4c19:f788:c2be:5e8f]) by DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::4c19:f788:c2be:5e8f%5]) with mapi id 15.20.1601.023; Wed, 13 Feb 2019
 08:02:19 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <loic.poulain@linaro.org>
CC:     <linux-media@vger.kernel.org>, <sakari.ailus@linux.intel.com>
Subject: Issues with ov5640 sensor
Thread-Topic: Issues with ov5640 sensor
Thread-Index: AQHUw3Jx2JdilSb8mk2RiQMZep4Qzw==
Date:   Wed, 13 Feb 2019 08:02:19 +0000
Message-ID: <633027a3-b6a9-4cf0-b1a8-9e4dbe3c824e@microchip.com>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR06CA0131.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::24) To DM5PR11MB1242.namprd11.prod.outlook.com
 (2603:10b6:3:14::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc6caabb-622c-41aa-19b7-08d69189934f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:DM5PR11MB1625;
x-ms-traffictypediagnostic: DM5PR11MB1625:
x-microsoft-exchange-diagnostics: =?utf-8?B?MTtETTVQUjExTUIxNjI1OzIzOmRIZnpROXM5RG9LZU5IZFdFS0hRRGE5VStF?=
 =?utf-8?B?NTQybFlWZTcrcitpK2V0MzkrMHBVZndraXVsckFEc0hQZ0I3WnpVVUNTdWpM?=
 =?utf-8?B?WmtzZjZ0c2tkTnRVS1E0ejE2UVZkUkNHRGppUUVlTVg4NGNkaXFIditYZXVj?=
 =?utf-8?B?NkMwbUs4eWVsU3VZOU1TT1FzbWIrNmZmSTlqazVvcmo4U2JoenFSVTNVSldP?=
 =?utf-8?B?S1gzVTJtVzY0ckMwb0VWR0kvU1lsb0FUeG5BeU42VjFDR3RZaVFvUFl5bkRV?=
 =?utf-8?B?UXZ3UXRkUERYZjJxd3lIZzR1cEVlVDZ5ZEQxMnF2TTk5eHBuSzZRWElOV3hv?=
 =?utf-8?B?RzBlZDFGemRqRnBNMWVacXFYSHllTE4vemNtbmN0RU5WSXNLaGlpWkVTMFc1?=
 =?utf-8?B?UXo5eU01Yk42VU1RaThNWjl3ZXA3S2p1V3BOWDk4ZDlla1pDQVdYajl3Q0lu?=
 =?utf-8?B?elljM3NlZlowZE5zRlhSaXl3cFJzV0VIeEJXcHZkUUhyNVJSOS82ZXJQZVNx?=
 =?utf-8?B?MUZwL3podmJrUVhVZ2hkSmRMbjhaa3VTK0ZIaFJGK291cHFiR202MW9hTmt5?=
 =?utf-8?B?UmNDUFlxSkVkRGFyZjJyaUxwemNxQnc0MStTU214MUJWZXpHbFBPM3ZsdmpM?=
 =?utf-8?B?RzY1RUM1UWVoL3hNMyszbERadnhOSndBL3Z5VGhFd2M0T1AxQ0psQ3J2U3lJ?=
 =?utf-8?B?VHBNemFMbktBV0svZlh2Y2pxOHhvSUdLVFBVZ0pkSjZEb3lzdXZYR00yM2ZC?=
 =?utf-8?B?WHR2bUF1NzZFSlFNUXFISXg2OEZVY1I4VEhLYWZrVjk0ODhrMXZidXZKYlRr?=
 =?utf-8?B?dG5xUjhjeTJrazdjTE1KVWtISitxMjJQK29LNDZDTkdYMC9RVjB4QTVsdHEv?=
 =?utf-8?B?VkdTVkp1emhXUDFjT1lqb1JMY2kxdTlHekRHS3kvbnRwdXpPakpKL1hRdXMw?=
 =?utf-8?B?UDFsRndjQXhFQkFmTmhtTHFYWXRlNVY0NVZtNlNnQmd6N1BneG9QMFBjY1pJ?=
 =?utf-8?B?R1VvWU5XZk5qaXREeGZ2RnR2QkY5REFCYXBYWTQ3dmJ1MWxoQzNvKzRhd25U?=
 =?utf-8?B?ZkhRS3U2MTBJdUp4M01XZFNPUUZhZ2xtNjR5Y3BEL29jbW83OW5NZ1MyVzFw?=
 =?utf-8?B?bmxJSmNWZVhEK3VSeDU0a2lzR3R4VU1WR2R1L1RLbUhGb1FQZUwvbFJpaVpq?=
 =?utf-8?B?aGFTd1lwNUJFc3A4N2lmQVAvWlNOU2pFTmh3UWVnK1N6bHdpSklsZmNRWEhL?=
 =?utf-8?B?TzRLb0VUTEhETXluSWEyWTVxR2N4ZHBNRmtyOENTNVpoN2Jhd3NDbWdWdEZR?=
 =?utf-8?B?bXhZU2d6c0p4SE5TSStSbWFUbnBGa1NZV0VHNXF1K3FLaStpZmNRVkJEa2NE?=
 =?utf-8?B?eUVGTmpNUC9uWisxRTFBOFR4MkJyYXBOeS9vdTBvOWs5L2dSQ3dCSHVnNnhK?=
 =?utf-8?B?dGN2NGxpRlpNU1Y2MDJPczkrTldZY1BZSjQxcDl0RG1Qd1dQdTFETktGcWJJ?=
 =?utf-8?B?SzdMYmlRbTA0cWFXaW96NjBCSCtUVkVSeWxpWGtUWWVJcFdIVjJ2M1JKNklO?=
 =?utf-8?B?K3BjK0cwN2VJZUt1RWluMmdaZDVrSkNHa2srbjd5SThEd09UTUh6NE9rUUo4?=
 =?utf-8?B?RkdaRlN6eFNXeFJtaTM5bkRKbzU2cEx4TnBFNk04RERNWkVIRVJqNHZRPT0=?=
x-microsoft-antispam-prvs: <DM5PR11MB16256A94F73F187E5060FA6FE8660@DM5PR11MB1625.namprd11.prod.outlook.com>
x-forefront-prvs: 094700CA91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(366004)(396003)(136003)(39860400002)(189003)(199004)(102836004)(105586002)(2906002)(6506007)(52116002)(305945005)(31686004)(186003)(6486002)(26005)(478600001)(53936002)(6916009)(68736007)(7736002)(6436002)(8676002)(81166006)(72206003)(5640700003)(2501003)(6512007)(14454004)(386003)(71190400001)(2351001)(81156014)(256004)(71200400001)(8936002)(106356001)(4744005)(4326008)(25786009)(316002)(486006)(86362001)(476003)(36756003)(66066001)(2616005)(54906003)(3846002)(31696002)(6116002)(99286004)(97736004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1625;H:DM5PR11MB1242.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cbdZUAZ8TeIa+uxyEUak5mhDr5vsiQTaMkdv+QMjvVxfz8ILb+ycs8BuZbpSv3M1c/ovznrRv+ffHyUG7uICKPCUJDDFBIwHCmCc6xpXfCIsk3POjBXY9KJm80OYz7QiGQ6S9Rt6usjmhudPnIDwumMvy56OpVhQPw4oEhdujZ4AAR1feB5ICJhcWd+EKkXC7Dd86H7z/3qm6LLRv1xG/yebQm6k/qC+juuSGxHwWVsZGQDLOznhENnn8mAq9ERPNW99JdV42EziXbaXKLZhyI+0W0VGpTdRZ20tukg+gWQ4BsE5TBVIgPtLEyN5rudYU/X6B4VbX71po6RSVSUbirH+yIPgv07nocOZE8LtFVFIruubsBnGbjtCaIiGGdGozDjhu3ehNeYTO1o0WECGetjSOrhZYfpoTFBulfxGTfE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5E362FE33072348A0D6F1F640A8C7CC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dc6caabb-622c-41aa-19b7-08d69189934f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2019 08:02:17.9128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1625
X-OriginatorOrg: microchip.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGVsbG8gTG9pYywNCg0KSSBhbSB0cnlpbmcgdG8gbWFrZSBzZW5zb3IgT21uaXZpc2lvbiBvdjU2
NDAgd29yayB3aXRoIG91ciBBdG1lbC1pc2MgDQpjb250cm9sbGVyLCBJIHNhdyB5b3UgaW1wbGVt
ZW50ZWQgUkFXIG1vZGUgZm9yIHRoaXMgc2Vuc29yIGluIHRoZSANCmRyaXZlciwgc28gSSB3YXMg
aG9waW5nIEkgY2FuIGFzayB5b3Ugc29tZSB0aGluZ3M6DQoNCkkgY2Fubm90IG1ha2UgdGhlIFJB
VyBiYXllciBmb3JtYXQgd29yaywgQkE4MSAvIG1idXMgDQpNRURJQV9CVVNfRk1UX1NCR0dSOF8x
WDggbWFrZXMgdGhlIHBob3RvIGxvb2sgbGlrZSBhIG1hemUgb2YgY29sb3JzLi4uDQoNClRoZSBz
ZW5zb3Igd29ya3MgZm9yIG1lIGluIFlVWVYgYW5kIFJHQjU2NSBtb2RlLCBzbyBJIGFzc3VtZSB0
aGUgd2lyaW5nIA0KaXMgZG9uZSBjb3JyZWN0bHkgZm9yIG15IHNldHVwDQoNCkFueXRoaW5nIHNw
ZWNpYWwgSSBuZWVkIHRvIGRvIGZvciB0aGlzIGZvcm1hdCB0byB3b3JrID8NCg0KVGhlIHNhbWUg
UkFXIEJBWUVSIGNvbmZpZ3VyYXRpb24gd29ya3MgZm9yIG1lIG9uIG92NzY3MCBmb3IgZXhhbXBs
ZS4uLg0KDQpVbnJlbGF0ZWQ6IGFyZSB5b3UgZmFtaWxpYXIgd2l0aCBvdjc3NDAgPyBUaGlzIHNl
bnNvciBsb29rcyB0byBoYXZlIA0Kc3RvcHBlZCB3b3JraW5nIGluIGxhdGVzdCBtZWRpYXRyZWUg
OiBmYWlsZWQgdG8gZW5hYmxlIHN0cmVhbWluZy4gDQood29ya2VkIHBlcmZlY3RseSBpbiBsYXN0
IHN0YWJsZSBmb3IgbWUgLSA0LjE0Li4uKQ0KDQpUaGFua3MgZm9yIHlvdXIgcmVwbHksDQoNCkV1
Z2VuDQo=
