Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46308 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbeKBTvM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 15:51:12 -0400
Received: by mail-lf1-f67.google.com with SMTP id o2-v6so989577lfl.13
        for <linux-media@vger.kernel.org>; Fri, 02 Nov 2018 03:44:28 -0700 (PDT)
Date: Fri, 2 Nov 2018 11:44:25 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 5/5] i2c: adv748x: configure number of lanes used for
 TXA CSI-2 transmitter
Message-ID: <20181102104425.GI22306@bigcity.dyn.berto.se>
References: <20181004204138.2784-1-niklas.soderlund@ragnatech.se>
 <20181004204138.2784-6-niklas.soderlund@ragnatech.se>
 <20181005104615.GP31281@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181005104615.GP31281@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your feedback.

On 2018-10-05 12:46:15 +0200, Jacopo Mondi wrote:
> Hi Niklas,
> 
> On Thu, Oct 04, 2018 at 10:41:38PM +0200, Niklas Söderlund wrote:
> > From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> >
> > The driver fixed the TXA CSI-2 transmitter in 4-lane mode while it could
> > operate using 1-, 2- and 4-lanes. Update the driver to support all modes
> > the hardware does.
> >
> > The driver make use of large tables of static register/value writes when
> > powering up/down the TXA and TXB transmitters which include the write to
> > the NUM_LANES register. By converting the tables into functions and
> > using parameters the power up/down functions for TXA and TXB power
> > up/down can be merged and used for both transmitters.
> >
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> >
> > ---
> > * Changes since v1
> > - Convert tables of register/value writes into functions instead of
> >   intercepting and modifying the writes to the NUM_LANES register.
> > ---
> >  drivers/media/i2c/adv748x/adv748x-core.c | 132 ++++++++++++-----------
> >  1 file changed, 67 insertions(+), 65 deletions(-)
> >
> > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> > index 3836dd3025d6ffb7..fe29781368a3a6b6 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > @@ -125,6 +125,16 @@ int adv748x_write(struct adv748x_state *state, u8 page, u8 reg, u8 value)
> >  	return regmap_write(state->regmap[page], reg, value);
> >  }
> >
> > +static int adv748x_write_check(struct adv748x_state *state, u8 page, u8 reg,
> > +			       u8 value, int *error)
> 
> Am I wrong or the return error is ignored and could be dropped?

No it's used to reduce boiler plate code, see adv748x_power_up_tx() 
bellow for one example.

    int ret = 0;
    ...
    adv748x_write_check(state, page, 0x31, 0x82, &ret);
    adv748x_write_check(state, page, 0x1e, 0x40, &ret);
    ...
    return ret;

If the first adv748x_write_check() fails all later calls to 
adv748x_write_check() will do nothing. This is do avoid the rather hard 
to read:

    ret = adv748x_write(state, page, 0x31, 0x82);
    if (ret)
        return ret;

    ret = adv748x_write(state, page, 0x1e, 0x40);
    if (ret)
        return ret;

