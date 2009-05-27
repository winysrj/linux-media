Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:51072 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbZE0V33 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 17:29:29 -0400
Date: Wed, 27 May 2009 16:43:32 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: linux-media@vger.kernel.org
Subject: Re: Licensing question regarding SN9C2028 decompression (fwd)
Message-ID: <alpine.LNX.2.00.0905271640190.14249@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hans,

Here is the answer which I got about the question of GPL->LGPL licensing 
in regard to the sn9c2028 decompression code.

Theodore Kilgore

---------- Forwarded message ----------
Date: Wed, 27 May 2009 13:19:46 -0400
From: Harald <hxr@users.sourceforge.net>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: Re: Licensing question regarding SN9C2028 decompression

Hi Theodore,

I give you permission to use the SN9C2028 code with a LGPL license.

I am the current maintainer of the macam project. Most of the code that has 
been
added in the last few years is mine. However, I did not originate the SN9C2028
code. I have messed with it a lot, it may not bear much resemblance to the 
original
code. I am sure that whatever code you based your version on has been modified
as well. I doubt that you use Objective-C for example...

It is likely that technically all of macam should be under LGPL anyway, as it 
works
as a plug-in component to QuickTime. So from an "intent" perspective, that is 
how
the macam code is used anyway. You should be able to use it the same way.

I have never been able to contact the originator (mattik) of the project! I 
became admin
through an intermediate admin (dirkx). We're all three admins, but neither of 
the others
have contributed anything in the last 5 years.

I hope this helps,
Harald


On May 24, 2009, at 13:40, Theodore Kilgore wrote:

> 
> Harald,
> 
> Right now I am working on putting streaming support for the SN9C2028 cameras 
> (supported by libgphoto2/camlibs/sonix as still cameras) into the Linux 
> kernel, as part of linux/drivers/media/video/gspca. In doing so, there is a 
> licensing conflict, as follows:
> 
> The Linux kernel is of course GPL licensed, as we are aware. However, the 
> philosophy of what the kernel is supposed to do with things like video 
> devices is, it takes care of creating a device dev/video and it takes care of 
> basic infrastructural things such as how to talk to the camera, to initialize 
> it, to turn it off, to tell it to stream, and to detect and save packets and 
> to construct frames.
> 
> The code for things like decompression has been deliberately moved away from 
> the kernel code, and the idea is to put all that stuff into a library called 
> libv4l, which then provides a unified interface for userspace streaming apps.
> 
> The problem is, the decompression code would need to go into part of libv4l, 
> namely libv4lconvert. And the license for libv4l and everything in it is 
> LGPL, not GPL.
> 
> As the originator of the decompression function for the Sonix cameras, are 
> you willing to give permission for taking my version of the code from GPL to 
> LGPL? Or can you suggest some other appropriate course of action?
> 
> Theodore Kilgore
