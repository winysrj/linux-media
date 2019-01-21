Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03188C282DE
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 07:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB6932084A
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 07:43:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="km06GWdA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbfAUHn3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:43:29 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:41306 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728474AbfAUHn2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 02:43:28 -0500
X-IronPort-AV: E=Sophos;i="5.56,502,1539673200"; 
   d="scan'208";a="25567471"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 21 Jan 2019 00:43:27 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 21 Jan 2019 00:43:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYezw/yPDQPNkoRgXGXLvHy/UySbhkOxxUA4Kq8OD9A=;
 b=km06GWdAvqHLP7xPmhfAed7b4YXIJvqZJ4qmyUmjRoQDNTnIHO8HrKiMtxcHUZsWO/w7sxuskTZNTD5+iktFw2LtwgN8ZBUvcRNy07wVGEEeecMnSUdIET2q7i7mlQEDvllajQokHnLzcnboHXv6vPTquPUNh8iF2L6NVDzyxqw=
Received: from DM5PR11MB1242.namprd11.prod.outlook.com (10.168.108.8) by
 DM5PR11MB1532.namprd11.prod.outlook.com (10.172.37.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.28; Mon, 21 Jan 2019 07:43:25 +0000
Received: from DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::4c19:f788:c2be:5e8f]) by DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::4c19:f788:c2be:5e8f%5]) with mapi id 15.20.1537.031; Mon, 21 Jan 2019
 07:43:25 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <KSloat@aampglobal.com>
