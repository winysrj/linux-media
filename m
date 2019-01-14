Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED26DC43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 16:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A94F9206B7
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 16:36:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="cDObTmqU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfANQgv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 11:36:51 -0500
Received: from mail-eopbgr50058.outbound.protection.outlook.com ([40.107.5.58]:11303
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726898AbfANQgv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 11:36:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector1-arm-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=niqEsVk4iCjsv6oeZbMugmvHS6LuvwOmzdJRnM2uTsE=;
 b=cDObTmqUY+XXjC3lN6tWuXvoGi2TBwi+XUSkFehgXfAqjhyYchh4c2Qw4cmHdDT5+Gs4FommWBiVTmUhT/oh1sdfsUGRNU/UyG0R1HQrdeJgylL3cjd4JHpBz5eMM+wOovdvF+P9BpRjlF7qSi2nm1cPtkFbpZVvyQL+p8fMiQQ=
Received: from AM0PR08MB3891.eurprd08.prod.outlook.com (20.178.82.147) by
 AM0PR08MB4257.eurprd08.prod.outlook.com (20.179.32.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.14; Mon, 14 Jan 2019 16:36:46 +0000
Received: from AM0PR08MB3891.eurprd08.prod.outlook.com
 ([fe80::39a3:457f:3d5e:84ff]) by AM0PR08MB3891.eurprd08.prod.outlook.com
 ([fe80::39a3:457f:3d5e:84ff%3]) with mapi id 15.20.1516.019; Mon, 14 Jan 2019
 16:36:46 +0000
From:   Ayan Halder <Ayan.Halder@arm.com>
To:     Randy Li <ayaka@soulik.info>
CC:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikhail.v.gavrilov@gmail.com" <mikhail.v.gavrilov@gmail.com>,
        "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "sean@poorly.run" <sean@poorly.run>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        nd <nd@arm.com>
Subject: Re: [PATCH v10 1/2] drm/fourcc: Add new P010, P016 video format
Thread-Topic: [PATCH v10 1/2] drm/fourcc: Add new P010, P016 video format
Thread-Index: AQHUqL9gEnx4T6VG8k+CSpcvb0pQRKWu/S2A
Date:   Mon, 14 Jan 2019 16:36:46 +0000
Message-ID: <20190114163645.GA16349@arm.com>
References: <20190109195710.28501-1-ayaka@soulik.info>
 <20190109195710.28501-2-ayaka@soulik.info>
In-Reply-To: <20190109195710.28501-2-ayaka@soulik.info>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0123.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::15) To AM0PR08MB3891.eurprd08.prod.outlook.com
 (2603:10a6:208:109::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.140.106.53]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR08MB4257;6:RFU7TCy6uWf7P5Cs0vwruHnQGmr5koNGdKDnAqum9FqdRpTsWbqwHZe00h2Bi6nnSLmUsyamjek5YYLy981CW9yTDQhh7tyXGxmJ5PccaV/2pBQGgwgSVbfDVWHysfgGkA05ZE4GP1cbV3qoqtjQ4F+pSOLswDZTBKiZ+2MIwXSew4tXKQe5ujRZSUuqTWTjVG1/rZlQCvz4CO46ap5Pw5Vg816Ew6EzBtmlaqQiAM/qusR20EHLZLzt4/VtPIzHyV1IVmwAmTHb4aEaXk1XCYr4/ftdXCzMBpiXNE/aTgSnqDSYVq5r+jQk3nl8nvOWbZInM2n2NVyIh7FRJrmc0Bv4yVwML38jr9YIRNwmp2nIYO7XERynK6nsInfmR1VNe5PkOo/B2qBaFMVsqLpQCLp5LE309ZXt861yC8zjhd3WC3ZdJWyCePMQr1Oluy06H/Ta7w/XpH2fJgzzAGhs8A==;5:FF5ZXaAyJdjG0y3DTMckHIDsT6CoCSccsRRCplLGxq3cGV/6185tPHXz/gqGo/WADMcrJG7nuTfFKNBfuLjt93gYcAvDzlre463iTcZT5U2iZ1blABYBlkwc64v9c6tDNhJy3taniaNePJpi7FpoG/iE4j4/V5jty4nKaJX5O0jKQKOTmmMdJMygU/wFbHSu5aEZeyttbYbTqj4+W61iWA==;7:+gqYB0ZEzB2FD+ZGuDVBCR2pNigmu2hkQzRWMpagnXjaEFSAf22Uh4WHA7mHc77JIvIJsJfeI4VqWVi7ccFfWKF/GMTzH/wM5wkbQiWybu/0IgZp+e59ojNIS6YDG2wSjA75+MkN8ArHi6ziLztVKg==
x-ms-office365-filtering-correlation-id: f28826ca-90d1-483a-f891-08d67a3e793e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR08MB4257;
x-ms-traffictypediagnostic: AM0PR08MB4257:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ayan.Halder@arm.com; 
nodisclaimer: True
x-microsoft-antispam-prvs: <AM0PR08MB4257A3BCF204B948131B7A5EE4800@AM0PR08MB4257.eurprd08.prod.outlook.com>
x-forefront-prvs: 0917DFAC67
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(39860400002)(376002)(366004)(346002)(199004)(189003)(6436002)(68736007)(7416002)(7736002)(305945005)(186003)(2616005)(476003)(11346002)(575784001)(446003)(86362001)(66066001)(14444005)(256004)(81156014)(8936002)(6916009)(6486002)(8676002)(81166006)(36756003)(229853002)(5660300001)(97736004)(54906003)(71200400001)(486006)(71190400001)(316002)(25786009)(44832011)(99286004)(106356001)(105586002)(966005)(1076003)(72206003)(6512007)(76176011)(6116002)(3846002)(6506007)(386003)(26005)(6306002)(102836004)(53936002)(478600001)(52116002)(2906002)(4326008)(6246003)(33656002)(39060400002)(14454004)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR08MB4257;H:AM0PR08MB3891.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oYa64PcxhPgujEwVjgc9Bes7cqSk9y8lAZ2ViOySWnU1oFSF8nCigERdg7VC5wdtMZ61o6eQ/D873xI6X59koRClCmZYKnci0NSpKm7rEWJSKPI/5dIwmGQI+Z2iOoHyVp762FJpHNJPyfT+6TH+mI18+F5JiGKlbR7XmCtcWD9bl34e4NqNmWjmv7dlo8FtiX4bhgtjRvKQ1cxrgihkn1oJvJ+uMLsd/ZGksSO7x58JeTBEUeM/a0HWnDNknWFt4WiKUOM3vXnbRSht+03nlDzHtqUYw8hv2pS393NCfrDX4PZDep2Dq+6ZeNsXOmzZxm65xK3/zR/roh2mGyfOPmBs5uRfklkb9aY29CqV5PsMLK3+8Z+Z8YAA+jTzX6KEvKc+YWPLPUWXHZ3LMTN/szJG9UaFU+FT9kvXM52q5aw=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EA93FBA4520CF8428E0B0D7CAC142AAD@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f28826ca-90d1-483a-f891-08d67a3e793e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2019 16:36:45.9914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4257
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Jan 10, 2019 at 03:57:09AM +0800, Randy Li wrote:
> P010 is a planar 4:2:0 YUV with interleaved UV plane, 10 bits per
> channel video format.
>=20
> P012 is a planar 4:2:0 YUV 12 bits per channel
>=20
> P016 is a planar 4:2:0 YUV with interleaved UV plane, 16 bits per
> channel video format.
>=20
> V3: Added P012 and fixed cpp for P010.
> V4: format definition refined per review.
> V5: Format comment block for each new pixel format.
> V6: reversed Cb/Cr order in comments.
> v7: reversed Cb/Cr order in comments of header files, remove
> the wrong part of commit message.
> V8: reversed V7 changes except commit message and rebased.
> v9: used the new properties to describe those format and
> rebased.
>=20
> Cc: Daniel Stone <daniel@fooishbar.org>
> Cc: Ville Syrj??l?? <ville.syrjala@linux.intel.com>
>=20
> Signed-off-by: Randy Li <ayaka@soulik.info>
> Signed-off-by: Clint Taylor <clinton.a.taylor@intel.com>
> ---
>  drivers/gpu/drm/drm_fourcc.c  |  9 +++++++++
>  include/uapi/drm/drm_fourcc.h | 21 +++++++++++++++++++++
>  2 files changed, 30 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
> index d90ee03a84c6..ba7e19d4336c 100644
> --- a/drivers/gpu/drm/drm_fourcc.c
> +++ b/drivers/gpu/drm/drm_fourcc.c
> @@ -238,6 +238,15 @@ const struct drm_format_info *__drm_format_info(u32 =
format)
>  		{ .format =3D DRM_FORMAT_X0L2,		.depth =3D 0,  .num_planes =3D 1,
>  		  .char_per_block =3D { 8, 0, 0 }, .block_w =3D { 2, 0, 0 }, .block_h =
=3D { 2, 0, 0 },
>  		  .hsub =3D 2, .vsub =3D 2, .is_yuv =3D true },
> +		{ .format =3D DRM_FORMAT_P010,            .depth =3D 0,  .num_planes =
=3D 2,
> +		  .char_per_block =3D { 2, 4, 0 }, .block_w =3D { 1, 0, 0 }, .block_h =
=3D { 1, 0, 0 },
> +		  .hsub =3D 2, .vsub =3D 2, .is_yuv =3D true},
> +		{ .format =3D DRM_FORMAT_P012,		.depth =3D 0,  .num_planes =3D 2,
> +		  .char_per_block =3D { 2, 4, 0 }, .block_w =3D { 1, 0, 0 }, .block_h =
=3D { 1, 0, 0 },
> +		   .hsub =3D 2, .vsub =3D 2, .is_yuv =3D true},
> +		{ .format =3D DRM_FORMAT_P016,		.depth =3D 0,  .num_planes =3D 2,
> +		  .char_per_block =3D { 2, 4, 0 }, .block_w =3D { 1, 0, 0 }, .block_h =
=3D { 1, 0, 0 },
> +		  .hsub =3D 2, .vsub =3D 2, .is_yuv =3D true},
>  	};
> =20
>  	unsigned int i;
> diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.=
h
> index 0b44260a5ee9..8dd1328bc8d6 100644
> --- a/include/uapi/drm/drm_fourcc.h
> +++ b/include/uapi/drm/drm_fourcc.h
> @@ -195,6 +195,27 @@ extern "C" {
>  #define DRM_FORMAT_NV24		fourcc_code('N', 'V', '2', '4') /* non-subsampl=
ed Cr:Cb plane */
>  #define DRM_FORMAT_NV42		fourcc_code('N', 'V', '4', '2') /* non-subsampl=
ed Cb:Cr plane */
> =20
> +/*
> + * 2 plane YCbCr MSB aligned
> + * index 0 =3D Y plane, [15:0] Y:x [10:6] little endian
> + * index 1 =3D Cr:Cb plane, [31:0] Cr:x:Cb:x [10:6:10:6] little endian
> + */
> +#define DRM_FORMAT_P010		fourcc_code('P', '0', '1', '0') /* 2x2 subsampl=
ed Cr:Cb plane 10 bits per channel */
> +
> +/*
> + * 2 plane YCbCr MSB aligned
> + * index 0 =3D Y plane, [15:0] Y:x [12:4] little endian
> + * index 1 =3D Cr:Cb plane, [31:0] Cr:x:Cb:x [12:4:12:4] little endian
> + */
> +#define DRM_FORMAT_P012		fourcc_code('P', '0', '1', '2') /* 2x2 subsampl=
ed Cr:Cb plane 12 bits per channel */
> +
> +/*
> + * 2 plane YCbCr MSB aligned
> + * index 0 =3D Y plane, [15:0] Y little endian
> + * index 1 =3D Cr:Cb plane, [31:0] Cr:Cb [16:16] little endian
> + */
> +#define DRM_FORMAT_P016		fourcc_code('P', '0', '1', '6') /* 2x2 subsampl=
ed Cr:Cb plane 16 bits per channel */
> +

looks good to me.
Reviewed by:- Ayan Kumar Halder <ayan.halder@arm.com>

We are using P010 format for our mali display driver. Our AFBC patch
series(https://patchwork.freedesktop.org/series/53395/) is dependent
on this patch. So, that's why I wanted to know when you are planning to
merge this. As far as I remember, Juha wanted to implement some igt
tests
(https://lists.freedesktop.org/archives/intel-gfx/2018-September/174877.htm=
l)
, so is that done now?

My apologies if I am pushing hard on this.
>  /*
>   * 3 plane YCbCr
>   * index 0: Y plane, [7:0] Y
> --=20
> 2.20.1
>=20
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
