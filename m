Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B79C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 19:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8482C20811
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 19:55:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="R4FgDhEa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfCVTzY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 15:55:24 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34060 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfCVTzX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 15:55:23 -0400
Received: by mail-qt1-f196.google.com with SMTP id k2so3955445qtm.1
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 12:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=N67rREYb2aXcg7WOCkt5fx+noFLEqIZXpws/cLUl3BI=;
        b=R4FgDhEaF3AZQPcAklQm3V/diqfy7WTkzhlZHuGXOVn+iJxMF6fKkIyDdw9f5VGguW
         Fu/6rBvgXg3u7K3FdU7doKAFKqpsnRg54Ce03d1hyPdDuZ3SoFuofDQWmSOv5BRq7n1i
         EX8GzjKE/34gVC72ZUr+Lh4E+qkkf8cYWY1dqx7h1RAEUR3pH3lZkqZArTxafJ9GbMYQ
         zIDrrueDNNTdoApTRds9cD+7JymTTJIBAC4Nv8BK9ia8PTyaOx1zIhGBszjzX/cULrq8
         WxhDm0TaFP9hRTMwbleW2RlMbVkyIOAJ3L8cNKLUpX4yVGpf5zB0kP1qbVVVXsjkXkAb
         rbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=N67rREYb2aXcg7WOCkt5fx+noFLEqIZXpws/cLUl3BI=;
        b=c9jgDDGDb2MiOYOBBFZuw8JQuPguDn43tKRctiGqBC1Z6AwFYMHfxoAjgThFx8i6BE
         kZraHBbKsOghXhkZAg6CnyNkD068RYd8c/EcmM0opM75fiMsqLMkuBn2bEn5Ir07FB4b
         ZBpa0xDlZgWYg0ME1Yn7sUG/yzo6o+EqXxG0eF8Cebn9YyZjzpRSiX2UFw7OdsFFuUKG
         ZOXXG3+mff7MDRhyfUtGHIQxuGTpTtcR1zrMlqXw3TsHRzn0odPsGa73o4u711x/Z6eO
         R42K4S7+BLuExfJzV+iA7LWv3c7/pFcM/xGe0aYm0dwZQ7/4ueeTCQpSrD7soKHczS9W
         Q7jA==
X-Gm-Message-State: APjAAAW4McemGOEomEosFp0BFJi4JVlm8YzD4A1zZMMYlOp+gHkgn2qR
        6ysFouq3OGS6CIgMg8Fbm+s4ag==
X-Google-Smtp-Source: APXvYqy+cIUN/4hyzzs3H4+p9t+8bkYKQwQ0JLUVJ/4eB9yzalvUIJdoGWD+SoVn/RMRyEYL785bqA==
X-Received: by 2002:aed:2196:: with SMTP id l22mr3144408qtc.226.1553284522314;
        Fri, 22 Mar 2019 12:55:22 -0700 (PDT)
