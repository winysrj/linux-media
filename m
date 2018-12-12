Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC0EC65BAF
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 08:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBE382086D
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 08:21:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBE382086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jmondi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbeLLIVG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 03:21:06 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37427 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbeLLIVF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 03:21:05 -0500
X-Originating-IP: 2.224.242.101
Received: from w540 (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 3047460002;
        Wed, 12 Dec 2018 08:21:03 +0000 (UTC)
Date:   Wed, 12 Dec 2018 09:21:01 +0100
From:   jacopo mondi <jacopo@jmondi.org>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/5] media: adv748x: csi2: Link AFE with TXA and TXB
Message-ID: <20181212082101.GK5597@w540>
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
 <1544541373-30044-3-git-send-email-jacopo+renesas@jmondi.org>
 <fa3b9980-2a19-2e5a-2e37-e76f1ad04daa@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f54savKjS/tSNRaU"
Content-Disposition: inline
In-Reply-To: <fa3b9980-2a19-2e5a-2e37-e76f1ad04daa@ideasonboard.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--f54savKjS/tSNRaU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Kieran,

On Tue, Dec 11, 2018 at 11:07:09PM +0000, Kieran Bingham wrote:
> Hi Jacopo,
>
> Thank you for the patch,
>
> On 11/12/2018 15:16, Jacopo Mondi wrote:
> > The ADV748x chip supports routing AFE output to either TXA or TXB.
> > In order to support run-time configuration of video stream path, create an
> > additional (not enabled) "AFE:8->TXA:0" link, and remove the IMMUTABLE flag
> > from existing ones.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/i2c/adv748x/adv748x-csi2.c | 48 ++++++++++++++++++++------------
> >  1 file changed, 30 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > index 6ce21542ed48..4d1aefc2c8d0 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > @@ -27,6 +27,7 @@ static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
> >   * @v4l2_dev: Video registration device
> >   * @src: Source subdevice to establish link
> >   * @src_pad: Pad number of source to link to this @tx
> > + * @flags: Flags for the newly created link
> >   *
> >   * Ensure that the subdevice is registered against the v4l2_device, and link the
> >   * source pad to the sink pad of the CSI2 bus entity.
> > @@ -34,17 +35,11 @@ static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
> >  static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
> >  				      struct v4l2_device *v4l2_dev,
> >  				      struct v4l2_subdev *src,
> > -				      unsigned int src_pad)
> > +				      unsigned int src_pad,
> > +				      unsigned int flags)
> >  {
> > -	int enabled = MEDIA_LNK_FL_ENABLED;
> >  	int ret;
> >
> > -	/*
> > -	 * Dynamic linking of the AFE is not supported.
> > -	 * Register the links as immutable.
> > -	 */
> > -	enabled |= MEDIA_LNK_FL_IMMUTABLE;
> > -
>
> Yup - that part certainly needs to go ...
>
> >  	if (!src->v4l2_dev) {
> >  		ret = v4l2_device_register_subdev(v4l2_dev, src);
> >  		if (ret)
> > @@ -53,7 +48,7 @@ static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
> >
> >  	return media_create_pad_link(&src->entity, src_pad,
> >  				     &tx->sd.entity, ADV748X_CSI2_SINK,
> > -				     enabled);
> > +				     flags);
> >  }
> >
> >  /* -----------------------------------------------------------------------------
> > @@ -68,24 +63,41 @@ static int adv748x_csi2_registered(struct v4l2_subdev *sd)
> >  {
> >  	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> >  	struct adv748x_state *state = tx->state;
> > +	int ret;
> >
> >  	adv_dbg(state, "Registered %s (%s)", is_txa(tx) ? "TXA":"TXB",
> >  			sd->name);
> >
> >  	/*
> > -	 * The adv748x hardware allows the AFE to route through the TXA, however
> > -	 * this is not currently supported in this driver.
> > +	 * Link TXA to HDMI and AFE, and TXB to AFE only as TXB cannot output
> > +	 * HDMI.
> >  	 *
> > -	 * Link HDMI->TXA, and AFE->TXB directly.
> > +	 * The HDMI->TXA link is enabled by default, as the AFE->TXB is.
> >  	 */
> > -	if (is_txa(tx) && is_hdmi_enabled(state))
> > -		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
> > -						  &state->hdmi.sd,
> > -						  ADV748X_HDMI_SOURCE);
> > -	if (!is_txa(tx) && is_afe_enabled(state))
> > +	if (is_txa(tx)) {
> > +		if (is_hdmi_enabled(state)) {
> > +			ret = adv748x_csi2_register_link(tx, sd->v4l2_dev,
> > +							 &state->hdmi.sd,
> > +							 ADV748X_HDMI_SOURCE,
> > +							 MEDIA_LNK_FL_ENABLED);
> > +			if (ret)
> > +				return ret;
> > +		}
> > +
> > +		if (is_afe_enabled(state)) {
> > +			ret = adv748x_csi2_register_link(tx, sd->v4l2_dev,
> > +							 &state->afe.sd,
> > +							 ADV748X_AFE_SOURCE,
> > +							 0);
> > +			if (ret)
> > +				return ret;
> > +		}
>
>
> > +	} else if (is_afe_enabled(state))
>
> I believe when adding braces to one side of an if statement, we are
> supposed to add to the else clauses too ?

