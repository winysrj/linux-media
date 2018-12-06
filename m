Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24293C64EB1
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 16:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6FEE20838
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 16:08:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="HHfhEPfb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6FEE20838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amd.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbeLFQIR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 11:08:17 -0500
Received: from mail-eopbgr800042.outbound.protection.outlook.com ([40.107.80.42]:20221
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbeLFQIQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 11:08:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNisFtIQyORIYJTtq9I4jd7HlZs8fPKcbLnbpUelshc=;
 b=HHfhEPfbvpk4vBK1UasPBb5VytNkKl2qlUfinCREjcmDduuHRTLIhFvsQM7vf3UAQP9J/ZPVNrbrffXz22h9UQDazpxhqhp0K8ljAvTGp364iICo+IWZF59uOUVr+gZoB/lEU7l7O2mE6igZv2AILy5dW1RrPIz93FmRC1g9veA=
Received: from BN6PR12MB1714.namprd12.prod.outlook.com (10.175.101.11) by
 BN6PR12MB1876.namprd12.prod.outlook.com (10.175.100.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1404.20; Thu, 6 Dec 2018 16:08:12 +0000
Received: from BN6PR12MB1714.namprd12.prod.outlook.com
 ([fe80::f8a7:157:6224:34ee]) by BN6PR12MB1714.namprd12.prod.outlook.com
 ([fe80::f8a7:157:6224:34ee%2]) with mapi id 15.20.1404.021; Thu, 6 Dec 2018
 16:08:12 +0000
From:   "Koenig, Christian" <Christian.Koenig@amd.com>
To:     Jerome Glisse <jglisse@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        =?utf-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] dma-buf: fix debugfs versus rcu and fence dumping
Thread-Topic: [PATCH] dma-buf: fix debugfs versus rcu and fence dumping
Thread-Index: AQHUjQTV9bhqQp9d+U2JZ+bK24/P+aVxW/SAgAB4rICAAA0OAA==
Date:   Thu, 6 Dec 2018 16:08:12 +0000
Message-ID: <4e79bf05-864e-f3ca-194c-40c4504e472a@amd.com>
References: <20181206014103.1364-1-jglisse@redhat.com>
 <b520e7b6-a8f6-da49-fc7d-460823eabf47@amd.com>
 <20181206152116.GA3544@redhat.com>
In-Reply-To: <20181206152116.GA3544@redhat.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
x-originating-ip: [2a02:908:125b:9a00:a142:2be6:b7be:5a3a]
x-clientproxiedby: AM5PR0701CA0007.eurprd07.prod.outlook.com
 (2603:10a6:203:51::17) To BN6PR12MB1714.namprd12.prod.outlook.com
 (2603:10b6:404:106::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Christian.Koenig@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BN6PR12MB1876;20:FgSXnFTA5F8xGVuPjgvkDq5WQLPpEF5/PuICo/uDxuyockbcJUNSrhWywoKwGWV+P2lroVNjFC2hg/2P22Wu8942l0IdzDBsAnZXiIPkZF5wnlLPFFf0px/t6qooKHPJlpRvT8YX245vgLpnxDZEjNE+/GgNfNevbRYowO9RE8zCaAYsWyeKkLcfCineXQnn8SIZCcdgZMTOsUR9ECsoujUpqwAXTBmD825jMAVVD4eW7o9DZejCyk/fKXIO3h0A
x-ms-office365-filtering-correlation-id: ea8905e3-be1a-46c2-5210-08d65b950591
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BN6PR12MB1876;
x-ms-traffictypediagnostic: BN6PR12MB1876:
x-microsoft-antispam-prvs: <BN6PR12MB1876C13584FA05F67988185A83A90@BN6PR12MB1876.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3231455)(999002)(944501520)(52105112)(93006095)(93001095)(3002001)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123564045)(20161123560045)(20161123558120)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BN6PR12MB1876;BCL:0;PCL:0;RULEID:;SRVR:BN6PR12MB1876;
x-forefront-prvs: 087894CD3C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(346002)(136003)(396003)(366004)(189003)(199004)(4326008)(6916009)(305945005)(8676002)(316002)(65956001)(58126008)(65806001)(25786009)(6246003)(5660300001)(8936002)(256004)(14444005)(66574009)(7736002)(81156014)(71190400001)(71200400001)(54906003)(36756003)(65826007)(6116002)(64126003)(229853002)(81166006)(6486002)(31696002)(86362001)(11346002)(486006)(476003)(99286004)(53936002)(446003)(76176011)(102836004)(6436002)(46003)(6506007)(52116002)(386003)(68736007)(14454004)(105586002)(2906002)(2616005)(97736004)(31686004)(72206003)(6512007)(478600001)(106356001)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR12MB1876;H:BN6PR12MB1714.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 06Q5Zb06Ybdt4pqQGfT/AExVjrpYpAUMgDAaad/hND7hdOnxTf40WQ8MDaS1w9cHPewHks5JbRBd5iNoopAM0JHpkIT25csseSEh/b/U5vjS2pdLobzuMQuQfd8VpnY395eBfafs4rhDhtzTckp8ziyMLJXCnzn3OxvfmB/Z9JG2W/+WKwTCvo2mkbaB+fblAhltTnUMx+UaTiNhiN+kwD5UZbX7JzcnZtlXVYq/7c+yIcd68FqdvY4eC1axhsVY7mseimgNwMdF7wERhpxrb/ZouM+AxvO1vALUYhhf4CvuY72bZdV9IGLHHZ7gTAL88vi9UFHgN1RdzILIRnjAf3L75zJwmoEQc4a2KwkUca8=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <640BC537C05F8D49881CDFF5C8BDB417@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8905e3-be1a-46c2-5210-08d65b950591
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2018 16:08:12.6673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1876
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

