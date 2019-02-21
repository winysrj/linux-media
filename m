Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F81CC43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 13:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 082D82080F
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 13:45:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="nQ3l0zps"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfBUNpA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 08:45:00 -0500
Received: from mail-eopbgr150052.outbound.protection.outlook.com ([40.107.15.52]:19635
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725820AbfBUNpA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 08:45:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector1-arm-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LhEbkI7o0mw7ScnxRcxyjXDT7liGWSx537E0gc0N8UA=;
 b=nQ3l0zps+CkhBCE7EA0ACOIzbI90tVw4VD3LwGaVM3FWQ8nTywebXSZPiAuB1e07NUauk/VQ4vDVt5GgCD0QS4J+DfK4T4kL7lHwhHtR/AKrMcBACztlohY+t8R3ZXwvlM3rZBuRxexUM/SsOpx7oGvOpJmiwN/MXuYlEJgd6Pc=
Received: from AM0PR08MB3025.eurprd08.prod.outlook.com (52.134.93.10) by
 AM0PR08MB3873.eurprd08.prod.outlook.com (20.178.83.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.14; Thu, 21 Feb 2019 13:44:56 +0000
Received: from AM0PR08MB3025.eurprd08.prod.outlook.com
 ([fe80::7e:6dfb:116b:befd]) by AM0PR08MB3025.eurprd08.prod.outlook.com
 ([fe80::7e:6dfb:116b:befd%2]) with mapi id 15.20.1643.016; Thu, 21 Feb 2019
 13:44:56 +0000
From:   Brian Starkey <Brian.Starkey@arm.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, nd <nd@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 0/7] VSP1: Display writeback support
Thread-Topic: [PATCH v4 0/7] VSP1: Display writeback support
Thread-Index: AQHUx4SuF0wk/rt+2UuytgV1PyNhIaXp7lqAgAAYUYCAAAOIgIAAJhOAgAABGgCAABbZAA==
Date:   Thu, 21 Feb 2019 13:44:56 +0000
Message-ID: <20190221134456.ahwo7xt3wcfc6zkw@DESKTOP-E1NTVVP.localdomain>
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190218122257.o5blxfs7jo5xu7ge@DESKTOP-E1NTVVP.localdomain>
 <20190221082317.GB3451@pendragon.ideasonboard.com>
 <20190221095019.rht64aylk52jqe5r@DESKTOP-E1NTVVP.localdomain>
 <20190221100257.GD3451@pendragon.ideasonboard.com>
 <20190221121913.l7e5zlitcfpvkupi@DESKTOP-E1NTVVP.localdomain>
 <20190221122310.GM3451@pendragon.ideasonboard.com>
In-Reply-To: <20190221122310.GM3451@pendragon.ideasonboard.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: NeoMutt/20180716-849-147d51-dirty
x-originating-ip: [217.140.106.51]
x-clientproxiedby: LO2P265CA0166.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::34) To AM0PR08MB3025.eurprd08.prod.outlook.com
 (2603:10a6:208:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Brian.Starkey@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 094b5727-58ea-41d3-6e98-08d69802c3ba
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605104)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:AM0PR08MB3873;
x-ms-traffictypediagnostic: AM0PR08MB3873:
nodisclaimer: True
x-microsoft-exchange-diagnostics: 1;AM0PR08MB3873;20:E2qOmYLBgqlTNs2pbTJbxC+qMcgCMZYS393nMLqtTK6XrSt8M8wngZ7NZ+V/PV+lQgCfUOgZK96Ynnl5Kfj68CdRVdapE2y4qdOhaRfDNwkKWTjVjOet+wg3dxbnPqloPrcdSb4TzkwZR1bDiZDHwrYWP3xiG6tCIUYoxH94Ruc=
x-microsoft-antispam-prvs: <AM0PR08MB38738503A57DC779480AF6F4F07E0@AM0PR08MB3873.eurprd08.prod.outlook.com>
x-forefront-prvs: 09555FB1AD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(366004)(346002)(39860400002)(376002)(189003)(199004)(68736007)(86362001)(3846002)(5660300002)(81156014)(9686003)(6512007)(2906002)(316002)(229853002)(6116002)(6246003)(71190400001)(93886005)(71200400001)(8676002)(305945005)(66066001)(97736004)(6436002)(54906003)(81166006)(8936002)(53936002)(58126008)(7736002)(14454004)(6916009)(486006)(44832011)(256004)(33896004)(105586002)(102836004)(4326008)(11346002)(476003)(386003)(1076003)(99286004)(76176011)(6486002)(478600001)(446003)(186003)(26005)(72206003)(52116002)(25786009)(106356001)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR08MB3873;H:AM0PR08MB3025.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gKmlO9gYKLu1vQXi57sf5cg2oWYmnnWdzpdYqBsrZp1DtxFD9Nu1MxT8M9WlUzQa8WZDCCfu+1n42MV9YcnQtZEgODWXqsV/+vYN6fWmKu1vC72dVz5OQHyo/DV0yq37UpXxvmEq4IqAH5aWeNy4SGFXePo1/c5OMIi/zMbdLJ3BtAEQ2sOEDU/NyNpP2uleHcyGrT3k5lfV2EvgjwYxu/+7f87y/AgcrcUvg3jESzMCrKg1GMU5AvyI1LbtMnwUkmJgC6wU+I9Zj75Oo5Bhi79XkR3FvZIr9Vx0hL9HlUlW3wmgtlFgpyGWnOWrJgHublBRVdFoWu3/FwA9r+zup8yRQWAqH97mmDzf118dcdYTgnHX92n7Xc4bLwyDtKBx+Vjjg3WdPB9mEm8j//hzIf041S6lIckY2Rl/CiKK4J0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8D01D33DD59DF542A3F05AE826C43507@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 094b5727-58ea-41d3-6e98-08d69802c3ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2019 13:44:55.9024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3873
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Feb 21, 2019 at 02:23:10PM +0200, Laurent Pinchart wrote:
> On Thu, Feb 21, 2019 at 12:19:13PM +0000, Brian Starkey wrote:

[snip]

> >=20
> > I used a pre-existing internal tool which does exactly that.
>=20
> Any hope of sharing the sources ?
>=20

Not in a timescale or form which would be useful to you. I'm convinced
people only ask questions like this to make us look like Bad Guys.

Opening everything up is a process, and it's going to take us time.
Sure we could be doing better, but I also think there's a lot of
people who do worse.

> > I appreciate that we don't have upstream tooling for writeback. As you
> > say, it's a young API (well, not by date, but certainly by usage).
> >=20
> > I also do appreciate you taking the time to consider it, identifying
> > issues which we did not, and for fixing them. The only way it stops
> > being a young API, with bugs and no tooling, is if people adopt it.
>=20
> If the developers who initially pushed the API upstream without an
> open-source test tool could spend a bit of time on this issue, I'm sure
> it would help too :-)
>=20

No one suggested a test test tool before. In fact, the DRM subsystem
explicitly requires that features land with something that isn't only
a test tool, hence why we did drm_hwcomposer.

That said, yes, we should be trying harder to get the igts landed. I
personally think igts are far more useful than a random example C
file, but I guess opinions differ.

Thanks,
-Brian

