Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:28497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981Ab1ENLqK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2011 07:46:10 -0400
Message-ID: <4DCE6B7B.1080907@redhat.com>
Date: Sat, 14 May 2011 13:46:03 +0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Jesse Barker <jesse.barker@linaro.org>
Subject: Re: Summary of the V4L2 discussions during LDS - was: Re: Embedded
 Linux memory management interest group list
References: <BANLkTimoKzWrAyCBM2B9oTEKstPJjpG_MA@mail.gmail.com> <4DCE5726.1030705@redhat.com> <201105141302.55100.hverkuil@xs4all.nl>
In-Reply-To: <201105141302.55100.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 14-05-2011 13:02, Hans Verkuil escreveu:
> On Saturday, May 14, 2011 12:19:18 Mauro Carvalho Chehab wrote:

>> So, based at all I've seen, I'm pretty much convinced that the normal MMAP
>> way of streaming (VIDIOC_[REQBUF|STREAMON|STREAMOFF|QBUF|DQBUF ioctl's)
>> are not the best way to share data with framebuffers.
> 
> I agree with that, but it is a different story between two V4L2 devices. There
> you obviously want to use the streaming ioctls and still share buffers.

I don't think so. the requirement for syncing the framebuffer between the two
V4L2 devices is pretty much the same as we have with one V4L2 device and one GPU.

On both cases, the requirement is to pass a framebuffer between two entities, 
and not a video stream.

For example, imagine something like:

	V4L2 camera =====> V4L2 encoder t MPEG2
		     ||
		     LL==> GPU

Both GPU and the V4L2 encoder should use the same logic to be sure that they will
use a buffer that were filled already by the camera. Also, the V4L2 camera
driver can't re-use such framebuffer before being sure that both consumers 
has already stopped using it.

So, it is the same requirement as having four displays receiving such framebuffer.

Of course, a GPU endpoint may require some extra information for the blending,
but also a V4L node may require some other type of extra information.

>> We probably need
>> something that it will be an enhanced version of the VIDIOC_FBUF/VIDIOC_OVERLAY
>> ioctls. Unfortunately, we can't just add more stuff there, as there's no
>> reserved space. So, we'll probably add some VIDIOC_FBUF2 series of ioctl's.
> 
> That will be useful as well to add better support for blending and Z-ordering
> between overlays. The old API for that is very limited in that respect.

Agreed.

Mauro.
