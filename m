Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B217C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D589E20675
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:49:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=epam.com header.i=@epam.com header.b="AzvNyAM/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbfAOOtR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 09:49:17 -0500
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:24192
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728619AbfAOOtQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 09:49:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LJIV5YCNnVl7Y7q67ZOoOMVt+psEkUSMBmFWJqWcqw=;
 b=AzvNyAM/FMg/33oy3n0MvK3z4mCM0NqrYEHXkwV9BIZ2X6ljBDu91gOWWFLfKXibBbqQCnTyTNPsiMXwYsp0d4JY2A0VZ9CGSaPCieYHYyYSXBnAo83X/LsX9EQG5GEDR8Rckojy1XLQ5dd+9AYPdThmys7S6NtN0s2FLGYL2OM=
Received: from AM6PR03MB4327.eurprd03.prod.outlook.com (20.177.33.25) by
 AM6PR03MB4757.eurprd03.prod.outlook.com (20.177.35.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.24; Tue, 15 Jan 2019 14:49:11 +0000
Received: from AM6PR03MB4327.eurprd03.prod.outlook.com
 ([fe80::844b:fab6:64d8:2f37]) by AM6PR03MB4327.eurprd03.prod.outlook.com
 ([fe80::844b:fab6:64d8:2f37%3]) with mapi id 15.20.1516.019; Tue, 15 Jan 2019
 14:49:11 +0000
From:   Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Oleksandr Andrushchenko <andr2000@gmail.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "koji.matsuoka.xm@renesas.com" <koji.matsuoka.xm@renesas.com>
Subject: Re: [Xen-devel][PATCH v4 1/1] cameraif: add ABI for para-virtual
 camera
Thread-Topic: [Xen-devel][PATCH v4 1/1] cameraif: add ABI for para-virtual
 camera
Thread-Index: AQHUrLYp6tWAOrd79kSs5Ly90xnXZqWwaEgAgAABPQA=
Date:   Tue, 15 Jan 2019 14:49:11 +0000
Message-ID: <f8cb4201-ae29-2d93-353f-7bf403b6e83c@epam.com>
References: <20190115093853.15495-1-andr2000@gmail.com>
 <20190115093853.15495-2-andr2000@gmail.com>
 <393f824d-e543-476c-777f-402bcc1c0bcb@xs4all.nl>
In-Reply-To: <393f824d-e543-476c-777f-402bcc1c0bcb@xs4all.nl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Oleksandr_Andrushchenko@epam.com; 
x-originating-ip: [85.223.209.22]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM6PR03MB4757;6:dhwjOoPhlQ5tv5AwECxoRWQYI7T0CkZbYdUdsCTl5i9RpuO8v8n9JMI8len4aNB9IOnZwgNhOfh0LtWDbaAcLmHDxHIoFIrRvSsJdhTrlNYB/GV0FrA8cyIh1be3r5xBy+4iTSGaTUsQpa9deAxhLCoK/GGmpmOumOvUtBB1FXR0ca6oG/1pPpkuGh642dFOEfmu29J7tAzFtAseEIH+Hes73Yd3MjY5rJEwRV3mGrnEy5Ev8CCbcJE5EYwvZ78pdkWbYK26D0ufzTyNNT+RYfxECy1coYg8MpR+pM7nq6aqoKod5rLbqM9Xgn9h4u7mnuQVqfsDYytlqyHjZ3/cq9S8D0JWEcnu4z0ekimlfJmPSr1IVpaeJl6/M6PdabunIrtCBTZRFTT3/2WjKlrju4n0hG179xY4d69wrR2/rQca+hg7r0E3YCfiOcUafK4d8MZUfiCtnsDypOSBwMry8Q==;5:YlyN7NOSFIXHXs/MBSzqeFgBQhPjYXyLzc/Tnt79de6htHcZv1Cxuc1JoMbBGd/sQUbeuNhVnTcxaTASbahXvHzMaTT3x+C8bTRHgBBKTu0qg2DOswZ02FoGSNppZOJ1mlpg9lZncQ3Ysn/NWECHOnfV0cNGLXQAb4rE8IKlkD3cFax24fVBJZ3l1B6vaP2knPorMc4d47/kFOPGA8inRA==;7:9+bxYmF4pGuFEtZ+HEjdTxYtnbldKQQcGY/XSmqJT1MvvHDuo1p4c0wlbDv50kNsBWkyhrOPR+jYp4doFrJP964bB7J4EEEnO/iP6WqQccIpq8yqpgGSjsitd6pPzjYh4sghykjH8NhfKbHAiLPwDQ==
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 04ecd6cf-80ee-47a6-0cfb-08d67af89cb2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:AM6PR03MB4757;
x-ms-traffictypediagnostic: AM6PR03MB4757:
x-microsoft-antispam-prvs: <AM6PR03MB4757ADC25B87CC6C36D1A7C8E7810@AM6PR03MB4757.eurprd03.prod.outlook.com>
x-forefront-prvs: 0918748D70
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(366004)(39860400002)(396003)(189003)(199004)(68736007)(53936002)(316002)(345774005)(110136005)(2501003)(81156014)(81166006)(8676002)(2201001)(7416002)(86362001)(8936002)(6512007)(106356001)(14444005)(31686004)(486006)(6506007)(105586002)(53546011)(72206003)(14454004)(256004)(99286004)(31696002)(2906002)(478600001)(6486002)(97736004)(76176011)(80792005)(26005)(229853002)(102836004)(186003)(3846002)(6116002)(6436002)(55236004)(71190400001)(71200400001)(446003)(25786009)(11346002)(5660300001)(7736002)(66066001)(305945005)(2616005)(6246003)(476003)(36756003)(39060400002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR03MB4757;H:AM6PR03MB4327.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: epam.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: z9zshi7jxXkg3agnxJKMo9sv73wtff7vgKoXTaKRJnxI7E8gqxDWSlWnihxnM/V4Xe4CFleETmnq8nQTwcxNnqgIffrVSbiDh+0jVVN5K6v7yJHo43jxbKyT3YwwjHV+K4pB9PaZ06+0tU2fP/0adPTl35uP6u069z6x7z8A3d6HCGWB54AQFeD1/mGOLoolat3QSripX8KC4cDurSfrkUcrhsknafCYBM5Mctde9yNkxVLfMK4ejFXAwtCK1A6leVqp1Ggj/800c/q1a1wzR+S2p5ECPy+lsZfULQ+5QHML37HLH+Q6UYL5t11ZYACnJgwCJtpRyNubV9hhUzxnOazEb28aDIxZi+7KDvmMOLomFx6wNEJMKjgdSAHemeUwBsChvHwVwOUpeq2wP+FP1KKvHLYL2PYNx4RYSf7bQxc=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <B45551940564904AB1422414CA502AF3@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04ecd6cf-80ee-47a6-0cfb-08d67af89cb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2019 14:49:11.8005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4757
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

T24gMS8xNS8xOSA0OjQ0IFBNLCBIYW5zIFZlcmt1aWwgd3JvdGU6DQo+IEhpIE9sZWtzYW5kciwN
CkhlbGxvLCBIYW5zIQ0KPiBKdXN0IHR3byByZW1haW5pbmcgY29tbWVudHM6DQo+DQo+IE9uIDEv
MTUvMTkgMTA6MzggQU0sIE9sZWtzYW5kciBBbmRydXNoY2hlbmtvIHdyb3RlOg0KPj4gRnJvbTog
T2xla3NhbmRyIEFuZHJ1c2hjaGVua28gPG9sZWtzYW5kcl9hbmRydXNoY2hlbmtvQGVwYW0uY29t
Pg0KPj4NCj4+IFRoaXMgaXMgdGhlIEFCSSBmb3IgdGhlIHR3byBoYWx2ZXMgb2YgYSBwYXJhLXZp
cnR1YWxpemVkDQo+PiBjYW1lcmEgZHJpdmVyIHdoaWNoIGV4dGVuZHMgWGVuJ3MgcmVhY2ggbXVs
dGltZWRpYSBjYXBhYmlsaXRpZXMgZXZlbg0KPj4gZmFydGhlciBlbmFibGluZyBpdCBmb3Igdmlk
ZW8gY29uZmVyZW5jaW5nLCBJbi1WZWhpY2xlIEluZm90YWlubWVudCwNCj4+IGhpZ2ggZGVmaW5p
dGlvbiBtYXBzIGV0Yy4NCj4+DQo+PiBUaGUgaW5pdGlhbCBnb2FsIGlzIHRvIHN1cHBvcnQgbW9z
dCBuZWVkZWQgZnVuY3Rpb25hbGl0eSB3aXRoIHRoZQ0KPj4gZmluYWwgaWRlYSB0byBtYWtlIGl0
IHBvc3NpYmxlIHRvIGV4dGVuZCB0aGUgcHJvdG9jb2wgaWYgbmVlZCBiZToNCj4+DQo+PiAxLiBQ
cm92aWRlIG1lYW5zIGZvciBiYXNlIHZpcnR1YWwgZGV2aWNlIGNvbmZpZ3VyYXRpb246DQo+PiAg
IC0gcGl4ZWwgZm9ybWF0cw0KPj4gICAtIHJlc29sdXRpb25zDQo+PiAgIC0gZnJhbWUgcmF0ZXMN
Cj4+IDIuIFN1cHBvcnQgYmFzaWMgY2FtZXJhIGNvbnRyb2xzOg0KPj4gICAtIGNvbnRyYXN0DQo+
PiAgIC0gYnJpZ2h0bmVzcw0KPj4gICAtIGh1ZQ0KPj4gICAtIHNhdHVyYXRpb24NCj4+IDMuIFN1
cHBvcnQgc3RyZWFtaW5nIGNvbnRyb2wNCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBPbGVrc2FuZHIg
QW5kcnVzaGNoZW5rbyA8b2xla3NhbmRyX2FuZHJ1c2hjaGVua29AZXBhbS5jb20+DQo+PiAtLS0N
Cj4+ICAgeGVuL2luY2x1ZGUvcHVibGljL2lvL2NhbWVyYWlmLmggfCAxMzY0ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKw0KPj4gICAxIGZpbGUgY2hhbmdlZCwgMTM2NCBpbnNlcnRpb25z
KCspDQo+PiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCB4ZW4vaW5jbHVkZS9wdWJsaWMvaW8vY2FtZXJh
aWYuaA0KPj4NCj4+IGRpZmYgLS1naXQgYS94ZW4vaW5jbHVkZS9wdWJsaWMvaW8vY2FtZXJhaWYu
aCBiL3hlbi9pbmNsdWRlL3B1YmxpYy9pby9jYW1lcmFpZi5oDQo+PiBuZXcgZmlsZSBtb2RlIDEw
MDY0NA0KPj4gaW5kZXggMDAwMDAwMDAwMDAwLi4yNDZlYjI0NTdmNDANCj4+IC0tLSAvZGV2L251
bGwNCj4+ICsrKyBiL3hlbi9pbmNsdWRlL3B1YmxpYy9pby9jYW1lcmFpZi5oDQo+PiBAQCAtMCww
ICsxLDEzNjQgQEANCj4gPHNuaXA+DQo+DQo+PiArLyoNCj4+ICsgKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqDQo+PiArICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBFVkVOVCBDT0RFUw0K
Pj4gKyAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioNCj4+ICsgKi8NCj4+ICsjZGVmaW5lIFhFTkNBTUVS
QV9FVlRfRlJBTUVfQVZBSUwgICAgICAweDAwDQo+PiArI2RlZmluZSBYRU5DQU1FUkFfRVZUX0NU
UkxfQ0hBTkdFICAgICAgMHgwMQ0KPj4gKw0KPj4gKy8qIFJlc29sdXRpb24gaGFzIGNoYW5nZWQu
ICovDQo+PiArI2RlZmluZSBYRU5DQU1FUkFfRVZUX0NGR19GTEdfUkVTT0wgICAgKDEgPDwgMCkN
Cj4gSSB0aGluayB0aGlzIGZsYWcgaXMgYSBsZWZ0LW92ZXIgZnJvbSB2MiBhbmQgc2hvdWxkIGJl
IHJlbW92ZWQuDQpHb29kIGNhdGNoLCB3aWxsIHJlbW92ZQ0KPg0KPiA8c25pcD4NCj4NCj4+ICsg
KiBSZXF1ZXN0IG51bWJlciBvZiBidWZmZXJzIHRvIGJlIHVzZWQ6DQo+PiArICogICAgICAgICAw
ICAgICAgICAgICAgICAgIDEgICAgICAgICAgICAgICAgIDIgICAgICAgICAgICAgICAzICAgICAg
ICBvY3RldA0KPj4gKyAqICstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0t
LS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tKw0KPj4gKyAqIHwgICAgICAgICAgICAgICBpZCAg
ICAgICAgICAgICAgICB8IF9PUF9CVUZfUkVRVUVTVHwgICByZXNlcnZlZCAgICAgfCA0DQo+PiAr
ICogKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tKy0t
LS0tLS0tLS0tLS0tLS0rDQo+PiArICogfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcmVz
ZXJ2ZWQgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IDgNCj4+ICsgKiArLS0tLS0tLS0t
LS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0t
LSsNCj4+ICsgKiB8ICAgIG51bV9idWZzICAgIHwgICAgICAgICAgICAgICAgICAgICByZXNlcnZl
ZCAgICAgICAgICAgICAgICAgICAgIHwgMTINCj4+ICsgKiArLS0tLS0tLS0tLS0tLS0tLSstLS0t
LS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSsNCj4+ICsgKiB8
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZXNlcnZlZCAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgMTYNCj4+ICsgKiArLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0t
Ky0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSsNCj4+ICsgKiB8L1wvXC9cL1wvXC9c
L1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL3wN
Cj4+ICsgKiArLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0t
LS0rLS0tLS0tLS0tLS0tLS0tLSsNCj4+ICsgKiB8ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICByZXNlcnZlZCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgNjQNCj4+ICsgKiArLS0t
LS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0t
LS0tLS0tLSsNCj4+ICsgKg0KPj4gKyAqIG51bV9idWZzIC0gdWludDhfdCwgZGVzaXJlZCBudW1i
ZXIgb2YgYnVmZmVycyB0byBiZSB1c2VkLiBUaGlzIGlzDQo+PiArICogICBsaW1pdGVkIHRvIHRo
ZSB2YWx1ZSBjb25maWd1cmVkIGluIFhlblN0b3JlLm1heC1idWZmZXJzLg0KPj4gKyAqICAgUGFz
c2luZyB6ZXJvIG51bV9idWZzIGluIHRoaXMgcmVxdWVzdCAoYWZ0ZXIgc3RyZWFtaW5nIGhhcyBz
dG9wcGVkDQo+PiArICogICBhbmQgYWxsIGJ1ZmZlcnMgZGVzdHJveWVkKSB1bmJsb2NrcyBjYW1l
cmEgY29uZmlndXJhdGlvbiBjaGFuZ2VzLg0KPiBJIHRoaW5rIHRoZSBwaHJhc2UgJ3VuYmxvY2tz
IGNhbWVyYSBjb25maWd1cmF0aW9uIGNoYW5nZXMnIGlzIGNvbmZ1c2luZy4NCj4NCj4gSW4gdjMg
dGhpcyBzZW50ZW5jZSBjYW1lIGFmdGVyIHRoZSB0aGlyZCBub3RlIGJlbG93LCBhbmQgc28gaXQg
bWFkZSBzZW5zZQ0KPiBpbiB0aGF0IGNvbnRleHQsIGJ1dCBub3cgdGhlIG9yZGVyIGhhcyBiZWVu
IHJldmVyc2VkIGFuZCBpdCBiZWNhbWUgaGFyZCB0bw0KPiB1bmRlcnN0YW5kLg0KPg0KPiBJJ20g
bm90IHN1cmUgd2hhdCB0aGUgYmVzdCBhcHByb2FjaCBpcyB0byBmaXggdGhpcy4gT25lIG9wdGlv
biBpcyB0byByZW1vdmUNCj4gdGhlIHRoaXJkIG5vdGUgYW5kIGludGVncmF0ZSBpdCBzb21laG93
IGluIHRoZSBzZW50ZW5jZSBhYm92ZS4gT3IgcGVyaGFwcw0KPiBkbyBhd2F5IHdpdGggdGhlICdu
b3RlcycgYXQgYWxsIGFuZCBqdXN0IHdyaXRlIGEgbW9yZSBleHRlbnNpdmUgZG9jdW1lbnRhdGlv
bg0KPiBmb3IgdGhpcyBvcC4gSSBsZWF2ZSB0aGF0IHVwIHRvIHlvdS4NCkknbGwgdGhpbmsgYWJv
dXQgd2hhdCBjYW4gYmUgZG9uZSBoZXJlDQo+PiArICoNCj4+ICsgKiBTZWUgcmVzcG9uc2UgZm9y
bWF0IGZvciB0aGlzIHJlcXVlc3QuDQo+PiArICoNCj4+ICsgKiBOb3RlczoNCj4+ICsgKiAgLSBm
cm9udGVuZCBtdXN0IGNoZWNrIHRoZSBjb3JyZXNwb25kaW5nIHJlc3BvbnNlIGluIG9yZGVyIHRv
IHNlZQ0KPj4gKyAqICAgIGlmIHRoZSB2YWx1ZXMgcmVwb3J0ZWQgYmFjayBieSB0aGUgYmFja2Vu
ZCBkbyBtYXRjaCB0aGUgZGVzaXJlZCBvbmVzDQo+PiArICogICAgYW5kIGNhbiBiZSBhY2NlcHRl
ZC4NCj4+ICsgKiAgLSBmcm9udGVuZCBtYXkgc2VuZCBtdWx0aXBsZSBYRU5DQU1FUkFfT1BfQlVG
X1JFUVVFU1QgcmVxdWVzdHMgYmVmb3JlDQo+PiArICogICAgc2VuZGluZyBYRU5DQU1FUkFfT1Bf
U1RSRUFNX1NUQVJUIHJlcXVlc3QgdG8gdXBkYXRlIG9yIHR1bmUgdGhlDQo+PiArICogICAgY29u
ZmlndXJhdGlvbi4NCj4+ICsgKiAgLSBhZnRlciB0aGlzIHJlcXVlc3QgY2FtZXJhIGNvbmZpZ3Vy
YXRpb24gY2Fubm90IGJlIGNoYW5nZWQsIHVubGVzcw0KPiBjYW1lcmEgY29uZmlndXJhdGlvbiAt
PiB0aGUgY2FtZXJhIGNvbmZpZ3VyYXRpb24NCldpbGwgZml4DQo+PiArICogICAgc3RyZWFtaW5n
IGlzIHN0b3BwZWQgYW5kIGJ1ZmZlcnMgZGVzdHJveWVkDQo+PiArICovDQo+IFJlZ2FyZHMsDQo+
DQo+IAlIYW5zDQpUaGFuayB5b3UgZm9yIGhlbHBpbmcgd2l0aCB0aGlzLA0KT2xla3NhbmRy
