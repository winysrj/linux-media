Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE42EC07EBF
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 18:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8930420850
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 18:05:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=aampusa.onmicrosoft.com header.i=@aampusa.onmicrosoft.com header.b="rif78wjl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbfARSFd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 13:05:33 -0500
Received: from mail-eopbgr780093.outbound.protection.outlook.com ([40.107.78.93]:26782
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728708AbfARSFd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 13:05:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=aampusa.onmicrosoft.com; s=selector1-aampglobal-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXfhKNpS9SkKA4hkmEasGzyjoISuiyRtYWY0g6jpF1g=;
 b=rif78wjl/KIkJNL2V55lUS8zbCRJDCiCqHUakf7jvt6N0JRJT2RxdGOrbEihwbt7oa+1SFCXoZ3OD3lJHAiIrdiUotktP0wF0cLXfAh6cyhl03nUAkzViN2hrIgkXQkR9NyBTooDPyv0savcgdfnUDgUl8zWiX76aQOnPLUz0rY=
Received: from DM5PR07MB4119.namprd07.prod.outlook.com (52.132.140.158) by
 DM5PR07MB3066.namprd07.prod.outlook.com (10.172.88.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.24; Fri, 18 Jan 2019 18:05:24 +0000
Received: from DM5PR07MB4119.namprd07.prod.outlook.com
 ([fe80::c0af:bc6f:3dd4:be07]) by DM5PR07MB4119.namprd07.prod.outlook.com
 ([fe80::c0af:bc6f:3dd4:be07%2]) with mapi id 15.20.1537.018; Fri, 18 Jan 2019
 18:05:24 +0000
From:   Ken Sloat <KSloat@aampglobal.com>
To:     "Eugen.Hristev@microchip.com" <Eugen.Hristev@microchip.com>
CC:     "mchehab@kernel.org" <mchehab@kernel.org>,
        "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "Ludovic.Desroches@microchip.com" <Ludovic.Desroches@microchip.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Topic: [PATCH v2 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Index: AQHUrzoN7XJuswIKkE+w1zxwJJXABKW1GOSAgAA2n1A=
Date:   Fri, 18 Jan 2019 18:05:23 +0000
Message-ID: <DM5PR07MB411967243FA1C96C1179071FAD9C0@DM5PR07MB4119.namprd07.prod.outlook.com>
References: <20190118142803.70160-1-ksloat@aampglobal.com>
 <20190118142803.70160-2-ksloat@aampglobal.com>
 <0c000df0-94ec-e8bf-e6b1-1a8a94170181@microchip.com>
In-Reply-To: <0c000df0-94ec-e8bf-e6b1-1a8a94170181@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=KSloat@aampglobal.com; 
x-originating-ip: [96.59.174.230]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR07MB3066;6:aMbSwahciCAHinmnZcV9ngDi2vmXDZPGbjmNCKXJ0tejF3b0YwYG7GcWPbHe0xhA+nGrhHt6F2MEEDmFfB1CSO+v2/1SqFyLnOSGhd6F94GqDbpyUqvBWXOtmHUgueAmTycxWgDNN04khivgJrlx2Y1jFDvdL5DqC3VP+kL1o80XEuvhfw+f1DuokJkQjJOvI04lXRi/U9b5/u4zXAJis1H9DvfblT/f6aCF5Zli7AVLVJk7xAiEwQRm/+Op/vgdgp+/bFWNzddLVTYK6aq/hUw+5rkUudC9XdQu0detcFJzF6zsX3TNpRlE+fTt/BC9JeO8a5e0BIvYz19PRmw8DeAsSJdc5cJOnZ9h5No1M7dA6ZS2+Tp/y8ZHNtqai7P3pXpZdSy8VMk9d5sRxriErqnXRmlagXqItDC3ByBcGT2xkN7/KyOJHIzez1x6tbYQHxeXzppasTJ5BDP24Npnvg==;5:BQFYA/wRQAcMSBNeS/wuVs2l8i4U0fu9ImLzy8XbALGHlBLqzZ2BMVny034sRygpp04lb7pf74QcmB1lhZELWaiwuR9YdD2IpKQFep3+Hxw+I7EhXeeLRwZcYy9fQedAYhe+DtrGlcs3e6HGsfAepOXl7Fm7SmDjpjZfE98tW2zQ2mW+jWwvfDOA0pdWb1Ge0mZtrOslI4lJmXxYIky6bA==;7:i4YefKem5izWdVnCKPBQ3kx/S7QP8HRE4pT63P0HvAwUFCtBwEfb/V8N0vrhL27gzZ7sIP/hidyaNT43s7o4rsccJjWhuw2ERhq9HhGXo98drw+7NDby5Gh2yB/DhOLZQadY4T5//N57wlwkN3OhuA==
x-ms-office365-filtering-correlation-id: 2bf9c01a-5586-43ae-04b9-08d67d6f84ac
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:DM5PR07MB3066;
x-ms-traffictypediagnostic: DM5PR07MB3066:
x-microsoft-antispam-prvs: <DM5PR07MB30661765D04BA7065A3D92B9AD9C0@DM5PR07MB3066.namprd07.prod.outlook.com>
x-forefront-prvs: 0921D55E4F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(346002)(366004)(376002)(396003)(136003)(13464003)(199004)(189003)(15650500001)(6916009)(86362001)(186003)(7736002)(6116002)(5640700003)(3846002)(476003)(72206003)(6436002)(102836004)(305945005)(55016002)(9686003)(106356001)(446003)(486006)(2501003)(11346002)(316002)(26005)(68736007)(2906002)(6506007)(53546011)(229853002)(33656002)(14454004)(5660300001)(6246003)(80792005)(97736004)(71190400001)(25786009)(54906003)(7696005)(2351001)(4326008)(71200400001)(81166006)(478600001)(81156014)(8676002)(74316002)(53936002)(105586002)(8936002)(99286004)(66066001)(256004)(76176011)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR07MB3066;H:DM5PR07MB4119.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aampglobal.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: boXcqcH2W5+LVfLrk95I4fgqFwPvRzyRIjLQNabQ2phF/UxVpCk2XbuKVnE6Xlxl7ltRzq7tIFusqJbk7AlEAoSkzqPuSQG4jfAvezAzWRcspOJ3fZOMeWRa2UblGuovTNuAw1yenupJsO+1ADTIM4axSjNTTsHWYPdc8XTQbCrNlTlAAS5L0NDovnhKzgBvBQskr8MWReHtlBotspzWqk8Uhp2Og/aP/yQAieLze1UI245LbqhgjZcUjqDWEi3Ng02v3+1wEDvd6snfiR1QRCN/h3w1MdFQpMxC8NMOuYhSRBrrmcl2SLbge3Y//g0qL+3W9/lWfM2fMZl/pmZfjiahs8fayjT7+TXaW+z8RlUCUT/UCIBXASpXdb2Xpe+er4iY4tRz+4EPmbE0xqIaYumaOsAUezq89r0gO5UGBjo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aampglobal.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bf9c01a-5586-43ae-04b9-08d67d6f84ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2019 18:05:23.8940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e20e3a66-8b9e-46e9-b859-cb654c1ec6ea
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR07MB3066
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: DM5PR07MB4119.namprd07.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-TransportTrafficSubType: 
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-originalclientipaddress: 96.59.174.230
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-transporttrafficsubtype: 
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: DM5PR07MB3066.namprd07.prod.outlook.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBFdWdlbi5IcmlzdGV2QG1pY3Jv
Y2hpcC5jb20gPEV1Z2VuLkhyaXN0ZXZAbWljcm9jaGlwLmNvbT4NCj4gU2VudDogRnJpZGF5LCBK
YW51YXJ5IDE4LCAyMDE5IDk6NDAgQU0NCj4gVG86IEtlbiBTbG9hdCA8S1Nsb2F0QGFhbXBnbG9i
YWwuY29tPg0KPiBDYzogbWNoZWhhYkBrZXJuZWwub3JnOyBOaWNvbGFzLkZlcnJlQG1pY3JvY2hp
cC5jb207DQo+IGFsZXhhbmRyZS5iZWxsb25pQGJvb3RsaW4uY29tOyBMdWRvdmljLkRlc3JvY2hl
c0BtaWNyb2NoaXAuY29tOyBsaW51eC0NCj4gbWVkaWFAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0
cmVlQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIDIvMl0gbWVkaWE6
IGF0bWVsLWlzYzogVXBkYXRlIGRldmljZSB0cmVlIGJpbmRpbmcNCj4gZG9jdW1lbnRhdGlvbg0K
PiANCj4gDQo+IA0KPiBPbiAxOC4wMS4yMDE5IDE2OjI4LCBLZW4gU2xvYXQgd3JvdGU6DQo+ID4g
RnJvbTogS2VuIFNsb2F0IDxrc2xvYXRAYWFtcGdsb2JhbC5jb20+DQo+ID4NCj4gPiBVcGRhdGUg
ZGV2aWNlIHRyZWUgYmluZGluZyBkb2N1bWVudGF0aW9uIHNwZWNpZnlpbmcgaG93IHRvIGVuYWJs
ZQ0KPiA+IEJUNjU2IHdpdGggQ1JDIGRlY29kaW5nLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTog
S2VuIFNsb2F0IDxrc2xvYXRAYWFtcGdsb2JhbC5jb20+DQo+ID4gLS0tDQo+ID4gICBDaGFuZ2Vz
IGluIHYyOg0KPiA+ICAgLVVzZSBjb3JyZWN0IG1lZGlhICJidXMtdHlwZSIgZHQgcHJvcGVydHku
DQo+ID4NCj4gPiAgIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9tZWRpYS9hdG1l
bC1pc2MudHh0IHwgNSArKysrKw0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygr
KQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9tZWRpYS9hdG1lbC1pc2MudHh0DQo+ID4gYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3MvbWVkaWEvYXRtZWwtaXNjLnR4dA0KPiA+IGluZGV4IGJiZTBlODdjNjE4OC4uMmQ0Mzc4
ZGZkNmM4IDEwMDY0NA0KPiA+IC0tLSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9tZWRpYS9hdG1lbC1pc2MudHh0DQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVl
L2JpbmRpbmdzL21lZGlhL2F0bWVsLWlzYy50eHQNCj4gPiBAQCAtMjEsNiArMjEsMTEgQEAgUmVx
dWlyZWQgcHJvcGVydGllcyBmb3IgSVNDOg0KPiA+ICAgLSBwaW5jdHJsLW5hbWVzLCBwaW5jdHJs
LTANCj4gPiAgIAlQbGVhc2UgcmVmZXIgdG8gcGluY3RybC1iaW5kaW5ncy50eHQuDQo+ID4NCj4g
PiArT3B0aW9uYWwgcHJvcGVydGllcyBmb3IgSVNDOg0KPiA+ICstIGJ1cy10eXBlDQo+ID4gKwlX
aGVuIHNldCB0byA2LCBCdC42NTYgZGVjb2RpbmcgKGVtYmVkZGVkIHN5bmMpIHdpdGggQ1JDIGRl
Y29kaW5nDQo+ID4gKwlpcyBlbmFibGVkLg0KPiA+ICsNCj4gDQo+IEkgZG9uJ3QgdGhpbmsgdGhp
cyBwYXRjaCBpcyByZXF1aXJlZCBhdCBhbGwgYWN0dWFsbHksIHRoZSBiaW5kaW5nIGNvbXBsaWVz
IHRvIHRoZQ0KPiB2aWRlby1pbnRlcmZhY2VzIGJ1cyBzcGVjaWZpY2F0aW9uIHdoaWNoIGluY2x1
ZGVzIHRoZSBwYXJhbGxlbCBhbmQgYnQuNjU2Lg0KPiANCj4gV291bGQgYmUgd29ydGggbWVudGlv
bmluZyBiZWxvdyBleHBsaWNpdGx5IHRoYXQgcGFyYWxsZWwgYW5kIGJ0LjY1NiBhcmUNCj4gc3Vw
cG9ydGVkLCBvciBhZGRlZCBhYm92ZSB0aGF0IGFsc28gcGxhaW4gcGFyYWxsZWwgYnVzIGlzIHN1
cHBvcnRlZCA/DQo+IA0KPiA+ICAgSVNDIHN1cHBvcnRzIGEgc2luZ2xlIHBvcnQgbm9kZSB3aXRo
IHBhcmFsbGVsIGJ1cy4gSXQgc2hvdWxkIGNvbnRhaW4NCj4gPiBvbmUNCj4gDQo+IGhlcmUgaW5z
aWRlIHRoZSBwcmV2aW91cyBsaW5lDQpIaSBFdWdlbiwNCg0KWWVzIGl0J3MgdHJ1ZSBhZGRpbmcg
bmV3IGRvY3VtZW50YXRpb24gaGVyZSBtYXkgYmUgb3ZlcmtpbGwsIGJ1dCB5ZXMgaXQgc2hvdWxk
IHNheSBzb21ldGhpbmcNCihhcyBhIHVzZXIgSSBhbHdheXMgZmluZCBpdCBoZWxwZnVsIGlmIHRo
ZSBkb2NzIGFyZSBtb3JlIHZlcmJvc2UgdGhhbiBub3QpLg0KDQpTbyBwZXIgeW91ciBzdWdnZXN0
aW9uLCBob3cgYWJvdXQgdGhlIHNpbXBsaWZpZWQ6DQoiSVNDIHN1cHBvcnRzIGEgc2luZ2xlIHBv
cnQgbm9kZSB3aXRoIHBhcmFsbGVsIGJ1cyBhbmQgb3B0aW9uYWxseSBCdC42NTYgc3VwcG9ydC4i
DQoNCmFuZCBJJ2xsIHJlbWl0IHRoZSBvdGhlciBzdGF0ZW1lbnRzLg0KDQo+ID4gICAncG9ydCcg
Y2hpbGQgbm9kZSB3aXRoIGNoaWxkICdlbmRwb2ludCcgbm9kZS4gUGxlYXNlIHJlZmVyIHRvIHRo
ZSBiaW5kaW5ncw0KPiA+ICAgZGVmaW5lZCBpbiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3MvbWVkaWEvdmlkZW8tDQo+IGludGVyZmFjZXMudHh0Lg0KPiA+DQoNClRoYW5rcywNCktl
bg0K