Received: from tpx230-nicolas.collaboramtl (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id b7sm94744qkc.47.2019.03.22.12.55.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Mar 2019 12:55:21 -0700 (PDT)
Message-ID: <3f5748a6422d2f7eb11601bad297df870ff5952b.camel@ndufresne.ca>
Subject: Re: [RFC PATCH 18/20] lib: image-formats: Add v4l2 formats support
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Date:   Fri, 22 Mar 2019 15:55:19 -0400
In-Reply-To: <c97024b97d3261dcf41aad3c8bc1c5d9906f33c9.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
         <c97024b97d3261dcf41aad3c8bc1c5d9906f33c9.1553032382.git-series.maxime.ripard@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-lgGHCZmKDxf7z1lRmaPQ"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-lgGHCZmKDxf7z1lRmaPQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 19 mars 2019 =C3=A0 22:57 +0100, Maxime Ripard a =C3=A9crit :
> V4L2 uses different fourcc's than DRM, and has a different set of formats=
.
> For now, let's add the v4l2 fourcc's for the already existing formats.

Hopefully I get the fixup right this time, see inline.

>=20
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  include/linux/image-formats.h |  9 +++++-
>  lib/image-formats.c           | 67 ++++++++++++++++++++++++++++++++++++-
>  2 files changed, 76 insertions(+)
>=20
> diff --git a/include/linux/image-formats.h b/include/linux/image-formats.=
h
> index 53fd73a71b3d..fbc3a4501ebd 100644
> --- a/include/linux/image-formats.h
> +++ b/include/linux/image-formats.h
> @@ -26,6 +26,13 @@ struct image_format_info {
>  	};
> =20
>  	/**
> +	 * @v4l2_fmt:
> +	 *
> +	 * V4L2 4CC format identifier (V4L2_PIX_FMT_*)
> +	 */
> +	u32 v4l2_fmt;
> +
> +	/**
>  	 * @depth:
>  	 *
>  	 * Color depth (number of bits per pixel excluding padding bits),
> @@ -222,6 +229,8 @@ image_format_info_is_yuv_sampling_444(const struct im=
age_format_info *info)
> =20
>  const struct image_format_info *__image_format_drm_lookup(u32 drm);
>  const struct image_format_info *image_format_drm_lookup(u32 drm);
> +const struct image_format_info *__image_format_v4l2_lookup(u32 v4l2);
> +const struct image_format_info *image_format_v4l2_lookup(u32 v4l2);
>  unsigned int image_format_plane_cpp(const struct image_format_info *form=
at,
>  				    int plane);
>  unsigned int image_format_plane_width(int width,
> diff --git a/lib/image-formats.c b/lib/image-formats.c
> index 9b9a73220c5d..39f1d38ae861 100644
> --- a/lib/image-formats.c
> +++ b/lib/image-formats.c
> @@ -8,6 +8,7 @@
>  static const struct image_format_info formats[] =3D {
>  	{
>  		.drm_fmt =3D DRM_FORMAT_C8,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_GREY,
>  		.depth =3D 8,
>  		.num_planes =3D 1,
>  		.cpp =3D { 1, 0, 0 },
> @@ -15,6 +16,7 @@ static const struct image_format_info formats[] =3D {
>  		.vsub =3D 1,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_RGB332,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_RGB332,
>  		.depth =3D 8,
>  		.num_planes =3D 1,
>  		.cpp =3D { 1, 0, 0 },
> @@ -29,6 +31,7 @@ static const struct image_format_info formats[] =3D {
>  		.vsub =3D 1,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_XRGB4444,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_XRGB444,

Not completely sure, looks like in the V4L2 variant, the padding is on
the 4 MSB of the second byte, which makes it incompatible. There is no
other equivalent.

>  		.depth =3D 0,
>  		.num_planes =3D 1,
>  		.cpp =3D { 2, 0, 0 },
> @@ -57,6 +60,7 @@ static const struct image_format_info formats[] =3D {
>  		.vsub =3D 1,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_ARGB4444,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_ARGB444,

Similarly.

>  		.depth =3D 0,
>  		.num_planes =3D 1,
>  		.cpp =3D { 2, 0, 0 },
> @@ -89,6 +93,7 @@ static const struct image_format_info formats[] =3D {
>  		.has_alpha =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_XRGB1555,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_XRGB555,

Same swapping, can't find a match.

>  		.depth =3D 15,
>  		.num_planes =3D 1,
>  		.cpp =3D { 2, 0, 0 },
> @@ -117,6 +122,7 @@ static const struct image_format_info formats[] =3D {
>  		.vsub =3D 1,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_ARGB1555,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_ARGB555,

Same.

>  		.depth =3D 15,
>  		.num_planes =3D 1,
>  		.cpp =3D { 2, 0, 0 },
> @@ -149,6 +155,7 @@ static const struct image_format_info formats[] =3D {
>  		.has_alpha =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_RGB565,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_RGB565,

-> V4L2_PIX_FMT_RGB565X

Was added later, as what you expect is not compatible.

>  		.depth =3D 16,
>  		.num_planes =3D 1,
>  		.cpp =3D { 2, 0, 0 },
> @@ -163,6 +170,7 @@ static const struct image_format_info formats[] =3D {
>  		.vsub =3D 1,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_RGB888,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_RGB24,

-> V4L2_PIX_FMT_BGR24

>  		.depth =3D 24,
>  		.num_planes =3D 1,
>  		.cpp =3D { 3, 0, 0 },
> @@ -170,6 +178,7 @@ static const struct image_format_info formats[] =3D {
>  		.vsub =3D 1,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_BGR888,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_BGR24,

-> V4L2_PIX_FMT_RGB24

>  		.depth =3D 24,
>  		.num_planes =3D 1,
>  		.cpp =3D { 3, 0, 0 },
> @@ -177,6 +186,7 @@ static const struct image_format_info formats[] =3D {
>  		.vsub =3D 1,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_XRGB8888,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_XRGB32,

-> V4L2_PIX_FMT_XBGR32

>  		.depth =3D 24,
>  		.num_planes =3D 1,
>  		.cpp =3D { 4, 0, 0 },
> @@ -281,6 +291,7 @@ static const struct image_format_info formats[] =3D {
>  		.has_alpha =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_ARGB8888,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_ARGB32,

-> V4L2_PIX_FMT_ABGR32

>  		.depth =3D 32,
>  		.num_planes =3D 1,
>  		.cpp =3D { 4, 0, 0 },
> @@ -361,6 +372,7 @@ static const struct image_format_info formats[] =3D {
>  		.has_alpha =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_YUV410,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_YUV410,
>  		.depth =3D 0,
>  		.num_planes =3D 3,
>  		.cpp =3D { 1, 1, 1 },
> @@ -369,6 +381,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_YVU410,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_YVU410,
>  		.depth =3D 0,
>  		.num_planes =3D 3,
>  		.cpp =3D { 1, 1, 1 },
> @@ -393,6 +406,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_YUV420,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_YUV420M,

There is two valid matches in V4L2 for this format, not sure how this
will be handled. The M variant is to be used with MPLANE v4l2_buffer
when num_planes is bigger then 1.

>  		.depth =3D 0,
>  		.num_planes =3D 3,
>  		.cpp =3D { 1, 1, 1 },
> @@ -401,6 +415,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_YVU420,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_YVU420M,

Same.

>  		.depth =3D 0,
>  		.num_planes =3D 3,
>  		.cpp =3D { 1, 1, 1 },
> @@ -409,6 +424,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_YUV422,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_YUV422M,

Same.

>  		.depth =3D 0,
>  		.num_planes =3D 3,
>  		.cpp =3D { 1, 1, 1 },
> @@ -417,6 +433,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_YVU422,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_YVU422M,

Same.=20

>  		.depth =3D 0,
>  		.num_planes =3D 3,
>  		.cpp =3D { 1, 1, 1 },
> @@ -425,6 +442,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_YUV444,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_YUV444M,

Same.

>  		.depth =3D 0,
>  		.num_planes =3D 3,
>  		.cpp =3D { 1, 1, 1 },
> @@ -433,6 +451,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_YVU444,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_YVU444M,

Same.

>  		.depth =3D 0,
>  		.num_planes =3D 3,
>  		.cpp =3D { 1, 1, 1 },
> @@ -441,6 +460,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_NV12,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_NV12,

V4L2_PIX_FMT_NV12M is the mplane variant. Depending on how you handle,
which should be concistant picking one up.

>  		.depth =3D 0,
>  		.num_planes =3D 2,
>  		.cpp =3D { 1, 2, 0 },
> @@ -449,6 +469,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_NV21,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_NV21,

Same, NV12M for mplane.

>  		.depth =3D 0,
>  		.num_planes =3D 2,
>  		.cpp =3D { 1, 2, 0 },
> @@ -457,6 +478,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_NV16,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_NV16,

Same, NV16M.

>  		.depth =3D 0,
>  		.num_planes =3D 2,
>  		.cpp =3D { 1, 2, 0 },
> @@ -465,6 +487,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_NV61,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_NV61,

Same, NV61M.

>  		.depth =3D 0,
>  		.num_planes =3D 2,
>  		.cpp =3D { 1, 2, 0 },
> @@ -473,6 +496,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_NV24,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_NV24,

For extra fun, the M variant has not been added yet.

>  		.depth =3D 0,
>  		.num_planes =3D 2,
>  		.cpp =3D { 1, 2, 0 },
> @@ -481,6 +505,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_NV42,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_NV42,
>  		.depth =3D 0,
>  		.num_planes =3D 2,
>  		.cpp =3D { 1, 2, 0 },
> @@ -489,6 +514,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_YUYV,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_YUYV,
>  		.depth =3D 0,
>  		.num_planes =3D 1,
>  		.cpp =3D { 2, 0, 0 },
> @@ -497,6 +523,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_YVYU,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_YVYU,
>  		.depth =3D 0,
>  		.num_planes =3D 1,
>  		.cpp =3D { 2, 0, 0 },
> @@ -505,6 +532,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_UYVY,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_UYVY,
>  		.depth =3D 0,
>  		.num_planes =3D 1,
>  		.cpp =3D { 2, 0, 0 },
> @@ -513,6 +541,7 @@ static const struct image_format_info formats[] =3D {
>  		.is_yuv =3D true,
>  	}, {
>  		.drm_fmt =3D DRM_FORMAT_VYUY,
> +		.v4l2_fmt =3D V4L2_PIX_FMT_VYUY,
>  		.depth =3D 0,
>  		.num_planes =3D 1,
>  		.cpp =3D { 2, 0, 0 },
> @@ -632,6 +661,44 @@ const struct image_format_info *image_format_drm_loo=
kup(u32 drm)
>  EXPORT_SYMBOL(image_format_drm_lookup);
> =20
>  /**
> + * __image_format_v4l2_lookup - query information for a given format
> + * @v4l2: V4L2 fourcc pixel format (V4L2_PIX_FMT_*)
> + *
> + * The caller should only pass a supported pixel format to this function=
.
> + *
> + * Returns:
> + * The instance of struct image_format_info that describes the pixel for=
mat, or
> + * NULL if the format is unsupported.
> + */
> +const struct image_format_info *__image_format_v4l2_lookup(u32 v4l2)
> +{
> +	return __image_format_lookup(v4l2_fmt, v4l2);
> +}
> +EXPORT_SYMBOL(__image_format_v4l2_lookup);
> +
> +/**
> + * image_format_v4l2_lookup - query information for a given format
> + * @v4l2: V4L2 fourcc pixel format (V4L2_PIX_FMT_*)
> + *
> + * The caller should only pass a supported pixel format to this function=
.
> + * Unsupported pixel formats will generate a warning in the kernel log.
> + *
> + * Returns:
> + * The instance of struct image_format_info that describes the pixel for=
mat, or
> + * NULL if the format is unsupported.
> + */
> +const struct image_format_info *image_format_v4l2_lookup(u32 v4l2)
> +{
> +	const struct image_format_info *format;
> +
> +	format =3D __image_format_v4l2_lookup(v4l2);
> +
> +	WARN_ON(!format);
> +	return format;
> +}
> +EXPORT_SYMBOL(image_format_v4l2_lookup);
> +
> +/**
>   * image_format_plane_cpp - determine the bytes per pixel value
>   * @format: pointer to the image_format
>   * @plane: plane index

--=-lgGHCZmKDxf7z1lRmaPQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXJU9pwAKCRBxUwItrAao
HOvPAJ0ezleNOa2YxDzZWkAnsXXQvVKSZwCfRzb7eXLMY9gJTtJR0ebGE08nqRA=
=mmqS
-----END PGP SIGNATURE-----

--=-lgGHCZmKDxf7z1lRmaPQ--

