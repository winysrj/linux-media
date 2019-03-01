Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1FFC10F03
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC23620851
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:22:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=renesasgroup.onmicrosoft.com header.i=@renesasgroup.onmicrosoft.com header.b="uaOKpPgW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387544AbfCANWC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:22:02 -0500
Received: from mail-eopbgr1410120.outbound.protection.outlook.com ([40.107.141.120]:59952
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727951AbfCANWB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 08:22:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector1-bp-renesas-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83ZfaTPbwZc8O4Y2wJNfBDuhOjPGhd7syWvH9Pve66k=;
 b=uaOKpPgWmUyRD4A3qV1Ttbta9e7esWLqYmD89dH1tZY/NvAOvUM/vY8dCzfObwH8AirBZXLhgiiYEfAjgG+Ks6Pnv8vXFfJOVHkPetMHj6j5p4bm+Rno3a/iiAVXU8RxsPjHxjHEV9YccOWwMs5rocPbX/yynGo7u83eMeNMBwc=
Received: from OSBPR01MB2103.jpnprd01.prod.outlook.com (52.134.242.17) by
 OSBPR01MB3031.jpnprd01.prod.outlook.com (52.134.252.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.17; Fri, 1 Mar 2019 13:21:54 +0000
Received: from OSBPR01MB2103.jpnprd01.prod.outlook.com
 ([fe80::d5b0:ac4:6d54:6285]) by OSBPR01MB2103.jpnprd01.prod.outlook.com
 ([fe80::d5b0:ac4:6d54:6285%5]) with mapi id 15.20.1643.022; Fri, 1 Mar 2019
 13:21:54 +0000
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
Thread-Index: AQHUSRPkl3NtQmcXZ0CHMGvDpVFZWaX3vTWAgAAM14CAAACzgIAAAukAgAAAKZCAAAKxAIAAAADg
Date:   Fri, 1 Mar 2019 13:21:54 +0000
Message-ID: <OSBPR01MB2103BF5BE70662BFE16DF5B1B8760@OSBPR01MB2103.jpnprd01.prod.outlook.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-2-git-send-email-biju.das@bp.renesas.com>
 <TYXPR01MB1775F18270FB477D010C180EC0760@TYXPR01MB1775.jpnprd01.prod.outlook.com>
 <8a5429a0-b4c5-a208-3e56-406bd031b01b@xs4all.nl>
 <CAMuHMdXOcFaQiLUNiuUS_p5H0r3ZWMrWd09m5xZk4qitvLS25g@mail.gmail.com>
 <3b702231-8d50-8434-177c-716203dac7b2@xs4all.nl>
 <OSBPR01MB21034BCCB73E585F2BC8C03CB8760@OSBPR01MB2103.jpnprd01.prod.outlook.com>
 <f6a3e336-9d44-aa06-5f92-e08398b6e992@xs4all.nl>
In-Reply-To: <f6a3e336-9d44-aa06-5f92-e08398b6e992@xs4all.nl>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=biju.das@bp.renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 610264fb-d166-4b36-b8fe-08d69e48dfaa
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:OSBPR01MB3031;
x-ms-traffictypediagnostic: OSBPR01MB3031:
x-microsoft-exchange-diagnostics: 1;OSBPR01MB3031;20:mxcn8BNHONi//hNQDOXRbxjPcT9tiCRPpQ+62S9SokYgrZuqpm9NjUF2Qcb9E41oaxCStHTB3nC6P1hDM5qbW8jArfN0znKLRU8yS0oin9X1DhQqdrCE+4DEValKVwGbBR0KD/bEB4hDgbfV8bYYO//sUHqh2CE+fUVuy0a8P7U=
x-microsoft-antispam-prvs: <OSBPR01MB3031EAC565F6FFBFB59E36D7B8760@OSBPR01MB3031.jpnprd01.prod.outlook.com>
x-forefront-prvs: 09634B1196
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(346002)(366004)(136003)(189003)(199004)(51914003)(13464003)(93886005)(74316002)(86362001)(2906002)(97736004)(8676002)(81156014)(256004)(14454004)(7736002)(25786009)(11346002)(44832011)(486006)(81166006)(476003)(446003)(305945005)(7416002)(71200400001)(71190400001)(33656002)(4326008)(229853002)(6246003)(68736007)(53546011)(102836004)(6506007)(106356001)(53936002)(478600001)(52536013)(5660300002)(110136005)(54906003)(55016002)(66066001)(26005)(186003)(316002)(3846002)(6116002)(9686003)(8936002)(7696005)(99286004)(76176011)(105586002)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:OSBPR01MB3031;H:OSBPR01MB2103.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: bp.renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FY4x9eLVuugOX3IAzAfYfSVKcPOdijRx6Phl3ThTGPacHzMKb6VaEE7OQlM0KGu+sj/ZBSFx4N7uwybSpxn0A/pSKnSsuhgv1fYEb6o04dybo+Px+hr49vkBl6JMIK5fPNSCQ6rzWp1VJiSJVzVzRixrj7C4bELByAlVEsXuCQ+VEvZz5BKw4BRDa2m80f1g7NcVGgvt6P6ONDsNDAvS1i/v7yRcGt8qoL1S+K0Mu7HKzdhtHP22MZjUbsH5IYPIlVVoIqrEGRH0Ji128PeGli0Y75PBAQSiquWoerJX/CoX4GZTzzI5HGVFKGqLzh4+k0qAf4uHsenlpEKn/M7VBpNbskumbyphCnMRR0ia2HE4oDRXpBDRD3AzKRaPVF16XiZRONHlFkYqKm2Kqmfl2sdcg5LbbFJHsWjXAr7HO9s=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 610264fb-d166-4b36-b8fe-08d69e48dfaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2019 13:21:54.5824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3031
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGkgSGFucywNCg0KWWVzLiBXaWxsIGRvLg0KDQpSZWdhcmRzLA0KQmlqdQ0KDQo+IC0tLS0tT3Jp
Z2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEhhbnMgVmVya3VpbCA8aHZlcmt1aWxAeHM0YWxs
Lm5sPg0KPiBTZW50OiAwMSBNYXJjaCAyMDE5IDEzOjE5DQo+IFRvOiBCaWp1IERhcyA8YmlqdS5k
YXNAYnAucmVuZXNhcy5jb20+OyBHZWVydCBVeXR0ZXJob2V2ZW4NCj4gPGdlZXJ0QGxpbnV4LW02
OGsub3JnPg0KPiBDYzogRmFicml6aW8gQ2FzdHJvIDxmYWJyaXppby5jYXN0cm9AYnAucmVuZXNh
cy5jb20+OyBNYXVybyBDYXJ2YWxobw0KPiBDaGVoYWIgPG1jaGVoYWJAa2VybmVsLm9yZz47IE5p
a2xhcyBTw7ZkZXJsdW5kDQo+IDxuaWtsYXMuc29kZXJsdW5kQHJhZ25hdGVjaC5zZT47IGxpbnV4
LW1lZGlhQHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+IHJlbmVzYXMtc29jQHZnZXIua2VybmVs
Lm9yZzsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IFNpbW9uIEhvcm1hbg0KPiA8aG9ybXNA
dmVyZ2UubmV0LmF1PjsgR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydCtyZW5lc2FzQGdsaWRlci5i
ZT47DQo+IENocmlzIFBhdGVyc29uIDxDaHJpcy5QYXRlcnNvbjJAcmVuZXNhcy5jb20+OyBSb2Ig
SGVycmluZw0KPiA8cm9iaCtkdEBrZXJuZWwub3JnPjsgTWFyayBSdXRsYW5kIDxtYXJrLnJ1dGxh
bmRAYXJtLmNvbT47IExhdXJlbnQNCj4gUGluY2hhcnQgPGxhdXJlbnQucGluY2hhcnRAaWRlYXNv
bmJvYXJkLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCAxLzVdIG1lZGlhOiBkdC1iaW5kaW5n
czogbWVkaWE6IHJjYXItY3NpMjogQWRkIHI4YTc3NGExDQo+IHN1cHBvcnQNCj4NCj4gSGkgQmlq
dSwNCj4NCj4gQ2FuIHlvdSBkbyB0aGUgZm9sbG93aW5nOg0KPg0KPiAxKSBmb3J3YXJkIGJvdGgg
b2YgUm9iJ3MgcmVwbGllcyB3aXRoIGhpcyBSZXZpZXdlZC1ieSB0YWcgdG8gbGludXgtbWVkaWEs
DQo+ICAgIHRoYXQgd2F5IEkgaGF2ZSBzZWVuIGl0Lg0KPiAyKSByZWJhc2UgdGhlIHBhdGNoIHNl
cmllcyBhbmQgYWRkIGFsbCBSZXZpZXdlZC1ieSBldGMuIHRhZ3MgYW5kIHBvc3QgYXMNCj4gICAg
YSB2Mi4gSSdsbCBwaWNrIGl0IHVwIGFuZCBtYWtlIHN1cmUgaXQgd2lsbCBnZXQgbWVyZ2VkLiBO
b3Qgc3VyZSBpZiB3ZQ0KPiAgICBjYW4gbWFuYWdlIDUuMSwgYnV0IGl0IHdpbGwgY2VydGFpbmx5
IGdldCBpbiA1LjIuDQo+DQo+IFJlZ2FyZHMsDQo+DQo+IEhhbnMNCj4NCj4gT24gMy8xLzE5IDI6
MTIgUE0sIEJpanUgRGFzIHdyb3RlOg0KPiA+IEhpIEhhbnMsDQo+ID4NCj4gPiBUaGFua3MgZm9y
IHRoZSBmZWVkYmFjay4NCj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+
PiBGcm9tOiBIYW5zIFZlcmt1aWwgPGh2ZXJrdWlsQHhzNGFsbC5ubD4NCj4gPj4gU2VudDogMDEg
TWFyY2ggMjAxOSAxMzowOQ0KPiA+PiBUbzogR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydEBsaW51
eC1tNjhrLm9yZz4NCj4gPj4gQ2M6IEZhYnJpemlvIENhc3RybyA8ZmFicml6aW8uY2FzdHJvQGJw
LnJlbmVzYXMuY29tPjsgTWF1cm8gQ2FydmFsaG8NCj4gPj4gQ2hlaGFiIDxtY2hlaGFiQGtlcm5l
bC5vcmc+OyBCaWp1IERhcyA8YmlqdS5kYXNAYnAucmVuZXNhcy5jb20+Ow0KPiA+PiBOaWtsYXMg
U8O2ZGVybHVuZCA8bmlrbGFzLnNvZGVybHVuZEByYWduYXRlY2guc2U+OyBsaW51eC0NCj4gPj4g
bWVkaWFAdmdlci5rZXJuZWwub3JnOyBsaW51eC1yZW5lc2FzLXNvY0B2Z2VyLmtlcm5lbC5vcmc7
DQo+ID4+IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBTaW1vbiBIb3JtYW4gPGhvcm1zQHZl
cmdlLm5ldC5hdT47DQo+IEdlZXJ0DQo+ID4+IFV5dHRlcmhvZXZlbiA8Z2VlcnQrcmVuZXNhc0Bn
bGlkZXIuYmU+OyBDaHJpcyBQYXRlcnNvbg0KPiA+PiA8Q2hyaXMuUGF0ZXJzb24yQHJlbmVzYXMu
Y29tPjsgUm9iIEhlcnJpbmcgPHJvYmgrZHRAa2VybmVsLm9yZz47DQo+IE1hcmsNCj4gPj4gUnV0
bGFuZCA8bWFyay5ydXRsYW5kQGFybS5jb20+OyBMYXVyZW50IFBpbmNoYXJ0DQo+ID4+IDxsYXVy
ZW50LnBpbmNoYXJ0QGlkZWFzb25ib2FyZC5jb20+DQo+ID4+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
MS81XSBtZWRpYTogZHQtYmluZGluZ3M6IG1lZGlhOiByY2FyLWNzaTI6IEFkZA0KPiA+PiByOGE3
NzRhMSBzdXBwb3J0DQo+ID4+DQo+ID4+IE9uIDMvMS8xOSAxOjU4IFBNLCBHZWVydCBVeXR0ZXJo
b2V2ZW4gd3JvdGU6DQo+ID4+PiBIaSBIYW5zLA0KPiA+Pj4NCj4gPj4+IE9uIEZyaSwgTWFyIDEs
IDIwMTkgYXQgMTo1NSBQTSBIYW5zIFZlcmt1aWwgPGh2ZXJrdWlsQHhzNGFsbC5ubD4gd3JvdGU6
DQo+ID4+Pj4gSXQgbG9va3MgbGlrZSB0aGlzIHNlcmllcyBmZWxsIHRocm91Z2ggdGhlIGNyYWNr
cy4NCj4gPj4+Pg0KPiA+Pj4+IEkgbG9va2VkIGF0IGl0IGFuZCB0aGUgbWFpbiBwcm9ibGVtIGlz
IHRoYXQgaXQgaXMgbWlzc2luZyBhDQo+ID4+Pj4gUmV2aWV3ZWQtYnkgZnJvbSBSb2IgSGVycmlu
ZyAoZGV2aWNldHJlZSBtYWludGFpbmVyKS4gSXQncyBhIGJpdA0KPiA+Pj4+IHN1cnByaXNpbmcg
c2luY2UgaGUgaXMgdXN1YWxseSBmYWlybHkgcHJvbXB0Lg0KPiA+Pj4NCj4gPj4+IEhlIGFjdHVh
bGx5IGRpZCBwcm92aWRlIGhpcyBSYiBvbiBTZXAgMTcuDQo+ID4+DQo+ID4+IEhtbSwgSSBkb24n
dCBzZWUgYW55dGhpbmcgYWJvdXQgdGhhdCBpbiBteSBsaW51eC1tZWRpYSBhcmNoaXZlLCBhbmQN
Cj4gPj4gcGF0Y2h3b3JrIGRpZG4ndCBwaWNrIHRoYXQgdXAgZWl0aGVyLg0KPiA+Pg0KPiA+PiBX
YXMgbGludXgtbWVkaWEgaW4gdGhlIENDIGxpc3Qgb2YgUm9iJ3MgcmVwbHk/DQo+ID4NCj4gPiBZ
ZXMuIFBsZWFzZSBzZWUgYmVsb3cuDQo+ID4NCj4gPj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0t
LS0NCj4gPj4gRnJvbTogUm9iIEhlcnJpbmcgPHJvYmhAa2VybmVsLm9yZz4NCj4gPj4gU2VudDog
MTcgU2VwdGVtYmVyIDIwMTggMDY6NDUNCj4gPj4gVG86IEJpanUgRGFzIDxiaWp1LmRhc0BicC5y
ZW5lc2FzLmNvbT4NCj4gPj4gQ2M6IE1hdXJvIENhcnZhbGhvIENoZWhhYiA8bWNoZWhhYkBrZXJu
ZWwub3JnPjsgTWFyayBSdXRsYW5kDQo+ID4+IDxtYXJrLnJ1dGxhbmRAYXJtLmNvbT47IEJpanUg
RGFzIDxiaWp1LmRhc0BicC5yZW5lc2FzLmNvbT47IE5pa2xhcw0KPiA+PiBTw7ZkZXJsdW5kIDxu
aWtsYXMuc29kZXJsdW5kQHJhZ25hdGVjaC5zZT47DQo+ID4+IGxpbnV4LW1lZGlhQHZnZXIua2Vy
bmVsLm9yZzsgbGludXgtcmVuZXNhcy1zb2NAdmdlci5rZXJuZWwub3JnOw0KPiA+PiBkZXZpY2V0
cmVlQHZnZXIua2VybmVsLm9yZzsgU2ltb24gSG9ybWFuIDxob3Jtc0B2ZXJnZS5uZXQuYXU+Ow0K
PiBHZWVydA0KPiA+PiBVeXR0ZXJob2V2ZW4gPGdlZXJ0K3JlbmVzYXNAZ2xpZGVyLmJlPjsgQ2hy
aXMgUGF0ZXJzb24NCj4gPj4gPENocmlzLlBhdGVyc29uMkByZW5lc2FzLmNvbT47IEZhYnJpemlv
IENhc3Rybw0KPiA+PiA8ZmFicml6aW8uY2FzdHJvQGJwLnJlbmVzYXMuY29tPg0KPiA+PiBTdWJq
ZWN0OiBSZTogW1BBVENIIDEvNV0gbWVkaWE6IGR0LWJpbmRpbmdzOiBtZWRpYTogcmNhci1jc2ky
OiBBZGQNCj4gPj4gcjhhNzc0YTEgc3VwcG9ydA0KPiA+Pg0KPiA+PiBPbiBNb24sIDEwIFNlcCAy
MDE4IDE1OjMxOjE0ICswMTAwLCBCaWp1IERhcyB3cm90ZToNCj4gPj4+IERvY3VtZW50IFJaL0cy
TSAoUjhBNzc0QTEpIFNvQyBiaW5kaW5ncy4NCj4gPj4+DQo+ID4+PiBUaGUgUlovRzJNIFNvQyBp
cyBzaW1pbGFyIHRvIFItQ2FyIE0zLVcgKFI4QTc3OTYpLg0KPiA+Pj4NCj4gPj4+IFNpZ25lZC1v
ZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhc0BicC5yZW5lc2FzLmNvbT4NCj4gPj4+IFJldmlld2Vk
LWJ5OiBGYWJyaXppbyBDYXN0cm8gPGZhYnJpemlvLmNhc3Ryb0BicC5yZW5lc2FzLmNvbT4NCj4g
Pj4+IC0tLQ0KPiA+Pj4gIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9tZWRpYS9y
ZW5lc2FzLHJjYXItY3NpMi50eHQgfCA1DQo+ID4+PiArKystLQ0KPiA+Pj4gIDEgZmlsZSBjaGFu
Z2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4+Pg0KPiA+Pg0KPiA+PiBS
ZXZpZXdlZC1ieTogUm9iIEhlcnJpbmcgPHJvYmhAa2VybmVsLm9yZz4NCj4gPg0KPiA+IFJlZ2Fy
ZHMsDQo+ID4gQmlqdQ0KPiA+DQo+ID4NCj4gPiBSZW5lc2FzIEVsZWN0cm9uaWNzIEV1cm9wZSBH
bWJILEdlc2NoYWVmdHNmdWVocmVyL1ByZXNpZGVudCA6IE1pY2hhZWwNCj4gPiBIYW5uYXdhbGQs
IFNpdHogZGVyIEdlc2VsbHNjaGFmdC9SZWdpc3RlcmVkIG9mZmljZTogRHVlc3NlbGRvcmYsDQo+
ID4gQXJjYWRpYXN0cmFzc2UgMTAsIDQwNDcyIER1ZXNzZWxkb3JmLA0KPiA+IEdlcm1hbnksSGFu
ZGVsc3JlZ2lzdGVyL0NvbW1lcmNpYWwgUmVnaXN0ZXI6IER1ZXNzZWxkb3JmLCBIUkIgMzcwOA0K
PiA+IFVTdC1JRE5yLi9UYXggaWRlbnRpZmljYXRpb24gbm8uOiBERSAxMTkzNTM0MDYgV0VFRS1S
ZWcuLU5yLi9XRUVFIHJlZy4NCj4gPiBuby46IERFIDE0OTc4NjQ3DQo+ID4NCg0KDQoNClJlbmVz
YXMgRWxlY3Ryb25pY3MgRXVyb3BlIEdtYkgsR2VzY2hhZWZ0c2Z1ZWhyZXIvUHJlc2lkZW50IDog
TWljaGFlbCBIYW5uYXdhbGQsIFNpdHogZGVyIEdlc2VsbHNjaGFmdC9SZWdpc3RlcmVkIG9mZmlj
ZTogRHVlc3NlbGRvcmYsIEFyY2FkaWFzdHJhc3NlIDEwLCA0MDQ3MiBEdWVzc2VsZG9yZiwgR2Vy
bWFueSxIYW5kZWxzcmVnaXN0ZXIvQ29tbWVyY2lhbCBSZWdpc3RlcjogRHVlc3NlbGRvcmYsIEhS
QiAzNzA4IFVTdC1JRE5yLi9UYXggaWRlbnRpZmljYXRpb24gbm8uOiBERSAxMTkzNTM0MDYgV0VF
RS1SZWcuLU5yLi9XRUVFIHJlZy4gbm8uOiBERSAxNDk3ODY0Nw0K
