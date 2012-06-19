Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60724 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2FSAw6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 20:52:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Alex Gershgorin <alexg@meprolight.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: SoC i.mx35 userptr method failure while running capture-example utility
Date: Tue, 19 Jun 2012 02:53:07 +0200
Message-ID: <4822902.K3IcgScTxe@avalon>
In-Reply-To: <CA+V-a8tX5tat3D2A_UFcRY-hAx1fZsXVLhO-hH8ib-L5JopO6g@mail.gmail.com>
References: <4875438356E7CA4A8F2145FCD3E61C0B2CC9525492@MEP-EXCH.meprolight.com> <1448068.cLOEOI22jq@avalon> <CA+V-a8tX5tat3D2A_UFcRY-hAx1fZsXVLhO-hH8ib-L5JopO6g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Monday 18 June 2012 16:26:01 Prabhakar Lad wrote:
> On Mon, Jun 18, 2012 at 4:05 PM, Laurent Pinchart wrote:
> > On Monday 18 June 2012 12:28:44 Prabhakar Lad wrote:
> >> On Wed, May 2, 2012 at 4:20 AM, Guennadi Liakhovetski wrote:
> >> > On Tue, 1 May 2012, Alex Gershgorin wrote:
> >> >> Hi everyone,
> >> >> 
> >> >> I use user-space utility from
> >> >> http://git.linuxtv.org/v4l-utils.git/blob/HEAD:/contrib/test/capture-
> >> >> example.c I made two small changes in this application and this is
> >> >> running on i.MX35 SoC
> >> >> 
> >> >> fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB565;
> >> >> fmt.fmt.pix.field       = V4L2_FIELD_ANY;
> >> >> 
> >> >> When MMAP method is used everything works fine, problem occurs when
> >> >> using USERPTR method this can see bellow :
> >> >> 
> >> >> ./capture-example -u -f -d /dev/video0
> >> >> mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
> >> >> Failed acquiring VMA for vaddr 0x76cd9008
> >> >> VIDIOC_QBUF error 22, Invalid arg
> >> > 
> >> > It doesn't surprise me, that this doesn't work. capture-example
> >> > allocates absolutely normal user-space buffers, when called with
> >> > USERPTR, and those buffers are very likely discontiguous. Whereas mx3-
> >> > camera needs physically contiguous buffers, so, this can only fail.
> >> > This means, you either have to use MMAP or you need to allocate USERPTR
> >> > buffers in a special way to guarantee their contiguity.
> >> 
> >> Even I am facing a similar issue when ported to VB2 for USERPTR.
> >> How do we ensure the buffers not discontiguous. Would cmem assure it?
> > 
> > CMEM is definitely not the way to go, it's an out-of-tree hack that should
> > disappear once we get proper CMA and DMABUF support in the kernel.
> > 
> > How to allocate memory depends on your use case(s). If you just need to
> > capture to anonymous memory that will then be read by userspace you
> > shouldn't use USERPTR, but MMAP. If you need to capture to device memory
> > (for instance capturing directly to a frame buffer), you should export a
> > DMABUF object on from the frame buffer driver (this isn't available in
> > mainline yet, I'll try to send a patch soon) and then import it on the
> > V4L2 side (not available in mainline yet either I'm afraid :-)). As an
> > interim solution, mmap() your frame buffer to userspace and then use
> > USERPTR.
> 
> I have got MMAP working with videobuf2, with videobuf there was a support
> for userptr which I need to achieve this with videobuf2.

videobuf2 supports USERPTR as well. If the memory pointed to by your user 
pointer matches the device requirements, USERPTR should work out of the box.

> Can you point me to your branch where you are working on it and also an
> example if you have to interim solution as you suggested above.

I currently have no public branch with the FBDEV DMABUF patches. I need to 
clean them up and submit them upstream, I hope to do that in the next couple 
of days.

Regarding the interim solution, just mmap() your frame buffer to userspace and 
pass that to your V4L driver using USERPTR. That's what embedded systems 
usually do nowadays.

-- 
Regards,

Laurent Pinchart

