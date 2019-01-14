Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E83C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 20:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64B9420659
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 20:28:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=aampusa.onmicrosoft.com header.i=@aampusa.onmicrosoft.com header.b="aCmFM0V7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfANU2W (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 15:28:22 -0500
Received: from mail-eopbgr690103.outbound.protection.outlook.com ([40.107.69.103]:18585
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726755AbfANU2W (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 15:28:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=aampusa.onmicrosoft.com; s=selector1-aampglobal-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xNoWj1DQ4khb8a5oOi9LnNN/1YpMAlg28Mj7wz0KmcM=;
 b=aCmFM0V7XO6r5ZWPwDOVZ818VWR0RNDcBlYrpWjoG7YHEbnveOqdwF7NBL40b35hPrf6VUf/U2QKWlVVEO3s2BHr0QeqRJmS7fbz3GoHOzsXzfinW4M+KcoEbDiTK8AuwC/BZDHa5OoLJtD5tzBfmWneQsq6atfjNlDsc2gOPmk=
Received: from BL0PR07MB4115.namprd07.prod.outlook.com (52.132.10.149) by
 BL0PR07MB5474.namprd07.prod.outlook.com (20.177.207.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.19; Mon, 14 Jan 2019 20:27:37 +0000
Received: from BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::c899:a193:f06c:cba7]) by BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::c899:a193:f06c:cba7%4]) with mapi id 15.20.1516.019; Mon, 14 Jan 2019
 20:27:37 +0000
From:   Ken Sloat <KSloat@aampglobal.com>
To:     "Eugen.Hristev@microchip.com" <Eugen.Hristev@microchip.com>
CC:     "mchehab@kernel.org" <mchehab@kernel.org>,
        "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "Ludovic.Desroches@microchip.com" <Ludovic.Desroches@microchip.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH v1 1/2] media: atmel-isc: Add support for BT656 with CRC
 decoding
Thread-Topic: [PATCH v1 1/2] media: atmel-isc: Add support for BT656 with CRC
 decoding
Thread-Index: AQHUns6/Mav1xniG5UimGV2/kOTXnaWjtE8AgAucQrA=
Date:   Mon, 14 Jan 2019 20:27:37 +0000
Message-ID: <BL0PR07MB4115EF29396DC3CB08FDDFF6AD800@BL0PR07MB4115.namprd07.prod.outlook.com>
References: <20181228165934.36393-1-ksloat@aampglobal.com>
 <79d76502-4fa6-d4fe-7922-9ea946edb6d9@microchip.com>
