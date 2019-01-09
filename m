Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F0BC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 13:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C24820665
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 13:07:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="i+r2m2pt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbfAINHM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 08:07:12 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:12611 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729603AbfAINHL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 08:07:11 -0500
X-IronPort-AV: E=Sophos;i="5.56,457,1539673200"; 
   d="scan'208";a="25104845"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Jan 2019 06:07:10 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Wed, 9 Jan 2019 06:07:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+gBv1zSqp2gZfuvWSW7T2W4nask9PLQeN2EcB7r5dM=;
 b=i+r2m2ptA/L/A02atSjhDft3B6EVC0UyCqEvnQLsoLZziZNe5P67f6/1m9NXtOyrhVoapyPIK/fig1Y2XyvFU+FVXkqwY8ffLJ0GVau9UxYvxTEdaqhEbekXOixRfCiqhGHE0rxq5XN+J/ryiNe2fGcurTKOWE9dpbMkRlb4SFo=
Received: from DM5PR11MB1242.namprd11.prod.outlook.com (10.168.108.8) by
 DM5PR11MB1914.namprd11.prod.outlook.com (10.175.87.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.9; Wed, 9 Jan 2019 13:07:06 +0000
Received: from DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::d41b:896d:ae28:5a57]) by DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::d41b:896d:ae28:5a57%12]) with mapi id 15.20.1495.011; Wed, 9 Jan 2019
 13:07:06 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <luis.oliveira@synopsys.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <joao.pinto@synopsys.com>, <festevam@gmail.com>,
        <mchehab@kernel.org>, <gregkh@linuxfoundation.org>,
        <davem@davemloft.net>, <akpm@linux-foundation.org>,
        <arnd@arndb.de>, <hans.verkuil@cisco.com>,
        <laurent.pinchart@ideasonboard.com>, <geert@linux-m68k.org>,
        <narmstrong@baylibre.com>, <p.zabel@pengutronix.de>,
        <treding@nvidia.com>, <maxime.ripard@bootlin.com>,
        <todor.tomov@linaro.org>
Subject: Re: [V3, 4/4] media: platform: dwc: Add MIPI CSI-2 controller driver
Thread-Topic: [V3, 4/4] media: platform: dwc: Add MIPI CSI-2 controller driver
Thread-Index: AQHUqBuhCcv9szjWl0qFFgx76hUWpA==
Date:   Wed, 9 Jan 2019 13:07:06 +0000
Message-ID: <4db76eb2-460f-c644-6dbd-370b07b2def8@microchip.com>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
 <1539953556-35762-5-git-send-email-lolivei@synopsys.com>
