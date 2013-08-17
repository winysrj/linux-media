Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:53282 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3HQXip (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Aug 2013 19:38:45 -0400
Received: by mail-bk0-f48.google.com with SMTP id my13so1019646bkb.35
        for <linux-media@vger.kernel.org>; Sat, 17 Aug 2013 16:38:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20130815T161444-925@post.gmane.org>
References: <loom.20130815T161444-925@post.gmane.org>
Date: Sun, 18 Aug 2013 07:38:43 +0800
Message-ID: <CALxrGmX2aZsTGG_gM6EECLa1Y9vWgWNqEg_TFoXFr=gVmsJnvw@mail.gmail.com>
Subject: Re: OMAP3 ISP DQBUF hangs
From: Su Jiaquan <jiaquan.lnx@gmail.com>
To: Tom <Bassai_Dai@gmx.net>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tom,

On Thu, Aug 15, 2013 at 10:15 PM, Tom <Bassai_Dai@gmx.net> wrote:
> Hello,
>
> I'm working with an OMAP3 DM3730 processor module with a ov3640 camera
> module attached on parallel interface. I'm using Linux 3.5 and an
> application which builds the pipeline and grabs an image like the
> "media-ctl" and the "yavta" tools.
>
> I configured the pipeline to:
>
> sensor->ccdc->memory
>
> When I call ioctl with DQBUF the calling functions are:
>
> isp_video_dqbuf -> omap3isp_video_queue_dqbuf -> isp_video_buffer_wait ->
> wait_event_interruptible
>
> The last function waits until the state of the buffer will be reseted
> somehow. Can someone tell my which function sets the state of the buffer? Am
> I missing an interrupt?
>
> Best Regards, Tom
>

I'm not familar with omap3isp, but from the code, the wait queue is
released by function ccdc_isr_buffer->omap3isp_video_buffer_next.
You are either missing a interrupt, or running out of buffer, or found
a buffer under run.

Jiaquan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
