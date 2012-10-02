Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52115 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab2JBTZM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 15:25:12 -0400
Message-ID: <506B3F81.3040404@iki.fi>
Date: Tue, 02 Oct 2012 22:24:49 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: Make all em28xx extensions to be initialized
 asynchronously
References: <1349203178-7782-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1349203178-7782-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/02/2012 09:39 PM, Mauro Carvalho Chehab wrote:
> em28xx-dvb, em28xx-alsa and em28xx-ir are typically initialized
> asyncrhronously. The exception for it is when those modules
> are loaded before em28xx (or before an em28xx card insertion) or
> when they're built in.
>
> Make the extentions to always load asynchronously. That allows
> having all DVB firmwares loaded synchronously with udev-182.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Tested-by: Antti Palosaari <crope@iki.fi>

Hauppauge WinTV HVR 930C
MaxMedia UB425-TC
PCTV QuatroStick nano (520e)


> ---
>   drivers/media/usb/em28xx/em28xx-cards.c | 22 ++++++++++------------
>   1 file changed, 10 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index ca62b99..ab98d08 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -2875,12 +2875,20 @@ static void em28xx_card_setup(struct em28xx *dev)
>   }
>
>
> -#if defined(CONFIG_MODULES) && defined(MODULE)
>   static void request_module_async(struct work_struct *work)
>   {
>   	struct em28xx *dev = container_of(work,
>   			     struct em28xx, request_module_wk);
>
> +	/*
> +	 * The em28xx extensions can be modules or builtin. If the
> +	 * modules are already loaded or are built in, those extensions
> +	 * can be initialised right now. Otherwise, the module init
> +	 * code will do it.
> +	 */
> +	em28xx_init_extension(dev);
> +
> +#if defined(CONFIG_MODULES) && defined(MODULE)
>   	if (dev->has_audio_class)
>   		request_module("snd-usb-audio");
>   	else if (dev->has_alsa_audio)
> @@ -2890,6 +2898,7 @@ static void request_module_async(struct work_struct *work)
>   		request_module("em28xx-dvb");
>   	if (dev->board.ir_codes && !disable_ir)
>   		request_module("em28xx-rc");
> +#endif /* CONFIG_MODULES */
>   }
>
>   static void request_modules(struct em28xx *dev)
> @@ -2902,10 +2911,6 @@ static void flush_request_modules(struct em28xx *dev)
>   {
>   	flush_work_sync(&dev->request_module_wk);
>   }
> -#else
> -#define request_modules(dev)
> -#define flush_request_modules(dev)
> -#endif /* CONFIG_MODULES */
>
>   /*
>    * em28xx_release_resources()
> @@ -3324,13 +3329,6 @@ static int em28xx_usb_probe(struct usb_interface *interface,
>   	 */
>   	mutex_unlock(&dev->lock);
>
> -	/*
> -	 * These extensions can be modules. If the modules are already
> -	 * loaded then we can initialise the device now, otherwise we
> -	 * will initialise it when the modules load instead.
> -	 */
> -	em28xx_init_extension(dev);
> -
>   	return 0;
>
>   unlock_and_free:
>


-- 
http://palosaari.fi/
