Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F75AC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 10:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2362F20657
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 10:47:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="s+ZZMRJL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbfAQKrm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 05:47:42 -0500
Received: from mail-eopbgr720082.outbound.protection.outlook.com ([40.107.72.82]:51360
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726917AbfAQKrl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 05:47:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySpFAlDw3bCrwlSoI0LBRqLP7nOlw9eKHW2O6y/nY28=;
 b=s+ZZMRJL2U5W9XuS4/uY0k2/nR1TRb78WzA8pPne7i2VPjKfG/Ly3DXGuS93ApUkCB+tnVpw0pT+VUo75s1oOf4e8OCQgrHY203RYqn9sAxb7XtqoI3vW5WFsPHaoOKcpH0JVUUdXN/3aaqfDVVMj8VIa+m1CkQbXmzNkc+MS/g=
Received: from BYAPR05MB5592.namprd05.prod.outlook.com (20.177.186.153) by
 BYAPR05MB4472.namprd05.prod.outlook.com (52.135.203.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.8; Thu, 17 Jan 2019 10:47:38 +0000
Received: from BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::4a1:2561:2487:5919]) by BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::4a1:2561:2487:5919%4]) with mapi id 15.20.1558.010; Thu, 17 Jan 2019
 10:47:38 +0000
From:   Thomas Hellstrom <thellstrom@vmware.com>
To:     "hch@lst.de" <hch@lst.de>, "jgg@ziepe.ca" <jgg@ziepe.ca>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syeh@vmware.com" <syeh@vmware.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "yong.zhi@intel.com" <yong.zhi@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
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
Thread-Index: AQHUpH3T+Rn6hCeN4kq6RDaSbJgsYKWpM0MAgAVgfACAAd1XAIAAd3mAgAE6wgCAABRnAIABDbyAgAAVrIA=
Date:   Thu, 17 Jan 2019 10:47:38 +0000
Message-ID: <c03889ffe2153cd84d263873bc8bd559c439177a.camel@vmware.com>
References: <20190104223531.GA1705@ziepe.ca>     <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
         <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
         <20190115212501.GE22045@ziepe.ca> <20190116161134.GA29041@lst.de>
         <20190116172436.GM22045@ziepe.ca> <20190117093001.GB31303@lst.de>
In-Reply-To: <20190117093001.GB31303@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [155.4.205.56]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4472;20:5zgG507gQ+Y4iS8/OgCcETw9x9lmtFEWeVVmH4C1gDu0LunuBIeHZwaicfuqcOQsCDSfcCyO58KRBXEHNGkbnwB1NL9Gql/KSwk7ueyHx4aGCUgL8flazhOAsPddwr9uggWcv4hgAoNS9oWkQ7uVNz9M9R+1CYKV0wgpLttZx20=
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 05132288-c820-475e-138d-08d67c6932c9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4472;
x-ms-traffictypediagnostic: BYAPR05MB4472:
x-microsoft-antispam-prvs: <BYAPR05MB44722224170255012F0D5D98A1830@BYAPR05MB4472.namprd05.prod.outlook.com>
x-forefront-prvs: 0920602B08
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(39860400002)(376002)(396003)(346002)(189003)(199004)(305945005)(2906002)(97736004)(486006)(4326008)(106356001)(7736002)(53936002)(105586002)(6246003)(68736007)(66066001)(102836004)(478600001)(6512007)(118296001)(6506007)(476003)(5660300001)(256004)(2616005)(11346002)(446003)(26005)(76176011)(6346003)(14444005)(93886005)(186003)(54906003)(71190400001)(71200400001)(6486002)(6436002)(14454004)(229853002)(86362001)(2501003)(7416002)(25786009)(3846002)(6116002)(8676002)(8936002)(81166006)(81156014)(316002)(99286004)(110136005)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4472;H:BYAPR05MB5592.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thellstrom@vmware.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lD2vBdEi7SVbDIHYcuOQZniDE1iKx27tNvGtsoAh1R1Ulq4M6+HEWziVsNTwDXOG8KugakjL8S3+X2DX4sF7S2gkJs1PMMcAiIzjVKYjhQN1eUR5sld9jFBUljx6mLap+kOU6elrVwrxlkxxcS2B+hVmax+uJvB446XHrxQl5FLMJmkL97uyvDtkUyg1lSGQun00s0ND6jqAhmOlkp4Ikq9h0+EIH6In6WdINxYcL/ZnVlUCkfMwjlDmk/aiNJexfEFtt70ut1JbvALvdfQS85FDfNaCHhFPC3i52TID0WwSbsJW37ioaFwj7REpb3zykPzeLVztgA2xQVvehAh8UWnt4/CntEyGdB/imfU96QZJAIBk6HOelWesdRxBAEvkG1VWGmQjh9l6zyFdx7ZjSGish+wFuYF73Phd0t2KPBE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <724C136F9533C74290DE9D9D2B8F64D1@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05132288-c820-475e-138d-08d67c6932c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2019 10:47:38.3031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4472
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

