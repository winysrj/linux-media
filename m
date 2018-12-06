Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A92BC64EB1
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 18:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF8DE20892
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 18:28:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="ckgXM7XJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF8DE20892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amd.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbeLFS2g (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 13:28:36 -0500
Received: from mail-eopbgr800051.outbound.protection.outlook.com ([40.107.80.51]:26464
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725898AbeLFS2g (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 13:28:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/LmgSzMGrlIUil4txTOMb6QuTP+1fFbv0bL+/DIKro=;
 b=ckgXM7XJIY5F2Or8f0Toaltnxm3xRaVa6atXUFZuesJd2AZMsyycUiuwC5lp2xbfkk59TatMKWGkwvHEjuz9eWBoM9Wqjpyb/04Bfc7rQugBVSFTpo8/LnRHbmyKvQyz8J6MYqEiXeypMp9mD1aCal4JASPwwgbEkD1OeF5HgnM=
Received: from BN6PR12MB1714.namprd12.prod.outlook.com (10.175.101.11) by
 BN6PR12MB1186.namprd12.prod.outlook.com (10.168.227.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1404.17; Thu, 6 Dec 2018 18:28:32 +0000
Received: from BN6PR12MB1714.namprd12.prod.outlook.com
 ([fe80::f8a7:157:6224:34ee]) by BN6PR12MB1714.namprd12.prod.outlook.com
 ([fe80::f8a7:157:6224:34ee%2]) with mapi id 15.20.1404.021; Thu, 6 Dec 2018
 18:28:32 +0000
From:   "Koenig, Christian" <Christian.Koenig@amd.com>
To:     "jglisse@redhat.com" <jglisse@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        =?utf-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] dma-buf: balance refcount inbalance
Thread-Topic: [PATCH] dma-buf: balance refcount inbalance
Thread-Index: AQHUjX9gMTWw8AdIsUKlQlT/QyAMDqVyB/SA
Date:   Thu, 6 Dec 2018 18:28:32 +0000
Message-ID: <d2e94866-08fe-048a-2196-b217e8535269@amd.com>
References: <20181206161840.6578-1-jglisse@redhat.com>
In-Reply-To: <20181206161840.6578-1-jglisse@redhat.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
x-originating-ip: [2a02:908:125b:9a00:a142:2be6:b7be:5a3a]
x-clientproxiedby: AM6P193CA0117.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::22) To BN6PR12MB1714.namprd12.prod.outlook.com
 (2603:10b6:404:106::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BN6PR12MB1186;20:YRLdD2GBni6CCvJt3sVp+oqG1VM9Bxvr0x+kjzSQoVI6NGoBYEuEhJV9l19eFjPd2hQrSVEjRAeUwFQRUmPc+W3BWsz3kzwGYKQFlJ9kG3wfchKGmqrg2SNSxWPG8TOYZq67UKe20WNQkrq62E/x3LxTT16ufuvPnByBLlYA72J5Uk7pQPs6/XacEf6nAlKUtjBXKa6VUeSwEkcGGMsAxY2VEj7EqMQWcss1ZI3tzefFUCLNQT786gR1Em91XYgy
x-ms-office365-filtering-correlation-id: 4b28969f-94aa-454d-bc81-08d65ba8a05c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BN6PR12MB1186;
x-ms-traffictypediagnostic: BN6PR12MB1186:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Christian.Koenig@amd.com; 
x-microsoft-antispam-prvs: <BN6PR12MB1186164CF3E1F50308C304C783A90@BN6PR12MB1186.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3231455)(999002)(944501520)(52105112)(93006095)(93001095)(3002001)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123564045)(20161123558120)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BN6PR12MB1186;BCL:0;PCL:0;RULEID:;SRVR:BN6PR12MB1186;
x-forefront-prvs: 087894CD3C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(136003)(346002)(376002)(189003)(199004)(7736002)(486006)(6486002)(5660300001)(65826007)(256004)(110136005)(46003)(316002)(58126008)(8676002)(31686004)(229853002)(305945005)(71190400001)(6436002)(6116002)(54906003)(81156014)(81166006)(71200400001)(8936002)(2501003)(2616005)(97736004)(4326008)(52116002)(11346002)(476003)(64126003)(76176011)(99286004)(36756003)(6506007)(446003)(65956001)(65806001)(386003)(186003)(106356001)(6246003)(102836004)(68736007)(14454004)(6512007)(31696002)(86362001)(72206003)(53936002)(478600001)(105586002)(25786009)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR12MB1186;H:BN6PR12MB1714.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: z550uwdfNBjw7MMlc5WVI2SisIQFEP/GfRyReSDS26uhvzo47zi6NmvuKBzMl9O1umYYutdY+i2aodUAsAoJ+6B667lz4CbtiJQQRyPjMZXqY2Dar+E81cwie24HhRK1JN5VTzm0+Xlix16DylPcGVdfvcIyCps7TuEm3vaeDCTaeZQNSs5k7NW0Wh1GUI2wdCsvUtqqHadP01iMR7YL4kftlFeADWdxdYf4kx7BtK0l+QKQXdFElgV/fX0aWq3slo5QpIIle+Oh4RsfkkfHOIylzpGZL0RWFc3MMjwGGJrb4qyovdmC83T7a60o8NIXFqT4LH8DlZxecgdCnZllTly+119DN4OxvMeNEWDdbe8=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <462953F3243385429E9DB03AF1C4B634@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b28969f-94aa-454d-bc81-08d65ba8a05c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2018 18:28:32.6732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1186
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

