Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C050C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 15:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E98A220836
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 15:29:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="F8TYRxe1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387642AbfAKP3I (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 10:29:08 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:13733 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731130AbfAKP3I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 10:29:08 -0500
X-IronPort-AV: E=Sophos;i="5.56,466,1539673200"; 
   d="scan'208";a="26284293"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 11 Jan 2019 08:29:06 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 11 Jan 2019 08:29:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cNz9+qnPZAXBL4RE91xiKkTtaITFIW5v4w3fHc4mbPg=;
 b=F8TYRxe1v6dEFwVHM+sr3rrNXCE7tyjpmKpirCVk/cjOEYCztMdq04W//gB8LWyw+MiLbSpwhRdqyJv2dBo3Hqsj9GRGE5z6FNJMtIy54hOITw0jnXLFL1dH+T+TotjEpDEOb8pnymm+bHl/grxPrhVnwgk/y5JDCaJRRiZsdls=
Received: from DM5PR11MB1242.namprd11.prod.outlook.com (10.168.108.8) by
 DM5PR11MB1898.namprd11.prod.outlook.com (10.175.87.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.18; Fri, 11 Jan 2019 15:29:04 +0000
Received: from DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::4c19:f788:c2be:5e8f]) by DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::4c19:f788:c2be:5e8f%4]) with mapi id 15.20.1516.016; Fri, 11 Jan 2019
 15:29:03 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <luis.oliveira@synopsys.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <joao.pinto@synopsys.com>, <festevam@gmail.com>,
        <mchehab@kernel.org>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <hans.verkuil@cisco.com>,
        <laurent.pinchart+renesas@ideasonboard.com>, <arnd@arndb.de>,
        <geert+renesas@glider.be>, <narmstrong@baylibre.com>,
        <p.zabel@pengutronix.de>, <keiichiw@chromium.org>,
        <kstewart@linuxfoundation.org>, <todor.tomov@linaro.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [V3, 3/4] Documentation: dt-bindings: media: Document bindings
 for DW MIPI CSI-2 Host
Thread-Topic: [V3, 3/4] Documentation: dt-bindings: media: Document bindings
 for DW MIPI CSI-2 Host
Thread-Index: AQHUqcHK4J+uFLFChk6N6mXR3EvcBw==
Date:   Fri, 11 Jan 2019 15:29:03 +0000
Message-ID: <a967f37a-07cb-4b0b-1777-f354427445ea@microchip.com>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
 <1539953556-35762-4-git-send-email-lolivei@synopsys.com>
