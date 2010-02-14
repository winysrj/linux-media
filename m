Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4573 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab0BNOYF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2010 09:24:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: videobuf and streaming I/O questions
Date: Sun, 14 Feb 2010 15:26:09 +0100
Cc: linux-media@vger.kernel.org
References: <201002141422.48362.hverkuil@xs4all.nl> <4B77FD89.3080209@infradead.org>
In-Reply-To: <4B77FD89.3080209@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002141526.09339.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 14 February 2010 14:41:29 Mauro Carvalho Chehab wrote:
> Hans Verkuil wrote:
> > Hi all,
> > 
> > I've been investigating some problems with my qv4l2 utility and I encountered
> > some inconsistencies in the streaming I/O documentation and the videobuf
> > implementation.
> > 
> > I would like to know which is correct.
> > 
> > 1) The VIDIOC_QBUF documentation should specify that the application has
> > to fill in the v4l2_buffer 'flags' field. The fact that this is not explicitly
> > stated tripped me up in qv4l2.
> 
> I don't think you need to set the flags, but for sure you need to clear the data
> on all ioctls. The capture-example.c is a reference code for implementation, and it
> does:
> 
>                         CLEAR(buf);
>                         buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>                         buf.memory = V4L2_MEMORY_MMAP;
>                         buf.index = i;
> 
>                         if (-1 == xioctl(fd, VIDIOC_QBUF, &buf))
>                                 errno_exit("VIDIOC_QBUF");
> 
> As far as I've tested, this app works on all drivers that support mmap.

I will fix the spec for this.

> > 2) The VIDIOC_REQBUFS documentation states that it should be possible to use
> > a count of 0, in which case it should do an implicit STREAMOFF. This is
> > currently not implemented. I have included a patch for this below and if there
> > are no issues with it, then I'll make a pull request for this.
> 
> This can eventually break some application. I think it is safer to fix the specs.

I don't really see how this would break an application and I think that some
drivers that do not use videobuf already support this. The reason why I think
this is a good idea to support it is that this makes it very easy to check
which streaming mode is supported without actually allocating anything.

I was actually using this in qv4l2 with uvc until I tried it with the mxb driver
and discovered that videobuf didn't support it. I am definitely in favor of
fixing the code instead of the spec in this case.

> > 3) The VIDIOC_REQBUFS documentation states that the count field is only used
> > by MEMORY_MMAP, not by MEMORY_USERPTR. This seems to be a false statement.
> > videobuf certainly uses the count field.
> 
> True. We need to fix the specs.
>  
> > 4) The same is true for QBUF and DQBUF and the index field of struct v4l2_buffer:
> > the documentation states that it is only used for MMAP, but as far as I can tell
> > that is not true and it should be used for USERPTR as well.
> 
> True. We need to fix the specs.
> > 
> > 5) Section 3.2 states that one should use VIDIOC_REQBUFS to determine if the
> > memory mapping flavor is supported by the driver. At least in the case of the
> > saa7146/mxb driver (which uses videobuf) this does not work. Even though it only
> > supports mmap, videobuf happily accepts userptr mode as well. Who is supposed
> > to test this? The driver before it calls videobuf_reqbufs?
> 
> videobuf-dma-sg supports all modes. if the driver has restrictions to one of the mode,
> videobuf have no way to know. So, the driver must limit.

OK.

> 
> > 6) V4L2_MEMORY_OVERLAY seems to be supported in videobuf, yet there is no driver
> > that supports it as far as I can tell and the documentation does not explain
> > what it is supposed to do. What is the status of this?
> 
> It is supported by videobuf and it is implemented by a few drivers. The best example
> is bttv-driver. I think saa7134 also implements the overlay mode.

Can you write a bit of documentation on how the m union of v4l2_buffer has to
be filled in for this mode? I will integrate that into the spec.

I found one mention here: 

http://archive.linuxcoding.com/video-4-linux/2002/msg03126.html

And one application that uses it here:

http://www.directfb.org/downloads/Core/DirectFB-1.4/DirectFB-1.4.3.tar.gz

Although it would be nice if it could actually be tested by someone whether
this is actually still working.

Regards,

	Hans


> Some motherboard chipsets don't work fine on overlay mode, since, in general, it causes
> a PCI2PCI data transfers. It is a known bug that, when PCI2PCI DMA transfers are happening,
> and if a PCI2MEM or MEM2PCI DMA is called (for example, to write a data to disk or to get
> swapped memory), that the two transfers got messed, causing memory and/or disk corruption.
> 
> There are some PCI quirks to disable this feature at the chipsets where this bug is known
> (some chipsets manufactured by VIA and by SYS).
> 
> This is mostly why people don't get enough motivation for use it on other drivers.
> > 
> > When I know the correct answers to this I will fix these issues. The qv4l2 tool
> > is written based on the documentation instead of copy-and-paste, so this was a
> > good test case to discover these inconsistencies.
> 
> Yes.
> > 
> > Regards,
> > 
> > 	Hans
> 
> Cheers,
> Mauro
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
