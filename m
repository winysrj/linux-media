Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48734 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1EOXo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 May 2011 19:44:27 -0400
Received: by bwz15 with SMTP id 15so3313893bwz.19
        for <linux-media@vger.kernel.org>; Sun, 15 May 2011 16:44:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110515222727.75b05a0c@lxorguk.ukuu.org.uk>
References: <BANLkTimoKzWrAyCBM2B9oTEKstPJjpG_MA@mail.gmail.com>
	<201105141302.55100.hverkuil@xs4all.nl>
	<4DCE6B7B.1080907@redhat.com>
	<201105152310.31678.hverkuil@xs4all.nl>
	<20110515222727.75b05a0c@lxorguk.ukuu.org.uk>
Date: Sun, 15 May 2011 18:44:26 -0500
Message-ID: <BANLkTi=GYeLSXEYY8OoH005c_s1XugsVbA@mail.gmail.com>
Subject: Re: Summary of the V4L2 discussions during LDS - was: Re: Embedded
 Linux memory management interest group list
From: Rob Clark <robdclark@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, May 15, 2011 at 4:27 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > On both cases, the requirement is to pass a framebuffer between two entities,
>> > and not a video stream.
>
> It may not even be a framebuffer. In many cases you'll pass a framebuffer
> or some memory target (in DRI think probably a GEM handle), in fact in
> theory you can do much of this now.
>
>> > use a buffer that were filled already by the camera. Also, the V4L2 camera
>> > driver can't re-use such framebuffer before being sure that both consumers
>> > has already stopped using it.
>
> You also potentially need fences which complicates the interface
> somewhat.

Presumable this is going through something like DRI2, so the client
application, which is what is interacting w/ V4L2 interface for camera
and perhaps video encoder, would call something that turns into a
ScheduleSwap() call on xserver side, returning a frame count to wait
for, and then at some point later ScheduleWaitMSC() to wait for that
frame count to know the GPU is done with the buffer.  The fences would
be buried somewhere within DRM (kernel) and xserver driver (userspace)
to keep the client app blocked until GPU is done.

You probably don't want the V4L2 devices to be too deeply connected to
how the GPU does synchronization, or otherwise V4L2 would need to
support each different DRM+xserver driver and how it implements buffer
synchronization with the GPU..

BR,
-R

>> The use case above isn't even possible without copying. At least, I don't see a
>> way, unless the GPU buffer is non-destructive. In that case you can give the
>> frame to the GPU, and when the GPU is finished you can give it to the encoder.
>> I suspect that might become quite complex though.
>
> It's actually no different to giving a buffer to the GPU some of the time
> and the CPU other bits. In those cases you often need to ensure private
> ownership each side and do fencing/cache flushing as needed.
>
>> Note that many video receivers cannot stall. You can't tell them to wait until
>> the last buffer finished processing. This is different from some/most? sensors.
>
> A lot of video receivers also keep the bits away from the CPU as part of
> the general DRM delusion TV operators work under. That means you've got
> an object that has a handle, has operations (alpha, fade, scale, etc) but
> you can never touch the bits. In the TV/Video world not unsurprisingly
> that is often seen as the 'primary' frame buffer as well. You've got a
> set of mappable framebuffers the CPU can touch plus other video sources
> that can be mixed and placed but the CPU can only touch the mappable
> objects that form part of the picture.
>
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
