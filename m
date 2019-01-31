Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F97C169C4
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 08:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B782D20881
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 08:25:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=epam.com header.i=@epam.com header.b="huF9socs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731016AbfAaIZC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 03:25:02 -0500
Received: from mail-eopbgr70041.outbound.protection.outlook.com ([40.107.7.41]:32896
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726172AbfAaIZC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 03:25:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjZ8gc5wihxANghHcAvgFszmSTXYKtmpDdFADkpe2lg=;
 b=huF9socsrM/Ov/MXmlrt26baNwaFsaxlh/D42caRJcNM8oJ/Ft8JpkImj4kmNZwD0+O05BZNH3MrF+nTSbcYkpUYA4ExQmNGtLinr6Ozj+qtb9zrEfxL1hCfwtDObMa/vbP8Oc5NaOMrCv0+XuIcvwyOmGs0vRHfanB7orhIY8o=
Received: from AM6PR03MB4327.eurprd03.prod.outlook.com (20.177.33.25) by
 AM6PR03MB4598.eurprd03.prod.outlook.com (20.177.35.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.18; Thu, 31 Jan 2019 08:24:54 +0000
Received: from AM6PR03MB4327.eurprd03.prod.outlook.com
 ([fe80::3cc9:3b23:a872:99d7]) by AM6PR03MB4327.eurprd03.prod.outlook.com
 ([fe80::3cc9:3b23:a872:99d7%2]) with mapi id 15.20.1558.023; Thu, 31 Jan 2019
 08:24:54 +0000
From:   Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>
To:     "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
CC:     Oleksandr Andrushchenko <andr2000@gmail.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "koji.matsuoka.xm@renesas.com" <koji.matsuoka.xm@renesas.com>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Subject: Re: [Xen-devel][PATCH v4 0/1] cameraif: add ABI for para-virtual
 camera
Thread-Topic: [Xen-devel][PATCH v4 0/1] cameraif: add ABI for para-virtual
 camera
Thread-Index: AQHUrLYp1U2oFnjo2EmWYC6cnKFR1aXJI3WA
Date:   Thu, 31 Jan 2019 08:24:54 +0000
Message-ID: <2f5828b6-20ee-365e-a599-2e57c4498564@epam.com>
References: <20190115093853.15495-1-andr2000@gmail.com>
In-Reply-To: <20190115093853.15495-1-andr2000@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Oleksandr_Andrushchenko@epam.com; 
x-originating-ip: [85.223.209.22]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM6PR03MB4598;6:rHf/DQDElMMFMgfKDudboBs6BgR6kfHdzVZ9DKlZTxTNNU3HgYTSON9lqdRmym/J3XiGTHI2CVXFEKZoXu9eTFfJNhfSiUTFuYeTk1wSFGoT1mJV6Ac52yLaJpXqDEQxs2qkenOJaHInGE0Q9aqCemtoO/2Giuwq6v65ZaKEpocMzE1y42hMRYvlUQyuzoE7UNzaqFQqL68PRcNaV6IMacBjLd734omQrq0aKDGFKphOiHFvie6n/dgK1OmqkI/DLsRWR7BWKlnlwDew9G+bXPPweuas/dzqnQUYZKZoouFLM4yRvjYHqWGETRteH9LT+/IkW9nBgsocWpG7F1VKdlMJo4OYzWbONe9eRtc4imS7fPUFAimKdQYHaiVjrO6lIlOUMKxIp7HI5MxALd8Ihd9yunjkP982rkhXYSaxgSQ5L0Y+08DYtcbLG8pcOTHp1xKrpvOildZ1TDJzXppXfA==;5:DtIKDOXCos2CtPaz/IJ8pAqMm6Kl7jsmsG5RWipChNTAKDiNBDjO97VRd7o0vsm/K3RyiyYa9cFeMEqmmy9eQbDhPgm2T1LoBwTfG/ywzCK55JQxvkSeZUsYa0JJTZQEYvZw9luo7zm9Ae4FdtnXUMsUDKIYwSV66SsE3BULjum3iVbYe4B74Us3mBDLucctNrHUFVmJRP+mf/x1oqdr0g==;7:l8++1eO28g/RS/ZTT2lph5IAgniLk0agYwEdSxwgZO2P+l7/3O0C2BsofkQYVm2NGZaByVgTFXw7Sw1k7G3lPdgmqCYUEn7dhvga2RDdt5iZREXGOK/hQYwUmeDzM324W8Ldts/RwTCUAVk58KEsYg==
x-ms-office365-filtering-correlation-id: 83f33c04-514b-4ae6-5a3d-08d68755941c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:AM6PR03MB4598;
x-ms-traffictypediagnostic: AM6PR03MB4598:
x-microsoft-antispam-prvs: <AM6PR03MB4598EC12E73E56850BBD6C58E7910@AM6PR03MB4598.eurprd03.prod.outlook.com>
x-forefront-prvs: 09347618C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(396003)(346002)(366004)(189003)(199004)(66066001)(6506007)(31696002)(3846002)(55236004)(71200400001)(446003)(81166006)(53546011)(11346002)(2501003)(486006)(71190400001)(8936002)(2616005)(6116002)(86362001)(476003)(102836004)(72206003)(54906003)(8676002)(99286004)(2351001)(186003)(7736002)(76176011)(7416002)(305945005)(26005)(81156014)(316002)(97736004)(106356001)(6246003)(6486002)(105586002)(6512007)(478600001)(68736007)(229853002)(2906002)(6436002)(6916009)(31686004)(966005)(53936002)(4326008)(14454004)(14444005)(36756003)(256004)(80792005)(5640700003)(39060400002)(6306002)(25786009)(21314003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR03MB4598;H:AM6PR03MB4327.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: epam.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: p+aU5K6q9zXjv4E70Avt8r5QYLkLVij0Wp38qaAbwOaCugRVzx4RGmdzWr1aZxnnQp1F7DKtrYgOnqbdD0+6whgXeVNrBq9GpXroKJjhVWVk/BwHV+wjQUwrnNYlC2BdLDFtL2ZObHUgmMWzdNHekK36yCyrI2ewGfb1FrF9pJ5enIPsKAx3fPytoNneYJGAsFeV5Mjo1RdPzWZFVPXFOLZfhtXY+bFBRIheE+tnj7X13uHwOzHfsZ33zOnCQujcxiwyDUBBMl9rsfSc5iGNsZGnrl29VVxUdZhE33xwITSvA3shgYcf9fQHJ1qEVAP8lK0JeW5034zpTQciNT1HyshY5sFmJ6PeLXUY2WKJk9ZfQ/DnSQxL0WFupX93raifkDUi7jYDLHJWppWBW7dAK+IuDZj3Z05xPPKWQtOByio=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1993F0E16A2B3E41AB62CFA583F80B27@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83f33c04-514b-4ae6-5a3d-08d68755941c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2019 08:24:54.5266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4598
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

S29ucmFkLCBjb3VsZCB5b3UgcGxlYXNlIHJldmlldz8NCg0KVGhhbmsgeW91LA0KT2xla3NhbmRy
DQoNCk9uIDEvMTUvMTkgMTE6MzggQU0sIE9sZWtzYW5kciBBbmRydXNoY2hlbmtvIHdyb3RlOg0K
PiBGcm9tOiBPbGVrc2FuZHIgQW5kcnVzaGNoZW5rbyA8b2xla3NhbmRyX2FuZHJ1c2hjaGVua29A
ZXBhbS5jb20+DQo+DQo+IEhlbGxvIQ0KPg0KPiBBdCB0aGUgbW9tZW50IFhlbiBbMV0gYWxyZWFk
eSBzdXBwb3J0cyBzb21lIHZpcnR1YWwgbXVsdGltZWRpYQ0KPiBmZWF0dXJlcyBbMl0gc3VjaCBh
cyB2aXJ0dWFsIGRpc3BsYXksIHNvdW5kLiBJdCBzdXBwb3J0cyBrZXlib2FyZHMsDQo+IHBvaW50
ZXJzIGFuZCBtdWx0aS10b3VjaCBkZXZpY2VzIGFsbCBhbGxvd2luZyBYZW4gdG8gYmUgdXNlZCBp
bg0KPiBhdXRvbW90aXZlIGFwcGxpYW5jZXMsIEluLVZlaGljbGUgSW5mb3RhaW5tZW50IChJVkkp
IHN5c3RlbXMNCj4gYW5kIG1hbnkgbW9yZS4NCj4NCj4gRnJvbnRlbmQgaW1wbGVtZW50YXRpb24g
aXMgYXZhaWxhYmxlIGF0IFszXSBhbmQgdGhlIGNvcnJlc3BvbmRpbmcNCj4gYmFja2VuZCBhdCBb
NF0uIFRoZXNlIGFyZSB3b3JrIGluIHByb2dyZXNzLCBidXQgZnJvbnRlbmQgYWxyZWFkeQ0KPiBw
YXNzZXMgdjRsMi1jb21wbGlhbmNlIHRlc3QgZm9yIFY0TDIgZHJpdmVycy4gbGlieGwgcHJlbGlt
aW5hcnkNCj4gY2hhbmdlcyBhcmUgYXZhaWxhYmxlIGF0IFs1XS4NCj4NCj4gVGhpcyB3b3JrIGFk
ZHMgYSBuZXcgWGVuIHBhcmEtdmlydHVhbGl6ZWQgcHJvdG9jb2wgZm9yIGEgdmlydHVhbA0KPiBj
YW1lcmEgZGV2aWNlIHdoaWNoIGV4dGVuZHMgbXVsdGltZWRpYSBjYXBhYmlsaXRpZXMgb2YgWGVu
IGV2ZW4NCj4gZmFydGhlcjogdmlkZW8gY29uZmVyZW5jaW5nLCBJVkksIGhpZ2ggZGVmaW5pdGlv
biBtYXBzIGV0Yy4NCj4NCj4gVGhlIGluaXRpYWwgZ29hbCBpcyB0byBzdXBwb3J0IG1vc3QgbmVl
ZGVkIGZ1bmN0aW9uYWxpdHkgd2l0aCB0aGUNCj4gZmluYWwgaWRlYSB0byBtYWtlIGl0IHBvc3Np
YmxlIHRvIGV4dGVuZCB0aGUgcHJvdG9jb2wgaWYgbmVlZCBiZToNCj4NCj4gMS4gUHJvdmlkZSBt
ZWFucyBmb3IgYmFzZSB2aXJ0dWFsIGRldmljZSBjb25maWd1cmF0aW9uOg0KPiAgIC0gcGl4ZWwg
Zm9ybWF0cw0KPiAgIC0gcmVzb2x1dGlvbnMNCj4gICAtIGZyYW1lIHJhdGVzDQo+IDIuIFN1cHBv
cnQgYmFzaWMgY2FtZXJhIGNvbnRyb2xzOg0KPiAgIC0gY29udHJhc3QNCj4gICAtIGJyaWdodG5l
c3MNCj4gICAtIGh1ZQ0KPiAgIC0gc2F0dXJhdGlvbg0KPiAzLiBTdXBwb3J0IHN0cmVhbWluZyBj
b250cm9sDQo+DQo+IEkgd291bGQgbGlrZSB0byB0aGFuayBIYW5zIFZlcmt1aWwgPGh2ZXJrdWls
QHhzNGFsbC5ubD4gZm9yIHZhbHVhYmxlDQo+IGNvbW1lbnRzIGFuZCBoZWxwLg0KPg0KPiBUaGFu
ayB5b3UsDQo+IE9sZWtzYW5kciBBbmRydXNoY2hlbmtvDQo+DQo+IENoYW5nZXMgc2luY2UgdjM6
DQo+ID09PT09PT09PT09PT09PT09DQo+DQo+IDEuIEFkZCB0cmltbWluZyBleGFtcGxlIGZvciBz
aG9ydCBGT1VSQ0MgbGFiZWxzLCBlLmcuIFkxNiBhbmQgWTE2LUJFDQo+IDIuIFJlbW92ZSBmcm9t
IFhFTkNBTUVSQV9PUF9DT05GSUdfWFhYIHJlcXVlc3RzIGNvbG9yc3BhY2UsIHhmZXJfZnVuYywN
Cj4gICAgIHljYmNyX2VuYywgcXVhbnRpemF0aW9uIGFuZCBtb3ZlIHRob3NlIGludG8gdGhlIGNv
cnJlc3BvbmRpbmcgcmVzcG9uc2UNCj4gMy4gRXh0ZW5kIGRlc2NyaXB0aW9uIG9mIFhFTkNBTUVS
QV9PUF9CVUZfUkVRVUVTVC5udW1fYnVmczogbGltaXQgdG8NCj4gICAgIG1heGltdW0gYnVmZmVy
cyBhbmQgbnVtX2J1ZnMgPT0gMCBjYXNlDQo+IDQuIEV4dGVuZCBkZWNyaXB0aW9uIG9mIFhFTkNB
TUVSQV9PUF9CVUZfQ1JFQVRFLmluZGV4IGFuZCBzcGVjaWZ5IGl0cw0KPiAgICAgcmFuZ2UNCj4g
NS4gTWFrZSBYRU5DQU1FUkFfRVZUX0ZSQU1FX0FWQUlMLnNlcV9udW0gMzItYml0IGluc3RlYWQg
b2YgNjQtYml0DQo+DQo+IENoYW5nZXMgc2luY2UgdjI6DQo+ID09PT09PT09PT09PT09PT09DQo+
DQo+IDEuIEFkZCAibWF4LWJ1ZmZlcnMiIGZyb250ZW5kIGNvbmZpZ3VyYXRpb24gZW50cnksIGUu
Zy4NCj4gICAgIHRoZSBtYXhpbXVtIG51bWJlciBvZiBjYW1lcmEgYnVmZmVycyBhIGZyb250ZW5k
IG1heSB1c2UuDQo+IDIuIEFkZCBiaWctZW5kaWFuIHBpeGVsLWZvcm1hdCBzdXBwb3J0Og0KPiAg
IC0gImZvcm1hdHMiIGNvbmZpZ3VyYXRpb24gc3RyaW5nIGxlbmd0aCBjaGFuZ2VkIGZyb20gNCB0
byA3DQo+ICAgICBvY3RldHMsIHNvIHdlIGNhbiBhbHNvIG1hbmFnZSBCRSBwaXhlbC1mb3JtYXRz
DQo+ICAgLSBhZGQgY29ycmVzcG9uZGluZyBjb21tZW50cyB0byBGT1VSQ0MgbWFwcGluZ3MgZGVz
Y3JpcHRpb24NCj4gMy4gTmV3IGNvbW1hbmRzIGFkZGVkIHRvIHRoZSBwcm90b2NvbCBhbmQgZG9j
dW1lbnRlZDoNCj4gICAtIFhFTkNBTUVSQV9PUF9DT05GSUdfVkFMSURBVEUNCj4gICAtIFhFTkNB
TUVSQV9PUF9GUkFNRV9SQVRFX1NFVA0KPiAgIC0gWEVOQ0FNRVJBX09QX0JVRl9HRVRfTEFZT1VU
DQo+IDQuLUFkZCBkZWZhdWx0cyBmb3IgY29sb3JzcGFjZSwgeGZlciwgeWNiY3JfZW5jIGFuZCBx
dWFudGl6YXRpb24NCj4gNS4gUmVtb3ZlIFhFTkNBTUVSQV9FVlRfQ09ORklHX0NIQU5HRSBldmVu
dA0KPiA2LiBNb3ZlIHBsYW5lIG9mZnNldHMgdG8gWEVOQ0FNRVJBX09QX0JVRl9SRVFVRVNUIGFz
IG9mZnNldHMNCj4gICAgIHJlcXVpcmVkIGZvciB0aGUgZnJvbnRlbmQgbWlnaHQgbm90IGJlIGtu
b3duIGF0IHRoZSBjb25maWd1cmF0aW9uIHRpbWUNCj4gNy4gQ2xlYW4gdXAgYW5kIGFkZHJlc3Mg
Y29tbWVudHMgdG8gdjIgb2YgdGhlIHByb3RvY29sDQo+DQo+IENoYW5nZXMgc2luY2UgdjE6DQo+
ID09PT09PT09PT09PT09PT09DQo+DQo+IDEuIEFkZGVkIFhlblN0b3JlIGVudHJpZXM6DQo+ICAg
LSBmcmFtZS1yYXRlcw0KPiAyLiBEbyBub3QgcmVxdWlyZSB0aGUgRk9VUkNDIGNvZGUgaW4gWGVu
U3RvcmUgdG8gYmUgdXBwZXIgY2FzZSBvbmx5DQo+IDMuIEFkZGVkL2NoYW5nZWQgY29tbWFuZCBz
ZXQ6DQo+ICAgLSBjb25maWd1cmF0aW9uIGdldC9zZXQNCj4gICAtIGJ1ZmZlciBxdWV1ZS9kZXF1
ZXVlDQo+ICAgLSBjb250cm9sIGdldA0KPiA0LiBBZGRlZCBjb250cm9sIGZsYWdzLCBlLmcuIHJl
YWQtb25seSBldGMuDQo+IDUuIEFkZGVkIGNvbG9yc3BhY2UgY29uZmlndXJhdGlvbiBzdXBwb3J0
LCByZWxldmFudCBjb25zdGFudHMNCj4gNi4gQWRkZWQgZXZlbnRzOg0KPiAgIC0gY29uZmlndXJh
dGlvbiBjaGFuZ2UNCj4gICAtIGNvbnRyb2wgY2hhbmdlDQo+IDcuIENoYW5nZWQgY29udHJvbCB2
YWx1ZXMgdG8gNjQtYml0DQo+IDguIEFkZGVkIHNlcXVlbmNlIG51bWJlciB0byBmcmFtZSBhdmFp
bCBldmVudA0KPiA5LiBDb2Rpbmcgc3R5bGUgY2xlYW51cA0KPg0KPiBbMV0gaHR0cHM6Ly93d3cu
eGVucHJvamVjdC5vcmcvDQo+IFsyXSBodHRwczovL3hlbmJpdHMueGVuLm9yZy9naXR3ZWIvP3A9
eGVuLmdpdDthPXRyZWU7Zj14ZW4vaW5jbHVkZS9wdWJsaWMvaW8NCj4gWzNdIGh0dHBzOi8vZ2l0
aHViLmNvbS9hbmRyMjAwMC9saW51eC90cmVlL2NhbWVyYV9mcm9udF92MS9kcml2ZXJzL21lZGlh
L3hlbg0KPiBbNF0gaHR0cHM6Ly9naXRodWIuY29tL2FuZHIyMDAwL2NhbWVyYV9iZQ0KPiBbNV0g
aHR0cHM6Ly9naXRodWIuY29tL2FuZHIyMDAwL3hlbi90cmVlL3ZjYW1lcmENCj4NCj4gT2xla3Nh
bmRyIEFuZHJ1c2hjaGVua28gKDEpOg0KPiAgICBjYW1lcmFpZjogYWRkIEFCSSBmb3IgcGFyYS12
aXJ0dWFsIGNhbWVyYQ0KPg0KPiAgIHhlbi9pbmNsdWRlL3B1YmxpYy9pby9jYW1lcmFpZi5oIHwg
MTM2NCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gICAxIGZpbGUgY2hhbmdlZCwg
MTM2NCBpbnNlcnRpb25zKCspDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IHhlbi9pbmNsdWRlL3B1
YmxpYy9pby9jYW1lcmFpZi5oDQo+DQo=
