Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f170.google.com ([209.85.210.170]:57703 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758741Ab3DINFi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 09:05:38 -0400
Received: by mail-ia0-f170.google.com with SMTP id j38so2152199iad.15
        for <linux-media@vger.kernel.org>; Tue, 09 Apr 2013 06:05:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201304091211.30037.hverkuil@xs4all.nl>
References: <CAFW1BFxJ-fe8N-=LSKUfRP=-R+XUY_it3miEUKKJ6twkZa1wZA@mail.gmail.com>
	<201304091109.11846.hverkuil@xs4all.nl>
	<CAFW1BFxuYJeJ5ZR0yapk9L58eZ7i4jgji=02kMcKyyQAAONQUw@mail.gmail.com>
	<201304091211.30037.hverkuil@xs4all.nl>
Date: Tue, 9 Apr 2013 15:05:37 +0200
Message-ID: <CAFW1BFxU8EkHCfgBEgQk=aNpJu0fgbqSmyXkUB8bA-Ahkbn2TQ@mail.gmail.com>
Subject: Re: vivi kernel driver
From: Michal Lazo <michal.lazo@mdragon.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

And can you explain where is problem with memcpy in kernel?
is it really that big problem to copy 720*576*3 bytes from kernel
space to user space ?
what all usb camera drivers do ? some dma access directly to destination buffer?


On Tue, Apr 9, 2013 at 12:11 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tue 9 April 2013 11:57:51 Michal Lazo wrote:
>> Amlogic provide only 2.6.34 driver
>> can I expect big performance loss ?
>
> Why do so many companies stick to ancient kernels? I can never understand that.
>
> You have three options:
>
> 1) update their driver to a recent kernel
> 2) create a v4l2 driver for 2.6.34. But in that case you can't use the videobuf2
>    framework which appeared in a later kernel and which greatly simplifies the
>    work of writing a v4l2 driver.
> 3) it's possible to backport the whole of drivers/media to a 2.6.34 kernel. It
>    will generate a huge patch (>30 MB), but you will have a modern V4L2 kernel
>    environment.
>
> Note that none of this matters for performance. I would pick either option 1 or 3.
>
> Instructions on how to do option 3 are:
>
> 1) Clone this git repo: http://git.linuxtv.org/hverkuil/cisco_build.git
> 2) Switch to the cobalt-mainline branch.
> 3) Edit patch-kernel.sh and modify the 'target', 'orig_source' and 'source'
>    paths.
> 4) Run patch-kernel.sh
>
> The resulting media.patch file should apply cleanly to your source kernel.
> Note that the source kernel should be your vendor supplied kernel without
> any of your own patches that you might normally apply on top of it.
>
> Regards,
>
>         Hans
>
>>
>> On Tue, Apr 9, 2013 at 11:09 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> > On Tue 9 April 2013 10:52:41 Michal Lazo wrote:
>> >> As we have all source codes
>> >> what do you advice ?
>> >
>> > Write your own driver. Good templates to look at are drivers/media/pci/sta2x11
>> > and drivers/media/platform/blackfin.
>> >
>> > The first is functionality-wise probably closer to what you need, but it's a pci
>> > driver, so the blackfin platform driver can be used to look at the platform part.
>> >
>> > Pick as recent a kernel as you can, but 3.6 at minimum since it has the useful
>> > vb2 helper functions that the sta2x11 driver also uses.
>> >
>> > Regards,
>> >
>> >         Hans
>> >
>> >>
>> >>
>> >> On Tue, Apr 9, 2013 at 10:38 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> >> > On Tue 9 April 2013 09:58:33 Michal Lazo wrote:
>> >> >> I want to make API that will provide hw video decoder on Amlogic SOC
>> >> >> it is ARM cortex 9
>> >> >>
>> >> >> with some proprietary video decoder
>> >> >>
>> >> >> amlogic provide me with working example that generate output frames in
>> >> >> amlvideo driver.
>> >> >> It is v4l2 driver
>> >> >> and it did memcpy to mmap userspace memory
>> >> >>
>> >> >>     buffer_y_start=ioremap(cs0.addr,cs0.width*cs0.height);
>> >> >>     for(i=0;i<buf->vb.height;i++) {
>> >> >>               memcpy(vbuf + pos_dst, buffer_y_start+pos_src, buf->vb.width*3);
>> >> >>               pos_dst+=buf->vb.width*3;
>> >> >>               pos_src+= cs0.width;
>> >> >>       }
>> >> >>
>> >> >> I did it with one memcpy with same cpu load
>> >> >>
>> >> >> https://github.com/Pivosgroup/buildroot-linux-kernel/blob/master/drivers/media/video/amlvideo/amlvideo.c#L218
>> >> >>
>> >> >> top get me 50% cpu load on this driver for 25fps PAL
>> >> >>
>> >> >> it is really too much
>> >> >>
>> >> >> and funny is that vivi driver(amlvideo is completely base on vivi) get
>> >> >> me same cpu load
>> >> >
>> >> > Well, yes, because it is the memcpy that gives you all the load.
>> >> > Of course, in a well-written driver the amlvideo buffers would be available
>> >> > to userspace directly using mmap() and no memcpy would be needed.
>> >> >
>> >> > Basically amlogic gave you a crappy driver.
>> >> >
>> >> > Regards,
>> >> >
>> >> >         Hans
>> >> >
>> >> >>
>> >> >> it looks like memcpy isn't cached or something but I don't know how to
>> >> >> identify problem
>> >> >> Any idea how to identify this problem.
>> >> >>
>> >> >> On Mon, Apr 8, 2013 at 2:46 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> >> >> > On Mon April 8 2013 14:42:32 Michal Lazo wrote:
>> >> >> >> Hi
>> >> >> >> 720x576 RGB 25, 30 fps and it take
>> >> >> >>
>> >> >> >> 25% cpu load on raspberry pi(ARM 700Mhz linux 3.6.11) or 8% on x86(AMD
>> >> >> >> 2GHz linux 3.2.0-39)
>> >> >> >>
>> >> >> >> it is simply too much
>> >> >> >
>> >> >> > No, that's what I would expect. Note that vivi was substantially improved recently
>> >> >> > when it comes to the image generation. That will be in the upcoming 3.9 kernel.
>> >> >> >
>> >> >> > This should reduce CPU load by quite a bit if memory serves.
>> >> >> >
>> >> >> > Regards,
>> >> >> >
>> >> >> >         Hans
>> >> >> >
>> >> >> >>
>> >> >> >>
>> >> >> >>
>> >> >> >>
>> >> >> >> On Mon, Apr 8, 2013 at 9:42 AM, Peter Senna Tschudin
>> >> >> >> <peter.senna@gmail.com> wrote:
>> >> >> >> > Dear Michal,
>> >> >> >> >
>> >> >> >> > The CPU intensive part of the vivi driver is the image generation.
>> >> >> >> > This is not an issue for real drivers.
>> >> >> >> >
>> >> >> >> > Regards,
>> >> >> >> >
>> >> >> >> > Peter
>> >> >> >> >
>> >> >> >> > On Sun, Apr 7, 2013 at 9:32 PM, Michal Lazo <michal.lazo@mdragon.org> wrote:
>> >> >> >> >> Hi
>> >> >> >> >> V4L2 driver vivi
>> >> >> >> >> generate 25% cpu load on raspberry pi(linux 3.6.11) or 8% on x86(linux 3.2.0-39)
>> >> >> >> >>
>> >> >> >> >> player
>> >> >> >> >> GST_DEBUG="*:3,v4l2src:3,v4l2:3" gst-launch-0.10 v4l2src
>> >> >> >> >> device="/dev/video0" norm=255 ! video/x-raw-rgb, width=720,
>> >> >> >> >> height=576, framerate=30000/1001 ! fakesink sync=false
>> >> >> >> >>
>> >> >> >> >> Anybody can answer me why?
>> >> >> >> >> And how can I do it better ?
>> >> >> >> >>
>> >> >> >> >> I use vivi as base example for my driver
>> >> >> >> >> --
>> >> >> >> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> >> >> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> >> >> >
>> >> >> >> >
>> >> >> >> >
>> >> >> >> > --
>> >> >> >> > Peter
>> >> >> >>
>> >> >> >>
>> >> >> >>
>> >> >> >>
>> >> >>
>> >> >>
>> >> >>
>> >> >>
>> >>
>> >>
>> >>
>> >>
>>
>>
>>
>>



-- 
Best Regards

Michal Lazo
Senior developer manager
mdragon.org
Slovakia
