Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2473 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1EOVKn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 May 2011 17:10:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Summary of the V4L2 discussions during LDS - was: Re: Embedded Linux memory management interest group list
Date: Sun, 15 May 2011 23:10:31 +0200
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Jesse Barker <jesse.barker@linaro.org>
References: <BANLkTimoKzWrAyCBM2B9oTEKstPJjpG_MA@mail.gmail.com> <201105141302.55100.hverkuil@xs4all.nl> <4DCE6B7B.1080907@redhat.com>
In-Reply-To: <4DCE6B7B.1080907@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105152310.31678.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, May 14, 2011 13:46:03 Mauro Carvalho Chehab wrote:
> Em 14-05-2011 13:02, Hans Verkuil escreveu:
> > On Saturday, May 14, 2011 12:19:18 Mauro Carvalho Chehab wrote:
> 
> >> So, based at all I've seen, I'm pretty much convinced that the normal MMAP
> >> way of streaming (VIDIOC_[REQBUF|STREAMON|STREAMOFF|QBUF|DQBUF ioctl's)
> >> are not the best way to share data with framebuffers.
> > 
> > I agree with that, but it is a different story between two V4L2 devices. There
> > you obviously want to use the streaming ioctls and still share buffers.
> 
> I don't think so. the requirement for syncing the framebuffer between the two
> V4L2 devices is pretty much the same as we have with one V4L2 device and one GPU.
> 
> On both cases, the requirement is to pass a framebuffer between two entities, 
> and not a video stream.
> 
> For example, imagine something like:
> 
> 	V4L2 camera =====> V4L2 encoder t MPEG2
> 		     ||
> 		     LL==> GPU
> 
> Both GPU and the V4L2 encoder should use the same logic to be sure that they will
> use a buffer that were filled already by the camera. Also, the V4L2 camera
> driver can't re-use such framebuffer before being sure that both consumers 
> has already stopped using it.

No. A camera whose output is sent to a resizer and then to a SW/FW/HW encoder
is a typical example where you want to queue/dequeue buffers. Especially since
the various parts of the pipeline may stall for a bit so you don't want to lose
frames. That's not what the overlay API is for, that's what our streaming API
gives us.

The use case above isn't even possible without copying. At least, I don't see a
way, unless the GPU buffer is non-destructive. In that case you can give the
frame to the GPU, and when the GPU is finished you can give it to the encoder.
I suspect that might become quite complex though.

Note that many video receivers cannot stall. You can't tell them to wait until
the last buffer finished processing. This is different from some/most? sensors.

So if you try to send the input of a video receiver to some device that requires
syncing which can cause stalls, then that will not work without losing frames.
Which especially for video encoding is not desirable.

Of course, it might be that we mean the same, but just use different words :-(

Regards,

	Hans

> 
> So, it is the same requirement as having four displays receiving such framebuffer.
> 
> Of course, a GPU endpoint may require some extra information for the blending,
> but also a V4L node may require some other type of extra information.
> 
> >> We probably need
> >> something that it will be an enhanced version of the VIDIOC_FBUF/VIDIOC_OVERLAY
> >> ioctls. Unfortunately, we can't just add more stuff there, as there's no
> >> reserved space. So, we'll probably add some VIDIOC_FBUF2 series of ioctl's.
> > 
> > That will be useful as well to add better support for blending and Z-ordering
> > between overlays. The old API for that is very limited in that respect.
> 
> Agreed.
> 
> Mauro.
> 
