Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm1.telefonica.net ([213.4.138.17]:26746 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754592Ab3ALVO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Jan 2013 16:14:28 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Antti Palosaari <crope@iki.fi>
Cc: Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: af9035 test needed!
Date: Sat, 12 Jan 2013 22:14:07 +0100
Message-ID: <1399201.n4JJjs39sT@jar7.dominio>
In-Reply-To: <50F0A501.5000103@iki.fi>
References: <50F05C09.3010104@iki.fi> <2909559.M1IsAHpWSv@jar7.dominio> <50F0A501.5000103@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sábado, 12 de enero de 2013 01:49:21 Antti Palosaari escribió:
> On 01/12/2013 01:45 AM, Jose Alberto Reguero wrote:
> > On Viernes, 11 de enero de 2013 20:38:01 Antti Palosaari escribió:
> >> Hello Jose and Gianluca
> >> 
> >> Could you test that (tda18218 & mxl5007t):
> >> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/it9135_t
> >> une r
> >> 
> >> I wonder if ADC config logic still works for superheterodyne tuners
> >> (tuner having IF). I changed it to adc / 2 always due to IT9135 tuner.
> >> That makes me wonder it possible breaks tuners having IF, as ADC was
> >> clocked just over 20MHz and if it is half then it is 10MHz. For BB that
> >> is enough, but I think that having IF, which is 4MHz at least for 8MHz
> >> BW it is too less.
> >> 
> >> F*ck I hate to maintain driver without a hardware! Any idea where I can
> >> get AF9035 device having tda18218 or mxl5007t?
> >> 
> >> regards
> >> Antti
> > 
> > Still pending the changes for  mxl5007t. Attached is a patch for that.
> > 
> > Changes to make work Avermedia Twinstar with the af9035 driver.
> > 
> > Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
> 
> I cannot do much about this as it changes mxl5007t driver which is not
> maintained by me. :)
> 
> regards
> Antti
>

Adding CC to Michael Krufky because it is the maintainer of mxl5007t driver. 
Michael, any chance to get this patch merged?

Jose Alberto
  
> > Jose Alberto
> > 
> > diff -upr linux/drivers/media/tuners/mxl5007t.c
> > linux.new/drivers/media/tuners/mxl5007t.c
> > --- linux/drivers/media/tuners/mxl5007t.c	2012-08-14 05:45:22.000000000
> > +0200 +++ linux.new/drivers/media/tuners/mxl5007t.c	2013-01-10
> > 19:23:09.247556275 +0100
> > @@ -374,7 +374,6 @@ static struct reg_pair_t *mxl5007t_calc_
> > 
> >   	mxl5007t_set_if_freq_bits(state, cfg->if_freq_hz, cfg->invert_if);
> >   	mxl5007t_set_xtal_freq_bits(state, cfg->xtal_freq_hz);
> > 
> > -	set_reg_bits(state->tab_init, 0x04, 0x01, cfg->loop_thru_enable);
> > 
> >   	set_reg_bits(state->tab_init, 0x03, 0x08, cfg->clk_out_enable << 3);
> >   	set_reg_bits(state->tab_init, 0x03, 0x07, cfg->clk_out_amp);
> > 
> > @@ -531,9 +530,12 @@ static int mxl5007t_tuner_init(struct mx
> > 
> >   	struct reg_pair_t *init_regs;
> >   	int ret;
> > 
> > -	ret = mxl5007t_soft_reset(state);
> > -	if (mxl_fail(ret))
> > +	if (!state->config->no_reset) {
> > +		ret = mxl5007t_soft_reset(state);
> > +		if (mxl_fail(ret))
> > 
> >   		goto fail;
> > 
> > +	}
> > +
> > 
> >   	/* calculate initialization reg array */
> >   	init_regs = mxl5007t_calc_init_regs(state, mode);
> > 
> > @@ -887,7 +889,12 @@ struct dvb_frontend *mxl5007t_attach(str
> > 
> >   		if (fe->ops.i2c_gate_ctrl)
> >   		
> >   			fe->ops.i2c_gate_ctrl(fe, 1);
> > 
> > -		ret = mxl5007t_get_chip_id(state);
> > +		if (!state->config->no_probe)
> > +			ret = mxl5007t_get_chip_id(state);
> > +
> > +		ret = mxl5007t_write_reg(state, 0x04,
> > +			state->config->loop_thru_enable);
> > +
> > 
> >   		if (fe->ops.i2c_gate_ctrl)
> >   		
> >   			fe->ops.i2c_gate_ctrl(fe, 0);
> > 
> > diff -upr linux/drivers/media/tuners/mxl5007t.h
> > linux.new/drivers/media/tuners/mxl5007t.h
> > --- linux/drivers/media/tuners/mxl5007t.h	2012-08-14 05:45:22.000000000
> > +0200 +++ linux.new/drivers/media/tuners/mxl5007t.h	2013-01-10
> > 19:19:11.204379581 +0100
> > @@ -73,8 +73,10 @@ struct mxl5007t_config {
> > 
> >   	enum mxl5007t_xtal_freq xtal_freq_hz;
> >   	enum mxl5007t_if_freq if_freq_hz;
> >   	unsigned int invert_if:1;
> > 
> > -	unsigned int loop_thru_enable:1;
> > +	unsigned int loop_thru_enable:3;
> > 
> >   	unsigned int clk_out_enable:1;
> > 
> > +	unsigned int no_probe:1;
> > +	unsigned int no_reset:1;
> > 
> >   };
> >   
> >   #if defined(CONFIG_MEDIA_TUNER_MXL5007T) ||
> > 
> > (defined(CONFIG_MEDIA_TUNER_MXL5007T_MODULE) && defined(MODULE))
> > diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c
> > linux.new/drivers/media/usb/dvb-usb-v2/af9035.c
> > --- linux/drivers/media/usb/dvb-usb-v2/af9035.c	2013-01-07
> > 05:45:57.000000000 +0100
> > +++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2013-01-12
> > 00:30:57.557310465 +0100
> > @@ -886,13 +886,17 @@ static struct mxl5007t_config af9035_mxl
> > 
> >   		.loop_thru_enable = 0,
> >   		.clk_out_enable = 0,
> >   		.clk_out_amp = MxL_CLKOUT_AMP_0_94V,
> > 
> > +		.no_probe = 1,
> > +		.no_reset = 1,
> > 
> >   	}, {
> >   	
> >   		.xtal_freq_hz = MxL_XTAL_24_MHZ,
> >   		.if_freq_hz = MxL_IF_4_57_MHZ,
> >   		.invert_if = 0,
> > 
> > -		.loop_thru_enable = 1,
> > +		.loop_thru_enable = 3,
> > 
> >   		.clk_out_enable = 1,
> >   		.clk_out_amp = MxL_CLKOUT_AMP_0_94V,
> > 
> > +		.no_probe = 1,
> > +		.no_reset = 1,
> > 
> >   	}
> >   
> >   };
