Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f42.google.com ([209.85.213.42]:59095 "EHLO
	mail-yw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab2F2VPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 17:15:52 -0400
Received: by yhfq11 with SMTP id q11so4580851yhf.1
        for <linux-media@vger.kernel.org>; Fri, 29 Jun 2012 14:15:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC-OdnAEsT=wDGZZVcNaywAFg2aquRNk3NkYFZZjbYH+VBPpBQ@mail.gmail.com>
References: <CAC-OdnAEsT=wDGZZVcNaywAFg2aquRNk3NkYFZZjbYH+VBPpBQ@mail.gmail.com>
Date: Fri, 29 Jun 2012 16:15:51 -0500
Message-ID: <CAC-OdnD+9gTdnSBjdV2qps=cA66mdGHd6p8vALj3XtNWY1uy0w@mail.gmail.com>
Subject: Re: [Query] Clearing V4L2_BUF_FLAG_MAPPED flag on a videobuf2 buffer
 after munmap
From: Sergio Aguirre <sergio.a.aguirre@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 29, 2012 at 9:13 AM, Sergio Aguirre
<sergio.a.aguirre@gmail.com> wrote:
> Hi all,
>
> So, I've been trying to test the REQBUFS(0) from libv4l2 with my
> omap4iss device, and I've hit the following problem:

Actually... nevermind :(

I just realized that multiple fixes went in after 3.1.

This problem i had is on a Android ICS kernel, which is v3.0, and didn't had
some REQBUFS(0) patches.

Very sorry for the noise.

Regards,
Sergio

>
> So, I basically do the basic IOCTL sequence:
>
> open(/dev/video0)
> VIDIOC_QUERYCAP
> VIDIOC_ENUM_FMT
> VIDIOC_ENUM_FRAMESIZES
> VIDIOC_ENUM_FRAMEINTERVALS
> VIDIOC_S_FMT (w = 640, h = 480, pixfmt = V4L2_PIX_FMT_YUYV, type =
> V4L2_BUF_TYPE_VIDEO_CAPTURE)
> VIDIOC_S_PARM (capability = V4L2_CAP_TIMEPERFRAME, timeperframe = 1/30)
> VIDIOC_REQBUFS (count = 6, MMAP)
>  Loop for 6 times:
>    VIDIOC_QUERYBUF (to get buff length)
>    mmap(length)
>  Loop for 6 times:
>    VIDIOC_QBUF(index = 0-5)
> VIDIOC_STREAMON
>  (Loop to poll, DQBUF and QBUF the same buffer)
> VIDIOC_STREAMOFF
>  Loop for 6 times:
>    munmap()
> VIDIOC_REQBUFS (count = 0, MMAP)
>
> ... And in this call, it fails on libv4l2 level, since it checks all
> buffers to see
> if they're mapped, by doign QUERYBUF on each index, and checking for
> "V4L2_BUF_FLAG_MAPPED" flag.
>
> Now, digging deep into how this flag is populated, I noticed the following:
>
> I notice that in "drivers/media/video/videobuf2-core.c", inside:
> vb2_querybuf()
>  -> __fill_v4l2_buffer()
>
> There's this condition:
>        if (vb->num_planes_mapped == vb->num_planes)
>                b->flags |= V4L2_BUF_FLAG_MAPPED;
>
> The problem is that, even if i did a munmap, the count of vb->num_planes_mapped
> is not decreased... :/
>
> How's this supposed to work? Do I need to do something in my driver to avoid
> this flag to be set?
>
> Regards,
> Sergio
