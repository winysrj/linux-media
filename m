Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f182.google.com ([209.85.208.182]:46037 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727660AbeISBDj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 21:03:39 -0400
Received: by mail-lj1-f182.google.com with SMTP id u83-v6so2809686lje.12
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 12:29:35 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Tue, 18 Sep 2018 21:29:32 +0200
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/3] i2c: adv748x: configure number of lanes used for TXA
 CSI-2 transmitter
Message-ID: <20180918192932.GW18450@bigcity.dyn.berto.se>
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
 <20180918014509.6394-3-niklas.soderlund+renesas@ragnatech.se>
 <cfcaa7a5-d642-e5cc-485b-267c7e5846a1@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cfcaa7a5-d642-e5cc-485b-267c7e5846a1@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thanks for your comments.

On 2018-09-18 11:13:45 +0100, Kieran Bingham wrote:
> Hi Niklas,
> 
> Thank you for the patch,
> 
> On 18/09/18 02:45, Niklas Söderlund wrote:
> > The driver fixed the TXA CSI-2 transmitter in 4-lane mode while it could
> > operate using 1-, 2- and 4-lanes. Update the driver to support all modes
> > the hardware does.
> > 
> > The driver make use of large tables of static register/value writes when
> > configuring the hardware, some writing to undocumented registers.
> > Instead of creating 3 sets of the register tables for the different
> > modes catch when the register containing NUM_LANES[2:0] is written to
> > and inject the correct number of lanes.
> > 
> 
> Aye aye aye.
> 
> Neat solution to avoid adding more tables - but is it necessary? And I
> can't find it easy to overlook the hack value in checking every register
> write against a specific value :-(

I agree it's not the most obvious nice solution.

> 
> 
> Couldn't we create a function called "adv748x_configure_tx_lanes(...)"
> or such and just write this value as appropriate after the tables are
> written?
> 
> That will then hopefully take us a step towards not needing (as much of)
> these tables.

This was my starting point :-) But the register is referenced multiple 
times in the tables and converting the tables to individual register 
writes turned out such a mess I judged this solution to be less of a 
maintenance burden. I'm however open to your views on how you would 
prefer this to be handled. Keep in mind that each row in the register 
tables needs to be turned into a:

    /* Write registerx */
    ret = adv748x_write(...)
    if (ret)
        return ret;

So the overview of what happens become much harder to read. Other 
options such as creating copies of the tables and injecting the NUM_LANE 
value at probe time I feel just hides the behavior even more.

Another option I tried was to splice the tables whenever the register in 
question was referenced. This became hard to read but less lines of 
code.

> However - *I fully understand ordering may be important here* so
> actually it looks like we can't write this after writing the table.
> 
> But it does look conveniently early in the tables, so we could split the
> tables out and start functionalising them with the information we do know.

I have not tested if ordering is important or not, the documentation we 
have is just a sequential list of register writes, The register is used 
in multiple places in the tables making things even more ugly.

adv748x_power_up_txa_4lane: 3 times, beginning and middle
adv748x_power_down_txa_4lane: 1 time, middle
adv748x_init_txa_4lane: 3 times, middle and end

> 
> I.e. We could have our init function enable the lanes, and handle the
> auto DPHY, then write the rest through the tables.

If only that where possible :-)

I hold off posting v2 until I know how you wish to handle this. To help 
you make a decision the number of register writes in the tables involved 
:-)

adv748x_power_up_txa_4lane: 11
adv748x_power_down_txa_4lane: 5
adv748x_init_txa_4lane: ~50

