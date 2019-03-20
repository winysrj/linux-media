Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98055C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 18:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7106A218A3
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 18:15:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="oeOZoJSl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfCTSP7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 14:15:59 -0400
Received: from mail-eopbgr00060.outbound.protection.outlook.com ([40.107.0.60]:43330
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726529AbfCTSP6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 14:15:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector1-arm-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpKQbY914KC3AcMUfYWXFlHT+B05nb6hlB4C68WfVZA=;
 b=oeOZoJSlYURT2uoycg2Gbe155d7dHnZlGSdyJIfz/R3jIrHkQTSL3RO5jRk4DuOkkK3PVgMgxSSZzNJ0LFVWRg+1m0VFAjnkuSE9K0OZuU12LfPn+5190YzyITm03PzJluVgAuh1MMAFT3o5a7NBEwStWtGWKbpoKs0VSPTBU/8=
Received: from AM0PR08MB3025.eurprd08.prod.outlook.com (52.134.93.10) by
 AM0PR08MB4002.eurprd08.prod.outlook.com (20.178.202.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.14; Wed, 20 Mar 2019 18:15:55 +0000
Received: from AM0PR08MB3025.eurprd08.prod.outlook.com
 ([fe80::7e:6dfb:116b:befd]) by AM0PR08MB3025.eurprd08.prod.outlook.com
 ([fe80::7e:6dfb:116b:befd%2]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 18:15:55 +0000
From:   Brian Starkey <Brian.Starkey@arm.com>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
CC:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        nd <nd@arm.com>
Subject: Re: [RFC PATCH 18/20] lib: image-formats: Add v4l2 formats support
Thread-Topic: [RFC PATCH 18/20] lib: image-formats: Add v4l2 formats support
Thread-Index: AQHU30j15eYGJfx+ZkmNvpI6wq6Apw==
Date:   Wed, 20 Mar 2019 18:15:54 +0000
Message-ID: <20190320181553.radwlhapzn464dlh@DESKTOP-E1NTVVP.localdomain>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
 <c97024b97d3261dcf41aad3c8bc1c5d9906f33c9.1553032382.git-series.maxime.ripard@bootlin.com>
 <d8f4a31e35b1702230ced4a0cb43c10d1c7e60c8.camel@ndufresne.ca>
In-Reply-To: <d8f4a31e35b1702230ced4a0cb43c10d1c7e60c8.camel@ndufresne.ca>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: NeoMutt/20180716-849-147d51-dirty
x-originating-ip: [217.140.106.49]
x-clientproxiedby: LO2P265CA0418.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::22) To AM0PR08MB3025.eurprd08.prod.outlook.com
 (2603:10a6:208:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Brian.Starkey@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 118528bc-f306-4126-864f-08d6ad6017ac
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR08MB4002;
x-ms-traffictypediagnostic: AM0PR08MB4002:
x-ms-exchange-purlcount: 1
nodisclaimer: True
x-microsoft-antispam-prvs: <AM0PR08MB40028E8548A023F72691C52FF0410@AM0PR08MB4002.eurprd08.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(256004)(386003)(97736004)(52116002)(9686003)(81156014)(76176011)(966005)(99286004)(102836004)(105586002)(106356001)(305945005)(6246003)(58126008)(72206003)(68736007)(6506007)(316002)(14454004)(54906003)(7736002)(2906002)(81166006)(478600001)(6512007)(25786009)(6306002)(8936002)(6916009)(66066001)(6116002)(1076003)(229853002)(3846002)(4326008)(86362001)(476003)(53936002)(14444005)(44832011)(5660300002)(486006)(446003)(71200400001)(71190400001)(6436002)(11346002)(8676002)(7416002)(6486002)(26005)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR08MB4002;H:AM0PR08MB3025.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2EZSvcw+CdYOaYsYpr0MeT5bkoc17Omlno6GxTi9DbLSoMCmVD0nfs9qKSGozu4zdPfXzui3jgH0TdNzjD+som1JrbtCi3IKqkUg2mdxj5Chqtl1c4a2+/BUalPxGCpHfw+5YLD6MLcTc2HOovTkBG9xKRW0sWtu1oR1OMOu63H38ynb7HbIYfoBMWciG5F0DndSSLE2av6tcviRFGEhcHBsLaojwcQpivCBUt1KPzcDC0wM/XL0JHghaOt2nUwTpOo2Y8RS8r2nN+/glcRk1KHN6LrOGzW7OxalbeV5QLSSnyj3bdOosIz4tL5qwlxtloqz3c/tdT11rSsJ2bxmymtK78cOYwDwyzLvY+/iFt6mO1C0Ho/+0f4VC4OMQ9I8oCV3iQy8oiZLEJ139HqF2lYA0XUSEUI/QJqYyjsjCA4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4811124997DA2F4383E90C1A9A8E2083@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 118528bc-f306-4126-864f-08d6ad6017ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 18:15:54.9935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4002
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Mar 19, 2019 at 07:29:18PM -0400, Nicolas Dufresne wrote:
> All RGB mapping should be surrounded by ifdef, because many (not all)
> DRM formats represent the order of component when placed in a CPU
> register, unlike V4L2 which uses memory order. I've pick this one
> randomly, but this one on most system, little endian, will match
> V4L2_PIX_FMT_XBGR32. This type of complex mapping can be found in
> multiple places, notably in GStreamer:
>=20
> https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/blob/master/sys/=
kms/gstkmsutils.c#L45
>=20

I do sort-of wonder if it's worth trying to switch to common fourccs
between DRM and V4L2 (and whatever else there is).

The V4L2 formats list is quite incomplete and a little quirky in
places (V4L2_PIX_FORMAT_XBGR32 and V4L2_PIX_FORMAT_XRGB32 naming
inconsistency being one. 'X' isn't even next to 'B' in XBGR32).

At least for newly-added formats, not using a common definition
doesn't make a lot of sense to me. Longer term, I also don't really
see any downsides to unification.

-Brian
