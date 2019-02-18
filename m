Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA72C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 08:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97FB1218D8
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 08:21:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="1Sd1S+C4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbfBRIVr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 03:21:47 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:3999 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfBRIVq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 03:21:46 -0500
X-IronPort-AV: E=Sophos;i="5.58,383,1544511600"; 
   d="scan'208";a="26728299"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 18 Feb 2019 01:21:46 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 18 Feb 2019 01:21:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lwGvKvPFArt7hKbL8CXYbUO17O7A4/oCyEYehjjppA=;
 b=1Sd1S+C4xt+fcKT2yahv3ePZQq2i3ZYKbqO3622UTWeVv0oHTZ9WeFyTuKx5oUPSyFD3bQ1jxzDxa9nszcyQTjF1chUuqjSDMXScnTw4qj9Tkvjku46kzniKp/CCTMK5Oi5bUfaIBcY2lpvNzEOddX6Odn8lzn64nzteNimTFOc=
Received: from DM5PR11MB1242.namprd11.prod.outlook.com (10.168.108.8) by
 DM5PR11MB1753.namprd11.prod.outlook.com (10.175.91.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.19; Mon, 18 Feb 2019 08:21:44 +0000
Received: from DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::e831:aee7:13c0:96b1]) by DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::e831:aee7:13c0:96b1%8]) with mapi id 15.20.1622.018; Mon, 18 Feb 2019
 08:21:44 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <akinobu.mita@gmail.com>, <linux-media@vger.kernel.org>
CC:     <wenyou.yang@microchip.com>, <sakari.ailus@linux.intel.com>,
        <mchehab@kernel.org>
