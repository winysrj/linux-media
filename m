Return-path: <mchehab@pedra>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57039 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751166Ab1EOV0E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 May 2011 17:26:04 -0400
Date: Sun, 15 May 2011 22:27:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: Summary of the V4L2 discussions during LDS - was: Re: Embedded
 Linux memory management interest group list
Message-ID: <20110515222727.75b05a0c@lxorguk.ukuu.org.uk>
In-Reply-To: <201105152310.31678.hverkuil@xs4all.nl>
References: <BANLkTimoKzWrAyCBM2B9oTEKstPJjpG_MA@mail.gmail.com>
	<201105141302.55100.hverkuil@xs4all.nl>
	<4DCE6B7B.1080907@redhat.com>
	<201105152310.31678.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> > On both cases, the requirement is to pass a framebuffer between two entities, 
> > and not a video stream.

It may not even be a framebuffer. In many cases you'll pass a framebuffer
or some memory target (in DRI think probably a GEM handle), in fact in
theory you can do much of this now.

> > use a buffer that were filled already by the camera. Also, the V4L2 camera
> > driver can't re-use such framebuffer before being sure that both consumers 
> > has already stopped using it.

You also potentially need fences which complicates the interface
somewhat.

> The use case above isn't even possible without copying. At least, I don't see a
> way, unless the GPU buffer is non-destructive. In that case you can give the
> frame to the GPU, and when the GPU is finished you can give it to the encoder.
> I suspect that might become quite complex though.

It's actually no different to giving a buffer to the GPU some of the time
and the CPU other bits. In those cases you often need to ensure private
ownership each side and do fencing/cache flushing as needed.

> Note that many video receivers cannot stall. You can't tell them to wait until
> the last buffer finished processing. This is different from some/most? sensors.

A lot of video receivers also keep the bits away from the CPU as part of
the general DRM delusion TV operators work under. That means you've got
an object that has a handle, has operations (alpha, fade, scale, etc) but
you can never touch the bits. In the TV/Video world not unsurprisingly
that is often seen as the 'primary' frame buffer as well. You've got a
set of mappable framebuffers the CPU can touch plus other video sources
that can be mixed and placed but the CPU can only touch the mappable
objects that form part of the picture.

Alan
