Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FCCC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 09:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CC912075E
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 09:14:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="xR99IEGZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfCSJOZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 05:14:25 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:16357 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfCSJOY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 05:14:24 -0400
X-IronPort-AV: E=Sophos;i="5.58,497,1544511600"; 
   d="scan'208";a="28099234"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 19 Mar 2019 02:14:23 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 19 Mar 2019 02:14:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XE9a5X41G/ox5TJAW0xdom9TJfHrWWpZnwu2gv7gCuw=;
 b=xR99IEGZzTOS5sB1PDH50CpTX3hCq97f9Wc6mzYqHWGK++euxzROm6L8vGyI/rxjP4R0xMWcakwz5CUTIwk3w7DvZKj5/Oc3kjN+q4KPunJo/jSah9KSPYlWy4bmS+vvhQYWqj3fNq4z55CJqTEOkHw+v8zhg3jbpa6kVUFKCTQ=
Received: from DM5PR11MB1242.namprd11.prod.outlook.com (10.168.108.8) by
 DM5PR11MB1531.namprd11.prod.outlook.com (10.172.37.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.14; Tue, 19 Mar 2019 09:14:21 +0000
Received: from DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::e8b6:2ae9:9b9c:2ca8]) by DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::e8b6:2ae9:9b9c:2ca8%3]) with mapi id 15.20.1709.015; Tue, 19 Mar 2019
 09:14:21 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <lkundrak@v3.sk>, <akinobu.mita@gmail.com>
CC:     <sakari.ailus@linux.intel.com>, <linux-media@vger.kernel.org>,
        <corbet@lwn.net>, <mchehab@kernel.org>
Subject: Re: [PATCH 0/2] media: ov7670: fix regressions caused by "hook
 s_power onto v4l2 core"
Thread-Topic: [PATCH 0/2] media: ov7670: fix regressions caused by "hook
 s_power onto v4l2 core"
Thread-Index: AQHU2CA7nz3NyGtboEiC+lD6jeFZ4aYIPk8AgAHScYCACKYDgA==
Date:   Tue, 19 Mar 2019 09:14:21 +0000
Message-ID: <1900bcf1-a5b7-b4b3-d275-03117e6c87ef@microchip.com>
References: <1552318563-6685-1-git-send-email-akinobu.mita@gmail.com>
 <559a9073a3d42de6737f75a1fb6a6e53451a6a28.camel@v3.sk>
 <20190313210535.fl54xfjhui7dl7bb@kekkonen.localdomain>