In-Reply-To: <1539953556-35762-5-git-send-email-lolivei@synopsys.com>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR07CA0171.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::19) To DM5PR11MB1242.namprd11.prod.outlook.com
 (2603:10b6:3:14::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR11MB1914;6:iEQF/B5oC+3JqNo3mWZ2pye4zMwE827NDmhBZasRkH2ekPVcPUmPjJMIyniT/vlsaCiW09m0BdIuAcwlO5TA70tJ+7mgm4b5OYqrRarOCYHTowtshRAWM/QiRuQpOsNP/FINSX9E/BmMgcWn2sCAhqakESFPub5fVSrDJxAvLUsIs/NfLAqpsw/3Ifw7BIRxHgpO/eNLI6fcDzX59mCKhbknt+QbOEBOer8Vd9+LOz3EeO1PqPTm59xpqxr3s6KtGTSew2PR2DAo0tBjMB/upgIXzk5RX6etOUnqwKh6DHhYs4EcNYSMh8lnFuW5iefbX97PQ/2gZuW+VnTfztlVYaUBJxzAncnxiFZsnAlL9rKriOpfw/78YBitJKkrdSXZd+iBvgA+P0vBbAz/kZOFpoQFER2E8tMYvc62BANyRuOtgFfR7+vt3QaTWpnmVWjUO8NYzenYLPrcTvdUK73ZYQ==;5:swE8vRAa4z0kH79Pfz6G/aOI9ONhqvzbDVdYN+2x8lwPqTpUhspMhDb1hClfGHaAhhJrdAMdB0ku3mcR0pzIap7sVULCAr5wUo43h/vfganPffVKUHxuAlAOEy/bRSDWKSB/JNNL5MyhnXC7vQSpgETwlomjasSnPPVn3iucJk2wfg5Q3tjiAQ5OfcZT6izvSEgd03WFe4dlIFldurk8aA==;7:dUXJacNefxbWqP2G2Amob1Fi7JtGQRQ/vLLBEL8bGdBEwgJyqheacDkbHP4P68lrxSB+5sdi4Dc+Pc0f0DFfdj28TEF4w5FmKqxOX3/lQBlT/iav7C6M+GGVgm992ATeU3V9QkLMAH992MHNMBI8lA==
x-ms-office365-filtering-correlation-id: 02cf984d-74c4-4f5c-bbfb-08d676335aec
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:DM5PR11MB1914;
x-ms-traffictypediagnostic: DM5PR11MB1914:
x-microsoft-antispam-prvs: <DM5PR11MB19140995ABBE77C1FEA77975E88B0@DM5PR11MB1914.namprd11.prod.outlook.com>
x-forefront-prvs: 0912297777
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(376002)(346002)(39860400002)(54534003)(199004)(189003)(106356001)(36756003)(305945005)(52116002)(105586002)(25786009)(11346002)(31686004)(3846002)(6116002)(2616005)(476003)(446003)(2906002)(256004)(4326008)(6246003)(53936002)(186003)(102836004)(26005)(6506007)(6512007)(39060400002)(386003)(53546011)(76176011)(14444005)(7736002)(2501003)(7416002)(478600001)(31696002)(54906003)(86362001)(110136005)(68736007)(8936002)(97736004)(6486002)(99286004)(66066001)(316002)(72206003)(6436002)(486006)(8676002)(81156014)(229853002)(5660300001)(71200400001)(71190400001)(2201001)(14454004)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1914;H:DM5PR11MB1242.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /0HUnnBrHTp6S1PyKBjrrEVJ+tXXqEplXdyxlb8H0HJVQIH5x4nuO6w9e3LKGj0q5r9RqG9cRMCJgJSWeBT0le46tMLp27HmMhwjPRqrYnxtGwCQOM0LONZw9bgJJ1vlF5s39e60wz3wZzJHzZcwwkUet2r59fo/vh7r4eLB01tAe25+oHi4W/or9Ua1NxTAskxdVdRODz5AeHBmBD2kW0++duTv2KzIjQ9u8f6cMIZczcZq8HZ94hvxOyLh7DuE1PRNNm5Z8cNKgfHAXvLzaoZgzN7hS+3cuCqLasRc9LepohIttz8aZvUTlQTQg6GI
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4E8609EE337F8499315817F1C172486@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 02cf984d-74c4-4f5c-bbfb-08d676335aec
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 13:07:06.3189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1914
X-OriginatorOrg: microchip.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

DQoNCk9uIDE5LjEwLjIwMTggMTU6NTIsIEx1aXMgT2xpdmVpcmEgd3JvdGU6DQo+IEFkZCB0aGUg
U3lub3BzeXMgTUlQSSBDU0ktMiBjb250cm9sbGVyIGRyaXZlci4gVGhpcw0KPiBjb250cm9sbGVy
IGRyaXZlciBpcyBkaXZpZGVkIGluIHBsYXRmb3JtIGRlcGVuZGVudCBmdW5jdGlvbnMNCj4gYW5k
IGNvcmUgZnVuY3Rpb25zLiBJdCBhbHNvIGluY2x1ZGVzIGEgcGxhdGZvcm0gZm9yIGZ1dHVyZQ0K
PiBEZXNpZ25XYXJlIGRyaXZlcnMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBMdWlzIE9saXZlaXJh
IDxsb2xpdmVpQHN5bm9wc3lzLmNvbT4NCj4gLS0tDQo+IENoYW5nZWxvZw0KPiB2Mi1WMw0KPiAt
IGV4cG9zZWQgSVBJIHNldHRpbmdzIHRvIHVzZXJzcGFjZQ0KPiAtIGZpeGVkIGhlYWRlcnMNCj4g
DQo+ICAgTUFJTlRBSU5FUlMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAxMSArDQo+
ICAgZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9kd2MvS2NvbmZpZyAgICAgICB8ICAzMCArLQ0KPiAg
IGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vZHdjL01ha2VmaWxlICAgICAgfCAgIDIgKw0KPiAgIGRy
aXZlcnMvbWVkaWEvcGxhdGZvcm0vZHdjL2R3LWNzaS1wbGF0LmMgfCA2OTkgKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKw0KPiAgIGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vZHdjL2R3LWNz
aS1wbGF0LmggfCAgNzcgKysrKw0KPiAgIGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vZHdjL2R3LW1p
cGktY3NpLmMgfCA0OTQgKysrKysrKysrKysrKysrKysrKysrKw0KPiAgIGRyaXZlcnMvbWVkaWEv
cGxhdGZvcm0vZHdjL2R3LW1pcGktY3NpLmggfCAyMDIgKysrKysrKysrDQo+ICAgaW5jbHVkZS9t
ZWRpYS9kd2MvZHctbWlwaS1jc2ktcGx0ZnJtLmggICB8IDEwMiArKysrKw0KPiAgIDggZmlsZXMg
Y2hhbmdlZCwgMTYxNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ICAgY3JlYXRlIG1v
ZGUgMTAwNjQ0IGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vZHdjL2R3LWNzaS1wbGF0LmMNCj4gICBj
cmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9kd2MvZHctY3NpLXBsYXQu
aA0KPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21lZGlhL3BsYXRmb3JtL2R3Yy9kdy1t
aXBpLWNzaS5jDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0v
ZHdjL2R3LW1pcGktY3NpLmgNCj4gICBjcmVhdGUgbW9kZSAxMDA2NDQgaW5jbHVkZS9tZWRpYS9k
d2MvZHctbWlwaS1jc2ktcGx0ZnJtLmgNCj4gDQoNCltzbmlwXQ0KDQo+ICsvKiBWaWRlbyBmb3Jt
YXRzIHN1cHBvcnRlZCBieSB0aGUgTUlQSSBDU0ktMiAqLw0KPiArY29uc3Qgc3RydWN0IG1pcGlf
Zm10IGR3X21pcGlfY3NpX2Zvcm1hdHNbXSA9IHsNCj4gKwl7DQo+ICsJCS8qIFJBVyA4ICovDQo+
ICsJCS5jb2RlID0gTUVESUFfQlVTX0ZNVF9TQkdHUjhfMVg4LA0KPiArCQkuZGVwdGggPSA4LA0K
PiArCX0sDQo+ICsJew0KPiArCQkvKiBSQVcgMTAgKi8NCj4gKwkJLmNvZGUgPSBNRURJQV9CVVNf
Rk1UX1NCR0dSMTBfMlg4X1BBREhJX0JFLA0KPiArCQkuZGVwdGggPSAxMCwNCj4gKwl9LA0KDQpI
aSBMdWlzLA0KDQpBbnkgcmVhc29uIHdoeSBSQVcxMiBmb3JtYXQgaXMgbm90IGhhbmRsZWQgaGVy
ZSA/DQoNCkhlcmUsIG5hbWVseSBNRURJQV9CVVNfRk1UX1NCR0dSMTJfMVgxMiBldGMuDQoNCj4g
Kwl7DQo+ICsJCS8qIFJHQiA1NjUgKi8NCj4gKwkJLmNvZGUgPSBNRURJQV9CVVNfRk1UX1JHQjU2
NV8yWDhfQkUsDQo+ICsJCS5kZXB0aCA9IDE2LA0KPiArCX0sDQo+ICsJew0KPiArCQkvKiBCR1Ig
NTY1ICovDQo+ICsJCS5jb2RlID0gTUVESUFfQlVTX0ZNVF9SR0I1NjVfMlg4X0xFLA0KPiArCQku
ZGVwdGggPSAxNiwNCj4gKwl9LA0KPiArCXsNCj4gKwkJLyogUkdCIDg4OCAqLw0KPiArCQkuY29k
ZSA9IE1FRElBX0JVU19GTVRfUkdCODg4XzJYMTJfTEUsDQo+ICsJCS5kZXB0aCA9IDI0LA0KPiAr
CX0sDQo+ICsJew0KPiArCQkvKiBCR1IgODg4ICovDQo+ICsJCS5jb2RlID0gTUVESUFfQlVTX0ZN
VF9SR0I4ODhfMlgxMl9CRSwNCj4gKwkJLmRlcHRoID0gMjQsDQo+ICsJfSwNCj4gK307DQoNCltz
bmlwXQ0KDQo+ICsNCj4gK3ZvaWQgZHdfbWlwaV9jc2lfc2V0X2lwaV9mbXQoc3RydWN0IG1pcGlf
Y3NpX2RldiAqY3NpX2RldikNCj4gK3sNCj4gKwlzdHJ1Y3QgZGV2aWNlICpkZXYgPSBjc2lfZGV2
LT5kZXY7DQo+ICsNCj4gKwlpZiAoY3NpX2Rldi0+aXBpX2R0KQ0KPiArCQlkd19taXBpX2NzaV93
cml0ZShjc2lfZGV2LCByZWcuSVBJX0RBVEFfVFlQRSwgY3NpX2Rldi0+aXBpX2R0KTsNCj4gKwll
bHNlIHsNCj4gKwkJc3dpdGNoIChjc2lfZGV2LT5mbXQtPmNvZGUpIHsNCj4gKwkJY2FzZSBNRURJ
QV9CVVNfRk1UX1JHQjU2NV8yWDhfQkU6DQo+ICsJCWNhc2UgTUVESUFfQlVTX0ZNVF9SR0I1NjVf
Mlg4X0xFOg0KPiArCQkJZHdfbWlwaV9jc2lfd3JpdGUoY3NpX2RldiwNCj4gKwkJCQkJcmVnLklQ
SV9EQVRBX1RZUEUsIENTSV8yX1JHQjU2NSk7DQo+ICsJCQlkZXZfZGJnKGRldiwgIkRUOiBSR0Ig
NTY1Iik7DQo+ICsJCQlicmVhazsNCj4gKw0KPiArCQljYXNlIE1FRElBX0JVU19GTVRfUkdCODg4
XzJYMTJfTEU6DQo+ICsJCWNhc2UgTUVESUFfQlVTX0ZNVF9SR0I4ODhfMlgxMl9CRToNCj4gKwkJ
CWR3X21pcGlfY3NpX3dyaXRlKGNzaV9kZXYsDQo+ICsJCQkJCXJlZy5JUElfREFUQV9UWVBFLCBD
U0lfMl9SR0I4ODgpOw0KPiArCQkJZGV2X2RiZyhkZXYsICJEVDogUkdCIDg4OCIpOw0KPiArCQkJ
YnJlYWs7DQo+ICsJCWNhc2UgTUVESUFfQlVTX0ZNVF9TQkdHUjEwXzJYOF9QQURISV9CRToNCj4g
KwkJCWR3X21pcGlfY3NpX3dyaXRlKGNzaV9kZXYsDQo+ICsJCQkJCXJlZy5JUElfREFUQV9UWVBF
LCBDU0lfMl9SQVcxMCk7DQo+ICsJCQlkZXZfZGJnKGRldiwgIkRUOiBSQVcgMTAiKTsNCj4gKwkJ
CWJyZWFrOw0KPiArCQljYXNlIE1FRElBX0JVU19GTVRfU0JHR1I4XzFYODoNCj4gKwkJCWR3X21p
cGlfY3NpX3dyaXRlKGNzaV9kZXYsDQo+ICsJCQkJCXJlZy5JUElfREFUQV9UWVBFLCBDU0lfMl9S
QVc4KTsNCj4gKwkJCWRldl9kYmcoZGV2LCAiRFQ6IFJBVyA4Iik7DQo+ICsJCQlicmVhazsNCg0K
U2FtZSBoZXJlLCBpbiBDU0lfMl9SQVcxMiBjYXNlIGl0IHdpbGwgZGVmYXVsdCB0byBhIFJHQjU2
NSBjYXNlLg0KDQpUaGFua3MsDQoNCkV1Z2VuDQoNCg0KDQo+ICsJCWRlZmF1bHQ6DQo+ICsJCQlk
d19taXBpX2NzaV93cml0ZShjc2lfZGV2LA0KPiArCQkJCQlyZWcuSVBJX0RBVEFfVFlQRSwgQ1NJ
XzJfUkdCNTY1KTsNCj4gKwkJCWRldl9kYmcoZGV2LCAiRXJyb3IiKTsNCj4gKwkJCWJyZWFrOw0K
PiArCQl9DQo+ICsJfQ0KPiArfQ0KPiArDQoNCltzbmlwXQ0K
