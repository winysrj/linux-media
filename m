Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:49882 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1BPHnC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 02:43:02 -0500
Date: Wed, 16 Feb 2011 08:42:51 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Qing Xu <qingx@marvell.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Johnson <realdealneil@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Uwe Taeubert <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Eino-Ville Talvala <talvala@stanford.edu>
Subject: RE: [RFD] frame-size switching: preview / single-shot use-case
In-Reply-To: <7BAC95F5A7E67643AAFB2C31BEE662D014042CB8F0@SC-VEXCH2.marvell.com>
Message-ID: <Pine.LNX.4.64.1102160829490.20711@axis700.grange>
References: <Pine.LNX.4.64.1102151641490.16709@axis700.grange>
 <7BAC95F5A7E67643AAFB2C31BEE662D014042CB8F0@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Tue, 15 Feb 2011, Qing Xu wrote:

Please, don't top-post and use a proper quoting.

> Hi,
> 
> I have a question that why we must check "icf->vb_vidq.bufs[0]" in
> s_fmt_vid_cap()? The application mainly calling sequence at switching
> fmt could be like this:
> streamoff
> s_fmt_vid_cap
> request_buf
> qbuf...qbuf
> streamon
> qbuf/dqbuf
> ...
> The application should also aware that they are switching the fmt,
> so they should release their buffer(per in usrptr method), and re-call
> request-buf/qbuf, so based on this assumption, how about we check "bufs[0]"
> in request_buf or qbuf according to the new fmt, if we find the buffer
> size is not correct, then indicate error in request_buf or qbuf.
> However,in s_fmt_vid_cap,
> we only need to check whether streaming is on/off, if it is still on,
> that means HW resource is not available or IO/buffer is in progress, then
> we reject s_fmt. What do you think?

Yes, that restriction is in a way more conservative, than it needs to be. 
I did that to (a) simplify the design and implementation: that way you 
don't have to worry about S_FMT calls in your drivers during a running 
capture, and to (b) verify whether that can be a problem for anyone and to 
hear from them;)

> For the idea 3, (what is the difference between idea 1 and 3?)

(1) proposes to add multiple inputs to the video device, selectable per 
VIDIOC_S_INPUT, (3) doesn't touch inputs and only proposes to add multiple 
videobuf queues to devices, adding a special ioctl().

> in our real usage cases of camera(our product is a phone),
> we will set many formats, such as:
> preview@VGA, photos@5M/3M/QVGA/QCIF..., video@1080p/720p/VGA/QVGA, if we
> maintain each queue for each fmt, it seems that there are too many queues,
> and, in this way, the application need to be changed, it should quite 
> aware of VIDIOC_BUFQ_SELECT queue-id for each fmt, then it could 
> allocate/release
> the required buffer queue by new ioctl. Is my understanding correct?

Of course, with case (3) from my original post, if you want to use those 
multiple queues, you _have_ to modify your application. Same holds for (1) 
and (2) too. As for too many queues - well, you can decide then. Maybe you 
don't need a separate queue for each format, maybe you could use one queue 
for several still-shot queues with similar buffer sizes and buffer 
numbers. Or you don't need them all simultaneously, depending on your 
use-case. If you have an interface, where the user only switches between 
preview and still images, the still image format is usually fixed. To 
select a different format the user has to go to some kind of a 
configuration menu and select a different image format, right? Which would 
be a good time to release the previous still image queue and allocate a 
new one.

Thanks
Guennadi

> 
> Thanks!
> -Qing
> 
> -----Original Message-----
> From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> Sent: 2011Äê2ÔÂ16ÈÕ 1:34
> To: Linux Media Mailing List
> Cc: Qing Xu; Hans Verkuil; Neil Johnson; Robert Jarzmik; Uwe Taeubert; Karicheri, Muralidharan; Eino-Ville Talvala
> Subject: [RFD] frame-size switching: preview / single-shot use-case
> 
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
> 
> 2. Use different IO methods, e.g., mmap() for preview and read() for still
> shots. I'm just mentioning this possibility here, because it occurred in
> one of previous threads, but I don't really like it either. What if you
> want to use the same IO method for all? Etc.
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
> 
> Ideas? Comments?
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
