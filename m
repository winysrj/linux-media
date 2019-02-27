Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA64C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 13:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2651C2075B
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 13:31:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="tXm292nH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730114AbfB0NbU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 08:31:20 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:63063 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbfB0NbU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 08:31:20 -0500
X-IronPort-AV: E=Sophos;i="5.58,419,1544511600"; 
   d="scan'208";a="24537647"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 27 Feb 2019 06:31:19 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Wed, 27 Feb 2019 06:31:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pDpE1ysHnDDOJh1VVKba8tHhJWm1Yvd8z8c3nv4dlRg=;
 b=tXm292nH/gJqvWD5m7ndi5E1WYWi6ggBRcE0J/+wt2u/uSPaDApJcUXkewzcuceiQ95vo+ioSd+41v99br6uAVqXk9meCgDpv8ROy4bwwTzxGOaK+hD6DVL/K+V89jQJeXyPGCeqIozAXxuszkqsiQgO5/XBhWSjjL56iucWzMc=
Received: from DM5PR11MB1242.namprd11.prod.outlook.com (10.168.108.8) by
 DM5PR11MB0076.namprd11.prod.outlook.com (10.164.155.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.21; Wed, 27 Feb 2019 13:31:17 +0000
Received: from DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::e831:aee7:13c0:96b1]) by DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::e831:aee7:13c0:96b1%8]) with mapi id 15.20.1643.019; Wed, 27 Feb 2019
 13:31:16 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <loic.poulain@linaro.org>
CC:     <linux-media@vger.kernel.org>, <sakari.ailus@linux.intel.com>,
        <slongerbeam@gmail.com>
Subject: Re: Issues with ov5640 sensor
Thread-Topic: Issues with ov5640 sensor
Thread-Index: AQHUw3Jx2JdilSb8mk2RiQMZep4Qz6Xda9wAgBZNeQA=
Date:   Wed, 27 Feb 2019 13:31:16 +0000
Message-ID: <fa696e08-daa9-c3d5-e94b-0de0bed4113c@microchip.com>
References: <633027a3-b6a9-4cf0-b1a8-9e4dbe3c824e@microchip.com>
 <CAMZdPi9OC7Exp=0mBJT-BusYm=fMj8=hVo80sJeSvpWdqRmwqg@mail.gmail.com>
