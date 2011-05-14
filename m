Return-path: <mchehab@gaivota>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1301 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab1ENLDH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2011 07:03:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Summary of the V4L2 discussions during LDS - was: Re: Embedded Linux memory management interest group list
Date: Sat, 14 May 2011 13:02:54 +0200
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Jesse Barker <jesse.barker@linaro.org>
References: <BANLkTimoKzWrAyCBM2B9oTEKstPJjpG_MA@mail.gmail.com> <4DCE5726.1030705@redhat.com>
In-Reply-To: <4DCE5726.1030705@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105141302.55100.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Saturday, May 14, 2011 12:19:18 Mauro Carvalho Chehab wrote:
> Em 18-04-2011 17:15, Jesse Barker escreveu:
> > One of the big issues we've been faced with at Linaro is around GPU
> > and multimedia device integration, in particular the memory management
> > requirements for supporting them on ARM.  This next cycle, we'll be
> > focusing on driving consensus around a unified memory management
> > solution for embedded systems that support multiple architectures and
> > SoCs.  This is listed as part of our working set of requirements for
> > the next six-month cycle (in spite of the URL, this is not being
> > treated as a graphics-specific topic - we also have participation from
> > multimedia and kernel working group folks):
> > 
> >   https://wiki.linaro.org/Cycles/1111/TechnicalTopics/Graphics
> 
> As part of the memory management needs, Linaro organized several discussions
> during Linaro Development Summit (LDS), at Budapest, and invited me and other
> members of the V4L and DRI community to discuss about the requirements.
> I wish to thank Linaro for its initiative.
> 
> Basically, on several SoC designs, the GPU and the CPU are integrated into
> the same chipset and they can share the same memory for a framebuffer. Also,
> they may have some IP blocks that allow processing the framebuffer internally,
> to do things like enhancing the image and converting it into an mpeg stream.
> 
> The desire, from the SoC developers, is that those operations should be
> done using zero-copy transfers.
> 
> This resembles somewhat the idea of the VIDIOC_OVERLAY/VIDIOC_FBUF API, 
> that was used in the old days where CPUs weren't fast enough to process
> video without generating a huge load on it. So the overlay mode were created
> to allow direct PCI2PCI transfers from the video capture board into the
> display adapter, using XVideo extension, and removing the overload at the
> CPU due to a video stream. It were designed as a Kernel API for it, and an
> userspace X11 driver, that passes a framebuffer reference to the V4L driver,
> where it is used to program the DMA transfers to happen inside the framebuffer.
> 
> At the LDS, we had a 3-day discussions about how the buffer sharing should
> be handled, and Linaro is producing a blueprint plan to address the needs.
> We had also a discussion about V4L and KMS, allowing both communities to better
> understand how things are supposed to work on the other side.
> 
> From V4L2 perspective, what is needed is to create a way to somehow allow
> passing a framebuffer between two V4L2 devices and between a V4L2 device
> and GPU. The V4L2 device can either be an input or an output one.
> The original idea were to add yet-another-mmap-mode at the VIDIOC streaming
> ioctls, and keep using QBUF/DQBUF to handle it. However, as I've pointed
> there, this would leed into sync issues on a shared buffer, causing flip
> effects. Also, as the API is generic, it can be used also on generic computers,
> like desktops, notebooks and tablets (even on arm-based designs), and it
> may end to be actually implemented as a PCI2PCI transfer.
> 
> So, based at all I've seen, I'm pretty much convinced that the normal MMAP
> way of streaming (VIDIOC_[REQBUF|STREAMON|STREAMOFF|QBUF|DQBUF ioctl's)
> are not the best way to share data with framebuffers.

I agree with that, but it is a different story between two V4L2 devices. There
you obviously want to use the streaming ioctls and still share buffers.

> We probably need
> something that it will be an enhanced version of the VIDIOC_FBUF/VIDIOC_OVERLAY
> ioctls. Unfortunately, we can't just add more stuff there, as there's no
> reserved space. So, we'll probably add some VIDIOC_FBUF2 series of ioctl's.

That will be useful as well to add better support for blending and Z-ordering
between overlays. The old API for that is very limited in that respect.

Regards,

	Hans

> It seems to me that the proper way to develop such API is to start working
> with Xorg V4L driver, changing it to work with KMS and with the new API
> (probably porting some parts of the Xorg driver to kernelspace).
> 
> One of the problems with a shared framebuffer is that an overlayed V4L stream
> may, at the worse case, be sent to up to 4 different GPU's and/or displays.
> 
> Imagine a scenario like:
> 
> 	===================+===================
> 	|                  |                  |
> 	|      D1     +----|---+     D2       |
> 	|             | V4L|   |              |
> 	+-------------|----+---|--------------|
> 	|             |    |   |              |
> 	|      D3     +----+---+     D4       |
> 	|                  |                  |
> 	=======================================
> 
> 
> Where D1, D2, D3 and D4 are 4 different displays, and the same V4L framebuffer is
> partially shared between them (the above is an example of a V4L input, although
> the reverse scenario of having one frame buffer divided into 4 V4L outputs
> also seems to be possible).
> 
> As the same image may be divided into 4 monitors, the buffer filling should be
> synced with all of them, in order to avoid flipping effects. Also, the shared
> buffer can't be re-used until all displays finish reading. From what I understood 
> from the discussions with DRI people, the display API's currently has similar issues
> of needing to wait for a buffer to be completely used before allowing it to be
> re-used. According to them, this were solved there by dynamically allocating buffers. 
> We may need to do something similar to that also at V4L.
> 
> Btw, the need of managing buffers is currently being covered by the proposal
> for new ioctl()s to support multi-sized video-buffers [1].
> 
> [1] http://www.spinics.net/lists/linux-media/msg30869.html
> 
> It makes sense to me to discuss such proposal together with the above discussions, 
> in order to keep the API consistent.
> 
> On my understanding, the SoC people that are driving those changes will
> be working on providing the API proposals for it. They should also be
> providing the needed patches, open source drivers and userspace application(s) 
> that allows testing and validating the GPU <==> V4L transfers using the newly API.
> 
> Thanks,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
