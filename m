Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:33336 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966806AbdDSVOl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 17:14:41 -0400
Subject: Re: [PATCH] [media] rainshadow-cec: use strlcat instead of strncat
To: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20170419171543.3274995-1-arnd@arndb.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e0cdbe4a-740d-70b4-6d98-5f72467a937b@xs4all.nl>
Date: Wed, 19 Apr 2017 23:14:38 +0200
MIME-Version: 1.0
In-Reply-To: <20170419171543.3274995-1-arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/04/17 19:15, Arnd Bergmann wrote:
> gcc warns about an obviously incorrect use of strncat():
> 
> drivers/media/usb/rainshadow-cec/rainshadow-cec.c: In function 'rain_cec_adap_transmit':
> drivers/media/usb/rainshadow-cec/rainshadow-cec.c:299:4: error: specified bound 48 equals the size of the destination [-Werror=stringop-overflow=]
> 
> It seems that strlcat was intended here, and using that makes the
> code correct.

Oops! You're right, it should be strlcat.

Which gcc version do you use? Mine (6.3.0) didn't give an error (or warning, for that matter).

Regards,

	Hans

> 
> Fixes: 0f314f6c2e77 ("[media] rainshadow-cec: new RainShadow Tech HDMI CEC driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
> index 541ca543f71f..dc1f64f904cd 100644
> --- a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
> +++ b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
> @@ -296,7 +296,7 @@ static int rain_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
>  			 cec_msg_destination(msg), msg->msg[1]);
>  		for (i = 2; i < msg->len; i++) {
>  			snprintf(hex, sizeof(hex), "%02x", msg->msg[i]);
> -			strncat(cmd, hex, sizeof(cmd));
> +			strlcat(cmd, hex, sizeof(cmd));
>  		}
>  	}
>  	mutex_lock(&rain->write_lock);
> 
