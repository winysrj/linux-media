Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 749CBC43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 15:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CAB2218A5
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 15:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfCUPrt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:47:49 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:58719 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbfCUPrt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 11:47:49 -0400
X-Originating-IP: 185.94.189.187
Received: from localhost (unknown [185.94.189.187])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id C724920011;
        Thu, 21 Mar 2019 15:47:45 +0000 (UTC)
Date:   Thu, 21 Mar 2019 16:47:45 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Brian Starkey <Brian.Starkey@arm.com>
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
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
Message-ID: <20190321154745.4o7setv3bucphrsv@flea>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
 <c97024b97d3261dcf41aad3c8bc1c5d9906f33c9.1553032382.git-series.maxime.ripard@bootlin.com>
 <d8f4a31e35b1702230ced4a0cb43c10d1c7e60c8.camel@ndufresne.ca>
 <20190320181553.radwlhapzn464dlh@DESKTOP-E1NTVVP.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i4gw25fdztzcmio7"
Content-Disposition: inline
In-Reply-To: <20190320181553.radwlhapzn464dlh@DESKTOP-E1NTVVP.localdomain>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--i4gw25fdztzcmio7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 20, 2019 at 06:15:54PM +0000, Brian Starkey wrote:
> On Tue, Mar 19, 2019 at 07:29:18PM -0400, Nicolas Dufresne wrote:
> > All RGB mapping should be surrounded by ifdef, because many (not all)
> > DRM formats represent the order of component when placed in a CPU
> > register, unlike V4L2 which uses memory order. I've pick this one
> > randomly, but this one on most system, little endian, will match
> > V4L2_PIX_FMT_XBGR32. This type of complex mapping can be found in
> > multiple places, notably in GStreamer:
> >
> > https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/blob/master/sys/kms/gstkmsutils.c#L45
>
> I do sort-of wonder if it's worth trying to switch to common fourccs
> between DRM and V4L2 (and whatever else there is).
>
> The V4L2 formats list is quite incomplete and a little quirky in
> places (V4L2_PIX_FORMAT_XBGR32 and V4L2_PIX_FORMAT_XRGB32 naming
> inconsistency being one. 'X' isn't even next to 'B' in XBGR32).
>
> At least for newly-added formats, not using a common definition
> doesn't make a lot of sense to me. Longer term, I also don't really
> see any downsides to unification.

Eventually, I agree that that his where we should be heading. Moving
the existing formats support to a common place will help with that.

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--i4gw25fdztzcmio7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXJOyIQAKCRDj7w1vZxhR
xfQNAP43UEujnLuknDuJ54/viHqBDU6/qBqdYGvG1QWwWP0FNQEAg0XP/rCIE20U
i+UysiRZ/+7aHE999qgXHkgD4o4pFAE=
=lNMS
-----END PGP SIGNATURE-----

--i4gw25fdztzcmio7--
