Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40697 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755300Ab3EURam (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 13:30:42 -0400
Date: Tue, 21 May 2013 20:30:37 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>,
	Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [RFC] Motion Detection API
Message-ID: <20130521173037.GD2041@valkosipuli.retiisi.org.uk>
References: <201304121736.16542.hverkuil@xs4all.nl>
 <201305061541.41204.hverkuil@xs4all.nl>
 <2428502.07isB1rKTR@avalon>
 <201305071435.30062.hverkuil@xs4all.nl>
 <518909DA.8000407@samsung.com>
 <20130508162648.GG1075@valkosipuli.retiisi.org.uk>
 <518ACDDA.3080908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <518ACDDA.3080908@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

My apologies for the late answer.

Sylwester Nawrocki wrote:
> Hi Sakari :-)
>
> On 05/08/2013 06:26 PM, Sakari Ailus wrote:
>> On Tue, May 07, 2013 at 04:04:10PM +0200, Sylwester Nawrocki wrote:
>>> On 05/07/2013 02:35 PM, Hans Verkuil wrote:
>>>> A metadata plane works well if you have substantial amounts of data
>>>> (e.g. histogram
>>>> data) but it has the disadvantage of requiring you to use the MPLANE
>>>> buffer types,
>>>> something which standard apps do not support. I definitely think
>>>> that is overkill
>>>> for things like this.
>>>
>>> Standard application could use the MPLANE interface through the
>>> libv4l-mplane
>>> plugin [1]. And meta-data plane could be handled in libv4l, passed in
>>> raw form
>>> from the kernel.
>>>
>>> There can be substantial amount of meta-data per frame and we were
>>> considering
>>> e.g. creating separate buffer queue for meta-data, to be able to use
>>> mmaped
>>> buffer at user space, rather than parsing and copying data multiple
>>> times in
>>> the kernel until it gets into user space and is further processed there.
>>
>> What kind of metadata do you have?
>
> At least I can tell of three kinds of meta-data at the moment:
>
>   a) face/smile/blink detection markers (rectangles), see struct
> is_face_marker
>      in file [1] in the media tree for more details; these markers can be
>      available after an image frame is dequeued AFAIK, i.e. not immediately
>      together with the image data,
>
>   b) EXIF tags (struct exif_attribute in file [1]), it's a preprocessed by
>      the ISP metadata appended to each buffer,

This class includes other image file metadata types such as iptc and xmp.

>   c) the object detection bitmap, and this one can have size comparable to
>      the actual image frame; I didn't see how it works in practice yet
> though.
> 
> For b) I have been re-considering using EXIF standard (chapter 4.6, [2]) to
> create some sane interface for the ISP driver.
>
>  From performance POV only c) would need a meta-data specific buffer
> queue, as
> such data has similar characteristics to the actual image data and a DMA
> engine
> is used to capture those bitmaps.
>
> As far as we're not copying megabytes of data by CPU there should be no big
> issues, I guess couple pages per frame is fine.
>
>>> I'm actually not sure if performance is a real issue here, were are
>>> talking
>>> of 1.5 KiB order amounts of data per frame. Likely on x86 desktop
>>> machines
>>> it is not a big deal, for ARM embedded platforms we would need to do
>>> some
>>> profiling.
>>>
>>> I'm not sure myself yet how much such motion/object detection data
>>> should be
>>> interpreted in the kernel, rather than in user space. I suspect some
>>> generic
>>> API like in your $subject RFC makes sense, it would cover as many
>>> cases as
>>> possible. But I was wondering how much it makes sense to design a
>>> sort of
>>> raw interface/buffer queue (similar to raw sockets concept), that
>>> would allow
>>> user space libraries to parse meta-data.
>>
>> This was proposed as one possible solution in the Cambourne meeting.
>>
>> <URL:http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/36587>
>>
>
> Oh, thanks for bringing up those meeting minutes.
>
>> I'm in favour of using a separate video buffer queue for passing
>> low-level
>> metadata to user space.
>
> Sure. I certainly see a need for such an interface. I wouldn't like to
> see it
> as the only option, however. One of the main reasons of introducing MPLANE
> API was to allow capture of meta-data. We are going to finally prepare some
> RFC regarding usage of a separate plane for meta-data capture. I'm not sure
> yet how it would look exactly in detail, we've just discussed this topic
> roughly with Andrzej.

I'm fine that being not the only option; however it's unbeatable when it
comes to latencies. So perhaps we should allow using multi-plane buffers for
the same purpose as well.

But how to choose between the two?

In complex media devices the metadata is written into the system memory in
an entirely different place than the images themselves which typically
require processing (especially if the sensor produces raw bayer images).
This would likely mean that there will be multiple device nodes in this kind
of situations.

That said, in both cases extra infrastructure is required for configuring
metadata format (possibly hardware-specific) and passing the control
information between the subdev drivers. This requires new interfaces to the
V4L2 subdev API. I'd think this part will still be common for both
approaches.

>>> The format of meta-data could for example have changed after
>>> switching to
>>> a new version of device's firmware. It might be rare, I'm just trying
>>> to say
>>> I would like to avoid designing a kernel interface that might soon
>>> become a
>>> limitation.
>>
>> On some devices it seems the metadata consists of much higher level
>> information.
>
> Indeed. It seems in case of devices like OMAP3 ISP we need to deal
> mostly with
> raw data from a Bayer sensor, while for the Exynos ISP I would need to
> expose
> something produced by the standalone ISP from such a raw metadata.

Can the Exynos ISP also process raw bayer input, or is it YUV only?

I remember I have heard of and seen external ISPs but never have used those
myself.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
