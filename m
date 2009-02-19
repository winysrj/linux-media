Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f163.google.com ([209.85.217.163]:50400 "EHLO
	mail-gx0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbZBSRNI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 12:13:08 -0500
Received: by gxk7 with SMTP id 7so439872gxk.13
        for <linux-media@vger.kernel.org>; Thu, 19 Feb 2009 09:13:06 -0800 (PST)
Date: Thu, 19 Feb 2009 14:12:52 -0300
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Nicola Soranzo <nsoranzo@tiscali.it>
Cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: register device to soundcard for sysfs
Message-ID: <20090219141252.3820c42b@gmail.com>
In-Reply-To: <200902191741.57767.nsoranzo@tiscali.it>
References: <200902191741.57767.nsoranzo@tiscali.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Feb 2009 17:41:56 +0100
Nicola Soranzo <nsoranzo@tiscali.it> wrote:

> As explained in "Writing an ALSA driver" (T. Iwai), audio drivers
> should set the struct device for the card before registering the card
> instance. This will add the correct /sys/class/sound/cardN/device
> symlink, so HAL can see the device and ConsoleKit sets its ACL
> permissions for the logged-in user.
> 
> For em28xx audio capture cards found e.g. in Hauppauge WinTV-HVR-900
> (R2), this patch fixes errors like:
> 
> ALSA lib pcm_hw.c:1429:(_snd_pcm_hw_open) Invalid value for card
> Error opening audio: Permission denied
> 
> when running mplayer as a normal user.
> 
> Priority: normal
> 
> Signed-off-by: Nicola Soranzo <nsoranzo@tiscali.it>
> ---
> diff -r 80e785538796 -r ef8cc17cc048
> linux/drivers/media/video/em28xx/em28xx-audio.c ---
> a/linux/drivers/media/video/em28xx/em28xx-audio.c	Wed Feb 18
> 18:27:33 2009 +0100 +++
> b/linux/drivers/media/video/em28xx/em28xx-audio.c	Thu Feb 19
> 17:36:44 2009 +0100 @@ -560,6 +560,8 @@ pcm->info_flags = 0;
> pcm->private_data = dev; strcpy(pcm->name, "Empia 28xx Capture");
> +
> +	snd_card_set_dev(card, &dev->udev->dev);
>  	strcpy(card->driver, "Empia Em28xx Audio");
>  	strcpy(card->shortname, "Em28xx Audio");
>  	strcpy(card->longname, "Empia Em28xx Audio");
> --

Applied, thanks!

Cheers,
Douglas,
