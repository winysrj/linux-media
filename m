Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56167 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab1JMRwd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Oct 2011 13:52:33 -0400
Received: by bkbzt4 with SMTP id zt4so1762980bkb.19
        for <linux-media@vger.kernel.org>; Thu, 13 Oct 2011 10:52:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E971255.8080203@lockie.ca>
References: <4E967E5B.3050504@lockie.ca>
	<CAGoCfiyViRDt690TWtiWdnfP5C-az2aeOK=TGhgP4kwT1QJfqQ@mail.gmail.com>
	<4E971255.8080203@lockie.ca>
Date: Thu, 13 Oct 2011 13:52:32 -0400
Message-ID: <CAGoCfix6dESpBe_=yX38q-q7JGYUcp2UkVi+4kM7dHL=cmW0bg@mail.gmail.com>
Subject: Re: recent cx23385?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: James <bjlockie@lockie.ca>
Cc: linux-media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 13, 2011 at 12:31 PM, James <bjlockie@lockie.ca> wrote:
> Where do I see the date/version of the media subsystem?

You can't.  The media_build stuff is just a script which backports
part of the latest kernel tree and applies some patches to make it
work with older kernels.  There is no real "version" for it.

> It is not video related, w_scan works sometimes but freezes the kernel
> sometimes.
> This is booting right to a console.
> Is there a program to do a stress test on the hardware and print lots of
> messages as it's working?

Not really, you can add the debug=1 modprobe option, but in reality
you probably need to get to the bottom of what is causing the hardware
lockup.

> I did:
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
> /bin/sh: /sbin/lsmod: No such file or directory
> Lot's of pr_fmt redefined errors.

lsmod is required.  Go install whatever package provides it.

> I put the build log at: lockie.ca/test/v4l_build.txt.bz2
>
> Something is not right though. :-(
> $ modprobe cx23885
> WARNING: Deprecated config file /etc/modprobe.conf, all config files belong
> into /etc/modprobe.d/.
> WARNING: Error inserting altera_ci
> (/lib/modules/3.0.4/kernel/drivers/media/video/cx23885/altera-ci.ko):
> Invalid module format
> WARNING: Error inserting media
> (/lib/modules/3.0.4/kernel/drivers/media/media.ko): Invalid module format
> WARNING: Error inserting videodev
> (/lib/modules/3.0.4/kernel/drivers/media/video/videodev.ko): Invalid module
> format
> WARNING: Error inserting v4l2_common
> (/lib/modules/3.0.4/kernel/drivers/media/video/v4l2-common.ko): Invalid
> module format
> WARNING: Error inserting videobuf_core
> (/lib/modules/3.0.4/kernel/drivers/media/video/videobuf-core.ko): Invalid
> module format
> WARNING: Error inserting videobuf_dvb
> (/lib/modules/3.0.4/kernel/drivers/media/video/videobuf-dvb.ko): Invalid
> module format
> WARNING: Error inserting videobuf_dma_sg
> (/lib/modules/3.0.4/kernel/drivers/media/video/videobuf-dma-sg.ko): Invalid
> module format
> WARNING: Error inserting cx2341x
> (/lib/modules/3.0.4/kernel/drivers/media/video/cx2341x.ko): Invalid module
> format
> WARNING: Error inserting altera_stapl
> (/lib/modules/3.0.4/kernel/drivers/linux/drivers/misc/altera-stapl/altera-stapl.ko):
> Invalid module format
> WARNING: Error inserting rc_core
> (/lib/modules/3.0.4/kernel/drivers/media/rc/rc-core.ko): Invalid module
> format
> FATAL: Error inserting cx23885
> (/lib/modules/3.0.4/kernel/drivers/media/video/cx23885/cx23885.ko): Invalid
> module format

Your build is screwed up.  Would recommend you do a "make clean" and
then "make && make install".  Then reboot.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
