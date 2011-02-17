Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:59582 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab1BQTEt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 14:04:49 -0500
Message-ID: <4D5D7141.4030101@infradead.org>
Date: Thu, 17 Feb 2011 17:04:33 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hansverk@cisco.com>, Qing Xu <qingx@marvell.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Neil Johnson <realdealneil@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Uwe Taeubert <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Eino-Ville Talvala <talvala@stanford.edu>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
References: <Pine.LNX.4.64.1102151641490.16709@axis700.grange> <201102160949.04605.hansverk@cisco.com> <Pine.LNX.4.64.1102160954560.20711@axis700.grange> <201102161011.59830.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1102161033440.20711@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102161033440.20711@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 16-02-2011 08:35, Guennadi Liakhovetski escreveu:
>>>> But from the point of view of the application it makes more sense to
>>>> actually have two video nodes. The only difference is that when one
>>>> starts streaming it pre-empts the other.
>>>
>>> Well, I don't think I like it all that much... One reason - yes, two
>>> "independent" video device-nodes, which actually only can stream in turn
>>> seems somewhat counterintuitive to me, specifically, I don't think there
>>> is a way to tell the application about this. What if we have more than two
>>> video devices on the system? Or what if you need more than two video
>>> queues / formats? Or actually only one? The kernel doesn't know initially
>>> how many, this is a dynamic resource, not a fixed static interface, IMHO.
>>
>> I agree with this, which is why I don't think two (or more) video nodes would 
>> be a good solution.

I agree. Video nodes shouldn't be bind to an specific format. A device with 2
video nodes should be able to retrieve images from two independent video sources.

Unfortunately, ivtv driver was merged with the bad concept of one video node per
different type of formats (partially my fault: I remember I commented about it at 
the time it was submitted, but, as its merge took a long time, and there were 
several other issues that were needed to be solved there, I ended by giving up 
and letting it to come with this API non-compliance, hoping that a fix would
happen at the next kernel release. Unfortunately, it was never fixed).

>> We've hit the exact same issue with the OMAP3 ISP driver. Our current solution 
>> is to allocate video buffer queues at the file handle level instead of the 
>> video node level. Applications can open the same video device twice and 
>> allocate buffers for the viewfinder on one of the instances and for still 
>> image capture on the other. When switching from viewfinder to still image 
>> capture, all it needs to do (beside obviously reconfiguring the media 
>> controller pipeline if required) is to issue VIDIOC_STREAMOFF on the 
>> viewfinder file handle and VIDIOC_STREAMON on the still capture file handle.

This seems to be the proper way. solution (2) of using read()/mmap() is just
an special case of per-file handle stream control, as applications that used 
this approach in the past were, in fact, using two opens, one for read, and 
another for mmap (to be clear, I'm not in favor of 2, I'm just saying that
a per-file handle solution will allow (2) also).

>> One issue with this approach is that allocating buffers requires knowledge of 
>> the format and resolution. The driver traditionally computes the buffer size 
>> from the parameters set by VIDIOC_S_FMT. This would prevent an application 
>> opening the video node a second time and setting up buffers for still image 
>> capture a second time while the viewfinder is running, as the VIDIOC_S_FMT on 
>> the second file handle won't be allowed then.
>>
>> Changes to the V4L2 spec would be needed to allow this to work properly.
> 
> The spec is actually saying about the S_FMT ioctl():
> 
> "On success the driver may program the hardware, allocate resources and 
> generally prepare for data exchange."
> 
> - _may_ program the hardware. So, if we don't do that and instead only 
> verify the format and store it for future activation upon a call to 
> STREAMON we are not violating the spec, thus, no change is required. OTOH, 
> another spec sections "V4L2 close()" says:
> 
> "data format parameters, current input or output, control values or other 
> properties remain unchanged."
> 
> which is usually interpreted as "a sequence open(); ioctl(S_FMT); close(); 
> open(); ioctl(STREAMON);" _must_ use the format, set by the call to S_FMT, 
> which is not necessarily logical, if we adopt the per-file-descriptor 
> format / stream approach.

Every time a "may" appears on a spec, we'll have troubles, as some drivers
will follow the "may" and others won't follow. Changing the behaviour will 
likely cause regressions, whatever direction is taken.

One alternative would be to have a better way to negotiate features than what's
provided by QUERYCAP. If we look for some protocols with a long life, like telnet, 
they don't have a one-way to check/set capabilities. Instead, both parties should
present their capabilities and the client need to negotiate what he wants.

We could do something like:

	ret = ioctl(fd, VIDIOC_QUERYCAP, &cap);
	if  (cap.capabilities & CAN_PER_FD_FMT) {
		setcap.capabilities |= SHOULD_PER_FD_FMT;
		ret = ioctl(fd, VIDIOC_SETCAP, &setcap);
	}

To be sure that the kernel driver will behave fine. Yet, in this particular case,
this would mean that drivers or core will need to handle both per-fd and per-node
S_FMT & friends.


> I think, we have two options:
> 
> (1) adopt Laurent's proposal of per-fd contexts, but that would require a 
> pretty heave modification of the spec - S_FMT is not kept across close() / 
> open() pair.

Whatever done, we'll need to change the specs in a lot of places.

> (2) cleanly separate setting video data format (S_FMT) from specifying the 
> allocated buffer size.

This would break existing applications. Too late for that, except if negotiated
with a "SETCAP" like approach.

There's an additional problem with that: assume that streaming is happening,
and a S_FMT changing the resolution was sent. There's no way to warrant that
the very next frame will have the new resolution. So, a meta-data with the
frame resolution (and format) would be needed.

> Of course, there are further possibilities, like my switching ioctl() 
> above, or we could extend the enum v4l2_priority with an extra application 
> priority, saying, that this file-descriptor can maintain a separate S_FMT 
> / STREAMON thread, without immediately affecting other descriptors, but 
> this seems too obscure to me.
> 
> My vote goes for (2) above, which is also what Laurent has mentioned here:
> 
>> One 
>> possible direction would be to enhance the buffers allocation API to allow 
>> applications to set the buffer size. I've been thinking about this, and I 
>> believe this is where the "global buffers pool" API could come into play.
> 
> I just wouldn't necessarily bind it to "global buffer pools."
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

