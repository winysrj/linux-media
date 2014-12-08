Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44568 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbaLHU7g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 15:59:36 -0500
Message-ID: <54861136.8050002@iki.fi>
Date: Mon, 08 Dec 2014 22:59:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] mn88472: implement firmware parity check
References: <1418070667-13349-1-git-send-email-benjamin@southpole.se> <1418070667-13349-2-git-send-email-benjamin@southpole.se>
In-Reply-To: <1418070667-13349-2-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

PS. something to say about logging levels... but as it is staging 
driver, criteria for patches is not so high yet.

regards
Antti

On 12/08/2014 10:31 PM, Benjamin Larsson wrote:
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
> ---
>   drivers/staging/media/mn88472/mn88472.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>
> diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
> index df7dbe9..1df85a7 100644
> --- a/drivers/staging/media/mn88472/mn88472.c
> +++ b/drivers/staging/media/mn88472/mn88472.c
> @@ -294,6 +294,7 @@ static int mn88472_init(struct dvb_frontend *fe)
>   	int ret, len, remaining;
>   	const struct firmware *fw = NULL;
>   	u8 *fw_file = MN88472_FIRMWARE;
> +	unsigned int csum;
>
>   	dev_dbg(&client->dev, "\n");
>
> @@ -346,6 +347,20 @@ static int mn88472_init(struct dvb_frontend *fe)
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
