Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53950 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbbCPV07 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 17:26:59 -0400
Message-ID: <55074AA0.7060107@iki.fi>
Date: Mon, 16 Mar 2015 23:26:56 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>, mchehab@osg.samsung.com
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 03/10] rtl28xxu: lower the rc poll time to mitigate i2c
 transfer errors
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se> <1426460275-3766-3-git-send-email-benjamin@southpole.se>
In-Reply-To: <1426460275-3766-3-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2015 12:57 AM, Benjamin Larsson wrote:
> The Astrometa device has issues with i2c transfers. Lowering the
> poll time somehow makes these errors disappear.
>
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>

Applied!

Antti


> ---
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 77dcfdf..ea75b3a 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1611,7 +1611,7 @@ static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
>   	rc->allowed_protos = RC_BIT_ALL;
>   	rc->driver_type = RC_DRIVER_IR_RAW;
>   	rc->query = rtl2832u_rc_query;
> -	rc->interval = 400;
> +	rc->interval = 200;
>
>   	return 0;
>   }
>

-- 
http://palosaari.fi/
