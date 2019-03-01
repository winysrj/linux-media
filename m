Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A4EEC4360F
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3246A20850
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:12:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=renesasgroup.onmicrosoft.com header.i=@renesasgroup.onmicrosoft.com header.b="NN4VadIs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733072AbfCANMr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:12:47 -0500
Received: from mail-eopbgr1400103.outbound.protection.outlook.com ([40.107.140.103]:29088
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbfCANMq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 08:12:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector1-bp-renesas-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HHQG8IFi1mUOQtWIqR0mYVxMxKTMXA+M40mtlqkeUi0=;
 b=NN4VadIsVOp5GrDwbGojMldVsHGqRD7nKHeqJwPFjtneYoQ0dfACtrPvnToKnbBtRj5hxlV6S2pb3lWgBBuWQ0lUCATlr6TnOrXrw9UuHUFoEo4QNly0S2YTAuQE0nv9/29qTkikYTxhXDob7Nc16N04dbX8J65ZpUmDgS/CR+Q=
Received: from OSBPR01MB2103.jpnprd01.prod.outlook.com (52.134.242.17) by
 OSBPR01MB3447.jpnprd01.prod.outlook.com (20.178.98.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.16; Fri, 1 Mar 2019 13:12:37 +0000
Received: from OSBPR01MB2103.jpnprd01.prod.outlook.com
 ([fe80::d5b0:ac4:6d54:6285]) by OSBPR01MB2103.jpnprd01.prod.outlook.com
 ([fe80::d5b0:ac4:6d54:6285%5]) with mapi id 15.20.1643.022; Fri, 1 Mar 2019
 13:12:37 +0000
From:   Biju Das <biju.das@bp.renesas.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?utf-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?= 
        <niklas.soderlund@ragnatech.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: RE: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1
 support
Thread-Topic: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1
 support
Thread-Index: AQHUSRPkl3NtQmcXZ0CHMGvDpVFZWaX3vTWAgAAM14CAAACzgIAAAukAgAAAKZA=
Date:   Fri, 1 Mar 2019 13:12:37 +0000
Message-ID: <OSBPR01MB21034BCCB73E585F2BC8C03CB8760@OSBPR01MB2103.jpnprd01.prod.outlook.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-2-git-send-email-biju.das@bp.renesas.com>
 <TYXPR01MB1775F18270FB477D010C180EC0760@TYXPR01MB1775.jpnprd01.prod.outlook.com>
 <8a5429a0-b4c5-a208-3e56-406bd031b01b@xs4all.nl>
 <CAMuHMdXOcFaQiLUNiuUS_p5H0r3ZWMrWd09m5xZk4qitvLS25g@mail.gmail.com>
 <3b702231-8d50-8434-177c-716203dac7b2@xs4all.nl>
In-Reply-To: <3b702231-8d50-8434-177c-716203dac7b2@xs4all.nl>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1da8be57-ef79-44f9-e08d-08d69e4793b6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:OSBPR01MB3447;
x-ms-traffictypediagnostic: OSBPR01MB3447:
x-microsoft-exchange-diagnostics: 1;OSBPR01MB3447;20:22SNj5dE25sGl4kv8qVIVn3t/17aHQSwbitr3CetEaLb+pIzpcAC6RuyW2H4A0OoOj2HEqwcVF8rs6iueHzhsRTm/07HAyvWT6YwZS8n9Qs7XF+yMPgLwMm6Hxd74HOjfikEjL5fMW7V8kWQHxN31t4w/sAnVUYRU5/zKaMUchQ=
x-microsoft-antispam-prvs: <OSBPR01MB34478840CAEF92E76380C576B8760@OSBPR01MB3447.jpnprd01.prod.outlook.com>
x-forefront-prvs: 09634B1196
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(346002)(39860400002)(136003)(366004)(199004)(189003)(13464003)(51914003)(71200400001)(3846002)(53936002)(9686003)(478600001)(305945005)(66066001)(6436002)(99286004)(256004)(52536013)(74316002)(71190400001)(7696005)(2906002)(55016002)(76176011)(53546011)(6506007)(7416002)(26005)(14454004)(86362001)(6116002)(7736002)(102836004)(81166006)(6246003)(6346003)(8676002)(229853002)(81156014)(25786009)(4326008)(105586002)(68736007)(110136005)(316002)(486006)(11346002)(446003)(476003)(186003)(8936002)(44832011)(106356001)(54906003)(93886005)(97736004)(5660300002)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:OSBPR01MB3447;H:OSBPR01MB2103.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: bp.renesas.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=biju.das@bp.renesas.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: samIQz8xCynyDN1EO1R4a5kscjdm+GzGF0arO0TWRUVoRscuyM4eAKcpOD4GfpEqJoTJpE2YpE79+DFFAaZiQGXFdaKdeV01eKwMrB5q0rS6901okJCq5+mCgKEY3MZDFwSSzb3RcPYGT6mSGGo1/KGv+SSf2G0MU+XKjC/bi2GYpPrn5h6oPURaD989RWGwhxRlFEfvUvN5Cj1gMfLKVbNtWlzTZirpRBRsI0qw6QcMVGD71l1OL5r36Bku2AhJJfAJ//iVN/oHSYjPGyMvpXdomPCiEtvNqreyuy5qo/U9tEIaQyjB7OT2eMjxoEejI1oRBrTV9linEWAsrj0hBLSsvIByE/ljvsl7uOXE3m97MOAUBmJG6C5QwK2ttvobKAdgrtihrTqNiJxrhcTG7iP02GOBxBWefvhYujOHPJ4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da8be57-ef79-44f9-e08d-08d69e4793b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2019 13:12:37.6705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3447
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGkgSGFucywNCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suDQoNCj4gLS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCj4gRnJvbTogSGFucyBWZXJrdWlsIDxodmVya3VpbEB4czRhbGwubmw+DQo+
IFNlbnQ6IDAxIE1hcmNoIDIwMTkgMTM6MDkNCj4gVG86IEdlZXJ0IFV5dHRlcmhvZXZlbiA8Z2Vl
cnRAbGludXgtbTY4ay5vcmc+DQo+IENjOiBGYWJyaXppbyBDYXN0cm8gPGZhYnJpemlvLmNhc3Ry
b0BicC5yZW5lc2FzLmNvbT47IE1hdXJvIENhcnZhbGhvDQo+IENoZWhhYiA8bWNoZWhhYkBrZXJu
ZWwub3JnPjsgQmlqdSBEYXMgPGJpanUuZGFzQGJwLnJlbmVzYXMuY29tPjsNCj4gTmlrbGFzIFPD
tmRlcmx1bmQgPG5pa2xhcy5zb2Rlcmx1bmRAcmFnbmF0ZWNoLnNlPjsgbGludXgtDQo+IG1lZGlh
QHZnZXIua2VybmVsLm9yZzsgbGludXgtcmVuZXNhcy1zb2NAdmdlci5rZXJuZWwub3JnOw0KPiBk
ZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgU2ltb24gSG9ybWFuIDxob3Jtc0B2ZXJnZS5uZXQu
YXU+OyBHZWVydA0KPiBVeXR0ZXJob2V2ZW4gPGdlZXJ0K3JlbmVzYXNAZ2xpZGVyLmJlPjsgQ2hy
aXMgUGF0ZXJzb24NCj4gPENocmlzLlBhdGVyc29uMkByZW5lc2FzLmNvbT47IFJvYiBIZXJyaW5n
IDxyb2JoK2R0QGtlcm5lbC5vcmc+OyBNYXJrDQo+IFJ1dGxhbmQgPG1hcmsucnV0bGFuZEBhcm0u
Y29tPjsgTGF1cmVudCBQaW5jaGFydA0KPiA8bGF1cmVudC5waW5jaGFydEBpZGVhc29uYm9hcmQu
Y29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDEvNV0gbWVkaWE6IGR0LWJpbmRpbmdzOiBtZWRp
YTogcmNhci1jc2kyOiBBZGQgcjhhNzc0YTENCj4gc3VwcG9ydA0KPg0KPiBPbiAzLzEvMTkgMTo1
OCBQTSwgR2VlcnQgVXl0dGVyaG9ldmVuIHdyb3RlOg0KPiA+IEhpIEhhbnMsDQo+ID4NCj4gPiBP
biBGcmksIE1hciAxLCAyMDE5IGF0IDE6NTUgUE0gSGFucyBWZXJrdWlsIDxodmVya3VpbEB4czRh
bGwubmw+IHdyb3RlOg0KPiA+PiBJdCBsb29rcyBsaWtlIHRoaXMgc2VyaWVzIGZlbGwgdGhyb3Vn
aCB0aGUgY3JhY2tzLg0KPiA+Pg0KPiA+PiBJIGxvb2tlZCBhdCBpdCBhbmQgdGhlIG1haW4gcHJv
YmxlbSBpcyB0aGF0IGl0IGlzIG1pc3NpbmcgYQ0KPiA+PiBSZXZpZXdlZC1ieSBmcm9tIFJvYiBI
ZXJyaW5nIChkZXZpY2V0cmVlIG1haW50YWluZXIpLiBJdCdzIGEgYml0DQo+ID4+IHN1cnByaXNp
bmcgc2luY2UgaGUgaXMgdXN1YWxseSBmYWlybHkgcHJvbXB0Lg0KPiA+DQo+ID4gSGUgYWN0dWFs
bHkgZGlkIHByb3ZpZGUgaGlzIFJiIG9uIFNlcCAxNy4NCj4NCj4gSG1tLCBJIGRvbid0IHNlZSBh
bnl0aGluZyBhYm91dCB0aGF0IGluIG15IGxpbnV4LW1lZGlhIGFyY2hpdmUsIGFuZA0KPiBwYXRj
aHdvcmsgZGlkbid0IHBpY2sgdGhhdCB1cCBlaXRoZXIuDQo+DQo+IFdhcyBsaW51eC1tZWRpYSBp
biB0aGUgQ0MgbGlzdCBvZiBSb2IncyByZXBseT8NCg0KWWVzLiBQbGVhc2Ugc2VlIGJlbG93Lg0K
DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJvYiBIZXJyaW5nIDxyb2Jo
QGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDE3IFNlcHRlbWJlciAyMDE4IDA2OjQ1DQo+IFRvOiBCaWp1
IERhcyA8YmlqdS5kYXNAYnAucmVuZXNhcy5jb20+DQo+IENjOiBNYXVybyBDYXJ2YWxobyBDaGVo
YWIgPG1jaGVoYWJAa2VybmVsLm9yZz47IE1hcmsgUnV0bGFuZA0KPiA8bWFyay5ydXRsYW5kQGFy
bS5jb20+OyBCaWp1IERhcyA8YmlqdS5kYXNAYnAucmVuZXNhcy5jb20+OyBOaWtsYXMNCj4gU8O2
ZGVybHVuZCA8bmlrbGFzLnNvZGVybHVuZEByYWduYXRlY2guc2U+OyBsaW51eC1tZWRpYUB2Z2Vy
Lmtlcm5lbC5vcmc7DQo+IGxpbnV4LXJlbmVzYXMtc29jQHZnZXIua2VybmVsLm9yZzsgZGV2aWNl
dHJlZUB2Z2VyLmtlcm5lbC5vcmc7IFNpbW9uDQo+IEhvcm1hbiA8aG9ybXNAdmVyZ2UubmV0LmF1
PjsgR2VlcnQgVXl0dGVyaG9ldmVuDQo+IDxnZWVydCtyZW5lc2FzQGdsaWRlci5iZT47IENocmlz
IFBhdGVyc29uDQo+IDxDaHJpcy5QYXRlcnNvbjJAcmVuZXNhcy5jb20+OyBGYWJyaXppbyBDYXN0
cm8NCj4gPGZhYnJpemlvLmNhc3Ryb0BicC5yZW5lc2FzLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCAxLzVdIG1lZGlhOiBkdC1iaW5kaW5nczogbWVkaWE6IHJjYXItY3NpMjogQWRkIHI4YTc3
NGExDQo+IHN1cHBvcnQNCj4NCj4gT24gTW9uLCAxMCBTZXAgMjAxOCAxNTozMToxNCArMDEwMCwg
QmlqdSBEYXMgd3JvdGU6DQo+ID4gRG9jdW1lbnQgUlovRzJNIChSOEE3NzRBMSkgU29DIGJpbmRp
bmdzLg0KPiA+DQo+ID4gVGhlIFJaL0cyTSBTb0MgaXMgc2ltaWxhciB0byBSLUNhciBNMy1XIChS
OEE3Nzk2KS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhc0BicC5y
ZW5lc2FzLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogRmFicml6aW8gQ2FzdHJvIDxmYWJyaXppby5j
YXN0cm9AYnAucmVuZXNhcy5jb20+DQo+ID4gLS0tDQo+ID4gIERvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9tZWRpYS9yZW5lc2FzLHJjYXItY3NpMi50eHQgfCA1ICsrKy0tDQo+ID4g
IDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4NCj4N
Cj4gUmV2aWV3ZWQtYnk6IFJvYiBIZXJyaW5nIDxyb2JoQGtlcm5lbC5vcmc+DQoNClJlZ2FyZHMs
DQpCaWp1DQoNCg0KUmVuZXNhcyBFbGVjdHJvbmljcyBFdXJvcGUgR21iSCxHZXNjaGFlZnRzZnVl
aHJlci9QcmVzaWRlbnQgOiBNaWNoYWVsIEhhbm5hd2FsZCwgU2l0eiBkZXIgR2VzZWxsc2NoYWZ0
L1JlZ2lzdGVyZWQgb2ZmaWNlOiBEdWVzc2VsZG9yZiwgQXJjYWRpYXN0cmFzc2UgMTAsIDQwNDcy
IER1ZXNzZWxkb3JmLCBHZXJtYW55LEhhbmRlbHNyZWdpc3Rlci9Db21tZXJjaWFsIFJlZ2lzdGVy
OiBEdWVzc2VsZG9yZiwgSFJCIDM3MDggVVN0LUlETnIuL1RheCBpZGVudGlmaWNhdGlvbiBuby46
IERFIDExOTM1MzQwNiBXRUVFLVJlZy4tTnIuL1dFRUUgcmVnLiBuby46IERFIDE0OTc4NjQ3DQo=
