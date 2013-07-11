Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:45276 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3GKNIe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 09:08:34 -0400
Received: by mail-la0-f42.google.com with SMTP id eb20so6855092lab.15
        for <linux-media@vger.kernel.org>; Thu, 11 Jul 2013 06:08:32 -0700 (PDT)
Message-ID: <51DEAE4E.90204@cogentembedded.com>
Date: Thu, 11 Jul 2013 17:08:30 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 45/50] sound: usb: usx2y: spin_lock in complete() cleanup
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com> <1373533573-12272-46-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-46-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11-07-2013 13:06, Ming Lei wrote:

> Complete() will be run with interrupt enabled, so change to
> spin_lock_irqsave().

    Changelog doesn't match the patch.

> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: alsa-devel@alsa-project.org
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>   sound/usb/usx2y/usbusx2yaudio.c |    4 ++++
>   1 file changed, 4 insertions(+)

> diff --git a/sound/usb/usx2y/usbusx2yaudio.c b/sound/usb/usx2y/usbusx2yaudio.c
> index 4967fe9..e2ee893 100644
> --- a/sound/usb/usx2y/usbusx2yaudio.c
> +++ b/sound/usb/usx2y/usbusx2yaudio.c
> @@ -273,7 +273,11 @@ static void usX2Y_clients_stop(struct usX2Ydev *usX2Y)
>   		struct snd_usX2Y_substream *subs = usX2Y->subs[s];
>   		if (subs) {
>   			if (atomic_read(&subs->state) >= state_PRERUNNING) {
> +				unsigned long flags;
> +
> +				local_irq_save(flags);
>   				snd_pcm_stop(subs->pcm_substream, SNDRV_PCM_STATE_XRUN);
> +				local_irq_restore(flags);
>   			}

WBR, Sergei


