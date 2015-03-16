Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41346 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934175AbbCPVpZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 17:45:25 -0400
Message-ID: <55074EF2.6010304@iki.fi>
Date: Mon, 16 Mar 2015 23:45:22 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>, mchehab@osg.samsung.com
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 09/10] mn88472: check if firmware is already running before
 loading it
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se> <1426460275-3766-9-git-send-email-benjamin@southpole.se>
In-Reply-To: <1426460275-3766-9-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2015 12:57 AM, Benjamin Larsson wrote:
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>

Applied! Please try to add some commit message, even patch topic says it 
all...

regards
Antti

> ---
>   drivers/staging/media/mn88472/mn88472.c | 21 ++++++++++++++++-----
>   1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
> index 4a00a4d..c041fbf 100644
> --- a/drivers/staging/media/mn88472/mn88472.c
> +++ b/drivers/staging/media/mn88472/mn88472.c
> @@ -258,7 +258,7 @@ static int mn88472_init(struct dvb_frontend *fe)
>   	int ret, len, remaining;
>   	const struct firmware *fw = NULL;
>   	u8 *fw_file = MN88472_FIRMWARE;
> -	unsigned int csum;
> +	unsigned int tmp;
>
>   	dev_dbg(&client->dev, "\n");
>
> @@ -274,6 +274,17 @@ static int mn88472_init(struct dvb_frontend *fe)
>   	if (ret)
>   		goto err;
>
> +	/* check if firmware is already running */
> +	ret = regmap_read(dev->regmap[0], 0xf5, &tmp);
> +	if (ret)
> +		goto err;
> +
> +	if (!(tmp & 0x1)) {
> +		dev_info(&client->dev, "firmware already running\n");
> +		dev->warm = true;
> +		return 0;
> +	}
> +
>   	/* request the firmware, this will block and timeout */
>   	ret = request_firmware(&fw, fw_file, &client->dev);
>   	if (ret) {
> @@ -305,18 +316,18 @@ static int mn88472_init(struct dvb_frontend *fe)
>   	}
>
>   	/* parity check of firmware */
> -	ret = regmap_read(dev->regmap[0], 0xf8, &csum);
> +	ret = regmap_read(dev->regmap[0], 0xf8, &tmp);
>   	if (ret) {
>   		dev_err(&client->dev,
>   				"parity reg read failed=%d\n", ret);
>   		goto err;
>   	}
> -	if (csum & 0x10) {
> +	if (tmp & 0x10) {
>   		dev_err(&client->dev,
> -				"firmware parity check failed=0x%x\n", csum);
> +				"firmware parity check failed=0x%x\n", tmp);
>   		goto err;
>   	}
> -	dev_err(&client->dev, "firmware parity check succeeded=0x%x\n", csum);
> +	dev_err(&client->dev, "firmware parity check succeeded=0x%x\n", tmp);
>
>   	ret = regmap_write(dev->regmap[0], 0xf5, 0x00);
>   	if (ret)
>

-- 
http://palosaari.fi/