In-Reply-To: <20190313210535.fl54xfjhui7dl7bb@kekkonen.localdomain>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR0102CA0099.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::40) To DM5PR11MB1242.namprd11.prod.outlook.com
 (2603:10b6:3:14::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-tagtoolbar-keys: D20190319110951418
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e253c01c-3510-4fb6-2161-08d6ac4b455e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:DM5PR11MB1531;
x-ms-traffictypediagnostic: DM5PR11MB1531:
x-microsoft-antispam-prvs: <DM5PR11MB15312E00C785EA94C5CF8CBCE8400@DM5PR11MB1531.namprd11.prod.outlook.com>
x-forefront-prvs: 0981815F2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(346002)(136003)(396003)(376002)(366004)(189003)(199004)(129404003)(6436002)(6506007)(386003)(6486002)(5660300002)(229853002)(71200400001)(26005)(71190400001)(66066001)(53546011)(3846002)(6116002)(36756003)(8676002)(6246003)(54906003)(2906002)(316002)(52116002)(53936002)(6512007)(110136005)(25786009)(186003)(8936002)(81166006)(86362001)(97736004)(14454004)(11346002)(446003)(256004)(72206003)(14444005)(476003)(99286004)(478600001)(2616005)(305945005)(68736007)(7736002)(102836004)(76176011)(31696002)(486006)(105586002)(106356001)(31686004)(81156014)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1531;H:DM5PR11MB1242.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zwvxfh8uYXUo8VqM6IOk0XgBgESBuy5g7UMt0JnJmcmU9AAIpe/OSOz/c8x/zfFBPaPsaBwzw7RxSDOfgjsSidR/ypyJJfvN5ftBrzFXBX6XHtSHM93J7w80KrVKibHGUA3FOpLKg19z9KNrqpmIoSXMvRiTJ10rYlzQzyc+vvgN0XvMdYEQ6JKhV/ZN3/9x10HUGGjT7zGeuazGlS+9qY1nhwYFzEPoqxmMvV5XAWnkds68PesZDYTt8zkUaqNIdWxqaIe+/6zCki5oUIvsdCvq9UjwL7oeNkTul6wYDukqP1GUtgT+Hkot5wTwwrkROi00fue4+Qx6nShBP5yUJTJY8kT0bV4VsB/W0uTv8n63cv0ECmBXNbut/PkcIzLKLDLu7D507RXn/HPLlsNsY+afkixWzdV+bEL0loyo7cA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <09B41F5B11FD6D429C2E719F85086454@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e253c01c-3510-4fb6-2161-08d6ac4b455e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2019 09:14:21.0809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1531
X-OriginatorOrg: microchip.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

DQoNCk9uIDEzLjAzLjIwMTkgMjM6MDUsIFNha2FyaSBBaWx1cyB3cm90ZToNCg0KPiBPbiBUdWUs
IE1hciAxMiwgMjAxOSBhdCAwNjoxNjowOFBNICswMTAwLCBMdWJvbWlyIFJpbnRlbCB3cm90ZToN
Cj4+IE9uIFR1ZSwgMjAxOS0wMy0xMiBhdCAwMDozNiArMDkwMCwgQWtpbm9idSBNaXRhIHdyb3Rl
Og0KPj4+IFRoaXMgcGF0Y2hzZXQgZml4ZXMgdGhlIHByb2JsZW1zIGludHJvZHVjZWQgYnkgcmVj
ZW50IGNoYW5nZSB0byBvdjc2NzAuDQo+Pj4NCj4+PiBBa2lub2J1IE1pdGEgKDIpOg0KPj4+ICAg
IG1lZGlhOiBvdjc2NzA6IHJlc3RvcmUgZGVmYXVsdCBzZXR0aW5ncyBhZnRlciBwb3dlci11cA0K
Pj4+ICAgIG1lZGlhOiBvdjc2NzA6IGRvbid0IGFjY2VzcyByZWdpc3RlcnMgd2hlbiB0aGUgZGV2
aWNlIGlzIHBvd2VyZWQgb2ZmDQo+Pj4NCj4+PiAgIGRyaXZlcnMvbWVkaWEvaTJjL292NzY3MC5j
IHwgMzIgKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0NCj4+PiAgIDEgZmlsZSBjaGFu
Z2VkLCAyNyBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPj4+DQo+Pj4gQ2M6IEx1Ym9t
aXIgUmludGVsIDxsa3VuZHJha0B2My5zaz4NCj4+PiBDYzogSm9uYXRoYW4gQ29yYmV0IDxjb3Ji
ZXRAbHduLm5ldD4NCj4+PiBDYzogU2FrYXJpIEFpbHVzIDxzYWthcmkuYWlsdXNAbGludXguaW50
ZWwuY29tPg0KPj4+IENjOiBNYXVybyBDYXJ2YWxobyBDaGVoYWIgPG1jaGVoYWJAa2VybmVsLm9y
Zz4NCj4+DQo+PiBGb3IgdGhlIGJvdGggcGF0Y2hlcyBpbiB0aGUgc2V0Og0KPj4NCj4+IFJldmll
d2VkLWJ5OiBMdWJvbWlyIFJpbnRlbCA8bGt1bmRyYWtAdjMuc2s+DQo+PiBUZXN0ZWQtYnk6IEx1
Ym9taXIgUmludGVsIDxsa3VuZHJha0B2My5zaz4NCj4gDQo+IFRoYW5rcywgZ3V5cyENCj4gDQoN
CkhpIEFraW5vYnUsDQoNCkkgYW0gaGF2aW5nIGlzc3VlcyB3aXRoIHRoaXMgc2Vuc29yLCBhbmQg
eW91ciBwYXRjaGVzIGRvIG5vdCBmaXggdGhlbSANCmZvciBtZSAoIG1heWJlIHRoZXkgYXJlIG5v
dCBzdXBwb3NlZCB0byApDQoNCk15IGlzc3VlcyBhcmUgbGlrZSB0aGlzOiBvbmNlIEkgc2V0IGEg
Zm9ybWF0IGFuZCBzdGFydCBzdHJlYW1pbmcsIGlmIEkgDQpzdG9wIHN0cmVhbWluZyBhbmQgcmVj
b25maWd1cmUgdGhlIGZvcm1hdCAsIGZvciBleGFtcGxlIFlVWVYgYWZ0ZXIgUkFXLCANCm9yIFJH
QjU2NSBhZnRlciBSQVcgYW5kIHZpY2V2ZXJzYSwgdGhlIHNlbnNvciBsb29rcyB0byBoYXZlIGNv
bXBsZXRlbHkgDQptZXNzZWQgdXAgc2V0dGluZ3M6IGltYWdlcyBvYnRhaW5lZCBhcmUgdmVyeSBi
YWQuDQpUaGlzIGRpZCBub3QgaGFwcGVuIGZvciBtZSB3aXRoIG9sZGVyIGtlcm5lbCB2ZXJzaW9u
ICg0LjE0IHN0YWJsZSBmb3IgDQpleGFtcGxlKS4NCkkgY2FuIGhlbHAgd2l0aCB0ZXN0aW5nIHBh
dGNoZXMgaWYgeW91IG5lZWQuDQpNeSBzZXR1cCBpcyB3aXRoIGF0bWVsLWlzYyB3aXRoIHBhcmFs
bGVsIGludGVyZmFjZSBvbiBib2FyZCBhdDkxIA0Kc2FtYTVkMl94cGxhaW5lZA0KDQpIb3BlIHRo
aXMgaGVscHMsDQoNCkV1Z2VuDQo=
