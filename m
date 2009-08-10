Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:64201 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbZHJWYU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 18:24:20 -0400
Received: by fxm28 with SMTP id 28so1203776fxm.17
        for <linux-media@vger.kernel.org>; Mon, 10 Aug 2009 15:24:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249753576.15160.251.camel@tux.localhost>
References: <1249753576.15160.251.camel@tux.localhost>
Date: Mon, 10 Aug 2009 18:24:20 -0400
Message-ID: <30353c3d0908101524y76bd9c3aq8aedf34fe3f3b3a6@mail.gmail.com>
Subject: Re: [patch review 6/6] radio-mr800: redesign radio->users counter
From: David Ellingsworth <david@identd.dyndns.org>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 8, 2009 at 1:46 PM, Alexey Klimov<klimov.linux@gmail.com> wrote:
> Redesign radio->users counter. Don't allow more that 5 users on radio in
> usb_amradio_open() and don't stop radio device if other userspace
> application uses it in usb_amradio_close().
>
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
>
> --
> diff -r c2dd9da28106 linux/drivers/media/radio/radio-mr800.c
> --- a/linux/drivers/media/radio/radio-mr800.c   Sat Aug 08 17:28:18 2009 +0400
> +++ b/linux/drivers/media/radio/radio-mr800.c   Sat Aug 08 18:12:01 2009 +0400
> @@ -540,7 +540,13 @@
>  {
>        struct amradio_device *radio = video_get_drvdata(video_devdata(file));
>
> -       radio->users = 1;
> +       /* don't allow more than 5 users on radio */
> +       if (radio->users > 4)
> +               return -EBUSY;

I agree with what the others have said regarding this.. there should
be no such restriction here. The code is broken anyway as it doesn't
acquire the lock before checking the number of active users. So
technically, while you've tried to limit it to five, six, seven, or
more users could gain access to it under the right conditions.

> +
> +       mutex_lock(&radio->lock);
> +       radio->users++;
> +       mutex_unlock(&radio->lock);
>
>        return 0;
>  }
> @@ -554,9 +560,20 @@
>                return -ENODEV;
>
>        mutex_lock(&radio->lock);
> -       radio->users = 0;
> +       radio->users--;
>        mutex_unlock(&radio->lock);
>
> +       /* In case several userspace applications opened the radio
> +        * and one of them closes and stops it,
> +        * we check if others use it and if they do we start the radio again. */
> +       if (radio->users && radio->status == AMRADIO_STOP) {

More locking issues here as well. Two competing opens might both see
the status as stopped and both try to start the device.

> +               int retval;
> +               retval = amradio_set_mute(radio, AMRADIO_START);
> +               if (retval < 0)
> +                       dev_warn(&radio->videodev->dev,
> +                               "amradio_start failed\n");
> +       }
> +
>        return 0;
>  }
>

Regards,

David Ellingsworth
