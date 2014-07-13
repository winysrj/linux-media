Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45820 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbaGMROm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jul 2014 13:14:42 -0400
Message-ID: <53C2BE80.7010409@iki.fi>
Date: Sun, 13 Jul 2014 20:14:40 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/6] si2168: Add handling for different chip revisions
 and firmwares
References: <1405259542-32529-1-git-send-email-olli.salonen@iki.fi> <1405259542-32529-3-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1405259542-32529-3-git-send-email-olli.salonen@iki.fi>
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
>   drivers/media/dvb-frontends/si2168.c      | 34 ++++++++++++++++++++++++++-----
>   drivers/media/dvb-frontends/si2168_priv.h |  4 +++-
>   2 files changed, 32 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index bae7771..268fce3 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -333,7 +333,7 @@ static int si2168_init(struct dvb_frontend *fe)
>   	struct si2168 *s = fe->demodulator_priv;
>   	int ret, len, remaining;
>   	const struct firmware *fw = NULL;
> -	u8 *fw_file = SI2168_FIRMWARE;
> +	u8 *fw_file;
>   	const unsigned int i2c_wr_max = 8;
>   	struct si2168_cmd cmd;
>
> @@ -353,6 +353,7 @@ static int si2168_init(struct dvb_frontend *fe)
>   	if (ret)
>   		goto err;
>
> +	/* query chip revision */
>   	memcpy(cmd.args, "\x02", 1);
>   	cmd.wlen = 1;
>   	cmd.rlen = 13;
> @@ -360,6 +361,20 @@ static int si2168_init(struct dvb_frontend *fe)
>   	if (ret)
>   		goto err;
>
> +	if (((cmd.args[1] & 0x0f) == 2) && (cmd.args[3] == '4') &&
> +			(cmd.args[4] == '0'))
> +		fw_file = SI2168_B40_FIRMWARE;
> +	else if (((cmd.args[1] & 0x0f) == 1) && (cmd.args[3] == '3') &&
> +			(cmd.args[4] == '0'))
> +		fw_file = SI2168_A30_FIRMWARE;
> +	else {
> +		dev_err(&s->client->dev,
> +				"%s: no firmware file for Si2168-%c%c defined\n",
> +				KBUILD_MODNAME, cmd.args[3], cmd.args[4]);
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
>   	/* cold state - try to download firmware */
>   	dev_info(&s->client->dev, "%s: found a '%s' in cold state\n",
>   			KBUILD_MODNAME, si2168_ops.info.name);
> @@ -367,9 +382,18 @@ static int si2168_init(struct dvb_frontend *fe)
>   	/* request the firmware, this will block and timeout */
>   	ret = request_firmware(&fw, fw_file, &s->client->dev);
>   	if (ret) {
> -		dev_err(&s->client->dev, "%s: firmare file '%s' not found\n",
> -				KBUILD_MODNAME, fw_file);
> -		goto err;
> +		/* fallback mechanism to handle old name for
> +		   SI2168_B40_FIRMWARE */
> +		if (((cmd.args[1] & 0x0f) == 2) && (cmd.args[3] == '4') &&
> +				(cmd.args[4] == '0')) {
> +			fw_file = SI2168_B40_FIRMWARE_FALLBACK;
> +			ret = request_firmware(&fw, fw_file, &s->client->dev);
> +		}
> +		if (ret) {
> +			dev_err(&s->client->dev, "%s: firmware file '%s' not found\n",
> +					KBUILD_MODNAME, fw_file);
> +			goto err;
> +		}
>   	}
>
>   	dev_info(&s->client->dev, "%s: downloading firmware from file '%s'\n",
> @@ -629,4 +653,4 @@ module_i2c_driver(si2168_driver);
>   MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
>   MODULE_DESCRIPTION("Silicon Labs Si2168 DVB-T/T2/C demodulator driver");
>   MODULE_LICENSE("GPL");
> -MODULE_FIRMWARE(SI2168_FIRMWARE);
> +MODULE_FIRMWARE(SI2168_B40_FIRMWARE);
> diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
> index 97f9d87..bebb68a 100644
> --- a/drivers/media/dvb-frontends/si2168_priv.h
> +++ b/drivers/media/dvb-frontends/si2168_priv.h
> @@ -22,7 +22,9 @@
>   #include <linux/firmware.h>
>   #include <linux/i2c-mux.h>
>
> -#define SI2168_FIRMWARE "dvb-demod-si2168-02.fw"
> +#define SI2168_A30_FIRMWARE "dvb-demod-si2168-a30-01.fw"
> +#define SI2168_B40_FIRMWARE "dvb-demod-si2168-b40-01.fw"
> +#define SI2168_B40_FIRMWARE_FALLBACK "dvb-demod-si2168-02.fw"
>
>   /* state struct */
>   struct si2168 {
>

-- 
http://palosaari.fi/
