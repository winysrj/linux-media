Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A48C4360F
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 15:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F95A20851
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 15:18:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=renesasgroup.onmicrosoft.com header.i=@renesasgroup.onmicrosoft.com header.b="FkLJ4iUA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388259AbfCAPS0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 10:18:26 -0500
Received: from mail-eopbgr1410123.outbound.protection.outlook.com ([40.107.141.123]:14560
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388036AbfCAPS0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 10:18:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector1-bp-renesas-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FtUYtMeJ0z5t8mrjorJI4IHbhe+cOWY17aUo/mgp41U=;
 b=FkLJ4iUA2eUuZbVj/ve0a64uYqOMdhLf2Cr55XoWSGRxZa3eVY/+H2PnKTPmtRFoEAZ0cJV9Qb1z/x4JfY7n4LGVq6oVHSnDRugzPKJTFwC3PpfvKY9go8tXdEc4KoqrP4PwVYfIr2bOTkqp5UByfDW0e2NTcIVfCXF6FgwrwC4=
Received: from OSBPR01MB2103.jpnprd01.prod.outlook.com (52.134.242.17) by
 OSBPR01MB3464.jpnprd01.prod.outlook.com (20.178.96.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.18; Fri, 1 Mar 2019 15:18:09 +0000
Received: from OSBPR01MB2103.jpnprd01.prod.outlook.com
 ([fe80::d5b0:ac4:6d54:6285]) by OSBPR01MB2103.jpnprd01.prod.outlook.com
 ([fe80::d5b0:ac4:6d54:6285%5]) with mapi id 15.20.1643.022; Fri, 1 Mar 2019
 15:18:09 +0000
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
Thread-Index: AQHU0Ds/TzDRnrLOkkeECrlssPMigKX213EAgAADyGCAAAb6YA==
Date:   Fri, 1 Mar 2019 15:18:09 +0000
Message-ID: <OSBPR01MB2103FD41B7BA18CDF16AAE36B8760@OSBPR01MB2103.jpnprd01.prod.outlook.com>
References: <1551450253-63390-1-git-send-email-biju.das@bp.renesas.com>
 <615b0c46-5939-bdce-e975-8572d42bdbe8@xs4all.nl>
 <OSBPR01MB2103FC038B64247EE41AE256B8760@OSBPR01MB2103.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB2103FC038B64247EE41AE256B8760@OSBPR01MB2103.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=biju.das@bp.renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd733cbc-cc7f-4f7e-45e0-08d69e591d33
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:OSBPR01MB3464;
x-ms-traffictypediagnostic: OSBPR01MB3464:
x-microsoft-exchange-diagnostics: 1;OSBPR01MB3464;20:23zabiKIk/Mkr/P5jHo+wXyZKipoJhuckU4o1gE3RONh6zdrAKKTTi9jdGCl4O6jMlyiwZl+rka+oPf05pe5WRwUHQl6VljX43BmuxFBeaZXn7BC2EKOakcsMYofrfTkOO3+sd+j0tj9VNrN3MkOyS3BoPYsx3+oV6qFtMHxnks=
x-microsoft-antispam-prvs: <OSBPR01MB346475E23F683F7EDCB97CC1B8760@OSBPR01MB3464.jpnprd01.prod.outlook.com>
x-forefront-prvs: 09634B1196
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(376002)(39860400002)(346002)(51914003)(199004)(189003)(486006)(105586002)(106356001)(44832011)(33656002)(102836004)(6116002)(66066001)(478600001)(3846002)(7696005)(53546011)(11346002)(76176011)(446003)(256004)(6506007)(476003)(6246003)(5660300002)(107886003)(99286004)(2940100002)(7416002)(71190400001)(71200400001)(26005)(93156006)(81156014)(316002)(25786009)(68736007)(4326008)(86362001)(110136005)(54906003)(14454004)(2906002)(8936002)(53936002)(229853002)(305945005)(74316002)(9686003)(55016002)(7736002)(97736004)(8676002)(52536013)(6436002)(81166006)(186003)(66574012);DIR:OUT;SFP:1102;SCL:1;SRVR:OSBPR01MB3464;H:OSBPR01MB2103.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: bp.renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zcTuE2FWz3Rx6ovddzR9AnAE4Hr/cVMF37GROD4ay1/zR6tZg2KeVV0xwrFtunHKuoeozdIkHd+f5H/TUkx4oMHlT9cFA0DOnvhYWksjZ/t2S33q5lP9WpeU6p0NcGyUr4DcOlD85m3+eTW84xpeYhOl5Aq4LbxuRSLH/7QvAA9obO8Wconqgn1/lo4Ws9OGDIYo05l9kOnuJxtBWv7KLcNCERQGk9Bvl2HsO5SEPyycaln3chqqbxY7BtpVtCyO6aEut4/d+j1zWBvKKYeqVU5RBmDQDOLl/gdTU97LVLsgTLvweXn6Y+Pilf4nV84N294u2N8p+hSGfVKOfLbJ63koeSqXK3Ipf7xb9RkNPQDfrNt+bLfRmhAL1x794FV6Tq/02yzHH4a2cC/W7tMBf9I1mJHl0y+LAwQdyNzZgMQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd733cbc-cc7f-4f7e-45e0-08d69e591d33
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2019 15:18:09.5929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3464
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGkgSGFucywNCg0KPiBTdWJqZWN0OiBSRTogW1BBVENIIFJFU0VORCB2MiAxLzJdIG1lZGlhOiBk
dC1iaW5kaW5nczogbWVkaWE6IHJjYXItY3NpMjogQWRkDQo+IHI4YTc3NGExIHN1cHBvcnQNCj4N
Cj4gSGkgSGFucywNCj4NCj4gVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suDQo+DQo+ID4gU3ViamVj
dDogUmU6IFtQQVRDSCBSRVNFTkQgdjIgMS8yXSBtZWRpYTogZHQtYmluZGluZ3M6IG1lZGlhOg0K
PiA+IHJjYXItY3NpMjogQWRkDQo+ID4gcjhhNzc0YTEgc3VwcG9ydA0KPiA+DQo+ID4gT24gMy8x
LzE5IDM6MjQgUE0sIEJpanUgRGFzIHdyb3RlOg0KPiA+ID4gRG9jdW1lbnQgUlovRzJNIChSOEE3
NzRBMSkgU29DIGJpbmRpbmdzLg0KPiA+DQo+ID4gUGxlYXNlIHJlc2VuZCB0aGUgd2hvbGUgc2Vy
aWVzLCBub3QganVzdCB0aGUgZHQtYmluZGluZ3MgcGF0Y2hlcy4NCj4gPg0KPiA+IEFsc28gbm90
ZSB0aGF0IHRoZSBvcmlnaW5hbCB2MSBzZXJpZXMgc2FpZCB0aGF0IHRoZXJlIHdlcmUgNSBwYXRj
aGVzDQo+ID4gaW4gdGhlIHNlcmllcywgYnV0IG9ubHkgdGhlIGZpcnN0IDQgd2VyZSByZWNlaXZl
ZCBvbiBsaW51eC1tZWRpYS4gU28gSQ0KPiA+IGhhdmUgbm8gaWRlYSB3aGF0IHRoZSA1dGggcGF0
Y2ggd2FzIChkdHMgY2hhbmdlIHBlcmhhcHM/KS4NCj4NCj4gWWVzLCAgSXQgaXMgZHRzIHBhdGNo
Lg0KDQpUaGlzIDV0aCBwYXRjaCBpcyBhbHJlYWR5IGluIG1lZGlhIHRyZWUgLiBjb21taXQgMGM4
NWU3OGZiMWQzNzQyYyAoImFybTY0OiBkdHM6IHJlbmVzYXM6IHI4YTc3NGExOiBBZGQgVklOIGFu
ZCBDU0ktMiBub2RlcyIpDQpTbyBJIHdpbGwgcmVzZW5kIHRoZSBwYXRjaCBzZXJpZXMgd2l0aCBm
aXJzdCA0IHBhdGNoZXMuDQoNClJlZ2FyZHMsDQpCaWp1DQoNCj4NCj4gPiA+DQo+ID4gPiBUaGUg
UlovRzJNIFNvQyBpcyBzaW1pbGFyIHRvIFItQ2FyIE0zLVcgKFI4QTc3OTYpLg0KPiA+ID4NCj4g
PiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhc0BicC5yZW5lc2FzLmNvbT4NCj4g
PiA+IFJldmlld2VkLWJ5OiBGYWJyaXppbyBDYXN0cm8gPGZhYnJpemlvLmNhc3Ryb0BicC5yZW5l
c2FzLmNvbT4NCj4gPiA+IEFja2VkLWJ5OiBOaWtsYXMgU8O2ZGVybHVuZCA8bmlrbGFzLnNvZGVy
bHVuZCtyZW5lc2FzQHJhZ25hdGVjaC5zZT4NCj4gPiA+IFJldmlld2VkLWJ5OiBTaW1vbiBIb3Jt
YW4gPGhvcm1zK3JlbmVzYXNAdmVyZ2UubmV0LmF1Pg0KPiA+ID4gUmV2aWV3ZWQtYnk6IFJvYiBI
ZXJyaW5nIDxyb2JoQGtlcm5lbC5vcmc+DQo+ID4gPiAtLS0NCj4gPiA+IFYxLT5WMg0KPiA+ID4g
ICAgKiBObyBjaGFuZ2UNCj4gPiA+IC0tLQ0KPiA+ID4gIERvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9tZWRpYS9yZW5lc2FzLHJjYXItY3NpMi50eHQgfCAxICsNCj4gPiA+ICAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gPiA+DQo+ID4gPiBkaWZmIC0tZ2l0DQo+ID4g
PiBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9tZWRpYS9yZW5lc2FzLHJjYXIt
Y3NpMi50eHQNCj4gPiA+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21lZGlh
L3JlbmVzYXMscmNhci1jc2kyLnR4dA0KPiA+ID4gaW5kZXggZDYzMjc1ZS4uOTkzMjQ1OCAxMDA2
NDQNCj4gPiA+IC0tLSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9tZWRpYS9y
ZW5lc2FzLHJjYXItY3NpMi50eHQNCj4gPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9tZWRpYS9yZW5lc2FzLHJjYXItY3NpMi50eHQNCj4gPiA+IEBAIC04LDYgKzgs
NyBAQCBSLUNhciBWSU4gbW9kdWxlLCB3aGljaCBwcm92aWRlcyB0aGUgdmlkZW8gY2FwdHVyZQ0K
PiA+IGNhcGFiaWxpdGllcy4NCj4gPiA+ICBNYW5kYXRvcnkgcHJvcGVydGllcw0KPiA+ID4gIC0t
LS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gPiAgIC0gY29tcGF0aWJsZTogTXVzdCBiZSBvbmUgb3Ig
bW9yZSBvZiB0aGUgZm9sbG93aW5nDQo+ID4gPiArICAgLSAicmVuZXNhcyxyOGE3NzRhMS1jc2ky
IiBmb3IgdGhlIFI4QTc3NEExIGRldmljZS4NCj4gPiA+ICAgICAtICJyZW5lc2FzLHI4YTc3NGMw
LWNzaTIiIGZvciB0aGUgUjhBNzc0QzAgZGV2aWNlLg0KPiA+ID4gICAgIC0gInJlbmVzYXMscjhh
Nzc5NS1jc2kyIiBmb3IgdGhlIFI4QTc3OTUgZGV2aWNlLg0KPiA+ID4gICAgIC0gInJlbmVzYXMs
cjhhNzc5Ni1jc2kyIiBmb3IgdGhlIFI4QTc3OTYgZGV2aWNlLg0KPiA+ID4NCg0KDQoNClJlbmVz
YXMgRWxlY3Ryb25pY3MgRXVyb3BlIEdtYkgsR2VzY2hhZWZ0c2Z1ZWhyZXIvUHJlc2lkZW50IDog
TWljaGFlbCBIYW5uYXdhbGQsIFNpdHogZGVyIEdlc2VsbHNjaGFmdC9SZWdpc3RlcmVkIG9mZmlj
ZTogRHVlc3NlbGRvcmYsIEFyY2FkaWFzdHJhc3NlIDEwLCA0MDQ3MiBEdWVzc2VsZG9yZiwgR2Vy
bWFueSxIYW5kZWxzcmVnaXN0ZXIvQ29tbWVyY2lhbCBSZWdpc3RlcjogRHVlc3NlbGRvcmYsIEhS
QiAzNzA4IFVTdC1JRE5yLi9UYXggaWRlbnRpZmljYXRpb24gbm8uOiBERSAxMTkzNTM0MDYgV0VF
RS1SZWcuLU5yLi9XRUVFIHJlZy4gbm8uOiBERSAxNDk3ODY0Nw0K
