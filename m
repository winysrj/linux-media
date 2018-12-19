Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 770B8C43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 07:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4682721841
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 07:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbeLSHEG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 02:04:06 -0500
Received: from mail-oln040092069089.outbound.protection.outlook.com ([40.92.69.89]:6302
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbeLSHEG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 02:04:06 -0500
Received: from AM5EUR02FT050.eop-EUR02.prod.protection.outlook.com
 (10.152.8.54) by AM5EUR02HT140.eop-EUR02.prod.protection.outlook.com
 (10.152.9.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1446.11; Wed, 19 Dec
 2018 07:04:02 +0000
Received: from AM0PR03MB4676.eurprd03.prod.outlook.com (10.152.8.58) by
 AM5EUR02FT050.mail.protection.outlook.com (10.152.9.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1446.11 via Frontend Transport; Wed, 19 Dec 2018 07:04:02 +0000
Received: from AM0PR03MB4676.eurprd03.prod.outlook.com
 ([fe80::f02a:2a6f:1b3b:ee3e]) by AM0PR03MB4676.eurprd03.prod.outlook.com
 ([fe80::f02a:2a6f:1b3b:ee3e%4]) with mapi id 15.20.1425.024; Wed, 19 Dec 2018
 07:04:02 +0000
From:   Jonas Karlman <jonas@kwiboo.se>
To:     Tomasz Figa <tfiga@chromium.org>,
        "hverkuil-cisco@xs4all.nl" <hverkuil-cisco@xs4all.nl>
CC:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        "Paul Kocialkowski" <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "nicolas@ndufresne.ca" <nicolas@ndufresne.ca>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: Re: [PATCHv5 6/8] vb2: add vb2_find_timestamp()
Thread-Topic: [PATCHv5 6/8] vb2: add vb2_find_timestamp()
Thread-Index: AQHUkheubL+OrDRAAUSQIXvjcD4iY6V7bRUAgAEthACACPNrAIAAIDQA
Date:   Wed, 19 Dec 2018 07:04:02 +0000
Message-ID: <AM0PR03MB467606D6C482F06F4E401767ACBE0@AM0PR03MB4676.eurprd03.prod.outlook.com>
References: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
 <20181212123901.34109-7-hverkuil-cisco@xs4all.nl>
 <AM0PR03MB4676988BC60352DFDFAD0783ACA70@AM0PR03MB4676.eurprd03.prod.outlook.com>
 <985a4c64-f914-8405-2a78-422bcd8f2139@xs4all.nl>
 <CAAFQd5BKizq20x+kyeH1nE1RUs9S2O7coQEXkPu6bCw8EAhmHA@mail.gmail.com>
In-Reply-To: <CAAFQd5BKizq20x+kyeH1nE1RUs9S2O7coQEXkPu6bCw8EAhmHA@mail.gmail.com>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR07CA0018.eurprd07.prod.outlook.com
 (2603:10a6:7:67::28) To AM0PR03MB4676.eurprd03.prod.outlook.com
 (2603:10a6:208:cc::33)
x-incomingtopheadermarker: OriginalChecksum:9170A15DDA7B6359DF2C587A5CC3042280BB8955A8C4E83C4BBF346F80E2CE31;UpperCasedChecksum:E351F8EFF7F92E6CA3F1A56B2B7B7714C24F3C87A4C86E22A1FA925F31703A6B;SizeAsReceived:8055;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [WhHyYysVm/NdV1dOrWcaxPiPva/+j9Sp]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM5EUR02HT140;6:jcajCd53z9RAnmlGgoQ/afYAh1V7PlXUPQyTfBkQ88X3VLUYfklINDcemMqI0wFiJxCDJUm1Bwqcp7Y29AvXsV1+PYbBmVOdzGDeI9JhFq8BNmnZrbRrlaB3+4UMepEWmDQBtB2/au01vUVTN9IO17xmeJ8i79tLraRdAIqZuBXieb0XleS6dUC2Y6+WmRxZihqVFRumXLnJBsLCXBvblZbv7WTqE4lBm+L8+v5lPICAZnFcFpuBMIV0KqIVEAATBcocPzyllhmAs3e8auc4fWFuGj8xqFU/MbOxH4dBfEbInE+OrbYlncfnZ1ODaeRmdh9ue02AkaVs5O1HT9RTe80jgQa+zKjogIt84UDJs8UC+8eh1eebIgb6Y+83nR9tQ/z+wiAyKkdMtfTO4p2P0CNg0CNfCNBu+iD7mlqFIDIYCEmlmzhdIQptXrnKGDCZtlphQQeA1dXvUXJyCuNOgA==;5:F1zk1Maf2reZoxfcRLCtf1q+6BCdpTqQir0W9NpSVoW2my740dsjtUnzca6R6j9vX2mAiMnERLaw0VCJu+VEWzQnJMf4lr24Ec5zw0j4QZYjg9YUmYHSbrui/+welVUsE9VvcDJc/d0mIDSA8GM459Feyq2gpLdzrBjhV1dyb/M=;7:aKjPIpNU3+oMH1rt4ojO1hztnmRSJpTqC1ynolXc3fmKCu9vjVmP5AyXSnxtMNT2JitNQS7O+LiiHrngOiEAqIfD4sBIH7481EimSIijW8vcOaubEf9XXwnypZjKHKWsG5Jpg32rOKMAyTm0tvoRwQ==
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:AM5EUR02HT140;
x-ms-traffictypediagnostic: AM5EUR02HT140:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:AM5EUR02HT140;BCL:0;PCL:0;RULEID:;SRVR:AM5EUR02HT140;
x-microsoft-antispam-message-info: tHB2CcAbv5dZz+4smfMyUimyJhOpJf8Sxz1ggxMauhKoOqo8juej3iRDGotnhnH3
Content-Type: text/plain; charset="utf-8"
Content-ID: <82B2C9B24BE2324194AB0A7D157F4DD2@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 54485d23-c432-40fe-8436-6091d627118c
X-MS-Exchange-CrossTenant-Network-Message-Id: 17b4340d-ab8c-4ff5-9886-08d6658026f0
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 54485d23-c432-40fe-8436-6091d627118c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2018 07:04:02.3279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5EUR02HT140
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

T24gMjAxOC0xMi0xOSAwNjoxMCwgVG9tYXN6IEZpZ2Egd3JvdGU6DQo+IE9uIFRodSwgRGVjIDEz
LCAyMDE4IGF0IDk6MjggUE0gSGFucyBWZXJrdWlsIDxodmVya3VpbC1jaXNjb0B4czRhbGwubmw+
IHdyb3RlOg0KPj4gT24gMTIvMTIvMTggNzoyOCBQTSwgSm9uYXMgS2FybG1hbiB3cm90ZToNCj4+
PiBIaSBIYW5zLA0KPj4+DQo+Pj4gU2luY2UgdGhpcyBmdW5jdGlvbiBvbmx5IHJldHVybiBERVFV
RVVFRCBhbmQgRE9ORSBidWZmZXJzLA0KPj4+IGl0IGNhbm5vdCBiZSB1c2VkIHRvIGZpbmQgYSBj
YXB0dXJlIGJ1ZmZlciB0aGF0IGlzIGJvdGggdXNlZCBmb3INCj4+PiBmcmFtZSBvdXRwdXQgYW5k
IGlzIHBhcnQgb2YgdGhlIGZyYW1lIHJlZmVyZW5jZSBsaXN0Lg0KPj4+IEUuZy4gYSBib3R0b20g
ZmllbGQgcmVmZXJlbmNpbmcgYSB0b3AgZmllbGQgdGhhdCBpcyBhbHJlYWR5DQo+Pj4gcGFydCBv
ZiB0aGUgY2FwdHVyZSBidWZmZXIgYmVpbmcgdXNlZCBmb3IgZnJhbWUgb3V0cHV0Lg0KPj4+ICh0
b3AgYW5kIGJvdHRvbSBmaWVsZCBpcyBvdXRwdXQgaW4gc2FtZSBidWZmZXIpDQo+Pj4NCj4+PiBK
ZXJuZWogxaBrcmFiZWMgYW5kIG1lIGhhdmUgd29ya2VkIGFyb3VuZCB0aGlzIGlzc3VlIGluIGNl
ZHJ1cyBkcml2ZXIgYnkNCj4+PiBmaXJzdCBjaGVja2luZw0KPj4+IHRoZSB0YWcvdGltZXN0YW1w
IG9mIHRoZSBjdXJyZW50IGJ1ZmZlciBiZWluZyB1c2VkIGZvciBvdXRwdXQgZnJhbWUuDQo+Pj4N
Cj4+Pg0KPj4+IC8vIGZpZWxkIHBpY3R1cmVzIG1heSByZWZlcmVuY2UgY3VycmVudCBjYXB0dXJl
IGJ1ZmZlciBhbmQgaXMgbm90DQo+Pj4gcmV0dXJuZWQgYnkgdmIyX2ZpbmRfdGFnDQo+Pj4gaWYg
KHY0bDJfYnVmLT50YWcgPT0gZHBiLT50YWcpDQo+Pj4gICAgIGJ1Zl9pZHggPSB2NGwyX2J1Zi0+
dmIyX2J1Zi5pbmRleDsNCj4+PiBlbHNlDQo+Pj4gICAgIGJ1Zl9pZHggPSB2YjJfZmluZF90YWco
Y2FwX3EsIGRwYi0+dGFnLCAwKTsNCj4+Pg0KPj4+DQo+Pj4gV2hhdCBpcyB0aGUgcmVjb21tZW5k
ZWQgd2F5IHRvIGhhbmRsZSBzdWNoIGNhc2U/DQo+PiBUaGF0IGlzIHRoZSByaWdodCBhcHByb2Fj
aCBmb3IgdGhpcy4gSW50ZXJlc3RpbmcgY29ybmVyIGNhc2UsIEkgaGFkbid0DQo+PiBjb25zaWRl
cmVkIHRoYXQuDQo+Pg0KPj4+IENvdWxkIHZiMl9maW5kX3RpbWVzdGFtcCBiZSBleHRlbmRlZCB0
byBhbGxvdyBRVUVVRUQgYnVmZmVycyB0byBiZSByZXR1cm5lZD8NCj4+IE5vLCBiZWNhdXNlIG9u
bHkgdGhlIGRyaXZlciBrbm93cyB3aGF0IHRoZSBjdXJyZW50IGJ1ZmZlciBpcy4NCj4+DQo+PiBC
dWZmZXJzIHRoYXQgYXJlIHF1ZXVlZCB0byB0aGUgZHJpdmVyIGFyZSBpbiBzdGF0ZSBBQ1RJVkUu
IEJ1dCB0aGVyZSBtYXkgYmUNCj4+IG11bHRpcGxlIEFDVElWRSBidWZmZXJzIGFuZCB2YjIgZG9l
c24ndCBrbm93IHdoaWNoIGJ1ZmZlciBpcyBjdXJyZW50bHkNCj4+IGJlaW5nIHByb2Nlc3NlZCBi
eSB0aGUgZHJpdmVyLg0KPj4NCj4+IFNvIHRoaXMgd2lsbCBoYXZlIHRvIGJlIGNoZWNrZWQgYnkg
dGhlIGRyaXZlciBpdHNlbGYuDQo+IEhvbGQgb24sIGl0J3MgYSBwZXJmZWN0bHkgdmFsaWQgdXNl
IGNhc2UgdG8gaGF2ZSB0aGUgYnVmZmVyIHF1ZXVlZCBidXQNCj4gc3RpbGwgdXNlZCBhcyBhIHJl
ZmVyZW5jZSBmb3IgcHJldmlvdXNseSBxdWV1ZWQgYnVmZmVycywgZS5nLg0KPg0KPiBRQlVGKE8s
IDApDQo+IFFCVUYoQywgMCkNCj4gUkVGKHJlZjAsIG91dF90aW1lc3RhbXAoMCkpDQo+IFFCVUYo
TywgMSkNCj4gUUJVRihDLCAxKQ0KPiBSRUYocmVmMCwgb3V0X3RpbWVzdGFtcCgwKSkNCj4gUUJV
RihPLCAyKQ0KPiBRQlVGKEMsIDIpDQo+IDwtIGRyaXZlciByZXR1cm5zIE8oMCkgYW5kIEMoMCkg
aGVyZQ0KPiA8LSB1c2Vyc3BhY2UgYWxzbyBrbm93cyB0aGF0IGFueSBuZXh0IGZyYW1lIHdpbGwg
bm90IHJlZmVyZW5jZSBDKDApIGFueW1vcmUNCj4gUkVGKHJlZjAsIG91dF90aW1lc3RhbXAoMikp
DQo+IFFCVUYoTywgMCkNCj4gUUJVRihDLCAwKQ0KPiA8LSBkcml2ZXIgbWF5IHBpY2sgTygxKStD
KDEpIG9yIE8oMikrQygyKSB0byBkZWNvZGUgaGVyZSwgYnV0IEMoMCkNCj4gd2hpY2ggaXMgdGhl
IHJlZmVyZW5jZSBmb3IgaXQgaXMgYWxyZWFkeSBRVUVVRUQuDQo+DQo+IEl0J3MgYSBwZXJmZWN0
bHkgZmluZSBzY2VuYXJpbyBhbmQgb3B0aW1hbCBmcm9tIHBpcGVsaW5pbmcgcG9pbnQgb2YNCj4g
dmlldywgYnV0IGlmIEknbSBub3QgbWlzc2luZyBzb21ldGhpbmcsIHRoZSBjdXJyZW50IHBhdGNo
IHdvdWxkbid0DQo+IGFsbG93IGl0Lg0KDQpUaGlzIHNjZW5hcmlvIHNob3VsZCBuZXZlciBoYXBw
ZW4gd2l0aCBGRm1wZWcgKyB2NGwycmVxdWVzdCBod2FjY2VsICsNCktvZGkgdXNlcnNwYWNlLg0K
RkZtcGVnIHdvdWxkIG9ubHkgUUJVRiBPKDApK0MoMCkgYWdhaW4gYWZ0ZXIgaXQgaGFzIGJlZW4g
cHJlc2VudGVkIG9uDQpzY3JlZW4gYW5kIEtvZGkgaGF2ZSByZWxlYXNlZCB0aGUgbGFzdCByZWZl
cmVuY2UgdG8gdGhlIEFWRnJhbWUuDQoNClRoZSB2NGwycmVxdWVzdCBod2FjY2VsIHdpbGwga2Vl
cCBhIEFWRnJhbWUgcG9vbCB3aXRoIHByZWFsbG9jYXRlZA0KZnJhbWVzLCBBVkZyYW1lKHgpIGlz
IGtlZXBpbmcgdXNlcnNwYWNlIHJlZiB0byBPKHgpK0MoeCkuDQpBbiBBVkZyYW1lIHdpbGwgbm90
IGJlIHJlbGVhc2VkIGJhY2sgdG8gdGhlIHBvb2wgdW50aWwgRkZtcGVnIGhhdmUNCnJlbW92ZWQg
aXQgZnJvbSBEUEIgYW5kIEtvZGkgaGF2ZSByZWxlYXNlZCBpdCBhZnRlciBpdCBubyBsb25nZXIg
aXMNCmJlaW5nIHByZXNlbnRlZCBvbiBzY3JlZW4uDQoNCkUuZy4gYW4gSVBCSVBCIHNlcXVlbnNl
IHdpdGggZGlzcGxheSBvcmRlciAwIDIgMSAzIDUgNA0KDQpGRm1wZWc6IEFWRnJhbWUoMCkNClFC
VUY6IE8oMCkrQygwKQ0KRFFCVUY6IE8oMCkrQygwKQ0KS29kaTogQVZGcmFtZSgwKSByZXR1cm5l
ZCBmcm9tIEZGbXBlZyBhbmQgcHJlc2VudGVkIG9uIHNjcmVlbg0KRkZtcGVnOiBBVkZyYW1lKDEp
IHdpdGggcmVmIHRvIEFWRnJhbWUoMCkNClFCVUY6IE8oMSkrQygxKSB3aXRoIHJlZiB0byB0aW1l
c3RhbXAoMCkNCkRRQlVGOiBPKDEpK0MoMSkNCkZGbXBlZzogQVZGcmFtZSgyKSB3aXRoIHJlZiB0
byBBVkZyYW1lKDApK0FWRnJhbWUoMSkNClFCVUY6IE8oMikrQygyKSB3aXRoIHJlZiB0byB0aW1l
c3RhbXAoMCkrdGltZXN0YW1wKDEpDQpEUUJVRjogTygyKStDKDIpDQpLb2RpOiBBVkZyYW1lKDIp
IHJldHVybmVkIGZyb20gRkZtcGVnIGFuZCBwcmVzZW50ZWQgb24gc2NyZWVuDQpLb2RpOiBBVkZy
YW1lKDApIHJlbGVhc2VkIChubyBsb25nZXIgcHJlc2VudGVkKQ0KRkZtcGVnOiBBVkZyYW1lKDMp
DQpRQlVGOiBPKDMpK0MoMykNCkRRQlVGOiBPKDMpK0MoMykNCktvZGk6IEFWRnJhbWUoMSkgcmV0
dXJuZWQgZnJvbSBGRm1wZWcgYW5kIHByZXNlbnRlZCBvbiBzY3JlZW4NCktvZGk6IEFWRnJhbWUo
MikgcmVsZWFzZWQgKG5vIGxvbmdlciBwcmVzZW50ZWQpDQpGRm1wZWc6IEFWRnJhbWUoMikgcmV0
dXJuZWQgdG8gcG9vbA0KRkZtcGVnOiBBVkZyYW1lKDIpIHdpdGggcmVmIHRvIEFWRnJhbWUoMykN
ClFCVUY6IE8oMikrQygyKSB3aXRoIHJlZiB0byB0aW1lc3RhbXAoMykNCkRRQlVGOiBPKDIpK0Mo
MikNCktvZGk6IEFWRnJhbWUoMykgcmV0dXJuZWQgZnJvbSBGRm1wZWcgYW5kIHByZXNlbnRlZCBv
biBzY3JlZW4NCktvZGk6IEFWRnJhbWUoMSkgcmVsZWFzZWQgKG5vIGxvbmdlciBwcmVzZW50ZWQp
DQpGRm1wZWc6IEFWRnJhbWUoMCkrQVZGcmFtZSgxKSByZXR1cm5lZCB0byBwb29sIChubyBsb25n
ZXIgcmVmZXJlbmNlZCkNCkZGbXBlZzogQVZGcmFtZSgwKSB3aXRoIHJlZiB0byBBVkZyYW1lKDMp
K0FWRnJhbWUoMikNClFCVUY6IE8oMCkrQygwKSB3aXRoIHJlZiB0byB0aW1lc3RhbXAoMykrdGlt
ZXN0YW1wKDIpDQpEUUJVRjogTygwKStDKDApDQpLb2RpOiBBVkZyYW1lKDApIHJldHVybmVkIGZy
b20gRkZtcGVnIGFuZCBwcmVzZW50ZWQgb24gc2NyZWVuDQpLb2RpOiBBVkZyYW1lKDMpIHJlbGVh
c2VkIChubyBsb25nZXIgcHJlc2VudGVkKQ0KYW5kIHNvIG9uDQoNCkhlcmUgd2UgY2FuIHNlZSB0
aGF0IE8oMCkrQygwKSB3aWxsIG5vdCBiZSBRQlVGIHVudGlsIGFmdGVyIEZGbXBlZyArDQpLb2Rp
IGhhdmUgcmVsZWFzZWQgYWxsIHVzZXJzcGFjZSByZWZzIHRvIEFWRnJhbWUoMCkuDQpBYm92ZSBl
eGFtcGxlIHdhcyBzaW1wbGlmaWVkLCBLb2RpIHdpbGwgbm9ybWFsbHkga2VlcCBhIGZldyBkZWNv
ZGVkDQpmcmFtZXMgaW4gYnVmZmVyIGJlZm9yZSBiZWluZyBwcmVzZW50ZWQgYW5kIEZGbXBlZyB3
aWxsIENSRUFURV9CVUYNCmFueXRpbWUgdGhlIHBvb2wgaXMgZW1wdHkgYW5kIG5ldyBPL0MgYnVm
ZmVycyBpcyBuZWVkZWQuDQoNClJlZ2FyZHMsDQpKb25hcw0KDQo+IEJlc3QgcmVnYXJkcywNCj4g
VG9tYXN6DQo=
