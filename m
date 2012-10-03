Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57062 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab2JCAiA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 20:38:00 -0400
Message-ID: <506B88D2.2060202@iki.fi>
Date: Wed, 03 Oct 2012 03:37:38 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
CC: linux-media@vger.kernel.org, liplianin@me.by
Subject: Re: [PATCH 5/7] [media] ds3000: properly report firmware probing
 issues
References: <1348837172-11784-1-git-send-email-remi.cardona@smartjog.com> <1348837172-11784-6-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1348837172-11784-6-git-send-email-remi.cardona@smartjog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2012 03:59 PM, Rémi Cardona wrote:
> ds3000_readreg() returns negative values in case of i2c failures. The
> old code would simply return 0 when failing to read the 0xb2 register,
> misleading ds3000_initfe() into believing that the firmware had been
> correctly loaded.
>
> Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>

Reviewed-by: Antti Palosaari <crope@iki.fi>

> ---
>   drivers/media/dvb-frontends/ds3000.c |    7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
> index 162faaf..59184a8 100644
> --- a/drivers/media/dvb-frontends/ds3000.c
> +++ b/drivers/media/dvb-frontends/ds3000.c
> @@ -395,8 +395,13 @@ static int ds3000_firmware_ondemand(struct dvb_frontend *fe)
>
>   	dprintk("%s()\n", __func__);
>
> -	if (ds3000_readreg(state, 0xb2) <= 0)
> +	ret = ds3000_readreg(state, 0xb2);
> +	if (ret == 0) {
> +		/* Firmware already uploaded, skipping */
>   		return ret;
> +	} else if (ret < 0) {
> +		return ret;
> +	}
>
>   	/* Load firmware */
>   	/* request the firmware, this will block until someone uploads it */
>


-- 
http://palosaari.fi/
