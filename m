Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BBFC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 18:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E16DB218A2
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 18:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfCVSol (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 14:44:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:15418 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727504AbfCVSol (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 14:44:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Mar 2019 11:44:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="157511686"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga001.fm.intel.com with SMTP; 22 Mar 2019 11:44:36 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 22 Mar 2019 20:44:35 +0200
Date:   Fri, 22 Mar 2019 20:44:35 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
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
Message-ID: <20190322184435.GJ3888@intel.com>
References: <20190320160939.GR3888@intel.com>
 <f3f8749e30aad81bc39ed9b60cd308ac5f3c6707.camel@ndufresne.ca>
 <20190320164133.GT3888@intel.com>
 <d46b30ca8962d3c31b1273cf010ca9fb7b145fe8.camel@ndufresne.ca>
 <20190320183914.GV3888@intel.com>
 <46df4fb13636b90c147839b0aa5ad1ac33030461.camel@bootlin.com>
 <20190321163532.GG3888@intel.com>
 <ac5329d77f83af2804c240ebe479ec323b60aec3.camel@ndufresne.ca>
 <20190321214455.GL3888@intel.com>
 <3e804c622fdc0ce43581982d81d2db67597508ec.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e804c622fdc0ce43581982d81d2db67597508ec.camel@ndufresne.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Mar 22, 2019 at 02:24:29PM -0400, Nicolas Dufresne wrote:
> Le jeudi 21 mars 2019 à 23:44 +0200, Ville Syrjälä a écrit :
> > On Thu, Mar 21, 2019 at 03:14:06PM -0400, Nicolas Dufresne wrote:
> > > Le jeudi 21 mars 2019 à 18:35 +0200, Ville Syrjälä a écrit :
> > > > > I'm not sure what it's worth, but there is a "pixel format guide"
> > > > > project that is all about matching formats from one API to another: 
> > > > > https://afrantzis.com/pixel-format-guide/ (and it has an associated
> > > > > tool too).
> > > > > 
> > > > > On the page about DRM, it seems that they got the word that DRM formats
> > > > > are the native pixel order in little-endian systems:
> > > > > https://afrantzis.com/pixel-format-guide/drm.html
> > > > 
> > > > Looks consistent with the official word in drm_fourcc.h.
> > > > 
> > > > $ python3 -m pfg find-compatible V4L2_PIX_FMT_XBGR32 drm
> > > > Format: V4L2_PIX_FMT_XBGR32
> > > > Is compatible on all systems with:
> > > >         DRM_FORMAT_XRGB8888
> > > > Is compatible on little-endian systems with:
> > > > Is compatible on big-endian systems with:
> > > > 
> > > > $ python3 -m pfg find-compatible DRM_FORMAT_XRGB8888 v4l2
> > > > Format: DRM_FORMAT_XRGB8888
> > > > Is compatible on all systems with:
> > > >         V4L2_PIX_FMT_XBGR32
> > > > Is compatible on little-endian systems with:
> > > > Is compatible on big-endian systems with:
> > > > 
> > > > Even works both ways :)
> > > > 
> > > > > Perhaps some drivers have been abusing the format definitions, leading
> > > > > to the inconsistencies that Nicolas could witness?
> > > > 
> > > > That is quite possible, perhaps even likely. No one really
> > > > seems interested in making sure big endian systems actually
> > > > work properly. I believe the usual approach is to hack
> > > > around semi-rnadomly until the correct colors accidentally
> > > > appear on the screen.
> > > 
> > > We did not hack around randomly. The code in GStreamer is exactly what
> > > the DRM and Wayland dev told us to do (they provided the initial
> > > patches to make it work). These are initially patches from Intel for
> > > what it's worth (see the wlvideoformat.c header [0]). Even though I
> > > just notice that in this file, it seems that we ended up with a
> > > different mapping order for WL and DRM format in 24bit RGB (no
> > > padding), clearly is a bug. That being said, there is no logical
> > > meaning for little endian 24bit RGB, you can't load a pixel on CPU in a
> > > single op.
> > 
> > To me little endian just means "little end comes first". So if
> > you think of things as just a stream of bytes CPU word size
> > etc. doesn't matter. And I guess if you really wanted to you
> > could even make a CPU with 24bit word size. 
> > 
> > Anyways, to make things more clear drm_fourcc.h could probably
> > document things better by showing explicitly which bits go into
> > which byte.
> > 
> > I don't know who did what patches for whatever project, but
> > clearly something has been lost in translation at some point.
> > 
> > > Just saying since I would not know which one of the two
> > > mapping here is right. I would probably have to go testing what DRM
> > > drivers do, which may not mean anything. I would also ask and get
> > > contradictory answers.
> > > 
> > > I have never myself tested these on big endian drivers though, as you
> > > say, nobody seems to care about graphics on those anymore. So the easy
> > > statement is to say they are little endian, like you just did, and
> > > ignore the legacy, but there is some catch. YUV formats has been added
> > > without applying this rules.
> > 
> > All drm formats follow the same rule (ignoring the recently added
> > non-byte aligned stuff which I guess don't really follow any rules).
> > 
> > > So V4L2 YUYV match YUYV in DRM format name
> > > instead of little endian UYVY. (at least 4 tested drivers implements it
> > > this way). Same for NV12, for which little endian CPU representation
> > > would swap the UV paid on a 16bit word.
> > 
> > DRM NV12 and YUYV (YUY2) match the NV12 and YUY2 defined here
> > https://docs.microsoft.com/en-us/windows/desktop/medfound/recommended-8-bit-yuv-formats-for-video-rendering
> 
> Problem is that these are all expressed MSB first like (the way V4L2
> and GStreamer do appart for the padding X, which is usually first in
> V4L2). Let's say you have 2 pixels of YUYV in a 32bit buffer.
> 
>    buf[0] = Y
>    buf[1] = U
>    buf[2] = Y
>    buf[3] = V

This is drm YUYV (aka. YUY2). Well, assuming buf[] is made up of bytes.

> 
> While with LSB first (was this what you wanted to say ?), this format
> would be VYUY as:
> 
>   buf[0] = V
>   buf[1] = Y
>   buf[2] = U
>   buf[3] = Y

This is VYUY as far as drm is concerned.

> 
> But I tested this format on i915, xlnx, msm and imx drm drivers, and
> they are all mapped as MSB. The LSB version of NV12 is called NV21 in
> MS pixel formats. It would be really confusing if the LSB rule was to
> be applied to these format in my opinion, because the names don't
> explicitly express the placement for the components.

The names don't really mean anything. Don't try to give any any special
meaning. They're just that, names. The fact that we used fourccs for
them was a mistake IMO. IIRC I objected but ended up going with them
to get the bikeshed painted at all.

And yes, the fact that we used a different naming scheme for packed YUV
vs. RGB was probably a mistake by me. But it was done long ago and we
have to live with it. Fortunately the mess has gotten much worse since
then and we are even more inconsistent now. We now YUV formats where
the A vs. X variants use totally different naming schemes.

> 
> Anyway, to cut short, as per currently tested implementation of DRM
> driver, we can keep the RGB mapping static (reversed) for now, but for
> Maxime, who probably have no clue about all this, the YUYV mapping is
> correct in this patch (in as of currently tested drivers).
> 
> > 
> > > To me, all the YUV stuff is the right way, because this is what the
> > > rest of the world is doing, it's not ambiguous.
> > > 
> > > [0] https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/blob/master/ext/wayland/wlvideoformat.c#L86
> > > 
> > > 
> > > 
> > > Nicolas



-- 
Ville Syrjälä
Intel
