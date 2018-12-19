Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE29C43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 15:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55213218C3
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 15:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbeLSPlE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 10:41:04 -0500
Received: from mail.bootlin.com ([62.4.15.54]:37265 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbeLSPlE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 10:41:04 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 4BE3920AB9; Wed, 19 Dec 2018 16:41:01 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-38-38.w90-88.abo.wanadoo.fr [90.88.157.38])
        by mail.bootlin.com (Postfix) with ESMTPSA id 975F4206A7;
        Wed, 19 Dec 2018 16:40:39 +0100 (CET)
Date:   Wed, 19 Dec 2018 16:40:40 +0100
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
Message-ID: <20181219154040.k424xkzz3xap6462@flea>
References: <cover.ad7c4feb3905658f10b022df4756a5ade280011f.1544190837.git-series.maxime.ripard@bootlin.com>
 <96a74b72be8db491dea720fdd7394bcd09880c84.1544190837.git-series.maxime.ripard@bootlin.com>
 <20181213204928.34hwq63nj5ircvkf@valkosipuli.retiisi.org.uk>
 <20181217154921.c4ttksa6bg2yxxjp@flea>
 <20181217202039.zhsxozdw7dlc3xdj@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5iqyg7jbpm2uyidw"
Content-Disposition: inline
In-Reply-To: <20181217202039.zhsxozdw7dlc3xdj@valkosipuli.retiisi.org.uk>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--5iqyg7jbpm2uyidw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 17, 2018 at 10:20:39PM +0200, sakari.ailus@iki.fi wrote:
> Hi Maxime,
>=20
> On Mon, Dec 17, 2018 at 04:49:21PM +0100, Maxime Ripard wrote:
> > Hi Sakari,
> >=20
> > Thanks for your feedback.
> >=20
> > On Thu, Dec 13, 2018 at 10:49:28PM +0200, sakari.ailus@iki.fi wrote:
> > > > +	/**
> > > > +	 * @lanes:
> > > > +	 *
> > > > +	 * Number of active data lanes used for the transmissions.
> > >=20
> > > Could you add that these are the first "lanes" number of lanes from w=
hat
> > > are available?
> >=20
> > I'm not quite sure I understood this part though, what did you mean?
>=20
> A number of lanes are routed between the two devices on hardware, and this
> field is specifying how many of them are in use. In order for the bus to
> function, both ends need to be in agreement on which of these lanes are
> actually being used. The current practice I've seen without exceptions is
> that these are the first n lanes.

Ah, right, I get it now, thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--5iqyg7jbpm2uyidw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXBpmeAAKCRDj7w1vZxhR
xTnFAQCP+5QVwIA2UFCKHNRgxL3GIau3a9c+AWOb3EwOgHtSKQEA9BNznxa/TFI6
EtTZ9A7KaebGQBSMkfkKIaBrEGGaqQQ=
=PQh1
-----END PGP SIGNATURE-----

--5iqyg7jbpm2uyidw--