CC:     <mchehab@kernel.org>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <Ludovic.Desroches@microchip.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Topic: [PATCH v2 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Index: AQHUrzoYUbNBT9P6U0ynPkBU6Yfu1qW1F7kAgAA6loCABAgLgA==
Date:   Mon, 21 Jan 2019 07:43:25 +0000
Message-ID: <3280bef8-e567-8dfb-e497-c365fa01609e@microchip.com>
References: <20190118142803.70160-1-ksloat@aampglobal.com>
 <20190118142803.70160-2-ksloat@aampglobal.com>
 <0c000df0-94ec-e8bf-e6b1-1a8a94170181@microchip.com>
 <DM5PR07MB411967243FA1C96C1179071FAD9C0@DM5PR07MB4119.namprd07.prod.outlook.com>
In-Reply-To: <DM5PR07MB411967243FA1C96C1179071FAD9C0@DM5PR07MB4119.namprd07.prod.outlook.com>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR0802CA0015.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::25) To DM5PR11MB1242.namprd11.prod.outlook.com
 (2603:10b6:3:14::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-tagtoolbar-keys: D20190121093913580
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR11MB1532;6:5RyJUX1eH5LGxMAEB+f5nvq770gnIPTgFBPBKLPIl/YTRfhmWY01nXM6LKwFVdZYns9NBHfhvDhjlAJni1nUguTP7QLgXwC4psqaANDrD4OQxc426dUBhVFDJ2zQFmQxtAeK+AhDr6LqqfUt3v2p/qlFw1c1CTOXDR8GVFs3EdeOXNAjXknU2h5vZSbJemsUAL7ua5mdSDmwPyS9srfvcAoSu8zTdGBSAOPVg16bwDRjqkbLhYucqhP4Rn/ZiNh39m/OVugOK6i6D1XJMLKRBnGRDVAvk/pisalICK8Fp9/xcjguuTQe5t12Y2+wR9MEXuF7wUBxYzZnEGXDc3DEiac1ocjn5CUvWHJV32wDFbQ/vjvvJk0kfaMK8rsXGYPghLda8Lpk5auwLTnIxwnD6xnHlYupLAA8BlKcJ2SJOWt+UV/8hI0bQOE6mPDUQ01bH73D0lgqvFRzP9mSgFbULA==;5:/vCJUZKrzeFeCTbAvzkYWt8sIIuxzV9PW7r7QtZG9hY77rADiNbFv4VIakzIoJc4+FUzpFVQO4ag6kEyJvKE/7GcFdWx80JuqT6jpwDApEgdD1+ezL7JSddxDLRfwRlKsI7f9fWwm6JAjaGVAdAHhoia0YCcCBQcPDA0W82f4+4AZbTMXlsXOWu/gIB2+85G5vpM8NacG2uBOIgm7R5Jrw==;7:5Y/TH3NFwh38yywFfZ904PbN3SbkVyR+kzxf95I3sclHAqQXC3I1Wxm/EjxD+6UU2Y7PUks92PBWOvfDPD8byhkqvBO822ubmFvY0LfFY61oFKP6E2jCKra03a0HzDlGC30q4xlvGV6ikuAFp5iaAg==
x-ms-office365-filtering-correlation-id: 73d15ef2-71a1-48dd-a625-08d67f742042
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:DM5PR11MB1532;
x-ms-traffictypediagnostic: DM5PR11MB1532:
x-microsoft-antispam-prvs: <DM5PR11MB1532EACC570C9503F775D8F3E89F0@DM5PR11MB1532.namprd11.prod.outlook.com>
x-forefront-prvs: 0924C6A0D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(346002)(396003)(376002)(136003)(199004)(189003)(13464003)(8936002)(68736007)(53936002)(36756003)(25786009)(316002)(97736004)(6486002)(31686004)(2906002)(15650500001)(6512007)(31696002)(54906003)(6246003)(66066001)(4326008)(486006)(81166006)(7736002)(86362001)(8676002)(81156014)(305945005)(229853002)(6116002)(93886005)(256004)(102836004)(71190400001)(6916009)(14444005)(478600001)(3846002)(6506007)(2616005)(186003)(105586002)(6436002)(106356001)(476003)(14454004)(99286004)(72206003)(76176011)(71200400001)(52116002)(11346002)(446003)(386003)(26005)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1532;H:DM5PR11MB1242.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wm7bKbx0NkeQ0CGXwP7Xros8naII8Ld/HPPZFeaxVVKE7FTiiUguctfrvjSi8TCHsK3vrpziRt+OdeT7qtTQl7cRA1vOxaPqYK/EG/DTVw0GwtxO63KkLDOMvrsehb/Rc7WQUXiGx06zyVi47it2xNb1LeN4LUvqDUalLgQICl/7s6hl6dSB7nL1O2pN9SMNu+ZRvOD98UGfJI2+E+BxSPKpugjLyMQHhc8nMVNZIXfdFMVOkOusOj5jonN3aooomCVGI2eC8hVEunihUD3GJA7FkWxSeRodYvkoYbyeGwR9XUm09vo6cIosA487VSalIKPyqKmGFWHlJRbXDleHlfY57D+vCuoOCpi15ldEbSy/bNcjKMyP17x3CJ2nn23aI/VzrEb2CunDeLhAeAWNGXZtWWQOM1DTkpCzmR6IDEE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <1140D1FE67E1044EBA8481FB02DABD0C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 73d15ef2-71a1-48dd-a625-08d67f742042
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2019 07:43:23.8873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1532
X-OriginatorOrg: microchip.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

DQoNCk9uIDE4LjAxLjIwMTkgMjA6MDUsIEtlbiBTbG9hdCB3cm90ZToNCj4+IC0tLS0tT3JpZ2lu
YWwgTWVzc2FnZS0tLS0tDQo+PiBGcm9tOiBFdWdlbi5IcmlzdGV2QG1pY3JvY2hpcC5jb20gPEV1
Z2VuLkhyaXN0ZXZAbWljcm9jaGlwLmNvbT4NCj4+IFNlbnQ6IEZyaWRheSwgSmFudWFyeSAxOCwg
MjAxOSA5OjQwIEFNDQo+PiBUbzogS2VuIFNsb2F0IDxLU2xvYXRAYWFtcGdsb2JhbC5jb20+DQo+
PiBDYzogbWNoZWhhYkBrZXJuZWwub3JnOyBOaWNvbGFzLkZlcnJlQG1pY3JvY2hpcC5jb207DQo+
PiBhbGV4YW5kcmUuYmVsbG9uaUBib290bGluLmNvbTsgTHVkb3ZpYy5EZXNyb2NoZXNAbWljcm9j
aGlwLmNvbTsgbGludXgtDQo+PiBtZWRpYUB2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdl
ci5rZXJuZWwub3JnDQo+PiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIDIvMl0gbWVkaWE6IGF0bWVs
LWlzYzogVXBkYXRlIGRldmljZSB0cmVlIGJpbmRpbmcNCj4+IGRvY3VtZW50YXRpb24NCj4+DQo+
Pg0KPj4NCj4+IE9uIDE4LjAxLjIwMTkgMTY6MjgsIEtlbiBTbG9hdCB3cm90ZToNCj4+PiBGcm9t
OiBLZW4gU2xvYXQgPGtzbG9hdEBhYW1wZ2xvYmFsLmNvbT4NCj4+Pg0KPj4+IFVwZGF0ZSBkZXZp
Y2UgdHJlZSBiaW5kaW5nIGRvY3VtZW50YXRpb24gc3BlY2lmeWluZyBob3cgdG8gZW5hYmxlDQo+
Pj4gQlQ2NTYgd2l0aCBDUkMgZGVjb2RpbmcuDQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBLZW4g
U2xvYXQgPGtzbG9hdEBhYW1wZ2xvYmFsLmNvbT4NCj4+PiAtLS0NCj4+PiAgICBDaGFuZ2VzIGlu
IHYyOg0KPj4+ICAgIC1Vc2UgY29ycmVjdCBtZWRpYSAiYnVzLXR5cGUiIGR0IHByb3BlcnR5Lg0K
Pj4+DQo+Pj4gICAgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21lZGlhL2F0bWVs
LWlzYy50eHQgfCA1ICsrKysrDQo+Pj4gICAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygr
KQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9tZWRpYS9hdG1lbC1pc2MudHh0DQo+Pj4gYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3MvbWVkaWEvYXRtZWwtaXNjLnR4dA0KPj4+IGluZGV4IGJiZTBlODdjNjE4OC4uMmQ0Mzc4
ZGZkNmM4IDEwMDY0NA0KPj4+IC0tLSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9tZWRpYS9hdG1lbC1pc2MudHh0DQo+Pj4gKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVl
L2JpbmRpbmdzL21lZGlhL2F0bWVsLWlzYy50eHQNCj4+PiBAQCAtMjEsNiArMjEsMTEgQEAgUmVx
dWlyZWQgcHJvcGVydGllcyBmb3IgSVNDOg0KPj4+ICAgIC0gcGluY3RybC1uYW1lcywgcGluY3Ry
bC0wDQo+Pj4gICAgCVBsZWFzZSByZWZlciB0byBwaW5jdHJsLWJpbmRpbmdzLnR4dC4NCj4+Pg0K
Pj4+ICtPcHRpb25hbCBwcm9wZXJ0aWVzIGZvciBJU0M6DQo+Pj4gKy0gYnVzLXR5cGUNCj4+PiAr
CVdoZW4gc2V0IHRvIDYsIEJ0LjY1NiBkZWNvZGluZyAoZW1iZWRkZWQgc3luYykgd2l0aCBDUkMg
ZGVjb2RpbmcNCj4+PiArCWlzIGVuYWJsZWQuDQo+Pj4gKw0KPj4NCj4+IEkgZG9uJ3QgdGhpbmsg
dGhpcyBwYXRjaCBpcyByZXF1aXJlZCBhdCBhbGwgYWN0dWFsbHksIHRoZSBiaW5kaW5nIGNvbXBs
aWVzIHRvIHRoZQ0KPj4gdmlkZW8taW50ZXJmYWNlcyBidXMgc3BlY2lmaWNhdGlvbiB3aGljaCBp
bmNsdWRlcyB0aGUgcGFyYWxsZWwgYW5kIGJ0LjY1Ni4NCj4+DQo+PiBXb3VsZCBiZSB3b3J0aCBt
ZW50aW9uaW5nIGJlbG93IGV4cGxpY2l0bHkgdGhhdCBwYXJhbGxlbCBhbmQgYnQuNjU2IGFyZQ0K
Pj4gc3VwcG9ydGVkLCBvciBhZGRlZCBhYm92ZSB0aGF0IGFsc28gcGxhaW4gcGFyYWxsZWwgYnVz
IGlzIHN1cHBvcnRlZCA/DQo+Pg0KPj4+ICAgIElTQyBzdXBwb3J0cyBhIHNpbmdsZSBwb3J0IG5v
ZGUgd2l0aCBwYXJhbGxlbCBidXMuIEl0IHNob3VsZCBjb250YWluDQo+Pj4gb25lDQo+Pg0KPj4g
aGVyZSBpbnNpZGUgdGhlIHByZXZpb3VzIGxpbmUNCj4gSGkgRXVnZW4sDQo+IA0KPiBZZXMgaXQn
cyB0cnVlIGFkZGluZyBuZXcgZG9jdW1lbnRhdGlvbiBoZXJlIG1heSBiZSBvdmVya2lsbCwgYnV0
IHllcyBpdCBzaG91bGQgc2F5IHNvbWV0aGluZw0KPiAoYXMgYSB1c2VyIEkgYWx3YXlzIGZpbmQg
aXQgaGVscGZ1bCBpZiB0aGUgZG9jcyBhcmUgbW9yZSB2ZXJib3NlIHRoYW4gbm90KS4NCj4gDQo+
IFNvIHBlciB5b3VyIHN1Z2dlc3Rpb24sIGhvdyBhYm91dCB0aGUgc2ltcGxpZmllZDoNCj4gIklT
QyBzdXBwb3J0cyBhIHNpbmdsZSBwb3J0IG5vZGUgd2l0aCBwYXJhbGxlbCBidXMgYW5kIG9wdGlv
bmFsbHkgQnQuNjU2IHN1cHBvcnQuIg0KPiANCj4gYW5kIEknbGwgcmVtaXQgdGhlIG90aGVyIHN0
YXRlbWVudHMuDQoNClRoYXQncyBmaW5lIHdpdGggbWUsIEkgd2lsbCBsZXQgUm9iIGhhdmUgaGlz
IG9waW5pb24gaGVhcmQgYXMgd2VsbC4NCg0KVGhhbmtzIGFnYWluLA0KDQpFdWdlbg0KDQo+IA0K
Pj4+ICAgICdwb3J0JyBjaGlsZCBub2RlIHdpdGggY2hpbGQgJ2VuZHBvaW50JyBub2RlLiBQbGVh
c2UgcmVmZXIgdG8gdGhlIGJpbmRpbmdzDQo+Pj4gICAgZGVmaW5lZCBpbiBEb2N1bWVudGF0aW9u
L2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvdmlkZW8tDQo+PiBpbnRlcmZhY2VzLnR4dC4NCj4+
Pg0KPiANCj4gVGhhbmtzLA0KPiBLZW4NCj4gDQo=
