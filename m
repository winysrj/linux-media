Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB01C43612
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 10:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4986520854
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 10:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfAGKFk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 05:05:40 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:56969 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfAGKFk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 05:05:40 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 07823C001C;
        Mon,  7 Jan 2019 10:05:36 +0000 (UTC)
Date:   Mon, 7 Jan 2019 11:05:42 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 1/6] media: adv748x: Add is_txb()
Message-ID: <20190107100542.5qszrtydqzowhzlp@uno.localdomain>
References: <20190106155413.30666-1-jacopo+renesas@jmondi.org>
 <20190106155413.30666-2-jacopo+renesas@jmondi.org>
 <556804e3-c537-2e85-5335-0194dfe7f83b@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="as5spdm3ppxs6sh4"
Content-Disposition: inline
In-Reply-To: <556804e3-c537-2e85-5335-0194dfe7f83b@ideasonboard.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--as5spdm3ppxs6sh4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Kieran,

On Mon, Jan 07, 2019 at 09:49:25AM +0000, Kieran Bingham wrote:
> Hi Jacopo
>
> On 06/01/2019 15:54, Jacopo Mondi wrote:
> > Add small is_txb() macro to the existing is_txa() and use it where
> > appropriate.
>
> Thank you.
>
> I think this will make the code much better to read than if (!is_txa).
>
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>
>
> > ---
> >  drivers/media/i2c/adv748x/adv748x-csi2.c | 2 +-
> >  drivers/media/i2c/adv748x/adv748x.h      | 6 +++++-
> >  2 files changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > index 6ce21542ed48..b6b5d8c7ea7c 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > @@ -82,7 +82,7 @@ static int adv748x_csi2_registered(struct v4l2_subdev *sd)
> >  		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
> >  						  &state->hdmi.sd,
> >  						  ADV748X_HDMI_SOURCE);
> > -	if (!is_txa(tx) && is_afe_enabled(state))
> > +	if (is_txb(tx) && is_afe_enabled(state))
> >  		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
> >  						  &state->afe.sd,
> >  						  ADV748X_AFE_SOURCE);
> > diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> > index b482c7fe6957..bc2da1b5ce29 100644
> > --- a/drivers/media/i2c/adv748x/adv748x.h
> > +++ b/drivers/media/i2c/adv748x/adv748x.h
> > @@ -89,8 +89,12 @@ struct adv748x_csi2 {
> >
> >  #define notifier_to_csi2(n) container_of(n, struct adv748x_csi2, notifier)
> >  #define adv748x_sd_to_csi2(sd) container_of(sd, struct adv748x_csi2, sd)
> > +
> >  #define is_tx_enabled(_tx) ((_tx)->state->endpoints[(_tx)->port] != NULL)
> > -#define is_txa(_tx) ((_tx) == &(_tx)->state->txa)
> > +#define __is_tx(_tx, _ab) ((_tx) == &(_tx)->state->tx##_ab)
> > +#define is_txa(_tx) __is_tx(_tx, a)
> > +#define is_txb(_tx) __is_tx(_tx, b)
>
> I would have just duplicated the is_txa() line here... but this is good
> too :)

I agree it might seem more complex than necessary. I initially made it
like this as I started from the 'is_tx()' macro this series adds in
6/6.

If it is easier to have an '((_tx) == &(_tx)->state->txb)' I can
change this.

Thanks
   j

>
>
> > +
> >  #define is_afe_enabled(_state)					\
> >  	((_state)->endpoints[ADV748X_PORT_AIN0] != NULL ||	\
> >  	 (_state)->endpoints[ADV748X_PORT_AIN1] != NULL ||	\
> >
>
> --
> Regards
> --
> Kieran

--as5spdm3ppxs6sh4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlwzJHYACgkQcjQGjxah
Vjw23w//Yk/8E0smgwkmcSQbutuG670gM/erUDL4qevccy4G3XcUSlz4zXZKPfUE
Fk/ugScC9PkjmogoXZLLnK+e7e9RDdOgkORjsnivbh+HanXLrP5S2cJHti81heFA
5qkfRdArbd7smgrBe+vqfd8c/iXcpsywh7+gNaPCGrv+xtKBLyqXv/SQvO7kefn4
V/GbhrarXVD3Mk2wXS+wHLrcKher+n9Zjm1Er7u4QQU3rz5KWQ4KtIwhojZda9g7
y2PTaWwek0WnQS58NpogbQMhn6UOuPLaWJ6IpjO8rhPulmVEjKPHekkzeuwwfIsI
T5kIWrhg8oBPyC6fEc9knWlcQYijkvk1JCweqY4YVfH4fM0FohjOHNeFVGEJQBXl
gpzCrNqxOOCg7t/b4tP8FOn4zlEdxei5Af1wvZMs9gvJ98oyT0Jt8dERvLMV3zGJ
ebViREzwHZhwLeG/nG9IANqbf7YaBxFHUtADFiSA92vHD0ccfFbAkTdmn29Ntmxy
P/73kD0H3RRbKxVMH6tMeg9VY/FjbEAFJ5m3uMd1MWmub0zcJgEmQfl8P8SP4PAe
sABP01I/qKp8nuTgW+HCtLX8zhsrMFpJ1vZqSKHBOWzs0FP2r9RtCHk2dM711VEb
XWPzuJajiFDLRcvlctHEruM9EAOs6hfPrUxL14kgyWgJbSxESdg=
=LNMV
-----END PGP SIGNATURE-----

--as5spdm3ppxs6sh4--
