Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57119 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933947AbbHKKVA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 06:21:00 -0400
Date: Tue, 11 Aug 2015 07:20:55 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 09/12] tda10071: use jiffies when poll firmware status
Message-ID: <20150811072055.55eeb0d4@recife.lan>
In-Reply-To: <1436414792-9716-9-git-send-email-crope@iki.fi>
References: <1436414792-9716-1-git-send-email-crope@iki.fi>
	<1436414792-9716-9-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  9 Jul 2015 07:06:29 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Use jiffies to set timeout for firmware command status polling.
> It is more elegant solution than poll X times with sleep.
> 
> Shorten timeout to 30ms as all commands seems to be executed under
> 10ms.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/dvb-frontends/tda10071.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
> index 6226b57..c1507cc 100644
> --- a/drivers/media/dvb-frontends/tda10071.c
> +++ b/drivers/media/dvb-frontends/tda10071.c
> @@ -53,8 +53,9 @@ static int tda10071_cmd_execute(struct tda10071_dev *dev,
>  	struct tda10071_cmd *cmd)
>  {
>  	struct i2c_client *client = dev->client;
> -	int ret, i;
> +	int ret;
>  	unsigned int uitmp;
> +	unsigned long timeout;
>  
>  	if (!dev->warm) {
>  		ret = -EFAULT;
> @@ -72,17 +73,19 @@ static int tda10071_cmd_execute(struct tda10071_dev *dev,
>  		goto error;
>  
>  	/* wait cmd execution terminate */
> -	for (i = 1000, uitmp = 1; i && uitmp; i--) {
> +	#define CMD_EXECUTE_TIMEOUT 30
> +	timeout = jiffies + msecs_to_jiffies(CMD_EXECUTE_TIMEOUT);
> +	for (uitmp = 1; !time_after(jiffies, timeout) && uitmp;) {
>  		ret = regmap_read(dev->regmap, 0x1f, &uitmp);
>  		if (ret)
>  			goto error;
> -
> -		usleep_range(200, 5000);

Hmm... removing the usleep() doesn't sound a good idea. You'll be
flooding the I2C bus with read commands and spending CPU cycles
for 30ms spending more power than the previous code. That doesn't
sound more "elegant solution than poll X times with sleep" for me.

So, I would keep the usleep_range() here and add a better
comment on the patch description.

I'll skip this patch from the git pull request, as, from your description,
this is just a cleanup patch. So, it shouldn't affect the other patches
at the series.


>  	}
>  
> -	dev_dbg(&client->dev, "loop=%d\n", i);
> +	dev_dbg(&client->dev, "cmd execution took %u ms\n",
> +		jiffies_to_msecs(jiffies) -
> +		(jiffies_to_msecs(timeout) - CMD_EXECUTE_TIMEOUT));
>  
> -	if (i == 0) {
> +	if (uitmp) {
>  		ret = -ETIMEDOUT;
>  		goto error;
>  	}
