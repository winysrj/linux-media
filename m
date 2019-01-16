Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2302BC43612
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 07:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7F592082F
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 07:10:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="PZF+/LsF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388404AbfAPHKW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 02:10:22 -0500
Received: from mail-eopbgr710073.outbound.protection.outlook.com ([40.107.71.73]:54016
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731056AbfAPHKW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 02:10:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyUYZi4k9RghHGWuyXwu5SnS2JgHuuNu8hbx7ThvUIM=;
 b=PZF+/LsFiBGAwYUKyE+1rWuUiHUUkLNuXD2FwBpD6k+uqeEdRDeCH+proGimgOZFR9gKKodyoBjFibsXo8N4+WCUMP6gE32QSFyOn3aUs3Hz1EoaZtEdPr6s1HPcoM3Qg+1P26f2ilEKd3RWMTwyzSP98Ff15Rx+1OlCyN9pwrw=
Received: from BYAPR05MB5592.namprd05.prod.outlook.com (20.177.186.153) by
 BYAPR05MB5670.namprd05.prod.outlook.com (20.177.186.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.17; Wed, 16 Jan 2019 07:09:37 +0000
Received: from BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::4a1:2561:2487:5919]) by BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::4a1:2561:2487:5919%4]) with mapi id 15.20.1537.018; Wed, 16 Jan 2019
 07:09:37 +0000
From:   Thomas Hellstrom <thellstrom@vmware.com>
To:     "hch@lst.de" <hch@lst.de>,
        "Christian.Koenig@amd.com" <Christian.Koenig@amd.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yong.zhi@intel.com" <yong.zhi@intel.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "bingbu.cao@intel.com" <bingbu.cao@intel.com>,
        "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>,
        "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Thread-Topic: [PATCH] lib/scatterlist: Provide a DMA page iterator
Thread-Index: AQHUpH3T+Rn6hCeN4kq6RDaSbJgsYKWpM0MAgAVgfACAAd1XAIAAAhqAgAAPhoCAAC2UgIAAB86AgAALooCAAB1KgIAAqt+A
Date:   Wed, 16 Jan 2019 07:09:37 +0000
Message-ID: <01e5522bf88549bfdaea1430fece23cb3d1a1a55.camel@vmware.com>
References: <20190104223531.GA1705@ziepe.ca>     <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
         <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
         <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com>
         <20190115152029.GB2325@lst.de>
         <41d0616e95fb48942404fb54d82249f5700affb1.camel@vmware.com>
         <20190115183133.GA12350@lst.de>
         <c82076aa-a6ee-5ba2-a8d8-935fdbb7d5ca@amd.com>
         <20190115205801.GA15432@lst.de>
In-Reply-To: <20190115205801.GA15432@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [155.4.205.56]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB5670;20:+m7RkWZ4j+gB+LNZT1QTvfJ7n/l/rhWy3MALHOOnIVlAB9Cu5BFHIOaM8qakTSvN1QGOjAFvrYllhHxi/1U3SSQ8u4jbv0p3eUBDbCUr3AI/0FehcZI31iHOO3umJqLBXSTFXLkyUiY1r9AZG1qF60AJHBu6KnKDiOVr/SHWEnc=
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: ba3182a7-6643-4b49-c09b-08d67b819383
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB5670;
x-ms-traffictypediagnostic: BYAPR05MB5670:
x-microsoft-antispam-prvs: <BYAPR05MB567059C8F394CAADEA45E131A1820@BYAPR05MB5670.namprd05.prod.outlook.com>
x-forefront-prvs: 091949432C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(39860400002)(136003)(396003)(376002)(199004)(189003)(305945005)(68736007)(97736004)(93886005)(229853002)(446003)(478600001)(7736002)(81166006)(476003)(486006)(2501003)(2616005)(110136005)(4326008)(86362001)(186003)(6436002)(11346002)(256004)(8676002)(316002)(14444005)(81156014)(54906003)(53936002)(6346003)(99286004)(6486002)(106356001)(26005)(8936002)(5660300001)(25786009)(105586002)(6246003)(118296001)(76176011)(102836004)(6506007)(3846002)(6116002)(6512007)(66066001)(71190400001)(14454004)(71200400001)(36756003)(2906002)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5670;H:BYAPR05MB5592.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thellstrom@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 51puxNK6uCPjxoi/UzZj8g1IENBk8VnjM4gcAwByeRh74Ik7IpRKy30MjUhj3ZjI+4Sth/QgzocRT9j3FUXY8N58ofkYj20PvuKYPrafmxFTjnl9V5sbP2riBpdqnrJGEMePmt70AUlRQQTtKga4S4teN/fN/LYE5FnB2ev2JyfU13/zloA+z7AYDCyrg1nMaHrmmEh/TLTDhDe2lvOEGy/nrej5U0Vr0oGErh/OXG6ISdqL1NyHdrj4oqeO0RgtkpGHfsV2cr+iJJOvHe2/sLbau1dwJ0JkVTBMiWiWeys6gjPTdSrfjFQw3u00tsNsiU+JWJscLh2xXpbfMhXgwvwv3gOGEwH9pWpryR2+wJ+fwAqUSwhHyyxAXta8tFsxwcFIZo5u/owPjLLHnezYamc9TEuts/e6QuFccjmrC1s=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <D690E4E5CF448546A269A54CCF741A1D@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba3182a7-6643-4b49-c09b-08d67b819383
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2019 07:09:37.4245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5670
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

