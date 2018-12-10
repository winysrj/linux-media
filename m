Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA2BC04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 12:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE8D920821
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 12:40:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="pb88Oswz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE8D920821
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbeLJMj5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 07:39:57 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:32814 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbeLJMj4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 07:39:56 -0500
X-IronPort-AV: E=Sophos;i="5.56,338,1539673200"; 
   d="scan'208";a="25056117"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 10 Dec 2018 05:39:54 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 10 Dec 2018 05:39:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+5Hwc5c3urAZddG5qtSG55hFhHA21g2LHH47fZJf/U=;
 b=pb88Oswz1h54i+VQiqXFDax9+kpdtfDozKmOjZI5y7Yc5XRuJwz3nJxTHi4sgcTAB1A5IlxQq+OHoGdeEtZDQIiaoMFU4CTC/WpuRS7kXrSfkQWlmlaCjNW8XKwslqac80ruRxG8fEz+9CNlyVoXJjwh3xJpQl2R/qRwXzZkZVE=
Received: from DM5PR11MB1242.namprd11.prod.outlook.com (10.168.108.8) by
 DM5PR11MB1675.namprd11.prod.outlook.com (10.172.38.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1404.17; Mon, 10 Dec 2018 12:39:52 +0000
Received: from DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::f46d:c17e:bb65:5e0f]) by DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::f46d:c17e:bb65:5e0f%3]) with mapi id 15.20.1404.026; Mon, 10 Dec 2018
 12:39:52 +0000
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
Thread-Index: AQHUkITXCcv9szjWl0qFFgx76hUWpA==
Date:   Mon, 10 Dec 2018 12:39:52 +0000
Message-ID: <ea589e15-a39d-84c0-f0ee-0f434273027b@microchip.com>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
 <1539953556-35762-5-git-send-email-lolivei@synopsys.com>
