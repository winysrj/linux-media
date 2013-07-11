Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:36193 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab3GKNKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 09:10:55 -0400
Received: by mail-lb0-f173.google.com with SMTP id v1so6711048lbd.18
        for <linux-media@vger.kernel.org>; Thu, 11 Jul 2013 06:10:53 -0700 (PDT)
Message-ID: <51DEAEDB.2060600@cogentembedded.com>
Date: Thu, 11 Jul 2013 17:10:51 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 46/50] Sound: usb: ua101: spin_lock in complete() cleanup
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com> <1373533573-12272-47-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-47-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11-07-2013 13:06, Ming Lei wrote:

    Here the subject doesn't match the patch.

> Complete() will be run with interrupt enabled, so disable local
> interrupt before holding a global lock which is held without irqsave.

> Cc: Clemens Ladisch <clemens@ladisch.de>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: alsa-devel@alsa-project.org
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>   sound/usb/misc/ua101.c |   14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)

> diff --git a/sound/usb/misc/ua101.c b/sound/usb/misc/ua101.c
> index 8b5d2c5..52a60c6 100644
> --- a/sound/usb/misc/ua101.c
> +++ b/sound/usb/misc/ua101.c
> @@ -613,14 +613,24 @@ static int start_usb_playback(struct ua101 *ua)
>
>   static void abort_alsa_capture(struct ua101 *ua)
>   {
> -	if (test_bit(ALSA_CAPTURE_RUNNING, &ua->states))
> +	if (test_bit(ALSA_CAPTURE_RUNNING, &ua->states)) {
> +		unsigned long flags;
> +
> +		local_irq_save(flags);
>   		snd_pcm_stop(ua->capture.substream, SNDRV_PCM_STATE_XRUN);
> +		local_irq_restore(flags);
> +	}
>   }
>
>   static void abort_alsa_playback(struct ua101 *ua)
>   {
> -	if (test_bit(ALSA_PLAYBACK_RUNNING, &ua->states))
> +	if (test_bit(ALSA_PLAYBACK_RUNNING, &ua->states)) {
> +		unsigned long flags;
> +
> +		local_irq_save(flags);
>   		snd_pcm_stop(ua->playback.substream, SNDRV_PCM_STATE_XRUN);
> +		local_irq_restore(flags);
> +	}
>   }

WBR, Sergei

