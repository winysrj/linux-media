Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32921 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbaHIWru (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 18:47:50 -0400
Message-ID: <53E6A514.4070605@iki.fi>
Date: Sun, 10 Aug 2014 01:47:48 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCHv2 2/4] Add USB ID for TechnoTrend TT-connect CT2-4650
 CI
References: <1407481598-24598-1-git-send-email-olli.salonen@iki.fi> <1407481598-24598-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1407481598-24598-2-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

On 08/08/2014 10:06 AM, Olli Salonen wrote:
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/dvb-core/dvb-usb-ids.h | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
> index 5135a09..b7a9b98 100644
> --- a/drivers/media/dvb-core/dvb-usb-ids.h
> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
> @@ -244,6 +244,7 @@
>   #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
>   #define USB_PID_TECHNOTREND_CONNECT_S2400_8KEEPROM	0x3009
>   #define USB_PID_TECHNOTREND_CONNECT_CT3650		0x300d
> +#define USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI		0x3012
>   #define USB_PID_TECHNOTREND_TVSTICK_CT2_4400		0x3014
>   #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
>   #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2	0x0081
>

-- 
http://palosaari.fi/
