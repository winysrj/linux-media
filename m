Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:43395 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbeAYGuQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 01:50:16 -0500
Date: Thu, 25 Jan 2018 07:50:13 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Piotr Oleszczyk <piotr.oleszczyk@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] media: cxusb, dib0700: ignore XC2028_I2C_FLUSH
In-Reply-To: <d59f93e1aa90d5c9a9172f731b3c66093d7a031d.1516791902.git.mchehab@osg.samsung.com>
Message-ID: <alpine.LNX.2.21.99.1801250749290.3761@mStation.localdomain>
References: <d59f93e1aa90d5c9a9172f731b3c66093d7a031d.1516791902.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you very very much for the fix.
You did really make my everyday experience better.....



On Wed, 24 Jan 2018, Mauro Carvalho Chehab wrote:

> Date: Wed, 24 Jan 2018 12:05:24
> From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> To: Enrico Mioso <mrkiko.rs@gmail.com>,
>     Linux Media Mailing List <linux-media@vger.kernel.org>,
>     Jonathan Corbet <corbet@lwn.net>
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
>     Mauro Carvalho Chehab <mchehab@infradead.org>,
>     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
>     Michael Krufky <mkrufky@linuxtv.org>, Sean Young <sean@mess.org>,
>     Hans Verkuil <hans.verkuil@cisco.com>,
>     Andrey Konovalov <andreyknvl@google.com>,
>     Piotr Oleszczyk <piotr.oleszczyk@gmail.com>,
>     Alexey Dobriyan <adobriyan@gmail.com>
> Subject: [PATCH] media: cxusb, dib0700: ignore XC2028_I2C_FLUSH
> 
> The XC2028_I2C_FLUSH only needs to be implemented on a few
> devices. Others can safely ignore it.
>
> That prevents filling the dmesg with lots of messages like:
>
> 	dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
>
> Reported-by: Enrico Mioso <mrkiko.rs@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
> drivers/media/usb/dvb-usb/cxusb.c           | 2 ++
> drivers/media/usb/dvb-usb/dib0700_devices.c | 1 +
> 2 files changed, 3 insertions(+)
>
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
> index 37dea0adc695..cfe86b4864b3 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -677,6 +677,8 @@ static int dvico_bluebird_xc2028_callback(void *ptr, int component,
> 	case XC2028_RESET_CLK:
> 		deb_info("%s: XC2028_RESET_CLK %d\n", __func__, arg);
> 		break;
> +	case XC2028_I2C_FLUSH:
> +		break;
> 	default:
> 		deb_info("%s: unknown command %d, arg %d\n", __func__,
> 			 command, arg);
> diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
> index 366b05529915..a9968fb1e8e4 100644
> --- a/drivers/media/usb/dvb-usb/dib0700_devices.c
> +++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
> @@ -430,6 +430,7 @@ static int stk7700ph_xc3028_callback(void *ptr, int component,
> 		state->dib7000p_ops.set_gpio(adap->fe_adap[0].fe, 8, 0, 1);
> 		break;
> 	case XC2028_RESET_CLK:
> +	case XC2028_I2C_FLUSH:
> 		break;
> 	default:
> 		err("%s: unknown command %d, arg %d\n", __func__,
> -- 
> 2.14.3
>
>
