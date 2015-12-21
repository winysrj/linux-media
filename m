Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45336 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbbLUCwy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2015 21:52:54 -0500
Subject: Re: [PATCH 2/3] mn88472: add work around for failing firmware loading
To: Benjamin Larsson <benjamin@southpole.se>,
	linux-media@vger.kernel.org
References: <1448763016-10527-1-git-send-email-benjamin@southpole.se>
 <1448763016-10527-2-git-send-email-benjamin@southpole.se>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <56776983.8060905@iki.fi>
Date: Mon, 21 Dec 2015 04:52:51 +0200
MIME-Version: 1.0
In-Reply-To: <1448763016-10527-2-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
I am not sure if problem is I2C adapter/bus or that demodulator I2C 
slave. If it is demod, then that workaround is correct place, but if it 
is not, then that is wrong and I2C adapter repeating logic should be used.

I did some testing again... Loading mn88472 firmware 1000 times, it failed:
61 times RC polling disabled
68 times RC polling enabled
83 times RC polling enabled, but repeated failed message due to that patch

I don't want apply that patch until I find some time myself to examine 
that problem - or someone else does some study to point out whats wrong. 
There is many things to test in order to get better understanding.

regards
Antti

On 11/29/2015 04:10 AM, Benjamin Larsson wrote:
> Sometimes the firmware fails to load because of an i2c error.
> Work around that by adding retry logic. This kind of logic
> also exist in the binary driver and failures have been observed
> there also. Thus this seems to be a property of the hardware
> and a fix like this is needed.
>
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
> ---
>   drivers/staging/media/mn88472/mn88472.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
> index cf2e96b..80c5807 100644
> --- a/drivers/staging/media/mn88472/mn88472.c
> +++ b/drivers/staging/media/mn88472/mn88472.c
> @@ -282,7 +282,7 @@ static int mn88472_init(struct dvb_frontend *fe)
>   	int ret, len, remaining;
>   	const struct firmware *fw = NULL;
>   	u8 *fw_file = MN88472_FIRMWARE;
> -	unsigned int tmp;
> +	unsigned int tmp, retry_cnt;
>
>   	dev_dbg(&client->dev, "\n");
>
> @@ -330,9 +330,22 @@ static int mn88472_init(struct dvb_frontend *fe)
>   		if (len > (dev->i2c_wr_max - 1))
>   			len = dev->i2c_wr_max - 1;
>
> +		/* I2C transfers during firmware load might fail sometimes,
> +		 * just retry in that case. 4 consecutive failures have
> +		 * been observed thus a retry limit of 20 is used.
> +		 */
> +		retry_cnt = 20;
> +retry:
>   		ret = regmap_bulk_write(dev->regmap[0], 0xf6,
>   				&fw->data[fw->size - remaining], len);
>   		if (ret) {
> +			if (retry_cnt) {
> +				dev_dbg(&client->dev,
> +				"i2c error, retry %d triggered\n", retry_cnt);
> +				retry_cnt--;
> +				usleep_range(200, 10000);
> +				goto retry;
> +			}
>   			dev_err(&client->dev,
>   					"firmware download failed=%d\n", ret);
>   			goto firmware_release;
>

-- 
http://palosaari.fi/
