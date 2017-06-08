Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37600 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751502AbdFHOmd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 10:42:33 -0400
Subject: Re: [media_build] regression at 3a17e11 "update
 v4.10_sched_signal.patch"
To: Vincent McIntyre <vincent.mcintyre@gmail.com>,
        linux-media@vger.kernel.org
References: <20170608131339.GA11167@ubuntu.windy>
 <20170608132826.GB11167@ubuntu.windy>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <546c4974-5fbe-ce02-3a20-f8f2ecf5107f@xs4all.nl>
Date: Thu, 8 Jun 2017 16:42:30 +0200
MIME-Version: 1.0
In-Reply-To: <20170608132826.GB11167@ubuntu.windy>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/06/17 15:28, Vincent McIntyre wrote:
> I managed to find the failing patch, not sure what the fix is.
> 
> $ cd linux/
> $ patch -f -N -p1 -i ../backports/v4.10_sched_signal.patch
> patching file drivers/media/dvb-core/dvb_ca_en50221.c
> Hunk #1 succeeded at 35 (offset 1 line).
> patching file drivers/media/dvb-core/dvb_demux.c
> Hunk #1 succeeded at 20 with fuzz 1 (offset 1 line).
> patching file drivers/media/dvb-core/dvb_frontend.c
> Hunk #1 succeeded at 30 (offset 1 line).
> patching file drivers/media/pci/cx18/cx18-driver.h
> patching file drivers/media/pci/ivtv/ivtv-driver.c
> patching file drivers/media/pci/ivtv/ivtv-driver.h
> Hunk #1 succeeded at 39 (offset 1 line).
> patching file drivers/media/pci/pt1/pt1.c
> patching file drivers/media/pci/pt3/pt3.c
> patching file drivers/media/pci/solo6x10/solo6x10-i2c.c
> patching file drivers/media/pci/zoran/zoran_device.c
> patching file drivers/media/platform/vivid/vivid-radio-rx.c
> patching file drivers/media/platform/vivid/vivid-radio-tx.c
> patching file drivers/media/rc/lirc_dev.c
> Hunk #1 FAILED at 18.
> 1 out of 1 hunk FAILED -- saving rejects to file drivers/media/rc/lirc_dev.c.rej
> patching file drivers/media/usb/cpia2/cpia2_core.c
> patching file drivers/media/usb/gspca/cpia1.c
> Hunk #1 succeeded at 28 (offset 1 line).
> patching file drivers/media/v4l2-core/videobuf-dma-sg.c
> patching file drivers/staging/media/lirc/lirc_zilog.c
> patching file include/media/v4l2-ioctl.h
> 
> $ cat drivers/media/rc/lirc_dev.c.rej
> --- drivers/media/rc/lirc_dev.c
> +++ drivers/media/rc/lirc_dev.c
> @@ -18,7 +18,7 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
>  #include <linux/module.h>
> -#include <linux/sched/signal.h>
> +#include <linux/sched.h>
>  #include <linux/ioctl.h>
>  #include <linux/poll.h>
>  #include <linux/mutex.h>
> 

Odd, it applies cleanly here.

But don't bother, the media_build totally broke after the latest round of
commits to the master. We're looking into that, but it might take a bit
of time before it is resolved.

Regards,

	Hans
