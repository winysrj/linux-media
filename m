Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F4BC43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 21:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D42821916
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 21:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfCUVpC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 17:45:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:3638 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbfCUVpC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 17:45:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Mar 2019 14:45:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,254,1549958400"; 
   d="scan'208";a="127509762"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga008.jf.intel.com with SMTP; 21 Mar 2019 14:44:56 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 21 Mar 2019 23:44:55 +0200
Date:   Thu, 21 Mar 2019 23:44:55 +0200
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
Message-ID: <20190321214455.GL3888@intel.com>
References: <20190320142739.GK3888@intel.com>
 <a13f7fdeaf1a5e97f21a6048da765705b59d64c2.camel@ndufresne.ca>
 <20190320160939.GR3888@intel.com>
 <f3f8749e30aad81bc39ed9b60cd308ac5f3c6707.camel@ndufresne.ca>
 <20190320164133.GT3888@intel.com>
 <d46b30ca8962d3c31b1273cf010ca9fb7b145fe8.camel@ndufresne.ca>
 <20190320183914.GV3888@intel.com>
 <46df4fb13636b90c147839b0aa5ad1ac33030461.camel@bootlin.com>
 <20190321163532.GG3888@intel.com>
 <ac5329d77f83af2804c240ebe479ec323b60aec3.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac5329d77f83af2804c240ebe479ec323b60aec3.camel@ndufresne.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Mar 21, 2019 at 03:14:06PM -0400, Nicolas Dufresne wrote:
> Le jeudi 21 mars 2019 à 18:35 +0200, Ville Syrjälä a écrit :
> > > I'm not sure what it's worth, but there is a "pixel format guide"
> > > project that is all about matching formats from one API to another: 
> > > https://afrantzis.com/pixel-format-guide/ (and it has an associated
> > > tool too).
> > > 
> > > On the page about DRM, it seems that they got the word that DRM formats
> > > are the native pixel order in little-endian systems:
> > > https://afrantzis.com/pixel-format-guide/drm.html
> > 
> > Looks consistent with the official word in drm_fourcc.h.
> > 
> > $ python3 -m pfg find-compatible V4L2_PIX_FMT_XBGR32 drm
> > Format: V4L2_PIX_FMT_XBGR32
> > Is compatible on all systems with:
> >         DRM_FORMAT_XRGB8888
> > Is compatible on little-endian systems with:
> > Is compatible on big-endian systems with:
> > 
> > $ python3 -m pfg find-compatible DRM_FORMAT_XRGB8888 v4l2
> > Format: DRM_FORMAT_XRGB8888
> > Is compatible on all systems with:
> >         V4L2_PIX_FMT_XBGR32
> > Is compatible on little-endian systems with:
> > Is compatible on big-endian systems with:
> > 
> > Even works both ways :)
> > 
> > > Perhaps some drivers have been abusing the format definitions, leading
> > > to the inconsistencies that Nicolas could witness?
> > 
> > That is quite possible, perhaps even likely. No one really
> > seems interested in making sure big endian systems actually
> > work properly. I believe the usual approach is to hack
> > around semi-rnadomly until the correct colors accidentally
> > appear on the screen.
> 
> We did not hack around randomly. The code in GStreamer is exactly what
> the DRM and Wayland dev told us to do (they provided the initial
> patches to make it work). These are initially patches from Intel for
> what it's worth (see the wlvideoformat.c header [0]). Even though I
> just notice that in this file, it seems that we ended up with a
> different mapping order for WL and DRM format in 24bit RGB (no
> padding), clearly is a bug. That being said, there is no logical
> meaning for little endian 24bit RGB, you can't load a pixel on CPU in a
> single op.

To me little endian just means "little end comes first". So if
you think of things as just a stream of bytes CPU word size
etc. doesn't matter. And I guess if you really wanted to you
could even make a CPU with 24bit word size. 

Anyways, to make things more clear drm_fourcc.h could probably
document things better by showing explicitly which bits go into
which byte.

I don't know who did what patches for whatever project, but
clearly something has been lost in translation at some point.

> Just saying since I would not know which one of the two
> mapping here is right. I would probably have to go testing what DRM
> drivers do, which may not mean anything. I would also ask and get
> contradictory answers.
> 
> I have never myself tested these on big endian drivers though, as you
> say, nobody seems to care about graphics on those anymore. So the easy
> statement is to say they are little endian, like you just did, and
> ignore the legacy, but there is some catch. YUV formats has been added
> without applying this rules.

All drm formats follow the same rule (ignoring the recently added
non-byte aligned stuff which I guess don't really follow any rules).

> So V4L2 YUYV match YUYV in DRM format name
> instead of little endian UYVY. (at least 4 tested drivers implements it
> this way). Same for NV12, for which little endian CPU representation
> would swap the UV paid on a 16bit word.

DRM NV12 and YUYV (YUY2) match the NV12 and YUY2 defined here
https://docs.microsoft.com/en-us/windows/desktop/medfound/recommended-8-bit-yuv-formats-for-video-rendering

> 
> To me, all the YUV stuff is the right way, because this is what the
> rest of the world is doing, it's not ambiguous.
> 
> [0] https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/blob/master/ext/wayland/wlvideoformat.c#L86
> 
> 
> 
> Nicolas

-- 
Ville Syrjälä
Intel
