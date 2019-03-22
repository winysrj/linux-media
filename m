Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9890AC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 14:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 729332190A
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 14:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbfCVOmT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:42:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:30471 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727719AbfCVOmT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 10:42:19 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Mar 2019 07:42:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="216591125"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga001.jf.intel.com with SMTP; 22 Mar 2019 07:42:11 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 22 Mar 2019 16:42:10 +0200
Date:   Fri, 22 Mar 2019 16:42:10 +0200
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
Message-ID: <20190322144210.GB3888@intel.com>
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
> We did not hack around randomly.

BTW I didn't mean to imply it was you who hacked around randomly.
Sorry if you got that impression.

What I was trying to convey is the following sequence of events:
1. random person X gets their hand on a big endian machine for
   a while
2. colors are wrong
3. they hack stuff until the colors are correct in their
   current use case
4. they move on to more interesting things

-- 
Ville Syrjälä
Intel
