Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04AB3C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 20:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8A75206B7
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 20:31:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=aampusa.onmicrosoft.com header.i=@aampusa.onmicrosoft.com header.b="pZ0ukRyA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfANUbT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 15:31:19 -0500
Received: from mail-eopbgr750130.outbound.protection.outlook.com ([40.107.75.130]:24208
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726767AbfANUbT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 15:31:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=aampusa.onmicrosoft.com; s=selector1-aampglobal-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMURPP+omGj3e4SfDT6YXo1rb/6TL/A+0dV0d6QK2Wg=;
 b=pZ0ukRyAoYrrLM+WiPdQ2mNY+XJJv8lHXq31++TxidKFfVOugQwsCzodHicD+jLD835IV9gSw+8xYdT0MPlbK2cYMEs/t0SLdsBn9r5Y5t7NtIMvoLhMxFk3NCG12Z2pPyEFpZfFLWsTu42AQGtgF+/YU45by0sQ4Z5C1nGudKg=
Received: from BL0PR07MB4115.namprd07.prod.outlook.com (52.132.10.149) by
 BL0PR07MB4114.namprd07.prod.outlook.com (52.132.10.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.16; Mon, 14 Jan 2019 20:31:13 +0000
Received: from BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::c899:a193:f06c:cba7]) by BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::c899:a193:f06c:cba7%4]) with mapi id 15.20.1516.019; Mon, 14 Jan 2019
 20:31:12 +0000
