Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36825 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbeIDSuA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2018 14:50:00 -0400
Date: Tue, 4 Sep 2018 16:24:37 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] media: i2c: adv748x: Support probing a single output
Message-ID: <20180904142437.GC28160@w540>
References: <1535369285-26032-1-git-send-email-jacopo+renesas@jmondi.org>
 <1535369285-26032-2-git-send-email-jacopo+renesas@jmondi.org>
 <f9923f8e-4644-81bd-9ee6-1ffbf44551f3@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Content-Disposition: inline
In-Reply-To: <f9923f8e-4644-81bd-9ee6-1ffbf44551f3@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Kieran,

On Tue, Aug 28, 2018 at 04:26:43PM +0100, Kieran Bingham wrote:
> Hi Jacopo,
>
> Thank you for the patch,
>
>
> On 27/08/18 12:28, Jacopo Mondi wrote:
> > Currently the adv748x driver refuses to probe if both its output endpoints
> > (TXA and TXB) are not connected.
> >
> > Make the driver support probing with (at least) one output endpoint connected
> > and protect the cleanup function from accessing un-initialized fields.
> >
> > Following patches will fix other user of un-initialized TXs in the driver,
> > such as power management functions.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/i2c/adv748x/adv748x-core.c | 38 +++++++++++++++++++++++++-------
> >  drivers/media/i2c/adv748x/adv748x-csi2.c | 17 ++++----------
> >  drivers/media/i2c/adv748x/adv748x.h      |  2 ++
> >  3 files changed, 36 insertions(+), 21 deletions(-)
> >
> > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> > index 6ca88daa..78d5996 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > @@ -654,6 +654,24 @@ static int adv748x_probe(struct i2c_client *client,
> >  		goto err_cleanup_clients;
> >  	}
> >
> > +	/*
> > +	 * We can not use container_of to get back to the state with two TXs;
> > +	 * Initialize the TXs's fields unconditionally on the endpoint
> > +	 * presence to access them later.
> > +	 */
> > +	state->txa.state = state->txb.state = state;
> > +	state->txa.page = ADV748X_PAGE_TXA;
> > +	state->txb.page = ADV748X_PAGE_TXB;
> > +	state->txa.port = ADV748X_PORT_TXA;
> > +	state->txb.port = ADV748X_PORT_TXB;
> > +
>
> Initialising this data here feels a bit hacky...

Possibly, yes.
I'm going to move this back to csi2_init() and call it
unconditionally, but I don't like returning an error if not having a
TX enabled is not an error. I'll go for

        if (!is_tx_enabled(tx))
                return 0;
>
>
> > +	if (!is_tx_enabled(&state->txa) &&
> > +	    !is_tx_enabled(&state->txb)) {
>
> Could we make is_tx_enabled() based on the information it needs?
>
> 	is_tx_enabled(ADV748X_PORT_TXA);
>
> Or perhaps:
> 	is_port_enabled(ADV748X_PORT_TXA)
>

We could, but why? Where's the benefit?

>
> > +		ret = -ENODEV;
> > +		adv_err(state, "No output endpoint defined\n");
> > +		goto err_cleanup_clients;
> > +	}
> > +
>
> I approached this slightly differently at [0], by allowing the CSI
> object to initialise, but if they return -ENODEV, then it's fine.

I see. Not my preference actually, but I'll change in v2 as you
suggested above (the tx initialization in csi2_init() )

Thanks
  j
