Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39328 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab1KLQON (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 11:14:13 -0500
Message-ID: <4EBE9B54.9050202@iki.fi>
Date: Sat, 12 Nov 2011 18:14:12 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/7] af9015 Slow down download firmware
References: <4ebe96cb.85c7e30a.27d9.ffff9098@mx.google.com>
In-Reply-To: <4ebe96cb.85c7e30a.27d9.ffff9098@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2011 05:54 PM, Malcolm Priestley wrote:
> It is noticed that sometimes the device fails to download parts of the firmware.
>
> Since there is no ack from firmware write a 250u second delay has been added.
>
> Signed-off-by: Malcolm Priestley<tvboxspy@gmail.com>
> ---
>   drivers/media/dvb/dvb-usb/af9015.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
> index c6c275b..dc6e4ec 100644
> --- a/drivers/media/dvb/dvb-usb/af9015.c
> +++ b/drivers/media/dvb/dvb-usb/af9015.c
> @@ -698,6 +698,7 @@ static int af9015_download_firmware(struct usb_device *udev,
>   			err("firmware download failed:%d", ret);
>   			goto error;
>   		}
> +		udelay(250);
>   	}
>
>   	/* firmware loaded, request boot */

That sleep is not critical as all, so defining it as udelay() is wrong 
in my understanding. Refer Kernel documentation about delays.

regards
Antti

-- 
http://palosaari.fi/
