Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40477 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaLGWgZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Dec 2014 17:36:25 -0500
Message-ID: <5484D666.6060605@iki.fi>
Date: Mon, 08 Dec 2014 00:36:22 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] mn88472: fix firmware loading
References: <1417990203-758-1-git-send-email-benjamin@southpole.se> <1417990203-758-2-git-send-email-benjamin@southpole.se>
In-Reply-To: <1417990203-758-2-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/08/2014 12:10 AM, Benjamin Larsson wrote:
> The firmware must be loaded one byte at a time via the 0xf6 register.

I don't think so. Currently it downloads firmware in 22 byte chunks and 
it seems to work, at least for me, both mn88472 and mn88473.

> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
> ---
>   drivers/staging/media/mn88472/mn88472.c | 21 +++++++--------------
>   1 file changed, 7 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
> index ffee187..ba1bc8d 100644
> --- a/drivers/staging/media/mn88472/mn88472.c
> +++ b/drivers/staging/media/mn88472/mn88472.c
> @@ -290,7 +290,7 @@ static int mn88472_init(struct dvb_frontend *fe)
>   {
>   	struct i2c_client *client = fe->demodulator_priv;
>   	struct mn88472_dev *dev = i2c_get_clientdata(client);
> -	int ret, len, remaining;
> +	int ret, i;
>   	const struct firmware *fw = NULL;
>   	u8 *fw_file = MN88472_FIRMWARE;
>
> @@ -330,19 +330,12 @@ static int mn88472_init(struct dvb_frontend *fe)
>   	if (ret)
>   		goto err;
>
> -	for (remaining = fw->size; remaining > 0;
> -			remaining -= (dev->i2c_wr_max - 1)) {
> -		len = remaining;
> -		if (len > (dev->i2c_wr_max - 1))
> -			len = (dev->i2c_wr_max - 1);
> -
> -		ret = regmap_bulk_write(dev->regmap[0], 0xf6,
> -				&fw->data[fw->size - remaining], len);
> -		if (ret) {
> -			dev_err(&client->dev,
> -					"firmware download failed=%d\n", ret);
> -			goto err;
> -		}
> +	for (i = 0 ; i < fw->size ; i++)
> +		ret |= regmap_write(dev->regmap[0], 0xf6, fw->data[i]);
> +	if (ret) {
> +		dev_err(&client->dev,
> +				"firmware download failed=%d\n", ret);
> +		goto err;
>   	}

Not nice.

1) You mask status and you could not know if error code is valid after 
mask few thousand error codes.

2) Even worse, it is loop that runs thousand of times. Guess how much 
I/O errors there could happen. There is many times situation when first 
error occur then all the rest commands are failing too. And many cases 
failing I2C command could be failed USB message, which could take few 
seconds. Very typical USB timeout is 2 secs, this means 2k firmware, 
2*2000=4000 sec => it blocks that routine over *one* hour.

>
>   	ret = regmap_write(dev->regmap[0], 0xf5, 0x00);
>

regards
Antti

-- 
http://palosaari.fi/
