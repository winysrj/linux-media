Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe07.c2i.net ([212.247.154.194]:57102 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751047Ab2GBTNG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Jul 2012 15:13:06 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Question about V4L2_MEMORY_USERPTR
Date: Mon, 2 Jul 2012 21:07:56 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
References: <201203230819.45385.hselasky@c2i.net> <20120701140058.GB20344@valkosipuli.retiisi.org.uk> <1507857.9YMcHMaQav@avalon>
In-Reply-To: <1507857.9YMcHMaQav@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207022107.56259.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Sakari,

For the sake of the matter, here is the driver in question:
http://www.freshports.org/multimedia/webcamd/

Under native-Linux (kernel mode):

I've looked at the linux-media code a bit and it appears that video data is 
copied directly from the USB callback functions to the destination process in 
userspace. This works because the userspace buffer is mapped into kernel 
memory it appears. Correct me if I'm wrong:

video/videobuf-core.c:

        err = __videobuf_mmap_setup(q, count, size, V4L2_MEMORY_USERPTR);

Under FreeBSD where the Linux kernel code is running in user-space as a driver 
daemon, this part cannot be done exactly like this, so I've just patched out 
the V4L2_MEMORY_USERPTR feature until further.

Am I clear?

--HPS

On Monday 02 July 2012 11:24:15 Laurent Pinchart wrote:
> On Sunday 01 July 2012 17:00:58 Sakari Ailus wrote:
> > On Fri, Mar 23, 2012 at 08:19:45AM +0100, Hans Petter Selasky wrote:
> > > Hi,
> > > 
> > > I have a question about V4L2_MEMORY_USERPTR:
> > > 
> > > From which context are the kernel's "copy_to_user()" functions called
> > > in relation to V4L2_MEMORY_USERPTR ? Can this be a USB callback
> > > function or is it only syscalls, like read/write/ioctl that are
> > > allowed to call "copy_to_user()" ?
> > > 
> > > The reason for asking is that I am maintaining a userland port of the
> > > media tree's USB drivers for FreeBSD. At the present moment it is not
> > > allowed to call copy_to_user() or copy_from_user() unless the backtrace
> > > shows a syscall, so the V4L2_MEMORY_USERPTR feature is simply removed
> > > and disabled. I'm currently thinking how I can enable this feature.
> > 
> > I hope this is still relevant --- I just read your message the first
> > time.
> > 
> > I don't know how V4L2 is being used in FreeBSD userland, but the intent
> > of copy_to_user() function is to copy the contents of kernel memory to
> > somewhere the user space has a mapping to (and the other way around for
> > copy_from_user()).
> 
> copy_(to|from)_user(), by definition, require a userspace memory context to
> perform the copy operation. They can't be called from interrupt context,
> kernel threads, or any other context where no userspace memory context is
> present.
> 
> > Are your video buffers allocated by the kernel or not? How is USB
> > accessed when you don't have the Linux kernel USB framework around?
