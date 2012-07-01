Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45684 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932401Ab2GAOBB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jul 2012 10:01:01 -0400
Date: Sun, 1 Jul 2012 17:00:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Petter Selasky <hselasky@c2i.net>
Cc: linux-media@vger.kernel.org
Subject: Re: Question about V4L2_MEMORY_USERPTR
Message-ID: <20120701140058.GB20344@valkosipuli.retiisi.org.uk>
References: <201203230819.45385.hselasky@c2i.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203230819.45385.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Mar 23, 2012 at 08:19:45AM +0100, Hans Petter Selasky wrote:
> Hi,
> 
> I have a question about V4L2_MEMORY_USERPTR:
> 
> From which context are the kernel's "copy_to_user()" functions called in 
> relation to V4L2_MEMORY_USERPTR ? Can this be a USB callback function or is it 
> only syscalls, like read/write/ioctl that are allowed to call "copy_to_user()" 
> ?
> 
> The reason for asking is that I am maintaining a userland port of the media 
> tree's USB drivers for FreeBSD. At the present moment it is not allowed to 
> call copy_to_user() or copy_from_user() unless the backtrace shows a syscall, 
> so the V4L2_MEMORY_USERPTR feature is simply removed and disabled. I'm 
> currently thinking how I can enable this feature.

I hope this is still relevant --- I just read your message the first time.

I don't know how V4L2 is being used in FreeBSD userland, but the intent of
copy_to_user() function is to copy the contents of kernel memory to
somewhere the user space has a mapping to (and the other way around for
copy_from_user()).

Are your video buffers allocated by the kernel or not? How is USB accessed
when you don't have the Linux kernel USB framework around?

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
