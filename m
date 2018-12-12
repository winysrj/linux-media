Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCDD8C04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 08:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C7432086D
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 08:16:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C7432086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jmondi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbeLLIQc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 03:16:32 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36587 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbeLLIQc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 03:16:32 -0500
X-Originating-IP: 2.224.242.101
Received: from w540 (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id A1EA460010;
        Wed, 12 Dec 2018 08:16:28 +0000 (UTC)
Date:   Wed, 12 Dec 2018 09:16:26 +0100
From:   jacopo mondi <jacopo@jmondi.org>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/5] media: adv748x: Rework reset procedure
Message-ID: <20181212081626.GJ5597@w540>
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
 <1544541373-30044-2-git-send-email-jacopo+renesas@jmondi.org>
 <32aa95b8-1ae8-9f05-6d57-cf370ff58edf@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="T4Djgzn3z2HSNnx0"
Content-Disposition: inline
In-Reply-To: <32aa95b8-1ae8-9f05-6d57-cf370ff58edf@ideasonboard.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--T4Djgzn3z2HSNnx0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Kieran,
   thanks for review

On Tue, Dec 11, 2018 at 11:52:03PM +0000, Kieran Bingham wrote:
> Hi Jacopo,
>
> On 11/12/2018 15:16, Jacopo Mondi wrote:
> > Re-work the chip reset procedure to configure the CP (HDMI) and SD (AFE) cores
> > before resetting the MIPI CSI-2 TXs.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/i2c/adv748x/adv748x-core.c | 24 ++++++++++--------------
> >  1 file changed, 10 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> > index d94c63cb6a2e..5495dc7891e8 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > @@ -353,9 +353,8 @@ static const struct adv748x_reg_value adv748x_sw_reset[] = {
> >  	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> >  };
> >
> > -/* Supported Formats For Script Below */
> > -/* - 01-29 HDMI to MIPI TxA CSI 4-Lane - RGB888: */
>
> Is this information redundant ? (CSI-4Lane, RGB888 configuration?)
>

The CSI-2 data lane configuration has been break out from this table
by Niklas' patches. I've tried also moving the format configuration
out of this, but I haven't sent that change. The HDMI video direction
is now handled at link setup time, so I guess the only relevant
information is about the RGB888 format configured on the CP backend.
I'll keep that.

> > -static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
> > +/* Initialize CP Core. */
> > +static const struct adv748x_reg_value adv748x_init_hdmi[] = {
>
> While we're here - is there much scope - or value in changing these
> tables to functions with parameters using Niklas' adv748x_write_check() ?
>
> The suggestion only has value if there are parameters that we would need
> to configure. So it might be reasonable to leave these tables.
>

Right now I don't see much value in that. I would prefer breaking out
the format configuration from this static tables, but that's for
later.

> A general Ack on renaming to the function instead of the
> TX/configuration though - as that makes the purpose clearer.
>
>
> >  	/* Disable chip powerdown & Enable HDMI Rx block */
> >  	{ADV748X_PAGE_IO, 0x00, 0x40},
> >
> > @@ -399,10 +398,8 @@ static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
> >  	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> >  };
> >
> > -/* 02-01 Analog CVBS to MIPI TX-B CSI 1-Lane - */
> > -/* Autodetect CVBS Single Ended In Ain 1 - MIPI Out */
> > -static const struct adv748x_reg_value adv748x_init_txb_1lane[] = {
> > -
>
> Same comments as above really :)
>

I'll see what I can keep.

Thanks
  j

> > +/* Initialize AFE core. */
> > +static const struct adv748x_reg_value adv748x_init_afe[] = {
> >  	{ADV748X_PAGE_IO, 0x00, 0x30},	/* Disable chip powerdown Rx */
> >  	{ADV748X_PAGE_IO, 0xf2, 0x01},	/* Enable I2C Read Auto-Increment */
> >
> > @@ -445,19 +442,18 @@ static int adv748x_reset(struct adv748x_state *state)
> >  	if (ret < 0)
> >  		return ret;
> >
> > -	/* Init and power down TXA */
> > -	ret = adv748x_write_regs(state, adv748x_init_txa_4lane);
> > +	/* Initialize CP and AFE cores. */
> > +	ret = adv748x_write_regs(state, adv748x_init_hdmi);
> >  	if (ret)
> >  		return ret;
> >
> > -	adv748x_tx_power(&state->txa, 1);
> > -	adv748x_tx_power(&state->txa, 0);
> > -
> > -	/* Init and power down TXB */
> > -	ret = adv748x_write_regs(state, adv748x_init_txb_1lane);
> > +	ret = adv748x_write_regs(state, adv748x_init_afe);
> >  	if (ret)
> >  		return ret;
> >
> > +	/* Reset TXA and TXB */
> > +	adv748x_tx_power(&state->txa, 1);
> > +	adv748x_tx_power(&state->txa, 0);
> >  	adv748x_tx_power(&state->txb, 1);
> >  	adv748x_tx_power(&state->txb, 0);
> >
> > --
> > 2.7.4
> >
>
> --
> Regards
> --
> Kieran

--T4Djgzn3z2HSNnx0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJcEMPaAAoJEHI0Bo8WoVY8VGEQAJR1JWtt4EsxUOENLJn1n02J
q9aNfmRJc3JWL2VKcK1OnfexSSSAE0x6StR+SJXaF2ZqLFeEyOD7i90wYzwjad3h
/8bAyOU/ABbsSJHMwcj677EyqecGlhzIS2orV1XiIurYBcis6NET2rNEBJeLo/9B
8JDipI8HilUNFi4fYKWyh6d/0m5BBrVwsklfI3H2IjYzpDE1FtJp3SyBRplwlT+x
YlVhZpCAZ2qDUmjhtv29rzPQobRNEHvOz9cUj0IaeMZ8RGvCTjAzgrtqKHRYr6TM
jCUXw55afsoyhZUTB2N7VQZb6iAc4J2xGvnkeCObtDL/iu61baPXLDFgfV9JmyfB
knq2adUqBJneFfN7cjA4KTslKibB9v7V1os078quYPkdqCWIrnwfff8JeJlNhaJ7
U5BH1uypNCebwknSWNigsyB0RTLBYh3dTueyxw7vHT6I0zxrdumqBJCmZtT6XxYy
qFMEEoPjoRFwW/qpsO90vtRryBLGTSm3yRI0xjjwG3a5ZBkEQYh1DK+/vDvLNIFH
dvd5Je55/1Z2/MuX7We5NYnhzTRU4mMIKSblAGR9iSRG6V6EcNH8m1ZQZysuP18x
aDF00kETPf4WRLZ0vQ12brKgGOlOO8mO6HGeywOW+Df/l2Pp0J8wCUK/q976IBja
V7VloRb1BnuE/cv5754M
=DL3s
-----END PGP SIGNATURE-----

--T4Djgzn3z2HSNnx0--
