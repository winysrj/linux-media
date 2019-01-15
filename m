Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709F4C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 19:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3465D20859
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 19:13:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="X4v+p8Jz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389263AbfAOTNS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 14:13:18 -0500
Received: from mail-eopbgr800075.outbound.protection.outlook.com ([40.107.80.75]:19328
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729921AbfAOTNS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 14:13:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYIHVzOR0Sqrw5I44vPkS27UuFfQgE9rdE2ylOeNKIs=;
 b=X4v+p8JzgvJBSMFNLwxfo5yXtXo85RgtUBHnhxUkd51jCErAZT7gt684xoaR83hW4lbhTlXHJOSaqUXRLDqs3biAnukaA+Sf6rf5eHJmLrOe+I0RpdDNPsGP3mOoKipVXxnrjJcZCvXw4PVOejmp/+/WiyAF308FD2ri1zkWCwQ=
Received: from BN6PR12MB1714.namprd12.prod.outlook.com (10.175.101.11) by
 BN6PR12MB1731.namprd12.prod.outlook.com (10.175.101.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.18; Tue, 15 Jan 2019 19:13:11 +0000
Received: from BN6PR12MB1714.namprd12.prod.outlook.com
 ([fe80::1c01:3bbc:5ef1:4090]) by BN6PR12MB1714.namprd12.prod.outlook.com
 ([fe80::1c01:3bbc:5ef1:4090%11]) with mapi id 15.20.1516.019; Tue, 15 Jan
 2019 19:13:11 +0000
From:   "Koenig, Christian" <Christian.Koenig@amd.com>
To:     "hch@lst.de" <hch@lst.de>, Thomas Hellstrom <thellstrom@vmware.com>
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
Thread-Index: AQHUrOXdj04wr1dVGkWvqY6Mg4pf06Wwn32AgAAHy4CAAAuYgA==
Date:   Tue, 15 Jan 2019 19:13:11 +0000
Message-ID: <c82076aa-a6ee-5ba2-a8d8-935fdbb7d5ca@amd.com>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
 <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com>
 <20190115152029.GB2325@lst.de>
 <41d0616e95fb48942404fb54d82249f5700affb1.camel@vmware.com>
 <20190115183133.GA12350@lst.de>
In-Reply-To: <20190115183133.GA12350@lst.de>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
x-originating-ip: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
x-clientproxiedby: AM5PR0202CA0003.eurprd02.prod.outlook.com
 (2603:10a6:203:69::13) To BN6PR12MB1714.namprd12.prod.outlook.com
 (2603:10b6:404:106::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BN6PR12MB1731;20:8JoEZaK5rOjTjGvWn0/jNsdeUr3o4QK8F7wUCGuvFLXrjOEomIxmuPK8GI3wIAYYAE64KxYndHCmoUKGnqbZwp+Jx+5Ewm7kFugkhC5QmHROjy0pqG6Lw9u6dG5dDazMpMD0cMpE1ZpDxq4VnkqvLh27+3j5D4horuvWePvq0ZTx5p9Xq5rWD9BqQmGApAMsFtWgAhAWZM9AduSYSEiUTiGn7nKm3SfiX3FvzX8mcf2xuIqg0rP2PBAGj/xaZ0Lp
x-ms-office365-filtering-correlation-id: ffc98a4a-9b0e-4df9-ec7c-08d67b1d7d7b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BN6PR12MB1731;
x-ms-traffictypediagnostic: BN6PR12MB1731:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Christian.Koenig@amd.com; 
x-microsoft-antispam-prvs: <BN6PR12MB1731E1CF8B9AE5752EEF300583810@BN6PR12MB1731.namprd12.prod.outlook.com>
x-forefront-prvs: 0918748D70
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(376002)(366004)(396003)(189003)(199004)(43544003)(6486002)(6116002)(386003)(6506007)(36756003)(72206003)(64126003)(14454004)(478600001)(52116002)(76176011)(68736007)(2906002)(229853002)(31686004)(106356001)(105586002)(102836004)(25786009)(31696002)(4326008)(86362001)(486006)(65826007)(99286004)(6436002)(7416002)(5660300001)(53936002)(186003)(6512007)(476003)(2616005)(11346002)(446003)(81166006)(81156014)(7736002)(46003)(97736004)(305945005)(8676002)(65956001)(65806001)(8936002)(54906003)(110136005)(256004)(71200400001)(6246003)(58126008)(71190400001)(2501003)(93886005)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR12MB1731;H:BN6PR12MB1714.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pzm4Y//mPX3OWRrzHs404z2Ff37ZSja+DPbLCU3Ukbd5XcGA/ZRf7iLYgVi3d27m39SwtmvSRP9m+bCMakvps4s0D7+uttaZKv1hhhoBrpmbgk8h2ycB88iVsa2m8+OGt14pDlKIyplRhERHEsZUElTZwOB0vuqRQzvWr3Ktl/OeCn4h2ojEWiEc6aWNZYTppm9qvdiEoYkZCqwzzwdknuJSixzND1emGoyJyQZWpwUTqg2sRNslwdRVXCbBtJD7PwRC1sHevEWPTkq5RaPPLtPEW4yaHoNTin0vvwKTqMwoY3/rpxpkAb/bxY3TZvml5wf/hX4fV+h+ywL0IsZClX32GCqLyHja1S7JiCESDC+2UJEbfYjR52QQ4tOK2Xn1nbq6zIT0uGU6hJaXYYDo5PongBkdj2kXXO7P+Nuqufc=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <01DFD43BFF2D1B4DB471E42D38BF959C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc98a4a-9b0e-4df9-ec7c-08d67b1d7d7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2019 19:13:08.6746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1731
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

QW0gMTUuMDEuMTkgdW0gMTk6MzEgc2NocmllYiBoY2hAbHN0LmRlOg0KPiBPbiBUdWUsIEphbiAx
NSwgMjAxOSBhdCAwNjowMzozOVBNICswMDAwLCBUaG9tYXMgSGVsbHN0cm9tIHdyb3RlOg0KPj4g
SW4gdGhlIGdyYXBoaWNzIGNhc2UsIGl0J3MgcHJvYmFibHkgYmVjYXVzZSBpdCBkb2Vzbid0IGZp
dCB0aGUgZ3JhcGhpY3MNCj4+IHVzZS1jYXNlczoNCj4+DQo+PiAxKSBNZW1vcnkgdHlwaWNhbGx5
IG5lZWRzIHRvIGJlIG1hcHBhYmxlIGJ5IGFub3RoZXIgZGV2aWNlLiAodGhlICJkbWEtDQo+PiBi
dWYiIGludGVyZmFjZSkNCj4gQW5kIHRoZXJlIGlzIG5vdGhpbmcgcHJldmVudGluZyBkbWEtYnVm
IHNoYXJpbmcgb2YgdGhlc2UgYnVmZmVycy4NCj4gVW5saWtlIHRoZSBnZXRfc2d0YWJsZSBtZXNz
IGl0IGNhbiBhY3R1YWxseSB3b3JrIHJlbGlhYmx5IG9uDQo+IGFyY2hpdGVjdHVyZXMgdGhhdCBo
YXZlIHZpcnR1YWxseSB0YWdnZWQgY2FjaGVzIGFuZC9vciBkb24ndA0KPiBndWFyYW50ZWUgY2Fj
aGUgY29oZXJlbmN5IHdpdGggbWl4ZWQgYXR0cmlidXRlIG1hcHBpbmdzLg0KPg0KPj4gMikgRE1B
IGJ1ZmZlcnMgYXJlIGV4cG9ydGVkIHRvIHVzZXItc3BhY2UgYW5kIGlzIHN1Yi1hbGxvY2F0ZWQg
YnkgaXQuDQo+PiBNb3N0bHkgdGhlcmUgYXJlIG5vIEdQVSB1c2VyLXNwYWNlIGtlcm5lbCBpbnRl
cmZhY2VzIHRvIHN5bmMgLyBmbHVzaA0KPj4gc3VicmVnaW9ucyBhbmQgdGhlc2Ugc3luY3MgbWF5
IGhhcHBlbiBvbiBhIHNtYWxsZXItdGhhbi1jYWNoZS1saW5lDQo+PiBncmFudWxhcml0eS4NCj4g
SSBrbm93IG9mIG5vIGFyY2hpdGVjdHVyZXMgdGhhdCBjYW4gZG8gY2FjaGUgbWFpbnRhaW5hbmNl
IG9uIGEgbGVzcw0KPiB0aGFuIGNhY2hlIGxpbmUgYmFzaXMuICBFaXRoZXIgdGhlIGluc3RydWN0
aW9ucyByZXF1aXJlIHlvdSB0bw0KPiBzcGVjaWZjeSBjYWNoZSBsaW5lcywgb3IgdGhleSBkbyBz
b21ldGltZXMgbW9yZSwgc29tZXRpbWVzIGxlc3MNCj4gaW50ZWxsaWdlbnQgcm91bmRpbmcgdXAu
DQo+DQo+IE5vdGUgdGhhdCBhcyBsb25nIGRtYSBub24tY29oZXJlbnQgYnVmZmVycyBhcmUgZGV2
aWNlcyBvd25lZCBpdA0KPiBpcyB1cCB0byB0aGUgZGV2aWNlIGFuZCB0aGUgdXNlciBzcGFjZSBk
cml2ZXIgdG8gdGFrZSBjYXJlIG9mDQo+IGNvaGVyZW5jeSwgdGhlIGtlcm5lbCB2ZXJ5IG11Y2gg
aXMgb3V0IG9mIHRoZSBwaWN0dXJlLg0KDQpUaG9tYXMgaXMgY29ycmVjdCB0aGF0IHRoZSBpbnRl
cmZhY2UgeW91IHByb3Bvc2UgaGVyZSBkb2Vzbid0IHdvcmsgYXQgDQphbGwgZm9yIEdQVXMuDQoN
ClRoZSBrZXJuZWwgZHJpdmVyIGlzIG5vdCBpbmZvcm1lZCBvZiBmbHVzaC9zeW5jLCBidXQgcmF0
aGVyIGp1c3Qgc2V0dXBzIA0KY29oZXJlbnQgbWFwcGluZ3MgYmV0d2VlbiBzeXN0ZW0gbWVtb3J5
IGFuZCBkZXZpY2VzLg0KDQpJbiBvdGhlciB3b3JkcyB5b3UgaGF2ZSBhbiBhcnJheSBvZiBzdHJ1
Y3QgcGFnZXMgYW5kIG5lZWQgdG8gbWFwIHRoYXQgdG8gDQphIHNwZWNpZmljIGRldmljZSBhbmQg
c28gY3JlYXRlIGRtYV9hZGRyZXNzZXMgZm9yIHRoZSBtYXBwaW5ncy4NCg0KUmVnYXJkcywNCkNo
cmlzdGlhbi4NCg==
