Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50677 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2GERYl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 13:24:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Petter Selasky <hselasky@c2i.net>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: Question about V4L2_MEMORY_USERPTR
Date: Thu, 05 Jul 2012 19:24:47 +0200
Message-ID: <4977006.H7Qry87s3L@avalon>
In-Reply-To: <201207022107.56259.hselasky@c2i.net>
References: <201203230819.45385.hselasky@c2i.net> <1507857.9YMcHMaQav@avalon> <201207022107.56259.hselasky@c2i.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans-Petter,

On Monday 02 July 2012 21:07:56 Hans Petter Selasky wrote:
> Hi Laurent and Sakari,
> 
> For the sake of the matter, here is the driver in question:
> http://www.freshports.org/multimedia/webcamd/
> 
> Under native-Linux (kernel mode):
> 
> I've looked at the linux-media code a bit and it appears that video data is
> copied directly from the USB callback functions to the destination process
> in userspace. This works because the userspace buffer is mapped into kernel
> memory it appears. Correct me if I'm wrong:
> 
> video/videobuf-core.c:
> 
>         err = __videobuf_mmap_setup(q, count, size, V4L2_MEMORY_USERPTR);

It's hard to tell from that line only. V4L2_MEMORY_USERPTR takes a memory 
pointer from userspace and uses it in the kernel. How the memory is used 
depends on the driver, it can be converted to a scatter list of physical 
memory and passed to the hardware, mapped to the kernel, be accessed using 
copy_from_user/copy_to_user, ...

BTW videobuf1 is outdated, drivers will eventually be ported to videobuf2.

> Under FreeBSD where the Linux kernel code is running in user-space as a
> driver daemon, this part cannot be done exactly like this, so I've just
> patched out the V4L2_MEMORY_USERPTR feature until further.
> 
> Am I clear?

-- 
Regards,

Laurent Pinchart

