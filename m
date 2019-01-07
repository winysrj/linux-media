Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD5EC43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18BA221736
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:10:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="K6pA5Wqn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfAGLKK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:10:10 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:60394 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfAGLKK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 06:10:10 -0500
X-IronPort-AV: E=Sophos;i="5.56,450,1539673200"; 
   d="scan'208";a="26076933"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Jan 2019 04:10:09 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 7 Jan 2019 04:10:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXejuPdICdS07NcuM0EMnLl42AQq0MpeJ8EqPBkBAbo=;
 b=K6pA5WqnrfTdPko2CpqgSYBOd1mJ+OiP/mZB1sdD4SCQENCo2EbqSIzmUN33PaBYSux5+IPhq4jhs78R75sdBcBFdicC9eOqFALP5FDniCNcdHidg4VRVopPQgU0wznOvMn4KgQpePaa/FbB0akVPemBfAkazjQt/I6oOPsSZ/A=
Received: from DM5PR11MB1242.namprd11.prod.outlook.com (10.168.108.8) by
 DM5PR11MB1932.namprd11.prod.outlook.com (10.175.88.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.9; Mon, 7 Jan 2019 11:10:07 +0000
Received: from DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::d41b:896d:ae28:5a57]) by DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::d41b:896d:ae28:5a57%12]) with mapi id 15.20.1495.011; Mon, 7 Jan 2019
 11:10:07 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <KSloat@aampglobal.com>
CC:     <mchehab@kernel.org>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <Ludovic.Desroches@microchip.com>,
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH v1 1/2] media: atmel-isc: Add support for BT656 with CRC
 decoding
Thread-Topic: [PATCH v1 1/2] media: atmel-isc: Add support for BT656 with CRC
 decoding
Thread-Index: AQHUns6/Mav1xniG5UimGV2/kOTXnaWjtE8A
Date:   Mon, 7 Jan 2019 11:10:06 +0000
Message-ID: <79d76502-4fa6-d4fe-7922-9ea946edb6d9@microchip.com>
References: <20181228165934.36393-1-ksloat@aampglobal.com>
In-Reply-To: <20181228165934.36393-1-ksloat@aampglobal.com>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1P190CA0025.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::38) To DM5PR11MB1242.namprd11.prod.outlook.com
 (2603:10b6:3:14::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR11MB1932;6:tuNWS0gq2l79H5i6R2AgWq6jp0BvC7kN0St3QEAGFBDFekdkh4QfNIgauHvL1vQ+XgSod2dMss/9A0tWMI3qEgg5H6TjYfIEjP16IzMRPVu3YxzHbFBWstjzEJGkQ4B0+qkLIJpSLwt5wJVBidbeZIYZeSEwMjJt8RaHu++cal83Lz/f2rrTRuQQqtwiiY26HMdhARQI62QGBGYm+5O+akBm95r8WCRsKpOWXI2Mw4abM0igK+UhpHKJMFf8C3yX9PFhAIDtcp/qF/Y1KMOSNlIay+uRSI42EmmRLIoQ5SjGJ+lqysz4+uY7PrMmCK5WTUMy/1RiD3WFziQnfY1DBM38QZIQehUH9+/mCZZWhajysX+/WHKSKSL1mJUwz736Tbx+Cm7ZFEHF3bHw7Xo1sbTxXccH0kvSyZv3FWAoT4iIEWaP+jXiEtdMMu8ApP1/1K5O2e33M7xoy370XNBfMA==;5:8bKpkMDcJD32hIqXfWLAzpAXj5N9FLYgn4KJxBph/9JeMpbZ4gjg4HI+ynFuFa34KqiSFCJjWa7LeCWfpTSdlIEMaJVc1DO6HjFXNM/bteY/IAuNfQ/I9X07KstMQUrwEy30dtedRn4YB2w2ppTKIcOcoDbm1YeJ4cXM5SJbz70ea4vH0CCQu08WyMBilcfBPucjPWxag4LmJHYOm9hfUg==;7:p1e1hZMYYGF3TmjJxKD0dtBhoZN9oFUWshcqdtsfHbmc2rJTpXWPwZXqLt4adh0X8bVgTyqEaR2VOSHdFl1oTpqV+SFEGHIkEfnngCGwGUUftmWKK9JUmqsJGNAI1ZoX0Ei2xOouoOlM4pTze3u4AA==
x-ms-office365-filtering-correlation-id: da8cfd10-9535-49e3-06d6-08d67490ae1e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600109)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DM5PR11MB1932;
x-ms-traffictypediagnostic: DM5PR11MB1932:
x-microsoft-antispam-prvs: <DM5PR11MB19327FE1A798DD4D1AF10486E8890@DM5PR11MB1932.namprd11.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(93006095)(93001095)(3231475)(944501520)(52105112)(3002001)(10201501046)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:DM5PR11MB1932;BCL:0;PCL:0;RULEID:;SRVR:DM5PR11MB1932;
x-forefront-prvs: 0910AAF391
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39860400002)(136003)(396003)(189003)(199004)(31696002)(86362001)(316002)(186003)(476003)(229853002)(2616005)(305945005)(6506007)(6436002)(386003)(53546011)(102836004)(66066001)(11346002)(446003)(6246003)(256004)(14444005)(97736004)(486006)(6486002)(53936002)(36756003)(2906002)(31686004)(6916009)(105586002)(14454004)(106356001)(4326008)(72206003)(478600001)(8676002)(71200400001)(8936002)(81156014)(7736002)(99286004)(71190400001)(81166006)(6116002)(3846002)(25786009)(26005)(5660300001)(68736007)(54906003)(6512007)(76176011)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1932;H:DM5PR11MB1242.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KEOI4jzlXLZlxh1GGQHLdsSNJL4B2iuyekb5wJV1YCKBGgnByVwTQcm7ywdVZYQri/JrBHtTjZ0LdyxniTGoTpc6LAzDwWNW9wopfBKldrpty1slVwv4RnoNjoKiat0pYqaNPD1+JGpHBUyEAo/eLoN8woj7hY3gcdBzPAh2mPb40rbaWcfkHhrZ85BHFbi5cn48Y7BtrIeWwxwnp2rB11AyTbfJJB4+F+9FAaCG/csO3vpmPr8+qLbZeAyKF0EEkv0PHuDMVnbJSYyTkvmrQr6VZyPM7AdRldsBy7xNQoOK+23t0x6A6TOduCH2Akrv
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <E90E319378962749B94187D87E865E8E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: da8cfd10-9535-49e3-06d6-08d67490ae1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2019 11:10:06.9784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1932
X-OriginatorOrg: microchip.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