In-Reply-To: <79d76502-4fa6-d4fe-7922-9ea946edb6d9@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [96.59.174.230]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR07MB5474;6:eorsBWwMlcZCUnwGclGeWuld/u4/P5MnWs8Mwt/VboQmvUkY95m8wUTFy9oo9xpwAYQhPtYBNxTnv11/90Nf9TOunPIhPPXzL15f8OlpDnfPGurIpyxeMva1hGstA/XBN93tLUG5VHbVKQwN7apm+BkLwsk4e90uxDQOe9yEKO3n4pA/l4kqDLg7s/5zPLn89kvNd3yvTg7OPkX8a6l7hLXGdcuvv6JQQF8sqhOw40gCBjHNh8X5dSZ04N76wLNgMa3bcqEknMsg2tss68MzTK2Tv3UIJCwufCxe0sHm14hZFFpIcSQvoq0ggn3kOjf9HodoLQIOa6neQZwJxWaAQC0zrVCF88iW95I8/nZOaUh+JOsAAww5n+GeK6VfUx+KsADVK4IIovMWlTbSwIHiyUeoZo42QURhP5/BkD8NsVaxxiij039/tTR3bJQUvVo3YKR2Beo0SMoqnHwZuqdXpA==;5:IMxtFekWCSiGKLHHIUSGZ+1Chdxdk1xZj1dEBqDdB//r1lFoQ91hyjdQaXM3dj5iyshqpEyIAgjWVxbQhyaLWWKxoFsM9+aX5LQjkJpUmfD3yBBSn14BYCtPKxE4xd2zX2SgCMUYxdCSnhJIDehEktjxccND9negKXRfXAKeibio7kyhBL7PC1VmUWfAqh/5QLBsEocV+SrQ2iO0fRU1cA==;7:A5OtMMzln5y3/ipsv3uGO6wFdtsBBvEDQgtwrE5K7AmUfYMsUBvz0EExaohMfTGndIdj1BwIbPJUfg/vSEbDUjppDxm56P3fGSHqEmh4ozohl2sRUJeM5qARK7ePCifAEz3mANhySAdJTfty3U1AWQ==
x-ms-office365-filtering-correlation-id: f37a397d-cdd8-4a7e-b09f-08d67a5eb950
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR07MB5474;
x-ms-traffictypediagnostic: BL0PR07MB5474:
x-microsoft-antispam-prvs: <BL0PR07MB54741C7FA39228E503A448CCAD800@BL0PR07MB5474.namprd07.prod.outlook.com>
x-forefront-prvs: 0917DFAC67
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(346002)(136003)(39850400004)(396003)(199004)(189003)(86362001)(80792005)(2501003)(7696005)(6506007)(53546011)(6246003)(486006)(26005)(186003)(256004)(74316002)(3846002)(478600001)(72206003)(11346002)(71190400001)(71200400001)(6346003)(76176011)(102836004)(446003)(6116002)(97736004)(476003)(14444005)(81156014)(8936002)(5660300001)(5640700003)(2906002)(81166006)(106356001)(6916009)(229853002)(55016002)(9686003)(14454004)(33656002)(105586002)(2351001)(8676002)(66066001)(25786009)(4326008)(53936002)(316002)(305945005)(68736007)(54906003)(6436002)(99286004)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR07MB5474;H:BL0PR07MB4115.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aampglobal.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=KSloat@aampglobal.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XcD4KyQRcqHPjKsu3jDL74d8JmbggOjvFybKmhH8UJVm4QLTl6fpu3G1YUhOzyI96EbPAOyjcRJRs3lHpQ1xX/4tiqJLKamgcbTtGitASH05WPebKo+6OPKoumrmtoMyMVngHrh5u2v4jqHy2iDfyF1UVlyTN2VBbvxiNdAU4KtemUga4IiVvl2aEp1tCJ4BFkRCGIuen0WF3N4x7YgGHQibPQc9StEBTtFBCSqpeT1P7CBMPpEAgwjLR8tGGOuEqHUoqIeBvwGWEifMi+xZoywO33VqklPxR56SJ/+ilnfhtoPG0o8q9dqqkL9KIkt6SEzugs5NFUTT+/Vf5DiuywQ3YjCC0qo9JcJ3ChWZdyWe9kHJ/UBm5CRpSzsP9f7ZlYn3ijMV1j8j8yDMnnoZbd+7Noab1erjFlgexu8P0jU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aampglobal.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f37a397d-cdd8-4a7e-b09f-08d67a5eb950
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2019 20:27:37.3270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e20e3a66-8b9e-46e9-b859-cb654c1ec6ea
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR07MB5474
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
X-OrganizationHeadersPreserved: BL0PR07MB5474.namprd07.prod.outlook.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

