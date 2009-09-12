Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38455 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbZILTzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 15:55:17 -0400
Received: by bwz19 with SMTP id 19so1392271bwz.37
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 12:55:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AABB520.9030805@gmail.com>
References: <4AABB520.9030805@gmail.com>
Date: Sat, 12 Sep 2009 15:55:19 -0400
Message-ID: <30353c3d0909121255w1449c059n27f356b030df1b6a@mail.gmail.com>
Subject: Re: [RFC/RFT 09/10] radio-mr800: preserve radio state during
	suspend/resume
From: David Ellingsworth <david@identd.dyndns.org>
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 12, 2009 at 10:50 AM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> From 31243088bd32d5568f06f2044f8ff782641e16b5 Mon Sep 17 00:00:00 2001
> From: David Ellingsworth <david@identd.dyndns.org>
> Date: Sat, 12 Sep 2009 02:05:57 -0400
> Subject: [PATCH 09/10] mr800: preserve radio state during suspend/resume
>
> Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
> ---
> drivers/media/radio/radio-mr800.c |   17 +++++++++++------
> 1 files changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/radio/radio-mr800.c
> b/drivers/media/radio/radio-mr800.c
> index 11db6ea..10bed62 100644
> --- a/drivers/media/radio/radio-mr800.c
> +++ b/drivers/media/radio/radio-mr800.c
> @@ -574,9 +574,12 @@ static int usb_amradio_suspend(struct usb_interface
> *intf, pm_message_t message)
>
>    mutex_lock(&radio->lock);
>
> -    retval = amradio_set_mute(radio, AMRADIO_STOP);
> -    if (retval < 0)
> -        dev_warn(&intf->dev, "amradio_stop failed\n");
> +    if (!radio->muted) {
> +        retval = amradio_set_mute(radio, AMRADIO_STOP);
> +        if (retval < 0)
> +            dev_warn(&intf->dev, "amradio_stop failed\n");
> +        radio->muted = 0;
> +    }
>
>    dev_info(&intf->dev, "going into suspend..\n");
>
> @@ -592,9 +595,11 @@ static int usb_amradio_resume(struct usb_interface
> *intf)
>
>    mutex_lock(&radio->lock);
>
> -    retval = amradio_set_mute(radio, AMRADIO_START);
> -    if (retval < 0)
> -        dev_warn(&intf->dev, "amradio_start failed\n");
> +    if (!radio->muted) {
> +        retval = amradio_set_mute(radio, AMRADIO_START);
> +        if (retval < 0)
> +            dev_warn(&intf->dev, "amradio_start failed\n");
> +    }
>
>    dev_info(&intf->dev, "coming out of suspend..\n");
>
> --
> 1.6.3.3
>
>

I'm going to rework this patch as well. I think the driver needs to do
more than just turn the radio back on. It should also restore the set
frequency and stereo mode.

Regards,

David Ellingsworth