> 
> 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/i2c/adv748x/adv748x-core.c | 38 +++++++++++++++++++-----
> >  1 file changed, 30 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> > index a93f8ea89a228474..9a82cdf301bccb41 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > @@ -207,13 +207,23 @@ static int adv748x_write_regs(struct adv748x_state *state,
> >  			      const struct adv748x_reg_value *regs)
> >  {
> >  	int ret;
> > +	u8 value;
> >  
> >  	while (regs->page != ADV748X_PAGE_EOR) {
> >  		if (regs->page == ADV748X_PAGE_WAIT) {
> >  			msleep(regs->value);
> >  		} else {
> > +			value = regs->value;
> > +
> > +			/*
> > +			 * Register 0x00 in TXA needs to bei injected with
> 
> s/bei/be/
> 
> > +			 * the number of CSI-2 lanes used to transmitt.
> 
> s/transmitt/transmit/
> 
> > +			 */
> > +			if (regs->page == ADV748X_PAGE_TXA && regs->reg == 0x00)
> > +				value = (value & ~7) | state->txa.num_lanes;
> > +
> >  			ret = adv748x_write(state, regs->page, regs->reg,
> > -				      regs->value);
> > +					    value);
> >  			if (ret < 0) {
> >  				adv_err(state,
> >  					"Error regs page: 0x%02x reg: 0x%02x\n",
> > @@ -233,14 +243,18 @@ static int adv748x_write_regs(struct adv748x_state *state,
> >  
> >  static const struct adv748x_reg_value adv748x_power_up_txa_4lane[] = {
> >  
> > -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> > -	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
> > +	/* NOTE: NUM_LANES[2:0] in TXA register 0x00 is injected on write. */
> > +	{ADV748X_PAGE_TXA, 0x00, 0x80},	/* Enable n-lane MIPI */
> > +	{ADV748X_PAGE_TXA, 0x00, 0xa0},	/* Set Auto DPHY Timing */
> >  
> >  	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> >  	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
> >  	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> >  	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> > -	{ADV748X_PAGE_TXA, 0x00, 0x24 },/* Power-up CSI-TX */
> > +
> > +	/* NOTE: NUM_LANES[2:0] in TXA register 0x00 is injected on write. */
> > +	{ADV748X_PAGE_TXA, 0x00, 0x20 },/* Power-up CSI-TX */
> > +
> >  	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> >  	{ADV748X_PAGE_TXA, 0xc1, 0x2b},	/* ADI Required Write */
> >  	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > @@ -253,7 +267,10 @@ static const struct adv748x_reg_value adv748x_power_down_txa_4lane[] = {
> >  
> >  	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> >  	{ADV748X_PAGE_TXA, 0x1e, 0x00},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> > +
> > +	/* NOTE: NUM_LANES[2:0] in TXA register 0x00 is injected on write. */
> > +	{ADV748X_PAGE_TXA, 0x00, 0x80},	/* Enable n-lane MIPI */
> 
> If we're in power down - shouldn't this be "Disable n-lane MIPI */ ??

Well the register write enables the lanes. IIRC the comments here come 
from the register tables text files found in the "documentation".

> 
> > +
> >  	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> >  	{ADV748X_PAGE_TXA, 0xc1, 0x3b},	/* ADI Required Write */
> >  
> > @@ -399,8 +416,10 @@ static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
> >  	/* Outputs Enabled */
> >  	{ADV748X_PAGE_IO, 0x10, 0xa0},	/* Enable 4-lane CSI Tx & Pixel Port */
> >  
> > -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> > -	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
> > +	/* NOTE: NUM_LANES[2:0] in TXA register 0x00 is injected on write. */
> > +	{ADV748X_PAGE_TXA, 0x00, 0x80},	/* Enable n-lane MIPI */
> > +	{ADV748X_PAGE_TXA, 0x00, 0xa0},	/* Set Auto DPHY Timing */
> > +
> >  	{ADV748X_PAGE_TXA, 0xdb, 0x10},	/* ADI Required Write */
> >  	{ADV748X_PAGE_TXA, 0xd6, 0x07},	/* ADI Required Write */
> >  	{ADV748X_PAGE_TXA, 0xc4, 0x0a},	/* ADI Required Write */
> > @@ -412,7 +431,10 @@ static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
> >  	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
> >  	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> >  	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> > -	{ADV748X_PAGE_TXA, 0x00, 0x24 },/* Power-up CSI-TX */
> > +
> > +	/* NOTE: NUM_LANES[2:0] in TXA register 0x00 is injected on write. */
> > +	{ADV748X_PAGE_TXA, 0x00, 0x20 },/* Power-up CSI-TX */
> > +
> >  	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> >  	{ADV748X_PAGE_TXA, 0xc1, 0x2b},	/* ADI Required Write */
> >  	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > 
> 
> -- 
> Regards
> --
> Kieran

-- 
Regards,
Niklas Söderlund