T24gVGh1LCAyMDE5LTAxLTE3IGF0IDEwOjMwICswMTAwLCBoY2hAbHN0LmRlIHdyb3RlOg0KPiBP
biBXZWQsIEphbiAxNiwgMjAxOSBhdCAxMDoyNDozNkFNIC0wNzAwLCBKYXNvbiBHdW50aG9ycGUg
d3JvdGU6DQo+ID4gVGhlIGZhY3QgaXMgdGhlcmUgaXMgMCBpbmR1c3RyeSBpbnRlcmVzdCBpbiB1
c2luZyBSRE1BIG9uIHBsYXRmb3Jtcw0KPiA+IHRoYXQgY2FuJ3QgZG8gSFcgRE1BIGNhY2hlIGNv
aGVyZW5jeSAtIHRoZSBrZXJuZWwgc3lzY2FsbHMgcmVxdWlyZWQNCj4gPiB0bw0KPiA+IGRvIHRo
ZSBjYWNoZSBmbHVzaGluZyBvbiB0aGUgSU8gcGF0aCB3b3VsZCBqdXN0IGRlc3Ryb3kgcGVyZm9y
bWFuY2UNCj4gPiB0bw0KPiA+IHRoZSBwb2ludCBvZiBtYWtpbmcgUkRNQSBwb2ludGxlc3MuIEJl
dHRlciB0byB1c2UgbmV0ZGV2IG9uIHRob3NlDQo+ID4gcGxhdGZvcm1zLg0KPiANCj4gSW4gZ2Vu
ZXJhbCB0aGVyZSBpcyBubyBzeXNjYWxsIHJlcXVpcmVkIGZvciBkb2luZyBjYWNoZSBmbHVzaGlu
ZywgeW91DQo+IGp1c3QgaXNzdWUgdGhlIHByb3BlciBpbnN0cnVjdGlvbnMgZGlyZWN0bHkgZnJv
bSB1c2Vyc3BhY2UuDQoNCkJ1dCB3aGF0IGlmIHRoZXJlIGFyZSBvdGhlciBjb2hlcmVuY2UgaXNz
dWVzPyBMaWtlIGJvdW5jZS1idWZmZXJzPw0KSSdkIGxpa2UgdG8gKzEgb24gd2hhdCBKYXNvbiBz
YXlzIGFib3V0IGluZHVzdHJ5IGludGVyZXN0OiBGV0lXLCB2bXdnZngNCmlzIHByb2JhYmx5IG9u
ZSBvZiB0aGUgZ3JhcGhpY3MgZHJpdmVycyB0aGF0IHdvdWxkIGxlbmQgaXRzZWxmIGJlc3QgdG8N
CmRvIGEgZnVsbHktZG1hLWludGVyZmFjZSBjb21wbGlhbnQgZ3JhcGhpY3Mgc3RhY2sgZXhwZXJp
bWVudC4gQnV0IGJlaW5nDQphIHBhcmF2aXJ0dWFsIGRyaXZlciwgYWxsIHBsYXRmb3JtcyB3ZSBj
YW4gZXZlciBydW4gb24gYXJlIGZ1bGx5DQpjb2hlcmVudCB1bmxlc3Mgc29tZW9uZSBpbnRyb2R1
Y2VzIGEgZmFrZSBpbmNvaGVyZW5jeSBieSBmb3JjaW5nDQpzd2lvdGxiLiBQdXR0aW5nIG1hbnkg
bWFuLW1vbnRocyBvZiBlZmZvcnQgaW50byBzdXBwb3J0aW5nIHN5c3RlbXMgb24NCndoaWNoIHdl
IHdvdWxkIG5ldmVyIHJ1biBvbiBhbmQgY2FuIG5ldmVyIHRlc3Qgb24gY2FuIG5ldmVyIG1ha2Ug
bW9yZQ0KdGhhbiBhY2FkZW1pYyBzZW5zZS4NCg0KPiAgDQo+IA0KPiA+IFRoZSByZWFsaXR5IGlz
IHRoYXQgKmFsbCogdGhlIHN1YnN5dGVtcyBkb2luZyBETUEga2VybmVsIGJ5cGFzcyBhcmUNCj4g
PiBpZ25vcmluZyB0aGUgRE1BIG1hcHBpbmcgcnVsZXMsIEkgdGhpbmsgd2Ugc2hvdWxkIHN1cHBv
cnQgdGhpcw0KPiA+IGJldHRlciwNCj4gPiBhbmQganVzdCBhY2NlcHQgdGhhdCB1c2VyIHNwYWNl
IERNQSB3aWxsIG5vdCBiZSB1c2luZyBzeW5jaW5nLg0KPiA+IEJsb2NrDQo+ID4gYWNjZXNzIGlu
IGNhc2VzIHdoZW4gdGhpcyBpcyByZXF1aXJlZCwgb3RoZXJ3aXNlIGxldCBpdCB3b3JrIGFzIGlz
DQo+ID4gdG9kYXkuDQo+IA0KPiBJbiB0aGF0IGNhc2Ugd2UganVzdCBuZWVkIHRvIGJsb2NrIHVz
ZXJzcGFjZSBETUEgYWNjZXNzIGVudGlyZWx5Lg0KPiBXaGljaCBnaXZlbiB0aGUgYW1vdW50IG9m
IHByb2JsZW1zIGl0IGNyZWF0ZXMgc291bmRzIGxpa2UgYSBwcmV0dHkNCj4gZ29vZCBpZGVhIGFu
eXdheS4NCg0KSSdtIG5vdCBzdXJlIEknbSBmb2xsb3dpbmcgeW91IGhlcmUuIEFyZSB5b3Ugc3Vn
Z2VzdGluZyBzY3JhdGNoaW5nDQpzdXBwb3J0IGZvciBhbGwgKEdQKUdQVS0gYW5kIFJETUEgZHJp
dmVycz8NCg0KVGhhbmtzLA0KVGhvbWFzDQoNCg0K
