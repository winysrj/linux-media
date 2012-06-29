Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53710 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2F2ON7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 10:13:59 -0400
Received: by gglu4 with SMTP id u4so2731897ggl.19
        for <linux-media@vger.kernel.org>; Fri, 29 Jun 2012 07:13:58 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 29 Jun 2012 09:13:58 -0500
Message-ID: <CAC-OdnAEsT=wDGZZVcNaywAFg2aquRNk3NkYFZZjbYH+VBPpBQ@mail.gmail.com>
Subject: [Query] Clearing V4L2_BUF_FLAG_MAPPED flag on a videobuf2 buffer
 after munmap
From: Sergio Aguirre <sergio.a.aguirre@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

So, I've been trying to test the REQBUFS(0) from libv4l2 with my
omap4iss device, and I've hit the following problem:

So, I basically do the basic IOCTL sequence:

open(/dev/video0)
VIDIOC_QUERYCAP
VIDIOC_ENUM_FMT
VIDIOC_ENUM_FRAMESIZES
VIDIOC_ENUM_FRAMEINTERVALS
VIDIOC_S_FMT (w = 640, h = 480, pixfmt = V4L2_PIX_FMT_YUYV, type =
V4L2_BUF_TYPE_VIDEO_CAPTURE)
VIDIOC_S_PARM (capability = V4L2_CAP_TIMEPERFRAME, timeperframe = 1/30)
VIDIOC_REQBUFS (count = 6, MMAP)
  Loop for 6 times:
    VIDIOC_QUERYBUF (to get buff length)
    mmap(length)
  Loop for 6 times:
    VIDIOC_QBUF(index = 0-5)
VIDIOC_STREAMON
  (Loop to poll, DQBUF and QBUF the same buffer)
VIDIOC_STREAMOFF
  Loop for 6 times:
    munmap()
VIDIOC_REQBUFS (count = 0, MMAP)

... And in this call, it fails on libv4l2 level, since it checks all
buffers to see
if they're mapped, by doign QUERYBUF on each index, and checking for
"V4L2_BUF_FLAG_MAPPED" flag.

Now, digging deep into how this flag is populated, I noticed the following:

I notice that in "drivers/media/video/videobuf2-core.c", inside:
vb2_querybuf()
  -> __fill_v4l2_buffer()

There's this condition:
	if (vb->num_planes_mapped == vb->num_planes)
		b->flags |= V4L2_BUF_FLAG_MAPPED;

The problem is that, even if i did a munmap, the count of vb->num_planes_mapped
is not decreased... :/

How's this supposed to work? Do I need to do something in my driver to avoid
this flag to be set?

Regards,
Sergio
