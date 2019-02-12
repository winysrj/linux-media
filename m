Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F52C282C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 10:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 922BA20855
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 10:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbfBLKie (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 05:38:34 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:45848 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728845AbfBLKie (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 05:38:34 -0500
Received: from relay12.mail.gandi.net (unknown [217.70.178.232])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 42DAC3A1D2F
        for <linux-media@vger.kernel.org>; Tue, 12 Feb 2019 11:23:30 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-80-177.w90-88.abo.wanadoo.fr [90.88.22.177])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 40364200004;
        Tue, 12 Feb 2019 10:23:25 +0000 (UTC)
Date:   Tue, 12 Feb 2019 11:23:24 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     nicolas.dufresne@collabora.com, tfiga@chromium.org,
        posciak@chromium.org, hans.verkuil@cisco.com,
        acourbot@chromium.org, sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        jenskuske@gmail.com, jernej.skrabec@gmail.com, jonas@kwiboo.se,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Subject: Re: [PATCH v3 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
Message-ID: <20190212102324.3tdurso54fumlkwr@flea>
References: <cover.d3bb4d93da91ed5668025354ee1fca656e7d5b8b.1549895062.git-series.maxime.ripard@bootlin.com>
 <562aefcd53a1a30d034e97f177096d70fb705f2b.1549895062.git-series.maxime.ripard@bootlin.com>
 <209bafb880bd9410f875f5e6f16923e38ec76df4.camel@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="drrdy3tibi4hg6l4"
Content-Disposition: inline
In-Reply-To: <209bafb880bd9410f875f5e6f16923e38ec76df4.camel@collabora.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--drrdy3tibi4hg6l4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 11, 2019 at 02:12:25PM -0300, Ezequiel Garcia wrote:
> On Mon, 2019-02-11 at 15:39 +0100, Maxime Ripard wrote:
> >=20
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videod=
ev2.h
> > index d6eed479c3a6..6fc955926bdb 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -645,6 +645,7 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 =
with start codes */
> >  #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H26=
4 without start codes */
> >  #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 =
MVC */
> > +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /* H26=
4 parsed slices */
>=20
> Nicolas and I have discussed the pixel format, and came up with
> the following proposal.
>=20
> Given this format represents H264 parsed slices, without any start code,
> perhpaps we name it as:
>=20
> V4L2_PIX_FMT_H264_SLICE_RAW
>=20
> Then, we'd also add:
>=20
> V4L2_PIX_FMT_H264_SLICE_ANNEX_B
>=20
> To represent H264 parsed slices with annex B (3- or 4-byte) start code.
> This one is what the Rockchip VPU driver would expose.
>=20
> Ideas?

I think we discussed that idea already, and I'm all for it.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--drrdy3tibi4hg6l4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXGKenAAKCRDj7w1vZxhR
xW+MAP9jbBHZlCQuCB5NsMT18YGAkvbt2059lhnKbRNmfwEwqwD/SafCidHKsDSl
2sdRRj1tVdOCB3oTJRS3WNE83XwAKgM=
=cJo3
-----END PGP SIGNATURE-----

--drrdy3tibi4hg6l4--
