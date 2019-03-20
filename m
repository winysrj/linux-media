Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E83C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 18:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 768122184D
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 18:28:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="zZhK1ORq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfCTS2E (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 14:28:04 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43208 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfCTS2D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 14:28:03 -0400
Received: by mail-qk1-f194.google.com with SMTP id c20so9991091qkc.10
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 11:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=BVx8tPcbjfhYBzaARFvYSZ2y37yTwM2JUdWJ9yMeGG8=;
        b=zZhK1ORqyR1SthzxK9JoQKRezG1pfb4NSnDRdWHnLuIlOHFAaeBVpAezVNd7ieM+iI
         VkvxnpjrY1LzWequyberiFjKxWFTlyaOvEr+7VHgWg9EDSclvaOflUmeHcC6o3ty9Psj
         lNthZYZXlLY4Bh+ujNx7mH+t4K+QmbAzR8iZJnz0cMc6txJYfN0GVq6RpTX0Tk927M4a
         CYx/UH49D8n02G68mNTXoJN1NVI6pW2OgBgUj3SJfV40WORScyEpu6+OpJZJpPt+lz+D
         Gj9H+DuOSl1ohZ0z56jvE3DlSA2XpLA5Bp86bLBzawauRRcGLjpyrZHRElpu+zxORSmj
         q5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=BVx8tPcbjfhYBzaARFvYSZ2y37yTwM2JUdWJ9yMeGG8=;
        b=ps/ARTDZVbSY8LkP1IoSaMq7nJGSYNI7JjrwNASsgk6FXOnxcYCRfDwt0ZOS6kgUvo
         3pTOX0T45k2IdnFBDHkfy+fpdDzsg3d5XwJkqkdTOw1abxkYXNTqEVpJEFNBDxHBQvlb
         3VhUtOlbQUM/j6mIU41ohiSLmcFFC5Fa+ehW2n2xPkcUWJAjnLTFG1ct9McP4UYof0GF
         ChOd5vvoullT1BmFqR1y8yLd+Rhp7sqYO9GE9/8cgO5ixZpBoC/EU114hD+aIMtcFXe9
         jnmugobzXrKrcNWkgceM2iHoY5+PP0Ll/2RwvCVrY+mTHxsUi8zc5Qto6jY0yoqWhVlV
         UqJQ==
X-Gm-Message-State: APjAAAUY8GYIrJIK2xFNvjHyELgKhzeEpqFxRtOIWdvdaqE136PfuVbP
        wyRaf7rf7sJ4qJlf/tDA6d3+cQ==
X-Google-Smtp-Source: APXvYqxiFOk/knPNw/LWY5pGObiHp4g9N9hitw7bpcpaAGypFnPxh6xtA39nLYwK3NZRvrmIipjvnQ==
X-Received: by 2002:ae9:e518:: with SMTP id w24mr7893130qkf.4.1553106482216;
        Wed, 20 Mar 2019 11:28:02 -0700 (PDT)
