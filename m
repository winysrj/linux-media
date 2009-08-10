Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:33564 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbZHJVcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 17:32:01 -0400
Received: by fxm28 with SMTP id 28so1182930fxm.17
        for <linux-media@vger.kernel.org>; Mon, 10 Aug 2009 14:32:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249753572.15160.250.camel@tux.localhost>
References: <1249753572.15160.250.camel@tux.localhost>
Date: Mon, 10 Aug 2009 17:32:01 -0400
Message-ID: <30353c3d0908101432v34ef1a09l93fafe436fc4d587@mail.gmail.com>
Subject: Re: [patch review 5/6] radio-mr800: update suspend/resume procedure
From: David Ellingsworth <david@identd.dyndns.org>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 8, 2009 at 1:46 PM, Alexey Klimov<klimov.linux@gmail.com> wrote:
> Patch fixes suspend/resume procedure.
>
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
>
> --
> diff -r 05754a500f80 linux/drivers/media/radio/radio-mr800.c
> --- a/linux/drivers/media/radio/radio-mr800.c   Sat Aug 08 20:06:36 2009 +0400
> +++ b/linux/drivers/media/radio/radio-mr800.c   Sat Aug 08 20:22:05 2009 +0400
> @@ -564,11 +564,23 @@
>  static int usb_amradio_suspend(struct usb_interface *intf, pm_message_t message)
>  {
>        struct amradio_device *radio = usb_get_intfdata(intf);
> -       int retval;
>
> -       retval = amradio_set_mute(radio, AMRADIO_STOP);
> -       if (retval < 0)
> -               dev_warn(&intf->dev, "amradio_stop failed\n");
> +       if (radio->status == AMRADIO_START) {

I think you need to take a good look at the locking in this driver.
The above condition should technically be checked with the lock held
to ensure that it doesn't change while it's being read.

> +               int retval;
> +               retval = amradio_set_mute(radio, AMRADIO_STOP);

A good place to start would be with amradio_set_mute. In my opinion,
you should remove the locks from this function, add a BUG_ON for
!mutex_is_locked to the start of the function, and ensure all
functions calling it currently hold the lock.

> +               if (retval < 0)
> +                       dev_warn(&intf->dev, "amradio_stop failed\n");
> +
> +               /* After stopping radio status set to AMRADIO_STOP.
> +                * If we want driver to start radio on resume
> +                * we set status equal to AMRADIO_START.
> +                * On resume we will check status and run radio if needed.
> +                */
> +
> +               mutex_lock(&radio->lock);
> +               radio->status = AMRADIO_START;
> +               mutex_unlock(&radio->lock);
> +       }
>
>        dev_info(&intf->dev, "going into suspend..\n");
>
> @@ -579,11 +591,24 @@
>  static int usb_amradio_resume(struct usb_interface *intf)
>  {
>        struct amradio_device *radio = usb_get_intfdata(intf);
> -       int retval;
>
> -       retval = amradio_set_mute(radio, AMRADIO_START);
> -       if (retval < 0)
> -               dev_warn(&intf->dev, "amradio_start failed\n");
> +       if (radio->status == AMRADIO_START) {

Same as above.

> +               int retval;
> +               retval = amradio_set_mute(radio, AMRADIO_START);
> +               if (retval < 0)
> +                       dev_warn(&intf->dev, "amradio_start failed\n");
> +               retval = amradio_setfreq(radio);
> +               if (retval < 0)
> +                       dev_warn(&intf->dev,
> +                               "set frequency failed\n");
> +
> +               if (radio->stereo) {

Same as above.
> +                       retval = amradio_set_stereo(radio, WANT_STEREO);

amradio_set_stereo should be refactored here as well.

> +                       if (retval < 0)
> +                       dev_warn(&intf->dev, "set stereo failed\n");
> +               }
> +
> +       }
>
>        dev_info(&intf->dev, "coming out of suspend..\n");
>
>
>
> --
> Best regards, Klimov Alexey
>

If you properly address the locking in this driver, you should be able
to remove the dependency of this driver on the lock_kernel() and
unlock_kernel() constructs.

Regards,

David Ellingsworth
