Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52200 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531Ab1BQS1X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 13:27:23 -0500
Received: by ywo7 with SMTP id 7so1254069ywo.19
        for <linux-media@vger.kernel.org>; Thu, 17 Feb 2011 10:27:22 -0800 (PST)
Message-ID: <4D5D6884.1090104@gmail.com>
Date: Thu, 17 Feb 2011 16:27:16 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Qing Xu <qingx@marvell.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Johnson <realdealneil@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Uwe Taeubert <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Eino-Ville Talvala <talvala@stanford.edu>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
References: <Pine.LNX.4.64.1102151641490.16709@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102151641490.16709@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-02-2011 15:33, Guennadi Liakhovetski escreveu:
> Hi
> 
> This topic has been slightly discussed several times [1] before, but there 
> has been no conclusion, nor I'm aware of any implementation, suitably 
> resolving this problem. I've added to CC all involved in earlier 
> discussions, that I managed to find.
> 
> What seems a typical use-case to me is a system with a vewfinder or a 
> display, providing a live preview of the video data from a source, like a 
> camera, with a relatively low resolution, and a possibility to take 
> high-resolution still photos with a very short delay.
> 
> Currently this is pretty difficult to realise, e.g., with soc-camera 
> drivers you have to free the videobuf(2) queue, by either closing and 
> re-opening the interface, or by issuing an ioctl(VIDIOC_REQBUFS, 
> count=0) if your driver is already using videobuf2 and if this is really 
> working;), configure with a different resolution and re-allocate 
> videobuffers (or use different buffers, allocated per USERPTR). Another 
> possibility would be to allocate and use buffers large enough for still 
> photos, also for the preview, which would be wasteful, because one can 
> well need many more preview than still-shot buffers.
> 
> So, it seems to me, we could live with a better solution.
> 
> 1. We could use separate inputs for different capture modes and support 
> per-input videobuf queues. Advantage: no API changes required. 
> Disadvantages: confusing, especially, if a driver already exports multiple 
> inputs. The driver does not know, whether this mode is required or not, 
> always exporting 2 inputs for this purpose doesn't seem like a good idea. 
> Eventually, the user might want not 2, but 3 or more of such videobuf 
> queues.

Very bad. The high res is not a new input.
> 
> 2. Use different IO methods, e.g., mmap() for preview and read() for still 
> shots. I'm just mentioning this possibility here, because it occurred in 
> one of previous threads, but I don't really like it either. What if you 
> want to use the same IO method for all? Etc.

Can be done.
> 
> 3. Not liking either of the above, it seems we need yet a new API for 
> this... How about extending VIDIOC_REQBUFS with a videobuf queue index, 
> thus using up one of the remaining two 32-bit reserved fields? Then we 
> need one more ioctl() like VIDIOC_BUFQ_SELECT to switch from one queue to 
> another, after which setting frame format and queuing and dequeuing 
> buffers will affect this currently selected queue. We could also keep 
> REQBUFS as is and require BUFQ_SELECT to be called before it for any queue 
> except the default 0.
> 
> Yes, I know, that some video sensors have a double register set for this 
> dual-format operation, so, for them it is natural to support two queues, 
> and drivers are certainly most welcome to use this feature for, say, the 
> first two queues. On other sensors and for any further queues switching 
> will have to be done in software.

Seems too hacky to me. 

There's a 4th alternative: open the device twice, and use different settings
on each open. Userspace can stop streaming on one file descriptor and 
start the other one when he wants to take a high-res picture.

Cheers,
Mauro
