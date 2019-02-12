Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847F4C282CA
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 13:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A278214DA
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 13:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbfBLNFy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 08:05:54 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:46837 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728059AbfBLNFy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 08:05:54 -0500
X-Originating-IP: 90.88.30.68
Received: from localhost (aaubervilliers-681-1-89-68.w90-88.abo.wanadoo.fr [90.88.30.68])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id EF47840007;
        Tue, 12 Feb 2019 13:05:48 +0000 (UTC)
Date:   Tue, 12 Feb 2019 14:05:48 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        jernej.skrabec@gmail.com, jonas@kwiboo.se, ezequiel@collabora.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Subject: Re: [PATCH v3 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
Message-ID: <20190212130548.tytlxmbu4q6qgzzq@flea>
References: <cover.d3bb4d93da91ed5668025354ee1fca656e7d5b8b.1549895062.git-series.maxime.ripard@bootlin.com>
 <562aefcd53a1a30d034e97f177096d70fb705f2b.1549895062.git-series.maxime.ripard@bootlin.com>
 <716ae1ff-8e62-c723-5b5a-0b018cf6af6a@xs4all.nl>
 <db7a762a-8bc3-0391-036b-1fda2e445023@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="clsemqi6dbr7yjrh"
Content-Disposition: inline
In-Reply-To: <db7a762a-8bc3-0391-036b-1fda2e445023@xs4all.nl>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--clsemqi6dbr7yjrh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 11, 2019 at 04:21:47PM +0100, Hans Verkuil wrote:
> > I think the API should be designed with 4k video in mind. So if some of
> > these constants would be too small when dealing with 4k (even if the
> > current HW doesn't support this yet), then these constants would have to
> > be increased.
> >=20
> > And yes, I know 8k video is starting to appear, but I think it is OK
> > that additional control(s) would be needed to support 8k.
>=20
> Hmm, 4k (and up) is much more likely to use HEVC. So perhaps designing th=
is
> for 4k is overkill.
>=20
> Does anyone know if H.264 is used for 4k video at all? If not (or if very
> rare), then just ignore this.

I don't know the state of it right now, but until quite recently
youtube at least was encoding their 4k videos in both VP9 and
H264. They might have moved to h265 since, but considering 4k doesn't
seem unreasonable.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--clsemqi6dbr7yjrh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXGLErAAKCRDj7w1vZxhR
xRi+AP0cIus7devJ8uO36+2F7paAjyP641RBIlsIga+cRq4/uAD/THY1UkMAZAlE
enuxa3pQVkeOdOKYeXuY8p9qrRG8ng8=
=ZOBQ
-----END PGP SIGNATURE-----

--clsemqi6dbr7yjrh--