T24gVHVlLCAyMDE5LTAxLTE1IGF0IDIxOjU4ICswMTAwLCBoY2hAbHN0LmRlIHdyb3RlOg0KPiBP
biBUdWUsIEphbiAxNSwgMjAxOSBhdCAwNzoxMzoxMVBNICswMDAwLCBLb2VuaWcsIENocmlzdGlh
biB3cm90ZToNCj4gPiBUaG9tYXMgaXMgY29ycmVjdCB0aGF0IHRoZSBpbnRlcmZhY2UgeW91IHBy
b3Bvc2UgaGVyZSBkb2Vzbid0IHdvcmsNCj4gPiBhdCANCj4gPiBhbGwgZm9yIEdQVXMuDQo+ID4g
DQo+ID4gVGhlIGtlcm5lbCBkcml2ZXIgaXMgbm90IGluZm9ybWVkIG9mIGZsdXNoL3N5bmMsIGJ1
dCByYXRoZXIganVzdA0KPiA+IHNldHVwcyANCj4gPiBjb2hlcmVudCBtYXBwaW5ncyBiZXR3ZWVu
IHN5c3RlbSBtZW1vcnkgYW5kIGRldmljZXMuDQo+ID4gDQo+ID4gSW4gb3RoZXIgd29yZHMgeW91
IGhhdmUgYW4gYXJyYXkgb2Ygc3RydWN0IHBhZ2VzIGFuZCBuZWVkIHRvIG1hcA0KPiA+IHRoYXQg
dG8gDQo+ID4gYSBzcGVjaWZpYyBkZXZpY2UgYW5kIHNvIGNyZWF0ZSBkbWFfYWRkcmVzc2VzIGZv
ciB0aGUgbWFwcGluZ3MuDQo+IA0KPiBJZiB5b3Ugd2FudCBhIGNvaGVyZW50IG1hcHBpbmcgeW91
IG5lZWQgdG8gdXNlIGRtYV9hbGxvY19jb2hlcmVudA0KPiBhbmQgZG1hX21tYXBfY29oZXJlbnQg
YW5kIHlvdSBhcmUgZG9uZSwgdGhhdCBpcyBub3QgdGhlIHByb2JsZW0uDQo+IFRoYXQgYWN0dWFs
bHkgaXMgb25lIG9mIHRoZSB2bWdmeCBtb2Rlcywgc28gSSBkb24ndCB1bmRlcnN0YW5kIHdoYXQN
Cj4gcHJvYmxlbSB3ZSBhcmUgdHJ5aW5nIHRvIHNvbHZlIGlmIHlvdSBkb24ndCBhY3R1YWxseSB3
YW50IGEgbm9uLQ0KPiBjb2hlcmVudCBtYXBwaW5nLiANCg0KRm9yIHZtd2dmeCwgbm90IG1ha2lu
ZyBkbWFfYWxsb2NfY29oZXJlbnQgZGVmYXVsdCBoYXMgYSBjb3VwbGUgb2YNCnJlYXNvbnM6DQox
KSBNZW1vcnkgaXMgYXNzb2NpYXRlZCB3aXRoIGEgc3RydWN0IGRldmljZS4gSXQgaGFzIG5vdCBi
ZWVuIGNsZWFyDQp0aGF0IGl0IGlzIGV4cG9ydGFibGUgdG8gb3RoZXIgZGV2aWNlcy4NCjIpIFRo
ZXJlIHNlZW1zIHRvIGJlIHJlc3RyaWN0aW9ucyBpbiB0aGUgc3lzdGVtIHBhZ2VzIGFsbG93YWJs
ZS4gR1BVcw0KZ2VuZXJhbGx5IHByZWZlciBoaWdobWVtIHBhZ2VzIGJ1dCBkbWFfYWxsb2NfY29o
ZXJlbnQgcmV0dXJucyBhIHZpcnR1YWwNCmFkZHJlc3MgaW1wbHlpbmcgR0ZQX0tFUk5FTD8gV2hp
bGUgbm90IHVzZWQgYnkgdm13Z2Z4LCBUVE0gdHlwaWNhbGx5DQpwcmVmZXJzIEhJR0hNRU0gcGFn
ZXMgdG8gZmFjaWxpdGF0ZSBjYWNoaW5nIG1vZGUgc3dpdGNoaW5nIHdpdGhvdXQNCmhhdmluZyB0
byB0b3VjaCB0aGUga2VybmVsIG1hcC4gDQozKSBIaXN0b3JpY2FsbHkgd2UgaGFkIEFQSXMgdG8g
YWxsb3cgY29oZXJlbnQgYWNjZXNzIHRvIHVzZXItc3BhY2UNCmRlZmluZWQgcGFnZXMuIFRoYXQg
aGFzIGdvbmUgYXdheSBub3QgYnV0IHRoZSBpbmZyYXN0cnVjdHVyZSB3YXMgYnVpbHQNCmFyb3Vu
ZCBpdC4NCg0KZG1hX21tYXBfY29oZXJlbnQgaXNuJ3QgdXNlIGJlY2F1c2UgYXMgdGhlIGRhdGEg
bW92ZXMgYmV0d2VlbiBzeXN0ZW0NCm1lbW9yeSwgc3dhcCBhbmQgVlJBTSwgUFRFcyBvZiB1c2Vy
LXNwYWNlIG1hcHBpbmdzIGFyZSBhZGp1c3RlZA0KYWNjb3JkaW5nbHksIG1lYW5pbmcgdXNlci1z
cGFjZSBkb2Vzbid0IGhhdmUgdG8gdW5tYXAgd2hlbiBhbiBvcGVyYXRpb24NCmlzIGluaXRpYXRl
ZCB0aGF0IG1pZ2h0IG1lYW4gdGhlIGRhdGEgaXMgbW92ZWQuDQoNCg0KPiBBbHRob3VnaCBsYXN0
IHRpbWUgSSBoYWQgdGhhdCBkaXNjdXNzaW9uIHdpdGggRGFuaWVsIFZldHRlcg0KPiBJIHdhcyB1
bmRlciB0aGUgaW1wcmVzc2lvbnMgdGhhdCBHUFVzIHJlYWxseSB3YW50ZWQgbm9uLWNvaGVyZW50
DQo+IG1hcHBpbmdzLg0KDQpJbnRlbCBoaXN0b3JpY2FsbHkgaGFzIGRvbmUgdGhpbmdzIGEgYml0
IGRpZmZlcmVudGx5LiBBbmQgaXQncyBhbHNvDQpwb3NzaWJsZSB0aGF0IGVtYmVkZGVkIHBsYXRm
b3JtcyBhbmQgQVJNIHByZWZlciB0aGlzIG1vZGUgb2Ygb3BlcmF0aW9uLA0KYnV0IEkgaGF2ZW4n
dCBjYXVnaHQgdXAgb24gdGhhdCBkaXNjdXNzaW9uLg0KDQo+IA0KPiBCdXQgaWYgeW91IHdhbnQg
YSBjb2hlcmVudCBtYXBwaW5nIHlvdSBjYW4ndCBnbyB0byBhIHN0cnVjdCBwYWdlLA0KPiBiZWNh
dXNlIG9uIG1hbnkgc3lzdGVtcyB5b3UgY2FuJ3QganVzdCBtYXAgYXJiaXRyYXJ5IG1lbW9yeSBh
cw0KPiB1bmNhY2hhYmxlLiAgSXQgbWlnaHQgZWl0aGVyIGNvbWUgZnJvbSB2ZXJ5IHNwZWNpYWwg
bGltaXRlZCBwb29scywNCj4gb3IgbWlnaHQgbmVlZCBvdGhlciBtYWdpYyBhcHBsaWVkIHRvIGl0
IHNvIHRoYXQgaXQgaXMgbm90IHZpc2libGUNCj4gaW4gdGhlIG5vcm1hbCBkaXJlY3QgbWFwcGlu
Zywgb3IgYXQgbGVhc3Qgbm90IGFjY2VzcyB0aHJvdWdoIGl0Lg0KDQoNClRoZSBUVE0gc3Vic3lz
dGVtIGhhcyBiZWVuIHJlbGllZCBvbiB0byBwcm92aWRlIGNvaGVyZW50IG1lbW9yeSB3aXRoDQp0
aGUgb3B0aW9uIHRvIHN3aXRjaCBjYWNoaW5nIG1vZGUgb2YgcGFnZXMuIEJ1dCBvbmx5IG9uIHNl
bGVjdGVkIGFuZA0Kd2VsbCB0ZXN0ZWQgcGxhdGZvcm1zLiBPbiBvdGhlciBwbGF0Zm9ybXMgd2Ug
c2ltcGx5IGRvIG5vdCBsb2FkLCBhbmQNCnRoYXQncyBmaW5lIGZvciBub3cuDQoNCkJ1dCBhcyBt
ZW50aW9uZWQgbXVsdGlwbGUgdGltZXMsIHRvIG1ha2UgR1BVIGRyaXZlcnMgbW9yZSBjb21wbGlh
bnQsDQp3ZSdkIHJlYWxseSB3YW50IHRoYXQNCg0KYm9vbCBkbWFfc3RyZWFtaW5nX2lzX2NvaGVy
ZW50KGNvbnN0IHN0cnVjdCBkZXZpY2UgKikNCg0KQVBJIHRvIGhlbHAgdXMgZGVjaWRlIHdoZW4g
dG8gbG9hZCBvciBub3QuDQoNClRoYW5rcywNClRob21hcw0KDQoNCg0KDQoNCg0KDQo=