QW0gMDYuMTIuMTggdW0gMTc6MTggc2NocmllYiBqZ2xpc3NlQHJlZGhhdC5jb206DQo+IEZyb206
IErDqXLDtG1lIEdsaXNzZSA8amdsaXNzZUByZWRoYXQuY29tPg0KPg0KPiBUaGUgZGVidWdmcyB0
YWtlIHJlZmVyZW5jZSBvbiBmZW5jZSB3aXRob3V0IGRyb3BwaW5nIHRoZW0uDQo+DQo+IFNpZ25l
ZC1vZmYtYnk6IErDqXLDtG1lIEdsaXNzZSA8amdsaXNzZUByZWRoYXQuY29tPg0KPiBDYzogQ2hy
aXN0aWFuIEvDtm5pZyA8Y2hyaXN0aWFuLmtvZW5pZ0BhbWQuY29tPg0KPiBDYzogRGFuaWVsIFZl
dHRlciA8ZGFuaWVsLnZldHRlckBmZndsbC5jaD4NCj4gQ2M6IFN1bWl0IFNlbXdhbCA8c3VtaXQu
c2Vtd2FsQGxpbmFyby5vcmc+DQo+IENjOiBsaW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmcNCj4g
Q2M6IGRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcNCj4gQ2M6IGxpbmFyby1tbS1zaWdA
bGlzdHMubGluYXJvLm9yZw0KPiBDYzogU3TDqXBoYW5lIE1hcmNoZXNpbiA8bWFyY2hldUBjaHJv
bWl1bS5vcmc+DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQoNClJldmlld2VkLWJ5OiBD
aHJpc3RpYW4gS8O2bmlnIDxjaHJpc3RpYW4ua29lbmlnQGFtZC5jb20+DQoNCj4gLS0tDQo+ICAg
ZHJpdmVycy9kbWEtYnVmL2RtYS1idWYuYyB8IDEgKw0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9kbWEtYnVmL2RtYS1idWYuYyBi
L2RyaXZlcnMvZG1hLWJ1Zi9kbWEtYnVmLmMNCj4gaW5kZXggMTM4ODQ0NzRkMTU4Li42OTg0MjE0
NWMyMjMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZG1hLWJ1Zi9kbWEtYnVmLmMNCj4gKysrIGIv
ZHJpdmVycy9kbWEtYnVmL2RtYS1idWYuYw0KPiBAQCAtMTA2OSw2ICsxMDY5LDcgQEAgc3RhdGlj
IGludCBkbWFfYnVmX2RlYnVnX3Nob3coc3RydWN0IHNlcV9maWxlICpzLCB2b2lkICp1bnVzZWQp
DQo+ICAgCQkJCSAgIGZlbmNlLT5vcHMtPmdldF9kcml2ZXJfbmFtZShmZW5jZSksDQo+ICAgCQkJ
CSAgIGZlbmNlLT5vcHMtPmdldF90aW1lbGluZV9uYW1lKGZlbmNlKSwNCj4gICAJCQkJICAgZG1h
X2ZlbmNlX2lzX3NpZ25hbGVkKGZlbmNlKSA/ICIiIDogInVuIik7DQo+ICsJCQlkbWFfZmVuY2Vf
cHV0KGZlbmNlKTsNCj4gICAJCX0NCj4gICAJCXJjdV9yZWFkX3VubG9jaygpOw0KPiAgIA0KDQo=
