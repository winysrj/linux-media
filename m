Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B419C65BAF
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 08:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E380D20849
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 08:28:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E380D20849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jmondi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbeLLI2C (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 03:28:02 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:38193 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbeLLI2B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 03:28:01 -0500
X-Originating-IP: 2.224.242.101
Received: from w540 (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 9B72F240020;
        Wed, 12 Dec 2018 08:27:58 +0000 (UTC)
Date:   Wed, 12 Dec 2018 09:27:57 +0100
From:   jacopo mondi <jacopo@jmondi.org>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 5/5] media: adv748x: Implement link_setup callback
Message-ID: <20181212082757.GL5597@w540>
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
 <1544541373-30044-6-git-send-email-jacopo+renesas@jmondi.org>
 <b4a718b4-ff9b-020e-d64e-09cf40747f6e@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="um2V5WpqCyd73IVb"
Content-Disposition: inline
In-Reply-To: <b4a718b4-ff9b-020e-d64e-09cf40747f6e@ideasonboard.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--um2V5WpqCyd73IVb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Kieran,

On Tue, Dec 11, 2018 at 11:43:08PM +0000, Kieran Bingham wrote:
> Hi Jacopo,
>
> On 11/12/2018 15:16, Jacopo Mondi wrote:
> > When the adv748x driver is informed about a link being created from HDMI or
> > AFE to a CSI-2 TX output, the 'link_setup()' callback is invoked. Make
> > sure to implement proper routing management at link setup time, to route
> > the selected video stream to the desired TX output.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/i2c/adv748x/adv748x-core.c | 63 +++++++++++++++++++++++++++++++-
> >  drivers/media/i2c/adv748x/adv748x.h      |  1 +
> >  2 files changed, 63 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> > index f3aabbccdfb5..08dc0e89b053 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > @@ -335,9 +335,70 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
> >  /* -----------------------------------------------------------------------------
> >   * Media Operations
> >   */
> > +static int adv748x_link_setup(struct media_entity *entity,
> > +			      const struct media_pad *local,
> > +			      const struct media_pad *remote, u32 flags)
> > +{
> > +	struct v4l2_subdev *rsd = media_entity_to_v4l2_subdev(remote->entity);
> > +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> > +	struct adv748x_state *state = v4l2_get_subdevdata(sd);
> > +	struct adv748x_csi2 *tx;
> > +	struct media_link *link;
> > +	u8 io10;
> > +
> > +	/*
> > +	 * For each link setup from [HDMI|AFE] to TX we receive two
> > +	 * notifications: "[HDMI|AFE]->TX" and "TX<-[HDMI|AFE]".
> > +	 *
> > +	 * Use the second notification form to make sure we're linking
> > +	 * to a TX and find out from where, to set up routing properly.
> > +	 */
>
>
> > +	if ((sd != &state->txa.sd && sd != &state->txb.sd) ||
>
> I'm starting to think an 'is_txb(tx)' would help clean up some code ...
> Then we could do the assignment of tx above, and then this line would read
>
>   if ( (!(is_txa(tx) && !(is_txb(tx)))
>      || !(flags & MEDIA_LNK_FL_ENABLED) )
>
>
> It shouldn't matter that the adv748x_sd_to_csi2(sd) could be called on
> non-TX SD's as they will then simply fail to match the above is_txa/is_txb.
>

Checking for is_txa() and is_txb() would require to call
'adv_sd_to_csi2(sd)' before having made sure the 'sd' actually
represent a csi2_tx. I would keep it as it is.
>
>
> > +	    !(flags & MEDIA_LNK_FL_ENABLED))
> > +		return 0;
>
> Don't we need to clear some local references when disabling links?
>

I don't think so, if the link is disabled the pipeline would never
start and s_stream() (where the reference to the connected tx is used)
will never be called the AFE or HDMI backends.


> (or actually perhaps it doesn't matter if we keep stale references in a
> disabled object, because it's disabled)

Yes. Even if both HDMI and AFE have 'TXA' as their connected TX, only one
of them has an actually enabled link, and to enable that link, the
previously existing one has to be disabled first, otherwise this
function fails (see the -EINVAL a few lines below)

>
> > +	tx = adv748x_sd_to_csi2(sd);
>
>
> > +
> > +	/*
> > +	 * Now that we're sure we're operating on one of the two TXs,
> > +	 * make sure there are no enabled links ending there from
> > +	 * either HDMI or AFE (this can only happens for TXA though).
> > +	 */
> > +	if (is_txa(tx))
> > +		list_for_each_entry(link, &entity->links, list)
> > +			if (link->sink->entity == entity &&
> > +			    link->flags & MEDIA_LNK_FL_ENABLED)
> > +				return -EINVAL;
> > +
>
> What does this protect?
>
> Doesn't this code read as:
>
>   if (is TXA)
> 	for each entity
> 		Check all links - and if any are enabled, -EINVAL
>
> Don't we ever want a link to be enabled on TXA?

Not if we are enabling another one. One should first disable the
existing link, then create a new one.

>
> (I must surely be mis-reading this - and it's nearly mid-night - so I'm
> going to say I'm confused and it's time for me to stop and go to bed :D)
>
>
> > +	/* Change video stream routing, according to the newly created link. */
> > +	io10 = io_read(state, ADV748X_IO_10);
> > +	if (rsd == &state->afe.sd) {
> > +		state->afe.tx = tx;
> > +
> > +		/*
> > +		 * If AFE is routed to TXA, make sure TXB is off;
> > +		 * If AFE goes to TXB, we need TXA powered on.
> > +		 */
> > +		if (is_txa(tx)) {
> > +			io10 |= ADV748X_IO_10_CSI4_IN_SEL_AFE;
> > +			io10 &= ~ADV748X_IO_10_CSI1_EN;
> > +		} else {
> > +			io10 |= ADV748X_IO_10_CSI4_EN |
> > +				ADV748X_IO_10_CSI1_EN;
> > +		}
> > +	} else {
> > +		state->hdmi.tx = tx;
> > +		io10 &= ~ADV748X_IO_10_CSI4_IN_SEL_AFE;
> > +	}
> > +	io_write(state, ADV748X_IO_10, io10);
> > +
> > +	tx->rsd = rsd;
> > +
> > +	return 0;
> > +}
> >
> >  static const struct media_entity_operations adv748x_media_ops = {
> > -	.link_validate = v4l2_subdev_link_validate,
> > +	.link_setup	= adv748x_link_setup,
> > +	.link_validate	= v4l2_subdev_link_validate,
> >  };
> >
> >  /* -----------------------------------------------------------------------------
> > diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> > index 0ee3b8d5c795..63a17c31c169 100644
> > --- a/drivers/media/i2c/adv748x/adv748x.h
> > +++ b/drivers/media/i2c/adv748x/adv748x.h
> > @@ -220,6 +220,7 @@ struct adv748x_state {
> >  #define ADV748X_IO_10_CSI4_EN		BIT(7)
> >  #define ADV748X_IO_10_CSI1_EN		BIT(6)
> >  #define ADV748X_IO_10_PIX_OUT_EN	BIT(5)
> > +#define ADV748X_IO_10_CSI4_IN_SEL_AFE	0x08
>
> Should this be BIT(3)?
>

It surely read better. See, you were not that sleepy as you said,
after all :p

Thanks for review, I'll wait some more time to receive more comments
and will resend.

Thanks
  j

> >
> >  #define ADV748X_IO_CHIP_REV_ID_1	0xdf
> >  #define ADV748X_IO_CHIP_REV_ID_2	0xe0
> >
>
> --
> Regards
> --
> Kieran

--um2V5WpqCyd73IVb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJcEMaMAAoJEHI0Bo8WoVY8XLUP/R0GhNVbCGLpbe8dBj152vqX
ftXe86YHRLu/3YAPRQDb+LxMMoSBgomM9jIZWWXU2e8ce+4ADbYBjWxmVLTTsKf4
0cKHb9V3UOqD1mkhOgb96lKM08DUQg2rDyVot4mcTAT+g2LSzT4qaZcgkJcol89v
bFY6+a2H3DpulLGlKz5nxJZYfvWckc1CJCHN/iCsc+FPGnNiHq32KkMg5upX8Vnt
tI/IMo2mjflkG8UBrdAELEAGve/2TAtL73SClxOjG781IlcvwrYcHGJ1KMK896G/
fLnc9Pb1eFkdwCCe7LFEvoRfXI70z4dCRPeJ5xAAYlU4FPckPt83qgh6eyrN4hfj
A/lecN7BvDvj6RrHXf2jVBVfF0xmzeDML9bocvuY2EfGJWFoc0h4yH0A6T3yJOzA
FmlGG+U+sBKriNEyMwJlg/E+NMovFQtt/BcrBM3M5nfS7hJINnMUEtkTFOKODbNM
DJGDGjMHYFurzn8/y+GGhJPy3iibUjp47fGCt/qYhR02z5LbMNCm1i9dkmmQdQvY
N97eN3REZ6K+c6hF+Nl0Ya71ojViA+xj5M1zO2RuGGcq9tjB8UmDKCjwQeEDXu2n
qRn1UztI4+7NFGiIROvWu6hQcaISNtABrmiKgL6vFnDYm5UqTUv9eQ0bL8wOclgL
oShk9fDoor+XsoPdWKMX
=XlhG
-----END PGP SIGNATURE-----

--um2V5WpqCyd73IVb--
