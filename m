Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:42686 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbZHJVnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 17:43:51 -0400
Received: by bwz19 with SMTP id 19so2843996bwz.37
        for <linux-media@vger.kernel.org>; Mon, 10 Aug 2009 14:43:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249753533.15160.241.camel@tux.localhost>
References: <1249753533.15160.241.camel@tux.localhost>
Date: Mon, 10 Aug 2009 17:43:51 -0400
Message-ID: <30353c3d0908101443i1f2d82besc931ce5a2707e2d0@mail.gmail.com>
Subject: Re: [patch review 1/6] radio-mr800: remove redundant
	lock/unlock_kernel
From: David Ellingsworth <david@identd.dyndns.org>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 8, 2009 at 1:45 PM, Alexey Klimov<klimov.linux@gmail.com> wrote:
> Remove redundant lock/unlock_kernel() calls from usb_amradio_open/close
> functions.
>
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
>
> --
> diff -r ee6cf88cb5d3 linux/drivers/media/radio/radio-mr800.c
> --- a/linux/drivers/media/radio/radio-mr800.c   Wed Jul 29 01:42:02 2009 -0300
> +++ b/linux/drivers/media/radio/radio-mr800.c   Wed Jul 29 10:44:02 2009 +0400
> @@ -540,8 +540,6 @@
>        struct amradio_device *radio = video_get_drvdata(video_devdata(file));
>        int retval;
>
> -       lock_kernel();
> -

Maybe I'm missing something here, but the lock_kernel() call seems
very necessary here since you're modifying the state of the driver
without taking the driver's lock. Last I checked the v4l2 subsystem
doesn't call open with it's lock held. So by removing these locks
you've introduced a race condition between open and close.

>        radio->users = 1;
>        radio->muted = 1;
>
> @@ -550,7 +548,6 @@
>                amradio_dev_warn(&radio->videodev->dev,
>                        "radio did not start up properly\n");
>                radio->users = 0;
> -               unlock_kernel();
>                return -EIO;
>        }
>
> @@ -564,7 +561,6 @@
>                amradio_dev_warn(&radio->videodev->dev,
>                        "set frequency failed\n");
>
> -       unlock_kernel();
>        return 0;
>  }
>
>
>
> --
> Best regards, Klimov Alexey
>

Regards,

David Ellingsworth
