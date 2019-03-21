Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433FEC43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 16:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2AEC21916
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 16:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbfCUQfj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 12:35:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:44150 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727198AbfCUQfj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 12:35:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Mar 2019 09:35:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,253,1549958400"; 
   d="scan'208";a="133559378"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga008.fm.intel.com with SMTP; 21 Mar 2019 09:35:33 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 21 Mar 2019 18:35:32 +0200
Date:   Thu, 21 Mar 2019 18:35:32 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
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
Subject: Re: [RFC PATCH 18/20] lib: image-formats: Add v4l2 formats support
Message-ID: <20190321163532.GG3888@intel.com>
References: <c97024b97d3261dcf41aad3c8bc1c5d9906f33c9.1553032382.git-series.maxime.ripard@bootlin.com>
 <d8f4a31e35b1702230ced4a0cb43c10d1c7e60c8.camel@ndufresne.ca>
 <20190320142739.GK3888@intel.com>
 <a13f7fdeaf1a5e97f21a6048da765705b59d64c2.camel@ndufresne.ca>
 <20190320160939.GR3888@intel.com>
 <f3f8749e30aad81bc39ed9b60cd308ac5f3c6707.camel@ndufresne.ca>
 <20190320164133.GT3888@intel.com>
 <d46b30ca8962d3c31b1273cf010ca9fb7b145fe8.camel@ndufresne.ca>
 <20190320183914.GV3888@intel.com>
 <46df4fb13636b90c147839b0aa5ad1ac33030461.camel@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46df4fb13636b90c147839b0aa5ad1ac33030461.camel@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Mar 21, 2019 at 05:04:19PM +0100, Paul Kocialkowski wrote:
