Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36785 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751191AbdFYGpr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 02:45:47 -0400
Received: by mail-pf0-f193.google.com with SMTP id z6so4958724pfk.3
        for <linux-media@vger.kernel.org>; Sat, 24 Jun 2017 23:45:47 -0700 (PDT)
Date: Sun, 25 Jun 2017 16:45:36 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [media_build] regression at 3a17e11 "update
 v4.10_sched_signal.patch"
Message-ID: <20170625064534.GA30976@ubuntu.windy>
References: <20170608131339.GA11167@ubuntu.windy>
 <20170608132826.GB11167@ubuntu.windy>
 <546c4974-5fbe-ce02-3a20-f8f2ecf5107f@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546c4974-5fbe-ce02-3a20-f8f2ecf5107f@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 08, 2017 at 04:42:30PM +0200, Hans Verkuil wrote:
> On 08/06/17 15:28, Vincent McIntyre wrote:
> > I managed to find the failing patch, not sure what the fix is.
> > 
> > $ cd linux/
> > $ patch -f -N -p1 -i ../backports/v4.10_sched_signal.patch
> > patching file drivers/media/dvb-core/dvb_ca_en50221.c
> > Hunk #1 succeeded at 35 (offset 1 line).
> > patching file drivers/media/dvb-core/dvb_demux.c
> > Hunk #1 succeeded at 20 with fuzz 1 (offset 1 line).
> > patching file drivers/media/dvb-core/dvb_frontend.c
> > Hunk #1 succeeded at 30 (offset 1 line).
> > patching file drivers/media/pci/cx18/cx18-driver.h
> > patching file drivers/media/pci/ivtv/ivtv-driver.c
> > patching file drivers/media/pci/ivtv/ivtv-driver.h
> > Hunk #1 succeeded at 39 (offset 1 line).
> > patching file drivers/media/pci/pt1/pt1.c
> > patching file drivers/media/pci/pt3/pt3.c
> > patching file drivers/media/pci/solo6x10/solo6x10-i2c.c
> > patching file drivers/media/pci/zoran/zoran_device.c
> > patching file drivers/media/platform/vivid/vivid-radio-rx.c
> > patching file drivers/media/platform/vivid/vivid-radio-tx.c
> > patching file drivers/media/rc/lirc_dev.c
> > Hunk #1 FAILED at 18.
> > 1 out of 1 hunk FAILED -- saving rejects to file drivers/media/rc/lirc_dev.c.rej
> > patching file drivers/media/usb/cpia2/cpia2_core.c
> > patching file drivers/media/usb/gspca/cpia1.c
> > Hunk #1 succeeded at 28 (offset 1 line).
> > patching file drivers/media/v4l2-core/videobuf-dma-sg.c
> > patching file drivers/staging/media/lirc/lirc_zilog.c
> > patching file include/media/v4l2-ioctl.h
> > 
> > $ cat drivers/media/rc/lirc_dev.c.rej
> > --- drivers/media/rc/lirc_dev.c
> > +++ drivers/media/rc/lirc_dev.c
> > @@ -18,7 +18,7 @@
> >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >  
> >  #include <linux/module.h>
> > -#include <linux/sched/signal.h>
> > +#include <linux/sched.h>
> >  #include <linux/ioctl.h>
> >  #include <linux/poll.h>
> >  #include <linux/mutex.h>
> > 
> 
> Odd, it applies cleanly here.
> 
> But don't bother, the media_build totally broke after the latest round of
> commits to the master. We're looking into that, but it might take a bit
> of time before it is resolved.
> 

Just to follow up on this.
The build still fell over during patching if I ran
   build --main-git --depth 1 -v 1
but did not if I ran
   build -v 1
(which causes the tarball to download instead)

This suggests an inconsistency between the two,
which is surprising and likely unintended.

I poked around a bit and found that the media subdir
was out of date and the build script was not updating it;
--depth 1 appears to suppress that.

Once I did a manual update, the patching succeeded.
I'll try to work out a patch so 'build' avoids this issue in future.

Vince
