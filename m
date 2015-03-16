Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55124 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535AbbCPVj0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 17:39:26 -0400
Message-ID: <55074D8B.10503@iki.fi>
Date: Mon, 16 Mar 2015 23:39:23 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>, mchehab@osg.samsung.com
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 07/10] mn88473: implement firmware parity check
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se> <1426460275-3766-7-git-send-email-benjamin@southpole.se>
In-Reply-To: <1426460275-3766-7-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2015 12:57 AM, Benjamin Larsson wrote:
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>

Applied with same comments that mn88472 patch.

regards
Antti

> ---
>   drivers/staging/media/mn88473/mn88473.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>
> diff --git a/drivers/staging/media/mn88473/mn88473.c b/drivers/staging/media/mn88473/mn88473.c
> index 84bd4fa..607ce4d 100644
> --- a/drivers/staging/media/mn88473/mn88473.c
> +++ b/drivers/staging/media/mn88473/mn88473.c
> @@ -192,6 +192,7 @@ static int mn88473_init(struct dvb_frontend *fe)
>   	int ret, len, remaining;
>   	const struct firmware *fw = NULL;
>   	u8 *fw_file = MN88473_FIRMWARE;
> +	unsigned int tmp;
>
>   	dev_dbg(&client->dev, "\n");
>
> @@ -227,6 +228,20 @@ static int mn88473_init(struct dvb_frontend *fe)
>   		}
>   	}
>
> +	/* parity check of firmware */
> +	ret = regmap_read(dev->regmap[0], 0xf8, &tmp);
> +	if (ret) {
> +		dev_err(&client->dev,
> +				"parity reg read failed=%d\n", ret);
> +		goto err;
> +	}
> +	if (tmp & 0x10) {
> +		dev_err(&client->dev,
> +				"firmware parity check failed=0x%x\n", tmp);
> +		goto err;
> +	}
> +	dev_err(&client->dev, "firmware parity check succeeded=0x%x\n", tmp);
> +
>   	ret = regmap_write(dev->regmap[0], 0xf5, 0x00);
>   	if (ret)
>   		goto err;
>

-- 
http://palosaari.fi/
