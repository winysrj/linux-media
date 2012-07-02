Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42224 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab2GBJYM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2012 05:24:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Petter Selasky <hselasky@c2i.net>, linux-media@vger.kernel.org
Subject: Re: Question about V4L2_MEMORY_USERPTR
Date: Mon, 02 Jul 2012 11:24:15 +0200
Message-ID: <1507857.9YMcHMaQav@avalon>
In-Reply-To: <20120701140058.GB20344@valkosipuli.retiisi.org.uk>
References: <201203230819.45385.hselasky@c2i.net> <20120701140058.GB20344@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 01 July 2012 17:00:58 Sakari Ailus wrote:
> On Fri, Mar 23, 2012 at 08:19:45AM +0100, Hans Petter Selasky wrote:
> > Hi,
> > 
> > I have a question about V4L2_MEMORY_USERPTR:
> > 
> > From which context are the kernel's "copy_to_user()" functions called in
> > relation to V4L2_MEMORY_USERPTR ? Can this be a USB callback function or
> > is it only syscalls, like read/write/ioctl that are allowed to call
> > "copy_to_user()" ?
> > 
> > The reason for asking is that I am maintaining a userland port of the
> > media tree's USB drivers for FreeBSD. At the present moment it is not
> > allowed to call copy_to_user() or copy_from_user() unless the backtrace
> > shows a syscall, so the V4L2_MEMORY_USERPTR feature is simply removed and
> > disabled. I'm currently thinking how I can enable this feature.
> 
> I hope this is still relevant --- I just read your message the first time.
> 
> I don't know how V4L2 is being used in FreeBSD userland, but the intent of
> copy_to_user() function is to copy the contents of kernel memory to
> somewhere the user space has a mapping to (and the other way around for
> copy_from_user()).

copy_(to|from)_user(), by definition, require a userspace memory context to 
perform the copy operation. They can't be called from interrupt context, 
kernel threads, or any other context where no userspace memory context is 
present.

> Are your video buffers allocated by the kernel or not? How is USB accessed
> when you don't have the Linux kernel USB framework around?

-- 
Regards,

Laurent Pinchart

