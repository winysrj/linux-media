Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788CEC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DD1A20656
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:17:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="cti6tKzZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730195AbfAOORf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 09:17:35 -0500
Received: from mail-eopbgr790049.outbound.protection.outlook.com ([40.107.79.49]:18496
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728612AbfAOORf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 09:17:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1CUaT47bnOoULEJoU1cPIE7MVvEymUw2Ui+OJ4Kw4Eg=;
 b=cti6tKzZdo73XMBhZ28g4IlyaHQtY2VsGx95kWqCk0v/SDDwN0jSxpCttTpJmkCrL9anDOsxDTgOCPN87D4MfL+FFOc5gSK9wucFkY/SEJhAWP//QtJaXU/bEInlVaFzUGBZxbLGKyw1iQbDxbsaIjbhhAHG5q9i/9fFdd5BnKc=
Received: from BYAPR05MB5592.namprd05.prod.outlook.com (20.177.186.153) by
 BYAPR05MB5096.namprd05.prod.outlook.com (20.177.231.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.10; Tue, 15 Jan 2019 14:17:26 +0000
Received: from BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::4a1:2561:2487:5919]) by BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::4a1:2561:2487:5919%4]) with mapi id 15.20.1537.018; Tue, 15 Jan 2019
 14:17:26 +0000
From:   Thomas Hellstrom <thellstrom@vmware.com>
To:     "hch@lst.de" <hch@lst.de>, "jgg@ziepe.ca" <jgg@ziepe.ca>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yong.zhi@intel.com" <yong.zhi@intel.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "syeh@vmware.com" <syeh@vmware.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "bingbu.cao@intel.com" <bingbu.cao@intel.com>,
        "imre.deak@intel.com" <imre.deak@intel.com>,
        "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>,
        "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Thread-Topic: [PATCH] lib/scatterlist: Provide a DMA page iterator