From:   Ken Sloat <KSloat@aampglobal.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        "eugen.hristev@microchip.com" <eugen.hristev@microchip.com>
CC:     "mchehab@kernel.org" <mchehab@kernel.org>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH v1 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Topic: [PATCH v1 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Index: AQHUns6/77kEGvPCikSLFo8p0P0NrKWlcvsAgAAAW4CACd5m0A==
Date:   Mon, 14 Jan 2019 20:31:12 +0000
Message-ID: <BL0PR07MB41155378F76D8B47A4FE79F7AD800@BL0PR07MB4115.namprd07.prod.outlook.com>
References: <20181228165934.36393-1-ksloat@aampglobal.com>
 <20181228165934.36393-2-ksloat@aampglobal.com>
 <fd9073b4-7625-6f91-546e-9dad0bf6201f@xs4all.nl>
 <0be61a88-93c9-6181-b0ea-b1048c98e0e1@xs4all.nl>
In-Reply-To: <0be61a88-93c9-6181-b0ea-b1048c98e0e1@xs4all.nl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=KSloat@aampglobal.com; 
x-originating-ip: [96.59.174.230]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR07MB4114;6:pjmVJTkMSICDkBOWT974G3q+TyOEAFRO2SpC2x3KYRAWO1AJn0FCzlXq6QCT3TJfU7RWD3Q0wtndEqW3IQMcgTu3MGUQoWPDZYxecLMkFGIh0qb1bPUsq/eeTwmTg3G1GSRcRbcZSGyFf+vP6ttS09Qql6HIbd92BmkSelqwtrHT6GwXf9qRXUS6uIPAA7315w2/o9dMBHmm6AI7J8bEHeq1/3lJ55p5wvuKA6Z/UAq1U0Om06HazyOOx2KgfC7Hgjxk4OW5ZprUxYXDn3xafCLYZIPBcSGj/POthaFCmLbq80HtZYE6DPF+Ym4qJ9REo8XcsxLu74M6DWEL3Z9bQsNraiofd6KP3d5wZ1x8i/iKJf9XLnr++fkfXSgcW/fFJK8iknRMezxXGHxgO8QgDKWzowoCDDyasPqPPhZx0NHAlv+vNc0kkpk5wzja1qmYZiI55QjgxDk/b/Tqq4dEqA==;5:G3HE9BBl39hqu8NhgcbwYR9NE2KJk53cojKy+ML70hvDrzeiWjJUP3diLZPs6GpDz/P1cwlmBcsehomc46GNCnnOxqewfBSuKD8VRJ74OozdKofNfrUprx2UjvJ+e9q8X5b6gu7qqSvo1NBAA6RV5WBkd6JXVAwIrUI/y7d2zA6rzMI1uFvUSHkpVGqh7fSIsN0AOVn0vYOF7V8odZ9nig==;7:mROXL0uu51waEq+k36Fzb4e/O4N19e0Q+O+DmKAa8g9FbhUk2GGnIYT4WpzW1BCg4mgmwgGa+WXdoSh79/RU1GlHVTaMw1wbRXogR+i29kNLEEJTP6qWfDXjnF0Eh43Q/2O3dcQJNAO8j7csHZqN4Q==
x-ms-office365-filtering-correlation-id: 512ff549-2676-4a4b-7e81-08d67a5f39cb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR07MB4114;
x-ms-traffictypediagnostic: BL0PR07MB4114:
x-microsoft-antispam-prvs: <BL0PR07MB4114271F1E7F6D67A1FF0626AD800@BL0PR07MB4114.namprd07.prod.outlook.com>
x-forefront-prvs: 0917DFAC67
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(39840400004)(396003)(136003)(366004)(189003)(199004)(97736004)(80792005)(9686003)(14444005)(26005)(6436002)(256004)(74316002)(186003)(4326008)(2501003)(15650500001)(86362001)(6506007)(6246003)(53546011)(66066001)(53936002)(2906002)(25786009)(102836004)(5660300001)(110136005)(316002)(7696005)(54906003)(76176011)(478600001)(7736002)(72206003)(68736007)(305945005)(8936002)(105586002)(476003)(106356001)(446003)(11346002)(99286004)(229853002)(14454004)(93886005)(71200400001)(71190400001)(486006)(6116002)(33656002)(81166006)(3846002)(8676002)(55016002)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR07MB4114;H:BL0PR07MB4115.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aampglobal.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CJ9YP+ADkWhSCo4TQDK4BF7j0psxfIPVZxFfdGIrwD/xKaW7LoHAz43GhxxPEE7g37LREWo3PnfIWNq2PT8ZerLs1qMhFpYVUmepUjvNSTuO0GLeQqVriGU3yRGrnD1z1cbv8s1cWAT73GJ6OiRBslwpzbrg9GgyYPEpv5p5d+9wdKk/gVfISFPJI5BJoZBMuQD5ptXxpZIt470zthULjQHNeYNPH5c4nz35AHISfJvpYFVAgZ0t1O6HC5cXtzO6UMYovRjdZh28SqsryldVTpD/nC4CCNV5iwUf86iIByBVzbzCM/d64Gk57Enm2FRrztJ/u+sdi5wx06SlSsVsFHOSMbRILbMo1h4sYzB3SbnNcXDbidd/0noBErKc5MUbEtrOpxJYWfGdzDzwMruN4CGpXErau0NHMrCZhBBg+J0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aampglobal.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 512ff549-2676-4a4b-7e81-08d67a5f39cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2019 20:31:12.8812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e20e3a66-8b9e-46e9-b859-cb654c1ec6ea
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR07MB4114
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: BL0PR07MB4115.namprd07.prod.outlook.com
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
X-OrganizationHeadersPreserved: BL0PR07MB4114.namprd07.prod.outlook.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

PiBGcm9tOiBIYW5zIFZlcmt1aWwgPGh2ZXJrdWlsQHhzNGFsbC5ubD4NCj4gU2VudDogVHVlc2Rh
eSwgSmFudWFyeSA4LCAyMDE5IDg6NDYgQU0NCj4gVG86IEtlbiBTbG9hdCA8S1Nsb2F0QGFhbXBn
bG9iYWwuY29tPjsgZXVnZW4uaHJpc3RldkBtaWNyb2NoaXAuY29tDQo+IENjOiBtY2hlaGFiQGtl
cm5lbC5vcmc7IG5pY29sYXMuZmVycmVAbWljcm9jaGlwLmNvbTsNCj4gYWxleGFuZHJlLmJlbGxv
bmlAYm9vdGxpbi5jb207IGx1ZG92aWMuZGVzcm9jaGVzQG1pY3JvY2hpcC5jb207IGxpbnV4LQ0K
PiBtZWRpYUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MSAyLzJdIG1l
ZGlhOiBhdG1lbC1pc2M6IFVwZGF0ZSBkZXZpY2UgdHJlZSBiaW5kaW5nDQo+IGRvY3VtZW50YXRp
b24NCj4gDQo+IE9uIDAxLzA4LzE5IDE0OjQ0LCBIYW5zIFZlcmt1aWwgd3JvdGU6DQo+ID4gT24g
MTIvMjgvMTggMTc6NTksIEtlbiBTbG9hdCB3cm90ZToNCj4gPj4gRnJvbTogS2VuIFNsb2F0IDxr
c2xvYXRAYWFtcGdsb2JhbC5jb20+DQo+ID4+DQo+ID4+IFVwZGF0ZSBkZXZpY2UgdHJlZSBiaW5k
aW5nIGRvY3VtZW50YXRpb24gc3BlY2lmeWluZyBob3cgdG8gZW5hYmxlDQo+ID4+IEJUNjU2IHdp
dGggQ1JDIGRlY29kaW5nLg0KPiA+Pg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBLZW4gU2xvYXQgPGtz
bG9hdEBhYW1wZ2xvYmFsLmNvbT4NCj4gPj4gLS0tDQo+ID4+ICBEb2N1bWVudGF0aW9uL2Rldmlj
ZXRyZWUvYmluZGluZ3MvbWVkaWEvYXRtZWwtaXNjLnR4dCB8IDMgKysrDQo+ID4+ICAxIGZpbGUg
Y2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+ID4+DQo+ID4+IGRpZmYgLS1naXQgYS9Eb2N1bWVu
dGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvYXRtZWwtaXNjLnR4dA0KPiA+PiBiL0Rv
Y3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9tZWRpYS9hdG1lbC1pc2MudHh0DQo+ID4+
IGluZGV4IGJiZTBlODdjNjE4OC4uZTc4N2VkZWVhN2RhIDEwMDY0NA0KPiA+PiAtLS0gYS9Eb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvYXRtZWwtaXNjLnR4dA0KPiA+PiAr
KysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvYXRtZWwtaXNjLnR4
dA0KPiA+PiBAQCAtMjUsNiArMjUsOSBAQCBJU0Mgc3VwcG9ydHMgYSBzaW5nbGUgcG9ydCBub2Rl
IHdpdGggcGFyYWxsZWwgYnVzLg0KPiA+PiBJdCBzaG91bGQgY29udGFpbiBvbmUgICdwb3J0JyBj
aGlsZCBub2RlIHdpdGggY2hpbGQgJ2VuZHBvaW50JyBub2RlLg0KPiA+PiBQbGVhc2UgcmVmZXIg
dG8gdGhlIGJpbmRpbmdzICBkZWZpbmVkIGluDQo+IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy9tZWRpYS92aWRlby1pbnRlcmZhY2VzLnR4dC4NCj4gPj4NCj4gPj4gK0lmIGFsbCBl
bmRwb2ludCBidXMgZmxhZ3MgKGkuZS4gaHN5bmMtYWN0aXZlKSBhcmUgb21pdHRlZCwgdGhlbg0K
PiA+PiArQ0NJUjY1NiBkZWNvZGluZyAoZW1iZWRkZWQgc3luYykgd2l0aCBDUkMgZGVjb2Rpbmcg
aXMgZW5hYmxlZC4NCj4gPg0KPiA+IFNvcnJ5LCB0aGlzIGlzIHdyb25nLiBUaGVyZSBpcyBhIGJ1
cy10eXBlIHByb3BlcnR5IGRlZmluZWQgaW4NCj4gPiB2aWRlby1pbnRlcmZhY2VzLnR4dCB0aGF0
IHlvdSBzaG91bGQgdXNlIHRvIGRldGVybWluZSB3aGV0aGVyIHRoaXMgaXMgYQ0KPiBwYXJhbGxl
bCBvciBhIEJ0LjY1NiBidXMuDQo+IA0KPiBBY3R1YWxseSwgdGhhdCdzIHdoYXQgeW91ciBjb2Rl
IGFscmVhZHkgZG9lcywgc28gaXQgc2VlbXMgdGhpcyB0ZXh0IGluIHRoZQ0KPiBiaW5kaW5ncyBk
b2MgaXMganVzdCBwbGFpbiB3cm9uZy4NCj4gDQo+IAlIYW5zDQo+IA0KPiA+DQo+ID4gQlRXLCBm
b3IgdjIgYWxzbyBDQyB0aGlzIHRvIGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnLCBzaW5jZSBp
dCBoYXMNCj4gPiB0byBiZSByZXZpZXdlZCBieSB0aGUgRFQgbWFpbnRhaW5lcnMuDQo+ID4NCj4g
PiBSZWdhcmRzLA0KPiA+DQo+ID4gCUhhbnMNCj4gPg0KPiA+PiArDQo+ID4+ICBFeGFtcGxlOg0K
PiA+PiAgaXNjOiBpc2NAZjAwMDgwMDAgew0KPiA+PiAgCWNvbXBhdGlibGUgPSAiYXRtZWwsc2Ft
YTVkMi1pc2MiOw0KPiA+Pg0KPiA+DQoNCkhpIEhhbnMsDQoNCk15IGFwb2xvZ2llcyB5b3UgYXJl
IGNvcnJlY3QuIFRoZSB3YXkgSSBkb2N1bWVudGVkIGl0IGhlcmUgd2FzIHRoZSBvbGQgd2F5IG9m
IGRvaW5nIGl0IGluIHRoZSBrZXJuZWwgYnV0IHN0aWxsIHdvcmtlZCBmb3IgbXkgc2V0dXAgYXMg
aXQgYXBwZWFycyB0aGUgdjRsMiBzdWJzeXN0ZW0gc3RpbGwgbWFrZXMgdGhlIGFzc3VtcHRpb24g
b2YgNjU2IG1vZGUgaWYgdGhlc2UgZmxhZ3MgYXJlIGFsbCBvbWl0dGVkLiBJIHdpbGwgdXBkYXRl
IHdpdGggdGhlIHByb3BlciAiYnVzLXR5cGUiIHByb3BlcnR5IGFuZCByZXN1Ym1pdCBoZXJlIGNv
cHlpbmcgdGhlIGR0IGxpc3QgYXMgd2VsbC4NCg0KVGhhbmtzLA0KS2VuDQoNCg==
