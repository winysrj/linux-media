Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4922FC282C5
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 08:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD4CF21726
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 08:14:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=epam.com header.i=@epam.com header.b="Xu8pONaZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfAWIOR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 03:14:17 -0500
Received: from mail-eopbgr30073.outbound.protection.outlook.com ([40.107.3.73]:60416
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725973AbfAWIOR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 03:14:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LA33/zbN2KA+e8/oVHl6tizxVgaEQKgZSbLZGI+PAs=;
 b=Xu8pONaZLjTG7WoKOi3a+tHgCPA8CfHOk1mIRf5aiUlMQv0SRN68P4TsM6rVKI7Mp/92GLQ0xqIwaE3e4yjntJwuQ7xxMmlDOYaHVuoJMrnKweIV7CIfPZQp86g6R9DueQO7H4QXKdHWrgUbOc9ZVuQanBKnK1qI4P3frPrJe9M=
Received: from AM6PR03MB4327.eurprd03.prod.outlook.com (20.177.33.25) by
 AM6PR03MB4696.eurprd03.prod.outlook.com (20.177.35.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.29; Wed, 23 Jan 2019 08:14:11 +0000
Received: from AM6PR03MB4327.eurprd03.prod.outlook.com
 ([fe80::844b:fab6:64d8:2f37]) by AM6PR03MB4327.eurprd03.prod.outlook.com
 ([fe80::844b:fab6:64d8:2f37%3]) with mapi id 15.20.1537.031; Wed, 23 Jan 2019
 08:14:11 +0000
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
Thread-Index: AQHUrLYp6tWAOrd79kSs5Ly90xnXZqWwaEgAgAwliYA=
Date:   Wed, 23 Jan 2019 08:14:11 +0000
Message-ID: <1152536e-9238-4192-653e-b784b34b8a0d@epam.com>
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
x-microsoft-exchange-diagnostics: 1;AM6PR03MB4696;6:vN2ITzAPQ063dCLbMhAeMJD+fxZIMdSCcencapWdzd+90CUxhKJox+bKIchysXqvVZtEclRoG03iOchphOodKZEUyaHXQDagEM12uR9nBzbcol8tbbtwO9my4xWhOKxqQN24ZViuHapwLbLBMZEp4Z//5LNj9IaeWUkHW+zU3FKwb2AXDMr/NyAIC6ezsIU3qMBisFxGbfgK9mxxYBI340W3CokYnHlafjgIwaaR9DuCBs0jaKLhRuEeJeD97Obdh5VdHWenYStllfPUF027LsRNcrKcY9wjyVsmRnsdJmOguZElxV0HQcHNqFlrcIi1s9l6wXQGFEK2DKrrusNigNJcKXVYnLbuugGuShzx/95xrIZjZ/AYXOLkPMKg5jFHNvcw8WyfSpvxhuHABtUCSPjNye3bDFZYDrM5m7WEH+fV7Tt0YddG9mxfDp6Ex0g+VRASlo+nt/GqC1JnZDY+9g==;5:N1ndTyKt91XZq0fgRoIWUl4nml3hwPQ9Bc3kaq/Hfem2ywk/rlYtFxuRFQk0Zff8KKQ7hM1bFyYgapE3hsjF7bs8B1O6m+KT4dUMvQirMuQ8GWlj91KUJkomv5taoqOpL7R7bjTUO7fMgoe/mNNNGPJfWf2rz2pvMokyYACKYEtAaJGKFv+k05gaf4xff2P5Ad6sGpjLm71WToGh22ALNg==;7:/FmJinSHtKViD59LClC4FAYsxjidqxaLrmCA2uuwiSk/+zmRy1emvMSKFDAfjd1hSSjvSrz/F59F9lb0vVGAN53qWPDHtApdid4fuQ/8y2m4rj48aDJVz6+ysHKs/o9wvWx0dGKeEIFel++QT1XGsQ==
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 71c1792c-fa9c-4cd6-e5f1-08d6810ac198
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:AM6PR03MB4696;
x-ms-traffictypediagnostic: AM6PR03MB4696:
x-microsoft-antispam-prvs: <AM6PR03MB4696BDF930EA9A347D349026E7990@AM6PR03MB4696.eurprd03.prod.outlook.com>
x-forefront-prvs: 0926B0E013
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(366004)(136003)(39860400002)(396003)(199004)(189003)(86362001)(14454004)(53936002)(6116002)(3846002)(53546011)(26005)(7736002)(55236004)(72206003)(6506007)(6486002)(186003)(2616005)(71190400001)(2501003)(76176011)(476003)(25786009)(31696002)(7416002)(2201001)(256004)(14444005)(71200400001)(6512007)(2906002)(229853002)(105586002)(106356001)(97736004)(99286004)(486006)(478600001)(6246003)(11346002)(8936002)(80792005)(305945005)(316002)(8676002)(39060400002)(102836004)(6436002)(68736007)(31686004)(446003)(66066001)(81166006)(81156014)(110136005)(36756003)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR03MB4696;H:AM6PR03MB4327.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: epam.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sOwbP9Ha+2d24U949o6xwGoyTFCV1YTf4u1yF9iwidYwqhIBoO+iPELxwtS8AOsGj9CN7T81otDjjWR23DRuxPB/HKixDMg3mB+FM/McBr7UIiw/BjLMnVg7QAAyDbeSUuZEQuM8+FDOeUdkKDUXKxqyd9Zkf7LNpmWEI13ld9XlapTGtT7oee6vLZ7u+2FxCB4YXKB4GNmaysM7tRTfpwALf3KlLPD7uph5UFubbkX4ORnBnhfbLjYn2lAG1WR/6XO3fXnUApiqNIzJnAj4rW4W0SzQMBWNNkITl5VEarUa82cTpJ0wYeLoB7g/q0hnzgI80e3N1Q1CDwZwelBlNrB3NWFsIoEPQ5zJ0mRx030KUXTRczVv/ibkT7P6fzBvN443uOVEueWTGm4bHbS/7Rn2dlOn4oPx+IzpQyAmIOY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C076C4F43EF394094F2B9C81AAD9D1C@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71c1792c-fa9c-4cd6-e5f1-08d6810ac198
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2019 08:14:11.6582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4696
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

QW55IGNvbW1lbnRzIGZyb20gWGVuIGNvbW11bml0eT8NCktvbnJhZD8NCg0KT24gMS8xNS8xOSA0
OjQ0IFBNLCBIYW5zIFZlcmt1aWwgd3JvdGU6DQo+IEhpIE9sZWtzYW5kciwNCj4NCj4gSnVzdCB0
d28gcmVtYWluaW5nIGNvbW1lbnRzOg0KPg0KPiBPbiAxLzE1LzE5IDEwOjM4IEFNLCBPbGVrc2Fu
ZHIgQW5kcnVzaGNoZW5rbyB3cm90ZToNCj4+IEZyb206IE9sZWtzYW5kciBBbmRydXNoY2hlbmtv
IDxvbGVrc2FuZHJfYW5kcnVzaGNoZW5rb0BlcGFtLmNvbT4NCj4+DQo+PiBUaGlzIGlzIHRoZSBB
QkkgZm9yIHRoZSB0d28gaGFsdmVzIG9mIGEgcGFyYS12aXJ0dWFsaXplZA0KPj4gY2FtZXJhIGRy
aXZlciB3aGljaCBleHRlbmRzIFhlbidzIHJlYWNoIG11bHRpbWVkaWEgY2FwYWJpbGl0aWVzIGV2
ZW4NCj4+IGZhcnRoZXIgZW5hYmxpbmcgaXQgZm9yIHZpZGVvIGNvbmZlcmVuY2luZywgSW4tVmVo
aWNsZSBJbmZvdGFpbm1lbnQsDQo+PiBoaWdoIGRlZmluaXRpb24gbWFwcyBldGMuDQo+Pg0KPj4g
VGhlIGluaXRpYWwgZ29hbCBpcyB0byBzdXBwb3J0IG1vc3QgbmVlZGVkIGZ1bmN0aW9uYWxpdHkg
d2l0aCB0aGUNCj4+IGZpbmFsIGlkZWEgdG8gbWFrZSBpdCBwb3NzaWJsZSB0byBleHRlbmQgdGhl
IHByb3RvY29sIGlmIG5lZWQgYmU6DQo+Pg0KPj4gMS4gUHJvdmlkZSBtZWFucyBmb3IgYmFzZSB2
aXJ0dWFsIGRldmljZSBjb25maWd1cmF0aW9uOg0KPj4gICAtIHBpeGVsIGZvcm1hdHMNCj4+ICAg
LSByZXNvbHV0aW9ucw0KPj4gICAtIGZyYW1lIHJhdGVzDQo+PiAyLiBTdXBwb3J0IGJhc2ljIGNh
bWVyYSBjb250cm9sczoNCj4+ICAgLSBjb250cmFzdA0KPj4gICAtIGJyaWdodG5lc3MNCj4+ICAg
LSBodWUNCj4+ICAgLSBzYXR1cmF0aW9uDQo+PiAzLiBTdXBwb3J0IHN0cmVhbWluZyBjb250cm9s
DQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogT2xla3NhbmRyIEFuZHJ1c2hjaGVua28gPG9sZWtzYW5k
cl9hbmRydXNoY2hlbmtvQGVwYW0uY29tPg0KPj4gLS0tDQo+PiAgIHhlbi9pbmNsdWRlL3B1Ymxp
Yy9pby9jYW1lcmFpZi5oIHwgMTM2NCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+
ICAgMSBmaWxlIGNoYW5nZWQsIDEzNjQgaW5zZXJ0aW9ucygrKQ0KPj4gICBjcmVhdGUgbW9kZSAx
MDA2NDQgeGVuL2luY2x1ZGUvcHVibGljL2lvL2NhbWVyYWlmLmgNCj4+DQo+PiBkaWZmIC0tZ2l0
IGEveGVuL2luY2x1ZGUvcHVibGljL2lvL2NhbWVyYWlmLmggYi94ZW4vaW5jbHVkZS9wdWJsaWMv
aW8vY2FtZXJhaWYuaA0KPj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4+IGluZGV4IDAwMDAwMDAw
MDAwMC4uMjQ2ZWIyNDU3ZjQwDQo+PiAtLS0gL2Rldi9udWxsDQo+PiArKysgYi94ZW4vaW5jbHVk
ZS9wdWJsaWMvaW8vY2FtZXJhaWYuaA0KPj4gQEAgLTAsMCArMSwxMzY0IEBADQo+IDxzbmlwPg0K
Pg0KPj4gKy8qDQo+PiArICoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg0KPj4gKyAqICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgRVZFTlQgQ09ERVMNCj4+ICsgKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqDQo+PiArICovDQo+PiArI2RlZmluZSBYRU5DQU1FUkFfRVZUX0ZSQU1FX0FWQUlMICAgICAg
MHgwMA0KPj4gKyNkZWZpbmUgWEVOQ0FNRVJBX0VWVF9DVFJMX0NIQU5HRSAgICAgIDB4MDENCj4+
ICsNCj4+ICsvKiBSZXNvbHV0aW9uIGhhcyBjaGFuZ2VkLiAqLw0KPj4gKyNkZWZpbmUgWEVOQ0FN
RVJBX0VWVF9DRkdfRkxHX1JFU09MICAgICgxIDw8IDApDQo+IEkgdGhpbmsgdGhpcyBmbGFnIGlz
IGEgbGVmdC1vdmVyIGZyb20gdjIgYW5kIHNob3VsZCBiZSByZW1vdmVkLg0KPg0KPiA8c25pcD4N
Cj4NCj4+ICsgKiBSZXF1ZXN0IG51bWJlciBvZiBidWZmZXJzIHRvIGJlIHVzZWQ6DQo+PiArICog
ICAgICAgICAwICAgICAgICAgICAgICAgIDEgICAgICAgICAgICAgICAgIDIgICAgICAgICAgICAg
ICAzICAgICAgICBvY3RldA0KPj4gKyAqICstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0t
LS0rLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tKw0KPj4gKyAqIHwgICAgICAgICAg
ICAgICBpZCAgICAgICAgICAgICAgICB8IF9PUF9CVUZfUkVRVUVTVHwgICByZXNlcnZlZCAgICAg
fCA0DQo+PiArICogKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0t
LS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0rDQo+PiArICogfCAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgcmVzZXJ2ZWQgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IDgNCj4+ICsgKiAr
LS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0t
LS0tLS0tLS0tLSsNCj4+ICsgKiB8ICAgIG51bV9idWZzICAgIHwgICAgICAgICAgICAgICAgICAg
ICByZXNlcnZlZCAgICAgICAgICAgICAgICAgICAgIHwgMTINCj4+ICsgKiArLS0tLS0tLS0tLS0t
LS0tLSstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSsN
Cj4+ICsgKiB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZXNlcnZlZCAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgMTYNCj4+ICsgKiArLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0t
LS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSsNCj4+ICsgKiB8L1wv
XC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9c
L1wvXC9cL3wNCj4+ICsgKiArLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tKy0tLS0t
LS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSsNCj4+ICsgKiB8ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICByZXNlcnZlZCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgNjQNCj4+
ICsgKiArLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0r
LS0tLS0tLS0tLS0tLS0tLSsNCj4+ICsgKg0KPj4gKyAqIG51bV9idWZzIC0gdWludDhfdCwgZGVz
aXJlZCBudW1iZXIgb2YgYnVmZmVycyB0byBiZSB1c2VkLiBUaGlzIGlzDQo+PiArICogICBsaW1p
dGVkIHRvIHRoZSB2YWx1ZSBjb25maWd1cmVkIGluIFhlblN0b3JlLm1heC1idWZmZXJzLg0KPj4g
KyAqICAgUGFzc2luZyB6ZXJvIG51bV9idWZzIGluIHRoaXMgcmVxdWVzdCAoYWZ0ZXIgc3RyZWFt
aW5nIGhhcyBzdG9wcGVkDQo+PiArICogICBhbmQgYWxsIGJ1ZmZlcnMgZGVzdHJveWVkKSB1bmJs
b2NrcyBjYW1lcmEgY29uZmlndXJhdGlvbiBjaGFuZ2VzLg0KPiBJIHRoaW5rIHRoZSBwaHJhc2Ug
J3VuYmxvY2tzIGNhbWVyYSBjb25maWd1cmF0aW9uIGNoYW5nZXMnIGlzIGNvbmZ1c2luZy4NCj4N
Cj4gSW4gdjMgdGhpcyBzZW50ZW5jZSBjYW1lIGFmdGVyIHRoZSB0aGlyZCBub3RlIGJlbG93LCBh
bmQgc28gaXQgbWFkZSBzZW5zZQ0KPiBpbiB0aGF0IGNvbnRleHQsIGJ1dCBub3cgdGhlIG9yZGVy
IGhhcyBiZWVuIHJldmVyc2VkIGFuZCBpdCBiZWNhbWUgaGFyZCB0bw0KPiB1bmRlcnN0YW5kLg0K
Pg0KPiBJJ20gbm90IHN1cmUgd2hhdCB0aGUgYmVzdCBhcHByb2FjaCBpcyB0byBmaXggdGhpcy4g
T25lIG9wdGlvbiBpcyB0byByZW1vdmUNCj4gdGhlIHRoaXJkIG5vdGUgYW5kIGludGVncmF0ZSBp
dCBzb21laG93IGluIHRoZSBzZW50ZW5jZSBhYm92ZS4gT3IgcGVyaGFwcw0KPiBkbyBhd2F5IHdp
dGggdGhlICdub3RlcycgYXQgYWxsIGFuZCBqdXN0IHdyaXRlIGEgbW9yZSBleHRlbnNpdmUgZG9j
dW1lbnRhdGlvbg0KPiBmb3IgdGhpcyBvcC4gSSBsZWF2ZSB0aGF0IHVwIHRvIHlvdS4NCj4NCj4+
ICsgKg0KPj4gKyAqIFNlZSByZXNwb25zZSBmb3JtYXQgZm9yIHRoaXMgcmVxdWVzdC4NCj4+ICsg
Kg0KPj4gKyAqIE5vdGVzOg0KPj4gKyAqICAtIGZyb250ZW5kIG11c3QgY2hlY2sgdGhlIGNvcnJl
c3BvbmRpbmcgcmVzcG9uc2UgaW4gb3JkZXIgdG8gc2VlDQo+PiArICogICAgaWYgdGhlIHZhbHVl
cyByZXBvcnRlZCBiYWNrIGJ5IHRoZSBiYWNrZW5kIGRvIG1hdGNoIHRoZSBkZXNpcmVkIG9uZXMN
Cj4+ICsgKiAgICBhbmQgY2FuIGJlIGFjY2VwdGVkLg0KPj4gKyAqICAtIGZyb250ZW5kIG1heSBz
ZW5kIG11bHRpcGxlIFhFTkNBTUVSQV9PUF9CVUZfUkVRVUVTVCByZXF1ZXN0cyBiZWZvcmUNCj4+
ICsgKiAgICBzZW5kaW5nIFhFTkNBTUVSQV9PUF9TVFJFQU1fU1RBUlQgcmVxdWVzdCB0byB1cGRh
dGUgb3IgdHVuZSB0aGUNCj4+ICsgKiAgICBjb25maWd1cmF0aW9uLg0KPj4gKyAqICAtIGFmdGVy
IHRoaXMgcmVxdWVzdCBjYW1lcmEgY29uZmlndXJhdGlvbiBjYW5ub3QgYmUgY2hhbmdlZCwgdW5s
ZXNzDQo+IGNhbWVyYSBjb25maWd1cmF0aW9uIC0+IHRoZSBjYW1lcmEgY29uZmlndXJhdGlvbg0K
Pg0KPj4gKyAqICAgIHN0cmVhbWluZyBpcyBzdG9wcGVkIGFuZCBidWZmZXJzIGRlc3Ryb3llZA0K
Pj4gKyAqLw0KPiBSZWdhcmRzLA0KPg0KPiAJSGFucw0K
