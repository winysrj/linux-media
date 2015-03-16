Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46754 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964923AbbCPVhT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 17:37:19 -0400
Message-ID: <55074D0C.40303@iki.fi>
Date: Mon, 16 Mar 2015 23:37:16 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>, mchehab@osg.samsung.com
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 06/10] mn88472: implement firmware parity check
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se> <1426460275-3766-6-git-send-email-benjamin@southpole.se>
In-Reply-To: <1426460275-3766-6-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2015 12:57 AM, Benjamin Larsson wrote:
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Applied!

Please don't use dev_err() logging for nothing but errors. That last 
logging should be dev_dbg(), but as this is staging driver and features 
really rule over minor issues I will simply apply that and fix minor 
issues later.

regards
Antti



> ---
>   drivers/staging/media/mn88472/mn88472.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>
> diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
> index 5070c37..4a00a4d 100644
> --- a/drivers/staging/media/mn88472/mn88472.c
> +++ b/drivers/staging/media/mn88472/mn88472.c
> @@ -258,6 +258,7 @@ static int mn88472_init(struct dvb_frontend *fe)
>   	int ret, len, remaining;
>   	const struct firmware *fw = NULL;
>   	u8 *fw_file = MN88472_FIRMWARE;
> +	unsigned int csum;
>
>   	dev_dbg(&client->dev, "\n");
>
> @@ -303,6 +304,20 @@ static int mn88472_init(struct dvb_frontend *fe)
>   		}
>   	}
>
> +	/* parity check of firmware */
> +	ret = regmap_read(dev->regmap[0], 0xf8, &csum);
> +	if (ret) {
> +		dev_err(&client->dev,
> +				"parity reg read failed=%d\n", ret);
> +		goto err;
> +	}
> +	if (csum & 0x10) {
> +		dev_err(&client->dev,
> +				"firmware parity check failed=0x%x\n", csum);
> +		goto err;
> +	}
> +	dev_err(&client->dev, "firmware parity check succeeded=0x%x\n", csum);
> +
>   	ret = regmap_write(dev->regmap[0], 0xf5, 0x00);
>   	if (ret)
>   		goto err;
>

-- 
http://palosaari.fi/
