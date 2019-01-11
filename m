Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA99C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 07:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EB2620872
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 07:25:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="S1b3lOK1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbfAKHZb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 02:25:31 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:30296 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730667AbfAKHZb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 02:25:31 -0500
X-IronPort-AV: E=Sophos;i="5.56,464,1539673200"; 
   d="scan'208";a="25358629"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 11 Jan 2019 00:25:29 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 11 Jan 2019 00:25:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akCWEhmZfDkKOuM8S8pymathlQxEVoK5fLlHbAQwr90=;
 b=S1b3lOK1a5vkykIF1oDVtoWkKVftLUxmbAzmJoBAJqMIIoC6M7NIHttA79XM0ePSnerUVgZPt+FnFz6Mrn2X6n59o4p3QANXuJgjmJ4Hefe1fNvkh7ciIAHvBobSkng+vqM4j0IkK7vhkbTHfh4imkXQV+qLgjFVhar3SaQWXGg=
Received: from MWHPR11MB1248.namprd11.prod.outlook.com (10.169.236.145) by
 MWHPR11MB1309.namprd11.prod.outlook.com (10.169.237.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.14; Fri, 11 Jan 2019 07:25:25 +0000
Received: from MWHPR11MB1248.namprd11.prod.outlook.com
 ([fe80::c14e:91dd:ffb7:5c1d]) by MWHPR11MB1248.namprd11.prod.outlook.com
 ([fe80::c14e:91dd:ffb7:5c1d%9]) with mapi id 15.20.1516.015; Fri, 11 Jan 2019
 07:25:25 +0000
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
Thread-Index: AQHUqBuhCcv9szjWl0qFFgx76hUWpKWosBEAgAD8KwA=
Date:   Fri, 11 Jan 2019 07:25:25 +0000
Message-ID: <24f6a1fe-4790-91ba-ce21-72397c0a02df@microchip.com>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
 <1539953556-35762-5-git-send-email-lolivei@synopsys.com>
 <4db76eb2-460f-c644-6dbd-370b07b2def8@microchip.com>
 <2407a3ca-1a83-5685-c26c-a922251b2943@synopsys.com>
In-Reply-To: <2407a3ca-1a83-5685-c26c-a922251b2943@synopsys.com>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR08CA0245.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::18) To MWHPR11MB1248.namprd11.prod.outlook.com
 (2603:10b6:300:29::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHPR11MB1309;6:1FTixN49vZtoWxFnP/JiVLSCnWKhMfw7/RROcZQfZqth8QpsJ449/KvzUqx24ansDDH1QCjLQ+fCgpo0gf0ORitr09TUNrTqkN88H6Xvxi6CxynFHKsAR3WVIPe/+YlqOUfOH7tnqC0LQi869CW+s1yHFV49GyA2WySUuZse6n0b7iQCRO3+LbrUdyFjZeZhGhHT3CzZ/yPKsIieFq9loR/I4t1qqIY0HNtWqeFUnwfzh0fjArIDyhnUGD285YlxXqSGduODEoNvWBbW+Dm0O75To/7i87NFpwlbXjYs5rVrA5El0ixxtjDvLnUJiUuHdg8lupxKLfh2OTAywze5Il+XJjrCey5v4wOAVtaJPARowLgjudrHmWlgKZiFjz1uiT0evAeVhKqEl8a2gI6QYBLaQndrmtdzytZhgLPecWlXkYAcW0jJpKG35D8BozLZOCjkprwPaY9Bsh3ElizfYw==;5:Mbvhg6AHvPLNTh04WC2USdKyJsYJFfD4GS/uFH1Wr+rSqh//R//JRAa+lvCqeedtDEd/cHkKuUNtGqyL6gx4pnMMXyq9Oti/PMmA/wo+ZzY+a+0lVgFkzPXtY0+/eAbwwHyRrRN+sRF7EFho7Yh/eA0jYa6+jvCVdka8ycPYKCkxYp6OxkH5TDl5yn5zw2hwZgaxR1ezCmTqk0WbzRNkpQ==;7:PON2ConJFh7z0OP295p3BwnuIHl9EFhPmRsSCXDPYO7x2E8FIyKESe1tSkLo/eQJmg0kDWNPo09fq7uX93RCjLonKerUxF2ixcs2L2I4HjJQJ9B3kG6kiOh07PmWeEhpuYmw32uzNJU6YyFhYgcugQ==
x-ms-office365-filtering-correlation-id: 06fa77f9-2f9a-443e-d8b9-08d67795f436
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHPR11MB1309;
x-ms-traffictypediagnostic: MWHPR11MB1309:
x-microsoft-antispam-prvs: <MWHPR11MB13092A76CA866C1634ECFFC7E8850@MWHPR11MB1309.namprd11.prod.outlook.com>
x-forefront-prvs: 09144DB0F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(54534003)(199004)(189003)(40764003)(39060400002)(93886005)(4326008)(99286004)(26005)(6506007)(386003)(53546011)(7736002)(305945005)(8936002)(6246003)(36756003)(106356001)(53936002)(2201001)(2616005)(25786009)(97736004)(11346002)(476003)(86362001)(446003)(6512007)(6116002)(3846002)(186003)(8676002)(81166006)(102836004)(81156014)(52116002)(2501003)(76176011)(5660300001)(7416002)(14454004)(72206003)(256004)(486006)(316002)(6436002)(31696002)(66066001)(54906003)(110136005)(14444005)(6486002)(105586002)(68736007)(71190400001)(71200400001)(31686004)(478600001)(2906002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1309;H:MWHPR11MB1248.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Irxzr0jZncm5Ss/AbnmAQN+xSpe9jUbvrYa4FGdpXEK/AZF0yXCNhP+hllF1zuRtcMpypkG9MHTL0SmoHC0IbHPZfT+HUz8LLP1rrNOJg7tvI7mTPZRt+y/RdBqAKFG/GnXhrqOM1t/rS8OwNHaz1Pv9J5JrN+aWO5//wH854QpPxdWFKQCmDcyv6uAJTVXSdVRg7WtYCfl/ZnOD5fMVWXncZ6WKwv/Trzb2e/Mjdly4QUJV5ZrWCrcYFU8BzoexHSR/LoCqRVVoAghrZolzgjqjNOTFfYjZ7e7+57tj6WJ/KMPljeBmuzfsXGhB4jZgSaezfFcpfUGejFz3WqKkoi63VutNNz/QLtmMBu5Ywm56nhclTj62d+baqhSiO55UDaxVDL4iDAxg3w+IpWhu8WefdJw8gHWUqvBjb+Y1T7w=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FB4AD518DC7024B8E6445F77228AEFA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 06fa77f9-2f9a-443e-d8b9-08d67795f436
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2019 07:25:25.5414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1309
X-OriginatorOrg: microchip.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

DQoNCk9uIDEwLjAxLjIwMTkgMTg6MTgsIEx1aXMgZGUgT2xpdmVpcmEgd3JvdGU6DQo+IA0KPiAN
Cj4gT24gMDktSmFuLTE5IDEzOjA3LCBFdWdlbi5IcmlzdGV2QG1pY3JvY2hpcC5jb20gd3JvdGU6
DQo+Pg0KPj4NCj4+IE9uIDE5LjEwLjIwMTggMTU6NTIsIEx1aXMgT2xpdmVpcmEgd3JvdGU6DQo+
Pj4gQWRkIHRoZSBTeW5vcHN5cyBNSVBJIENTSS0yIGNvbnRyb2xsZXIgZHJpdmVyLiBUaGlzDQo+
Pj4gY29udHJvbGxlciBkcml2ZXIgaXMgZGl2aWRlZCBpbiBwbGF0Zm9ybSBkZXBlbmRlbnQgZnVu
Y3Rpb25zDQo+Pj4gYW5kIGNvcmUgZnVuY3Rpb25zLiBJdCBhbHNvIGluY2x1ZGVzIGEgcGxhdGZv
cm0gZm9yIGZ1dHVyZQ0KPj4+IERlc2lnbldhcmUgZHJpdmVycy4NCj4+Pg0KPj4+IFNpZ25lZC1v
ZmYtYnk6IEx1aXMgT2xpdmVpcmEgPGxvbGl2ZWlAc3lub3BzeXMuY29tPg0KPj4+IC0tLQ0KPj4+
IENoYW5nZWxvZw0KPj4+IHYyLVYzDQo+Pj4gLSBleHBvc2VkIElQSSBzZXR0aW5ncyB0byB1c2Vy
c3BhY2UNCj4+PiAtIGZpeGVkIGhlYWRlcnMNCj4+Pg0KPj4+ICAgIE1BSU5UQUlORVJTICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfCAgMTEgKw0KPj4+ICAgIGRyaXZlcnMvbWVkaWEvcGxh
dGZvcm0vZHdjL0tjb25maWcgICAgICAgfCAgMzAgKy0NCj4+PiAgICBkcml2ZXJzL21lZGlhL3Bs
YXRmb3JtL2R3Yy9NYWtlZmlsZSAgICAgIHwgICAyICsNCj4+PiAgICBkcml2ZXJzL21lZGlhL3Bs
YXRmb3JtL2R3Yy9kdy1jc2ktcGxhdC5jIHwgNjk5ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysNCj4+PiAgICBkcml2ZXJzL21lZGlhL3BsYXRmb3JtL2R3Yy9kdy1jc2ktcGxhdC5oIHwg
IDc3ICsrKysNCj4+PiAgICBkcml2ZXJzL21lZGlhL3BsYXRmb3JtL2R3Yy9kdy1taXBpLWNzaS5j
IHwgNDk0ICsrKysrKysrKysrKysrKysrKysrKysNCj4+PiAgICBkcml2ZXJzL21lZGlhL3BsYXRm
b3JtL2R3Yy9kdy1taXBpLWNzaS5oIHwgMjAyICsrKysrKysrKw0KPj4+ICAgIGluY2x1ZGUvbWVk
aWEvZHdjL2R3LW1pcGktY3NpLXBsdGZybS5oICAgfCAxMDIgKysrKysNCj4+PiAgICA4IGZpbGVz
IGNoYW5nZWQsIDE2MTYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4+ICAgIGNyZWF0
ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21lZGlhL3BsYXRmb3JtL2R3Yy9kdy1jc2ktcGxhdC5jDQo+
Pj4gICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vZHdjL2R3LWNz
aS1wbGF0LmgNCj4+PiAgICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9tZWRpYS9wbGF0Zm9y
bS9kd2MvZHctbWlwaS1jc2kuYw0KPj4+ICAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21l
ZGlhL3BsYXRmb3JtL2R3Yy9kdy1taXBpLWNzaS5oDQo+Pj4gICAgY3JlYXRlIG1vZGUgMTAwNjQ0
IGluY2x1ZGUvbWVkaWEvZHdjL2R3LW1pcGktY3NpLXBsdGZybS5oDQo+Pj4NCj4+DQo+PiBbc25p
cF0NCj4+DQo+Pj4gKy8qIFZpZGVvIGZvcm1hdHMgc3VwcG9ydGVkIGJ5IHRoZSBNSVBJIENTSS0y
ICovDQo+Pj4gK2NvbnN0IHN0cnVjdCBtaXBpX2ZtdCBkd19taXBpX2NzaV9mb3JtYXRzW10gPSB7
DQo+Pj4gKwl7DQo+Pj4gKwkJLyogUkFXIDggKi8NCj4+PiArCQkuY29kZSA9IE1FRElBX0JVU19G
TVRfU0JHR1I4XzFYOCwNCj4+PiArCQkuZGVwdGggPSA4LA0KPj4+ICsJfSwNCj4+PiArCXsNCj4+
PiArCQkvKiBSQVcgMTAgKi8NCj4+PiArCQkuY29kZSA9IE1FRElBX0JVU19GTVRfU0JHR1IxMF8y
WDhfUEFESElfQkUsDQo+Pj4gKwkJLmRlcHRoID0gMTAsDQo+Pj4gKwl9LA0KPj4NCj4+IEhpIEx1
aXMsDQo+Pg0KPj4gQW55IHJlYXNvbiB3aHkgUkFXMTIgZm9ybWF0IGlzIG5vdCBoYW5kbGVkIGhl
cmUgPw0KPj4NCj4+IEhlcmUsIG5hbWVseSBNRURJQV9CVVNfRk1UX1NCR0dSMTJfMVgxMiBldGMu
DQo+Pg0KPiBIaSBFdWdlbiwNCj4gDQo+IE15IEh3IHRlc3Rpbmcgc2V0dXAgY3VycmVudGx5IGRv
ZXMgbm90IHN1cHBvcnQgaXQsIHNvIEkgZGlkbid0IGFkZCBpdC4NCj4gDQo+Pj4gKwl7DQo+Pj4g
KwkJLyogUkdCIDU2NSAqLw0KPj4+ICsJCS5jb2RlID0gTUVESUFfQlVTX0ZNVF9SR0I1NjVfMlg4
X0JFLA0KPj4+ICsJCS5kZXB0aCA9IDE2LA0KPj4+ICsJfSwNCj4+PiArCXsNCj4+PiArCQkvKiBC
R1IgNTY1ICovDQo+Pj4gKwkJLmNvZGUgPSBNRURJQV9CVVNfRk1UX1JHQjU2NV8yWDhfTEUsDQo+
Pj4gKwkJLmRlcHRoID0gMTYsDQo+Pj4gKwl9LA0KPj4+ICsJew0KPj4+ICsJCS8qIFJHQiA4ODgg
Ki8NCj4+PiArCQkuY29kZSA9IE1FRElBX0JVU19GTVRfUkdCODg4XzJYMTJfTEUsDQo+Pj4gKwkJ
LmRlcHRoID0gMjQsDQo+Pj4gKwl9LA0KPj4+ICsJew0KPj4+ICsJCS8qIEJHUiA4ODggKi8NCj4+
PiArCQkuY29kZSA9IE1FRElBX0JVU19GTVRfUkdCODg4XzJYMTJfQkUsDQo+Pj4gKwkJLmRlcHRo
ID0gMjQsDQo+Pj4gKwl9LA0KPj4+ICt9Ow0KPj4NCj4+IFtzbmlwXQ0KPj4NCj4+PiArDQo+Pj4g
K3ZvaWQgZHdfbWlwaV9jc2lfc2V0X2lwaV9mbXQoc3RydWN0IG1pcGlfY3NpX2RldiAqY3NpX2Rl
dikNCj4+PiArew0KPj4+ICsJc3RydWN0IGRldmljZSAqZGV2ID0gY3NpX2Rldi0+ZGV2Ow0KPj4+
ICsNCj4+PiArCWlmIChjc2lfZGV2LT5pcGlfZHQpDQo+Pj4gKwkJZHdfbWlwaV9jc2lfd3JpdGUo
Y3NpX2RldiwgcmVnLklQSV9EQVRBX1RZUEUsIGNzaV9kZXYtPmlwaV9kdCk7DQo+Pj4gKwllbHNl
IHsNCj4+PiArCQlzd2l0Y2ggKGNzaV9kZXYtPmZtdC0+Y29kZSkgew0KPj4+ICsJCWNhc2UgTUVE
SUFfQlVTX0ZNVF9SR0I1NjVfMlg4X0JFOg0KPj4+ICsJCWNhc2UgTUVESUFfQlVTX0ZNVF9SR0I1
NjVfMlg4X0xFOg0KPj4+ICsJCQlkd19taXBpX2NzaV93cml0ZShjc2lfZGV2LA0KPj4+ICsJCQkJ
CXJlZy5JUElfREFUQV9UWVBFLCBDU0lfMl9SR0I1NjUpOw0KPj4+ICsJCQlkZXZfZGJnKGRldiwg
IkRUOiBSR0IgNTY1Iik7DQo+Pj4gKwkJCWJyZWFrOw0KPj4+ICsNCj4+PiArCQljYXNlIE1FRElB
X0JVU19GTVRfUkdCODg4XzJYMTJfTEU6DQo+Pj4gKwkJY2FzZSBNRURJQV9CVVNfRk1UX1JHQjg4
OF8yWDEyX0JFOg0KPj4+ICsJCQlkd19taXBpX2NzaV93cml0ZShjc2lfZGV2LA0KPj4+ICsJCQkJ
CXJlZy5JUElfREFUQV9UWVBFLCBDU0lfMl9SR0I4ODgpOw0KPj4+ICsJCQlkZXZfZGJnKGRldiwg
IkRUOiBSR0IgODg4Iik7DQo+Pj4gKwkJCWJyZWFrOw0KPj4+ICsJCWNhc2UgTUVESUFfQlVTX0ZN
VF9TQkdHUjEwXzJYOF9QQURISV9CRToNCj4+PiArCQkJZHdfbWlwaV9jc2lfd3JpdGUoY3NpX2Rl
diwNCj4+PiArCQkJCQlyZWcuSVBJX0RBVEFfVFlQRSwgQ1NJXzJfUkFXMTApOw0KPj4+ICsJCQlk
ZXZfZGJnKGRldiwgIkRUOiBSQVcgMTAiKTsNCj4+PiArCQkJYnJlYWs7DQo+Pj4gKwkJY2FzZSBN
RURJQV9CVVNfRk1UX1NCR0dSOF8xWDg6DQo+Pj4gKwkJCWR3X21pcGlfY3NpX3dyaXRlKGNzaV9k
ZXYsDQo+Pj4gKwkJCQkJcmVnLklQSV9EQVRBX1RZUEUsIENTSV8yX1JBVzgpOw0KPj4+ICsJCQlk
ZXZfZGJnKGRldiwgIkRUOiBSQVcgOCIpOw0KPj4+ICsJCQlicmVhazsNCj4+DQo+PiBTYW1lIGhl
cmUsIGluIENTSV8yX1JBVzEyIGNhc2UgaXQgd2lsbCBkZWZhdWx0IHRvIGEgUkdCNTY1IGNhc2Uu
DQo+Pg0KPj4gVGhhbmtzLA0KPj4NCj4+IEV1Z2VuDQo+Pg0KPj4NCj4gSSB3aWxsIHRyeSB0byBh
ZGQgdGhlIHN1cHBvcnQgZm9yIHRoaXMgZGF0YSB0eXBlIGluIG15IG5leHQgcGF0Y2hzZXQgaWYg
bm90IEkNCj4gd2lsbCBmbGFnIGl0IGFzIHVuc3VwcG9ydGVkIGZvciBub3cgaW4gdGhlIGNvbW1p
dCBtZXNzYWdlIGFuZCBjb2RlLg0KDQpIaSBMdWlzLA0KDQpJIGFtIGN1cnJlbnRseSB0cnlpbmcg
dG8gc2VlIGlmIHlvdXIgZHJpdmVyIHdvcmtzICwgYW5kIEkgbmVlZCB0aGUgUkFXMTIgDQp0eXBl
LCB0aGF0J3Mgd2h5IEkgYW0gYXNraW5nIGFib3V0IGl0Lg0KDQpPbmUgcXVlc3Rpb24gcmVsYXRl
ZCB0byB0aGUgc3ViZGV2aWNlIHlvdSBjcmVhdGUgaGVyZSwgaG93IGRvIHlvdSANCnJlZ2lzdGVy
IHRoaXMgc3ViZGV2IGludG8gdGhlIG1lZGlhIHN1YnN5c3RlbSA/IHN5bmMgb3IgYXN5bmMsIG9y
IG5vdCBhdCANCmFsbCA/DQpBZnRlciB0aGUgZHJpdmVyIHByb2JlcywgdGhlcmUgaXMgbm8gY2Fs
bCB0byB0aGUgc2V0IGZvcm1hdCBmdW5jdGlvbnMsIEkgDQphZGRlZCBhIG5vZGUgaW5zaWRlIHRo
ZSBEZXZpY2UgdHJlZSwgSSBzZWUgeW91IGFyZSByZWdpc3RlcmluZyBtZWRpYSANCnBhZHMsIGJ1
dCB0aGUgb3RoZXIgZW5kcG9pbnQgbmVlZHMgdG8gYmUgYW4gYXN5bmMgd2FpdGluZyBmb3IgY29t
cGxldGlvbiANCm5vZGUgb3IgeW91ciBzdWJkZXYgcmVnaXN0ZXJzIGluIHNvbWUgb3RoZXIgd2F5
ID8gKG1heWJlIHNvbWUgbGluayANCnZhbGlkYXRpb24gcmVxdWlyZWQgPykNCg0KVGhhbmtzIGZv
ciB5b3VyIGhlbHAsDQoNCkV1Z2VuDQoNCj4gDQo+IFRoYW5rcyBmb3IgeW91ciByZXZpZXcsDQo+
IEx1aXMNCj4gDQo+Pg0KPj4+ICsJCWRlZmF1bHQ6DQo+Pj4gKwkJCWR3X21pcGlfY3NpX3dyaXRl
KGNzaV9kZXYsDQo+Pj4gKwkJCQkJcmVnLklQSV9EQVRBX1RZUEUsIENTSV8yX1JHQjU2NSk7DQo+
Pj4gKwkJCWRldl9kYmcoZGV2LCAiRXJyb3IiKTsNCj4+PiArCQkJYnJlYWs7DQo+Pj4gKwkJfQ0K
Pj4+ICsJfQ0KPj4+ICt9DQo+Pj4gKw0KPj4NCj4+IFtzbmlwXQ0KPj4NCj4gDQo=
