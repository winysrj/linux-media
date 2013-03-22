Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33765 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab3CVKkO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 06:40:14 -0400
Message-ID: <514C34E0.6030206@iki.fi>
Date: Fri, 22 Mar 2013 12:39:28 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: mchehab@redhat.com, yongjun_wei@trendmicro.com.cn,
	linux-media@vger.kernel.org
Subject: Re: [PATCH -next] [media] dvb_usb_v2: make local function dvb_usb_v2_generic_io()
 static
References: <CAPgLHd_EgofJ+x4EdB-E4Fx8wm9Z5e7cyvde044SiXS0X-OBzg@mail.gmail.com>
In-Reply-To: <CAPgLHd_EgofJ+x4EdB-E4Fx8wm9Z5e7cyvde044SiXS0X-OBzg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/22/2013 05:17 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> dvb_usb_v2_generic_io() was not declared. It should be static.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Antti Palosaari <crope@iki.fi>


> ---
>   drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
> index 74c911f..aa0c35e 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
> +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
> @@ -21,7 +21,7 @@
>
>   #include "dvb_usb_common.h"
>
> -int dvb_usb_v2_generic_io(struct dvb_usb_device *d,
> +static int dvb_usb_v2_generic_io(struct dvb_usb_device *d,
>   		u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
>   {
>   	int ret, actual_length;
>


-- 
http://palosaari.fi/