In-Reply-To: <1539953556-35762-4-git-send-email-lolivei@synopsys.com>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR08CA0210.eurprd08.prod.outlook.com
 (2603:10a6:802:15::19) To DM5PR11MB1242.namprd11.prod.outlook.com
 (2603:10b6:3:14::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR11MB1898;6:c7Z1ia/pQ+j7xhey4D9jebBr4vUzurtZBcbDwZa9QcLZzIQ1LfcwTEFCz3woSsNC6ekJ+qZfEL4qMJQONkpkyo1LYxDrO3vOCvUa3i/8SyZuQjw0MLfMk1l9IbzE70qrJg07NU9uggHd54EXx0nagwchnZUImL16RI9s3sHyMTYVTIs7H8xZeSLe1cg9d93bsl+/oBQPX7uP4/+8QKWhs+QlTRvA+1ymMFdiVlRNxYb9Gryvt0OjJBCS0p0cszRWeO4oDZ3uVi1sWDKNIZBfshHXcsLO5ziTjJxUhp92KDddecJvgNZJN7ppqUilFbI+mV1OxntOrtiZyUkm5Nmof5q5S0Hgjh98lqN4Hc94Z5BhvmHkbvuUFaHrT6jJoc/hU5gAScs58iuNj/AL+AbrgEhXgSkW/mU1twlteSX60FnEg35Xd/bXu1oMzVmAfSvO6jU7H5fp38Qv1myv4+wgrA==;5:17obCliWw0eeLq2eFXq485j0mv4uNgyweuEY/vlrLJ/j+pEe0crO5QtSSeHs+bQmSYNrxyzbyIXW14jE3CYr3Rad9/zyIFUDMVCosdIHYpNuk6UQTh0NeyQefqWhGOy8H12H1Hh+kWx1RxuBk1Nl26fvsdfhu60EZzmf/V2aaTf/kAOR1J+jxe/M2Qs3wB3l5awPLn8WPSqLmDQUGUGSwQ==;7:yQ/WPFjjHAgtGx+voOy39sPG12mmu5vP/FVc3WdtCVu1xcqzitmhY8ZHi3Pgp8xetbfCAwWLH7Bsdvrzq7sAeOKg5bdngsbhWsKe6hG3eAgXoDr/gTRUFu9FwAEUUaoqvlnoFEcB1P2+Ab4BqiNq6A==
x-ms-office365-filtering-correlation-id: 4ad5b8ca-444a-405b-5a9b-08d677d98487
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:DM5PR11MB1898;
x-ms-traffictypediagnostic: DM5PR11MB1898:
x-microsoft-antispam-prvs: <DM5PR11MB189883A98A936919A78A9126E8850@DM5PR11MB1898.namprd11.prod.outlook.com>
x-forefront-prvs: 09144DB0F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(396003)(346002)(39860400002)(54534003)(189003)(199004)(76176011)(102836004)(110136005)(8676002)(305945005)(53546011)(54906003)(26005)(6506007)(81166006)(316002)(8936002)(81156014)(31696002)(7416002)(5660300001)(25786009)(106356001)(386003)(105586002)(99286004)(52116002)(7736002)(11346002)(446003)(476003)(2616005)(186003)(39060400002)(4326008)(53936002)(6246003)(6116002)(3846002)(486006)(2201001)(86362001)(71190400001)(71200400001)(256004)(2906002)(2501003)(6486002)(6512007)(6436002)(66066001)(68736007)(97736004)(31686004)(229853002)(72206003)(478600001)(36756003)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1898;H:DM5PR11MB1242.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JaQymgJxsUc5jZXO2hh3jSrS6CTHLRZN3npK1MXWB1+MzIBv4UFIYVp5uAeBjKq08W89fNl7YAbCzqqC8bv//Zyk2ebJAbk8M/Nb6PZlGszfQGe0OUeXo9M1e3KdYBvu8gEueDG3SSq0o4BF3PiIp24C5B95ilq6EKfuuh6It/v1+49lK+av+38P8VsNzGBCNADCfs9tHimKiZxOE6BWtDrZvwnExPlepEwzT4j1cbSCfpjlcC2cjHuFf0GiPSlkcAX7PLqtklf8ctYEBmDJpCM1fpC+VsiLE9ZAabjZMMAEruZZjXsmzyHoqCpecD1sngcl+lWJmdiN3pJiLSxNZDHO1E0wFjz5NeCmgjBZFdvq6yTpdhVz4Qs25wtWTy1KFmMTbY0mLZhcCSUdb14NqQKH+C65yOM04Z1k2lXUsnw=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3E7EB16CA57C944A93487FDAA009FF8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad5b8ca-444a-405b-5a9b-08d677d98487
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2019 15:29:03.8538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1898
X-OriginatorOrg: microchip.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

DQoNCk9uIDE5LjEwLjIwMTggMTU6NTIsIEx1aXMgT2xpdmVpcmEgd3JvdGU6DQo+IEFkZCBiaW5k
aW5ncyBmb3IgU3lub3BzeXMgRGVzaWduV2FyZSBNSVBJIENTSS0yIGhvc3QuDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBMdWlzIE9saXZlaXJhIDxsb2xpdmVpQHN5bm9wc3lzLmNvbT4NCj4gLS0tDQo+
IENoYW5nZWxvZw0KPiB2Mi1WMw0KPiAtIHJlbW92ZWQgSVBJIHNldHRpbmdzDQo+IA0KPiAgIC4u
Li9kZXZpY2V0cmVlL2JpbmRpbmdzL21lZGlhL3NucHMsZHctY3NpLXBsYXQudHh0IHwgNTIgKysr
KysrKysrKysrKysrKysrKysrKw0KPiAgIDEgZmlsZSBjaGFuZ2VkLCA1MiBpbnNlcnRpb25zKCsp
DQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9tZWRpYS9zbnBzLGR3LWNzaS1wbGF0LnR4dA0KPiANCj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50
YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9tZWRpYS9zbnBzLGR3LWNzaS1wbGF0LnR4dCBiL0Rv
Y3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9tZWRpYS9zbnBzLGR3LWNzaS1wbGF0LnR4
dA0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwLi5iZTNkYTA1DQo+IC0t
LSAvZGV2L251bGwNCj4gKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21l
ZGlhL3NucHMsZHctY3NpLXBsYXQudHh0DQo+IEBAIC0wLDAgKzEsNTIgQEANCj4gK1N5bm9wc3lz
IERlc2lnbldhcmUgQ1NJLTIgSG9zdCBjb250cm9sbGVyDQo+ICsNCj4gK0Rlc2NyaXB0aW9uDQo+
ICstLS0tLS0tLS0tLQ0KPiArDQo+ICtUaGlzIEhXIGJsb2NrIGlzIHVzZWQgdG8gcmVjZWl2ZSBp
bWFnZSBjb21pbmcgZnJvbSBhbiBNSVBJIENTSS0yIGNvbXBhdGlibGUNCj4gK2NhbWVyYS4NCj4g
Kw0KPiArUmVxdWlyZWQgcHJvcGVydGllczoNCj4gKy0gY29tcGF0aWJsZTogc2hhbGwgYmUgInNu
cHMsZHctY3NpLXBsYXQiDQo+ICstIHJlZwkJCTogcGh5c2ljYWwgYmFzZSBhZGRyZXNzIGFuZCBz
aXplIG9mIHRoZSBkZXZpY2UgbWVtb3J5IG1hcHBlZA0KPiArICByZWdpc3RlcnM7DQo+ICstIGlu
dGVycnVwdHMJCTogQ1NJLTIgSG9zdCBpbnRlcnJ1cHQNCj4gKy0gc25wcyxvdXRwdXQtdHlwZQk6
IENvcmUgb3V0cHV0IHRvIGJlIHVzZWQgKElQSS0+IDAgb3IgSURJLT4xIG9yIEJPVEgtPjIpDQo+
ICsJCQkgIFRoZXNlICB2YWx1ZXMgY2hvb3NlIHdoaWNoIG9mIHRoZSBDb3JlIG91dHB1dHMgd2ls
bCBiZSB1c2VkLA0KPiArCQkJICBpdCBjYW4gYmUgSW1hZ2UgRGF0YSBJbnRlcmZhY2Ugb3IgSW1h
Z2UgUGl4ZWwgSW50ZXJmYWNlLg0KPiArLSBwaHlzCQkJOiBMaXN0IG9mIG9uZSBQSFkgc3BlY2lm
aWVyIChhcyBkZWZpbmVkIGluDQo+ICsJCQkgIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5k
aW5ncy9waHkvcGh5LWJpbmRpbmdzLnR4dCkuDQo+ICsJCQkgIFRoaXMgUEhZIGlzIGEgTUlQSSBE
UEhZIHdvcmtpbmcgaW4gUlggbW9kZS4NCj4gKy0gcmVzZXRzCQk6IFJlZmVyZW5jZSB0byBhIHJl
c2V0IGNvbnRyb2xsZXIgKG9wdGlvbmFsKQ0KPiArDQo+ICtUaGUgcGVyLWJvYXJkIHNldHRpbmdz
Og0KPiArIC0gcG9ydCBzdWItbm9kZSBkZXNjcmliaW5nIGEgc2luZ2xlIGVuZHBvaW50IGNvbm5l
Y3RlZCB0byB0aGUgY2FtZXJhIGFzDQo+ICsgICBkZXNjcmliZWQgaW4gdmlkZW8taW50ZXJmYWNl
cy50eHRbMV0uDQo+ICsNCj4gK0V4YW1wbGU6DQo+ICsNCj4gKwljc2kyXzE6IGNzaTJAMzAwMCB7
DQo+ICsJCWNvbXBhdGlibGUgPSAic25wcyxkdy1jc2ktcGxhdCI7DQo+ICsJCSNhZGRyZXNzLWNl
bGxzID0gPDE+Ow0KPiArCQkjc2l6ZS1jZWxscyA9IDwwPjsNCj4gKwkJcmVnID0gPCAweDAzMDAw
IDB4N0ZGPjsNCj4gKwkJaW50ZXJydXB0cyA9IDwyPjsNCj4gKwkJb3V0cHV0LXR5cGUgPSA8Mj47
DQo+ICsJCXJlc2V0cyA9IDwmZHdfcnN0IDE+Ow0KPiArCQlwaHlzID0gPCZtaXBpX2RwaHlfcngx
IDA+Ow0KPiArCQlwaHktbmFtZXMgPSAiY3NpMi1kcGh5IjsNCj4gKw0KPiArCQkvKiBDU0ktMiBw
ZXItYm9hcmQgc2V0dGluZ3MgKi8NCj4gKwkJcG9ydEAxIHsNCj4gKwkJCXJlZyA9IDwxPjsNCj4g
KwkJCWNzaTFfZXAxOiBlbmRwb2ludCB7DQo+ICsJCQkJcmVtb3RlLWVuZHBvaW50ID0gPCZjYW1l
cmFfMT47DQo+ICsJCQkJZGF0YS1sYW5lcyA9IDwxIDI+Ow0KPiArCQkJfTsNCj4gKwkJfTsNCj4g
KwkJcG9ydEAyIHsNCj4gKwkJCWNzaTFfZXAyOiBlbmRwb2ludCB7DQo+ICsJCQkJcmVtb3RlLWVu
ZHBvaW50ID0gPCZ2aWYxX2VwPjsNCg0KSGkgYWdhaW4gTHVpcywNCg0KUmVnYXJkaW5nIHRoZSBv
dXRwdXQgZW5kcG9pbnQsIGluIHlvdXIgZXhhbXBsZSBwb3J0QDIsIGlmIHdlIHVzZSB0aGUgDQpw
cm9wZXJ0eSBzbnBzLG91dHB1dC10eXBlPTIgZm9yIGV4YW1wbGUsIHNvIElESSBvdXRwdXQsIHdo
aWNoIGJ1cy10eXBlIA0KeW91IGhhdmUgaW4gbWluZCBmb3IgdGhpcyBsaW5rPyBJREkgaXMgbm90
IGRvY3VtZW50ZWQgaW4gdGhlIA0KdmlkZW8taW50ZXJmYWNlcy50eHQgYmluZGluZy4NCg0KU2lu
Y2UgdGhlIE1JUEkgQ1NJLTIgRFBIWSBpcyBhY3R1YWxseSBiZXR3ZWVuIGNhbWVyYSBzZW5zb3Ig
YW5kIA0KY3NpMmhvc3QsIGFmdGVyIHRoaXMgd2UgY2FuIHVzZSBlaXRoZXIgSURJIG9yIElQSSBp
ZiBteSB1bmRlcnN0YW5kaW5nIGlzIA0KY29ycmVjdCwgYW5kIGNvbm5lY3QgdG8gYSBkaWZmZXJl
bnQgcGFkL2h3IGJsb2NrIHdoaWNoIGNhbiBmdXJ0aGVyIA0KaGFuZGxlIHRoZXNlIHBhY2tldHMv
cGl4ZWxzLg0KDQpJIGFtIGludGVyZXN0ZWQgb24gaG93IHRvIHNwZWNpZnkgdGhlIGNvbm5lY3Rp
b24gdHlwZSBiZXR3ZWVuIHRoaXMgDQpvdXRwdXQgcGFkIGFuZCB0aGUgbmV4dCBvbmUgKHVudGls
IGEgL2Rldi92aWRlbyBjYW4gYmUgcmVnaXN0ZXJlZCBieSB0aGUgDQpsYXN0IGRyaXZlciBmb3Ig
dGhlIGxhc3QgaHcgYmxvY2spLg0KDQpUaGFua3MsDQoNCkV1Z2VuDQoNCj4gKwkJCX07DQo+ICsJ
CX07DQo+ICsJfTsNCj4gLS0NCj4gMi43LjQNCj4gDQo+IA0K
