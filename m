Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57569 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbaLFMq4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 07:46:56 -0500
Message-ID: <5482FABE.3050004@iki.fi>
Date: Sat, 06 Dec 2014 14:46:54 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] rtl28xxu: lower the rc poll time to mitigate i2c
 transfer errors
References: <1417825533-13081-1-git-send-email-benjamin@southpole.se>
In-Reply-To: <1417825533-13081-1-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!
I am very surprised about that patch, especially because it *increases* 
polling interval from 400ms to 200ms. For me it has been always worked 
rather well, but now I suspect it could be due to I disable always 
remote controller... I have to test that.

regards
Antti

On 12/06/2014 02:25 AM, Benjamin Larsson wrote:
> The Astrometa device has issues with i2c transfers. Lowering the
> poll time somehow makes these errors disappear.
>
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
> ---
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 705c6c3..9ec4223 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1567,7 +1567,7 @@ static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
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
