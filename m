Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 629E8C2F43D
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 15:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B5BC20870
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 15:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbfAUPnm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 10:43:42 -0500
Received: from mail.bootlin.com ([62.4.15.54]:60742 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729195AbfAUPnl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 10:43:41 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 37DD320BA8; Mon, 21 Jan 2019 16:43:38 +0100 (CET)
Received: from localhost (unknown [185.94.189.187])
        by mail.bootlin.com (Postfix) with ESMTPSA id E945620A7D;
        Mon, 21 Jan 2019 16:43:27 +0100 (CET)
Date:   Mon, 21 Jan 2019 16:43:28 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Sean Paul <sean@poorly.run>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
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
Subject: Re: [PATCH v4 6/9] drm/bridge: cdns: Separate DSI and D-PHY
 configuration
Message-ID: <20190121154328.ydvz4fr5l77do3eh@flea>
References: <cover.5d91ef683e3f432342f536e0f2fe239dbcebcb3e.1547026369.git-series.maxime.ripard@bootlin.com>
 <df619f059617d85c00efa146884e295240a07ae7.1547026369.git-series.maxime.ripard@bootlin.com>
 <20190117133338.GA114153@art_vandelay>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l6imrxbzhtg7biw4"
Content-Disposition: inline
In-Reply-To: <20190117133338.GA114153@art_vandelay>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--l6imrxbzhtg7biw4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2019 at 08:33:38AM -0500, Sean Paul wrote:
> > @@ -768,49 +769,90 @@ static int cdns_dsi_mode2cfg(struct cdns_dsi *dsi,
> > =20
> >  		dsi_cfg->hsa =3D dpi_to_dsi_timing(tmp, bpp,
> >  						 DSI_HSA_FRAME_OVERHEAD);
> > -		dsi_htotal +=3D dsi_cfg->hsa + DSI_HSA_FRAME_OVERHEAD;
> > -		dsi_hss_hsa_hse_hbp +=3D dsi_cfg->hsa + DSI_HSA_FRAME_OVERHEAD;
> >  	}
> > =20
> >  	dsi_cfg->hact =3D dpi_to_dsi_timing(mode_valid_check ?
> >  					  mode->hdisplay : mode->crtc_hdisplay,
> >  					  bpp, 0);
> > -	dsi_htotal +=3D dsi_cfg->hact;
> > +	dsi_cfg->hfp =3D dpi_to_dsi_timing(mode_to_dpi_hfp(mode), bpp,
> > +					 DSI_HFP_FRAME_OVERHEAD);
>=20
> We're throwing away the mode_valid_check switch here to flip between crtc=
_h*
> value and h* value. Is that intentional? We're using it above for hdispla=
y, so
> it's a bit confusing.

ah, right, thanks for spotting this.

I'll resend a version with those changes, thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--l6imrxbzhtg7biw4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXEXooAAKCRDj7w1vZxhR
xZvQAP9c5WpWI5x2NUr+cpn0bnmw6vFHt4EsPXnMArrGqiPwFgEAlu2Dw7n4C1H9
K0jkBgL1lQj7MoT8wU2DNLJ2gXtN1AQ=
=fa+Q
-----END PGP SIGNATURE-----

--l6imrxbzhtg7biw4--
