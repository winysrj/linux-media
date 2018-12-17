Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 963B8C43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 15:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 708302133F
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 15:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387896AbeLQPtg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 10:49:36 -0500
Received: from mail.bootlin.com ([62.4.15.54]:59741 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387800AbeLQPtf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 10:49:35 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 23E1F207B8; Mon, 17 Dec 2018 16:49:33 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-89-7.w90-88.abo.wanadoo.fr [90.88.30.7])
        by mail.bootlin.com (Postfix) with ESMTPSA id 2072C20858;
        Mon, 17 Dec 2018 16:49:21 +0100 (CET)
Date:   Mon, 17 Dec 2018 16:49:21 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     sakari.ailus@iki.fi
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>
Subject: Re: [PATCH v3 03/10] phy: Add MIPI D-PHY configuration options
Message-ID: <20181217154921.c4ttksa6bg2yxxjp@flea>
References: <cover.ad7c4feb3905658f10b022df4756a5ade280011f.1544190837.git-series.maxime.ripard@bootlin.com>
 <96a74b72be8db491dea720fdd7394bcd09880c84.1544190837.git-series.maxime.ripard@bootlin.com>
 <20181213204928.34hwq63nj5ircvkf@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kvr2vsrtqxz7hlll"
Content-Disposition: inline
In-Reply-To: <20181213204928.34hwq63nj5ircvkf@valkosipuli.retiisi.org.uk>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--kvr2vsrtqxz7hlll
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

Thanks for your feedback.

On Thu, Dec 13, 2018 at 10:49:28PM +0200, sakari.ailus@iki.fi wrote:
> > +	/**
> > +	 * @lanes:
> > +	 *
> > +	 * Number of active data lanes used for the transmissions.
>=20
> Could you add that these are the first "lanes" number of lanes from what
> are available?

I'm not quite sure I understood this part though, what did you mean?

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--kvr2vsrtqxz7hlll
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXBfFgQAKCRDj7w1vZxhR
xZZhAPwKCDQDW4bVEg3hzR1GYNwuPON5DLL3r3Zi5HNQcek09AD/YBnHdAdFW/zH
KvQ9ywl7y2WWIOusvw/3N4wDQa2/TwU=
=bDVi
-----END PGP SIGNATURE-----

--kvr2vsrtqxz7hlll--
