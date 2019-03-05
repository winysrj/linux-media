Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FCAC43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 09:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA2462082C
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 09:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfCEJno (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 04:43:44 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:42395 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfCEJno (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 04:43:44 -0500
X-Originating-IP: 90.88.147.150
Received: from localhost (aaubervilliers-681-1-27-150.w90-88.abo.wanadoo.fr [90.88.147.150])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id E153320005;
        Tue,  5 Mar 2019 09:43:38 +0000 (UTC)
Date:   Tue, 5 Mar 2019 10:43:38 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        jernej.skrabec@gmail.com, jonas@kwiboo.se,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Subject: Re: [PATCH v4 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
Message-ID: <20190305094338.r6fxapkhkir25g6t@flea>
References: <cover.1862a43851950ddee041d53669f8979aba863c38.1550672228.git-series.maxime.ripard@bootlin.com>
 <9817c9875638ed2484d61e6e128e2551cf3bda4c.1550672228.git-series.maxime.ripard@bootlin.com>
 <4aac6476ffe6a6be021c69a708f19d5da30a79e4.camel@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ij7ubrshaobrtlud"
Content-Disposition: inline
In-Reply-To: <4aac6476ffe6a6be021c69a708f19d5da30a79e4.camel@collabora.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--ij7ubrshaobrtlud
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Mar 04, 2019 at 03:49:11PM -0300, Ezequiel Garcia wrote:
> On Wed, 2019-02-20 at 15:17 +0100, Maxime Ripard wrote:
> > From: Pawel Osciak <posciak@chromium.org>
> >=20
> > Stateless video codecs will require both the H264 metadata and slices in
> > order to be able to decode frames.
> >=20
> > This introduces the definitions for a new pixel format for H264 slices =
that
> > have been parsed, as well as the structures used to pass the metadata f=
rom
> > the userspace to the kernel.
> >=20
> > Co-Developped-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > Signed-off-by: Pawel Osciak <posciak@chromium.org>
> > Signed-off-by: Guenter Roeck <groeck@chromium.org>
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  Documentation/media/uapi/v4l/biblio.rst            |   9 +-
> >  Documentation/media/uapi/v4l/extended-controls.rst | 547 +++++++++++++=
+-
>=20
> It seems Hans splitted the documentation and so this should now
> go to Documentation/media/uapi/v4l/ext-ctrls-codec.rst.

Thanks for letting me know, it will be fixed in the next version.

> >=20
> > +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /* H26=
4 parsed slices */
> >  #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263 =
         */
> >  #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-=
1 ES     */
> >  #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-=
2 ES     */
>=20
> I haven't seen any objections to renaming this to V4L2_PIX_FMT_H264_SLICE=
_RAW,
> so if you could be so kind to push v5 with this rename (or similar), and =
also
> rebasing to the master branch, I could then submit the H264 decoder suppo=
rt for
> the Rockchip VPU.

I don't remember it, but yeah, this is fine by me. I'll adjust it and
send a new version.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--ij7ubrshaobrtlud
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXH5EygAKCRDj7w1vZxhR
xRoDAP95iR+PSnNWLGn1NQ6nA8KqOQuDq3p6KazU91X/RVHf1QEA1hw8vHtpwXpz
BLEtdM7HyAhrs5BBOKqOKJCd0o0OZwY=
=yU2z
-----END PGP SIGNATURE-----

--ij7ubrshaobrtlud--
