Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB73C282C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 10:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7531E20818
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 10:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbfBLKnT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 05:43:19 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:36013 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbfBLKnT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 05:43:19 -0500
Received: from localhost (aaubervilliers-681-1-80-177.w90-88.abo.wanadoo.fr [90.88.22.177])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 1BED6100006;
        Tue, 12 Feb 2019 10:43:14 +0000 (UTC)
Date:   Tue, 12 Feb 2019 11:43:14 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>
Cc:     linux-sunxi@googlegroups.com, hans.verkuil@cisco.com,
        acourbot@chromium.org, sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        jonas@kwiboo.se, ezequiel@collabora.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [linux-sunxi] [PATCH v3 2/2] media: cedrus: Add H264 decoding
 support
Message-ID: <20190212104314.slytpbufwhf5ujv7@flea>
References: <cover.d3bb4d93da91ed5668025354ee1fca656e7d5b8b.1549895062.git-series.maxime.ripard@bootlin.com>
 <4c00e1ab1e70adb1d94db59c37393250ca3791c5.1549895062.git-series.maxime.ripard@bootlin.com>
 <12916702.RFRCeC2GgE@jernej-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5gdejtoqqa6qlisa"
Content-Disposition: inline
In-Reply-To: <12916702.RFRCeC2GgE@jernej-laptop>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--5gdejtoqqa6qlisa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 11, 2019 at 08:21:31PM +0100, Jernej =C5=A0krabec wrote:
> > +	reg =3D 0;
> > +	/*
> > +	 * FIXME: This bit tells the video engine to use the default
> > +	 * quantization matrices. This will obviously need to be
> > +	 * changed to support the profiles supporting custom
> > +	 * quantization matrices.
> > +	 */
> > +	reg |=3D VE_H264_SHS_QP_SCALING_MATRIX_DEFAULT;
>=20
> This flag should not be needed anymore. From what I see, you correctly se=
t=20
> scaling matrix every time.

The scaling matrix control is optional, so I guess we should protect
that by a check on whether that control has been set or not. What do
you think?

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--5gdejtoqqa6qlisa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXGKjQgAKCRDj7w1vZxhR
xbGrAQDuJ3RI8iJRp2xbjnQ//F/tGuWwtz7PdNfWKUaQvNBr0AD8DA9cnLZ4F7c3
hTdzfxkMmPlsb+v5HUPlK14j1NWIRgY=
=LFLc
-----END PGP SIGNATURE-----

--5gdejtoqqa6qlisa--