>
> The only thing missing from [0] is a check to see if at least one of the
> CSI devices probed.
>
>
>
> You might be interested in [1], from my old 'adv748x/dev' branch [2] for
> looking at the link creation too.
>
> [0]
> https://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git/commit/?h=adv748x/for-next&id=ee53e0f7e6e0f3dacc79dcf157ce3c403b17ec14
>
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git/commit/?h=adv748x/dev&id=e0e975d73a70a5b73ad674e206103cd7df983a04
>
>
> [2]
> https://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git/log/?h=adv748x/dev
>
>
> >  	/* SW reset ADV748X to its default values */
> >  	ret = adv748x_reset(state);
> >  	if (ret) {
> > @@ -676,17 +694,21 @@ static int adv748x_probe(struct i2c_client *client,
> >  	}
> >
> >  	/* Initialise TXA */
> > -	ret = adv748x_csi2_init(state, &state->txa);
> > -	if (ret) {
> > -		adv_err(state, "Failed to probe TXA");
> > -		goto err_cleanup_afe;
> > +	if (is_tx_enabled(&state->txa)) {
> > +		ret = adv748x_csi2_init(state, &state->txa);
> > +		if (ret) {
> > +			adv_err(state, "Failed to probe TXA");
> > +			goto err_cleanup_afe;
> > +		}
> >  	}
> >
> >  	/* Initialise TXB */
> > -	ret = adv748x_csi2_init(state, &state->txb);
> > -	if (ret) {
> > -		adv_err(state, "Failed to probe TXB");
> > -		goto err_cleanup_txa;
> > +	if (is_tx_enabled(&state->txb)) {
> > +		ret = adv748x_csi2_init(state, &state->txb);
> > +		if (ret) {
> > +			adv_err(state, "Failed to probe TXB");
> > +			goto err_cleanup_txa;
> > +		}
> >  	}
> >
> >  	return 0;
> > diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > index 469be87..709cdea 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > @@ -266,20 +266,8 @@ static int adv748x_csi2_init_controls(struct adv748x_csi2 *tx)
> >
> >  int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx)
> >  {
> > -	struct device_node *ep;
> >  	int ret;
> >
> > -	/* We can not use container_of to get back to the state with two TXs */
> > -	tx->state = state;
> > -	tx->page = is_txa(tx) ? ADV748X_PAGE_TXA : ADV748X_PAGE_TXB;
> > -
> > -	ep = state->endpoints[is_txa(tx) ? ADV748X_PORT_TXA : ADV748X_PORT_TXB];
> > -	if (!ep) {
> > -		adv_err(state, "No endpoint found for %s\n",
> > -				is_txa(tx) ? "txa" : "txb");
>
> If you used the -ENODEV approach, this adv_err should be removed.
>
> > -		return -ENODEV;
> > -	}
> > -
> >  	/* Initialise the virtual channel */
> >  	adv748x_csi2_set_virtual_channel(tx, 0);
> >
> > @@ -288,7 +276,7 @@ int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx)
> >  			    is_txa(tx) ? "txa" : "txb");
> >
> >  	/* Ensure that matching is based upon the endpoint fwnodes */
> > -	tx->sd.fwnode = of_fwnode_handle(ep);
> > +	tx->sd.fwnode = of_fwnode_handle(state->endpoints[tx->port]);
> >
> >  	/* Register internal ops for incremental subdev registration */
> >  	tx->sd.internal_ops = &adv748x_csi2_internal_ops;
> > @@ -321,6 +309,9 @@ int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx)
> >
> >  void adv748x_csi2_cleanup(struct adv748x_csi2 *tx)
> >  {
> > +	if (!is_tx_enabled(tx))
> > +		return;
> > +
> >  	v4l2_async_unregister_subdev(&tx->sd);
> >  	media_entity_cleanup(&tx->sd.entity);
> >  	v4l2_ctrl_handler_free(&tx->ctrl_hdl);
> > diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> > index 65f8374..1cf46c40 100644
> > --- a/drivers/media/i2c/adv748x/adv748x.h
> > +++ b/drivers/media/i2c/adv748x/adv748x.h
> > @@ -82,6 +82,7 @@ struct adv748x_csi2 {
> >  	struct adv748x_state *state;
> >  	struct v4l2_mbus_framefmt format;
> >  	unsigned int page;
> > +	unsigned int port;
> >
> >  	struct media_pad pads[ADV748X_CSI2_NR_PADS];
> >  	struct v4l2_ctrl_handler ctrl_hdl;
> > @@ -91,6 +92,7 @@ struct adv748x_csi2 {
> >
> >  #define notifier_to_csi2(n) container_of(n, struct adv748x_csi2, notifier)
> >  #define adv748x_sd_to_csi2(sd) container_of(sd, struct adv748x_csi2, sd)
> > +#define is_tx_enabled(_tx) ((_tx)->state->endpoints[(_tx)->port] != NULL)
>
> >
> >  enum adv748x_hdmi_pads {
> >  	ADV748X_HDMI_SINK,
> >
>

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbjpWkAAoJEHI0Bo8WoVY8/2cP/0V68iHm3zCPWEEQ79V1rVP1
UtsqbT/PpgHHEpEiZt34t9dvwsTlVJV2hBgtlax8/Y20+ItLOHeysxJWZ2HwYDSL
aTzuWg1C00B3qoWUs/OR5fJMdS8yymRebLuYnTjrS4k3OxLf0fpP9gKWc3y/Q9wi
nmHayZtVRfKFxpeNGU9kIiI8j7dcUEIfzKG9nIBXG70ZDo7eMkcg7GUK1O18znCS
0S60bX76gCHn8GPh37Piq59j1hAiRfMQkYHrlytpPLqEm9pNwx+Lyc8YghWXxDtU
7meoc5f+BdB3vRjMkmDhAJCE+NtK9rBqWb7VWB40GVnRjPjWU4iKHLa5dP9G28ka
jRFs68teIVM+r/wSAJ2UfsdZG1kq6Or4ISBEJiRHMmubnNGJEz+ti7Qg8fhLbVm9
S6uNP68juBwx4Vvwq+RLVR3nf3RBpX3YnGRZKo7NMJfnv/CJKPjWWB6w2+Tpm5rP
ueLUv4YxJdMjbdpS2dbXIM143bfodgjwC8tRB97EP6WHVweSnd5EGNR2QAU9k5Fo
7vHvdrMgHpMkFQJNwGgq+o/926z0Dibk1tnUjSPKeaDYPo1QAmAPUTSk5rPaTLF0
m2cKvrmV53uBURs3+xE+m5uHOqeFW5haze3P81/nDuKsw6CvcYEdxijFrIJ5VimD
MNFXmT+Ub8pobsndzy9G
=l4Vp
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--
