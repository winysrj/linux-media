Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:51006 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759459AbZKKX4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 18:56:16 -0500
Received: by fxm21 with SMTP id 21so1652516fxm.21
        for <linux-media@vger.kernel.org>; Wed, 11 Nov 2009 15:56:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3d7d5c150911031413i2a3c23a1j8cb136b721b75da1@mail.gmail.com>
References: <3d7d5c150911021621g72461dao1e66a654b574af5f@mail.gmail.com>
	 <Pine.LNX.4.64.0911032250060.5059@axis700.grange>
	 <3d7d5c150911031413i2a3c23a1j8cb136b721b75da1@mail.gmail.com>
Date: Wed, 11 Nov 2009 16:56:20 -0700
Message-ID: <3d7d5c150911111556h253099a4mbc5d65c7b796151d@mail.gmail.com>
Subject: Re: Capturing video and still images using one driver
From: Neil Johnson <realdealneil@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,

Your suggestions do work well, though my implementation is not ideal.
However, I am now able to switch between high res capture and low res
capture using S_FMT.  I made the switch to using user-ptr buffers in
user space, and now I allocate both large still image buffers and
smaller video buffers when my app starts.  Then, I switch from video
to still image capture (always using streaming, not read()), and then
switch back to video when needed.

Unfortunately, I'm not a huge expert at making my code fit the
video4linux model, so I've basically introduced some hacks that make
it work for me.  I'll try to get my hackish code up to spec so that it
will possibly be useful for others.

Neil

On Tue, Nov 3, 2009 at 3:13 PM, Neil Johnson <realdealneil@gmail.com> wrote:
>
>
> On Tue, Nov 3, 2009 at 3:02 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
>>
>> On Mon, 2 Nov 2009, Neil Johnson wrote:
>>
>> > video4linux-list,
>> >
>> > I am developing on the OMAP3 system using a micron/aptina mt9p031
>> > 5-megapixel imager.  This CMOs imager supports full image capture at 5
>> > fps
>> > (2592x1944 pixels) or you can capture subregions using skipping and
>> > binning.  We have proven both capabilities, but would like to be able to
>> > capture both VGA sized video and still images without using separate
>> > drivers.
>> >
>> > So far, I have not found any support for capturing large images and
>> > video
>> > through a single driver interface.  Does such a capability exist within
>> > v4l2?  One possible way to solve the problem is to allocate N buffers of
>> > the
>> > full 5-megapixel size (they end up being 10-MB for each buffer since I'm
>> > using 16-bits per pixel), and then using a small portion of that for
>> > video.
>> > These is less desirable since when I'm capturing video, I only need
>> > 640x480
>> > size buffers, and I should only need one snapshot buffer at a time (I'm
>> > not
>> > streaming them in, just take a snapshot and go back to live video
>> > capture).
>> > Is there a way to allocate a side-buffer for the 5-megapixel image and
>> > also
>> > allocate "normal" sized buffers for video within the same driver?  Any
>> > recommendations on how to accomplish such a thing?  I would think that
>> > camera-phones using linux would have run up against this.  Thanks,
>>
>> I came across the same problem when working on the rj54n1cb0c driver.
>> What's even more exciting with that sensor, is that it has separate
>> frame-size settings for preview (video) and still capture.
>
> I'm running into this as well.  The MT9P013 has different capture sizes for
> video preview (can be 720x480, 1280x720, etc), but the full image capture is
> 2592x1944.  The biggest problem is that the hardware I'm using (OMAP3530)
> has an image signal processing (isp) chain that needs to be properly
> configured for the input size and output size.  Right now, the isp gets
> initialized when the driver is opened, and then doesn't get touched until
> it's closed.  However, the isp needs to be reconfigured if the frame size
> changes.  This is getting to be a painful experience.
>
>
>>
>> So far the
>> driver doesn't have any support for those still image frame settings, but
>> I was thinking about implenting it using the read V4L method. I.e., you
>> would use the mmap method just normally to capture video and use read to
>> get still images?
>
> I've considered this, and maybe that's the right way to do it.  The buffer
> size for the read would have to be different than the mmap buffers...but
> maybe that's doable.  Does "read" use videobuf in most circumstances?  Is it
> possible to allocate multiple video buffer queues from a single driver?
>
>>
>> OTOH, with my driver I would need to differentiate
>> between S_FMT for video and still. Would we have to use different inputs
>> for them?
>
> Not sure...maybe that's the way to do it... right now my only option is to
> close the device, reopen it with different settings everytime I switch from
> video to still image.
>>
>> Thanks
>> Guennadi
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>> http://www.open-technology.de/
>
>
> Thanks for the feedback.  Hopefully this will be a good learning experience
> :)
>
>
> --