Thread-Index: AQHUpH3T+Rn6hCeN4kq6RDaSbJgsYKWpM0MAgAVgfACAAd1XAA==
Date:   Tue, 15 Jan 2019 14:17:26 +0000
Message-ID: <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
References: <20190104223531.GA1705@ziepe.ca>     <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
In-Reply-To: <20190114094856.GB29604@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thellstrom@vmware.com; 
x-originating-ip: [155.4.205.56]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB5096;20:NWnxJSDwZV1mkqHXnNAm+oWQQkCxdAMkvIgI6QnKkbhizU/nHF4qPQegT/0aBFeN9DksQQNF7WXXSkPjo711k5HroXM6BpJAWmwm5jiDBEQEjF8Y+Sl9C3IDG8LxUkxwm7sJ6JQz2m+fCLF60kUkOQiouYeELoQhtKJ0EYQg048=
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: aa387cac-9dd3-4549-1659-08d67af42cfb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB5096;
x-ms-traffictypediagnostic: BYAPR05MB5096:
x-microsoft-antispam-prvs: <BYAPR05MB5096E3DE48558416C4EB57E5A1810@BYAPR05MB5096.namprd05.prod.outlook.com>
x-forefront-prvs: 0918748D70
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(136003)(346002)(376002)(189003)(199004)(68736007)(229853002)(6436002)(2501003)(256004)(76176011)(66066001)(7736002)(14454004)(305945005)(478600001)(486006)(86362001)(106356001)(97736004)(2906002)(71200400001)(71190400001)(6486002)(186003)(26005)(6506007)(476003)(102836004)(105586002)(2616005)(99286004)(81166006)(81156014)(11346002)(36756003)(6246003)(6512007)(316002)(8676002)(110136005)(54906003)(5660300001)(53936002)(7416002)(25786009)(4326008)(8936002)(3846002)(6116002)(118296001)(446003)(21314003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5096;H:BYAPR05MB5592.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8UT48eH2b7ODuvXjatJyUBEAqgDHTAlEFLzOHiwZ3VIk4SiLqfL0bLb4UCD8ahO8crw+FBaZ3pvMFRcnqXBmJ5cS39aoZd0GBN53bAtow3Y4u6rZdJAdUlaKmE4CFgktQj9c7Vk6TJkeeT5EfiJHst2uGGZ1rfc0tpNdoC22Ms3I5mAhmd6m+2n9yk2ptNqQrjmTT2VqTbzfdcJckmidCyARIda8I95gn128Jauhw3Auwybxj1xkYD6pwAznBixdPMDu81CzS4Y0nFr2ryrZOYMdTeHbIVoFOVz5EwTGrOhu0CMcohf29mcfGGOxasRyIOQVfPiZNfNepSx92YIGfy9ANTXwLqIQSvhRkNLOsad6+d/8rcttwAWWNu14+7L0/K/h/iFNMjgGAF8XM7qRVP21a1IbyOCHI/AOv82Y0Vw=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <08354190753F9248B70A9EE8CA12BF44@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa387cac-9dd3-4549-1659-08d67af42cfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2019 14:17:26.3784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5096
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGksIENocmlzdG9waCwNCg0KT24gTW9uLCAyMDE5LTAxLTE0IGF0IDEwOjQ4ICswMTAwLCBDaHJp
c3RvcGggSGVsbHdpZyB3cm90ZToNCj4gT24gVGh1LCBKYW4gMTAsIDIwMTkgYXQgMDQ6NDI6MThQ
TSAtMDcwMCwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiA+ID4gQ2hhbmdlcyBzaW5jZSB0aGUg
UkZDOg0KPiA+ID4gLSBSZXdvcmsgdm13Z2Z4IHRvbyBbQ0hdDQo+ID4gPiAtIFVzZSBhIGRpc3Rp
bmN0IHR5cGUgZm9yIHRoZSBETUEgcGFnZSBpdGVyYXRvciBbQ0hdDQo+ID4gPiAtIERvIG5vdCBo
YXZlIGEgI2lmZGVmIFtDSF0NCj4gPiANCj4gPiBDaHJpc3RvcGhIOiBXaWxsIHlvdSBhY2s/DQo+
IA0KPiBUaGlzIGxvb2tzIGdlbmVyYWxseSBmaW5lLg0KPiANCj4gPiBBcmUgeW91IHN0aWxsIE9L
IHdpdGggdGhlIHZtd2dmeCByZXdvcmtpbmcsIG9yIHNob3VsZCB3ZSBnbyBiYWNrIHRvDQo+ID4g
dGhlIG9yaWdpbmFsIHZlcnNpb24gdGhhdCBkaWRuJ3QgaGF2ZSB0aGUgdHlwZSBzYWZldHkgc28g
dGhpcw0KPiA+IGRyaXZlcg0KPiA+IGNhbiBiZSBsZWZ0IGJyb2tlbj8NCj4gDQo+IEkgdGhpbmsg
dGhlIG1hcCBtZXRob2QgaW4gdm1nZnggdGhhdCBqdXN0IGRvZXMgdmlydF90b19waHlzIGlzDQo+
IHByZXR0eSBicm9rZW4uICBUaG9tYXMsIGNhbiB5b3UgY2hlY2sgaWYgeW91IHNlZSBhbnkgcGVy
Zm9ybWFuY2UNCj4gZGlmZmVyZW5jZSB3aXRoIGp1c3QgZG9pbmcgdGhlIHByb3BlciBkbWEgbWFw
cGluZywgYXMgdGhhdCBnZXRzIHRoZQ0KPiBkcml2ZXIgb3V0IG9mIGludGVyZmFjZSBhYnVzZSBs
YW5kPw0KDQpUaGUgcGVyZm9ybWFuY2UgZGlmZmVyZW5jZSBpcyBub3QgcmVhbGx5IHRoZSBtYWlu
IHByb2JsZW0gaGVyZS4gVGhlDQpwcm9ibGVtIGlzIHRoYXQgZXZlbiB0aG91Z2ggd2UgdXRpbGl6
ZSB0aGUgc3RyZWFtaW5nIERNQSBpbnRlcmZhY2UsIHdlDQp1c2UgaXQgb25seSBzaW5jZSB3ZSBo
YXZlIHRvIGZvciBETUEtUmVtYXBwaW5nIGFuZCBhc3N1bWUgdGhhdCB0aGUNCm1lbW9yeSBpcyBj
b2hlcmVudC4gVG8gYmUgYWJsZSB0byBiZSBhcyBjb21wbGlhbnQgYXMgcG9zc2libGUgYW5kIGRp
dGNoDQp0aGUgdmlydC10by1waHlzIG1vZGUsIHdlICpuZWVkKiBhIERNQSBpbnRlcmZhY2UgZmxh
ZyB0aGF0IHRlbGxzIHVzDQp3aGVuIHRoZSBkbWFfc3luY19mb3JfeHh4IGFyZSBuby1vcHMuIElm
IHRoZXkgYXJlbid0IHdlJ2xsIHJlZnVzZSB0bw0KbG9hZCBmb3Igbm93LiBJJ20gbm90IHN1cmUs
IGJ1dCBJIHRoaW5rIGFsc28gbm91dmVhdSBhbmQgcmFkZW9uIHN1ZmZlcg0KZnJvbSB0aGUgc2Ft
ZSBpc3N1ZS4NCg0KPiANCj4gV2hpbGUgd2UncmUgYXQgaXQgSSB0aGluayB3ZSBuZWVkIHRvIG1l
cmdlIG15IHNlcmllcyBpbiB0aGlzIGFyZWENCj4gZm9yIDUuMCwgYmVjYXVzZSB3aXRob3V0IHRo
YXQgdGhlIGRyaXZlciBpcyBhbHJlYWR5IGJyb2tlbi4gIFdoZXJlDQo+IHNob3VsZCB3ZSBtZXJn
ZSBpdD8NCg0KSSBjYW4gbWVyZ2UgaXQgdGhyb3VnaCB2bXdnZngvZHJtLWZpeGVzLiBUaGVyZSBp
cyBhbiBvdXRzdGFuZGluZyBpc3N1ZQ0Kd2l0aCBwYXRjaCAzLiBEbyB5b3Ugd2FudCBtZSB0byBm
aXggdGhhdCB1cD8NCg0KVGhhbmtzLA0KVGhvbWFzDQoNCg0K
