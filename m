Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59789 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030678Ab2HGXFC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 19:05:02 -0400
Received: by lagy9 with SMTP id y9so83958lag.19
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2012 16:05:00 -0700 (PDT)
Message-ID: <50219F10.5020004@iki.fi>
Date: Wed, 08 Aug 2012 02:04:48 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 04/11] dvb-usb: use %*ph to dump small buffers
References: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com> <1344357792-18202-4-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1344357792-18202-4-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/07/2012 07:43 PM, Andy Shevchenko wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Antti Palosaari <crope@iki.fi>

Drop that patch.

af9015 and af9035 were moved to dvb-usb-v2 and due to that it conflicts. 
I fixed merge conflict, reviewed and tested patch. New version (13678) 
is here: http://patchwork.linuxtv.org/patch/13678/


And very big thanks Andy, I have been looking that for a while!

https://lkml.org/lkml/2012/7/5/85

regards
Antti


> ---
>   drivers/media/dvb/dvb-usb/af9015.c   |    3 +--
>   drivers/media/dvb/dvb-usb/af9035.c   |    3 +--
>   drivers/media/dvb/dvb-usb/pctv452e.c |    7 +++----
>   3 files changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
> index 677fed7..ae1a01b 100644
> --- a/drivers/media/dvb/dvb-usb/af9015.c
> +++ b/drivers/media/dvb/dvb-usb/af9015.c
> @@ -1053,8 +1053,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
>
>   	/* Only process key if canary killed */
>   	if (buf[16] != 0xff && buf[0] != 0x01) {
> -		deb_rc("%s: key pressed %02x %02x %02x %02x\n", __func__,
> -			buf[12], buf[13], buf[14], buf[15]);
> +		deb_rc("%s: key pressed %*ph\n", __func__, 4, buf + 12);
>
>   		/* Reset the canary */
>   		ret = af9015_write_reg(d, 0x98e9, 0xff);
> diff --git a/drivers/media/dvb/dvb-usb/af9035.c b/drivers/media/dvb/dvb-usb/af9035.c
> index e83b39d..01e3321 100644
> --- a/drivers/media/dvb/dvb-usb/af9035.c
> +++ b/drivers/media/dvb/dvb-usb/af9035.c
> @@ -393,8 +393,7 @@ static int af9035_identify_state(struct usb_device *udev,
>   	if (ret < 0)
>   		goto err;
>
> -	pr_debug("%s: reply=%02x %02x %02x %02x\n", __func__,
> -		rbuf[0], rbuf[1], rbuf[2], rbuf[3]);
> +	pr_debug("%s: reply=%*ph\n", __func__, 4, rbuf);
>   	if (rbuf[0] || rbuf[1] || rbuf[2] || rbuf[3])
>   		*cold = 0;
>   	else
> diff --git a/drivers/media/dvb/dvb-usb/pctv452e.c b/drivers/media/dvb/dvb-usb/pctv452e.c
> index f526eb0..02e8785 100644
> --- a/drivers/media/dvb/dvb-usb/pctv452e.c
> +++ b/drivers/media/dvb/dvb-usb/pctv452e.c
> @@ -136,8 +136,8 @@ static int tt3650_ci_msg(struct dvb_usb_device *d, u8 cmd, u8 *data,
>   	return 0;
>
>   failed:
> -	err("CI error %d; %02X %02X %02X -> %02X %02X %02X.",
> -	     ret, SYNC_BYTE_OUT, id, cmd, buf[0], buf[1], buf[2]);
> +	err("CI error %d; %02X %02X %02X -> %*ph.",
> +	     ret, SYNC_BYTE_OUT, id, cmd, 3, buf);
>
>   	return ret;
>   }
> @@ -556,8 +556,7 @@ static int pctv452e_rc_query(struct dvb_usb_device *d)
>   		return ret;
>
>   	if (debug > 3) {
> -		info("%s: read: %2d: %02x %02x %02x: ", __func__,
> -				ret, rx[0], rx[1], rx[2]);
> +		info("%s: read: %2d: %*ph: ", __func__, ret, 3, rx);
>   		for (i = 0; (i < rx[3]) && ((i+3) < PCTV_ANSWER_LEN); i++)
>   			info(" %02x", rx[i+3]);
>
>


-- 
http://palosaari.fi/
