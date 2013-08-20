Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:47550 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3HTAuD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 20:50:03 -0400
Received: by mail-bk0-f43.google.com with SMTP id mz13so1621888bkb.2
        for <linux-media@vger.kernel.org>; Mon, 19 Aug 2013 17:50:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20130819T160758-83@post.gmane.org>
References: <loom.20130815T161444-925@post.gmane.org>
	<CALxrGmX2aZsTGG_gM6EECLa1Y9vWgWNqEg_TFoXFr=gVmsJnvw@mail.gmail.com>
	<loom.20130819T160758-83@post.gmane.org>
Date: Tue, 20 Aug 2013 08:50:02 +0800
Message-ID: <CALxrGmWE0G91KSwUysZ+Vz4807ihc9hbPDJqbjoPE4z2YEAN_g@mail.gmail.com>
Subject: Re: OMAP3 ISP DQBUF hangs
From: Su Jiaquan <jiaquan.lnx@gmail.com>
To: Tom <Bassai_Dai@gmx.net>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tom


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
>
>
>

Well, for our practice, we QBUF before STREAMON (not on omap3 isp).
You can try that and see what happens.

As I check the omap3 code, you sequence maybe OK. Coz there is a
restart mechanism in the code to restart CCDC hardware after buffer
underrun. But for you sequence, if the interrupt comes before you
QBUF, then the hardware is running in underrun state ever from the
STREAMON. Not sure the restart mechanism works in this scenario. Let's
wait for answers from the professional :-)

Jiaquan
