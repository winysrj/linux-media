Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:44429 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbZHJWQz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 18:16:55 -0400
Received: by bwz19 with SMTP id 19so2857600bwz.37
        for <linux-media@vger.kernel.org>; Mon, 10 Aug 2009 15:16:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249753568.15160.249.camel@tux.localhost>
References: <1249753568.15160.249.camel@tux.localhost>
Date: Mon, 10 Aug 2009 18:16:55 -0400
Message-ID: <30353c3d0908101516m773e9b27t97b3710766b1eb89@mail.gmail.com>
Subject: Re: [patch review 4/6] radio-mr800: make radio->status variable
From: David Ellingsworth <david@identd.dyndns.org>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 8, 2009 at 1:46 PM, Alexey Klimov<klimov.linux@gmail.com> wrote:
> Remove radio->muted and radio->removed variables from amradio_device
> structure. Instead patch creates radio->status variable and updates
> code.
>
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
>
> --
> diff -r a1ccdea5a182 linux/drivers/media/radio/radio-mr800.c
> --- a/linux/drivers/media/radio/radio-mr800.c   Wed Jul 29 12:42:06 2009 +0400
> +++ b/linux/drivers/media/radio/radio-mr800.c   Sat Aug 08 17:24:05 2009 +0400
> @@ -108,6 +108,8 @@
>  #define AMRADIO_START          0x00
>  #define AMRADIO_STOP           0x01
>
> +#define DISCONNECTED           -1
> +
>  /* Comfortable defines for amradio_set_stereo */
>  #define WANT_STEREO            0x00
>  #define WANT_MONO              0x01
> @@ -135,11 +137,10 @@
>
>        unsigned char *buffer;
>        struct mutex lock;      /* buffer locking */
> +       int status;
>        int curfreq;
>        int stereo;
>        int users;
> -       int removed;
> -       int muted;
>  };
>
>  /* USB Device ID List */
> @@ -172,7 +173,7 @@
>        int size;
>
>        /* safety check */
> -       if (radio->removed)
> +       if (unlikely(radio->status == DISCONNECTED))
>                return -EIO;
>
>        mutex_lock(&radio->lock);
> @@ -194,7 +195,7 @@
>                return retval;
>        }
>
> -       radio->muted = argument;
> +       radio->status = argument;
>
>        mutex_unlock(&radio->lock);
>
> @@ -209,7 +210,7 @@
>        unsigned short freq_send = 0x10 + (radio->curfreq >> 3) / 25;
>
>        /* safety check */
> -       if (radio->removed)
> +       if (unlikely(radio->status == DISCONNECTED))
>                return -EIO;
>
>        mutex_lock(&radio->lock);
> @@ -259,7 +260,7 @@
>        int size;
>
>        /* safety check */
> -       if (radio->removed)
> +       if (unlikely(radio->status == DISCONNECTED))
>                return -EIO;
>
>        mutex_lock(&radio->lock);
> @@ -299,7 +300,7 @@
>        struct amradio_device *radio = usb_get_intfdata(intf);
>
>        mutex_lock(&radio->lock);
> -       radio->removed = 1;
> +       radio->status = DISCONNECTED;
>        mutex_unlock(&radio->lock);
>
>        usb_set_intfdata(intf, NULL);
> @@ -329,7 +330,7 @@
>        int retval;
>
>        /* safety check */
> -       if (radio->removed)
> +       if (unlikely(radio->status == DISCONNECTED))
>                return -EIO;
>
>        if (v->index > 0)
> @@ -371,7 +372,7 @@
>        int retval;
>
>        /* safety check */
> -       if (radio->removed)
> +       if (unlikely(radio->status == DISCONNECTED))
>                return -EIO;
>
>        if (v->index > 0)
> @@ -406,7 +407,7 @@
>        int retval;
>
>        /* safety check */
> -       if (radio->removed)
> +       if (unlikely(radio->status == DISCONNECTED))
>                return -EIO;
>
>        mutex_lock(&radio->lock);
> @@ -427,7 +428,7 @@
>        struct amradio_device *radio = video_get_drvdata(video_devdata(file));
>
>        /* safety check */
> -       if (radio->removed)
> +       if (unlikely(radio->status == DISCONNECTED))
>                return -EIO;
>
>        f->type = V4L2_TUNER_RADIO;
> @@ -454,12 +455,12 @@
>        struct amradio_device *radio = video_get_drvdata(video_devdata(file));
>
>        /* safety check */
> -       if (radio->removed)
> +       if (unlikely(radio->status == DISCONNECTED))
>                return -EIO;
>
>        switch (ctrl->id) {
>        case V4L2_CID_AUDIO_MUTE:
> -               ctrl->value = radio->muted;
> +               ctrl->value = radio->status;
>                return 0;
>        }
>        return -EINVAL;
> @@ -473,7 +474,7 @@
>        int retval;
>
>        /* safety check */
> -       if (radio->removed)
> +       if (unlikely(radio->status == DISCONNECTED))
>                return -EIO;
>
>        switch (ctrl->id) {
> @@ -540,7 +541,6 @@
>        struct amradio_device *radio = video_get_drvdata(video_devdata(file));
>
>        radio->users = 1;
> -       radio->muted = 1;
>
>        return 0;
>  }
> @@ -674,7 +674,7 @@
>        radio->videodev->ioctl_ops = &usb_amradio_ioctl_ops;
>        radio->videodev->release = usb_amradio_video_device_release;
>
> -       radio->removed = 0;
> +       radio->status = AMRADIO_STOP;
>        radio->users = 0;
>        radio->usbdev = interface_to_usbdev(intf);
>        radio->curfreq = 95.16 * FREQ_MUL;
>
>
> --
> Best regards, Klimov Alexey

I'm not sure all these checks for the device being disconnected are
actually needed. They are all done without taking the lock and won't
necessarily prevent a IO error from occurring after the status has
been checked. IE, the device might be connected at the time the status
is checked, but disconnected immediately after. It would be better for
the driver to just assume the device was there and allow usb functions
it calls to fail appropriately.

Since the usb_disconnect callback most likely modifies the driver's
state, it should probably take the lock along with open, close, and
any other ioctl which uses or modifies the state of the driver to
avoid race conditions between them.

With all of your ioctls competing for the lock, the usb_disconnect
callback wont be able to do anything while others have the lock. So if
the device is disconnected during that time, calls to the usb
subsystem will fail. In these cases you should catch the failure,
unlock the device, and return EIO. Eventually the usb_disconnect
callback will be called, and you'll be able to update the driver's
state to indicate that usb calls are no longer valid. IMHO, you
shouldn't need the DISCONNECTED state, as you already have an
indicator for that (IE the usbdev pointer).

Regards,

David Ellingsworth
