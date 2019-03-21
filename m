Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A6EC43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 10:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F249218AE
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 10:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbfCUKNj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 06:13:39 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:54535 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbfCUKNj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 06:13:39 -0400
X-Originating-IP: 90.88.33.153
Received: from localhost (aaubervilliers-681-1-92-153.w90-88.abo.wanadoo.fr [90.88.33.153])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 5434560003;
        Thu, 21 Mar 2019 10:13:36 +0000 (UTC)
Date:   Thu, 21 Mar 2019 11:13:35 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 03/20] drm/fourcc: Pass the format_info pointer to
 drm_format_plane_cpp
Message-ID: <20190321101335.wws44wdh42jazboq@flea>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
 <6e5850afb02cc2851fe3229122fb3cb4869dc108.1553032382.git-series.maxime.ripard@bootlin.com>
 <2ef894df9d9e79d4a89e745e95c79bbb6a2505e4.camel@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3fgryhrccqk3ctcg"
Content-Disposition: inline
In-Reply-To: <2ef894df9d9e79d4a89e745e95c79bbb6a2505e4.camel@bootlin.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--3fgryhrccqk3ctcg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 2019 at 03:24:26PM +0100, Paul Kocialkowski wrote:
> Hi,
>
> Le mardi 19 mars 2019 =E0 22:57 +0100, Maxime Ripard a =E9crit :
> > So far, the drm_format_plane_cpp function was operating on the format's
> > fourcc and was doing a lookup to retrieve the drm_format_info structure=
 and
> > return the cpp.
> >
> > However, this is inefficient since in most cases, we will have the
> > drm_format_info pointer already available so we shouldn't have to perfo=
rm a
> > new lookup. Some drm_fourcc functions also already operate on the
> > drm_format_info pointer for that reason, so the API is quite inconsiste=
nt
> > there.
>
> Well, it seems that drm_fourcc functions that take a drm_format_info
> have a drm_format_info prefix, so having this would be more consistent.
>
> And given what the helper does, I think it would make good sense to
> switch it over to an inline drm_format_info_plane_cpp helper.
>
> What do you think?

That makes total sense, I'll change it. Thanks!
Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--3fgryhrccqk3ctcg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXJNjzwAKCRDj7w1vZxhR
xeDxAP9igUy53jj/yNPXFCSDY7e7I/oyTqzXAlWmASCZBvYc8QEAoY9iAzv0Sp6E
4o3AlROC52GmSYBbNWGK0MvLa14chgY=
=J/XE
-----END PGP SIGNATURE-----

--3fgryhrccqk3ctcg--
