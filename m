Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:34546 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbZHJVxQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 17:53:16 -0400
Received: by fxm28 with SMTP id 28so1191693fxm.17
        for <linux-media@vger.kernel.org>; Mon, 10 Aug 2009 14:53:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249753564.15160.248.camel@tux.localhost>
References: <1249753564.15160.248.camel@tux.localhost>
Date: Mon, 10 Aug 2009 17:53:16 -0400
Message-ID: <30353c3d0908101453w797f2a14ve54f434cfdb12849@mail.gmail.com>
Subject: Re: [patch review 3/6] radio-mr800: no need to pass curfreq value to
	amradio_setfreq()
From: David Ellingsworth <david@identd.dyndns.org>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 8, 2009 at 1:46 PM, Alexey Klimov<klimov.linux@gmail.com> wrote:
> Small cleanup of amradio_setfreq(). No need to pass radio->curfreq value
> to this function.
>
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
>
> --
> diff -r 5f3329bebfe4 linux/drivers/media/radio/radio-mr800.c
> --- a/linux/drivers/media/radio/radio-mr800.c   Wed Jul 29 12:36:46 2009 +0400
> +++ b/linux/drivers/media/radio/radio-mr800.c   Wed Jul 29 12:41:51 2009 +0400
> @@ -202,11 +202,11 @@
>  }
>
>  /* set a frequency, freq is defined by v4l's TUNER_LOW, i.e. 1/16th kHz */
> -static int amradio_setfreq(struct amradio_device *radio, int freq)
> +static int amradio_setfreq(struct amradio_device *radio)
>  {
>        int retval;
>        int size;
> -       unsigned short freq_send = 0x10 + (freq >> 3) / 25;
> +       unsigned short freq_send = 0x10 + (radio->curfreq >> 3) / 25;

I suspect there may be race conditions here. Once again you're reading
a value without first acquiring the lock. Since this is another
utility function, the lock should probably be held _before_ calling
this function and any locking in this function should be removed.
Adding a BUG_ON(!is_mutex_locked(&radio->lock)) should probably be
added as well.

>
>        /* safety check */
>        if (radio->removed)
> @@ -413,7 +413,7 @@
>        radio->curfreq = f->frequency;
>        mutex_unlock(&radio->lock);
>
> -       retval = amradio_setfreq(radio, radio->curfreq);
> +       retval = amradio_setfreq(radio);
>        if (retval < 0)
>                amradio_dev_warn(&radio->videodev->dev,
>                        "set frequency failed\n");
>
>
>
> --
> Best regards, Klimov Alexey
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Regards,

David Ellingsworth