> Hi,
> 
> Le mercredi 20 mars 2019 à 20:39 +0200, Ville Syrjälä a écrit :
> > On Wed, Mar 20, 2019 at 02:27:59PM -0400, Nicolas Dufresne wrote:
> > > Le mercredi 20 mars 2019 à 18:41 +0200, Ville Syrjälä a écrit :
> > > > On Wed, Mar 20, 2019 at 12:30:25PM -0400, Nicolas Dufresne wrote:
> > > > > Le mercredi 20 mars 2019 à 18:09 +0200, Ville Syrjälä a écrit :
> > > > > > On Wed, Mar 20, 2019 at 11:51:58AM -0400, Nicolas Dufresne wrote:
> > > > > > > Le mercredi 20 mars 2019 à 16:27 +0200, Ville Syrjälä a écrit :
> > > > > > > > On Tue, Mar 19, 2019 at 07:29:18PM -0400, Nicolas Dufresne wrote:
> > > > > > > > > Le mardi 19 mars 2019 à 22:57 +0100, Maxime Ripard a écrit :
> > > > > > > > > > V4L2 uses different fourcc's than DRM, and has a different set of formats.
> > > > > > > > > > For now, let's add the v4l2 fourcc's for the already existing formats.
> > > > > > > > > > 
> > > > > > > > > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > > > > > > > > ---
> > > > > > > > > >  include/linux/image-formats.h |  9 +++++-
> > > > > > > > > >  lib/image-formats.c           | 67 ++++++++++++++++++++++++++++++++++++-
> > > > > > > > > >  2 files changed, 76 insertions(+)
> > > > > > > > > > 
> > > > > > > > > > diff --git a/include/linux/image-formats.h b/include/linux/image-formats.h
> > > > > > > > > > index 53fd73a71b3d..fbc3a4501ebd 100644
> > > > > > > > > > --- a/include/linux/image-formats.h
> > > > > > > > > > +++ b/include/linux/image-formats.h
> > > > > > > > > > @@ -26,6 +26,13 @@ struct image_format_info {
> > > > > > > > > >  	};
> > > > > > > > > >  
> > > > > > > > > >  	/**
> > > > > > > > > > +	 * @v4l2_fmt:
> > > > > > > > > > +	 *
> > > > > > > > > > +	 * V4L2 4CC format identifier (V4L2_PIX_FMT_*)
> > > > > > > > > > +	 */
> > > > > > > > > > +	u32 v4l2_fmt;
> > > > > > > > > > +
> > > > > > > > > > +	/**
> > > > > > > > > >  	 * @depth:
> > > > > > > > > >  	 *
> > > > > > > > > >  	 * Color depth (number of bits per pixel excluding padding bits),
> > > > > > > > > > @@ -222,6 +229,8 @@ image_format_info_is_yuv_sampling_444(const struct image_format_info *info)
> > > > > > > > > >  
> > > > > > > > > >  const struct image_format_info *__image_format_drm_lookup(u32 drm);
> > > > > > > > > >  const struct image_format_info *image_format_drm_lookup(u32 drm);
> > > > > > > > > > +const struct image_format_info *__image_format_v4l2_lookup(u32 v4l2);
> > > > > > > > > > +const struct image_format_info *image_format_v4l2_lookup(u32 v4l2);
> > > > > > > > > >  unsigned int image_format_plane_cpp(const struct image_format_info *format,
> > > > > > > > > >  				    int plane);
> > > > > > > > > >  unsigned int image_format_plane_width(int width,
> > > > > > > > > > diff --git a/lib/image-formats.c b/lib/image-formats.c
> > > > > > > > > > index 9b9a73220c5d..39f1d38ae861 100644
> > > > > > > > > > --- a/lib/image-formats.c
> > > > > > > > > > +++ b/lib/image-formats.c
> > > > > > > > > > @@ -8,6 +8,7 @@
> > > > > > > > > >  static const struct image_format_info formats[] = {
> > > > > > > > > >  	{
> > > > > > > > > >  		.drm_fmt = DRM_FORMAT_C8,
> > > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_GREY,
> > > > > > > > > >  		.depth = 8,
> > > > > > > > > >  		.num_planes = 1,
> > > > > > > > > >  		.cpp = { 1, 0, 0 },
> > > > > > > > > > @@ -15,6 +16,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > > >  		.vsub = 1,
> > > > > > > > > >  	}, {
> > > > > > > > > >  		.drm_fmt = DRM_FORMAT_RGB332,
> > > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_RGB332,
> > > > > > > > > >  		.depth = 8,
> > > > > > > > > >  		.num_planes = 1,
> > > > > > > > > >  		.cpp = { 1, 0, 0 },
> > > > > > > > > > @@ -29,6 +31,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > > >  		.vsub = 1,
> > > > > > > > > >  	}, {
> > > > > > > > > >  		.drm_fmt = DRM_FORMAT_XRGB4444,
> > > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_XRGB444,
> > > > > > > > > >  		.depth = 0,
> > > > > > > > > >  		.num_planes = 1,
> > > > > > > > > >  		.cpp = { 2, 0, 0 },
> > > > > > > > > > @@ -57,6 +60,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > > >  		.vsub = 1,
> > > > > > > > > >  	}, {
> > > > > > > > > >  		.drm_fmt = DRM_FORMAT_ARGB4444,
> > > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_ARGB444,
> > > > > > > > > >  		.depth = 0,
> > > > > > > > > >  		.num_planes = 1,
> > > > > > > > > >  		.cpp = { 2, 0, 0 },
> > > > > > > > > > @@ -89,6 +93,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > > >  		.has_alpha = true,
> > > > > > > > > >  	}, {
> > > > > > > > > >  		.drm_fmt = DRM_FORMAT_XRGB1555,
> > > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_XRGB555,
> > > > > > > > > >  		.depth = 15,
> > > > > > > > > >  		.num_planes = 1,
> > > > > > > > > >  		.cpp = { 2, 0, 0 },
> > > > > > > > > > @@ -117,6 +122,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > > >  		.vsub = 1,
> > > > > > > > > >  	}, {
> > > > > > > > > >  		.drm_fmt = DRM_FORMAT_ARGB1555,
> > > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_ARGB555,
> > > > > > > > > >  		.depth = 15,
> > > > > > > > > >  		.num_planes = 1,
> > > > > > > > > >  		.cpp = { 2, 0, 0 },
> > > > > > > > > > @@ -149,6 +155,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > > >  		.has_alpha = true,
> > > > > > > > > >  	}, {
> > > > > > > > > >  		.drm_fmt = DRM_FORMAT_RGB565,
> > > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_RGB565,
> > > > > > > > > >  		.depth = 16,
> > > > > > > > > >  		.num_planes = 1,
> > > > > > > > > >  		.cpp = { 2, 0, 0 },
> > > > > > > > > > @@ -163,6 +170,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > > >  		.vsub = 1,
> > > > > > > > > >  	}, {
> > > > > > > > > >  		.drm_fmt = DRM_FORMAT_RGB888,
> > > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_RGB24,
> > > > > > > > > >  		.depth = 24,
> > > > > > > > > >  		.num_planes = 1,
> > > > > > > > > >  		.cpp = { 3, 0, 0 },
> > > > > > > > > > @@ -170,6 +178,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > > >  		.vsub = 1,
> > > > > > > > > >  	}, {
> > > > > > > > > >  		.drm_fmt = DRM_FORMAT_BGR888,
> > > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_BGR24,
> > > > > > > > > >  		.depth = 24,
> > > > > > > > > >  		.num_planes = 1,
> > > > > > > > > >  		.cpp = { 3, 0, 0 },
> > > > > > > > > > @@ -177,6 +186,7 @@ static const struct image_format_info formats[] = {
> > > > > > > > > >  		.vsub = 1,
> > > > > > > > > >  	}, {
> > > > > > > > > >  		.drm_fmt = DRM_FORMAT_XRGB8888,
> > > > > > > > > > +		.v4l2_fmt = V4L2_PIX_FMT_XRGB32,
> > > > > > > > > 
> > > > > > > > > All RGB mapping should be surrounded by ifdef, because many (not all)
> > > > > > > > > DRM formats represent the order of component when placed in a CPU
> > > > > > > > > register, unlike V4L2 which uses memory order. I've pick this one
> > > > > > > > 
> > > > > > > > DRM formats are explicitly defined as little endian.
> > > > > > > 
> > > > > > > Yes, that means the same thing. The mapping has nothing to do with the
> > > > > > > buffer bytes order, unlike V4L2 (and most streaming stack) do.
> > > > > > 
> > > > > > It has everything to do with byte order. Little endian means the least
> > > > > > significant byte is stored in the first byte in memory.
> > > > > > 
> > > > > > Based on https://www.kernel.org/doc/html/v4.15/media/uapi/v4l/pixfmt-packed-rgb.html
> > > > > > drm XRGB888 is actually v4l XBGR32, not XRGB32 as claimed by this patch.
> > > > > 
> > > > > That's basically what I said, as it's define for Little Endian rather
> > > > > then buffer order, you have to make the mapping conditional. It
> > > > > basically mean that in memory, the DRM format physically differ
> > > > > depending on CPU endian.
> > > > 
> > > > No. It is always little endian no matter what the CPU is.
> > > 
> > > I'm sorry, this is in your ABI, we don't add layers of ifdef in
> > > userspace code just for the fun of it. If you redefine this now you are
> > > breaking userspace. I agree there is very little to no Big Endian on
> > > DRM side anymore, but what historically was mapped per CPU cannot be
> > > changed by you now.
> > 
> > It was always little endian.
> 
> I'm not sure what it's worth, but there is a "pixel format guide"
> project that is all about matching formats from one API to another: 
> https://afrantzis.com/pixel-format-guide/ (and it has an associated
> tool too).
> 
> On the page about DRM, it seems that they got the word that DRM formats
> are the native pixel order in little-endian systems:
> https://afrantzis.com/pixel-format-guide/drm.html

Looks consistent with the official word in drm_fourcc.h.

$ python3 -m pfg find-compatible V4L2_PIX_FMT_XBGR32 drm
Format: V4L2_PIX_FMT_XBGR32
Is compatible on all systems with:
        DRM_FORMAT_XRGB8888
Is compatible on little-endian systems with:
Is compatible on big-endian systems with:

$ python3 -m pfg find-compatible DRM_FORMAT_XRGB8888 v4l2
Format: DRM_FORMAT_XRGB8888
Is compatible on all systems with:
        V4L2_PIX_FMT_XBGR32
Is compatible on little-endian systems with:
Is compatible on big-endian systems with:

Even works both ways :)

> 
> Perhaps some drivers have been abusing the format definitions, leading
> to the inconsistencies that Nicolas could witness?

That is quite possible, perhaps even likely. No one really
seems interested in making sure big endian systems actually
work properly. I believe the usual approach is to hack
around semi-rnadomly until the correct colors accidentally
appear on the screen.

-- 
Ville Syrjälä
Intel
