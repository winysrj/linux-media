Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6B1C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 21:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05D68217F5
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 21:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfBRVEb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 16:04:31 -0500
Received: from gofer.mess.org ([88.97.38.141]:55077 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726991AbfBRVEa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 16:04:30 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id DDB9F60340; Mon, 18 Feb 2019 21:04:28 +0000 (GMT)
Date:   Mon, 18 Feb 2019 21:04:28 +0000
From:   Sean Young <sean@mess.org>
To:     tskd08@gmail.com
Cc:     linux-media@vger.kernel.org, mchehab@kernel.org
Subject: Re: [PATCH] media: dvb/earth-pt1: fix wrong initialization for demod
 blocks
Message-ID: <20190218210428.uink722bty5lxdzx@gofer.mess.org>
References: <20190110095623.28070-1-tskd08@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190110095623.28070-1-tskd08@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

Thank you for your patch.

On Thu, Jan 10, 2019 at 06:56:23PM +0900, tskd08@gmail.com wrote:
> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> earth-pt1 driver was decomposed/restructured by the commit: b732539efdba
> ("media: dvb: earth-pt1: decompose pt1 driver into sub drivers"),
> but it introduced a problem regarding concurrent streaming:
> Opening a new terrestial stream stops the reception of an existing,
> already-opened satellite stream.
> 
> The demod IC in earth-pt1 boards contains 2 pairs of terr. and sat. blocks,
> supporting 4 concurrent demodulations, and the above problem was because
> the config of a terr. block contained whole reset/init of the pair blocks,
> thus each open() of a terrestrial frontend wrongly cleared the config of
> its peer satellite block of the demod.
> This whole/pair reset should be executed earlier and not on each open().
> 
> Fixes: b732539efdba ("media: dvb: earth-pt1: decompose pt1 driver into sub drivers")
> Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
> ---
>  drivers/media/pci/pt1/pt1.c | 54 ++++++++++++++++++++++++++++++++-----
>  1 file changed, 48 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
> index f4b8030e236..403f88ee3d9 100644
> --- a/drivers/media/pci/pt1/pt1.c
> +++ b/drivers/media/pci/pt1/pt1.c
> @@ -200,16 +200,10 @@ static const u8 va1j5jf8007t_25mhz_configs[][2] = {
>  static int config_demod(struct i2c_client *cl, enum pt1_fe_clk clk)
>  {
>  	int ret;
> -	u8 buf[2] = {0x01, 0x80};
>  	bool is_sat;
>  	const u8 (*cfg_data)[2];
>  	int i, len;
>  
> -	ret = i2c_master_send(cl, buf, 2);
> -	if (ret < 0)
> -		return ret;
> -	usleep_range(30000, 50000);
> -
>  	is_sat = !strncmp(cl->name, TC90522_I2C_DEV_SAT,
>  			  strlen(TC90522_I2C_DEV_SAT));
>  	if (is_sat) {
> @@ -260,6 +254,46 @@ static int config_demod(struct i2c_client *cl, enum pt1_fe_clk clk)
>  	return 0;
>  }
>  
> +/*
> + * Init registers for (each pair of) terrestrial/satellite block in demod.
> + * Note that resetting terr. block also resets its peer sat. block as well.
> + * This function must be called before configuring any demod block
> + * (before pt1_wakeup(), fe->ops.init()).
> + */
> +static int pt1_demod_block_init(struct pt1 *pt1)
> +{
> +	struct i2c_client *cl;
> +	u8 buf[2] = {0x01, 0x80};
> +	int ret;
> +	int i;
> +
> +	/* reset all terr. & sat. pairs first */
> +	for (i = 0; i < PT1_NR_ADAPS; i++) {
> +		cl = pt1->adaps[i]->demod_i2c_client;
> +		if (strncmp(cl->name, TC90522_I2C_DEV_TER,
> +			     strlen(TC90522_I2C_DEV_TER)))
> +			continue;
> +
> +		ret = i2c_master_send(cl, buf, 2);
> +		if (ret < 0)
> +			return ret;
> +		usleep_range(30000, 50000);
> +	}
> +
> +	for (i = 0; i < PT1_NR_ADAPS; i++) {
> +		cl = pt1->adaps[i]->demod_i2c_client;
> +		if (strncmp(cl->name, TC90522_I2C_DEV_SAT,
> +			     strlen(TC90522_I2C_DEV_SAT)))
> +			continue;
> +
> +		ret = i2c_master_send(cl, buf, 2);
> +		if (ret < 0)
> +			return ret;
> +		usleep_range(30000, 50000);
> +	}

It might be possible to simplify the code a little by using strcmp() and
making it into one loop, like so:

	for (i = 0; i < PT1_NR_ADAPS; i++) {
		cl = pt1->adaps[i]->demod_i2c_client;
		if (strcmp(cl->name, TC90522_I2C_DEV_SAT) &&
		    strcmp(cl->name, TC90522_I2C_DEV_TER)) 
			continue;

		ret = i2c_master_send(cl, buf, 2);
		if (ret < 0)
			return ret;

		usleep_range(30000, 50000);
	}


> +	return 0;
> +}
> +
>  static void pt1_write_reg(struct pt1 *pt1, int reg, u32 data)
>  {
>  	writel(data, pt1->regs + reg * 4);
> @@ -987,6 +1021,10 @@ static int pt1_init_frontends(struct pt1 *pt1)
>  			goto tuner_release;
>  	}
>  
> +	ret = pt1_demod_block_init(pt1);
> +	if (ret < 0)
> +		goto fe_unregister;
> +
>  	return 0;
>  
>  tuner_release:
> @@ -1245,6 +1283,10 @@ static int pt1_resume(struct device *dev)
>  	pt1_update_power(pt1);
>  	usleep_range(1000, 2000);
>  
> +	ret = pt1_demod_block_init(pt1);
> +	if (ret < 0)
> +		goto resume_err;
> +
>  	for (i = 0; i < PT1_NR_ADAPS; i++)
>  		dvb_frontend_reinitialise(pt1->adaps[i]->fe);
>  
> -- 
> 2.20.1

Many thanks,

Sean
