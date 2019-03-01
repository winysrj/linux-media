Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D451C10F03
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 14:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C75CC20851
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 14:52:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=renesasgroup.onmicrosoft.com header.i=@renesasgroup.onmicrosoft.com header.b="HPyrbg3J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388631AbfCAOw7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:52:59 -0500
Received: from mail-eopbgr1400111.outbound.protection.outlook.com ([40.107.140.111]:15552
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728300AbfCAOw6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 09:52:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector1-bp-renesas-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ENTkYF4OxW8k/mjXm/6O/UWfyzoJuvtM4sfKGhfbyRs=;
 b=HPyrbg3Ju5/lk0QvatQamBsiW8yQxz9+PfPeD1JWTj1MRv6UKTOg3uIgmfNIrLk2eik1Iaj+NzrXEvmu6Iw7ySykbTtGC6uYkYRhbQfjn1KYOSAI8+db/Qa9NzWP8kJCFoQMaGIn3jubbGl9AgWHCuf4l1bnDezlwp1JRRdzjA4=
Received: from OSBPR01MB2103.jpnprd01.prod.outlook.com (52.134.242.17) by
 OSBPR01MB2887.jpnprd01.prod.outlook.com (52.134.255.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.16; Fri, 1 Mar 2019 14:52:52 +0000
Received: from OSBPR01MB2103.jpnprd01.prod.outlook.com
 ([fe80::d5b0:ac4:6d54:6285]) by OSBPR01MB2103.jpnprd01.prod.outlook.com
 ([fe80::d5b0:ac4:6d54:6285%5]) with mapi id 15.20.1643.022; Fri, 1 Mar 2019
 14:52:52 +0000
From:   Biju Das <biju.das@bp.renesas.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC:     =?utf-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?= 
        <niklas.soderlund@ragnatech.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Subject: RE: [PATCH RESEND v2 1/2] media: dt-bindings: media: rcar-csi2: Add
 r8a774a1 support
Thread-Topic: [PATCH RESEND v2 1/2] media: dt-bindings: media: rcar-csi2: Add
 r8a774a1 support
Thread-Index: AQHU0Ds/TzDRnrLOkkeECrlssPMigKX213EAgAADyGA=
Date:   Fri, 1 Mar 2019 14:52:51 +0000
Message-ID: <OSBPR01MB2103FC038B64247EE41AE256B8760@OSBPR01MB2103.jpnprd01.prod.outlook.com>
References: <1551450253-63390-1-git-send-email-biju.das@bp.renesas.com>
 <615b0c46-5939-bdce-e975-8572d42bdbe8@xs4all.nl>
In-Reply-To: <615b0c46-5939-bdce-e975-8572d42bdbe8@xs4all.nl>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efa439b9-d2e3-40d9-b3ef-08d69e559489
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:OSBPR01MB2887;
x-ms-traffictypediagnostic: OSBPR01MB2887:
x-microsoft-exchange-diagnostics: 1;OSBPR01MB2887;20:MSxgd3Qz1YkEdfhPEIL44joRy/At9BwN2dIIcO+ASKpXFJVKT6ibwxhIJQri6q4TRRrFRnyZBtxVM/nRdp3wYq6sqBMeLzqaSraI9vU0Dhzj7ZOvr/cQc0EOiaKjooUFElNSNnpAOMOrB/oNGdEuhcq4uDNP0M7Yt9JYxAV+sbE=
x-microsoft-antispam-prvs: <OSBPR01MB2887E1C5CCE6A87571E50684B8760@OSBPR01MB2887.jpnprd01.prod.outlook.com>
x-forefront-prvs: 09634B1196
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(346002)(136003)(39860400002)(396003)(189003)(199004)(51914003)(256004)(3846002)(68736007)(6116002)(97736004)(8936002)(5660300002)(229853002)(6436002)(7416002)(33656002)(14454004)(478600001)(71190400001)(71200400001)(7696005)(99286004)(6346003)(102836004)(26005)(52536013)(6506007)(53546011)(76176011)(2906002)(6246003)(55016002)(105586002)(106356001)(81156014)(107886003)(9686003)(316002)(66066001)(25786009)(8676002)(81166006)(186003)(446003)(44832011)(305945005)(74316002)(476003)(11346002)(7736002)(486006)(4326008)(54906003)(110136005)(53936002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:OSBPR01MB2887;H:OSBPR01MB2103.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: bp.renesas.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=biju.das@bp.renesas.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: k26uzbXwFk7RtqwpjQep1ZTqFeKFVX4ZptK5tGDoOrIt5B6+p/IHQBGkstAqUrR5ooovmsReSMwIPzr6oH3ZPKfVIDKiYS1pPc8xN9t8reKq1BSAwQIe47GaF7cGJOiQyEilAFUL1m8A1kHu4CSy1sA4iiEi6qRCRUqL7JMIAqEOACWYxKMcW0SnK4VT784EK3UQsyp/CX+4lLf+COECKyd4XaReuWXiS3p4237lMyfbVbHv0/K4YWaBgQjOJddjpH1ySZQJWaXPkH4inluoqvqFmfiOIdmbwlAR8oZpNt2kIVMmwHIONPyPpvxMFcy6isX+e6HpJB7q1Hm9PHUn+l1Djy3Z4mNaGHYh8reE4NIVcNhN0IE9cHf83SQh2nUvYaUID+foSJ9HAHwHigGkv2mN/UIDRL7E7+bFTWQMtXM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efa439b9-d2e3-40d9-b3ef-08d69e559489
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2019 14:52:51.8213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2887
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGkgSGFucywNCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suDQoNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCBSRVNFTkQgdjIgMS8yXSBtZWRpYTogZHQtYmluZGluZ3M6IG1lZGlhOiByY2FyLWNzaTI6
IEFkZA0KPiByOGE3NzRhMSBzdXBwb3J0DQo+DQo+IE9uIDMvMS8xOSAzOjI0IFBNLCBCaWp1IERh
cyB3cm90ZToNCj4gPiBEb2N1bWVudCBSWi9HMk0gKFI4QTc3NEExKSBTb0MgYmluZGluZ3MuDQo+
DQo+IFBsZWFzZSByZXNlbmQgdGhlIHdob2xlIHNlcmllcywgbm90IGp1c3QgdGhlIGR0LWJpbmRp
bmdzIHBhdGNoZXMuDQo+DQo+IEFsc28gbm90ZSB0aGF0IHRoZSBvcmlnaW5hbCB2MSBzZXJpZXMg
c2FpZCB0aGF0IHRoZXJlIHdlcmUgNSBwYXRjaGVzIGluIHRoZQ0KPiBzZXJpZXMsIGJ1dCBvbmx5
IHRoZSBmaXJzdCA0IHdlcmUgcmVjZWl2ZWQgb24gbGludXgtbWVkaWEuIFNvIEkgaGF2ZSBubyBp
ZGVhDQo+IHdoYXQgdGhlIDV0aCBwYXRjaCB3YXMgKGR0cyBjaGFuZ2UgcGVyaGFwcz8pLg0KDQpZ
ZXMsICBJdCBpcyBkdHMgcGF0Y2gNCg0KPiBIYXZpbmcgYSBuZXdseSBwb3N0ZWQgcGF0Y2ggc2Vy
aWVzIGF2b2lkcyBjb25mdXNpb24uDQoNCk9LLiBXaWxsIHNlbmQgdGhlIHdob2xlIHNlcmllcyBh
Z2Fpbi4uDQoNClJlZ2FyZHMsDQpCaWp1DQoNCj4gPg0KPiA+IFRoZSBSWi9HMk0gU29DIGlzIHNp
bWlsYXIgdG8gUi1DYXIgTTMtVyAoUjhBNzc5NikuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBC
aWp1IERhcyA8YmlqdS5kYXNAYnAucmVuZXNhcy5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IEZhYnJp
emlvIENhc3RybyA8ZmFicml6aW8uY2FzdHJvQGJwLnJlbmVzYXMuY29tPg0KPiA+IEFja2VkLWJ5
OiBOaWtsYXMgU8O2ZGVybHVuZCA8bmlrbGFzLnNvZGVybHVuZCtyZW5lc2FzQHJhZ25hdGVjaC5z
ZT4NCj4gPiBSZXZpZXdlZC1ieTogU2ltb24gSG9ybWFuIDxob3JtcytyZW5lc2FzQHZlcmdlLm5l
dC5hdT4NCj4gPiBSZXZpZXdlZC1ieTogUm9iIEhlcnJpbmcgPHJvYmhAa2VybmVsLm9yZz4NCj4g
PiAtLS0NCj4gPiBWMS0+VjINCj4gPiAgICAqIE5vIGNoYW5nZQ0KPiA+IC0tLQ0KPiA+ICBEb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvcmVuZXNhcyxyY2FyLWNzaTIudHh0
IHwgMSArDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPiA+DQo+ID4gZGlm
ZiAtLWdpdA0KPiA+IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21lZGlhL3Jl
bmVzYXMscmNhci1jc2kyLnR4dA0KPiA+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRp
bmdzL21lZGlhL3JlbmVzYXMscmNhci1jc2kyLnR4dA0KPiA+IGluZGV4IGQ2MzI3NWUuLjk5MzI0
NTggMTAwNjQ0DQo+ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21l
ZGlhL3JlbmVzYXMscmNhci1jc2kyLnR4dA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9tZWRpYS9yZW5lc2FzLHJjYXItY3NpMi50eHQNCj4gPiBAQCAtOCw2ICs4
LDcgQEAgUi1DYXIgVklOIG1vZHVsZSwgd2hpY2ggcHJvdmlkZXMgdGhlIHZpZGVvIGNhcHR1cmUN
Cj4gY2FwYWJpbGl0aWVzLg0KPiA+ICBNYW5kYXRvcnkgcHJvcGVydGllcw0KPiA+ICAtLS0tLS0t
LS0tLS0tLS0tLS0tLQ0KPiA+ICAgLSBjb21wYXRpYmxlOiBNdXN0IGJlIG9uZSBvciBtb3JlIG9m
IHRoZSBmb2xsb3dpbmcNCj4gPiArICAgLSAicmVuZXNhcyxyOGE3NzRhMS1jc2kyIiBmb3IgdGhl
IFI4QTc3NEExIGRldmljZS4NCj4gPiAgICAgLSAicmVuZXNhcyxyOGE3NzRjMC1jc2kyIiBmb3Ig
dGhlIFI4QTc3NEMwIGRldmljZS4NCj4gPiAgICAgLSAicmVuZXNhcyxyOGE3Nzk1LWNzaTIiIGZv
ciB0aGUgUjhBNzc5NSBkZXZpY2UuDQo+ID4gICAgIC0gInJlbmVzYXMscjhhNzc5Ni1jc2kyIiBm
b3IgdGhlIFI4QTc3OTYgZGV2aWNlLg0KPiA+DQoNCg0KDQpSZW5lc2FzIEVsZWN0cm9uaWNzIEV1
cm9wZSBHbWJILEdlc2NoYWVmdHNmdWVocmVyL1ByZXNpZGVudCA6IE1pY2hhZWwgSGFubmF3YWxk
LCBTaXR6IGRlciBHZXNlbGxzY2hhZnQvUmVnaXN0ZXJlZCBvZmZpY2U6IER1ZXNzZWxkb3JmLCBB
cmNhZGlhc3RyYXNzZSAxMCwgNDA0NzIgRHVlc3NlbGRvcmYsIEdlcm1hbnksSGFuZGVsc3JlZ2lz
dGVyL0NvbW1lcmNpYWwgUmVnaXN0ZXI6IER1ZXNzZWxkb3JmLCBIUkIgMzcwOCBVU3QtSUROci4v
VGF4IGlkZW50aWZpY2F0aW9uIG5vLjogREUgMTE5MzUzNDA2IFdFRUUtUmVnLi1Oci4vV0VFRSBy
ZWcuIG5vLjogREUgMTQ5Nzg2NDcNCg==
