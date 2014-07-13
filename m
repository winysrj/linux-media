Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58724 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbaGMRO6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jul 2014 13:14:58 -0400
Message-ID: <53C2BE90.2090209@iki.fi>
Date: Sun, 13 Jul 2014 20:14:56 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 4/6] si2157: Add support for Si2158 chip
References: <1405259542-32529-1-git-send-email-olli.salonen@iki.fi> <1405259542-32529-5-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1405259542-32529-5-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Applied!
http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=silabs

Antti


On 07/13/2014 04:52 PM, Olli Salonen wrote:
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/tuners/si2157.c      | 73 +++++++++++++++++++++++++++++++++++---
>   drivers/media/tuners/si2157.h      |  2 +-
>   drivers/media/tuners/si2157_priv.h |  5 ++-
>   3 files changed, 73 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index a92570f9..58c5ef5 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -1,5 +1,5 @@
>   /*
> - * Silicon Labs Si2157 silicon tuner driver
> + * Silicon Labs Si2157/2158 silicon tuner driver
>    *
>    * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
>    *
> @@ -16,6 +16,8 @@
>
>   #include "si2157_priv.h"
>
> +static const struct dvb_tuner_ops si2157_ops;
> +
>   /* execute firmware command */
>   static int si2157_cmd_execute(struct si2157 *s, struct si2157_cmd *cmd)
>   {
> @@ -80,8 +82,11 @@ err:
>   static int si2157_init(struct dvb_frontend *fe)
>   {
>   	struct si2157 *s = fe->tuner_priv;
> -	int ret;
> +	int ret, remaining;
>   	struct si2157_cmd cmd;
> +	u8 chip, len = 0;
> +	const struct firmware *fw = NULL;
> +	u8 *fw_file;
>
>   	dev_dbg(&s->client->dev, "%s:\n", __func__);
>
> @@ -101,6 +106,64 @@ static int si2157_init(struct dvb_frontend *fe)
>   	if (ret)
>   		goto err;
>
> +	chip = cmd.args[2]; /* 57 for Si2157, 58 for Si2158 */
> +
> +	/* Si2158 requires firmware download */
> +	if (chip == 58) {
> +		if (((cmd.args[1] & 0x0f) == 1) && (cmd.args[3] == '2') &&
> +				(cmd.args[4] == '0'))
> +			fw_file = SI2158_A20_FIRMWARE;
> +		else {
> +			dev_err(&s->client->dev,
> +					"%s: no firmware file for Si%d-%c%c defined\n",
> +					KBUILD_MODNAME, chip, cmd.args[3], cmd.args[4]);
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +
> +		/* cold state - try to download firmware */
> +		dev_info(&s->client->dev, "%s: found a '%s' in cold state\n",
> +				KBUILD_MODNAME, si2157_ops.info.name);
> +
> +		/* request the firmware, this will block and timeout */
> +		ret = request_firmware(&fw, fw_file, &s->client->dev);
> +		if (ret) {
> +			dev_err(&s->client->dev, "%s: firmware file '%s' not found\n",
> +					KBUILD_MODNAME, fw_file);
> +			goto err;
> +		}
> +
> +		dev_info(&s->client->dev, "%s: downloading firmware from file '%s'\n",
> +				KBUILD_MODNAME, fw_file);
> +
> +		/* firmware should be n chunks of 17 bytes */
> +		if (fw->size % 17 != 0) {
> +			dev_err(&s->client->dev, "%s: firmware file '%s' is invalid\n",
> +					KBUILD_MODNAME, fw_file);
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +
> +		for (remaining = fw->size; remaining > 0; remaining -= 17) {
> +			memcpy(&len, &fw->data[fw->size - remaining], 1);
> +			memcpy(cmd.args, &fw->data[(fw->size - remaining) + 1],
> +					len);
> +			cmd.wlen = len;
> +			cmd.rlen = 1;
> +			ret = si2157_cmd_execute(s, &cmd);
> +			if (ret) {
> +				dev_err(&s->client->dev,
> +						"%s: firmware download failed=%d\n",
> +						KBUILD_MODNAME, ret);
> +				goto err;
> +			}
> +		}
> +
> +		release_firmware(fw);
> +		fw = NULL;
> +
> +	}
> +
>   	/* reboot the tuner with new firmware? */
>   	memcpy(cmd.args, "\x01\x01", 2);
>   	cmd.wlen = 2;
> @@ -177,7 +240,7 @@ err:
>
>   static const struct dvb_tuner_ops si2157_tuner_ops = {
>   	.info = {
> -		.name           = "Silicon Labs Si2157",
> +		.name           = "Silicon Labs Si2157/Si2158",
>   		.frequency_min  = 110000000,
>   		.frequency_max  = 862000000,
>   	},
> @@ -221,7 +284,7 @@ static int si2157_probe(struct i2c_client *client,
>   	i2c_set_clientdata(client, s);
>
>   	dev_info(&s->client->dev,
> -			"%s: Silicon Labs Si2157 successfully attached\n",
> +			"%s: Silicon Labs Si2157/Si2158 successfully attached\n",
>   			KBUILD_MODNAME);
>   	return 0;
>   err:
> @@ -263,6 +326,6 @@ static struct i2c_driver si2157_driver = {
>
>   module_i2c_driver(si2157_driver);
>
> -MODULE_DESCRIPTION("Silicon Labs Si2157 silicon tuner driver");
> +MODULE_DESCRIPTION("Silicon Labs Si2157/Si2158 silicon tuner driver");
>   MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
>   MODULE_LICENSE("GPL");
> diff --git a/drivers/media/tuners/si2157.h b/drivers/media/tuners/si2157.h
> index f469a09..4465c46 100644
> --- a/drivers/media/tuners/si2157.h
> +++ b/drivers/media/tuners/si2157.h
> @@ -1,5 +1,5 @@
>   /*
> - * Silicon Labs Si2157 silicon tuner driver
> + * Silicon Labs Si2157/2158 silicon tuner driver
>    *
>    * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
>    *
> diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
> index 6db4c97..db79f3c 100644
> --- a/drivers/media/tuners/si2157_priv.h
> +++ b/drivers/media/tuners/si2157_priv.h
> @@ -1,5 +1,5 @@
>   /*
> - * Silicon Labs Si2157 silicon tuner driver
> + * Silicon Labs Si2157/2158 silicon tuner driver
>    *
>    * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
>    *
> @@ -17,6 +17,7 @@
>   #ifndef SI2157_PRIV_H
>   #define SI2157_PRIV_H
>
> +#include <linux/firmware.h>
>   #include "si2157.h"
>
>   /* state struct */
> @@ -35,4 +36,6 @@ struct si2157_cmd {
>   	unsigned rlen;
>   };
>
> +#define SI2158_A20_FIRMWARE "dvb-tuner-si2158-a20-01.fw"
> +
>   #endif
>

-- 
http://palosaari.fi/
