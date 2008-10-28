Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9SFTewF022065
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 11:29:40 -0400
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9SFSQji026106
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 11:28:27 -0400
Date: Tue, 28 Oct 2008 10:28:25 -0500
From: Matt Porter <mporter@kernel.crashing.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20081028152825.GA25654@gate.crashing.org>
References: <20081027211837.GA20197@gate.crashing.org>
	<200810272259.43058.hverkuil@xs4all.nl>
	<20081028020021.GA3684@gate.crashing.org>
	<200810280820.03931.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810280820.03931.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
Subject: Re: output overlay driver and pix format
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Tue, Oct 28, 2008 at 08:20:03AM +0100, Hans Verkuil wrote:
> On Tuesday 28 October 2008 03:00:21 Matt Porter wrote:
> > Ok. I guess it does make sense. I've been used to think in terms of
> > real-world outputs on previous driver work so that's where the
> > confusion set in. I can define an output that is the internal target
> > buffer as you suggest. Since it requires the standards ioctls it
> > seems I'll have to define a driver specific standard id for a "system
> > buffer". Perhaps that should be generic...
> 
> If there are a fixed number of possible target buffers, then you can 
> associate each output with each buffer. But without knowing the precise 
> architecture it's hard for me to comment on this.
 
Ok, the hardware can only be programmed with a fixed target buffer. It
seems the best mapping is to have multiple outputs depending on the
functionality of the target buffer. The normal case is that the output
target buffer is the source for the LCD h/w interface.

<snip>

> > > In this case I don't think it makes sense. But as I said, I think
> > > adding an OUTPUT capability is not a problem.
> >
> > Yes, seems reasonable to me now. There's one other thing this brings
> > up. Since my hardware can handle 5 different pixelformats as input
> > I'll obviously S_FMT those on the OUTPUT device. However, it is
> > possible to configure hardware such that the processed results in the
> > target buffer are in 4 different pixel formats. Within V4L, it seems
> > that the way to handle this would be to have 4 different custom
> > (driver specific) standards that correspond to the 4 possible pixel
> > formats. Does that sound right?
> 
> That seems to be the only way to do this at the moment. Is the target 
> buffer's pixel format in any way related to the pixel format of the 
> framebuffer? Or are they independent?

They are completely independent with regards to the hardware capabilities.
However, the normal usage case would be to set the target (output) buffer
configuration the same as the framebuffer.

Specifically, here's what it can do:

On the video input side it handles YUV420, YUV422P, RGB24, RGB555, RGB565
The framebuffer input handles ARGB32, RGB32, ARGB1555, RGB555, RGB565
Target (output) buffer may be ARGB32, RGB32, RGB24, ARGB1555, RGB555, RGB565

So we could feed it YUV420 video, overlay an RGB565 FB, and output RGB555
if desired. I could simply force the output buffer to be the same as
the framebuffer configuration which will probably be the usual usage
model.

> It feels rather like a hack to abuse S_STD for this. Can you tell a bit 
> more about the sort of formats this device can handle? Is it limited to 
> PAL/NTSC type images only or can it be different sizes as well? I'm 
> planning on adding a new ioctl to support HDTV and it sounds like this 
> is something that new ioctl might support as well.

It does feel like a hack for S_STD. It can output more than PAL/NTSC compatible
images. It can also drive an LCD interface with popular progressive formats
like 800x480, 480x272, etc. Since it can crop and scale, the output size
doesn't need to be the same as the framebuffer size. The end result is that
the output isn't necessarily in the form of something that conforms to
the definition of analog standards. I'm not sure handling arbitrary LCD formats
is appropriate for the HDTV ioctl, but maybe another interface could handle
this type of output. Do you have a pointer to some spec for this new ioctl?
I'm not sure if I missed it on the list before.

Thanks,
Matt

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
