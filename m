Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7ACC43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 14:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5BB32087E
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 14:39:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="IKDPRtwU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfAROj5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 09:39:57 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:43307 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfAROj4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 09:39:56 -0500
X-IronPort-AV: E=Sophos;i="5.56,491,1539673200"; 
   d="scan'208";a="25201101"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 18 Jan 2019 07:39:55 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 18 Jan 2019 07:39:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lnlUnHS6ueQ5W/agA5YUM7ZJ4gQb80Y5QpPtdvswSPs=;
 b=IKDPRtwUczlI3FQEz3U75hcqofAQEk+kELQzhzAwwDpwbXeMrCmmhaxMzgWxKBOXY2cmx1kLLYVxJqh80Av9P4zrZAegAtV/miUYf4wOBRndBW8vyp2EQ4ytwwZfLtQB4FsyQlUlmmvcK5HEjp9bTCOaf7KPOjFv1F4QaFtRce0=
Received: from DM5PR11MB1242.namprd11.prod.outlook.com (10.168.108.8) by
 DM5PR11MB1834.namprd11.prod.outlook.com (10.175.92.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.18; Fri, 18 Jan 2019 14:39:54 +0000
Received: from DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::4c19:f788:c2be:5e8f]) by DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::4c19:f788:c2be:5e8f%4]) with mapi id 15.20.1516.019; Fri, 18 Jan 2019
 14:39:54 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <KSloat@aampglobal.com>