> 
> > +{
> > +	if (*error)
> > +		return *error;
> > +
> > +	*error = adv748x_write(state, page, reg, value);
> > +	return *error;
> > +}
> > +
> >  /* adv748x_write_block(): Write raw data with a maximum of I2C_SMBUS_BLOCK_MAX
> >   * size to one or more registers.
> >   *
> > @@ -231,69 +241,63 @@ static int adv748x_write_regs(struct adv748x_state *state,
> >   * TXA and TXB
> >   */
> >
> > -static const struct adv748x_reg_value adv748x_power_up_txa_4lane[] = {
> > -
> > -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> > -	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
> > -
> > -	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> > -	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> > -	{ADV748X_PAGE_TXA, 0x00, 0x24 },/* Power-up CSI-TX */
> > -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > -	{ADV748X_PAGE_TXA, 0xc1, 0x2b},	/* ADI Required Write */
> > -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > -	{ADV748X_PAGE_TXA, 0x31, 0x80},	/* ADI Required Write */
> > -
> > -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> > -};
> > -
> > -static const struct adv748x_reg_value adv748x_power_down_txa_4lane[] = {
> > -
> > -	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXA, 0x1e, 0x00},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> > -	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> > -	{ADV748X_PAGE_TXA, 0xc1, 0x3b},	/* ADI Required Write */
> > -
> > -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> > -};
> > -
> > -static const struct adv748x_reg_value adv748x_power_up_txb_1lane[] = {
> > -
> > -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> > -	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
> > -
> > -	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXB, 0x1e, 0x40},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> > -	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> > -	{ADV748X_PAGE_TXB, 0x00, 0x21 },/* Power-up CSI-TX */
> > -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > -	{ADV748X_PAGE_TXB, 0xc1, 0x2b},	/* ADI Required Write */
> > -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > -	{ADV748X_PAGE_TXB, 0x31, 0x80},	/* ADI Required Write */
> > -
> > -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> > -};
> > -
> > -static const struct adv748x_reg_value adv748x_power_down_txb_1lane[] = {
> > -
> > -	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXB, 0x1e, 0x00},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> > -	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> > -	{ADV748X_PAGE_TXB, 0xc1, 0x3b},	/* ADI Required Write */
> > -
> > -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> > -};
> > +static int adv748x_power_up_tx(struct adv748x_csi2 *tx)
> > +{
> > +	struct adv748x_state *state = tx->state;
> > +	u8 page = is_txa(tx) ? ADV748X_PAGE_TXA : ADV748X_PAGE_TXB;
> > +	int ret = 0;
> > +
> > +	/* Enable 4-lane MIPI */
> > +	adv748x_write_check(state, page, 0x00, 0x80 | tx->num_lanes, &ret);
> > +
> > +	/* Set Auto DPHY Timing */
> > +	adv748x_write_check(state, page, 0x00, 0xa0 | tx->num_lanes, &ret);
> > +
> > +	/* ADI Required Writes*/
> > +	adv748x_write_check(state, page, 0x31, 0x82, &ret);
> > +	adv748x_write_check(state, page, 0x1e, 0x40, &ret);
> > +
> > +	/* i2c_mipi_pll_en - 1'b1 */
> > +	adv748x_write_check(state, page, 0xda, 0x01, &ret);
> > +	usleep_range(2000, 2500);
> > +
> > +	/* Power-up CSI-TX */
> > +	adv748x_write_check(state, page, 0x00, 0x20 | tx->num_lanes, &ret);
> > +	usleep_range(1000, 1500);
> > +
> > +	/* ADI Required Writes*/
> > +	adv748x_write_check(state, page, 0xc1, 0x2b, &ret);
> > +	usleep_range(1000, 1500);
> > +	adv748x_write_check(state, page, 0x31, 0x80, &ret);
> > +
> > +	return ret;
> > +}
> > +
> > +static int adv748x_power_down_tx(struct adv748x_csi2 *tx)
> > +{
> > +	struct adv748x_state *state = tx->state;
> > +	u8 page = is_txa(tx) ? ADV748X_PAGE_TXA : ADV748X_PAGE_TXB;
> > +	int ret = 0;
> > +
> > +	/* ADI Required Writes */
> > +	adv748x_write_check(state, page, 0x31, 0x82, &ret);
> > +	adv748x_write_check(state, page, 0x1e, 0x00, &ret);
> > +
> > +	/* Enable 4-lane MIPI */
> > +	adv748x_write_check(state, page, 0x00, 0x80 | tx->num_lanes, &ret);
> > +
> > +	/* i2c_mipi_pll_en - 1'b1 */
> > +	adv748x_write_check(state, page, 0xda, 0x01, &ret);
> > +
> > +	/* ADI Required Write */
> > +	adv748x_write_check(state, page, 0xc1, 0x3b, &ret);
> > +
> > +	return ret;
> > +}
> 
> This one looks good to me
> 
> >
> >  int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
> >  {
> > -	struct adv748x_state *state = tx->state;
> > -	const struct adv748x_reg_value *reglist;
> > -	int val;
> > +	int val, ret;
> >
> >  	if (!is_tx_enabled(tx))
> >  		return 0;
> > @@ -311,13 +315,11 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
> >  			"Enabling with unknown bit set");
> >
> >  	if (on)
> > -		reglist = is_txa(tx) ? adv748x_power_up_txa_4lane :
> > -				       adv748x_power_up_txb_1lane;
> > +		ret = adv748x_power_up_tx(tx);
> >  	else
> > -		reglist = is_txa(tx) ? adv748x_power_down_txa_4lane :
> > -				       adv748x_power_down_txb_1lane;
> > +		ret = adv748x_power_down_tx(tx);
> >
> > -	return adv748x_write_regs(state, reglist);
> > +	return ret;
> 
> As Laurent suggested, or even
>         return on ? adv748x_power_up_tx(tx) : adv748x_power_down_tx(tx);

Good idea!

> 
> Thanks
>    j
> 
> >  }
> >
> >  /* -----------------------------------------------------------------------------
> > --
> > 2.19.0
> >



-- 
Regards,
Niklas Söderlund