Received: from tpx230-nicolas.collaboramtl (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id w37sm1783377qtw.27.2019.03.20.11.28.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Mar 2019 11:28:01 -0700 (PDT)
Message-ID: <d46b30ca8962d3c31b1273cf010ca9fb7b145fe8.camel@ndufresne.ca>
Subject: Re: [RFC PATCH 18/20] lib: image-formats: Add v4l2 formats support
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-media@vger.kernel.org, Daniel Stone <daniels@collabora.com>
Date:   Wed, 20 Mar 2019 14:27:59 -0400
In-Reply-To: <20190320164133.GT3888@intel.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
         <c97024b97d3261dcf41aad3c8bc1c5d9906f33c9.1553032382.git-series.maxime.ripard@bootlin.com>
         <d8f4a31e35b1702230ced4a0cb43c10d1c7e60c8.camel@ndufresne.ca>
         <20190320142739.GK3888@intel.com>
         <a13f7fdeaf1a5e97f21a6048da765705b59d64c2.camel@ndufresne.ca>
         <20190320160939.GR3888@intel.com>
         <f3f8749e30aad81bc39ed9b60cd308ac5f3c6707.camel@ndufresne.ca>
         <20190320164133.GT3888@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-noI8eAD4jGJrD0azTXFa"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-noI8eAD4jGJrD0azTXFa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 20 mars 2019 =C3=A0 18:41 +0200, Ville Syrj=C3=A4l=C3=A4 a =C3=
=A9crit :
> On Wed, Mar 20, 2019 at 12:30:25PM -0400, Nicolas Dufresne wrote:
> > Le mercredi 20 mars 2019 =C3=A0 18:09 +0200, Ville Syrj=C3=A4l=C3=A4 a =
=C3=A9crit :
> > > On Wed, Mar 20, 2019 at 11:51:58AM -0400, Nicolas Dufresne wrote:
> > > > Le mercredi 20 mars 2019 =C3=A0 16:27 +0200, Ville Syrj=C3=A4l=C3=
=A4 a =C3=A9crit :
> > > > > On Tue, Mar 19, 2019 at 07:29:18PM -0400, Nicolas Dufresne wrote:
> > > > > > Le mardi 19 mars 2019 =C3=A0 22:57 +0100, Maxime Ripard a =C3=
=A9crit :
> > > > > > > V4L2 uses different fourcc's than DRM, and has a different se=
t of formats.
> > > > > > > For now, let's add the v4l2 fourcc's for the already existing=
 formats.
> > > > > > >=20
> > > > > > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > > > > > ---
> > > > > > >  include/linux/image-formats.h |  9 +++++-
> > > > > > >  lib/image-formats.c           | 67 +++++++++++++++++++++++++=
+++++++++++-
> > > > > > >  2 files changed, 76 insertions(+)
> > > > > > >=20
> > > > > > > diff --git a/include/linux/image-formats.h b/include/linux/im=
age-formats.h
> > > > > > > index 53fd73a71b3d..fbc3a4501ebd 100644
> > > > > > > --- a/include/linux/image-formats.h
> > > > > > > +++ b/include/linux/image-formats.h
> > > > > > > @@ -26,6 +26,13 @@ struct image_format_info {
> > > > > > >  	};
> > > > > > > =20
> > > > > > >  	/**
> > > > > > > +	 * @v4l2_fmt:
> > > > > > > +	 *
> > > > > > > +	 * V4L2 4CC format identifier (V4L2_PIX_FMT_*)
> > > > > > > +	 */
> > > > > > > +	u32 v4l2_fmt;
> > > > > > > +
> > > > > > > +	/**
> > > > > > >  	 * @depth:
> > > > > > >  	 *
> > > > > > >  	 * Color depth (number of bits per pixel excluding padding =
bits),
> > > > > > > @@ -222,6 +229,8 @@ image_format_info_is_yuv_sampling_444(con=
st struct image_format_info *info)
> > > > > > > =20
> > > > > > >  const struct image_format_info *__image_format_drm_lookup(u3=
2 drm);
> > > > > > >  const struct image_format_info *image_format_drm_lookup(u32 =
drm);
> > > > > > > +const struct image_format_info *__image_format_v4l2_lookup(u=
32 v4l2);
> > > > > > > +const struct image_format_info *image_format_v4l2_lookup(u32=
 v4l2);
> > > > > > >  unsigned int image_format_plane_cpp(const struct image_forma=
t_info *format,
> > > > > > >  				    int plane);
> > > > > > >  unsigned int image_format_plane_width(int width,
> > > > > > > diff --git a/lib/image-formats.c b/lib/image-formats.c
> > > > > > > index 9b9a73220c5d..39f1d38ae861 100644
> > > > > > > --- a/lib/image-formats.c
> > > > > > > +++ b/lib/image-formats.c
> > > > > > > @@ -8,6 +8,7 @@
> > > > > > >  static const struct image_format_info formats[] =3D {
> > > > > > >  	{
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_C8,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_GREY,
> > > > > > >  		.depth =3D 8,
> > > > > > >  		.num_planes =3D 1,
> > > > > > >  		.cpp =3D { 1, 0, 0 },
> > > > > > > @@ -15,6 +16,7 @@ static const struct image_format_info forma=
ts[] =3D {
> > > > > > >  		.vsub =3D 1,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_RGB332,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_RGB332,
> > > > > > >  		.depth =3D 8,
> > > > > > >  		.num_planes =3D 1,
> > > > > > >  		.cpp =3D { 1, 0, 0 },
> > > > > > > @@ -29,6 +31,7 @@ static const struct image_format_info forma=
ts[] =3D {
> > > > > > >  		.vsub =3D 1,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_XRGB4444,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_XRGB444,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 1,
> > > > > > >  		.cpp =3D { 2, 0, 0 },
> > > > > > > @@ -57,6 +60,7 @@ static const struct image_format_info forma=
ts[] =3D {
> > > > > > >  		.vsub =3D 1,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_ARGB4444,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_ARGB444,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 1,
> > > > > > >  		.cpp =3D { 2, 0, 0 },
> > > > > > > @@ -89,6 +93,7 @@ static const struct image_format_info forma=
ts[] =3D {
> > > > > > >  		.has_alpha =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_XRGB1555,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_XRGB555,
> > > > > > >  		.depth =3D 15,
> > > > > > >  		.num_planes =3D 1,
> > > > > > >  		.cpp =3D { 2, 0, 0 },
> > > > > > > @@ -117,6 +122,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.vsub =3D 1,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_ARGB1555,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_ARGB555,
> > > > > > >  		.depth =3D 15,
> > > > > > >  		.num_planes =3D 1,
> > > > > > >  		.cpp =3D { 2, 0, 0 },
> > > > > > > @@ -149,6 +155,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.has_alpha =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_RGB565,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_RGB565,
> > > > > > >  		.depth =3D 16,
> > > > > > >  		.num_planes =3D 1,
> > > > > > >  		.cpp =3D { 2, 0, 0 },
> > > > > > > @@ -163,6 +170,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.vsub =3D 1,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_RGB888,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_RGB24,
> > > > > > >  		.depth =3D 24,
> > > > > > >  		.num_planes =3D 1,
> > > > > > >  		.cpp =3D { 3, 0, 0 },
> > > > > > > @@ -170,6 +178,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.vsub =3D 1,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_BGR888,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_BGR24,
> > > > > > >  		.depth =3D 24,
> > > > > > >  		.num_planes =3D 1,
> > > > > > >  		.cpp =3D { 3, 0, 0 },
> > > > > > > @@ -177,6 +186,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.vsub =3D 1,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_XRGB8888,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_XRGB32,
> > > > > >=20
> > > > > > All RGB mapping should be surrounded by ifdef, because many (no=
t all)
> > > > > > DRM formats represent the order of component when placed in a C=
PU
> > > > > > register, unlike V4L2 which uses memory order. I've pick this o=
ne
> > > > >=20
> > > > > DRM formats are explicitly defined as little endian.
> > > >=20
> > > > Yes, that means the same thing. The mapping has nothing to do with =
the
> > > > buffer bytes order, unlike V4L2 (and most streaming stack) do.
> > >=20
> > > It has everything to do with byte order. Little endian means the leas=
t
> > > significant byte is stored in the first byte in memory.
> > >=20
> > > Based on https://www.kernel.org/doc/html/v4.15/media/uapi/v4l/pixfmt-=
packed-rgb.html
> > > drm XRGB888 is actually v4l XBGR32, not XRGB32 as claimed by this pat=
ch.
> >=20
> > That's basically what I said, as it's define for Little Endian rather
> > then buffer order, you have to make the mapping conditional. It
> > basically mean that in memory, the DRM format physically differ
> > depending on CPU endian.
>=20
> No. It is always little endian no matter what the CPU is.

I'm sorry, this is in your ABI, we don't add layers of ifdef in
userspace code just for the fun of it. If you redefine this now you are
breaking userspace. I agree there is very little to no Big Endian on
DRM side anymore, but what historically was mapped per CPU cannot be
changed by you now.

>=20
> > Last time we have run this on PPC / Big
> > Endian, the mapping was XRGB/XRGB, we checked that up multiple time
> > with the DRM maintainers and was told this is exactly what it's suppose
> > to do, hence this endian dependant mapping all over the place. If you
> > make up that this isn't right, you are breaking userspace, and people
> > don't like that.
>=20
> Someone recently added those DRM_FORMAT_HOST variants to allow
> the legacy addfb1 to create pick the format based on host
> endianness. I thought that was the only conclusion from the
> little vs. big endian drm fourcc wars.
>=20
> > So the mapping should be:
> > Little: DRM XRGB / V4L2 XBGR
> > Big:    DRM XRGB / V4L2 XRGB
> >=20
> > > > > > randomly, but this one on most system, little endian, will matc=
h
> > > > > > V4L2_PIX_FMT_XBGR32. This type of complex mapping can be found =
in
> > > > > > multiple places, notably in GStreamer:
> > > > > >=20
> > > > > > https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/blob/m=
aster/sys/kms/gstkmsutils.c#L45
> > > > > >=20
> > > > > > >  		.depth =3D 24,
> > > > > > >  		.num_planes =3D 1,
> > > > > > >  		.cpp =3D { 4, 0, 0 },
> > > > > > > @@ -281,6 +291,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.has_alpha =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_ARGB8888,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_ARGB32,
> > > > > > >  		.depth =3D 32,
> > > > > > >  		.num_planes =3D 1,
> > > > > > >  		.cpp =3D { 4, 0, 0 },
> > > > > > > @@ -361,6 +372,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.has_alpha =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_YUV410,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_YUV410,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 3,
> > > > > > >  		.cpp =3D { 1, 1, 1 },
> > > > > > > @@ -369,6 +381,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_YVU410,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_YVU410,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 3,
> > > > > > >  		.cpp =3D { 1, 1, 1 },
> > > > > > > @@ -393,6 +406,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_YUV420,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_YUV420M,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 3,
> > > > > > >  		.cpp =3D { 1, 1, 1 },
> > > > > > > @@ -401,6 +415,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_YVU420,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_YVU420M,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 3,
> > > > > > >  		.cpp =3D { 1, 1, 1 },
> > > > > > > @@ -409,6 +424,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_YUV422,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_YUV422M,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 3,
> > > > > > >  		.cpp =3D { 1, 1, 1 },
> > > > > > > @@ -417,6 +433,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_YVU422,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_YVU422M,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 3,
> > > > > > >  		.cpp =3D { 1, 1, 1 },
> > > > > > > @@ -425,6 +442,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_YUV444,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_YUV444M,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 3,
> > > > > > >  		.cpp =3D { 1, 1, 1 },
> > > > > > > @@ -433,6 +451,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_YVU444,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_YVU444M,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 3,
> > > > > > >  		.cpp =3D { 1, 1, 1 },
> > > > > > > @@ -441,6 +460,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_NV12,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_NV12,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 2,
> > > > > > >  		.cpp =3D { 1, 2, 0 },
> > > > > > > @@ -449,6 +469,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_NV21,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_NV21,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 2,
> > > > > > >  		.cpp =3D { 1, 2, 0 },
> > > > > > > @@ -457,6 +478,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_NV16,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_NV16,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 2,
> > > > > > >  		.cpp =3D { 1, 2, 0 },
> > > > > > > @@ -465,6 +487,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_NV61,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_NV61,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 2,
> > > > > > >  		.cpp =3D { 1, 2, 0 },
> > > > > > > @@ -473,6 +496,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_NV24,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_NV24,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 2,
> > > > > > >  		.cpp =3D { 1, 2, 0 },
> > > > > > > @@ -481,6 +505,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_NV42,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_NV42,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 2,
> > > > > > >  		.cpp =3D { 1, 2, 0 },
> > > > > > > @@ -489,6 +514,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_YUYV,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_YUYV,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 1,
> > > > > > >  		.cpp =3D { 2, 0, 0 },
> > > > > > > @@ -497,6 +523,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_YVYU,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_YVYU,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 1,
> > > > > > >  		.cpp =3D { 2, 0, 0 },
> > > > > > > @@ -505,6 +532,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_UYVY,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_UYVY,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 1,
> > > > > > >  		.cpp =3D { 2, 0, 0 },
> > > > > > > @@ -513,6 +541,7 @@ static const struct image_format_info for=
mats[] =3D {
> > > > > > >  		.is_yuv =3D true,
> > > > > > >  	}, {
> > > > > > >  		.drm_fmt =3D DRM_FORMAT_VYUY,
> > > > > > > +		.v4l2_fmt =3D V4L2_PIX_FMT_VYUY,
> > > > > > >  		.depth =3D 0,
> > > > > > >  		.num_planes =3D 1,
> > > > > > >  		.cpp =3D { 2, 0, 0 },
> > > > > > > @@ -632,6 +661,44 @@ const struct image_format_info *image_fo=
rmat_drm_lookup(u32 drm)
> > > > > > >  EXPORT_SYMBOL(image_format_drm_lookup);
> > > > > > > =20
> > > > > > >  /**
> > > > > > > + * __image_format_v4l2_lookup - query information for a give=
n format
> > > > > > > + * @v4l2: V4L2 fourcc pixel format (V4L2_PIX_FMT_*)
> > > > > > > + *
> > > > > > > + * The caller should only pass a supported pixel format to t=
his function.
> > > > > > > + *
> > > > > > > + * Returns:
> > > > > > > + * The instance of struct image_format_info that describes t=
he pixel format, or
> > > > > > > + * NULL if the format is unsupported.
> > > > > > > + */
> > > > > > > +const struct image_format_info *__image_format_v4l2_lookup(u=
32 v4l2)
> > > > > > > +{
> > > > > > > +	return __image_format_lookup(v4l2_fmt, v4l2);
> > > > > > > +}
> > > > > > > +EXPORT_SYMBOL(__image_format_v4l2_lookup);
> > > > > > > +
> > > > > > > +/**
> > > > > > > + * image_format_v4l2_lookup - query information for a given =
format
> > > > > > > + * @v4l2: V4L2 fourcc pixel format (V4L2_PIX_FMT_*)
> > > > > > > + *
> > > > > > > + * The caller should only pass a supported pixel format to t=
his function.
> > > > > > > + * Unsupported pixel formats will generate a warning in the =
kernel log.
> > > > > > > + *
> > > > > > > + * Returns:
> > > > > > > + * The instance of struct image_format_info that describes t=
he pixel format, or
> > > > > > > + * NULL if the format is unsupported.
> > > > > > > + */
> > > > > > > +const struct image_format_info *image_format_v4l2_lookup(u32=
 v4l2)
> > > > > > > +{
> > > > > > > +	const struct image_format_info *format;
> > > > > > > +
> > > > > > > +	format =3D __image_format_v4l2_lookup(v4l2);
> > > > > > > +
> > > > > > > +	WARN_ON(!format);
> > > > > > > +	return format;
> > > > > > > +}
> > > > > > > +EXPORT_SYMBOL(image_format_v4l2_lookup);
> > > > > > > +
> > > > > > > +/**
> > > > > > >   * image_format_plane_cpp - determine the bytes per pixel va=
lue
> > > > > > >   * @format: pointer to the image_format
> > > > > > >   * @plane: plane index
> > > > > >=20
> > > > > > _______________________________________________
> > > > > > dri-devel mailing list
> > > > > > dri-devel@lists.freedesktop.org
> > > > > > https://lists.freedesktop.org/mailman/listinfo/dri-devel
>=20
>=20

--=-noI8eAD4jGJrD0azTXFa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXJKGLwAKCRBxUwItrAao
HMRTAKDdqsylfXxPHNE+Pe9UqK7e2gg1YwCeOc/2PAkFTosvMfb0yCa1f2qkePc=
=gubB
-----END PGP SIGNATURE-----

--=-noI8eAD4jGJrD0azTXFa--

