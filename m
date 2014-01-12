Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:49654 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaALRhd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 12:37:33 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZA00DWIUAL4W40@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 12 Jan 2014 12:37:33 -0500 (EST)
Date: Sun, 12 Jan 2014 15:37:29 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] em28xx: fix check for audio only usb interfaces when
 changing the usb alternate setting
Message-id: <20140112153729.6f87cd2e@samsung.com>
In-reply-to: <1389447750-2642-2-git-send-email-fschaefer.oss@googlemail.com>
References: <1389447750-2642-1-git-send-email-fschaefer.oss@googlemail.com>
 <1389447750-2642-2-git-send-email-fschaefer.oss@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 11 Jan 2014 14:42:30 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Previously, we've been assuming that the video endpoints are always at usb
> interface 0. Hence, if vendor audio endpoints are provided at a separate
> interface, they were supposed to be at interface number > 0.
> Instead of checking for (interface number > 0) to determine if an interface is a
> pure audio interface, dev->is_audio_only should be checked.
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-audio.c |   15 +++++++++++++--
>  1 Datei geändert, 13 Zeilen hinzugefügt(+), 2 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> index b2ae954..18b745f 100644
> --- a/drivers/media/usb/em28xx/em28xx-audio.c
> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> @@ -243,11 +243,22 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
>  	}
>  
>  	runtime->hw = snd_em28xx_hw_capture;
> -	if ((dev->alt == 0 || dev->ifnum) && dev->adev.users == 0) {
> -		if (dev->ifnum)
> +	if (dev->adev.users == 0 && (dev->alt == 0 || dev->is_audio_only)) {
> +		if (dev->is_audio_only)
> +			/* vendor audio is on a separate interface */
>  			dev->alt = 1;
>  		else
> +			/* vendor audio is on the same interface as video */
>  			dev->alt = 7;
> +			/*
> +			 * FIXME: The intention seems to be to select the alt
> +			 * setting with the largest wMaxPacketSize for the video
> +			 * endpoint.
> +			 * At least dev->alt and dev->dvb_alt_isoc should be
> +			 * used instead, but we should probably not touch it at
> +			 * all if it is already >0, because wMaxPacketSize of
> +			 * the audio endpoints seems to be the same for all.
> +			 */

Actually, it should take into account only the analog case, since, in
digital mode, the audio comes via the MPEG stream instead.

Ok, it makes sense to return -EBUSY if one tries to use it while using
DVB.

>  
>  		dprintk("changing alternate number on interface %d to %d\n",
>  			dev->ifnum, dev->alt);


-- 

Cheers,
Mauro
