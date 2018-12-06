Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C14C04EB9
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 08:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13D9A21479
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 08:09:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="bd1Nl1xX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13D9A21479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amd.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbeLFIJc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 03:09:32 -0500
Received: from mail-eopbgr760057.outbound.protection.outlook.com ([40.107.76.57]:39424
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729062AbeLFIJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 03:09:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdDVxcG3ALM8+OHCX/P7+0z8zqrg6ErHBQY0W0KY5D8=;
 b=bd1Nl1xXvrnVPoLdMxwzNAsgIrbJ5Ldd/XVDvqz449WHTeYVmHNaHWADDX9ngTRP3PyHUWatV9+9WF3n43I3KpLtR71LGlenPP0mXr9/dlUimun1RYMStiVCovmfHr453ANCYwgw9ywY0mdkLKboFBxzJQMEmPdIjZ3IJJJvKCA=
Received: from BN6PR12MB1714.namprd12.prod.outlook.com (10.175.101.11) by
 BN6PR12MB1314.namprd12.prod.outlook.com (10.168.228.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.22; Thu, 6 Dec 2018 08:09:28 +0000
Received: from BN6PR12MB1714.namprd12.prod.outlook.com
 ([fe80::f8a7:157:6224:34ee]) by BN6PR12MB1714.namprd12.prod.outlook.com
 ([fe80::f8a7:157:6224:34ee%2]) with mapi id 15.20.1404.021; Thu, 6 Dec 2018
 08:09:28 +0000
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
Subject: Re: [PATCH] dma-buf: fix debugfs versus rcu and fence dumping
Thread-Topic: [PATCH] dma-buf: fix debugfs versus rcu and fence dumping
Thread-Index: AQHUjQTV9bhqQp9d+U2JZ+bK24/P+aVxW/SA
Date:   Thu, 6 Dec 2018 08:09:28 +0000
Message-ID: <b520e7b6-a8f6-da49-fc7d-460823eabf47@amd.com>
References: <20181206014103.1364-1-jglisse@redhat.com>
In-Reply-To: <20181206014103.1364-1-jglisse@redhat.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
x-originating-ip: [2a02:908:125b:9a00:a142:2be6:b7be:5a3a]
x-clientproxiedby: AM6PR0202CA0053.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::30) To BN6PR12MB1714.namprd12.prod.outlook.com
 (2603:10b6:404:106::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Christian.Koenig@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BN6PR12MB1314;20:UpLOUF8+cP68mNr9es0jZIXadDV6Pvqvv2fZfHRqw2W2uo1ToufjML9UgFxJpaDU9SBRB8aTq/3EIotOU9b7MOBdIw9WgfiSNYRfV1L5vpHbAywTWTP4R8wxiAUTympN3Dtx7BRGxOFSVfIWTItAoin7IxhEvnGf/MfgfPhsnEUqTVi1B+cILqCA1IFU23oJ1tI1TQ0bGWC3XmBOd2EK/XXh85VriSBGSRK2NyTh8OC8syTgJ4gcnh59Gvie6QXi
x-ms-office365-filtering-correlation-id: 0eac15ab-6eaf-40a9-47b4-08d65b5224f7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BN6PR12MB1314;
x-ms-traffictypediagnostic: BN6PR12MB1314:
x-microsoft-antispam-prvs: <BN6PR12MB13148BD86831999DBECD013583A90@BN6PR12MB1314.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231455)(999002)(944501520)(52105112)(6055026)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123560045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BN6PR12MB1314;BCL:0;PCL:0;RULEID:;SRVR:BN6PR12MB1314;
x-forefront-prvs: 087894CD3C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(189003)(52116002)(71200400001)(71190400001)(53936002)(186003)(25786009)(6512007)(65826007)(229853002)(6246003)(66574009)(7736002)(6116002)(58126008)(6436002)(68736007)(76176011)(6486002)(305945005)(5660300001)(97736004)(54906003)(386003)(4326008)(110136005)(14454004)(6506007)(256004)(14444005)(36756003)(86362001)(106356001)(316002)(478600001)(46003)(72206003)(11346002)(99286004)(446003)(8676002)(31696002)(102836004)(65806001)(65956001)(64126003)(2906002)(476003)(31686004)(2501003)(2616005)(81156014)(81166006)(105586002)(486006)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR12MB1314;H:BN6PR12MB1714.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: kVLa3+8CpK75/vqC566vgTt+lZLJyfnU6QGqkkG7MKPyrTiEGia+FGL3/SXM4mwMCVaM6PkePzHZ0AFhIO6fP2fZe7iYnk+AhTc39ke0efsf+tf4v3fFGgApjfrXRCP0hWVjgcYkKLEdyuqOJpIzDNvdPa8m9zFg1rYNOvgSq9rxMgkXtxE0wz0qiOO6KXS1Ptcce05SJLBiprF1En3mvA4/izLHzqqnl06d85rWeNVz4NF/ldR8Uf8eXgw20tmLYl94YO6spa4hOl+b7fUCxaOazaKab86B0yMeUzLxYEQRIsPcmVx+ZBdOr97ikMW+keXbltnaQp+rdI66Ef+JTt/eCcIBr/GcDRpJyoG0hIs=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <A98628569431534097434057866ADF28@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eac15ab-6eaf-40a9-47b4-08d65b5224f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2018 08:09:28.6996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1314
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

QW0gMDYuMTIuMTggdW0gMDI6NDEgc2NocmllYiBqZ2xpc3NlQHJlZGhhdC5jb206DQo+IEZyb206
IErDqXLDtG1lIEdsaXNzZSA8amdsaXNzZUByZWRoYXQuY29tPg0KPg0KPiBUaGUgZGVidWdmcyB0
YWtlIHJlZmVyZW5jZSBvbiBmZW5jZSB3aXRob3V0IGRyb3BwaW5nIHRoZW0uIEFsc28gdGhlDQo+
IHJjdSBzZWN0aW9uIGFyZSBub3Qgd2VsbCBiYWxhbmNlLiBGaXggYWxsIHRoYXQgLi4uDQo+DQo+
IFNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIEdsaXNzZSA8amdsaXNzZUByZWRoYXQuY29tPg0KPiBD
YzogQ2hyaXN0aWFuIEvDtm5pZyA8Y2hyaXN0aWFuLmtvZW5pZ0BhbWQuY29tPg0KPiBDYzogRGFu
aWVsIFZldHRlciA8ZGFuaWVsLnZldHRlckBmZndsbC5jaD4NCj4gQ2M6IFN1bWl0IFNlbXdhbCA8
c3VtaXQuc2Vtd2FsQGxpbmFyby5vcmc+DQo+IENjOiBsaW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5v
cmcNCj4gQ2M6IGRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcNCj4gQ2M6IGxpbmFyby1t
bS1zaWdAbGlzdHMubGluYXJvLm9yZw0KPiBDYzogU3TDqXBoYW5lIE1hcmNoZXNpbiA8bWFyY2hl
dUBjaHJvbWl1bS5vcmc+DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQoNCldlbGwgTkFL
LCB5b3UgYXJlIG5vdyB0YWtpbmcgdGhlIFJDVSBsb2NrIHR3aWNlIGFuZCBkcm9wcGluZyB0aGUg
UkNVIGFuZCANCnN0aWxsIGFjY2Vzc2luZyBmb2JqIGhhcyBhIGh1Z2UgcG90ZW50aWFsIGZvciBh
Y2Nlc3NpbmcgZnJlZWQgdXAgbWVtb3J5Lg0KDQpUaGUgb25seSBjb3JyZWN0IHRoaW5nIEkgY2Fu
IHNlZSBoZXJlIGlzIHRvIGdyYWIgYSByZWZlcmVuY2UgdG8gdGhlIA0KZmVuY2UgYmVmb3JlIHBy
aW50aW5nIGFueSBpbmZvIG9uIGl0LA0KQ2hyaXN0aWFuLg0KDQo+IC0tLQ0KPiAgIGRyaXZlcnMv
ZG1hLWJ1Zi9kbWEtYnVmLmMgfCAxMSArKysrKysrKystLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCA5
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L2RtYS1idWYvZG1hLWJ1Zi5jIGIvZHJpdmVycy9kbWEtYnVmL2RtYS1idWYuYw0KPiBpbmRleCAx
Mzg4NDQ3NGQxNTguLmY2ZjRkZTQyYWM0OSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9kbWEtYnVm
L2RtYS1idWYuYw0KPiArKysgYi9kcml2ZXJzL2RtYS1idWYvZG1hLWJ1Zi5jDQo+IEBAIC0xMDUx
LDI0ICsxMDUxLDMxIEBAIHN0YXRpYyBpbnQgZG1hX2J1Zl9kZWJ1Z19zaG93KHN0cnVjdCBzZXFf
ZmlsZSAqcywgdm9pZCAqdW51c2VkKQ0KPiAgIAkJCWZvYmogPSByY3VfZGVyZWZlcmVuY2Uocm9i
ai0+ZmVuY2UpOw0KPiAgIAkJCXNoYXJlZF9jb3VudCA9IGZvYmogPyBmb2JqLT5zaGFyZWRfY291
bnQgOiAwOw0KPiAgIAkJCWZlbmNlID0gcmN1X2RlcmVmZXJlbmNlKHJvYmotPmZlbmNlX2V4Y2wp
Ow0KPiArCQkJZmVuY2UgPSBkbWFfZmVuY2VfZ2V0X3JjdShmZW5jZSk7DQo+ICAgCQkJaWYgKCFy
ZWFkX3NlcWNvdW50X3JldHJ5KCZyb2JqLT5zZXEsIHNlcSkpDQo+ICAgCQkJCWJyZWFrOw0KPiAg
IAkJCXJjdV9yZWFkX3VubG9jaygpOw0KPiAgIAkJfQ0KPiAtDQo+IC0JCWlmIChmZW5jZSkNCj4g
KwkJaWYgKGZlbmNlKSB7DQo+ICAgCQkJc2VxX3ByaW50ZihzLCAiXHRFeGNsdXNpdmUgZmVuY2U6
ICVzICVzICVzc2lnbmFsbGVkXG4iLA0KPiAgIAkJCQkgICBmZW5jZS0+b3BzLT5nZXRfZHJpdmVy
X25hbWUoZmVuY2UpLA0KPiAgIAkJCQkgICBmZW5jZS0+b3BzLT5nZXRfdGltZWxpbmVfbmFtZShm
ZW5jZSksDQo+ICAgCQkJCSAgIGRtYV9mZW5jZV9pc19zaWduYWxlZChmZW5jZSkgPyAiIiA6ICJ1
biIpOw0KPiArCQkJZG1hX2ZlbmNlX3B1dChmZW5jZSk7DQo+ICsJCX0NCj4gKw0KPiArCQlyY3Vf
cmVhZF9sb2NrKCk7DQo+ICAgCQlmb3IgKGkgPSAwOyBpIDwgc2hhcmVkX2NvdW50OyBpKyspIHsN
Cj4gICAJCQlmZW5jZSA9IHJjdV9kZXJlZmVyZW5jZShmb2JqLT5zaGFyZWRbaV0pOw0KPiAgIAkJ
CWlmICghZG1hX2ZlbmNlX2dldF9yY3UoZmVuY2UpKQ0KPiAgIAkJCQljb250aW51ZTsNCj4gKwkJ
CXJjdV9yZWFkX3VubG9jaygpOw0KPiAgIAkJCXNlcV9wcmludGYocywgIlx0U2hhcmVkIGZlbmNl
OiAlcyAlcyAlc3NpZ25hbGxlZFxuIiwNCj4gICAJCQkJICAgZmVuY2UtPm9wcy0+Z2V0X2RyaXZl
cl9uYW1lKGZlbmNlKSwNCj4gICAJCQkJICAgZmVuY2UtPm9wcy0+Z2V0X3RpbWVsaW5lX25hbWUo
ZmVuY2UpLA0KPiAgIAkJCQkgICBkbWFfZmVuY2VfaXNfc2lnbmFsZWQoZmVuY2UpID8gIiIgOiAi
dW4iKTsNCj4gKwkJCWRtYV9mZW5jZV9wdXQoZmVuY2UpOw0KPiArCQkJcmN1X3JlYWRfbG9jaygp
Ow0KPiAgIAkJfQ0KPiAgIAkJcmN1X3JlYWRfdW5sb2NrKCk7DQo+ICAgDQoNCg==
