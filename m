Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44992 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964951AbaLMEF1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 23:05:27 -0500
Message-ID: <548BBB05.10108@iki.fi>
Date: Sat, 13 Dec 2014 06:05:25 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/4] mn88472: elaborate debug printout
References: <1418429925-16342-1-git-send-email-benjamin@southpole.se> <1418429925-16342-3-git-send-email-benjamin@southpole.se>
In-Reply-To: <1418429925-16342-3-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That patch is simply wrong. Kernel logging system is able to add 
function name automatically - it should not be defined manually for 
debug logging.

See kernel documentation:
Documentation/dynamic-debug-howto.txt

around the line 213.

----------------------------------
The flags are:

   p    enables the pr_debug() callsite.
   f    Include the function name in the printed message
   l    Include line number in the printed message
   m    Include module name in the printed message
   t    Include thread ID in messages not generated from interrupt context
   _    No flags are set. (Or'd with others on input)
----------------------------------

Antti




On 12/13/2014 02:18 AM, Benjamin Larsson wrote:
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
> ---
>   drivers/staging/media/mn88472/mn88472.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
> index 4d80046..746cc94 100644
> --- a/drivers/staging/media/mn88472/mn88472.c
> +++ b/drivers/staging/media/mn88472/mn88472.c
> @@ -33,6 +33,7 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
>   	u64 tmp;
>   	u8 delivery_system_val, if_val[3], bw_val[7], bw_val2;
>
> +	dev_dbg(&client->dev, "%s:\n", __func__);
>   	dev_dbg(&client->dev,
>   			"delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d\n",
>   			c->delivery_system, c->modulation,
> @@ -288,7 +289,7 @@ static int mn88472_init(struct dvb_frontend *fe)
>   	u8 *fw_file = MN88472_FIRMWARE;
>   	unsigned int csum;
>
> -	dev_dbg(&client->dev, "\n");
> +	dev_dbg(&client->dev, "%s:\n", __func__);
>
>   	/* set cold state by default */
>   	dev->warm = false;
> @@ -371,7 +372,7 @@ static int mn88472_sleep(struct dvb_frontend *fe)
>   	struct mn88472_dev *dev = i2c_get_clientdata(client);
>   	int ret;
>
> -	dev_dbg(&client->dev, "\n");
> +	dev_dbg(&client->dev, "%s:\n", __func__);
>
>   	/* power off */
>   	ret = regmap_write(dev->regmap[2], 0x0b, 0x30);
>

-- 
http://palosaari.fi/
