Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50810 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaI3WbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 18:31:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Paulo Assis <pj.assis@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: uvcvideo fails on 3.16 and 3.17 kernels
Date: Wed, 01 Oct 2014 01:31:11 +0300
Message-ID: <3332528.UXGlNqFTSJ@avalon>
In-Reply-To: <CAPueXH73_yHoBhHKn+zroC6WViBmU1XH-B-FPVE2Q-V56bcBFQ@mail.gmail.com>
References: <CAPueXH4puHLAPWpBS9gjGHd5AGb1gAxZqSggXDaGEJ3WYC_nMA@mail.gmail.com> <CAPueXH73_yHoBhHKn+zroC6WViBmU1XH-B-FPVE2Q-V56bcBFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paulo,

Thank you for investigation this.

On Tuesday 30 September 2014 13:56:15 Paulo Assis wrote:
> Ok,
> so I've set a workaround in guvcview, it now uses the length filed if
> bytesused is set to zero.
> Anyway I think this violates the v4l2 api:
> http://linuxtv.org/downloads/v4l-dvb-apis/buffer.html
> 
> bytesused - ..., Drivers must set this field when type refers to an
> input stream, ...
> 
> without this value we have no way of knowing the exact frame size for
> compressed formats.
> 
> And this was working in uvcvideo up until 3.16, I don't know how many
> userspace apps rely on this value, but at least guvcview does, and
> it's currently broken for uvcvideo devices in the latest kernels.

It took me some time to debug the problem, and I think the problem is actually 
on guvcview's side. When dequeuing a video buffer, the application requeues it 
immediately before processing the buffer's contents. The VIDIOC_QBUF ioctl 
will reset the bytesused field to 0.

While you could work around the problem by using a different struct 
v4l2_buffer instance for the VIDIOC_QBUF call, the V4L2 doesn't allow 
userspace application to access a queued buffer. You must process the buffer 
before requeuing it.

> 2014-09-30 9:50 GMT+01:00 Paulo Assis <pj.assis@gmail.com>:
> > I referring to the following bug:
> > 
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1362358
> > 
> > I've run some tests and after increasing verbosity for uvcvideo, I get:
> > EOF on empty payload
> > 
> > this seems consistent with the zero size frames returned by the driver.
> > After VIDIOC_DQBUF | VIDIOC_QBUF, I get buf.bytesused=0
> > 
> > Testing with an eye toy 2 (gspca), everything works fine, so this is
> > definitly related to uvcvideo.
> > This happens on all available formats (YUYV and MJPEG)

-- 
Regards,

Laurent Pinchart

