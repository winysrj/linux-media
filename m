Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.southpole.se ([37.247.8.11]:60805 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbbBSJoU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 04:44:20 -0500
Received: from [10.10.1.135] (assp.southpole.se [37.247.8.10])
	by mail.southpole.se (Postfix) with ESMTPSA id E1AC0440648
	for <linux-media@vger.kernel.org>; Thu, 19 Feb 2015 10:44:18 +0100 (CET)
Message-ID: <54E5B071.2050608@southpole.se>
Date: Thu, 19 Feb 2015 10:44:17 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] rtl28xxu: lower the rc poll time to mitigate i2c
 transfer errors
References: <1417825533-13081-1-git-send-email-benjamin@southpole.se>
In-Reply-To: <1417825533-13081-1-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-12-06 01:25, Benjamin Larsson wrote:
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

Ping, can I get an ack or nack on this ?

MvH
Benjamin Larsson
