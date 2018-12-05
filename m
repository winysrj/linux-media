Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,URIBL_RHS_DOB,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5D7C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 11:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20248206B7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 11:01:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20248206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbeLELBQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 06:01:16 -0500
Received: from mail.bootlin.com ([62.4.15.54]:47729 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbeLELBP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 06:01:15 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id C1DC820C4D; Wed,  5 Dec 2018 12:01:13 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id 923FC20745;
        Wed,  5 Dec 2018 12:01:03 +0100 (CET)
Date:   Wed, 5 Dec 2018 12:01:03 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2 13/15] media: cedrus: Add device-tree compatible and
 variant for A64 support
Message-ID: <20181205110103.eq4pqscbvjfj6zec@flea>
References: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
 <20181205092444.29497-14-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="o6xnrun6kihfzgt4"
Content-Disposition: inline
In-Reply-To: <20181205092444.29497-14-paul.kocialkowski@bootlin.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--o6xnrun6kihfzgt4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

65;5402;1c
On Wed, Dec 05, 2018 at 10:24:42AM +0100, Paul Kocialkowski wrote:
> Add the necessary compatible for supporting the A64 SoC along with a
> description of the capabilities of this variant.
>=20
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--o6xnrun6kihfzgt4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXAev7wAKCRDj7w1vZxhR
xWclAQCwSo+7OO/mm5fiV5wxj+1NiAPZyGzzt8+N0KfycHqQFAD9EOS3eBfTeJY4
EhMjg+zNImaeh63RQp/pwrm1V/BSuQ4=
=/9/o
-----END PGP SIGNATURE-----

--o6xnrun6kihfzgt4--
