Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C40C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 16:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C42FC218E2
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 16:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbfCUQE1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 12:04:27 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:52021 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728016AbfCUQEZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 12:04:25 -0400
Received: from aptenodytes (aaubervilliers-681-1-92-153.w90-88.abo.wanadoo.fr [90.88.33.153])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id A0AEC20000B;
        Thu, 21 Mar 2019 16:04:19 +0000 (UTC)
Message-ID: <46df4fb13636b90c147839b0aa5ad1ac33030461.camel@bootlin.com>
Subject: Re: [RFC PATCH 18/20] lib: image-formats: Add v4l2 formats support
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-media@vger.kernel.org, Daniel Stone <daniels@collabora.com>
Date:   Thu, 21 Mar 2019 17:04:19 +0100
In-Reply-To: <20190320183914.GV3888@intel.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
         <c97024b97d3261dcf41aad3c8bc1c5d9906f33c9.1553032382.git-series.maxime.ripard@bootlin.com>
         <d8f4a31e35b1702230ced4a0cb43c10d1c7e60c8.camel@ndufresne.ca>
         <20190320142739.GK3888@intel.com>
         <a13f7fdeaf1a5e97f21a6048da765705b59d64c2.camel@ndufresne.ca>
         <20190320160939.GR3888@intel.com>
         <f3f8749e30aad81bc39ed9b60cd308ac5f3c6707.camel@ndufresne.ca>
         <20190320164133.GT3888@intel.com>
         <d46b30ca8962d3c31b1273cf010ca9fb7b145fe8.camel@ndufresne.ca>
         <20190320183914.GV3888@intel.com>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.0 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

