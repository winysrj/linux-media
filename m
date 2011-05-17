Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48356 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab1EQHCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 03:02:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linaro-mm-sig@lists.linaro.org
Subject: Re: [Linaro-mm-sig] Video4Linux API for shared buffers
Date: Tue, 17 May 2011 09:03:47 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <4DCE4935.2050205@infradead.org>
In-Reply-To: <4DCE4935.2050205@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105170903.47943.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

CC'ing linux-media, as the topic is of interest for the V4L2 developers.

On Saturday 14 May 2011 11:19:49 Mauro Carvalho Chehab wrote:
> After the mm panels, I had a few discussions with Hans, Rob and Daniel,
> among others, during the V4L and KMS discussions and after that. Based
> on those discussions, I'm pretty much convinced that the normal MMAP
> way of streaming (VIDIOC_[REQBUF|STREAMON|STREAMOFF|QBUF|DQBUF ioctl's)
> are not the best way to share data with framebuffers. We probably need
> something that it is close to VIDIOC_FBUF/VIDIOC_OVERLAY, but it is
> still not the same thing.

Why do you think so ? Can you explain what serious limitations you see in the 
current buffer-based API that would prevent sharing data with frame buffers 
(I'm talking about both fbdev and KMS) ?

> I suspect that working on such API is somewhat orthogonal to the decision
> of using a file pointer based or a bufer ID based based kABI for passing
> the buffer parameters to the newly V4L calls,

Userspace won't pass a file pointer to the kernel, it will pass a file 
descriptor number.

> but we cannot decide about the type of buffer ID that we'll use if we not
> finish working at an initial RFC for the V4L API, as the way the buffers
> will be passed into it will depend on how we design such API.

Shouldn't it be the other way around ? On the kernel side the dma buffer API 
will offer a function that converts a buffer ID, whatever it is, to a dma 
buffer structure pointer, so I don't think it matters much for drivers.

> It should be also noticed that, while in the shared buffers some
> definitions can be postponed to happen later (as it is basically
> a Kernelspace-only ABI - at least initially), the V4L API should be
> designed to consider all possible scenarios, as "diamonds and userspace
> API's are forever"(tm).
> 
> It seems to me that the proper way to develop such API is starting working
> with Xorg V4L driver, changing it to work with KMS and with the new API
> (probably porting some parts of it to kernelspace).

I'm not sure to follow you here. Please remember that X is not a requirement, 
we definitely want to share buffers between fbdev and V4L2 in X-less systems.

> One of the problems with a shared framebuffer is that an overlayed V4L
> stream may, at the worse case, be sent to up to 4 different GPU's and/or
> displays, like:
> 
> 	===================+===================
> 
> 	|      D1     +----|---+     D2       |
> 	|      
> 	|             | V4L|   |              |
> 
> 	+-------------|----+---|--------------|
> 
> 	|      D3     +----+---+     D4       |
> 
> 	=======================================
> 
> 
> Where D1, D2, D3 and D4 are 4 different displays, and the same V4L
> framebuffer is partially shared between them (the above is an example of a
> V4L input, although the reverse scenario of having one frame buffer
> divided into 4 V4L outputs also seems to be possible).
> 
> As the same image may be divided into 4 monitors, the buffer filling should
> be synced with all of them, in order to avoid flipping effects. Also, the
> buffer can't be re-used until all displays finish reading.
> 
> Display API's currently has similar issues.  From what I understood from
> Rob and Daniel, this is solved there by dynamically allocating buffers.
> So, we may need to do something similar to that also at V4L (in a matter
> of fact, there's currently a proposal to hack REQBUF's, in order to extend
> V4L API to allow dynamically creating more buffers than used by a stream).
> It makes sense to me to discuss such proposal together with the above
> discussions, in order to keep the API consistent.
> 
> From my side, I'm expecting that the responsible(s) for the API proposals
> to also provide with open source drivers and userspace application(s),
> that allows to test and validate such API RFC.

-- 
Regards,

Laurent Pinchart