DQoNCk9uIDI4LjEyLjIwMTggMTg6NTksIEtlbiBTbG9hdCB3cm90ZToNCj4gRnJvbTogS2VuIFNs
b2F0IDxrc2xvYXRAYWFtcGdsb2JhbC5jb20+DQo+IA0KPiBUaGUgSVNDIGRyaXZlciBjdXJyZW50
bHkgc3VwcG9ydHMgSVRVLVIgNjAxIGVuY29kaW5nIHdoaWNoDQo+IHV0aWxpemVzIHRoZSBleHRl
cm5hbCBoeXN5bmMgYW5kIHZzeW5jIHNpZ25hbHMuIElUVS1SIDY1Ng0KPiBmb3JtYXQgcmVtb3Zl
cyB0aGUgbmVlZCBmb3IgdGhlc2UgcGlucyBieSBlbWJlZGRpbmcgdGhlDQo+IHN5bmMgcHVsc2Vz
IHdpdGhpbiB0aGUgZGF0YSBwYWNrZXQuDQo+IA0KPiBUbyBzdXBwb3J0IHRoaXMgZmVhdHVyZSwg
ZW5hYmxlIG5lY2Vzc2FyeSByZWdpc3RlciBiaXRzDQo+IHdoZW4gdGhpcyBmZWF0dXJlIGlzIGVu
YWJsZWQgdmlhIGRldmljZSB0cmVlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogS2VuIFNsb2F0IDxr
c2xvYXRAYWFtcGdsb2JhbC5jb20+DQpBY2tlZC1ieTogRXVnZW4gSHJpc3RldiA8ZXVnZW4uaHJp
c3RldkBtaWNyb2NoaXAuY29tPg0KDQpBbHNvIGZvciBteSByZWZlcmVuY2UsIHdoaWNoIGJvYXJk
IGFuZCB3aGljaCBzZW5zb3IgZGlkIHlvdSB0ZXN0IHRoaXMgd2l0aCA/DQoNClRoYW5rcw0KDQo+
IC0tLQ0KPiAgIGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vYXRtZWwvYXRtZWwtaXNjLXJlZ3MuaCB8
IDIgKysNCj4gICBkcml2ZXJzL21lZGlhL3BsYXRmb3JtL2F0bWVsL2F0bWVsLWlzYy5jICAgICAg
fCA3ICsrKysrKy0NCj4gICAyIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQ0KPiANCg==
