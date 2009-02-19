Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:40771 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbZBSQ5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 11:57:05 -0500
Received: by bwz5 with SMTP id 5so1401899bwz.13
        for <linux-media@vger.kernel.org>; Thu, 19 Feb 2009 08:57:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200902191741.57767.nsoranzo@tiscali.it>
References: <200902191741.57767.nsoranzo@tiscali.it>
Date: Thu, 19 Feb 2009 17:57:03 +0100
Message-ID: <d9def9db0902190857p331d7667td0900ec6e8a9c75f@mail.gmail.com>
Subject: Re: [PATCH] em28xx: register device to soundcard for sysfs
From: Markus Rechberger <mrechberger@gmail.com>
To: Nicola Soranzo <nsoranzo@tiscali.it>
Cc: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 19, 2009 at 5:41 PM, Nicola Soranzo <nsoranzo@tiscali.it> wrote:
> As explained in "Writing an ALSA driver" (T. Iwai),

when writing a patch write the truth about where it comes from, eg.
the author of the patch.

thanks,
Markus

> audio drivers should
> set the struct device for the card before registering the card instance.
> This will add the correct /sys/class/sound/cardN/device symlink, so HAL
> can see the device and ConsoleKit sets its ACL permissions for the
> logged-in user.
>
> For em28xx audio capture cards found e.g. in Hauppauge WinTV-HVR-900 (R2),
> this patch fixes errors like:
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
> diff -r 80e785538796 -r ef8cc17cc048 linux/drivers/media/video/em28xx/em28xx-audio.c
> --- a/linux/drivers/media/video/em28xx/em28xx-audio.c   Wed Feb 18 18:27:33 2009 +0100
> +++ b/linux/drivers/media/video/em28xx/em28xx-audio.c   Thu Feb 19 17:36:44 2009 +0100
> @@ -560,6 +560,8 @@
>        pcm->info_flags = 0;
>        pcm->private_data = dev;
>        strcpy(pcm->name, "Empia 28xx Capture");
> +
> +       snd_card_set_dev(card, &dev->udev->dev);
>        strcpy(card->driver, "Empia Em28xx Audio");
>        strcpy(card->shortname, "Em28xx Audio");
>        strcpy(card->longname, "Empia Em28xx Audio");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