QW0gMDYuMTIuMTggdW0gMTY6MjEgc2NocmllYiBKZXJvbWUgR2xpc3NlOg0KPiBPbiBUaHUsIERl
YyAwNiwgMjAxOCBhdCAwODowOToyOEFNICswMDAwLCBLb2VuaWcsIENocmlzdGlhbiB3cm90ZToN
Cj4+IEFtIDA2LjEyLjE4IHVtIDAyOjQxIHNjaHJpZWIgamdsaXNzZUByZWRoYXQuY29tOg0KPj4+
IEZyb206IErDqXLDtG1lIEdsaXNzZSA8amdsaXNzZUByZWRoYXQuY29tPg0KPj4+DQo+Pj4gVGhl
IGRlYnVnZnMgdGFrZSByZWZlcmVuY2Ugb24gZmVuY2Ugd2l0aG91dCBkcm9wcGluZyB0aGVtLiBB
bHNvIHRoZQ0KPj4+IHJjdSBzZWN0aW9uIGFyZSBub3Qgd2VsbCBiYWxhbmNlLiBGaXggYWxsIHRo
YXQgLi4uDQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBHbGlzc2UgPGpnbGlzc2VA
cmVkaGF0LmNvbT4NCj4+PiBDYzogQ2hyaXN0aWFuIEvDtm5pZyA8Y2hyaXN0aWFuLmtvZW5pZ0Bh
bWQuY29tPg0KPj4+IENjOiBEYW5pZWwgVmV0dGVyIDxkYW5pZWwudmV0dGVyQGZmd2xsLmNoPg0K
Pj4+IENjOiBTdW1pdCBTZW13YWwgPHN1bWl0LnNlbXdhbEBsaW5hcm8ub3JnPg0KPj4+IENjOiBs
aW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmcNCj4+PiBDYzogZHJpLWRldmVsQGxpc3RzLmZyZWVk
ZXNrdG9wLm9yZw0KPj4+IENjOiBsaW5hcm8tbW0tc2lnQGxpc3RzLmxpbmFyby5vcmcNCj4+PiBD
YzogU3TDqXBoYW5lIE1hcmNoZXNpbiA8bWFyY2hldUBjaHJvbWl1bS5vcmc+DQo+Pj4gQ2M6IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4+IFdlbGwgTkFLLCB5b3UgYXJlIG5vdyB0YWtpbmcgdGhl
IFJDVSBsb2NrIHR3aWNlIGFuZCBkcm9wcGluZyB0aGUgUkNVIGFuZA0KPj4gc3RpbGwgYWNjZXNz
aW5nIGZvYmogaGFzIGEgaHVnZSBwb3RlbnRpYWwgZm9yIGFjY2Vzc2luZyBmcmVlZCB1cCBtZW1v
cnkuDQo+Pg0KPj4gVGhlIG9ubHkgY29ycmVjdCB0aGluZyBJIGNhbiBzZWUgaGVyZSBpcyB0byBn
cmFiIGEgcmVmZXJlbmNlIHRvIHRoZQ0KPj4gZmVuY2UgYmVmb3JlIHByaW50aW5nIGFueSBpbmZv
IG9uIGl0LA0KPj4gQ2hyaXN0aWFuLg0KPiBIdSA/IFRoYXQgaXMgZXhhY3RseSB3aGF0IGkgYW0g
ZG9pbmcsIHRha2UgcmVmZXJlbmNlIHVuZGVyIHJjdSwNCj4gcmN1X3VubG9jayBwcmludCB0aGUg
ZmVuY2UgaW5mbywgZHJvcCB0aGUgZmVuY2UgcmVmZXJlbmNlLCByY3UNCj4gbG9jayByaW5zZSBh
bmQgcmVwZWF0IC4uLg0KPg0KPiBOb3RlIHRoYXQgdGhlIGZvYmogaW4gX2V4aXN0aW5nXyBjb2Rl
IGlzIGFjY2VzcyBvdXRzaWRlIHRoZSByY3UNCj4gZW5kIHRoYXQgdGhlcmUgaXMgYW4gcmN1IGlt
YmFsYW5jZSBpbiB0aGF0IGNvZGUgaWUgYSBsb25sZWx5DQo+IHJjdV91bmxvY2sgYWZ0ZXIgdGhl
IGZvciBsb29wLg0KPg0KPiBTbyB0aGF0IHRoZSBleGlzdGluZyBjb2RlIGlzIGJyb2tlbi4NCg0K
Tm8sIHRoZSBleGlzdGluZyBjb2RlIGlzIHBlcmZlY3RseSBmaW5lLg0KDQpQbGVhc2Ugbm90ZSB0
aGUgYnJlYWsgaW4gdGhlIGxvb3AgYmVmb3JlIHRoZSByY3VfdW5sb2NrKCk7DQo+ICAgIAkJCWlm
ICghcmVhZF9zZXFjb3VudF9yZXRyeSgmcm9iai0+c2VxLCBzZXEpKQ0KPiAgICAJCQkJYnJlYWs7
IDwtIEhFUkUhDQo+ICAgIAkJCXJjdV9yZWFkX3VubG9jaygpOw0KPiAgICAJCX0NCg0KU28geW91
ciBwYXRjaCBicmVha3MgdGhhdCBhbmQgdGFrZSB0aGUgUkNVIHJlYWQgbG9jayB0d2ljZS4NCg0K
UmVnYXJkcywNCkNocmlzdGlhbi4NCg0KPg0KPj4+IC0tLQ0KPj4+ICAgIGRyaXZlcnMvZG1hLWJ1
Zi9kbWEtYnVmLmMgfCAxMSArKysrKysrKystLQ0KPj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCA5IGlu
c2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9kbWEtYnVmL2RtYS1idWYuYyBiL2RyaXZlcnMvZG1hLWJ1Zi9kbWEtYnVmLmMNCj4+PiBpbmRl
eCAxMzg4NDQ3NGQxNTguLmY2ZjRkZTQyYWM0OSAxMDA2NDQNCj4+PiAtLS0gYS9kcml2ZXJzL2Rt
YS1idWYvZG1hLWJ1Zi5jDQo+Pj4gKysrIGIvZHJpdmVycy9kbWEtYnVmL2RtYS1idWYuYw0KPj4+
IEBAIC0xMDUxLDI0ICsxMDUxLDMxIEBAIHN0YXRpYyBpbnQgZG1hX2J1Zl9kZWJ1Z19zaG93KHN0
cnVjdCBzZXFfZmlsZSAqcywgdm9pZCAqdW51c2VkKQ0KPj4+ICAgIAkJCWZvYmogPSByY3VfZGVy
ZWZlcmVuY2Uocm9iai0+ZmVuY2UpOw0KPj4+ICAgIAkJCXNoYXJlZF9jb3VudCA9IGZvYmogPyBm
b2JqLT5zaGFyZWRfY291bnQgOiAwOw0KPj4+ICAgIAkJCWZlbmNlID0gcmN1X2RlcmVmZXJlbmNl
KHJvYmotPmZlbmNlX2V4Y2wpOw0KPj4+ICsJCQlmZW5jZSA9IGRtYV9mZW5jZV9nZXRfcmN1KGZl
bmNlKTsNCj4+PiAgICAJCQlpZiAoIXJlYWRfc2VxY291bnRfcmV0cnkoJnJvYmotPnNlcSwgc2Vx
KSkNCj4+PiAgICAJCQkJYnJlYWs7DQo+Pj4gICAgCQkJcmN1X3JlYWRfdW5sb2NrKCk7DQo+Pj4g
ICAgCQl9DQo+Pj4gLQ0KPj4+IC0JCWlmIChmZW5jZSkNCj4+PiArCQlpZiAoZmVuY2UpIHsNCj4+
PiAgICAJCQlzZXFfcHJpbnRmKHMsICJcdEV4Y2x1c2l2ZSBmZW5jZTogJXMgJXMgJXNzaWduYWxs
ZWRcbiIsDQo+Pj4gICAgCQkJCSAgIGZlbmNlLT5vcHMtPmdldF9kcml2ZXJfbmFtZShmZW5jZSks
DQo+Pj4gICAgCQkJCSAgIGZlbmNlLT5vcHMtPmdldF90aW1lbGluZV9uYW1lKGZlbmNlKSwNCj4+
PiAgICAJCQkJICAgZG1hX2ZlbmNlX2lzX3NpZ25hbGVkKGZlbmNlKSA/ICIiIDogInVuIik7DQo+
Pj4gKwkJCWRtYV9mZW5jZV9wdXQoZmVuY2UpOw0KPj4+ICsJCX0NCj4+PiArDQo+Pj4gKwkJcmN1
X3JlYWRfbG9jaygpOw0KPj4+ICAgIAkJZm9yIChpID0gMDsgaSA8IHNoYXJlZF9jb3VudDsgaSsr
KSB7DQo+Pj4gICAgCQkJZmVuY2UgPSByY3VfZGVyZWZlcmVuY2UoZm9iai0+c2hhcmVkW2ldKTsN
Cj4+PiAgICAJCQlpZiAoIWRtYV9mZW5jZV9nZXRfcmN1KGZlbmNlKSkNCj4+PiAgICAJCQkJY29u
dGludWU7DQo+Pj4gKwkJCXJjdV9yZWFkX3VubG9jaygpOw0KPj4+ICAgIAkJCXNlcV9wcmludGYo
cywgIlx0U2hhcmVkIGZlbmNlOiAlcyAlcyAlc3NpZ25hbGxlZFxuIiwNCj4+PiAgICAJCQkJICAg
ZmVuY2UtPm9wcy0+Z2V0X2RyaXZlcl9uYW1lKGZlbmNlKSwNCj4+PiAgICAJCQkJICAgZmVuY2Ut
Pm9wcy0+Z2V0X3RpbWVsaW5lX25hbWUoZmVuY2UpLA0KPj4+ICAgIAkJCQkgICBkbWFfZmVuY2Vf
aXNfc2lnbmFsZWQoZmVuY2UpID8gIiIgOiAidW4iKTsNCj4+PiArCQkJZG1hX2ZlbmNlX3B1dChm
ZW5jZSk7DQo+Pj4gKwkJCXJjdV9yZWFkX2xvY2soKTsNCj4+PiAgICAJCX0NCj4+PiAgICAJCXJj
dV9yZWFkX3VubG9jaygpOw0KPj4+ICAgIA0KDQo=