CC:     <mchehab@kernel.org>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <Ludovic.Desroches@microchip.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Topic: [PATCH v2 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Index: AQHUrzoYUbNBT9P6U0ynPkBU6Yfu1qW1F7kA
Date:   Fri, 18 Jan 2019 14:39:53 +0000
Message-ID: <0c000df0-94ec-e8bf-e6b1-1a8a94170181@microchip.com>
References: <20190118142803.70160-1-ksloat@aampglobal.com>
 <20190118142803.70160-2-ksloat@aampglobal.com>
In-Reply-To: <20190118142803.70160-2-ksloat@aampglobal.com>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0601CA0025.eurprd06.prod.outlook.com
 (2603:10a6:203:68::11) To DM5PR11MB1242.namprd11.prod.outlook.com
 (2603:10b6:3:14::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-tagtoolbar-keys: D20190118163542861
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR11MB1834;6:6NHwvTa27dKe9yxPlrea4ELv4zK/KErLGLUDUNg4VFkNqLViKACNuFgAq92FW+WHWzZXtqt3qGADvgzcGuM9c+3csSQ+qcRg58L5WJ0oqmykAGLcsWJaRyEjbfBjpe9DlbH9RGRMKVhvfJAaZnOneo8e3rHY2Ibv4aQUxAYXst7FCdLc63nwg+JquMgg00HUNhO+kCIgA1P64gQdrSgkIxlwRF9/IPgRuqR6cc20P4UHxh7cY7miMgUV3bUH3pJEqHyckVVXso8np22LrO+rq3MlZsRdk6HCqomzHHzlbg+GHuw1LVE8E9/j8r0wxzDGjY7tNAgNOKBOfMiui9AAXOhnpwfPiRzB+fLgYmtotGOECv+0gnXxvZzNCiY6m9KvMnRhFCCIobdqBnOGx2Q0Nl0JCDb4NJrYDbHlM29mbU6PtonUpOrv2GPlNJd8SbpVIyNlRYroXR562lvdJ4jEwA==;5:9VlUsspUX+Ko4W2JSskTadB7hJ8XaHsaAPh+qWsVkp+WyFyCpOIVpySZ8YzvByalVoLfgzIkaY2RSZBw83NpJFovXfvqj+3eaLG1WyGOK5Q5qYBYjiZjZNGfBqaPON6n6KgXOKNe6Oa8OqbdOp4xj3IoDsb2gaGNj+Cc0u8x5kpGQKi0yXPzfoT2QvMupJ5ZFB3kQT+zROfkFv429SiaRw==;7:i0baCDvuYzIRiP4ZC6LOhwZ2DYPTVxlb1O9LDyEEBYU/qAbd9C1g96q0jCzYi6T3qV5rFa9kk/bCrkhykHPOnG5nYvVsMA+bN1m2/9btmmO1CVJQAjoObQXUyR9saKbptkO0idmRfRuQPpQiMqHlDg==
x-ms-office365-filtering-correlation-id: 5189a914-41c2-4a96-7a2b-08d67d52cf33
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:DM5PR11MB1834;
x-ms-traffictypediagnostic: DM5PR11MB1834:
x-microsoft-antispam-prvs: <DM5PR11MB1834D32A558B781F131BB9FEE89C0@DM5PR11MB1834.namprd11.prod.outlook.com>
x-forefront-prvs: 0921D55E4F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(136003)(39860400002)(396003)(199004)(189003)(14454004)(25786009)(446003)(256004)(6116002)(386003)(71190400001)(3846002)(8936002)(106356001)(81166006)(6506007)(53546011)(71200400001)(15650500001)(4326008)(52116002)(68736007)(6916009)(102836004)(8676002)(5660300001)(86362001)(76176011)(2906002)(72206003)(14444005)(305945005)(7736002)(26005)(31696002)(105586002)(81156014)(31686004)(486006)(316002)(6246003)(2616005)(97736004)(36756003)(99286004)(6486002)(11346002)(229853002)(478600001)(186003)(476003)(6436002)(6512007)(53936002)(54906003)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1834;H:DM5PR11MB1242.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: I2n/uKH2noooXX3Bg9n2zF3gBuvs+3ntPEbrDJ9b98shYg0ZkzGmg/9LnZpL9+p+9JROrzpOBSdI2BF2u+a7udzshvD4vOZuFyeKdOOGI/zHBlrdRPjocJCIhvcRSB9zWPZK5Zd+0supoOXjLuzseRoQrtj9w5xseOoxFrP7FysY1jndm461hvrTpeYp4zy+WwZ6kwo3hhD+ARcM3vvcvYnMXiH/dJ38pmk5SqeLLwVBTH7xwBzceT29KumYJf/tFXPRvK+buX4UI3qrni/SeK3KJEDvNM2GPHquijLF4/TXBlMhDi7mWBS/ZbQmHnclHe8oqidjIwNfKJg8Y5Lf7sWQn1zUOq6v7/uv0KAgWHMjxgqI3VU5r8A+xPVgC5ylIGveVslv5Xj/hni406XHT5IeADT18i6gFwT5eUCw99o=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C8E7A1DBEF9B249885D171910411690@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5189a914-41c2-4a96-7a2b-08d67d52cf33
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2019 14:39:52.2176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1834
X-OriginatorOrg: microchip.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

DQoNCk9uIDE4LjAxLjIwMTkgMTY6MjgsIEtlbiBTbG9hdCB3cm90ZToNCj4gRnJvbTogS2VuIFNs
b2F0IDxrc2xvYXRAYWFtcGdsb2JhbC5jb20+DQo+IA0KPiBVcGRhdGUgZGV2aWNlIHRyZWUgYmlu
ZGluZyBkb2N1bWVudGF0aW9uIHNwZWNpZnlpbmcgaG93IHRvDQo+IGVuYWJsZSBCVDY1NiB3aXRo
IENSQyBkZWNvZGluZy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEtlbiBTbG9hdCA8a3Nsb2F0QGFh
bXBnbG9iYWwuY29tPg0KPiAtLS0NCj4gICBDaGFuZ2VzIGluIHYyOg0KPiAgIC1Vc2UgY29ycmVj
dCBtZWRpYSAiYnVzLXR5cGUiIGR0IHByb3BlcnR5Lg0KPiAgIA0KPiAgIERvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9tZWRpYS9hdG1lbC1pc2MudHh0IHwgNSArKysrKw0KPiAgIDEg
ZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9Eb2N1bWVu
dGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvYXRtZWwtaXNjLnR4dCBiL0RvY3VtZW50
YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9tZWRpYS9hdG1lbC1pc2MudHh0DQo+IGluZGV4IGJi
ZTBlODdjNjE4OC4uMmQ0Mzc4ZGZkNmM4IDEwMDY0NA0KPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2Rl
dmljZXRyZWUvYmluZGluZ3MvbWVkaWEvYXRtZWwtaXNjLnR4dA0KPiArKysgYi9Eb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvYXRtZWwtaXNjLnR4dA0KPiBAQCAtMjEsNiAr
MjEsMTEgQEAgUmVxdWlyZWQgcHJvcGVydGllcyBmb3IgSVNDOg0KPiAgIC0gcGluY3RybC1uYW1l
cywgcGluY3RybC0wDQo+ICAgCVBsZWFzZSByZWZlciB0byBwaW5jdHJsLWJpbmRpbmdzLnR4dC4N
Cj4gICANCj4gK09wdGlvbmFsIHByb3BlcnRpZXMgZm9yIElTQzoNCj4gKy0gYnVzLXR5cGUNCj4g
KwlXaGVuIHNldCB0byA2LCBCdC42NTYgZGVjb2RpbmcgKGVtYmVkZGVkIHN5bmMpIHdpdGggQ1JD
IGRlY29kaW5nDQo+ICsJaXMgZW5hYmxlZC4NCj4gKw0KDQpJIGRvbid0IHRoaW5rIHRoaXMgcGF0
Y2ggaXMgcmVxdWlyZWQgYXQgYWxsIGFjdHVhbGx5LCB0aGUgYmluZGluZyANCmNvbXBsaWVzIHRv
IHRoZSB2aWRlby1pbnRlcmZhY2VzIGJ1cyBzcGVjaWZpY2F0aW9uIHdoaWNoIGluY2x1ZGVzIHRo
ZSANCnBhcmFsbGVsIGFuZCBidC42NTYuDQoNCldvdWxkIGJlIHdvcnRoIG1lbnRpb25pbmcgYmVs
b3cgZXhwbGljaXRseSB0aGF0IHBhcmFsbGVsIGFuZCBidC42NTYgYXJlIA0Kc3VwcG9ydGVkLCBv
ciBhZGRlZCBhYm92ZSB0aGF0IGFsc28gcGxhaW4gcGFyYWxsZWwgYnVzIGlzIHN1cHBvcnRlZCA/
DQoNCj4gICBJU0Mgc3VwcG9ydHMgYSBzaW5nbGUgcG9ydCBub2RlIHdpdGggcGFyYWxsZWwgYnVz
LiBJdCBzaG91bGQgY29udGFpbiBvbmUNCg0KaGVyZSBpbnNpZGUgdGhlIHByZXZpb3VzIGxpbmUN
Cg0KPiAgICdwb3J0JyBjaGlsZCBub2RlIHdpdGggY2hpbGQgJ2VuZHBvaW50JyBub2RlLiBQbGVh
c2UgcmVmZXIgdG8gdGhlIGJpbmRpbmdzDQo+ICAgZGVmaW5lZCBpbiBEb2N1bWVudGF0aW9uL2Rl
dmljZXRyZWUvYmluZGluZ3MvbWVkaWEvdmlkZW8taW50ZXJmYWNlcy50eHQuDQo+IA0K