Subject: Re: [PATCH] media: ov7740: fix runtime pm initialization
Thread-Topic: [PATCH] media: ov7740: fix runtime pm initialization
Thread-Index: AQHUxtP/YwjF6XEk7U+qGZbrOQ8dfaXlNx0A
Date:   Mon, 18 Feb 2019 08:21:44 +0000
Message-ID: <c3e8cbd0-0a9c-a22b-bb06-7aaff8c2168b@microchip.com>
References: <1550416667-9372-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1550416667-9372-1-git-send-email-akinobu.mita@gmail.com>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR09CA0044.eurprd09.prod.outlook.com
 (2603:10a6:802:28::12) To DM5PR11MB1242.namprd11.prod.outlook.com
 (2603:10b6:3:14::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-tagtoolbar-keys: D20190218101728396
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d24d3dca-2440-4b68-e8e2-08d6957a1ddb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DM5PR11MB1753;
x-ms-traffictypediagnostic: DM5PR11MB1753:
x-ms-exchange-purlcount: 1
x-microsoft-exchange-diagnostics: =?utf-8?B?MTtETTVQUjExTUIxNzUzOzIzOjlDM0ZpK09JUkI0YURKRzJQMnVvcFlIRzAr?=
 =?utf-8?B?eXgyL201YU5RaWtPcUFaUnhndXIwNTZ4ZTlNOEhUSm50SlZ5Rkd2bGlVYVJH?=
 =?utf-8?B?WUszK1RZbHBJZHBzemNMT0h6czg3VVJOWGdqejlYeVRPd1F6UEg1SnQySG01?=
 =?utf-8?B?T1Qyd1QyUHRkWUpLNVZhenRiZ1ZKT1RoM2c4WTFqMDRhTVBnVm5uNGlBNVF2?=
 =?utf-8?B?elNXcnJHRXV1VkJzUTZYMVhCVGlNU0VJT0NtRWR0ZTExRmpOdDlxWFNIc3Ez?=
 =?utf-8?B?eUUvN014ZUVHVzZDYXpyaFBDOERoOHZwZFdyU1ErVm5RTW1Jc3FEODhGQkJi?=
 =?utf-8?B?bC8vampPbU9nZElHRWtsRSt0Uk83YTYwcmlsRytpbWJTM3J4SjRxMkltdnRV?=
 =?utf-8?B?RitSRExpNG11ZWhJN3RGeHpIaElxUWd3ak9JVTNNNEtuM2lWV1prQnZmRnFW?=
 =?utf-8?B?YllBNXlORFkyRzU2NnNGSHdNczRXUzlMcEQ1cUE4RjdXbzZzc0c2K1ZqSHo1?=
 =?utf-8?B?SkNDcXR4ZTZBWHZMUWJRRlRDU2xkY2I2c2MvZGdFTEtZRi9CcUE3OE1SV0Jr?=
 =?utf-8?B?Vld1ZnNaaGlRd0t1Mit1WTJ1V1lFVlhLYXNMMzFMNTJtVHJGeWRHMVBCU0Q0?=
 =?utf-8?B?bXl6NElRR3ZBa2hnOVlKa29zTHpnNUFzMHhWK1h6RWtuVWl6YjdKMDVoeGxj?=
 =?utf-8?B?MjVpckk3RE14L0RuVzhhNng5Q2NTZXNxQkFaYUZCZEJTTU9rMUtuRUJKeTFL?=
 =?utf-8?B?SnFuWmpwcnNBVzhwaEp0Sk9tU1NJMi8xVHJpMkpEcWg1TXl3VVpQNU9uS3Ux?=
 =?utf-8?B?c3Q4RTFmNW5kYm55RS8zZDNPU2hhbzkrOTIzRU0vd1BJdTVydTFJTEJHUGVl?=
 =?utf-8?B?ZmoxN2JDVnBxSTRwU2Z2TmNqUGlPS2EwTFgxRkdPSUgyYlUvZnh0cEovLzA2?=
 =?utf-8?B?YzhMRmQvNTFLenNubmJxLzc3NkUzNC9NZndiN2lMQzdWa0M5akZ2T0xSYWo1?=
 =?utf-8?B?eTMwTVVBVlBzUGZiSkJwOEJrbWhzQ1hHdUpOeEdxRHE0Yi8yclpFOE9NQkIy?=
 =?utf-8?B?d21Oa3RmRjF6M2R0NStxWnd4MGNQS1pyZm9zTlZlOG9LMXBOWmgrUTEvV251?=
 =?utf-8?B?V3V5ZzdueHh1RjdpMXFWUVBuM3RQZ0UrNDRJTERjMlpLZGZxQ016YU51U0pl?=
 =?utf-8?B?dHQ3b21jak1nQW1jeVdQU0pCdytBNkR5STNrejVRM1ZLL0hJNEhwaTdEM0hW?=
 =?utf-8?B?VWRDdnZITGR0UllXeXdUMGtRVmltZERRaDkybGs5SGx6R280cW1FVVNtSjM0?=
 =?utf-8?B?QWttcjVhbGx5dWlnOFZxYlg2Y0REYW82aGRqZEdLOXN1SmZzaTVVZXJDd3pJ?=
 =?utf-8?B?NU5XSk5RZW8zQVhnY2Q3YzlUZ2ZpemJPSVFhNEZxbXJENk12bHdHVnR3QUxG?=
 =?utf-8?B?SjFtVVh0ZCtsTDk0UjFsU0FMZTJ0TWJtR0NnZy8xTnpBYTRrWC8zNWVMdmJI?=
 =?utf-8?B?WmpuYjBFWTZEQjVLS0Y5SG8za0VwdFNaM2VKeFZDWG1GZkRWRHAxeDBoaEV5?=
 =?utf-8?B?MmJCSUh3dEEzdGxQalVFZmI3anpSU0RMSVI3Snl2QVZiT3V5WnZSdExHWkl2?=
 =?utf-8?B?cEt1Zk1SaTVNdVA2b0FxeEhqV0Y5L3lwOE9BaU5HNlkyRlYrY3VrdVkwWHdz?=
 =?utf-8?B?K09QTHdDK214dXNuSlNRNG1EVGtjamFwdXBHR3JZeEtScmNhdFBTZURZK3A1?=
 =?utf-8?B?VlgxUlo3a0pFWEE4TWh2Z1FaUysvb3ppcng2SnFjODVwWXpIWjdLeHdRbGVF?=
 =?utf-8?B?T2lHM2J3a3NEY3BFQlR5bE8rTnpjUVcwL0JxSHhNNXpveGc9PQ==?=
x-microsoft-antispam-prvs: <DM5PR11MB1753DC32F340519A8D283593E8630@DM5PR11MB1753.namprd11.prod.outlook.com>
x-forefront-prvs: 09525C61DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(39860400002)(376002)(136003)(396003)(189003)(199004)(2501003)(446003)(6506007)(11346002)(6486002)(6116002)(53546011)(3846002)(106356001)(386003)(6246003)(476003)(2616005)(486006)(186003)(102836004)(72206003)(14444005)(316002)(81156014)(81166006)(54906003)(256004)(478600001)(14454004)(110136005)(6436002)(25786009)(966005)(26005)(4326008)(8676002)(2906002)(31686004)(68736007)(52116002)(5660300002)(53936002)(229853002)(66066001)(76176011)(8936002)(99286004)(6306002)(105586002)(31696002)(71190400001)(97736004)(6512007)(305945005)(71200400001)(7736002)(86362001)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1753;H:DM5PR11MB1242.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: a5My9t1EmVD/u2yXP3u7mHQy9RKX02sgLmsIkPYNQb/wb4TetNt7BK3Rm9OYMp0k060cNZ5jgGyBnFjzYbEA6Qdmxh5p+Lmzj1B3NE7v4Suyt1GEcvLgMkHQFNGC/9rs614utOaS01KZkfjDfs6AhjfJ4THLVMmzbbix4QmnhsyKjTlYExrov66hQMQ0nsYFkW1nEV1KUAsnVkqra1ll9b+fTVI4P3j9NPmBKuK7qozQtc7boGOQrMg0sJDDgaO9UglSzZv+pcT55X82UJYUE88oHfy/0JEiqnVVDiC2WvB5UD0O1EGEhw11IjFZ0YX6TE6/TXWr5faI/JOfiKaCDi43GKQiyDzkCbvyUx1D7Y5tDFZvBj7HJy/VOLY6FIZSul7iI+jI1yCthoSYaoZTqKLBXj8Gk7Eno0WkkfPYU00=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE20458F2CC788439FA706EF9909F51A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d24d3dca-2440-4b68-e8e2-08d6957a1ddb
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2019 08:21:42.6713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1753
X-OriginatorOrg: microchip.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

DQoNCk9uIDE3LjAyLjIwMTkgMTc6MTcsIEFraW5vYnUgTWl0YSB3cm90ZToNCj4gVGhlIHJ1bnRp
bWUgUE0gb2YgdGhpcyBkZXZpY2UgaXMgZW5hYmxlZCBhZnRlciB2NGwyX2N0cmxfaGFuZGxlcl9z
ZXR1cCgpLA0KPiBhbmQgdGhpcyBtYWtlcyB0aGlzIGRldmljZSdzIHJ1bnRpbWUgUE0gdXNhZ2Ug
Y291bnQgYSBuZWdhdGl2ZSB2YWx1ZS4NCj4gDQo+IFRoZSBvdjc3NDBfc2V0X2N0cmwoKSB0cmll
cyB0byBkbyBzb21ldGhpbmcgb25seSBpZiB0aGUgZGV2aWNlJ3MgcnVudGltZQ0KPiBQTSB1c2Fn
ZSBjb3VudGVyIGlzIG5vbnplcm8uDQo+IA0KPiBvdjc3NDBfc2V0X2N0cmwoKQ0KPiB7DQo+IAlp
ZiAoIXBtX3J1bnRpbWVfZ2V0X2lmX2luX3VzZSgmY2xpZW50LT5kZXYpKQ0KPiAJCXJldHVybiAw
Ow0KPiANCj4gCTxkbyBzb21ldGhpbmc+Ow0KPiANCj4gCXBtX3J1bnRpbWVfcHV0KCZjbGllbnQt
PmRldik7DQo+IA0KPiAJcmV0dXJuIHJldDsNCj4gfQ0KPiANCj4gSG93ZXZlciwgdGhlIG92Nzc0
MF9zZXRfY3RybCgpIGlzIGNhbGxlZCBieSB2NGwyX2N0cmxfaGFuZGxlcl9zZXR1cCgpDQo+IHdo
aWxlIHRoZSBydW50aW1lIFBNIG9mIHRoaXMgZGV2aWNlIGlzIG5vdCB5ZXQgZW5hYmxlZC4gIElu
IHRoaXMgY2FzZSwNCj4gdGhlIHBtX3J1bnRpbWVfZ2V0X2lmX2luX3VzZSgpIHJldHVybnMgLUVJ
TlZBTCAoIT0gMCkuDQo+IA0KPiBUaGVyZWZvcmUgd2UgY2FuJ3QgYmFpbCBvdXQgb2YgdGhpcyBm
dW5jdGlvbiBhbmQgdGhlIHVzYWdlIGNvdW50IGlzDQo+IGRlY3JlYXNlZCBieSBwbV9ydW50aW1l
X3B1dCgpIHdpdGhvdXQgaW5jcmVtZW50Lg0KPiANCj4gVGhpcyBmaXhlcyB0aGlzIHByb2JsZW0g
YnkgZW5hYmxpbmcgdGhlIHJ1bnRpbWUgUE0gb2YgdGhpcyBkZXZpY2UgYmVmb3JlDQo+IHY0bDJf
Y3RybF9oYW5kbGVyX3NldHVwKCkgc28gdGhhdCB0aGUgb3Y3NzQwX3NldF9jdHJsKCkgaXMgYWx3
YXlzIGNhbGxlZA0KPiB3aGVuIHRoZSBydW50aW1lIFBNIGlzIGVuYWJsZWQuDQo+IA0KPiBDYzog
RXVnZW4gSHJpc3RldiA8ZXVnZW4uaHJpc3RldkBtaWNyb2NoaXAuY29tPg0KPiBDYzogV2VueW91
IFlhbmcgPHdlbnlvdS55YW5nQG1pY3JvY2hpcC5jb20+DQo+IENjOiBTYWthcmkgQWlsdXMgPHNh
a2FyaS5haWx1c0BsaW51eC5pbnRlbC5jb20+DQo+IENjOiBNYXVybyBDYXJ2YWxobyBDaGVoYWIg
PG1jaGVoYWJAa2VybmVsLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogQWtpbm9idSBNaXRhIDxha2lu
b2J1Lm1pdGFAZ21haWwuY29tPg0KPiAtLS0NCj4gSSBkb24ndCBoYXZlIHRoZSBvdjc3NDAgZGV2
aWNlLCBidXQgSSBzYXcgdGhlIHNhbWUgcHJvYmxlbSB3aXRoIHRoZQ0KPiBtdDltMDAxIGRldmlj
ZSB3aGVuIEkgd2FzIGFkZGluZyB0aGUgcnVudGltZSBQTSBzdXBwb3J0IGZvciBpdC4NCj4gDQo+
IEV1Z2VuIEhyaXN0ZXYgcmVwb3J0ZWQgdGhlIHByb2JsZW0gd2l0aCBvdjc3NDAuDQoNCkhpLA0K
DQpUaGlzIGZpeGVzIG15IGlzc3VlIHdpdGggdGhpcyBzZW5zb3IgaW4gbGF0ZXN0IG1lZGlhdHJl
ZQ0KRm9yIGFueXRoaW5nJ3Mgd29ydGgsIGZvciBBdG1lbCBJU0MgKyBvdjc3NDAsIHdpdGggbXkg
cGF0Y2gsDQoNClRlc3RlZC1ieTogRXVnZW4gSHJpc3RldiA8ZXVnZW4uaHJpc3RldkBtaWNyb2No
aXAuY29tPg0KDQpUaGFua3MNCg0KPiANCj4gaHR0cHM6Ly93d3cubWFpbC1hcmNoaXZlLmNvbS9s
aW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmcvbXNnMTQ0NTQwLmh0bWwNCj4gDQo+IEkgc3VzcGVj
dCB0aGF0IGl0IGlzIHJlbGF0ZWQgdG8gdGhpcyBydW50aW1lIFBNIHByb2JsZW0uDQo+IA0KPiBU
aGVyZSBzZWVtcyB0byBiZSB0aGUgc2FtZSBwcm9ibGVtIGluIG90aGVyIGRldmljZXMuICBJIHdv
dWxkIGxpa2UgdG8gc2VlDQo+IGlmIHRoaXMgcGF0Y2ggYWN0dWFsbHkgZml4IHRoZSBvdjc3NDAn
cyBwcm9ibGVtIGFuZCB0aGVuIHByb3BhZ2F0ZSBvdGhlcg0KPiBkZXZpY2VzLg0KPiANCj4gICBk
cml2ZXJzL21lZGlhL2kyYy9vdjc3NDAuYyB8IDcgKysrKystLQ0KPiAgIDEgZmlsZSBjaGFuZ2Vk
LCA1IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9tZWRpYS9pMmMvb3Y3NzQwLmMgYi9kcml2ZXJzL21lZGlhL2kyYy9vdjc3NDAuYw0KPiBp
bmRleCAxNzc2ODhhLi44ODM1YjgzIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL21lZGlhL2kyYy9v
djc3NDAuYw0KPiArKysgYi9kcml2ZXJzL21lZGlhL2kyYy9vdjc3NDAuYw0KPiBAQCAtMTEwMSw2
ICsxMTAxLDkgQEAgc3RhdGljIGludCBvdjc3NDBfcHJvYmUoc3RydWN0IGkyY19jbGllbnQgKmNs
aWVudCwNCj4gICAJaWYgKHJldCkNCj4gICAJCXJldHVybiByZXQ7DQo+ICAgDQo+ICsJcG1fcnVu
dGltZV9zZXRfYWN0aXZlKCZjbGllbnQtPmRldik7DQo+ICsJcG1fcnVudGltZV9lbmFibGUoJmNs
aWVudC0+ZGV2KTsNCj4gKw0KPiAgIAlyZXQgPSBvdjc3NDBfZGV0ZWN0KG92Nzc0MCk7DQo+ICAg
CWlmIChyZXQpDQo+ICAgCQlnb3RvIGVycm9yX2RldGVjdDsNCj4gQEAgLTExMjMsOCArMTEyNiw2
IEBAIHN0YXRpYyBpbnQgb3Y3NzQwX3Byb2JlKHN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQsDQo+
ICAgCWlmIChyZXQpDQo+ICAgCQlnb3RvIGVycm9yX2FzeW5jX3JlZ2lzdGVyOw0KPiAgIA0KPiAt
CXBtX3J1bnRpbWVfc2V0X2FjdGl2ZSgmY2xpZW50LT5kZXYpOw0KPiAtCXBtX3J1bnRpbWVfZW5h
YmxlKCZjbGllbnQtPmRldik7DQo+ICAgCXBtX3J1bnRpbWVfaWRsZSgmY2xpZW50LT5kZXYpOw0K
PiAgIA0KPiAgIAlyZXR1cm4gMDsNCj4gQEAgLTExMzQsNiArMTEzNSw4IEBAIHN0YXRpYyBpbnQg
b3Y3NzQwX3Byb2JlKHN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQsDQo+ICAgZXJyb3JfaW5pdF9j
b250cm9sczoNCj4gICAJb3Y3NzQwX2ZyZWVfY29udHJvbHMob3Y3NzQwKTsNCj4gICBlcnJvcl9k
ZXRlY3Q6DQo+ICsJcG1fcnVudGltZV9kaXNhYmxlKCZjbGllbnQtPmRldik7DQo+ICsJcG1fcnVu
dGltZV9zZXRfc3VzcGVuZGVkKCZjbGllbnQtPmRldik7DQo+ICAgCW92Nzc0MF9zZXRfcG93ZXIo
b3Y3NzQwLCAwKTsNCj4gICAJbWVkaWFfZW50aXR5X2NsZWFudXAoJm92Nzc0MC0+c3ViZGV2LmVu
dGl0eSk7DQo+ICAgDQo+IA0K
