Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45010 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbZCJJAF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 05:00:05 -0400
Date: Tue, 10 Mar 2009 05:59:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] v4l2-ioctl: get rid of
 video_decoder.h
Message-ID: <20090310055950.0529630f@pedra.chehab.org>
In-Reply-To: <200903100831.32788.hverkuil@xs4all.nl>
References: <E1LgqdW-00019H-Vp@www.linuxtv.org>
	<200903100831.32788.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Tue, 10 Mar 2009 08:31:32 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> > The V4L1 obsoleted header video_decoder.h is not used anymore by any
> > driver. Only a name decoding function at v4l2-ioctl still implements it.
> 
> Hoorah! 

Yes! We're finally getting rid of some of those V4L1 headers. The only
remaining one is videodev.h.

> Note that video_encoder.h is now also unused, but since that header 
> isn't in v4l-dvb it should be removed manually in the kernel during the 
> 2.6.30 merge window.

I've already got rid of video_encoder.h on my -git tree. I just wrote a patch
removing the rest of video_decoder.h references on -git.

Yet, there are a few drivers that still requires V4L1 videodev.h header:

A minimal set of V4L1 stuff, just for VIDIOCMBUF:
	linux/include/media/videobuf-core.h
	linux/include/media/v4l2-ioctl.h

Core modules, to preserve V4L1 compatibility:
	linux/drivers/media/video/v4l2-ioctl.c
	linux/drivers/media/video/v4l1-compat.c
	linux/drivers/media/video/v4l2-compat-ioctl32.c

V4L1 legacy webcam drivers:
	linux/include/media/ovcamchip.h
	linux/drivers/media/video/stv680.c
	linux/drivers/media/video/ov511.h
	linux/drivers/media/video/w9966.c
	linux/drivers/media/video/meye.c
	linux/drivers/media/video/bw-qcam.c
	linux/drivers/media/video/cpia.h
	linux/drivers/media/video/cpia2/cpia2_v4l.c
	linux/drivers/media/video/cpia2/cpia2.h
	linux/drivers/media/video/cpia2/cpia2dev.h
	linux/drivers/media/video/se401.h
	linux/drivers/media/video/c-qcam.c
	linux/drivers/media/video/usbvideo/usbvideo.h
	linux/drivers/media/video/usbvideo/vicam.c
	linux/drivers/media/video/w9968cf.c
	linux/drivers/media/video/arv.c
	linux/drivers/media/video/pwc/pwc.h

A few capture drivers:
	linux/drivers/media/video/zoran/zoran_driver.c
	linux/drivers/media/video/stradis.c
	linux/drivers/media/video/pms.c

And two i2c helper drivers:
	linux/drivers/media/video/msp3400-driver.c
	linux/drivers/media/video/tuner-core.c

Most of the above are the legacy V4L1 webcam drivers. It would be really nice
if someone could volunteer to port those Webcam drivers to gspca.

I suspect that it shouldn't hard to remove the few V4L1 bits from zoran_driver, after all
the conversions made. Yet, there are some Zoran specific ioctls that use this.
We should probably discontinue those zoran-specific ioctls.

It seems also safe to remove V4L1 code from msp3400, since, AFAIK, all drivers
that supports it are already converted to V4L2.

After converting stradis, it will be probably safe also to remove V4L1 code
from tuner-core.

I doubt that there are still some pms hardware around, but it would be
interesting to keep this module, since this is the first V4L driver wrote.

-- 

Cheers,
Mauro
