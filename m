Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53919 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbbGVRKs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 13:10:48 -0400
Date: Wed, 22 Jul 2015 14:10:40 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 02/12] [media] dvb-pll: Add support for THOMSON DTT7546X
 tuner.
Message-ID: <20150722141040.2be3ca98@recife.lan>
In-Reply-To: <1435158670-7195-3-git-send-email-peter.griffin@linaro.org>
References: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
	<1435158670-7195-3-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 24 Jun 2015 16:11:00 +0100
Peter Griffin <peter.griffin@linaro.org> escreveu:

> This is used in conjunction with the STV0367 demodulator on
> the STV0367-NIM-V1.0 NIM card which can be used with the STi
> STB SoC's.
> 
> This tuner has a fifth register, so some changes have been made
> to accommodate this.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  drivers/media/dvb-frontends/dvb-pll.c | 74 +++++++++++++++++++++++++++++------
>  drivers/media/dvb-frontends/dvb-pll.h |  1 +
>  2 files changed, 64 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
> index 6d8fe88..f7381c7 100644
> --- a/drivers/media/dvb-frontends/dvb-pll.c
> +++ b/drivers/media/dvb-frontends/dvb-pll.c
> @@ -141,6 +141,35 @@ static struct dvb_pll_desc dvb_pll_thomson_dtt7520x = {
>  	},
>  };
>  
> +static void thomson_dtt7546x_bw(struct dvb_frontend *fe, u8 *buf)
> +{
> +	/* set CB2 reg - set ATC, XTO */
> +	buf[4] = 0xc3;
> +}
> +
> +static struct dvb_pll_desc dvb_pll_thomson_dtt7546x = {
> +	.name  = "Thomson dtt7546x",
> +	.min   = 44250000,
> +	.max   = 863250000,
> +	.set   = thomson_dtt7546x_bw,
> +	.iffreq= 36166667,

Whitespace is missing. Please check the patchs with scripts/checkpatch.pl.

> +	.count = 12,
> +	.entries = {
> +		{  121000000, 166667, 0x88, 0x01 },
> +		{  141000000, 166667, 0x88, 0x41 },
> +		{  166000000, 166667, 0x88, 0x81 },
> +		{  182000000, 166667, 0x88, 0xc1 },
> +		{  286000000, 166667, 0x88, 0x02 },
> +		{  386000000, 166667, 0x88, 0x42 },
> +		{  446000000, 166667, 0x88, 0x82 },
> +		{  466000000, 166667, 0x88, 0xc2 },
> +		{  506000000, 166667, 0x88, 0x08 },
> +		{  761000000, 166667, 0x88, 0x48 },
> +		{  846000000, 166667, 0x88, 0x88 },
> +		{  905000000, 166667, 0x88, 0xc8 },
> +	},
> +};
> +
>  static struct dvb_pll_desc dvb_pll_lg_z201 = {
>  	.name  = "LG z201",
>  	.min   = 174000000,
> @@ -537,6 +566,7 @@ static struct dvb_pll_desc dvb_pll_alps_tdee4 = {
>  static struct dvb_pll_desc *pll_list[] = {
>  	[DVB_PLL_UNDEFINED]              = NULL,
>  	[DVB_PLL_THOMSON_DTT7579]        = &dvb_pll_thomson_dtt7579,
> +	[DVB_PLL_THOMSON_DTT7546X]       = &dvb_pll_thomson_dtt7546x,
>  	[DVB_PLL_THOMSON_DTT759X]        = &dvb_pll_thomson_dtt759x,
>  	[DVB_PLL_THOMSON_DTT7520X]       = &dvb_pll_thomson_dtt7520x,
>  	[DVB_PLL_LG_Z201]                = &dvb_pll_lg_z201,
> @@ -561,7 +591,7 @@ static struct dvb_pll_desc *pll_list[] = {
>  /* code                                                        */
>  
>  static int dvb_pll_configure(struct dvb_frontend *fe, u8 *buf,
> -			     const u32 frequency)
> +			const u32 frequency, const u32 len)
>  {
>  	struct dvb_pll_priv *priv = fe->tuner_priv;
>  	struct dvb_pll_desc *desc = priv->pll_desc;
> @@ -593,11 +623,15 @@ static int dvb_pll_configure(struct dvb_frontend *fe, u8 *buf,
>  	if (desc->set)
>  		desc->set(fe, buf);
>  
> -	if (debug)
> -		printk("pll: %s: div=%d | buf=0x%02x,0x%02x,0x%02x,0x%02x\n",
> -		       desc->name, div, buf[0], buf[1], buf[2], buf[3]);
> +	if (debug) {
> +		printk(KERN_DEBUG "pll: %s: div=%d | buf=", desc->name, div);
> +		for (i = 0; i < len; i++)
> +			printk(KERN_DEBUG "0x%02x,", buf[i]);
>  
> -	// calculate the frequency we set it to
> +		printk(KERN_DEBUG "\n");
> +	}

Please use, instead, the Documentation/printk-formats.txt macros to
print an hex buffer:

	"Raw buffer as a hex string:
		%*ph	00 01 02  ...  3f
		%*phC	00:01:02: ... :3f
		%*phD	00-01-02- ... -3f
		%*phN	000102 ... 3f"


> +
> +	/* calculate the frequency we set it to */
>  	return (div * desc->entries[i].stepsize) - desc->iffreq;
>  }
>  
> @@ -634,21 +668,39 @@ static int dvb_pll_sleep(struct dvb_frontend *fe)
>  	return -EINVAL;
>  }
>  
> +static int dvb_pll_get_num_regs(struct dvb_pll_priv *priv)
> +{
> +	int num_regs = 4;
> +
> +	if (strncmp(priv->pll_desc->name, "Thomson dtt7546x", 16) == 0)
> +		num_regs = 5;
> +
> +	return num_regs;
> +}
> +
>  static int dvb_pll_set_params(struct dvb_frontend *fe)
>  {
>  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>  	struct dvb_pll_priv *priv = fe->tuner_priv;
> -	u8 buf[4];
> -	struct i2c_msg msg =
> -		{ .addr = priv->pll_i2c_address, .flags = 0,
> -		  .buf = buf, .len = sizeof(buf) };
> +	struct i2c_msg msg;
> +	u8 *bufp;
>  	int result;
>  	u32 frequency = 0;
>  
> +	bufp = kzalloc(dvb_pll_get_num_regs(priv), GFP_KERNEL);
> +
> +	if (!bufp)
> +		return -ENOMEM;
> +
> +	msg.addr = priv->pll_i2c_address;
> +	msg.flags = 0;
> +	msg.buf = bufp;
> +	msg.len = dvb_pll_get_num_regs(priv);
> +
>  	if (priv->i2c == NULL)
>  		return -EINVAL;
>  
> -	result = dvb_pll_configure(fe, buf, c->frequency);
> +	result = dvb_pll_configure(fe, bufp, c->frequency, msg.len);
>  	if (result < 0)
>  		return result;
>  	else
> @@ -677,7 +729,7 @@ static int dvb_pll_calc_regs(struct dvb_frontend *fe,
>  	if (buf_len < 5)
>  		return -EINVAL;
>  
> -	result = dvb_pll_configure(fe, buf + 1, c->frequency);
> +	result = dvb_pll_configure(fe, buf + 1, c->frequency, buf_len - 1);
>  	if (result < 0)
>  		return result;
>  	else
> diff --git a/drivers/media/dvb-frontends/dvb-pll.h b/drivers/media/dvb-frontends/dvb-pll.h
> index bf9602a..f523f42 100644
> --- a/drivers/media/dvb-frontends/dvb-pll.h
> +++ b/drivers/media/dvb-frontends/dvb-pll.h
> @@ -28,6 +28,7 @@
>  #define DVB_PLL_SAMSUNG_TBMU24112      17
>  #define DVB_PLL_TDEE4		       18
>  #define DVB_PLL_THOMSON_DTT7520X       19
> +#define DVB_PLL_THOMSON_DTT7546X       20
>  
>  /**
>   * Attach a dvb-pll to the supplied frontend structure.
