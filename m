Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:33789 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3HSPfW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 11:35:22 -0400
Received: by mail-ob0-f175.google.com with SMTP id xn12so5521077obc.6
        for <linux-media@vger.kernel.org>; Mon, 19 Aug 2013 08:35:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20130819T160758-83@post.gmane.org>
References: <loom.20130815T161444-925@post.gmane.org>
	<CALxrGmX2aZsTGG_gM6EECLa1Y9vWgWNqEg_TFoXFr=gVmsJnvw@mail.gmail.com>
	<loom.20130819T160758-83@post.gmane.org>
Date: Mon, 19 Aug 2013 17:35:22 +0200
Message-ID: <CA+2YH7twPoVSKPET2Am9=a3bmER+7cs41sK6mqeQJL4bMCZ2aw@mail.gmail.com>
Subject: Re: OMAP3 ISP DQBUF hangs
From: Enrico <ebutera@users.berlios.de>
To: Tom <Bassai_Dai@gmx.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 19, 2013 at 4:53 PM, Tom <Bassai_Dai@gmx.net> wrote:
>
> you are right. it seems that the list of the ccdc has no buffer left,
> because the printk("TOM ccdc_isr_buffer ERROR 1 ##########\n"); is shown in
> my log. But I don't understand what I need to do to solve the problem.
> What I do is:
> - configure the pipeline
> - open the video device
> - do ioctl VIDIOC_REQBUFS (with memory = V4L2_MEMORY_MMAP and type =
> V4L2_BUF_TYPE_VIDEO_CAPTURE)
> - do ioctl VIDIOC_QUERYBUF
> - do ioctl VIDIOC_STREAMON
> - do ioctl VIDIOC_QBUF
>
> without fail. and when I do ioctl VIDIOC_DQBUF. I get my problem.
>
> Does anyone have an idea what I need to do to solve this problem?

Even if you are sure your application works, try with media-ctl +
yavta first so you can send logs that everybody understand.

Did you check you have interrupts during capture? (cat
/proc/interrupts before and after yavta, look for omap3isp or
something like that).

Enrico
