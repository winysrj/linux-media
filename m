Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64879 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932976Ab1KBQMu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 12:12:50 -0400
Received: by ggnb2 with SMTP id b2so289761ggn.19
        for <linux-media@vger.kernel.org>; Wed, 02 Nov 2011 09:12:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACKLOr2CvPofCcveh6ReYuEbAzsq+z4hu12nza_pTwSceYtRkQ@mail.gmail.com>
References: <CACKLOr2CvPofCcveh6ReYuEbAzsq+z4hu12nza_pTwSceYtRkQ@mail.gmail.com>
Date: Wed, 2 Nov 2011 12:12:49 -0400
Message-ID: <CAGoCfiym+uCKq7ZuxrryO-ofboA2WG_R4JEGZ6AgN18JbX_YQQ@mail.gmail.com>
Subject: Re: UVC with continuous video buffers.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 2, 2011 at 11:49 AM, javier Martin
<javier.martin@vista-silicon.com> wrote:
> Hi,
> we have a system with a UVC camera connected to USB to acquire video
> images and a hardware processor which needs continuous memory buffers
> to process them.
>
> I've been looking at the current version of UVC drivers and it seems
> it allocates buffers using vmalloc_32() call:
> http://lxr.linux.no/#linux+v3.1/drivers/media/video/uvc/uvc_queue.c#L135
>
> I am interested to extend the driver to support contiguous memory
> buffers and send it to mainline. What is the right way to achieve
> this? Can anyone please point me to a video driver example where
> continuous memory allocation is used?

I've actually got a very similar issue and have been looking into it
(an em28xx device on OMAP requiring contiguous physical memory for the
hardware H.264 encoder).  One thing you may definitely want to check
out is the patch sent earlier today with subject:

[PATCH] media: vb2: vmalloc-based allocator user pointer handling
				
While that patch is intended for videobuf2, you might be able to copy
the core logic into videobuf-vmalloc.

There are other drivers which use USERPTR provided buffers (which are
allocated as contiguous memory from userland [i.e. vfpe_capture
accepting buffers from cmemk on the OMAP platform]), but they
typically do DMA so it's not really useful as an example where you
have a USB based device.

If you get it working, by all means send the code to the ML so others
can benefit.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