PiBGcm9tOiBFdWdlbi5IcmlzdGV2QG1pY3JvY2hpcC5jb20gPEV1Z2VuLkhyaXN0ZXZAbWljcm9j
aGlwLmNvbT4NCj4gU2VudDogTW9uZGF5LCBKYW51YXJ5IDcsIDIwMTkgNjoxMCBBTQ0KPiBUbzog
S2VuIFNsb2F0IDxLU2xvYXRAYWFtcGdsb2JhbC5jb20+DQo+IENjOiBtY2hlaGFiQGtlcm5lbC5v
cmc7IE5pY29sYXMuRmVycmVAbWljcm9jaGlwLmNvbTsNCj4gYWxleGFuZHJlLmJlbGxvbmlAYm9v
dGxpbi5jb207IEx1ZG92aWMuRGVzcm9jaGVzQG1pY3JvY2hpcC5jb207IGxpbnV4LQ0KPiBtZWRp
YUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MSAxLzJdIG1lZGlhOiBh
dG1lbC1pc2M6IEFkZCBzdXBwb3J0IGZvciBCVDY1NiB3aXRoIENSQw0KPiBkZWNvZGluZw0KPiAN
Cj4gDQo+IA0KPiBPbiAyOC4xMi4yMDE4IDE4OjU5LCBLZW4gU2xvYXQgd3JvdGU6DQo+ID4gRnJv
bTogS2VuIFNsb2F0IDxrc2xvYXRAYWFtcGdsb2JhbC5jb20+DQo+ID4NCj4gPiBUaGUgSVNDIGRy
aXZlciBjdXJyZW50bHkgc3VwcG9ydHMgSVRVLVIgNjAxIGVuY29kaW5nIHdoaWNoIHV0aWxpemVz
DQo+ID4gdGhlIGV4dGVybmFsIGh5c3luYyBhbmQgdnN5bmMgc2lnbmFscy4gSVRVLVIgNjU2IGZv
cm1hdCByZW1vdmVzIHRoZQ0KPiA+IG5lZWQgZm9yIHRoZXNlIHBpbnMgYnkgZW1iZWRkaW5nIHRo
ZSBzeW5jIHB1bHNlcyB3aXRoaW4gdGhlIGRhdGENCj4gPiBwYWNrZXQuDQo+ID4NCj4gPiBUbyBz
dXBwb3J0IHRoaXMgZmVhdHVyZSwgZW5hYmxlIG5lY2Vzc2FyeSByZWdpc3RlciBiaXRzIHdoZW4g
dGhpcw0KPiA+IGZlYXR1cmUgaXMgZW5hYmxlZCB2aWEgZGV2aWNlIHRyZWUuDQo+ID4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBLZW4gU2xvYXQgPGtzbG9hdEBhYW1wZ2xvYmFsLmNvbT4NCj4gQWNrZWQt
Ynk6IEV1Z2VuIEhyaXN0ZXYgPGV1Z2VuLmhyaXN0ZXZAbWljcm9jaGlwLmNvbT4NCj4gDQo+IEFs
c28gZm9yIG15IHJlZmVyZW5jZSwgd2hpY2ggYm9hcmQgYW5kIHdoaWNoIHNlbnNvciBkaWQgeW91
IHRlc3QgdGhpcyB3aXRoID8NCj4gDQo+IFRoYW5rcw0KPiANCj4gPiAtLS0NCj4gPiAgIGRyaXZl
cnMvbWVkaWEvcGxhdGZvcm0vYXRtZWwvYXRtZWwtaXNjLXJlZ3MuaCB8IDIgKysNCj4gPiAgIGRy
aXZlcnMvbWVkaWEvcGxhdGZvcm0vYXRtZWwvYXRtZWwtaXNjLmMgICAgICB8IDcgKysrKysrLQ0K
PiA+ICAgMiBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4g
Pg0KDQpIaSBFdWdlbiwNCg0KU29ycnkgZm9yIG15IGRlbGF5ZWQgcmVwbHkuIEkgdGVzdGVkIHRo
aXMgd2l0aCBhIHR3OTk5MCBzZW5zb3IgY29ubmVjdGVkIHRvIGEgY3VzdG9tIGJvYXJkIGJhc2Vk
IG9uIHRoZSBTQU1BNUQyNy1TT00xLUVLMSBib2FyZC4NCg0KVGhhbmtzLA0KS2VuDQo=
