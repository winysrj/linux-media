Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EF5C43612
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 09:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFB532177E
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 09:49:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="GeA8KM18"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731427AbfAKJto (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 04:49:44 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:50649 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731416AbfAKJtn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 04:49:43 -0500
X-IronPort-AV: E=Sophos;i="5.56,465,1539673200"; 
   d="scan'208";a="25362998"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 11 Jan 2019 02:49:42 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 11 Jan 2019 02:49:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFU04S5zG8nGFVhZqNKHb5Yf2U+DQyhEWfxio82Fzeo=;
 b=GeA8KM18oid9ScVDiL+bDxPEDFBZiN96qpwx4PWpvUlZdtCGcPgChHpYjPVVN8GnOEV1DnuTuBkeyjHL6X3IZrzSyw5cbnYrsxxrlQHkH8FD92pc6AiW+R//SkI7labc2hyoihTJLoCO1Tlx7mBhmwk2F7jalVxcPPncagRI5KY=
Received: from MWHPR11MB1248.namprd11.prod.outlook.com (10.169.236.145) by
 MWHPR11MB2063.namprd11.prod.outlook.com (10.169.236.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.13; Fri, 11 Jan 2019 09:49:39 +0000
Received: from MWHPR11MB1248.namprd11.prod.outlook.com
 ([fe80::c14e:91dd:ffb7:5c1d]) by MWHPR11MB1248.namprd11.prod.outlook.com
 ([fe80::c14e:91dd:ffb7:5c1d%9]) with mapi id 15.20.1516.015; Fri, 11 Jan 2019
 09:49:39 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <luis.oliveira@synopsys.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <joao.pinto@synopsys.com>, <festevam@gmail.com>,
        <mchehab@kernel.org>, <gregkh@linuxfoundation.org>,
        <davem@davemloft.net>, <akpm@linux-foundation.org>,
        <arnd@arndb.de>, <hans.verkuil@cisco.com>,
        <laurent.pinchart@ideasonboard.com>, <geert@linux-m68k.org>,
        <narmstrong@baylibre.com>, <p.zabel@pengutronix.de>,
        <treding@nvidia.com>, <maxime.ripard@bootlin.com>,
        <todor.tomov@linaro.org>
Subject: Re: [V3, 4/4] media: platform: dwc: Add MIPI CSI-2 controller driver
Thread-Topic: [V3, 4/4] media: platform: dwc: Add MIPI CSI-2 controller driver
Thread-Index: AQHUqBuhCcv9szjWl0qFFgx76hUWpKWosBEAgAD8KwCAAA4JAIAAGkMA
Date:   Fri, 11 Jan 2019 09:49:39 +0000
Message-ID: <bf825cf1-14b1-b1bf-d433-f8b552bb9ace@microchip.com>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
 <1539953556-35762-5-git-send-email-lolivei@synopsys.com>
 <4db76eb2-460f-c644-6dbd-370b07b2def8@microchip.com>
 <2407a3ca-1a83-5685-c26c-a922251b2943@synopsys.com>
 <24f6a1fe-4790-91ba-ce21-72397c0a02df@microchip.com>
 <2c5b8a1b-c620-787b-9d83-6bfe099c4552@synopsys.com>
In-Reply-To: <2c5b8a1b-c620-787b-9d83-6bfe099c4552@synopsys.com>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR0101CA0047.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::15) To MWHPR11MB1248.namprd11.prod.outlook.com
 (2603:10b6:300:29::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHPR11MB2063;6:XfXW51EUevz1ExpyiGIYaPDLhip/NK+O6VtmfUS6CWtpV3MAtRaeQCCAraazGxiAsgP/oBvXzdYpYOhtaaDQWqMW0YQjlpmMV+jZmGHitpD6bG+s2A4EuANEIwQSUHpUrquyhOdzK6Gj7Mzo0LOEbvqdNpF4umPugdNYE/AZy0j4duo1FQ2Kg4+fTCHiO4KY7xdo7r2YsG4qVMkb+pqNmbwVyuf0erSx3UdosXFtE5GKnL5R29Z5Rs2gVuiABxgg3UzhE3IA1enQfjC/0VqiOM6ObOf8EWpXYX9VXjRnE9qiPZ64Ang7SoK3SYIlxjF02pMDF7lv7o6nUFcl10HibnZCf2Tx43THo2O5hWmTg9A7V7N7rEjdLFPUhGlmKrPk0qtn/AeJdwtmMsDEa1pFDjnqW5vhT4DOaxkACT394f3P+dWqVU1FqtmE7wYv8vi6wDOgUuMzV3jbMuz7ipczJg==;5:F+js73pAuYKDoeoKifvfhMcbZj+x1mGcno/QB4YBFJ+0ulSM1ck80K4IRvqzT+Msvsg9oqvqxh5zvWEuDvkFrFUNK/PyLqzmOm7RTxwJmmi/qd4FNdQd6ZDYqkiC1yQ75fmbfkhgA+snyptSlqA6kwU+JyjvEkQui39tm3kAJQ26U4ksbZwY6gBh20/2LayceUgBWbOpZFWxFbiwLwELbg==;7:GNRzaHLLhe0/jWEZKuyv2ewTwNr/+2sMCtyxPiLm//2OrlHBDFzoiBR+zjmu0FMKPd2zqtJ84Y/nygKY8FKfo7Vs1cv1iXlxHXXcM79sDn7U06y35JKzAY5p/LSkhbC8BucUoLDch1irIrHVPEscsw==
x-ms-office365-filtering-correlation-id: cc3a1f31-6d73-47a1-ebef-08d677aa1a27
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600109)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:MWHPR11MB2063;
x-ms-traffictypediagnostic: MWHPR11MB2063:
x-microsoft-antispam-prvs: <MWHPR11MB20634CC7E9087B160BDB96D5E8850@MWHPR11MB2063.namprd11.prod.outlook.com>
x-forefront-prvs: 09144DB0F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(376002)(396003)(346002)(39860400002)(199004)(189003)(54534003)(40764003)(386003)(71190400001)(53936002)(52116002)(71200400001)(4326008)(25786009)(6246003)(76176011)(39060400002)(6506007)(53546011)(11346002)(446003)(2616005)(36756003)(26005)(186003)(102836004)(2906002)(8676002)(81156014)(81166006)(476003)(7416002)(8936002)(7736002)(305945005)(86362001)(5660300001)(6116002)(2201001)(3846002)(6512007)(31696002)(316002)(99286004)(54906003)(110136005)(14454004)(6486002)(229853002)(6436002)(31686004)(105586002)(106356001)(93886005)(97736004)(66066001)(486006)(478600001)(256004)(14444005)(72206003)(2501003)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB2063;H:MWHPR11MB1248.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1GF7sg9tIqmTe8znbJ+s/V6LiXWU1lZbQtRzSh/o1eb8SsRiHGWbC5RbBIqzImYp2e1DH6BxZjhG1e5H2RubGAGaHwamUe8pQeahvLLZ7lollWEBhw07scYQlXhGlHzf5q3Pxt5GP02pCFwBwXvCDy5O2nHysTbYaV84lNlqvHxZWlN31kgdtxzN2i/pMDqyRlvUYQP5Oj2uJNoQ85/RkWpLSbsAmDG/HjJ9719TnDX08v5L6bj1czNz8kzpzW3WJi2pUe9Dr8OQYMk//reIhfZEZdiH2OL0HcIXTDpQS/VR2mQYxBImpmWKFFEJ2lgDPLb9k3Cu3a7HVhrKY9gGLDcE5qFnwQ3Nn1odZiaFdEYCDLJOwp8LIxE0eC/R1sXOv8E3PS6hNVuYL0X/mGHCPOswcv9dP23PHRs+TENW3QI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E20BD6510A8C04B92651200213C50E0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cc3a1f31-6d73-47a1-ebef-08d677aa1a27
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2019 09:49:39.2098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2063
X-OriginatorOrg: microchip.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

DQoNCk9uIDExLjAxLjIwMTkgMTA6MTEsIEx1aXMgZGUgT2xpdmVpcmEgd3JvdGU6DQo+IA0KPiAN
Cj4gT24gMTEtSmFuLTE5IDc6MjUsIEV1Z2VuLkhyaXN0ZXZAbWljcm9jaGlwLmNvbSB3cm90ZToN
Cj4+DQo+Pg0KPj4gT24gMTAuMDEuMjAxOSAxODoxOCwgTHVpcyBkZSBPbGl2ZWlyYSB3cm90ZToN
Cj4+Pg0KPj4+DQo+Pj4gT24gMDktSmFuLTE5IDEzOjA3LCBFdWdlbi5IcmlzdGV2QG1pY3JvY2hp
cC5jb20gd3JvdGU6DQo+Pj4+DQo+Pj4+DQo+Pj4+IE9uIDE5LjEwLjIwMTggMTU6NTIsIEx1aXMg
T2xpdmVpcmEgd3JvdGU6DQo+Pj4+PiBBZGQgdGhlIFN5bm9wc3lzIE1JUEkgQ1NJLTIgY29udHJv
bGxlciBkcml2ZXIuIFRoaXMNCj4+Pj4+IGNvbnRyb2xsZXIgZHJpdmVyIGlzIGRpdmlkZWQgaW4g
cGxhdGZvcm0gZGVwZW5kZW50IGZ1bmN0aW9ucw0KPj4+Pj4gYW5kIGNvcmUgZnVuY3Rpb25zLiBJ
dCBhbHNvIGluY2x1ZGVzIGEgcGxhdGZvcm0gZm9yIGZ1dHVyZQ0KPj4+Pj4gRGVzaWduV2FyZSBk
cml2ZXJzLg0KPj4+Pj4NCj4+Pj4+IFNpZ25lZC1vZmYtYnk6IEx1aXMgT2xpdmVpcmEgPGxvbGl2
ZWlAc3lub3BzeXMuY29tPg0KPj4+Pj4gLS0tDQo+Pj4+PiBDaGFuZ2Vsb2cNCj4+Pj4+IHYyLVYz
DQo+Pj4+PiAtIGV4cG9zZWQgSVBJIHNldHRpbmdzIHRvIHVzZXJzcGFjZQ0KPj4+Pj4gLSBmaXhl
ZCBoZWFkZXJzDQo+Pj4+Pg0KPj4+Pj4gICAgIE1BSU5UQUlORVJTICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgMTEgKw0KPj4+Pj4gICAgIGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vZHdj
L0tjb25maWcgICAgICAgfCAgMzAgKy0NCj4+Pj4+ICAgICBkcml2ZXJzL21lZGlhL3BsYXRmb3Jt
L2R3Yy9NYWtlZmlsZSAgICAgIHwgICAyICsNCj4+Pj4+ICAgICBkcml2ZXJzL21lZGlhL3BsYXRm
b3JtL2R3Yy9kdy1jc2ktcGxhdC5jIHwgNjk5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysNCj4+Pj4+ICAgICBkcml2ZXJzL21lZGlhL3BsYXRmb3JtL2R3Yy9kdy1jc2ktcGxhdC5oIHwg
IDc3ICsrKysNCj4+Pj4+ICAgICBkcml2ZXJzL21lZGlhL3BsYXRmb3JtL2R3Yy9kdy1taXBpLWNz
aS5jIHwgNDk0ICsrKysrKysrKysrKysrKysrKysrKysNCj4+Pj4+ICAgICBkcml2ZXJzL21lZGlh
L3BsYXRmb3JtL2R3Yy9kdy1taXBpLWNzaS5oIHwgMjAyICsrKysrKysrKw0KPj4+Pj4gICAgIGlu
Y2x1ZGUvbWVkaWEvZHdjL2R3LW1pcGktY3NpLXBsdGZybS5oICAgfCAxMDIgKysrKysNCj4+Pj4+
ICAgICA4IGZpbGVzIGNoYW5nZWQsIDE2MTYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0K
Pj4+Pj4gICAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21lZGlhL3BsYXRmb3JtL2R3Yy9k
dy1jc2ktcGxhdC5jDQo+Pj4+PiAgICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbWVkaWEv
cGxhdGZvcm0vZHdjL2R3LWNzaS1wbGF0LmgNCj4+Pj4+ICAgICBjcmVhdGUgbW9kZSAxMDA2NDQg
ZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9kd2MvZHctbWlwaS1jc2kuYw0KPj4+Pj4gICAgIGNyZWF0
ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21lZGlhL3BsYXRmb3JtL2R3Yy9kdy1taXBpLWNzaS5oDQo+
Pj4+PiAgICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGluY2x1ZGUvbWVkaWEvZHdjL2R3LW1pcGktY3Np
LXBsdGZybS5oDQo+Pj4+Pg0KPj4+Pg0KPj4+PiBbc25pcF0NCj4+Pj4NCj4+Pj4+ICsvKiBWaWRl
byBmb3JtYXRzIHN1cHBvcnRlZCBieSB0aGUgTUlQSSBDU0ktMiAqLw0KPj4+Pj4gK2NvbnN0IHN0
cnVjdCBtaXBpX2ZtdCBkd19taXBpX2NzaV9mb3JtYXRzW10gPSB7DQo+Pj4+PiArCXsNCj4+Pj4+
ICsJCS8qIFJBVyA4ICovDQo+Pj4+PiArCQkuY29kZSA9IE1FRElBX0JVU19GTVRfU0JHR1I4XzFY
OCwNCj4+Pj4+ICsJCS5kZXB0aCA9IDgsDQo+Pj4+PiArCX0sDQo+Pj4+PiArCXsNCj4+Pj4+ICsJ
CS8qIFJBVyAxMCAqLw0KPj4+Pj4gKwkJLmNvZGUgPSBNRURJQV9CVVNfRk1UX1NCR0dSMTBfMlg4
X1BBREhJX0JFLA0KPj4+Pj4gKwkJLmRlcHRoID0gMTAsDQo+Pj4+PiArCX0sDQo+Pj4+DQo+Pj4+
IEhpIEx1aXMsDQo+Pj4+DQo+Pj4+IEFueSByZWFzb24gd2h5IFJBVzEyIGZvcm1hdCBpcyBub3Qg
aGFuZGxlZCBoZXJlID8NCj4+Pj4NCj4+Pj4gSGVyZSwgbmFtZWx5IE1FRElBX0JVU19GTVRfU0JH
R1IxMl8xWDEyIGV0Yy4NCj4+Pj4NCj4+PiBIaSBFdWdlbiwNCj4+Pg0KPj4+IE15IEh3IHRlc3Rp
bmcgc2V0dXAgY3VycmVudGx5IGRvZXMgbm90IHN1cHBvcnQgaXQsIHNvIEkgZGlkbid0IGFkZCBp
dC4NCj4+Pg0KPj4+Pj4gKwl7DQo+Pj4+PiArCQkvKiBSR0IgNTY1ICovDQo+Pj4+PiArCQkuY29k
ZSA9IE1FRElBX0JVU19GTVRfUkdCNTY1XzJYOF9CRSwNCj4+Pj4+ICsJCS5kZXB0aCA9IDE2LA0K
Pj4+Pj4gKwl9LA0KPj4+Pj4gKwl7DQo+Pj4+PiArCQkvKiBCR1IgNTY1ICovDQo+Pj4+PiArCQku
Y29kZSA9IE1FRElBX0JVU19GTVRfUkdCNTY1XzJYOF9MRSwNCj4+Pj4+ICsJCS5kZXB0aCA9IDE2
LA0KPj4+Pj4gKwl9LA0KPj4+Pj4gKwl7DQo+Pj4+PiArCQkvKiBSR0IgODg4ICovDQo+Pj4+PiAr
CQkuY29kZSA9IE1FRElBX0JVU19GTVRfUkdCODg4XzJYMTJfTEUsDQo+Pj4+PiArCQkuZGVwdGgg
PSAyNCwNCj4+Pj4+ICsJfSwNCj4+Pj4+ICsJew0KPj4+Pj4gKwkJLyogQkdSIDg4OCAqLw0KPj4+
Pj4gKwkJLmNvZGUgPSBNRURJQV9CVVNfRk1UX1JHQjg4OF8yWDEyX0JFLA0KPj4+Pj4gKwkJLmRl
cHRoID0gMjQsDQo+Pj4+PiArCX0sDQo+Pj4+PiArfTsNCj4+Pj4NCj4+Pj4gW3NuaXBdDQo+Pj4+
DQo+Pj4+PiArDQo+Pj4+PiArdm9pZCBkd19taXBpX2NzaV9zZXRfaXBpX2ZtdChzdHJ1Y3QgbWlw
aV9jc2lfZGV2ICpjc2lfZGV2KQ0KPj4+Pj4gK3sNCj4+Pj4+ICsJc3RydWN0IGRldmljZSAqZGV2
ID0gY3NpX2Rldi0+ZGV2Ow0KPj4+Pj4gKw0KPj4+Pj4gKwlpZiAoY3NpX2Rldi0+aXBpX2R0KQ0K
Pj4+Pj4gKwkJZHdfbWlwaV9jc2lfd3JpdGUoY3NpX2RldiwgcmVnLklQSV9EQVRBX1RZUEUsIGNz
aV9kZXYtPmlwaV9kdCk7DQo+Pj4+PiArCWVsc2Ugew0KPj4+Pj4gKwkJc3dpdGNoIChjc2lfZGV2
LT5mbXQtPmNvZGUpIHsNCj4+Pj4+ICsJCWNhc2UgTUVESUFfQlVTX0ZNVF9SR0I1NjVfMlg4X0JF
Og0KPj4+Pj4gKwkJY2FzZSBNRURJQV9CVVNfRk1UX1JHQjU2NV8yWDhfTEU6DQo+Pj4+PiArCQkJ
ZHdfbWlwaV9jc2lfd3JpdGUoY3NpX2RldiwNCj4+Pj4+ICsJCQkJCXJlZy5JUElfREFUQV9UWVBF
LCBDU0lfMl9SR0I1NjUpOw0KPj4+Pj4gKwkJCWRldl9kYmcoZGV2LCAiRFQ6IFJHQiA1NjUiKTsN
Cj4+Pj4+ICsJCQlicmVhazsNCj4+Pj4+ICsNCj4+Pj4+ICsJCWNhc2UgTUVESUFfQlVTX0ZNVF9S
R0I4ODhfMlgxMl9MRToNCj4+Pj4+ICsJCWNhc2UgTUVESUFfQlVTX0ZNVF9SR0I4ODhfMlgxMl9C
RToNCj4+Pj4+ICsJCQlkd19taXBpX2NzaV93cml0ZShjc2lfZGV2LA0KPj4+Pj4gKwkJCQkJcmVn
LklQSV9EQVRBX1RZUEUsIENTSV8yX1JHQjg4OCk7DQo+Pj4+PiArCQkJZGV2X2RiZyhkZXYsICJE
VDogUkdCIDg4OCIpOw0KPj4+Pj4gKwkJCWJyZWFrOw0KPj4+Pj4gKwkJY2FzZSBNRURJQV9CVVNf
Rk1UX1NCR0dSMTBfMlg4X1BBREhJX0JFOg0KPj4+Pj4gKwkJCWR3X21pcGlfY3NpX3dyaXRlKGNz
aV9kZXYsDQo+Pj4+PiArCQkJCQlyZWcuSVBJX0RBVEFfVFlQRSwgQ1NJXzJfUkFXMTApOw0KPj4+
Pj4gKwkJCWRldl9kYmcoZGV2LCAiRFQ6IFJBVyAxMCIpOw0KPj4+Pj4gKwkJCWJyZWFrOw0KPj4+
Pj4gKwkJY2FzZSBNRURJQV9CVVNfRk1UX1NCR0dSOF8xWDg6DQo+Pj4+PiArCQkJZHdfbWlwaV9j
c2lfd3JpdGUoY3NpX2RldiwNCj4+Pj4+ICsJCQkJCXJlZy5JUElfREFUQV9UWVBFLCBDU0lfMl9S
QVc4KTsNCj4+Pj4+ICsJCQlkZXZfZGJnKGRldiwgIkRUOiBSQVcgOCIpOw0KPj4+Pj4gKwkJCWJy
ZWFrOw0KPj4+Pg0KPj4+PiBTYW1lIGhlcmUsIGluIENTSV8yX1JBVzEyIGNhc2UgaXQgd2lsbCBk
ZWZhdWx0IHRvIGEgUkdCNTY1IGNhc2UuDQo+Pj4+DQo+Pj4+IFRoYW5rcywNCj4+Pj4NCj4+Pj4g
RXVnZW4NCj4+Pj4NCj4+Pj4NCj4+PiBJIHdpbGwgdHJ5IHRvIGFkZCB0aGUgc3VwcG9ydCBmb3Ig
dGhpcyBkYXRhIHR5cGUgaW4gbXkgbmV4dCBwYXRjaHNldCBpZiBub3QgSQ0KPj4+IHdpbGwgZmxh
ZyBpdCBhcyB1bnN1cHBvcnRlZCBmb3Igbm93IGluIHRoZSBjb21taXQgbWVzc2FnZSBhbmQgY29k
ZS4NCj4+DQo+PiBIaSBMdWlzLA0KPj4NCj4+IEkgYW0gY3VycmVudGx5IHRyeWluZyB0byBzZWUg
aWYgeW91ciBkcml2ZXIgd29ya3MgLCBhbmQgSSBuZWVkIHRoZSBSQVcxMg0KPj4gdHlwZSwgdGhh
dCdzIHdoeSBJIGFtIGFza2luZyBhYm91dCBpdC4NCj4+DQo+PiBPbmUgcXVlc3Rpb24gcmVsYXRl
ZCB0byB0aGUgc3ViZGV2aWNlIHlvdSBjcmVhdGUgaGVyZSwgaG93IGRvIHlvdQ0KPj4gcmVnaXN0
ZXIgdGhpcyBzdWJkZXYgaW50byB0aGUgbWVkaWEgc3Vic3lzdGVtID8gc3luYyBvciBhc3luYywg
b3Igbm90IGF0DQo+PiBhbGwgPw0KPj4gQWZ0ZXIgdGhlIGRyaXZlciBwcm9iZXMsIHRoZXJlIGlz
IG5vIGNhbGwgdG8gdGhlIHNldCBmb3JtYXQgZnVuY3Rpb25zLCBJDQo+PiBhZGRlZCBhIG5vZGUg
aW5zaWRlIHRoZSBEZXZpY2UgdHJlZSwgSSBzZWUgeW91IGFyZSByZWdpc3RlcmluZyBtZWRpYQ0K
Pj4gcGFkcywgYnV0IHRoZSBvdGhlciBlbmRwb2ludCBuZWVkcyB0byBiZSBhbiBhc3luYyB3YWl0
aW5nIGZvciBjb21wbGV0aW9uDQo+PiBub2RlIG9yIHlvdXIgc3ViZGV2IHJlZ2lzdGVycyBpbiBz
b21lIG90aGVyIHdheSA/IChtYXliZSBzb21lIGxpbmsNCj4+IHZhbGlkYXRpb24gcmVxdWlyZWQg
PykNCj4+DQo+PiBUaGFua3MgZm9yIHlvdXIgaGVscCwNCj4+DQo+PiBFdWdlbg0KPj4NCj4gSGkg
RXVnZW4sDQo+IA0KPiBPbiB0b3Agb2YgdGhpcyBkcGh5K2NvbnRyb2xsZXIgc29sdXRpb24gSSB1
c2UgYSB3cmFwcGVyIGRyaXZlciB0aGF0IGJpbmRzIHRoaXMNCj4gdHdvIHRvZ2V0aGVyIGFuZCBj
cmVhdGUgdGhlIGxpbmtzLg0KPiBJIHVzZSBWNEwyX0FTWU5DX01BVENIX0ZXTk9ERSBhbmQgdjRs
Ml9hc3luY19ub3RpZmllcl9vcGVyYXRpb25zIHRvIG1hdGNoIGFuZA0KPiBib3VuZCBhbGwgbXkg
c2Vuc29ycyB1bnRpbCBjb21wbGV0aW9uLg0KPiANCj4gTXkgZHQgbG9va3MgbGlrZSB0aGlzOg0K
PiANCj4gY2FtZXJhIHdyYXBwZXIgew0KPiAgIAkNCj4gCXZpZGVvX2RldiB7DQo+IAkJZG1hDQo+
IAl9DQo+IAl2aWZfMSBAcmVnIHsNCj4gCQkuLi4NCj4gCX0NCj4gCS4uDQo+IAl2aWZfbiBAcmVn
IHsNCj4gCQkuLi4NCj4gCX0NCj4gCWNzaV8xIEByZWcgew0KPiAJCS4uLg0KPiAJCXBoeQ0KPiAJ
CXBvcnQgMS4uMiB7fQ0KPiAJfQ0KPiAJY3NpX24gQHJlZyB7DQo+IAkJLi4uDQo+IAkJcGh5DQo+
IAkJcG9ydCAxLi4yIHt9DQo+IAl9DQo+IA0KPiBGdW5kYW1lbnRhbGx5IEl0IGlzIHRoZSBzYW1l
IHByaW5jaXBsZSBhcyB0aGlzDQo+IGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vZXh5bm9zNC1pcy9t
ZWRpYS1kZXYuYyBidXQgbXkgc29sdXRpb24gaGFzIG1vcmUgZW50aXRpZXMNCj4gZm9yIHRlc3Rp
bmcgcHVycG9zZXMuDQo+IENoZWNrIHRoZSBleHlub3M0LWlzIGJlY2F1c2UgaXMgdmVyeSBzaW1p
bGFyIHRvIG15IHRvcCBzb2x1dGlvbi4NCj4gDQo+IFdoZW4gSSBzdGFydGVkIGRvaW5nIHRoaXMg
cGF0Y2hzZXQgSSB3YXMgdGhpbmtpbmcgb2Ygc2VuZGluZyB0aGUgd3JhcHBlciBhbHNvDQo+IGJ1
dCBJIHRoZW4gZGVjaWRlZCB0byBub3QgZG8gaXQgYmVjYXVzZSBpdCBpcyB2ZXJ5IG5hcnJvdyBh
bmQgZm9jdXNlZCBpbiBteQ0KPiB0ZXN0cy4gQnV0IEkgY2FuIGluY2x1ZGUgaXQgaW4gdjQgaWYg
ZXZlcnlvbmUgdGhpbmsgaXRzIGJlc3QuDQoNCk9rLCBJIHVuZGVyc3RhbmQgaG93IHlvdSBkaWQs
IGJ1dCBkbyB5b3UgaGF2ZSBhIHB1YmxpYyB0cmVlIHdpdGggdGhpcyANCmNvZGUgd2hpY2ggSSBj
YW4gYWNjZXNzIHRvIGhhdmUgYSBsb29rIG9uIGV4YWN0bHkgaG93IHlvdSBjb25uZWN0ZWQgDQpl
dmVyeXRoaW5nID8NCg0KVGhhbmtzDQoNCg0KPiANCj4gVGhhbmsgeW91LA0KPiBMdWlzDQo+Pj4N
Cj4+PiBUaGFua3MgZm9yIHlvdXIgcmV2aWV3LA0KPj4+IEx1aXMNCj4+Pg0KPj4+Pg0KPj4+Pj4g
KwkJZGVmYXVsdDoNCj4+Pj4+ICsJCQlkd19taXBpX2NzaV93cml0ZShjc2lfZGV2LA0KPj4+Pj4g
KwkJCQkJcmVnLklQSV9EQVRBX1RZUEUsIENTSV8yX1JHQjU2NSk7DQo+Pj4+PiArCQkJZGV2X2Ri
ZyhkZXYsICJFcnJvciIpOw0KPj4+Pj4gKwkJCWJyZWFrOw0KPj4+Pj4gKwkJfQ0KPj4+Pj4gKwl9
DQo+Pj4+PiArfQ0KPj4+Pj4gKw0KPj4+Pg0KPj4+PiBbc25pcF0NCj4+Pj4NCj4+Pg0KPiANCg==
