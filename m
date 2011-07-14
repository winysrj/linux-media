Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab1GNK4k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 06:56:40 -0400
Message-ID: <4E1ECB5F.8030308@redhat.com>
Date: Thu, 14 Jul 2011 07:56:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Michael Jones <michael.jones@matrix-vision.de>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] capture-example: allow V4L2_PIX_FMT_GREY with USERPTR
References: <1309270998-5070-1-git-send-email-michael.jones@matrix-vision.de> <4E1E1DC2.1070505@redhat.com> <4E1E94D0.20702@matrix-vision.de>
In-Reply-To: <4E1E94D0.20702@matrix-vision.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-07-2011 04:03, Michael Jones escreveu:
> Hi Mauro,
> 
> On 07/14/2011 12:35 AM, Mauro Carvalho Chehab wrote:
>> Em 28-06-2011 11:23, Michael Jones escreveu:
>>> There is an assumption that the format coming from the device
>>> needs 2 bytes per pixel, which is not the case when the device
>>> delivers e.g. V4L2_PIX_FMT_GREY. This doesn't manifest itself with
>>> IO_METHOD_MMAP because init_mmap() (the default) doesn't take
>>> sizeimage as an argument.
>>>
>>> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
>>> ---
>>>
>>> This same issue would apply to other formats which have 1 byte per pixel,
>>> this patch only fixes it for GREY.  Is this OK for now, or does somebody
>>> have a better suggestion for supporting other formats as well?
>>
>> Well, just rely on the bytesperline provided by the driver should be enough.
>> Devices should be returning it on a consistent way.
>>
>> Regards,
>> Mauro
> 
> So you would rather remove the "Buggy driver paranoia" altogether and
> just trust the bytesperline from the driver?

In fact, to rely on sizeimage. The code there is:

	/* Buggy driver paranoia. */
	min = fmt.fmt.pix.width * 2;
	if (fmt.fmt.pix.bytesperline < min)
		fmt.fmt.pix.bytesperline = min;
	min = fmt.fmt.pix.bytesperline * fmt.fmt.pix.height;
	if (fmt.fmt.pix.sizeimage < min)
		fmt.fmt.pix.sizeimage = min;

See: the code there is just over-estimating the sizeimage. Provided that the drivers
are returning reliable sizeimages, the above code doesn't need to exist.

> That's fine with me, but I
> presumed the paranoia was there for a reason.

Several webcam drivers used to have bugs on the value reported by sizeimage,
or were just filling sizeimage with 0 or a small value and bytesperline with 0.
This were fixed already.

Hmm... there are afew drivers that fill bytesperline with 0, but they
fill sizeimage properly. For example:

drivers/media/video/cx18/cx18-ioctl.c:            pixfmt->sizeimage = 128 * 1024;
drivers/media/video/cx18/cx18-ioctl.c-            pixfmt->bytesperline = 0;
drivers/media/video/ivtv/ivtv-ioctl.c:            pixfmt->sizeimage = 128 * 1024;
drivers/media/video/ivtv/ivtv-ioctl.c-            pixfmt->bytesperline = 0;

If you want to be pedantic, is is probably worth to take a deeper look at the
drivers bellow, but, at least on a quick check, all of them seems to be properly
filling sizeimage:

$ git grep "bytesperline = 0" drivers/media/video/
drivers/media/video/cpia2/cpia2_v4l.c:    f->fmt.pix.bytesperline = 0;
drivers/media/video/cpia2/cpia2_v4l.c:    f->fmt.pix.bytesperline = 0;
drivers/media/video/cx18/cx18-ioctl.c:            pixfmt->bytesperline = 0;
drivers/media/video/cx231xx/cx231xx-417.c:        f->fmt.pix.bytesperline = 0;
drivers/media/video/cx231xx/cx231xx-417.c:        f->fmt.pix.bytesperline = 0;
drivers/media/video/cx23885/cx23885-417.c:        f->fmt.pix.bytesperline = 0;
drivers/media/video/cx23885/cx23885-417.c:        f->fmt.pix.bytesperline = 0;
drivers/media/video/cx23885/cx23885-417.c:        f->fmt.pix.bytesperline = 0;
drivers/media/video/cx88/cx88-blackbird.c:        f->fmt.pix.bytesperline = 0;
drivers/media/video/cx88/cx88-blackbird.c:        f->fmt.pix.bytesperline = 0;
drivers/media/video/cx88/cx88-blackbird.c:        f->fmt.pix.bytesperline = 0;
drivers/media/video/gspca/se401.c:                        sd->fmts[i].bytesperline = 0;
drivers/media/video/ivtv/ivtv-ioctl.c:            pixfmt->bytesperline = 0;
drivers/media/video/ivtv/ivtv-ioctl.c:            pixfmt->bytesperline = 0;
drivers/media/video/saa7164/saa7164-encoder.c:    f->fmt.pix.bytesperline = 0;
drivers/media/video/saa7164/saa7164-encoder.c:    f->fmt.pix.bytesperline = 0;
drivers/media/video/saa7164/saa7164-encoder.c:    f->fmt.pix.bytesperline = 0;
drivers/media/video/saa7164/saa7164-vbi.c:        f->fmt.pix.bytesperline = 0;
drivers/media/video/saa7164/saa7164-vbi.c:        f->fmt.pix.bytesperline = 0;
drivers/media/video/saa7164/saa7164-vbi.c:        f->fmt.pix.bytesperline = 0;
drivers/media/video/soc_camera.c: pix->bytesperline = 0;
drivers/media/video/zoran/zoran_card.c:   zr->vbuf_bytesperline = 0;
drivers/media/video/zoran/zoran_driver.c: fmt->fmt.pix.bytesperline = 0;
drivers/media/video/zoran/zoran_driver.c: fmt->fmt.pix.bytesperline = 0;
drivers/media/video/zoran/zoran_driver.c: fmt->fmt.pix.bytesperline = 0;

> Would you accept a patch
> then that just removes the 7 lines which fiddle with bytesperline?

Just removing the bytesperline seems appropriate for me.

The usage of bytesperline for buffer allocation is wrong. Drivers that use compression
often do things like:

drivers/media/video/gspca/conex.c-                .bytesperline = 640,
drivers/media/video/gspca/conex.c:                .sizeimage = 640 * 480 * 3 / 8 + 590,

The sizeimage considers the maximum size of the headers, and the worse case of the
compress algorithm. Userspace should not expect anything bigger than sizeimage, as
the driver internal buffers were allocated with sizeimage. So, in the unlikely case
that a frame got more than sizeimage, that frame will be dropped or corrupted (or
the driver will OOPS, if there's an internal bug). But nothing bigger than sizeimage
will be returned to userspace.

Thanks,
Mauro.
