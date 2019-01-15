Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88157C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 18:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 435CE20859
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 18:03:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="PpUGOzJs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388636AbfAOSDr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 13:03:47 -0500
Received: from mail-eopbgr750075.outbound.protection.outlook.com ([40.107.75.75]:27977
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731200AbfAOSDq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 13:03:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtokOlS39rUuUWjDT61AefUTHpa6Qou5CG2yefb1kwo=;
 b=PpUGOzJsXj9eLMyK1ToSS+WoH82UHLXf6s3+JKWMfu4Ox06gkhSaJL1lJWvcQmeiORrvnHXedx34VntAVFD2tXp0aPLSlbLI/DZ8X8nuICqQK5jANo2VQUGx7cCcGE9V4TYUTG8OQWL9s+kAVeJ7f/9oLTH3FK6YWfHjXsHKRXo=
Received: from BYAPR05MB5592.namprd05.prod.outlook.com (20.177.186.153) by
 BYAPR05MB5319.namprd05.prod.outlook.com (20.177.127.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.18; Tue, 15 Jan 2019 18:03:39 +0000
Received: from BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::4a1:2561:2487:5919]) by BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::4a1:2561:2487:5919%4]) with mapi id 15.20.1537.018; Tue, 15 Jan 2019
 18:03:39 +0000
From:   Thomas Hellstrom <thellstrom@vmware.com>
To:     "hch@lst.de" <hch@lst.de>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>
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
Thread-Index: AQHUpH3T+Rn6hCeN4kq6RDaSbJgsYKWpM0MAgAVgfACAAd1XAIAAAhqAgAAPhoCAAC2UgA==
Date:   Tue, 15 Jan 2019 18:03:39 +0000
Message-ID: <41d0616e95fb48942404fb54d82249f5700affb1.camel@vmware.com>
References: <20190104223531.GA1705@ziepe.ca>     <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
         <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
         <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com>
         <20190115152029.GB2325@lst.de>
In-Reply-To: <20190115152029.GB2325@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thellstrom@vmware.com; 
x-originating-ip: [155.4.205.56]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB5319;20:4iXOcmhkTuQjZdjR1i1J7WPgfmEMYvhPhe2WvIJQe4g9HqaEyiUNmRJBWPFFxqXG7TkRZmM6C56BgRj24JZ3WEqxZ7lWzFNoozRKxoPzry2Vl9vFtMIwBwWbQTvRj+zZPxAOwn32Ld8rpxCwR4ogI+d7gPhuSg6znwe7+kSrMv4=
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 29b1393b-896b-419c-4a15-08d67b13c73e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB5319;
x-ms-traffictypediagnostic: BYAPR05MB5319:
x-microsoft-antispam-prvs: <BYAPR05MB5319E4E1B8E3D3770ABF2521A1810@BYAPR05MB5319.namprd05.prod.outlook.com>
x-forefront-prvs: 0918748D70
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(366004)(396003)(39860400002)(346002)(189003)(199004)(14454004)(86362001)(229853002)(186003)(76176011)(102836004)(6506007)(81156014)(81166006)(8936002)(36756003)(110136005)(54906003)(8676002)(316002)(5660300001)(26005)(6486002)(6436002)(7416002)(478600001)(45080400002)(966005)(7736002)(256004)(105586002)(486006)(93886005)(118296001)(2501003)(305945005)(6116002)(3846002)(97736004)(4326008)(2906002)(68736007)(71200400001)(71190400001)(2616005)(476003)(11346002)(446003)(66066001)(25786009)(53936002)(99286004)(6306002)(6512007)(6246003)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5319;H:BYAPR05MB5592.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:3;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aIOheURhbnYHHrvWiU1cMc4ToJPjCWwsKtnVNnklf4W7rFIu74yDOUDveUu5Ze6/FBHEK5tsVr6GkGVpDBFSXTTMhtfkla9OtE+7lD4zCNr2+g/rdWTRXJkKv3xMLmhPGi+B10+vF8K1aBunQZIMbJfKUEyrkVuEYUj0iuNPJzm7+mVa1KUqT1Kk8dxdoQvWQoucvZNwoBVVwGlEMG+wRstzmz2eZgYTPFeVZj75YPVwWCckcLoRrxqb42DjS25/x0NHTiHcDiUx0dajujZ6Y6oeufNCB7uRFGoxIJVuAB99xOIO7G25VhaQX++cbf0Ri4DEM/CbVsejL53ruDNUA+dH/PIt8nGJgO94GGdPX/In3dZh1AAXDbNwY8JA+4MKn3CuQX5/3CS0EBDpZGZ1pmJlYeA3ugE5LutNlRH8KiY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <FED2CBB835F5DD40B292A1B1B614FFB3@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b1393b-896b-419c-4a15-08d67b13c73e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2019 18:03:39.5406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5319
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

