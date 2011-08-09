Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm2.telefonica.net ([213.4.138.18]:17829 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751537Ab1HITqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 15:46:00 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] add support for the dvb-t part of CT-3650 v3
Date: Tue, 9 Aug 2011 21:45:48 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>,
	Guy Martin <gmsoft@tuxicoman.be>
References: <201106070205.08118.jareguero@telefonica.net> <201108081235.35950.jareguero@telefonica.net> <4E4058CB.7080908@iki.fi>
In-Reply-To: <4E4058CB.7080908@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108092145.49090.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Lunes, 8 de Agosto de 2011 23:44:43 Antti Palosaari escribió:
> Reviewed-by: Antti Palosaari <crope@iki.fi>
> 
> It looks just fine.
> 
> regards
> Antti
>
 
Forgot the Signed-off-by

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

Jose Alberto

> On 08/08/2011 01:35 PM, Jose Alberto Reguero wrote:
> > On Martes, 2 de Agosto de 2011 21:21:13 Jose Alberto Reguero escribió:
> >> On Jueves, 28 de Julio de 2011 21:25:01 Jose Alberto Reguero escribió:
> >>> On Miércoles, 27 de Julio de 2011 21:22:26 Antti Palosaari escribió:
> >>>> On 07/24/2011 12:45 AM, Jose Alberto Reguero wrote:
> >>>>> Read without write work as with write. Attached updated patch.
> >>>>> 
> >>>>> ttusb2-6.diff
> >>>>> 
> >>>>> -		read = i+1<  num&&  (msg[i+1].flags&  I2C_M_RD);
> >>>>> +		write_read = i+1<  num&&  (msg[i+1].flags&  I2C_M_RD);
> >>>>> +		read = msg[i].flags&  I2C_M_RD;
> >>>> 
> >>>> ttusb2 I2C-adapter seems to be fine for my eyes now. No more writing
> >>>> any random bytes in case of single read. Good!
> >>>> 
> >>>>> +	.dtv6_if_freq_khz = TDA10048_IF_4000,
> >>>>> +	.dtv7_if_freq_khz = TDA10048_IF_4500,
> >>>>> +	.dtv8_if_freq_khz = TDA10048_IF_5000,
> >>>>> +	.clk_freq_khz     = TDA10048_CLK_16000,
> >>>>> 
> >>>>> 
> >>>>> +static int ct3650_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
> >>>> 
> >>>> cosmetic issue rename to ttusb2_ct3650_i2c_gate_ctrl
> >>>> 
> >>>>>   	{ TDA10048_CLK_16000, TDA10048_IF_4000,  10, 3, 0 },
> >>>>> 
> >>>>> +	{ TDA10048_CLK_16000, TDA10048_IF_4500,   5, 3, 0 },
> >>>>> +	{ TDA10048_CLK_16000, TDA10048_IF_5000,   5, 3, 0 },
> >>>>> 
> >>>>> +	/* Set the  pll registers */
> >>>>> +	tda10048_writereg(state, TDA10048_CONF_PLL1, 0x0f);
> >>>>> +	tda10048_writereg(state, TDA10048_CONF_PLL2, (u8)(state-
> >>>> 
> >>>> pll_mfactor));
> >>>> 
> >>>>> +	tda10048_writereg(state, TDA10048_CONF_PLL3,
> >>>>> tda10048_readreg(state, TDA10048_CONF_PLL3) |
> >>>>> ((u8)(state->pll_nfactor) | 0x40));
> >>>> 
> >>>> This if only issue can have effect to functionality and I want double
> >>>> check. I see few things.
> >>>> 
> >>>> 1) clock (and PLL) settings should be done generally only once at
> >>>> .init() and probably .sleep() in case of needed for sleep. Something
> >>>> like start clock in init, stop clock in sleep. It is usually very
> >>>> first thing to set before other. Now it is in wrong place -
> >>>> .set_frontend().
> >>>> 
> >>>> 2) Those clock settings seem somehow weird. As you set different PLL M
> >>>> divider for 6 MHz bandwidth than others. Have you looked those are
> >>>> really correct? I suspect there could be some other Xtal than 16MHz
> >>>> and thus those are wrong. Which Xtals there is inside device used?
> >>>> There is most likely 3 Xtals, one for each chip. It is metal box
> >>>> nearest to chip.
> >>> 
> >>> I left 6MHz like it was before in the driver. I try to do other way,
> >>> allowing to put different PLL in config that the default ones of the
> >>> driver and initialize it in init.
> >>> 
> >>> Jose Alberto
> >> 
> >> Attached new version of the patch. Adding tda827x lna and doing tda10048
> >> pll in other way.
> >> 
> >> Jose Alberto
> > 
> > Another version, without tda827x lna. It don't improve anything.
> > 
> > Jose Alberto
> > 
> >>>> Ran checkpatch.pl also to find out style issues before send patch.
> >>>> 
> >>>> I have send new version, hopefully final, of MFE. It changes array
> >>>> name from adap->mfe to adap-fe. You should also update that.
> >>>> 
> >>>> 
> >>>> regards
> >>>> Antti
> >>> 
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-media"
> >>> in the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
