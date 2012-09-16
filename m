Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39086 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab2IPBo7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 21:44:59 -0400
Message-ID: <50552F08.1080401@iki.fi>
Date: Sun, 16 Sep 2012 04:44:40 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
CC: linux-media@vger.kernel.org, liplianin@me.by
Subject: Re: [PATCH 5/6] [media] ds3000: properly report firmware probing
 issues
References: <1347614846-19046-1-git-send-email-remi.cardona@smartjog.com> <1347614846-19046-6-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1347614846-19046-6-git-send-email-remi.cardona@smartjog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2012 12:27 PM, Rémi Cardona wrote:
> ds3000_readreg() returns negative values in case of i2c failures. The
> old code would simply return 0 when failing to read the 0xb2 register,
> misleading ds3000_initfe() into believing that the firmware had been
> correctly loaded.
>
> Also print out a message if the chip says a firmware is already loaded.
> This should make it more obvious if the chip is in a weird state.
>
> Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>

Reviewed-by: Antti Palosaari <crope@iki.fi>

I still suggest to use pr_info() / dev_info() instead of 
printk(KERN_INFO...).

Also printing "Firmware already uploaded, skipping" *every time* when 
device is opened is not wise.


> ---
>   drivers/media/dvb/frontends/ds3000.c |    8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
> index 162faaf..970963c 100644
> --- a/drivers/media/dvb/frontends/ds3000.c
> +++ b/drivers/media/dvb/frontends/ds3000.c
> @@ -395,8 +395,14 @@ static int ds3000_firmware_ondemand(struct dvb_frontend *fe)
>
>   	dprintk("%s()\n", __func__);
>
> -	if (ds3000_readreg(state, 0xb2) <= 0)
> +	ret = ds3000_readreg(state, 0xb2);
> +	if (ret == 0) {
> +		printk(KERN_INFO "%s: Firmware already uploaded, skipping\n",
> +			__func__);
>   		return ret;
> +	} else if (ret < 0) {
> +		return ret;
> +	}
>
>   	/* Load firmware */
>   	/* request the firmware, this will block until someone uploads it */
>

regards
Antti

-- 
http://palosaari.fi/
