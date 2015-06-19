Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-064.synserver.de ([212.40.185.64]:1112 "EHLO
	smtp-out-064.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbbFSJNI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 05:13:08 -0400
Message-ID: <5583DD1B.20304@metafoo.de>
Date: Fri, 19 Jun 2015 11:12:59 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Pablo Anton <pablo.anton@veo-labs.com>, hans.verkuil@cisco.com
CC: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Subject: Re: [PATCH v2] media: i2c: ADV7604: Migrate to regmap
References: <1434443919-3196-1-git-send-email-pablo.anton@veo-labs.com>
In-Reply-To: <1434443919-3196-1-git-send-email-pablo.anton@veo-labs.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2015 10:38 AM, Pablo Anton wrote:
> This is a preliminary patch in order to add support for ALSA.
> It replaces all current i2c access with regmap.

Looks pretty good.

>   #define ADV76XX_REG(page, offset)	(((page) << 8) | (offset))
> @@ -633,13 +618,15 @@ static int adv76xx_read_reg(struct v4l2_subdev *sd, unsigned int reg)
>   {
>   	struct adv76xx_state *state = to_state(sd);
>   	unsigned int page = reg >> 8;
> +	unsigned int val;
>
>   	if (!(BIT(page) & state->info->page_mask))
>   		return -EINVAL;
>
>   	reg &= 0xff;
> +	regmap_read(state->regmap[page], reg, &val);

should check return value of regmap_read.

>
> -	return adv_smbus_read_byte_data(state, page, reg);
> +	return val;
>   }
>   #endif

> +static int configure_regmap(struct adv76xx_state *state, int region)
> +{
> +	int err;
> +
> +	if (!state->i2c_clients[region])
> +		return -ENODEV;
> +
> +	if (!state->regmap[region]) {
> +
> +		state->regmap[region] =
> +			devm_regmap_init_i2c(state->i2c_clients[region],
> +					     &adv76xx_regmap_cnf[region]);
> +
> +		if (IS_ERR(state->regmap[region])) {
> +			err = PTR_ERR(state->regmap[region]);
> +			v4l_err(state->i2c_clients[region],
> +					"Error initializing regmap %d with error %d\n",
> +					region, err);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int configure_regmaps(struct adv76xx_state *state)
> +{
> +	int i, err;
> +
> +	for (i = 0 ; i < ADV76XX_PAGE_MAX; i++) {

The IO page was already initilaized earlier on, so this should start with i 
= ADV7604_PAGE_AVLINK.

> +		err = configure_regmap(state, i);
> +		if (err && (err != -ENODEV))
> +			return err;
> +	}
> +	return 0;
> +}
> +
>   static int adv76xx_probe(struct i2c_client *client,
>   			 const struct i2c_device_id *id)
>   {
> @@ -2683,7 +2815,7 @@ static int adv76xx_probe(struct i2c_client *client,
>   	struct v4l2_ctrl_handler *hdl;
>   	struct v4l2_subdev *sd;
>   	unsigned int i;
> -	u16 val;
> +	unsigned int val, val2;
>   	int err;
>
>   	/* Check if the adapter supports the needed features */
> @@ -2747,22 +2879,36 @@ static int adv76xx_probe(struct i2c_client *client,
>   		client->addr);
>   	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>
> +	/* Configure IO Regmap region */
> +	err = configure_regmap(state, ADV76XX_PAGE_IO);
> +
> +	if (err) {
> +		v4l2_info(sd, "Error configuring IO regmap region\n");
> +		return -ENODEV;
> +	}
> +
>   	/*
>   	 * Verify that the chip is present. On ADV7604 the RD_INFO register only
>   	 * identifies the revision, while on ADV7611 it identifies the model as
>   	 * well. Use the HDMI slave address on ADV7604 and RD_INFO on ADV7611.
>   	 */
>   	if (state->info->type == ADV7604) {
> -		val = adv_smbus_read_byte_data_check(client, 0xfb, false);
> +		regmap_read(state->regmap[ADV76XX_PAGE_IO], 0xfb, &val);
>   		if (val != 0x68) {
>   			v4l2_info(sd, "not an adv7604 on address 0x%x\n",
>   					client->addr << 1);
>   			return -ENODEV;
>   		}
>   	} else {
> -		val = (adv_smbus_read_byte_data_check(client, 0xea, false) << 8)
> -		    | (adv_smbus_read_byte_data_check(client, 0xeb, false) << 0);
> -		if (val != 0x2051) {
> +		regmap_read(state->regmap[ADV76XX_PAGE_IO],
> +				0xea,
> +				&val);
> +		val2 = val << 8;
> +		regmap_read(state->regmap[ADV76XX_PAGE_IO],
> +			    0xeb,
> +			    &val);

we should check the return value of regmap_read to make sure the device 
responds.

> +		val2 |= val;
> +		if (val2 != 0x2051) {
>   			v4l2_info(sd, "not an adv7611 on address 0x%x\n",
>   					client->addr << 1);
>   			return -ENODEV;
> @@ -2853,6 +2999,11 @@ static int adv76xx_probe(struct i2c_client *client,
>   	if (err)
>   		goto err_work_queues;
>
> +	/* Configure regmaps */
> +	err = configure_regmaps(state);
> +	if (err)
> +		goto err_entity;
> +
>   	err = adv76xx_core_init(sd);
>   	if (err)
>   		goto err_entity;
>