Le mercredi 20 mars 2019 à 20:39 +0200, Ville Syrjälä a écrit :
> On Wed, Mar 20, 2019 at 02:27:59PM -0400, Nicolas Dufresne wrote:
> > Le mercredi 20 mars 2019 à 18:41 +0200, Ville Syrjälä a écrit :
> > > On Wed, Mar 20, 2019 at 12:30:25PM -0400, Nicolas Dufresne wrote:
> > > > Le mercredi 20 mars 2019 à 18:09 +0200, Ville Syrjälä a écrit :
> > > > > On Wed, Mar 20, 2019 at 11:51:58AM -0400, Nicolas Dufresne wrote:
> > > > > > Le mercredi 20 mars 2019 à 16:27 +0200, Ville Syrjälä a écrit :
> > > > > > > On Tue, Mar 19, 2019 at 07:29:18PM -0400, Nicolas Dufresne wrote:
> > > > > > > > Le mardi 19 mars 2019 à 22:57 +0100, Maxime Ripard a écrit :
> > > > > > > > > V4L2 uses different fourcc's than DRM, and has a different set of formats.
> > > > > > > > > For now, let's add the v4l2 fourcc's for the already existing formats.
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > > > > > > > ---
> > > > > > > > >  include/linux/image-formats.h |  9 +++++-
> > > > > > > > >  lib/image-formats.c           | 67 ++++++++++++++++++++++++++++++++++++-
> > > > > > > > >  2 files changed, 76 insertions(+)
> > > > > > > > > 
> > > > > > > > > diff --git a/include/linux/image-formats.h b/include/linux/image-formats.h
> > > > > > > > > index 53fd73a71b3d..fbc3a4501ebd 100644
> > > > > > > > > --- a/include/linux/image-formats.h
> > > > > > > > > +++ b/include/linux/image-formats.h
> > > > > > > > > @@ -26,6 +26,13 @@ struct image_format_info {
> > > > > > > > >  	};
> > > > > > > > >  
> > > > > > > > >  	/**
> > > > > > > > > +	 * @v4l2_fmt:
> > > > > > > > > +	 *
> > > > > > > > > +	 * V4L2 4CC format identifier (V4L2_PIX_FMT_*)
> > > > > > > > > +	 */
> > > > > > > > > +	u32 v4l2_fmt;
> > > > > > > > > +
> > > > > > > > > +	/**
> > > > > > > > >  	 * @depth:
> > > > > > > > >  	 *
> > > > > > > > >  	 * Color depth (number of bits per pixel excluding padding bits),
> > > > > > > > > @@ -222,6 +229,8 @@ image_format_info_is_yuv_sampling_444(const struct image_format_info *info)
> > > > > > > > >  
> > > > > > > > >  const struct image_format_info *__image_format_drm_lookup(u32 drm);
> > > > > > > > >  const struct image_format_info *image_format_drm_lookup(u32 drm);
> > > > > > > > > +const struct image_format_info *__image_format_v4l2_lookup(u32 v4l2);
> > > > > > > > > +const struct image_format_info *image_format_v4l2_lookup(u32 v4l2);
> > > > > > > > >  unsigned int image_format_plane_cpp(const struct image_format_info *format,
> > > > > > > > >  				    int plane);
> > > > > > > > >  unsigned int image_format_plane_width(int width,
> > > > > > > > > diff --git a/lib/image-formats.c b/lib/image-formats.c
> > > > > > > > > index 9b9a73220c5d..39f1d38ae861 100644
> > > > > > > > > --- a/lib/image-formats.c
> > > > > > > > > +++ b/lib/image-formats.c
> > > > > > > > > @@ -8,6 +8,7 @@
> > > > > > > > >  static const struct image_format_info formats[] = {
> > > > > > > > >  	{
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_C8,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_GREY,
> > > > > > > > >  		.depth = 8,
> > > > > > > > >  		.num_planes = 1,
> > > > > > > > >  		.cpp = { 1, 0, 0 },
> > > > > > > > > @@ -15,6 +16,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.vsub = 1,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_RGB332,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_RGB332,
> > > > > > > > >  		.depth = 8,
> > > > > > > > >  		.num_planes = 1,
> > > > > > > > >  		.cpp = { 1, 0, 0 },
> > > > > > > > > @@ -29,6 +31,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.vsub = 1,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_XRGB4444,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_XRGB444,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 1,
> > > > > > > > >  		.cpp = { 2, 0, 0 },
> > > > > > > > > @@ -57,6 +60,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.vsub = 1,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_ARGB4444,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_ARGB444,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 1,
> > > > > > > > >  		.cpp = { 2, 0, 0 },
> > > > > > > > > @@ -89,6 +93,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.has_alpha = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_XRGB1555,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_XRGB555,
> > > > > > > > >  		.depth = 15,
> > > > > > > > >  		.num_planes = 1,
> > > > > > > > >  		.cpp = { 2, 0, 0 },
> > > > > > > > > @@ -117,6 +122,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.vsub = 1,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_ARGB1555,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_ARGB555,
> > > > > > > > >  		.depth = 15,
> > > > > > > > >  		.num_planes = 1,
> > > > > > > > >  		.cpp = { 2, 0, 0 },
> > > > > > > > > @@ -149,6 +155,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.has_alpha = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_RGB565,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_RGB565,
> > > > > > > > >  		.depth = 16,
> > > > > > > > >  		.num_planes = 1,
> > > > > > > > >  		.cpp = { 2, 0, 0 },
> > > > > > > > > @@ -163,6 +170,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.vsub = 1,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_RGB888,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_RGB24,
> > > > > > > > >  		.depth = 24,
> > > > > > > > >  		.num_planes = 1,
> > > > > > > > >  		.cpp = { 3, 0, 0 },
> > > > > > > > > @@ -170,6 +178,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.vsub = 1,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_BGR888,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_BGR24,
> > > > > > > > >  		.depth = 24,
> > > > > > > > >  		.num_planes = 1,
> > > > > > > > >  		.cpp = { 3, 0, 0 },
> > > > > > > > > @@ -177,6 +186,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.vsub = 1,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_XRGB8888,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_XRGB32,
> > > > > > > > 
> > > > > > > > All RGB mapping should be surrounded by ifdef, because many (not all)
> > > > > > > > DRM formats represent the order of component when placed in a CPU
> > > > > > > > register, unlike V4L2 which uses memory order. I've pick this one
> > > > > > > 
> > > > > > > DRM formats are explicitly defined as little endian.
> > > > > > 
> > > > > > Yes, that means the same thing. The mapping has nothing to do with the
> > > > > > buffer bytes order, unlike V4L2 (and most streaming stack) do.
> > > > > 
> > > > > It has everything to do with byte order. Little endian means the least
> > > > > significant byte is stored in the first byte in memory.
> > > > > 
> > > > > Based on https://www.kernel.org/doc/html/v4.15/media/uapi/v4l/pixfmt-packed-rgb.html
> > > > > drm XRGB888 is actually v4l XBGR32, not XRGB32 as claimed by this patch.
> > > > 
> > > > That's basically what I said, as it's define for Little Endian rather
> > > > then buffer order, you have to make the mapping conditional. It
> > > > basically mean that in memory, the DRM format physically differ
> > > > depending on CPU endian.
> > > 
> > > No. It is always little endian no matter what the CPU is.
> > 
> > I'm sorry, this is in your ABI, we don't add layers of ifdef in
> > userspace code just for the fun of it. If you redefine this now you are
> > breaking userspace. I agree there is very little to no Big Endian on
> > DRM side anymore, but what historically was mapped per CPU cannot be
> > changed by you now.
> 
> It was always little endian.

I'm not sure what it's worth, but there is a "pixel format guide"
project that is all about matching formats from one API to another: 
https://afrantzis.com/pixel-format-guide/ (and it has an associated
tool too).

On the page about DRM, it seems that they got the word that DRM formats
are the native pixel order in little-endian systems:
https://afrantzis.com/pixel-format-guide/drm.html

Perhaps some drivers have been abusing the format definitions, leading
to the inconsistencies that Nicolas could witness?

Cheers,

Paul

> > > > Last time we have run this on PPC / Big
> > > > Endian, the mapping was XRGB/XRGB, we checked that up multiple time
> > > > with the DRM maintainers and was told this is exactly what it's suppose
> > > > to do, hence this endian dependant mapping all over the place. If you
> > > > make up that this isn't right, you are breaking userspace, and people
> > > > don't like that.
> > > 
> > > Someone recently added those DRM_FORMAT_HOST variants to allow
> > > the legacy addfb1 to create pick the format based on host
> > > endianness. I thought that was the only conclusion from the
> > > little vs. big endian drm fourcc wars.
> > > 
> > > > So the mapping should be:
> > > > Little: DRM XRGB / V4L2 XBGR
> > > > Big:    DRM XRGB / V4L2 XRGB
> > > > 
> > > > > > > > randomly, but this one on most system, little endian, will match
> > > > > > > > V4L2_PIX_FMT_XBGR32. This type of complex mapping can be found in
> > > > > > > > multiple places, notably in GStreamer:
> > > > > > > > 
> > > > > > > > https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/blob/master/sys/kms/gstkmsutils.c#L45
> > > > > > > > 
> > > > > > > > >  		.depth = 24,
> > > > > > > > >  		.num_planes = 1,
> > > > > > > > >  		.cpp = { 4, 0, 0 },
> > > > > > > > > @@ -281,6 +291,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.has_alpha = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_ARGB8888,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_ARGB32,
> > > > > > > > >  		.depth = 32,
> > > > > > > > >  		.num_planes = 1,
> > > > > > > > >  		.cpp = { 4, 0, 0 },
> > > > > > > > > @@ -361,6 +372,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.has_alpha = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_YUV410,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_YUV410,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 3,
> > > > > > > > >  		.cpp = { 1, 1, 1 },
> > > > > > > > > @@ -369,6 +381,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_YVU410,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_YVU410,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 3,
> > > > > > > > >  		.cpp = { 1, 1, 1 },
> > > > > > > > > @@ -393,6 +406,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_YUV420,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_YUV420M,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 3,
> > > > > > > > >  		.cpp = { 1, 1, 1 },
> > > > > > > > > @@ -401,6 +415,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_YVU420,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_YVU420M,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 3,
> > > > > > > > >  		.cpp = { 1, 1, 1 },
> > > > > > > > > @@ -409,6 +424,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_YUV422,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_YUV422M,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 3,
> > > > > > > > >  		.cpp = { 1, 1, 1 },
> > > > > > > > > @@ -417,6 +433,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_YVU422,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_YVU422M,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 3,
> > > > > > > > >  		.cpp = { 1, 1, 1 },
> > > > > > > > > @@ -425,6 +442,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_YUV444,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_YUV444M,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 3,
> > > > > > > > >  		.cpp = { 1, 1, 1 },
> > > > > > > > > @@ -433,6 +451,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_YVU444,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_YVU444M,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 3,
> > > > > > > > >  		.cpp = { 1, 1, 1 },
> > > > > > > > > @@ -441,6 +460,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_NV12,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_NV12,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 2,
> > > > > > > > >  		.cpp = { 1, 2, 0 },
> > > > > > > > > @@ -449,6 +469,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_NV21,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_NV21,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 2,
> > > > > > > > >  		.cpp = { 1, 2, 0 },
> > > > > > > > > @@ -457,6 +478,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_NV16,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_NV16,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 2,
> > > > > > > > >  		.cpp = { 1, 2, 0 },
> > > > > > > > > @@ -465,6 +487,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_NV61,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_NV61,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 2,
> > > > > > > > >  		.cpp = { 1, 2, 0 },
> > > > > > > > > @@ -473,6 +496,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_NV24,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_NV24,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 2,
> > > > > > > > >  		.cpp = { 1, 2, 0 },
> > > > > > > > > @@ -481,6 +505,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_NV42,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_NV42,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 2,
> > > > > > > > >  		.cpp = { 1, 2, 0 },
> > > > > > > > > @@ -489,6 +514,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_YUYV,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_YUYV,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 1,
> > > > > > > > >  		.cpp = { 2, 0, 0 },
> > > > > > > > > @@ -497,6 +523,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_YVYU,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_YVYU,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 1,
> > > > > > > > >  		.cpp = { 2, 0, 0 },
> > > > > > > > > @@ -505,6 +532,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_UYVY,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_UYVY,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 1,
> > > > > > > > >  		.cpp = { 2, 0, 0 },
> > > > > > > > > @@ -513,6 +541,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > >  		.is_yuv = true,
> > > > > > > > >  	}, {
> > > > > > > > >  		.drm_fmt = DRM_FORMAT_VYUY,
> > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_VYUY,
> > > > > > > > >  		.depth = 0,
> > > > > > > > >  		.num_planes = 1,
> > > > > > > > >  		.cpp = { 2, 0, 0 },
> > > > > > > > > @@ -632,6 +661,44 @@ const struct image_format_info *image_format_drm_lookup(u32 drm)
> > > > > > > > >  EXPORT_SYMBOL(image_format_drm_lookup);
> > > > > > > > >  
> > > > > > > > >  /**
> > > > > > > > > + * __image_format_v4l2_lookup - query information for a given format
> > > > > > > > > + * @v4l2: V4L2 fourcc pixel format (V4L2_PIX_FMT_*)
> > > > > > > > > + *
> > > > > > > > > + * The caller should only pass a supported pixel format to this function.
> > > > > > > > > + *
> > > > > > > > > + * Returns:
> > > > > > > > > + * The instance of struct image_format_info that describes the pixel format, or
> > > > > > > > > + * NULL if the format is unsupported.
> > > > > > > > > + */
> > > > > > > > > +const struct image_format_info *__image_format_v4l2_lookup(u32 v4l2)
> > > > > > > > > +{
> > > > > > > > > +	return __image_format_lookup(v4l2_fmt, v4l2);
> > > > > > > > > +}
> > > > > > > > > +EXPORT_SYMBOL(__image_format_v4l2_lookup);
> > > > > > > > > +
> > > > > > > > > +/**
> > > > > > > > > + * image_format_v4l2_lookup - query information for a given format
> > > > > > > > > + * @v4l2: V4L2 fourcc pixel format (V4L2_PIX_FMT_*)
> > > > > > > > > + *
> > > > > > > > > + * The caller should only pass a supported pixel format to this function.
> > > > > > > > > + * Unsupported pixel formats will generate a warning in the kernel log.
> > > > > > > > > + *
> > > > > > > > > + * Returns:
> > > > > > > > > + * The instance of struct image_format_info that describes the pixel format, or
> > > > > > > > > + * NULL if the format is unsupported.
> > > > > > > > > + */
> > > > > > > > > +const struct image_format_info *image_format_v4l2_lookup(u32 v4l2)
> > > > > > > > > +{
> > > > > > > > > +	const struct image_format_info *format;
> > > > > > > > > +
> > > > > > > > > +	format = __image_format_v4l2_lookup(v4l2);
> > > > > > > > > +
> > > > > > > > > +	WARN_ON(!format);
> > > > > > > > > +	return format;
> > > > > > > > > +}
> > > > > > > > > +EXPORT_SYMBOL(image_format_v4l2_lookup);
> > > > > > > > > +
> > > > > > > > > +/**
> > > > > > > > >   * image_format_plane_cpp - determine the bytes per pixel value
> > > > > > > > >   * @format: pointer to the image_format
> > > > > > > > >   * @plane: plane index
> > > > > > > > 
> > > > > > > > _______________________________________________
> > > > > > > > dri-devel mailing list
> > > > > > > > dri-devel@lists.freedesktop.org
> > > > > > > > https://lists.freedesktop.org/mailman/listinfo/dri-devel
> 
> 
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