In-Reply-To: <CAMZdPi9OC7Exp=0mBJT-BusYm=fMj8=hVo80sJeSvpWdqRmwqg@mail.gmail.com>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR0401CA0014.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::24) To DM5PR11MB1242.namprd11.prod.outlook.com
 (2603:10b6:3:14::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-tagtoolbar-keys: D20190227152658955
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: acd14562-d0a4-474e-df59-08d69cb7d9bc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:DM5PR11MB0076;
x-ms-traffictypediagnostic: DM5PR11MB0076:
x-microsoft-exchange-diagnostics: =?utf-8?B?MTtETTVQUjExTUIwMDc2OzIzOitFVllqQUIzM2RZMVc0NEVpQVdyRmJLVWNw?=
 =?utf-8?B?VUxnZFBMYzNXOVFObHJQTFVIL0I0TnRXWG1PK0d4aXh4VEltRjQ1RElRTXdC?=
 =?utf-8?B?VnpUSHU1Z0tDOUdURG5ZbHIzNzN6dGFyNUtMVzIvQzBoTlJWcUVDckQ4blpY?=
 =?utf-8?B?Si9NL3g3TWRWRSttcmZzalZRV09JNnNtazVoaXNuSTExSjB3OUdiMEl3anpY?=
 =?utf-8?B?QVhDby9OdHJMZlo0MHk5UEtJMm1nV2tZQ3FLZjE2VVU5NXNSbjdZQ1BORW9i?=
 =?utf-8?B?UDNhQks0WVdpVlJ0Rml5QkxwVVZUSDl6UWJFZlhWY0F5REZTS2xzVnFBMExY?=
 =?utf-8?B?QW5sUkdYbmlQb0dpRUhqY21rdkdObjZQVFVDQ2JBakJxYUJCTUZyK09UMnVp?=
 =?utf-8?B?QzUvQVI2QUoyYUVHSUFjTU1sWThCcDA5Zk94RmMxRmhOcWFhZ3VkUVdaU21B?=
 =?utf-8?B?a0ZiaHFBOFpKY0ZEN1RTZWZOTFFNZyszczRjY1I2cTNucGJmaEs0TlpaeHUy?=
 =?utf-8?B?QkFHNzE2NytRNExRYVRKejdoM285eFVhTjFuampzSTlOd3hnQXhtN2ZyVUxp?=
 =?utf-8?B?UDdRM1FJR3U2WkVYdXRkVmVGT1lWeEFoa2t2eFNoeGRUU2dCV2FUQkhDRVFy?=
 =?utf-8?B?VVdlRGFRVEdhR0E5Qi9kYnk1WjZ4cTBuYjFkUzdrL1N4MjQxTXMzOE1seWdk?=
 =?utf-8?B?bGtnckluYVZUNTNoNm9wUlVpTVFUSTlZaXQ1cXFyTjJwVjA5dzR0WEJqMEZJ?=
 =?utf-8?B?YUpuSUV2dWk1aEpxb09XdUJXZXRzVHJod3cvdFdabjRLNmxKWStsYURrMzI0?=
 =?utf-8?B?YVlvdFo5T3ZaUWlObGFuaXArM3VWTUV0SXFPMTlLdklVS1RKMDVieUh3Umxi?=
 =?utf-8?B?a2JGY1JxSktDYVhqT21kN3poc2dwL25UUVdoclYrUk5wcGx3VytBMFVwaHRM?=
 =?utf-8?B?TVZCQklvZVNkeHZBUzgzVkt4ZGFUeFpRRHJvck1RQUhTZ0JqbWZpOER3VDVz?=
 =?utf-8?B?K0pCRmUzYzREZjBzcVhDYlkzRkNwd2FDc0tNSUpqZW9lSVgxN0ZQSTdhaVlT?=
 =?utf-8?B?S00zWGVKcEYzbFpLMzdrWndEMkc1V281YUE3d1dVL0ZZVk44MmdWSTkxU2p5?=
 =?utf-8?B?V0o2eGJyYmJ4WnYxazFQRlJTUGNhaElPdEQxY3B0OXJPSVFPNTZTMXA1MXor?=
 =?utf-8?B?TEpSeWoxT25EVmZzd1RRVWJtZmpCUEtaTXkzVkpmUjNRYnB2bDhXd21BTmZt?=
 =?utf-8?B?ZGs3dWJ1ZW1kR2cyUVorM1A4c2tURlRlRDRWUVlYVEVNZ1oyYUlBUjhTdHh5?=
 =?utf-8?B?RytSVndZUzhBdXA2a2tJaTNEQ0lOUnBhZWluY05HdXdneGdLOE1nUVNtQzJw?=
 =?utf-8?B?TG5JTXpqdFIzYnVlYk53ZWY2RFlXck9ZM21kemcrV0syY1pIZ0Q5azN5VEdY?=
 =?utf-8?B?eVVvUmpaSUlBcU5KdXBZZ2Q5OXdEY1RnbGpPb002UStXWnVIODFJZWNiWFVF?=
 =?utf-8?B?djJaZ09nRVduNGNOVGhmT3lPQ0dKR2h6S0lmellzVWRvMFlNTXJhb25uLzhH?=
 =?utf-8?B?Y0tZWUZXUFdEdDBJYkg1QXY3VlBYbXlCekU3NDJVQkpGWVFHMk9tSXJORGlG?=
 =?utf-8?B?dTJ2ZHVNUTgzZGw2a3NIZnozOTBLOE5jNWFBcmRQeDFUTVN3aU55eEt4U3NS?=
 =?utf-8?B?RzAra2F0RTBJV0NzdGoxQXBhbCtzLzdFSFZ3N1htUXRqeUxReEFkbC85YXhH?=
 =?utf-8?B?anA2OFNScGc1L1puYWdCdz09?=
x-microsoft-antispam-prvs: <DM5PR11MB007670BB07EC9B6F365CA0A2E8740@DM5PR11MB0076.namprd11.prod.outlook.com>
x-forefront-prvs: 0961DF5286
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(376002)(396003)(39860400002)(346002)(199004)(189003)(2906002)(81166006)(478600001)(7736002)(6116002)(486006)(3846002)(54906003)(81156014)(8676002)(316002)(26005)(71200400001)(305945005)(102836004)(6436002)(71190400001)(6486002)(229853002)(186003)(6506007)(53546011)(386003)(8936002)(2616005)(11346002)(36756003)(446003)(476003)(5660300002)(66066001)(31686004)(14454004)(72206003)(6512007)(105586002)(86362001)(106356001)(4326008)(6916009)(53936002)(97736004)(31696002)(99286004)(76176011)(256004)(68736007)(25786009)(52116002)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB0076;H:DM5PR11MB1242.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bE32zT4Gl1eOY3+QUQ3icVK2ijgE9FpiIN3FHihoNyKy3+XQtcTG1q5YA/nmmwVEYkzj2w0ZcVZqYEgHjzsDCjcW8DzqKmgwokzwpguArFt5Rh9GBpjHDuSag6ZIDiFxhxbLdkuFf/vQR/OWrLkALtCVl6rHqm70ab8eoAwM9fmh6qo7AJG3Q+Mfst3gJCv6NBwyNaMq65kgYlRXBzEeyoeum1+Bvly0Uxz+bSL+Rj0ytRdFl4iH1D6UyJ/63K4KSrHLzXJgfkbeT10d9ABM1dbYuyBoowlndS4HpEm+qFotzVIML0UWJcC00GqoYdCY+2T6anMK3d76cCKDon1sw2YIGdXtqw10XgVvFg7nVtKb0Kj3+dlxITrHRncbnx6kJ4xQqrS2KZNv11RT/Yh992TPDTxHhNXeslJGtO+Ekv8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B6D8574AD6D954DB861524F345C45B7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: acd14562-d0a4-474e-df59-08d69cb7d9bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2019 13:31:15.0413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB0076
X-OriginatorOrg: microchip.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

DQoNCk9uIDEzLjAyLjIwMTkgMTA6NTEsIExvaWMgUG91bGFpbiB3cm90ZToNCj4gSGkgRXVnZW4s
DQo+IA0KPiBPbiBXZWQsIDEzIEZlYiAyMDE5IGF0IDA5OjAyLCA8RXVnZW4uSHJpc3RldkBtaWNy
b2NoaXAuY29tPiB3cm90ZToNCj4+DQo+PiBIZWxsbyBMb2ljLA0KPj4NCj4+IEkgYW0gdHJ5aW5n
IHRvIG1ha2Ugc2Vuc29yIE9tbml2aXNpb24gb3Y1NjQwIHdvcmsgd2l0aCBvdXIgQXRtZWwtaXNj
DQo+PiBjb250cm9sbGVyLCBJIHNhdyB5b3UgaW1wbGVtZW50ZWQgUkFXIG1vZGUgZm9yIHRoaXMg
c2Vuc29yIGluIHRoZQ0KPj4gZHJpdmVyLCBzbyBJIHdhcyBob3BpbmcgSSBjYW4gYXNrIHlvdSBz
b21lIHRoaW5nczoNCj4+DQo+PiBJIGNhbm5vdCBtYWtlIHRoZSBSQVcgYmF5ZXIgZm9ybWF0IHdv
cmssIEJBODEgLyBtYnVzDQo+PiBNRURJQV9CVVNfRk1UX1NCR0dSOF8xWDggbWFrZXMgdGhlIHBo
b3RvIGxvb2sgbGlrZSBhIG1hemUgb2YgY29sb3JzLi4uDQo+Pg0KPj4gVGhlIHNlbnNvciB3b3Jr
cyBmb3IgbWUgaW4gWVVZViBhbmQgUkdCNTY1IG1vZGUsIHNvIEkgYXNzdW1lIHRoZSB3aXJpbmcN
Cj4+IGlzIGRvbmUgY29ycmVjdGx5IGZvciBteSBzZXR1cA0KPj4NCj4+IEFueXRoaW5nIHNwZWNp
YWwgSSBuZWVkIHRvIGRvIGZvciB0aGlzIGZvcm1hdCB0byB3b3JrID8NCj4gDQo+IEkgZGVmaW5p
dGVseSBuZWVkIHRvIGNoZWNrIHdpdGggdGhlIGxhdGVzdCBkcml2ZXIgdmVyc2lvbiwgbWFueQ0K
PiBjaGFuZ2VzIGhhdmUgYmVlbiBpbnRlZ3JhdGVkIHJlY2VudGx5LCBpbmNsdWRpbmcgY2xvY2sN
Cj4gYXV0b2NvbmZpZ3VyYXRpb24uDQo+IE1vcmVvdmVyLCBBRkFJVSwgeW91IGFyZSBjb25uZWN0
ZWQgdmlhIHRoZSBwYXJhbGxlbCBpbnRlcmZhY2UsIEkgb25seQ0KPiB0ZXN0ZWQgd2l0aCBNSVBJ
L0NTSS4NCg0KSGkgTG9pYywNCg0KVGhhbmtzIGZvciB5b3VyIHJlcGx5LA0KDQpZZXMgSSBhbSB1
c2luZyBwYXJhbGxlbCBpbnRlcmZhY2UuDQoNCk9uZSBxdWVzdGlvbjogaGF2ZSB5b3UgdHJpZWQg
b3RoZXIgcmVzb2x1dGlvbnMgdGhhbiA2NDB4NDgwID8gNjQweDQ4MCANCndvcmtzIHdlbGwgZm9y
IG1lLCAxMjgweDcyMCBnaXZlcyBvdXQgaW1hZ2UsIGJ1dCBpdCdzIHRvdGFsbHkgZ2FyYmxlZCwg
DQphbmQgaGlnaGVyIHJlc29sdXRpb25zIGRvbid0IHdvcmsgYXQgYWxsIDogdGhlcmUgaXMgbm8g
dnN5bmMgZGV0ZWN0ZWQgb24gDQp0aGUgbGluZSB3aGF0c29ldmVyLi4uDQoNCk9yIHBlcmhhcHMg
YW55b25lIGVsc2UgdXNpbmcgdGhpcyBzZW5zb3IgKGRyaXZlcikgaW4gYW55IGNvbmZpZ3VyYXRp
b24gPw0KDQo+IEkgd291bGQgc3VnZ2VzdCB5b3UgYWRkaW5nIGRlYnVnIGluIHRoZSBvdjU2NDAg
ZHJpdmVyIHRvIHJldHJpZXZlDQo+IGNhbGN1bGF0ZWQgcGNsaywgc3lzY2xrLCBldGMuLi4NCj4g
QWxzbyB0aGUgZm9sbG93aW5nIGxpbmVzIGRvZXMnbnQgbG9vayBjb3JyZWN0IGFueW1vcmU6DQo+
IA0KPiAgICAgIC8qDQo+ICAgICAgICogQWxsIHRoZSBmb3JtYXRzIHdlIHN1cHBvcnQgaGF2ZSAx
NiBiaXRzIHBlciBwaXhlbCwgc2VlbXMgdG8gcmVxdWlyZQ0KPiAgICAgICAqIHRoZSBzYW1lIHJh
dGUgdGhhbiBZVVYsIHNvIHdlIGNhbiBqdXN0IHVzZSAxNiBicHAgYWxsIHRoZSB0aW1lLg0KPiAg
ICAgICAqLw0KPiAgICAgIHJhdGUgPSBtb2RlLT52dG90ICogbW9kZS0+aHRvdCAqIDE2Ow0KPiAg
ICAgIHJhdGUgKj0gb3Y1NjQwX2ZyYW1lcmF0ZXNbc2Vuc29yLT5jdXJyZW50X2ZyXTsNCj4gDQo+
IFdpdGggUkFXOCwgd2UgaGF2ZSA4IGJpdHMgcGVyIHBpeGVsLCBtYXliZSBpdCB3b3VsZCB3b3J0
aCBmb3IgdGVzdGluZw0KPiBwdXJwb3NlIHRvIGNoYW5nZSAxNiB0byA4IGFuZCBzZWUgd2hhdCBo
YXBwZW5zLg0KDQpJIGNhbiBjaGVjayBpdCBvdXQuDQoNCj4gDQo+Pg0KPj4gVGhlIHNhbWUgUkFX
IEJBWUVSIGNvbmZpZ3VyYXRpb24gd29ya3MgZm9yIG1lIG9uIG92NzY3MCBmb3IgZXhhbXBsZS4u
Lg0KPj4NCj4+IFVucmVsYXRlZDogYXJlIHlvdSBmYW1pbGlhciB3aXRoIG92Nzc0MCA/IFRoaXMg
c2Vuc29yIGxvb2tzIHRvIGhhdmUNCj4+IHN0b3BwZWQgd29ya2luZyBpbiBsYXRlc3QgbWVkaWF0
cmVlIDogZmFpbGVkIHRvIGVuYWJsZSBzdHJlYW1pbmcuDQo+PiAod29ya2VkIHBlcmZlY3RseSBp
biBsYXN0IHN0YWJsZSBmb3IgbWUgLSA0LjE0Li4uKQ0KPiANCj4gTm8gc29ycnkuDQo+IA0KPiAN
Cj4gUmVnYXJkcywNCj4gTG9pYw0KPiANCg==
