Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39A9C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 07:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F2FC20859
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 07:28:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="wOFiULek"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388279AbfAPH2V (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 02:28:21 -0500
Received: from mail-eopbgr820048.outbound.protection.outlook.com ([40.107.82.48]:11632
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733101AbfAPH2V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 02:28:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNlnge5VSLhi0mZz1nnVlQkl6RZrc49p3RMaUPHGqjg=;
 b=wOFiULekIYiRyqQ5eYmh8TYmHlaZrpIcf4AqE/b/t7oPFpAdCDHXJ8tmsi48ECg8WiU8m8G2gvo2SBvDEg1tNNsvfkQAdWXpzcOdfzqP2rlrQqFdOZpNCW/Cnz+UptXpAoGib72bKiywmRMQb6oQUudgb/FmYn2g4M/EZ5Dr0+k=
Received: from CY4PR12MB1717.namprd12.prod.outlook.com (10.175.62.139) by
 CY4PR12MB1830.namprd12.prod.outlook.com (10.175.81.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.25; Wed, 16 Jan 2019 07:28:13 +0000
Received: from CY4PR12MB1717.namprd12.prod.outlook.com
 ([fe80::7dec:669a:ec18:7f0f]) by CY4PR12MB1717.namprd12.prod.outlook.com
 ([fe80::7dec:669a:ec18:7f0f%7]) with mapi id 15.20.1516.019; Wed, 16 Jan 2019
 07:28:13 +0000
From:   "Koenig, Christian" <Christian.Koenig@amd.com>
To:     Thomas Hellstrom <thellstrom@vmware.com>, "hch@lst.de" <hch@lst.de>
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
Thread-Index: AQHUrOXdj04wr1dVGkWvqY6Mg4pf06Wwn32AgAAHy4CAAAuYgIAAHVSAgACq4YCAAAUpgA==
Date:   Wed, 16 Jan 2019 07:28:13 +0000
Message-ID: <8aadac80-da9b-b52a-a4bf-066406127117@amd.com>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
 <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com>
 <20190115152029.GB2325@lst.de>
 <41d0616e95fb48942404fb54d82249f5700affb1.camel@vmware.com>
 <20190115183133.GA12350@lst.de>
 <c82076aa-a6ee-5ba2-a8d8-935fdbb7d5ca@amd.com>
 <20190115205801.GA15432@lst.de>
 <01e5522bf88549bfdaea1430fece23cb3d1a1a55.camel@vmware.com>
In-Reply-To: <01e5522bf88549bfdaea1430fece23cb3d1a1a55.camel@vmware.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
x-originating-ip: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
x-clientproxiedby: AM6PR06CA0015.eurprd06.prod.outlook.com
 (2603:10a6:20b:14::28) To CY4PR12MB1717.namprd12.prod.outlook.com
 (2603:10b6:903:121::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Christian.Koenig@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR12MB1830;20:e7Nd8p7n/85MKbtFbsj7lwdrxo4D5p9rooLa3S9swfnOBjAlMGPrn/rXeZIHEbOzQV003nw5ygJQ7Ja4hO3jKmpNjelVM5RvDqC3w3JiZIFIee24Y6tTNbN39+zyoD8CrgiheugLc7zeIqlARh9dTFp7ipoG15uquL9oTWq2SE1PPNXFXIlupviGTa5H1/3Isk8w8g691lYwffzz2329I3nnZPwamNBTa8bC+fDQsY9DEn2JgMDwrEwbEXJlZqQB
x-ms-office365-filtering-correlation-id: 39c2fca6-2d84-45ad-626c-08d67b842c98
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:CY4PR12MB1830;
x-ms-traffictypediagnostic: CY4PR12MB1830:
x-microsoft-antispam-prvs: <CY4PR12MB183088B1002C574BA99FD54183820@CY4PR12MB1830.namprd12.prod.outlook.com>
x-forefront-prvs: 091949432C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(64126003)(6486002)(58126008)(305945005)(72206003)(53936002)(106356001)(6512007)(110136005)(478600001)(14444005)(256004)(476003)(14454004)(68736007)(93886005)(6116002)(31696002)(316002)(7736002)(71190400001)(86362001)(71200400001)(8676002)(5660300001)(76176011)(6506007)(2501003)(386003)(65826007)(486006)(97736004)(186003)(54906003)(36756003)(46003)(81166006)(81156014)(7416002)(52116002)(65956001)(65806001)(8936002)(2616005)(25786009)(105586002)(11346002)(2906002)(446003)(99286004)(6246003)(102836004)(4326008)(229853002)(31686004)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1830;H:CY4PR12MB1717.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: P5MirGg/wOUv9l+yl9x0f723Gi7Uae39UR+xnNa/MwCPDXYVGVdVmkZijKdVE7E7pl9B4PjmckcRJUPwIT/gL/I/Xdy35//w5ObC/5AB1spbOz/tPVqipcwz9mODimiuwxasXSGlI5GbfxhPmUAKP+vp53krge5wikBDNw7BYJjQPJ40OU3vKYxn+0B+3ciV/rPm5AqQOqfcmtJ1icBWwG9fz6Ks4Re23gNx1C4eueEvJ5m1MxTe/42p+MziM/JeXPPeLnFnhininEv0vvhawbbwBJ4uceum3xDUr7tpUGO8xYOLUfFlVhx3ZHBFyWvUya4g2vG9KPNt+Kz4C9PWYq9D5DTNCc2CddyOyyVMd+qzvZxpCej3N1VCwUnEIj2ImvRUfhHH5QwFQZJQumSP0q/EAPorIkBJUnQ1XLWEB7E=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4275FA746EF0941B06A19C769236B4D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39c2fca6-2d84-45ad-626c-08d67b842c98
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2019 07:28:10.9297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1830
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

QW0gMTYuMDEuMTkgdW0gMDg6MDkgc2NocmllYiBUaG9tYXMgSGVsbHN0cm9tOg0KPiBPbiBUdWUs
IDIwMTktMDEtMTUgYXQgMjE6NTggKzAxMDAsIGhjaEBsc3QuZGUgd3JvdGU6DQo+PiBPbiBUdWUs
IEphbiAxNSwgMjAxOSBhdCAwNzoxMzoxMVBNICswMDAwLCBLb2VuaWcsIENocmlzdGlhbiB3cm90
ZToNCj4+PiBUaG9tYXMgaXMgY29ycmVjdCB0aGF0IHRoZSBpbnRlcmZhY2UgeW91IHByb3Bvc2Ug
aGVyZSBkb2Vzbid0IHdvcmsNCj4+PiBhdA0KPj4+IGFsbCBmb3IgR1BVcy4NCj4+Pg0KPj4+IFRo
ZSBrZXJuZWwgZHJpdmVyIGlzIG5vdCBpbmZvcm1lZCBvZiBmbHVzaC9zeW5jLCBidXQgcmF0aGVy
IGp1c3QNCj4+PiBzZXR1cHMNCj4+PiBjb2hlcmVudCBtYXBwaW5ncyBiZXR3ZWVuIHN5c3RlbSBt
ZW1vcnkgYW5kIGRldmljZXMuDQo+Pj4NCj4+PiBJbiBvdGhlciB3b3JkcyB5b3UgaGF2ZSBhbiBh
cnJheSBvZiBzdHJ1Y3QgcGFnZXMgYW5kIG5lZWQgdG8gbWFwDQo+Pj4gdGhhdCB0bw0KPj4+IGEg
c3BlY2lmaWMgZGV2aWNlIGFuZCBzbyBjcmVhdGUgZG1hX2FkZHJlc3NlcyBmb3IgdGhlIG1hcHBp
bmdzLg0KPj4gSWYgeW91IHdhbnQgYSBjb2hlcmVudCBtYXBwaW5nIHlvdSBuZWVkIHRvIHVzZSBk
bWFfYWxsb2NfY29oZXJlbnQNCj4+IGFuZCBkbWFfbW1hcF9jb2hlcmVudCBhbmQgeW91IGFyZSBk
b25lLCB0aGF0IGlzIG5vdCB0aGUgcHJvYmxlbS4NCj4+IFRoYXQgYWN0dWFsbHkgaXMgb25lIG9m
IHRoZSB2bWdmeCBtb2Rlcywgc28gSSBkb24ndCB1bmRlcnN0YW5kIHdoYXQNCj4+IHByb2JsZW0g
d2UgYXJlIHRyeWluZyB0byBzb2x2ZSBpZiB5b3UgZG9uJ3QgYWN0dWFsbHkgd2FudCBhIG5vbi0N
Cj4+IGNvaGVyZW50IG1hcHBpbmcuDQo+IEZvciB2bXdnZngsIG5vdCBtYWtpbmcgZG1hX2FsbG9j
X2NvaGVyZW50IGRlZmF1bHQgaGFzIGEgY291cGxlIG9mDQo+IHJlYXNvbnM6DQo+IDEpIE1lbW9y
eSBpcyBhc3NvY2lhdGVkIHdpdGggYSBzdHJ1Y3QgZGV2aWNlLiBJdCBoYXMgbm90IGJlZW4gY2xl
YXINCj4gdGhhdCBpdCBpcyBleHBvcnRhYmxlIHRvIG90aGVyIGRldmljZXMuDQo+IDIpIFRoZXJl
IHNlZW1zIHRvIGJlIHJlc3RyaWN0aW9ucyBpbiB0aGUgc3lzdGVtIHBhZ2VzIGFsbG93YWJsZS4g
R1BVcw0KPiBnZW5lcmFsbHkgcHJlZmVyIGhpZ2htZW0gcGFnZXMgYnV0IGRtYV9hbGxvY19jb2hl
cmVudCByZXR1cm5zIGEgdmlydHVhbA0KPiBhZGRyZXNzIGltcGx5aW5nIEdGUF9LRVJORUw/IFdo
aWxlIG5vdCB1c2VkIGJ5IHZtd2dmeCwgVFRNIHR5cGljYWxseQ0KPiBwcmVmZXJzIEhJR0hNRU0g
cGFnZXMgdG8gZmFjaWxpdGF0ZSBjYWNoaW5nIG1vZGUgc3dpdGNoaW5nIHdpdGhvdXQNCj4gaGF2
aW5nIHRvIHRvdWNoIHRoZSBrZXJuZWwgbWFwLg0KPiAzKSBIaXN0b3JpY2FsbHkgd2UgaGFkIEFQ
SXMgdG8gYWxsb3cgY29oZXJlbnQgYWNjZXNzIHRvIHVzZXItc3BhY2UNCj4gZGVmaW5lZCBwYWdl
cy4gVGhhdCBoYXMgZ29uZSBhd2F5IG5vdCBidXQgdGhlIGluZnJhc3RydWN0dXJlIHdhcyBidWls
dA0KPiBhcm91bmQgaXQuDQo+DQo+IGRtYV9tbWFwX2NvaGVyZW50IGlzbid0IHVzZSBiZWNhdXNl
IGFzIHRoZSBkYXRhIG1vdmVzIGJldHdlZW4gc3lzdGVtDQo+IG1lbW9yeSwgc3dhcCBhbmQgVlJB
TSwgUFRFcyBvZiB1c2VyLXNwYWNlIG1hcHBpbmdzIGFyZSBhZGp1c3RlZA0KPiBhY2NvcmRpbmds
eSwgbWVhbmluZyB1c2VyLXNwYWNlIGRvZXNuJ3QgaGF2ZSB0byB1bm1hcCB3aGVuIGFuIG9wZXJh
dGlvbg0KPiBpcyBpbml0aWF0ZWQgdGhhdCBtaWdodCBtZWFuIHRoZSBkYXRhIGlzIG1vdmVkLg0K
DQpUbyBzdW1tYXJpemUgb25jZSBtb3JlOiBXZSBoYXZlIGFuIGFycmF5IG9mIHN0cnVjdCBwYWdl
cyBhbmQgd2FudCB0byANCmNvaGVyZW50bHkgbWFwIHRoYXQgdG8gYSBkZXZpY2UuDQoNCklmIHRo
YXQgaXMgbm90IHBvc3NpYmxlIGJlY2F1c2Ugb2Ygd2hhdGV2ZXIgcmVhc29uIHdlIHdhbnQgdG8g
Z2V0IGFuIA0KZXJyb3IgY29kZSBvciBldmVuIG5vdCBsb2FkIHRoZSBkcml2ZXIgZnJvbSB0aGUg
YmVnaW5uaW5nLg0KDQo+DQo+DQo+PiBBbHRob3VnaCBsYXN0IHRpbWUgSSBoYWQgdGhhdCBkaXNj
dXNzaW9uIHdpdGggRGFuaWVsIFZldHRlcg0KPj4gSSB3YXMgdW5kZXIgdGhlIGltcHJlc3Npb25z
IHRoYXQgR1BVcyByZWFsbHkgd2FudGVkIG5vbi1jb2hlcmVudA0KPj4gbWFwcGluZ3MuDQo+IElu
dGVsIGhpc3RvcmljYWxseSBoYXMgZG9uZSB0aGluZ3MgYSBiaXQgZGlmZmVyZW50bHkuIEFuZCBp
dCdzIGFsc28NCj4gcG9zc2libGUgdGhhdCBlbWJlZGRlZCBwbGF0Zm9ybXMgYW5kIEFSTSBwcmVm
ZXIgdGhpcyBtb2RlIG9mIG9wZXJhdGlvbiwNCj4gYnV0IEkgaGF2ZW4ndCBjYXVnaHQgdXAgb24g
dGhhdCBkaXNjdXNzaW9uLg0KPg0KPj4gQnV0IGlmIHlvdSB3YW50IGEgY29oZXJlbnQgbWFwcGlu
ZyB5b3UgY2FuJ3QgZ28gdG8gYSBzdHJ1Y3QgcGFnZSwNCj4+IGJlY2F1c2Ugb24gbWFueSBzeXN0
ZW1zIHlvdSBjYW4ndCBqdXN0IG1hcCBhcmJpdHJhcnkgbWVtb3J5IGFzDQo+PiB1bmNhY2hhYmxl
LiAgSXQgbWlnaHQgZWl0aGVyIGNvbWUgZnJvbSB2ZXJ5IHNwZWNpYWwgbGltaXRlZCBwb29scywN
Cj4+IG9yIG1pZ2h0IG5lZWQgb3RoZXIgbWFnaWMgYXBwbGllZCB0byBpdCBzbyB0aGF0IGl0IGlz
IG5vdCB2aXNpYmxlDQo+PiBpbiB0aGUgbm9ybWFsIGRpcmVjdCBtYXBwaW5nLCBvciBhdCBsZWFz
dCBub3QgYWNjZXNzIHRocm91Z2ggaXQuDQo+DQo+IFRoZSBUVE0gc3Vic3lzdGVtIGhhcyBiZWVu
IHJlbGllZCBvbiB0byBwcm92aWRlIGNvaGVyZW50IG1lbW9yeSB3aXRoDQo+IHRoZSBvcHRpb24g
dG8gc3dpdGNoIGNhY2hpbmcgbW9kZSBvZiBwYWdlcy4gQnV0IG9ubHkgb24gc2VsZWN0ZWQgYW5k
DQo+IHdlbGwgdGVzdGVkIHBsYXRmb3Jtcy4gT24gb3RoZXIgcGxhdGZvcm1zIHdlIHNpbXBseSBk
byBub3QgbG9hZCwgYW5kDQo+IHRoYXQncyBmaW5lIGZvciBub3cuDQo+DQo+IEJ1dCBhcyBtZW50
aW9uZWQgbXVsdGlwbGUgdGltZXMsIHRvIG1ha2UgR1BVIGRyaXZlcnMgbW9yZSBjb21wbGlhbnQs
DQo+IHdlJ2QgcmVhbGx5IHdhbnQgdGhhdA0KPg0KPiBib29sIGRtYV9zdHJlYW1pbmdfaXNfY29o
ZXJlbnQoY29uc3Qgc3RydWN0IGRldmljZSAqKQ0KPg0KPiBBUEkgdG8gaGVscCB1cyBkZWNpZGUg
d2hlbiB0byBsb2FkIG9yIG5vdC4NCg0KWWVzLCBwbGVhc2UuDQoNCkNocmlzdGlhbi4NCg0KPg0K
PiBUaGFua3MsDQo+IFRob21hcw0KPg0KPg0KPg0KPg0KPg0KPg0KPg0KDQo=