In-Reply-To: <1539953556-35762-5-git-send-email-lolivei@synopsys.com>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR07CA0225.eurprd07.prod.outlook.com
 (2603:10a6:802:58::28) To DM5PR11MB1242.namprd11.prod.outlook.com
 (2603:10b6:3:14::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR11MB1675;6:SNl6aReDIzqw0LXNmXnFbdjdJf/Y8x5dL1WBbeeiIMuvmMsaZ5fTkKpEfD+cgyHRi2JJqS1PjP43a4E0e+90vyGjuJfKGPSfOvdspjYXHXCvkN++fEHDrBiUYJyVQo0Eiaj2vAuAVsPEQ8m/YLJrUc2XZShC8Hn/YCcT9MRj0svYV23Qag9C0xXyerr4K1KOOgA1cyy0u3oVGwnRWgR06NV5AB2fMhocLA1lSsq1Wo2//R1xiSkPRXafjGaG4FtX5jCK6lH7eXVfHdyAVmF9otfQQUJY6RcAtJRC87pUIaE6KF/yqvGoHYfeH93nGxWEidNfey4eawQJZpmbflHFWje9P/tQR0KWTSxOatvBcQ9bDCCMD8oP6ewn2eyhPmG7uKUaF8faevC02lgTfsn6XlsfVJzCU1xxpPJ2A+jraAnfvMW23ZTz0q79QOodIjeoUQNtiF6+pw2Momx9HzEygA==;5:gK2sdtLJEjsEpT8QWMlpSsuWQQAxg3IsEB65omJAH8Veu/9FdvT5SCaEX0fx8qTTZ9J3KXSitVdpNzEDLFxqsNMXrW2smaOXpeic7lixpRqDCbAF3R9Nh8vpXaS1Sn6IMT8OIOQH38aoQZhk0TRvJefyObO3WQjO/1+4dgVh+Qo=;7:zeHNHri2JtlC7Oy9ErT/jDfc7/EseRVo9+k2vaymHZFz9evFqH8sb7hQhYJOpNIvot2ZKHZQorVILQCLeecMnmW+Nau4dyz7ZeTHcFW42F4qgo1fEL8xd1lLkHaMIPervSgQn/tZkIEWcySLKtwB7g==
x-ms-office365-filtering-correlation-id: f2a96ca5-1951-49b3-a794-08d65e9c9494
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DM5PR11MB1675;
x-ms-traffictypediagnostic: DM5PR11MB1675:
x-microsoft-antispam-prvs: <DM5PR11MB1675DFBB491F3E6DAA815047E8A50@DM5PR11MB1675.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3231455)(999002)(944501520)(52105112)(3002001)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:DM5PR11MB1675;BCL:0;PCL:0;RULEID:;SRVR:DM5PR11MB1675;
x-forefront-prvs: 08828D20BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(366004)(346002)(376002)(189003)(54534003)(199004)(2501003)(6246003)(2906002)(7736002)(25786009)(99286004)(31686004)(5660300001)(97736004)(39060400002)(305945005)(14454004)(36756003)(68736007)(6116002)(3846002)(72206003)(52116002)(476003)(105586002)(2616005)(446003)(486006)(106356001)(11346002)(4326008)(478600001)(6506007)(66066001)(53936002)(6486002)(53546011)(386003)(256004)(186003)(6436002)(110136005)(8936002)(54906003)(76176011)(6512007)(102836004)(26005)(71200400001)(2201001)(86362001)(316002)(81166006)(7416002)(8676002)(31696002)(71190400001)(229853002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1675;H:DM5PR11MB1242.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 4TAUnI0HXLDOAQprVs+ixKqKqwu2ChkGAoZW8v9/8aqNU1rMk4Xxcj2Lp3mnC6nBb9lM26GB+Ky8G5wFcdvsWd+KYBvFK4cupuv5UIe630j8yaGHdlZC9x7Blv76Dj3ToZgEVv8XCUcIcQxQfyrPI94ygXUjNqKzcyZFAS0qnbDKJYUFYggBM7ciBySJuLA2kL6gy5C0PcmPcW49Xdvro592RTBqNrBQxtK9q8h8jIAOnmbMnvlPXjMfQPewQ9yUGppLhQwAmh+ilDLPd+r5NTB5xnXVYBKwXOw3KkSMjwV6w1NlGv/R4yGpWl/gtW1k
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <A86AC8607CD8824FA16EF562E9320E1C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f2a96ca5-1951-49b3-a794-08d65e9c9494
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2018 12:39:52.4516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1675
X-OriginatorOrg: microchip.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

DQoNCk9uIDE5LjEwLjIwMTggMTU6NTIsIEx1aXMgT2xpdmVpcmEgd3JvdGU6DQo+IEFkZCB0aGUg
U3lub3BzeXMgTUlQSSBDU0ktMiBjb250cm9sbGVyIGRyaXZlci4gVGhpcw0KPiBjb250cm9sbGVy
IGRyaXZlciBpcyBkaXZpZGVkIGluIHBsYXRmb3JtIGRlcGVuZGVudCBmdW5jdGlvbnMNCj4gYW5k
IGNvcmUgZnVuY3Rpb25zLiBJdCBhbHNvIGluY2x1ZGVzIGEgcGxhdGZvcm0gZm9yIGZ1dHVyZQ0K
PiBEZXNpZ25XYXJlIGRyaXZlcnMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBMdWlzIE9saXZlaXJh
IDxsb2xpdmVpQHN5bm9wc3lzLmNvbT4NCj4gLS0tDQo+IENoYW5nZWxvZw0KPiB2Mi1WMw0KPiAt
IGV4cG9zZWQgSVBJIHNldHRpbmdzIHRvIHVzZXJzcGFjZQ0KPiAtIGZpeGVkIGhlYWRlcnMNClsu
Li5dDQoNCnNuaXANCg0KDQo+ICsNCj4gK3N0YXRpYyBpbnQNCj4gK2R3X21pcGlfY3NpX3BhcnNl
X2R0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYsIHN0cnVjdCBtaXBpX2NzaV9kZXYgKmRl
dikNCj4gK3sNCj4gKwlzdHJ1Y3QgZGV2aWNlX25vZGUgKm5vZGUgPSBwZGV2LT5kZXYub2Zfbm9k
ZTsNCj4gKwlzdHJ1Y3QgdjRsMl9md25vZGVfZW5kcG9pbnQgZW5kcG9pbnQ7DQoNCkhlbGxvIEx1
aXMsDQoNCkkgYmVsaWV2ZSB5b3UgaGF2ZSB0byBpbml0aWFsaXplICJlbmRwb2ludCIgaGVyZSBj
b3JyZWN0bHksIG90aGVyd2lzZSANCnRoZSBwYXJzaW5nIG1lY2hhbmlzbSAoZndub2RlX2VuZHBv
aW50X3BhcnNlKSB3aWxsIGNvbnNpZGVyIHlvdSBoYXZlIGEgDQpzcGVjaWZpYyBtYnVzIHR5cGUg
YW5kIGZhaWwgdG8gcHJvYmUgdGhlIGVuZHBvaW50OiBiYWlsIG91dCB3aXRoIGRlYnVnIA0KbWVz
c2FnZSAiZXhwZWN0aW5nIGJ1cyB0eXBlIG5vdCBmb3VuZCAiDQoNCihuYW1lbHksIGluaXRpYWxp
emUgdG8gemVybyB3aGljaCBpcyB0aGUgVU5LTk9XTiBtYnVzIHR5cGUsIG9yICwgdG8gYSANCnNw
ZWNpZmljIG1idXMgKGZyb20gRFQgb3Igd2hhdGV2ZXIgc291cmNlKSkNCg0KRXVnZW4NCg0KDQo+
ICsJaW50IHJldDsNCj4gKw0KPiArCW5vZGUgPSBvZl9ncmFwaF9nZXRfbmV4dF9lbmRwb2ludChu
b2RlLCBOVUxMKTsNCj4gKwlpZiAoIW5vZGUpIHsNCj4gKwkJZGV2X2VycigmcGRldi0+ZGV2LCAi
Tm8gcG9ydCBub2RlIGF0ICVzXG4iLA0KPiArCQkJCXBkZXYtPmRldi5vZl9ub2RlLT5mdWxsX25h
bWUpOw0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gKwl9DQo+ICsNCj4gKwlyZXQgPSB2NGwyX2Z3
bm9kZV9lbmRwb2ludF9wYXJzZShvZl9md25vZGVfaGFuZGxlKG5vZGUpLCAmZW5kcG9pbnQpOw0K
PiArCWlmIChyZXQpDQo+ICsJCWdvdG8gZXJyOw0KPiArDQo+ICsJZGV2LT5pbmRleCA9IGVuZHBv
aW50LmJhc2UucG9ydCAtIDE7DQo+ICsJaWYgKGRldi0+aW5kZXggPj0gQ1NJX01BWF9FTlRJVElF
Uykgew0KPiArCQlyZXQgPSAtRU5YSU87DQo+ICsJCWdvdG8gZXJyOw0KPiArCX0NCj4gKwlkZXYt
Pmh3Lm51bV9sYW5lcyA9IGVuZHBvaW50LmJ1cy5taXBpX2NzaTIubnVtX2RhdGFfbGFuZXM7DQo+
ICsNCj4gK2VycjoNCj4gKwlvZl9ub2RlX3B1dChub2RlKTsNCj4gKwlyZXR1cm4gcmV0Ow0KPiAr
fQ0KPiArDQoNCnNuaXANCg==