T24gVHVlLCAyMDE5LTAxLTE1IGF0IDE2OjIwICswMTAwLCBoY2hAbHN0LmRlIHdyb3RlOg0KPiBP
biBUdWUsIEphbiAxNSwgMjAxOSBhdCAwMzoyNDo1NVBNICswMTAwLCBDaHJpc3RpYW4gS8O2bmln
IHdyb3RlOg0KPiA+IFllYWgsIGluZGVlZC4gQm91bmNlIGJ1ZmZlcnMgYXJlIGFuIGFic29sdXRl
IG5vLWdvIGZvciBHUFVzLg0KPiA+IA0KPiA+IElmIHRoZSBETUEgQVBJIGZpbmRzIHRoYXQgYSBw
aWVjZSBvZiBtZW1vcnkgaXMgbm90IGRpcmVjdGx5DQo+ID4gYWNjZXNzaWJsZSBieSANCj4gPiB0
aGUgR1BVIHdlIG5lZWQgdG8gcmV0dXJuIGFuIGVycm9yIGFuZCBub3QgdHJ5IHRvIHVzZSBib3Vu
Y2UNCj4gPiBidWZmZXJzIGJlaGluZCANCj4gPiB0aGUgc3VyZmFjZS4NCj4gPiANCj4gPiBUaGF0
IGlzIHNvbWV0aGluZyB3aGljaCBhbHdheXMgYW5ub3llZCBtZSB3aXRoIHRoZSBETUEgQVBJLCB3
aGljaA0KPiA+IGlzIA0KPiA+IG90aGVyd2lzZSByYXRoZXIgY2xlYW5seSBkZWZpbmVkLg0KPiAN
Cj4gVGhhdCBpcyBleGFjdGx5IHdoYXQgSSB3YW50IHRvIGZpeCB3aXRoIG15IHNlcmllcyB0byBt
YWtlDQo+IERNQV9BVFRSX05PTl9DT05TSVNURU5UIG1vcmUgdXNlZnVsIGFuZCBhbHdheXMgYXZh
aWxhYmxlOg0KPiANCj4gaHR0cHM6Ly9uYTAxLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2su
Y29tLz91cmw9aHR0cHMlM0ElMkYlMkZsaXN0cy5saW51eGZvdW5kYXRpb24ub3JnJTJGcGlwZXJt
YWlsJTJGaW9tbXUlMkYyMDE4LURlY2VtYmVyJTJGMDMxOTg1Lmh0bWwmYW1wO2RhdGE9MDIlN0Mw
MSU3Q3RoZWxsc3Ryb20lNDB2bXdhcmUuY29tJTdDYjE3OTljNDA3MzAyNGE4MjRmOTQwOGQ2N2Fm
Y2ZjZWElN0NiMzkxMzhjYTNjZWU0YjRhYTRkNmNkODNkOWRkNjJmMCU3QzAlN0MwJTdDNjM2ODMx
NjI0MzQwODM0MTQwJmFtcDtzZGF0YT1KaVJCZnpaTXZOM2pvSjR2S2lFcmJ6WEFIYU56dUJjTGFw
UkpETCUyQnQ2SGMlM0QmYW1wO3Jlc2VydmVkPTANCj4gDQo+IFdpdGggdGhhdCB5b3UgYWxsb2Nh
dGUgdGhlIG1lbW9yeSB1c2luZyBkbWFfYWxsb2NfYXR0cnMgd2l0aA0KPiBETUFfQVRUUl9OT05f
Q09OU0lTVEVOVCwgYW5kIHVzZSBkbWFfc3luY19zaW5nbGVfKiB0byB0cmFuc2Zlcg0KPiBvd25l
cnNoaXAgdG8gdGhlIGNwdSBhbmQgYmFjayB0byB0aGUgZGV2aWNlLCB3aXRoIGEgZ3VyYW50ZWUg
dGhhdA0KPiB0aGVyZSB3b24ndCBiZSBhbnkgYm91bmNpbmcuICBTbyBmYXIgdGhlIGludGVyZXN0
IGJ5IHRoZSBwYXJ0aWVzIHRoYXQNCj4gcmVxdWVzdGVkIHRoZSBmZWF0dXJlIGhhcyBiZWVuIHJh
dGhlciBsYWNrbHVzdHJlLCB0aG91Z2guDQoNCkluIHRoZSBncmFwaGljcyBjYXNlLCBpdCdzIHBy
b2JhYmx5IGJlY2F1c2UgaXQgZG9lc24ndCBmaXQgdGhlIGdyYXBoaWNzDQp1c2UtY2FzZXM6DQoN
CjEpIE1lbW9yeSB0eXBpY2FsbHkgbmVlZHMgdG8gYmUgbWFwcGFibGUgYnkgYW5vdGhlciBkZXZp
Y2UuICh0aGUgImRtYS0NCmJ1ZiIgaW50ZXJmYWNlKQ0KMikgRE1BIGJ1ZmZlcnMgYXJlIGV4cG9y
dGVkIHRvIHVzZXItc3BhY2UgYW5kIGlzIHN1Yi1hbGxvY2F0ZWQgYnkgaXQuDQpNb3N0bHkgdGhl
cmUgYXJlIG5vIEdQVSB1c2VyLXNwYWNlIGtlcm5lbCBpbnRlcmZhY2VzIHRvIHN5bmMgLyBmbHVz
aA0Kc3VicmVnaW9ucyBhbmQgdGhlc2Ugc3luY3MgbWF5IGhhcHBlbiBvbiBhIHNtYWxsZXItdGhh
bi1jYWNoZS1saW5lDQpncmFudWxhcml0eS4NCg0KU28gdG8gaGVscCB0aGUgZ3JhcGhpY3MgZHJp
dmVyLCB0aGF0IGNvaGVyZW50IGZsYWcgd291bGQgYmUgbXVjaCBtb3JlDQp1c2VmdWwuDQoNCi9U
aG9tYXMNCg0K
