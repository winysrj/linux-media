Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09136C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C26672147C
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:10:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="qas1qMT5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfAGLK6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:10:58 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:10105 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbfAGLK6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 06:10:58 -0500
X-IronPort-AV: E=Sophos;i="5.56,450,1539673200"; 
   d="scan'208";a="23071590"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Jan 2019 04:10:58 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 7 Jan 2019 04:11:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdHDG7J1szsTf/kl3KJd689gJ0JCoXaLRgdXwJ7yPpY=;
 b=qas1qMT5UDUG5mJV7s3udBPZX3A/n2PnC3azVEMDXuAnx1JV5ZjpNVEgAXKfkbUB7fyQVXE0wF4AWA+mFp6dCdJCNBgzD0tBc7mLI8cZ+n6dzIdG/YzQjeh/D1NTLhn0sXKhZanFtgkJRFtYWAGoQmdEZCSYlm3XBfbRuBLkOec=
Received: from DM5PR11MB1242.namprd11.prod.outlook.com (10.168.108.8) by
 DM5PR11MB1932.namprd11.prod.outlook.com (10.175.88.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.9; Mon, 7 Jan 2019 11:10:55 +0000
Received: from DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::d41b:896d:ae28:5a57]) by DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::d41b:896d:ae28:5a57%12]) with mapi id 15.20.1495.011; Mon, 7 Jan 2019
 11:10:55 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <KSloat@aampglobal.com>
