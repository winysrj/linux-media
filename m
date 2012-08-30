Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60171 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab2H3Njy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Aug 2012 09:39:54 -0400
Message-ID: <503F6D18.2060804@iki.fi>
Date: Thu, 30 Aug 2012 16:39:36 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] ds3000: properly report firmware loading
 issues
References: <1346319391-19015-1-git-send-email-remi.cardona@smartjog.com> <1346319391-19015-3-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1346319391-19015-3-git-send-email-remi.cardona@smartjog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2012 12:36 PM, Rémi Cardona wrote:
> ds3000_readreg() returns negative values in case of i2c failures. The
> old code would simply return 0 when failing to read the 0xb2 register,
> misleading ds3000_initfe() into believing that the firmware had been
> correctly loaded.
>
> Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>
> ---
>   drivers/media/dvb/frontends/ds3000.c |    8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
> index 066870a..4c774c4 100644
> --- a/drivers/media/dvb/frontends/ds3000.c
> +++ b/drivers/media/dvb/frontends/ds3000.c
> @@ -391,8 +391,14 @@ static int ds3000_firmware_ondemand(struct dvb_frontend *fe)
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

As I understand firmware downloading failure is coming from the fact 
that register read fails => fails to detect if firmware is already 
running or not.

Original behavior to expect firmware is loaded and running when register 
read fails is very stupid and your fix seems much better.

So first priority should be try fix that issue with register read. Is it 
coming from the USB stack (eg. error 110 timeout) or some other error 
coming from the fact chip answers wrong?

Do you see other register I/O failing too?

Does adding few usec sleep help?


regards
Antti


-- 
http://palosaari.fi/
