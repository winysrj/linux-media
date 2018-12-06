Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74D9C04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 18:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 954BF20892
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 18:30:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="BfoOARHK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 954BF20892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amd.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbeLFSaK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 13:30:10 -0500
Received: from mail-eopbgr800072.outbound.protection.outlook.com ([40.107.80.72]:44976
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725921AbeLFSaK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 13:30:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2P13GwIc1PfgA0h9HIv2TsfVC+43F2WxFp4RR6UDt4=;
 b=BfoOARHKoU5BxD74Ny/qywuf5fVpSSxFrXsw06EELecLdi2Mj5l14Q7XJ5HDYPBy1p8V4Rk2gAyV18OrUVNyfhbjJkbnsJX0WIp5OyBgLK09Dv9ngcAfisGn6AkXu7fNLjT3oF2SR2lKYMdq94S6sdJRctUVa06aiGKkOc6cea0=
Received: from BN6PR12MB1714.namprd12.prod.outlook.com (10.175.101.11) by
 BN6PR12MB1378.namprd12.prod.outlook.com (10.168.228.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.22; Thu, 6 Dec 2018 18:30:06 +0000
Received: from BN6PR12MB1714.namprd12.prod.outlook.com
 ([fe80::f8a7:157:6224:34ee]) by BN6PR12MB1714.namprd12.prod.outlook.com
 ([fe80::f8a7:157:6224:34ee%2]) with mapi id 15.20.1404.021; Thu, 6 Dec 2018
 18:30:06 +0000
From:   "Koenig, Christian" <Christian.Koenig@amd.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        "jglisse@redhat.com" <jglisse@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?utf-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] dma-buf: fix debugfs versus rcu and fence dumping v2
Thread-Topic: [PATCH] dma-buf: fix debugfs versus rcu and fence dumping v2
Thread-Index: AQHUjXr2wJ3Y8tIeNEOvDhIgwueydKVx7tqAgAAZlAA=
Date:   Thu, 6 Dec 2018 18:30:06 +0000
Message-ID: <203a629c-995b-c2c3-4938-1c1494747438@amd.com>
References: <20181206154704.5366-1-jglisse@redhat.com>
 <154411550724.26970.8541642329782166943@skylake-alporthouse-com>
In-Reply-To: <154411550724.26970.8541642329782166943@skylake-alporthouse-com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
x-originating-ip: [2a02:908:125b:9a00:a142:2be6:b7be:5a3a]
x-clientproxiedby: AM6PR05CA0016.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::29) To BN6PR12MB1714.namprd12.prod.outlook.com
 (2603:10b6:404:106::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Christian.Koenig@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BN6PR12MB1378;20:NhrNWDl6o0WVAZDF9w2XKij9FTcf5SNQd8Gp5SktkPegceMfWliv5k2duw9Es/O2/j/fFQoqqMxOE+vaYAtzNahANCzWrk1D2hLTURLT4y+MvZDaQ38SWLUcmuggm9SD1ZxqFCHFRFik7TVGkG6t3hZmubMt9bAaMnWGA7VWZk2yqOS7LaqQ+baLWKwVj7dR3y2GKJciO1IWlt2vheoyHztICLQwZByDRMLEoM1h6ShojWv01zOtsxk1yjW0dDED
x-ms-office365-filtering-correlation-id: 47d15ffd-75f9-4293-4569-08d65ba8d863
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BN6PR12MB1378;
x-ms-traffictypediagnostic: BN6PR12MB1378:
x-microsoft-antispam-prvs: <BN6PR12MB13789A867CB7E2C26F4CD23683A90@BN6PR12MB1378.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3231455)(999002)(944501520)(52105112)(93006095)(93001095)(3002001)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123564045)(20161123560045)(20161123558120)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BN6PR12MB1378;BCL:0;PCL:0;RULEID:;SRVR:BN6PR12MB1378;
x-forefront-prvs: 087894CD3C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(39860400002)(396003)(136003)(366004)(199004)(189003)(102836004)(446003)(476003)(53936002)(81156014)(81166006)(2906002)(11346002)(65806001)(65956001)(86362001)(8676002)(316002)(52116002)(2501003)(2616005)(58126008)(2201001)(4326008)(8936002)(5660300001)(65826007)(256004)(386003)(31696002)(76176011)(71200400001)(36756003)(6506007)(71190400001)(6246003)(99286004)(105586002)(14454004)(6436002)(6486002)(72206003)(106356001)(31686004)(7736002)(486006)(64126003)(6116002)(68736007)(97736004)(54906003)(229853002)(186003)(6512007)(110136005)(305945005)(25786009)(46003)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR12MB1378;H:BN6PR12MB1714.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: A3C0Ke1XIITyTQ3ckJSynejOWa8dx0ebCglZGJ+whwpYqZnAJBQzUMluSd8rKUPuXoELQ2aa9sL/wVAaxPS8vdIkzUTTiiIQKUlaEQf9KmTEd4qOU7l/UHAQBsdbIFadGHbyqJ5kFhsXzUy4qltsdxVkOP88nmPsu4AAV5zjsBO00il+nOLw83cyvb6ExfUbY7LF//sG1P97WPDk8256I8oj/2auOlqbR2Abz8UvWxOyUMgUDhW0a49/8otyBHee0jhAcE8c90eUOspCyhUhTfXUTQlTHoxEvaBDKBm1KjqjO24IjuFDIiIpOr4A7Atu9x+A7FE/I3g17/N2Or3r2VDVLCH1dthxQHk6p5gXjRo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <FFA2B4747B165943B4806913716BA47E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d15ffd-75f9-4293-4569-08d65ba8d863
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2018 18:30:06.6364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1378
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

QW0gMDYuMTIuMTggdW0gMTc6NTggc2NocmllYiBDaHJpcyBXaWxzb246DQo+IFF1b3Rpbmcgamds
aXNzZUByZWRoYXQuY29tICgyMDE4LTEyLTA2IDE1OjQ3OjA0KQ0KPj4gRnJvbTogSsOpcsO0bWUg
R2xpc3NlIDxqZ2xpc3NlQHJlZGhhdC5jb20+DQo+Pg0KPj4gVGhlIGRlYnVnZnMgdGFrZSByZWZl
cmVuY2Ugb24gZmVuY2Ugd2l0aG91dCBkcm9wcGluZyB0aGVtLiBBbHNvIHRoZQ0KPj4gcmN1IHNl
Y3Rpb24gYXJlIG5vdCB3ZWxsIGJhbGFuY2UuIEZpeCBhbGwgdGhhdCAuLi4NCj4gV291bGRuJ3Qg
dGhlIGNvZGUgYmUgYSBsb3Qgc2ltcGxlciAoYW5kIGEgY29uc2lzdGVudCBzbmFwc2hvdCkgaWYg
aXQgdXNlZA0KPiByZXNlcnZhdGlvbl9vYmplY3RfZ2V0X2ZlbmNlc19yY3UoKT8NCg0KWWVhaCwg
dGhvdWdodCBhYm91dCB0aGF0IGFzIHdlbGwuDQoNCk9yIGV2ZW4gYmV0dGVyIG1vdmUgdGhhdCBj
b2RlIGludG8gcmVzZXJ2YXRpb25fb2JqZWN0LmMgYXMgDQpyZXNlcnZhdGlvbl9vYmplY3Rfc2hv
d19mZW5jZXMoKSBvciBzb21ldGhpbmcgbGlrZSB0aGF0Lg0KDQpDaHJpc3RpYW4uDQoNCj4gLUNo
cmlzDQoNCg==