CC:     <mchehab@kernel.org>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <Ludovic.Desroches@microchip.com>,
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH v1 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Topic: [PATCH v1 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Index: AQHUns6/77kEGvPCikSLFo8p0P0NrKWjtIoA
Date:   Mon, 7 Jan 2019 11:10:55 +0000
Message-ID: <2fdfa5e9-7b59-0898-73d9-2ac75a8057d2@microchip.com>
References: <20181228165934.36393-1-ksloat@aampglobal.com>
 <20181228165934.36393-2-ksloat@aampglobal.com>
In-Reply-To: <20181228165934.36393-2-ksloat@aampglobal.com>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1P190CA0013.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::26) To DM5PR11MB1242.namprd11.prod.outlook.com
 (2603:10b6:3:14::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR11MB1932;6:QCrRWm1C+jdFO2RS663whv4SIvQ4aTxbxqPwGMCm6XKw0JFJel1LbDl1tOPOtZTjxwLn1fRsjfC1ihyfQKmeA7d7i315TUFVplol3bagJNFkTR6lPwAT9VaWExM/lZRRXg7X+04/GxYiEqLYqqS2OtZhgIBG2VTVoh6NB5omiTEFRYBw7WZcaT3ySQVUMG+EdrtrfFwuUlkRDtHGRJNRKLTrC1VWC3OUahPrrsKEYIP15MDkTc7NCugAoNNS+97+7c8VLU1AeybnOQDmPJdOiGtlZlYMqtSh/RN+XXW+pIV4SKvYEryojZVcfkn4vW1APo3JkH7/iiHo78i/oGfi2zMXhrF0bH2DVefbzXSx4f6db/9RMJO8b8pZvdVOcqp6yQ9PpYKzbY0lO2igSXEI9WV5WfSOgZu9xJjHHkOkexWCKp3lG2b0P7XglWHszKz+Y+tF5XljFow1Khuw4+Aw9g==;5:dlCk5wynei4zCC/uM2oB7e7dDocngZ9vyUcL0ERRcyj44mhMH3eq7ilBACw0996dwcrpl+hqqpLz0TYHGjtj2DiXLffngdbcC1I8UQGB5Rh9syYqXAUYry6Yn5u0gN8rInw6KpbVbZBt+MgQzlOS6SNKpdZ6TlVKt3WJeImVaRfc03zo5cW+RLkCCIhMjpmsFHmIOs/Su9o2lN8QOVqQRA==;7:JG0TnzZLse2pS0vAU0AZeJIDgmHH0cp3CSKY+ruhnK9yNOF6gR7HSSKKx6JI/P5aVhuwP70hDFUoL8SiBxGemBoF12ll1qCAKnYhOnbiZrVFh2hYnTkjCFOFEChv6lQcaUgHv9vKGy6OSm23bPNCJg==
x-ms-office365-filtering-correlation-id: 46d26dff-0b2f-4d07-ef2b-08d67490cb10
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600109)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DM5PR11MB1932;
x-ms-traffictypediagnostic: DM5PR11MB1932:
x-microsoft-antispam-prvs: <DM5PR11MB193208804B4162C0D5CB3F01E8890@DM5PR11MB1932.namprd11.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(93006095)(93001095)(3231475)(944501520)(52105112)(3002001)(10201501046)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:DM5PR11MB1932;BCL:0;PCL:0;RULEID:;SRVR:DM5PR11MB1932;
x-forefront-prvs: 0910AAF391
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39860400002)(136003)(396003)(189003)(199004)(31696002)(86362001)(316002)(186003)(476003)(229853002)(2616005)(305945005)(575784001)(6506007)(6436002)(386003)(53546011)(102836004)(66066001)(11346002)(446003)(6246003)(256004)(14444005)(97736004)(486006)(6486002)(15650500001)(53936002)(36756003)(2906002)(31686004)(6916009)(105586002)(14454004)(106356001)(4326008)(72206003)(478600001)(8676002)(71200400001)(8936002)(81156014)(7736002)(99286004)(71190400001)(81166006)(6116002)(3846002)(25786009)(26005)(5660300001)(68736007)(54906003)(6512007)(76176011)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1932;H:DM5PR11MB1242.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: G/JVIAyN6bRs9U9xBit9B8P2KJGb8S8dPuM4kCjuzTltpi/ZSGaLw+5DGFmDD02+5OHMp8m7faG9Jq+kKj/p28YEykodvLUo5dflH2gwwV4vou759gXYKH/QNrMgIFCiFAirFFILbOyG3khcG2yCKbeXIwtsAWvOt5/z2iejEshoGHvj04QHjfr42ZiBi7cNngl+82ZXjO85x+QSmQ4U+qrdX8yfvu5ePXCk7UWqZtQg6A196PXA8CDTnbHANrywJrxNuS/f2AeAOWDJr7s6LyWSmA43KMcr5ooi0n0MFqrYpXizZ43+F+MU+5dWd1qg
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F303C647A495042A80F36A124C5452C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 46d26dff-0b2f-4d07-ef2b-08d67490cb10
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2019 11:10:55.3073
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
b2F0IDxrc2xvYXRAYWFtcGdsb2JhbC5jb20+DQo+IA0KPiBVcGRhdGUgZGV2aWNlIHRyZWUgYmlu
ZGluZyBkb2N1bWVudGF0aW9uIHNwZWNpZnlpbmcgaG93IHRvDQo+IGVuYWJsZSBCVDY1NiB3aXRo
IENSQyBkZWNvZGluZy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEtlbiBTbG9hdCA8a3Nsb2F0QGFh
bXBnbG9iYWwuY29tPg0KQWNrZWQtYnk6IEV1Z2VuIEhyaXN0ZXYgPGV1Z2VuLmhyaXN0ZXZAbWlj
cm9jaGlwLmNvbT4NCg0KPiAtLS0NCj4gICBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGlu
Z3MvbWVkaWEvYXRtZWwtaXNjLnR4dCB8IDMgKysrDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDMgaW5z
ZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy9tZWRpYS9hdG1lbC1pc2MudHh0IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2Jp
bmRpbmdzL21lZGlhL2F0bWVsLWlzYy50eHQNCj4gaW5kZXggYmJlMGU4N2M2MTg4Li5lNzg3ZWRl
ZWE3ZGEgMTAwNjQ0DQo+IC0tLSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9t
ZWRpYS9hdG1lbC1pc2MudHh0DQo+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5k
aW5ncy9tZWRpYS9hdG1lbC1pc2MudHh0DQo+IEBAIC0yNSw2ICsyNSw5IEBAIElTQyBzdXBwb3J0
cyBhIHNpbmdsZSBwb3J0IG5vZGUgd2l0aCBwYXJhbGxlbCBidXMuIEl0IHNob3VsZCBjb250YWlu
IG9uZQ0KPiAgICdwb3J0JyBjaGlsZCBub2RlIHdpdGggY2hpbGQgJ2VuZHBvaW50JyBub2RlLiBQ
bGVhc2UgcmVmZXIgdG8gdGhlIGJpbmRpbmdzDQo+ICAgZGVmaW5lZCBpbiBEb2N1bWVudGF0aW9u
L2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvdmlkZW8taW50ZXJmYWNlcy50eHQuDQo+ICAgDQo+
ICtJZiBhbGwgZW5kcG9pbnQgYnVzIGZsYWdzIChpLmUuIGhzeW5jLWFjdGl2ZSkgYXJlIG9taXR0
ZWQsIHRoZW4gQ0NJUjY1Ng0KPiArZGVjb2RpbmcgKGVtYmVkZGVkIHN5bmMpIHdpdGggQ1JDIGRl
Y29kaW5nIGlzIGVuYWJsZWQuDQo+ICsNCj4gICBFeGFtcGxlOg0KPiAgIGlzYzogaXNjQGYwMDA4
MDAwIHsNCj4gICAJY29tcGF0aWJsZSA9ICJhdG1lbCxzYW1hNWQyLWlzYyI7DQo+IA0K