Correct

>
> >  		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
> >  						  &state->afe.sd,
> > -						  ADV748X_AFE_SOURCE);
> > +						  ADV748X_AFE_SOURCE,
> > +						  MEDIA_LNK_FL_ENABLED);
>
> Won't this enable the AFE link for both TXA and TXB ?
> Which one will win? Just the last one ? the first one ?
> Does it error?
>
> (It might not be a problem ... I can't recall what the behaviour is)
>
>

The AFE->TXA link is created as not enabled (see the 0 as last
argument in the adv748x_csi2_register_link() call above here, in the
'is_txa(tx)' case

> > +
>
> There are a lot of nested if's above, and I think we can simplify
> greatly if we move the logic for the flags inside
> adv748x_csi2_register_link(), and adjust the checks on is_xxx_enabled()
>
> What do you think about the following pseudo code?:
>
>
> int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
>   				      struct v4l2_device *v4l2_dev,
>   				      struct v4l2_subdev *src,
> 				      unsigned int src_pad,
> 				      bool enable)
> {
>
>   int flags = 0;
>   int ret;
>
>   if (!src->v4l2_dev) {
> 	ret = v4l2_device_register_subdev(v4l2_dev, src)
> 	if (ret) return ret;
>   }
>
>   if (enable)
> 	flags = MEDIA_LNK_FL_ENABLED;
>
>    return media_create_pad_link(&src->entity, src_pad,
>  			        &tx->sd.entity, ADV748X_CSI2_SINK,
>  			        flags);
> }
>
> int adv748x_csi2_registered(struct v4l2_subdev *sd)
> {
>   int ret;
>
>   if (is_afe_enabled(state) {
>       ret = adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->afe.sd,
> 				   ADV748X_AFE_SOURCE, !is_txa(tx));
>       if (ret)
> 	  return ret;
>   }
>
>   /* TX-B only supports AFE */
>   if (!is_txa(tx) || !(is_hdmi_enabled(state))
> 	return 0;
>
>   return adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->hdmi.sd,
> 				    ADV748X_HDMI_SOURCE, true);
> }
>
>
> The above will for TXA:
> 	register_link(..., AFE_SOURCE, enable = false );
> 	register_link(..., HDMI_SOURCE, enable = true );
>
> then TXB:
> 	register_link(..., AFE_SOURCE, enable = true );
>
> Does that meet our needs?
>

Yes it does, and it looks better. Thanks!

>
>
>
> >  	return 0;
> >  }
> >
> > --
> > 2.7.4
> >
>
> --
> Regards
> --
> Kieran

--f54savKjS/tSNRaU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJcEMTtAAoJEHI0Bo8WoVY8RyoQAKXZJkR4T8EcrJ5QtPywVQCN
E23KYkYkE7jvjsO+kEydg95Nt3gj1dtnx/+pKEvmGMAeBXVt+bE1L5PRERMzNQfp
xhvao8yJnW+1Bv3Jdr/V1bHdN1LqTvGD/vJ+P/sOSVzkDeqhwK4i0WNCa2zCk5SO
PJr1hSo6vtnmtjhJmhpz06tillfSyOLq9TrC3jVdfNMhDWvOI1eGu41ly79BQeCY
6xu+SeUGCvUhuoxuTZIXmWcSmJbGSy0wbCHS2ewpG3s6flv9LeUTBVVgOANCpSFA
tvzNc0fiN7zCUeBCLh6WU5y88ofieXYGyjERSvPJWD/6n094lpA+xNi5XbablxkJ
zFNK5Cqqb15KqBDJ/MtKGx8xcIJKetMVj4QXhVUXQco5RJsR9BucCIMA8DC/2RZP
SyXmSGAkBgVgx4TLwUNr0syI0aW7CbqLWPowdagE1ZkbGJZrxZcjFinKK9MjGzsW
b1dtB1K3uJsOq+pV3N9TgmG5QX/QPddIsO8sX4Li0h6ipQIOTNk8eBj/ONr0nnGZ
vOlikC1YI1CATZAmn6Q5O9F8SgWwXVesxm2EywafcqR61xQJXJHgCwmswj8F+Ibf
n6k7XUrVC9TCfQTSo0AlC8S6k1TPjK4uQHZTU2bEmSAcJ08TVbRyV8U1ZGXgfhEl
TpDmPkORzTKf3urDU160
=vTk1
-----END PGP SIGNATURE-----

--f54savKjS/tSNRaU--
