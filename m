Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:38005 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868Ab3EVVlz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 May 2013 17:41:55 -0400
Received: by mail-ea0-f170.google.com with SMTP id f15so1367189eak.1
        for <linux-media@vger.kernel.org>; Wed, 22 May 2013 14:41:54 -0700 (PDT)
Message-ID: <519D3B9E.4090800@gmail.com>
Date: Wed, 22 May 2013 23:41:50 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>,
	Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [RFC] Motion Detection API
References: <201304121736.16542.hverkuil@xs4all.nl> <201305061541.41204.hverkuil@xs4all.nl> <2428502.07isB1rKTR@avalon> <201305071435.30062.hverkuil@xs4all.nl> <518909DA.8000407@samsung.com> <20130508162648.GG1075@valkosipuli.retiisi.org.uk> <518ACDDA.3080908@gmail.com> <20130521173037.GD2041@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130521173037.GD2041@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 05/21/2013 07:30 PM, Sakari Ailus wrote:
> Hi Sylwester,
>
> My apologies for the late answer.

No problem at all, thank you for your follow up.

> Sylwester Nawrocki wrote:
>> On 05/08/2013 06:26 PM, Sakari Ailus wrote:
>>> On Tue, May 07, 2013 at 04:04:10PM +0200, Sylwester Nawrocki wrote:
>>>> On 05/07/2013 02:35 PM, Hans Verkuil wrote:
>>>>> A metadata plane works well if you have substantial amounts of data
>>>>> (e.g. histogram
>>>>> data) but it has the disadvantage of requiring you to use the MPLANE
>>>>> buffer types,
>>>>> something which standard apps do not support. I definitely think
>>>>> that is overkill for things like this.
>>>>
>>>> Standard application could use the MPLANE interface through the
>>>> libv4l-mplane
>>>> plugin [1]. And meta-data plane could be handled in libv4l, passed in
>>>> raw form from the kernel.
>>>>
>>>> There can be substantial amount of meta-data per frame and we were
>>>> considering
>>>> e.g. creating separate buffer queue for meta-data, to be able to use
>>>> mmaped
>>>> buffer at user space, rather than parsing and copying data multiple
>>>> times in
>>>> the kernel until it gets into user space and is further processed
>>>> there.
>>>
>>> What kind of metadata do you have?
>>
>> At least I can tell of three kinds of meta-data at the moment:
>>
>> a) face/smile/blink detection markers (rectangles), see struct
>> is_face_marker
>> in file [1] in the media tree for more details; these markers can be
>> available after an image frame is dequeued AFAIK, i.e. not immediately
>> together with the image data,
>>
>> b) EXIF tags (struct exif_attribute in file [1]), it's a preprocessed by
>> the ISP metadata appended to each buffer,
>
> This class includes other image file metadata types such as iptc and xmp.

Right, thanks for pointing it out.

It seems EXIF is most useful for device related image properties though.
At least this is my understanding from reading the "Guidelines For Handling
Image Metadata" [1].

XMP uses XML schemas and it seems more relevant to processing data in user
space applications. Although it defines various namespaces [2] and could be
a container of a set of EXIF-specific properties.

>> c) the object detection bitmap, and this one can have size comparable to
>> the actual image frame; I didn't see how it works in practice yet
>> though.
>>
>> For b) I have been re-considering using EXIF standard (chapter 4.6,
>> [2]) to
>> create some sane interface for the ISP driver.
>>
>> From performance POV only c) would need a meta-data specific buffer
>> queue, as
>> such data has similar characteristics to the actual image data and a DMA
>> engine
>> is used to capture those bitmaps.
[...]
>>> I'm in favour of using a separate video buffer queue for passing
>>> low-level
>>> metadata to user space.
>>
>> Sure. I certainly see a need for such an interface. I wouldn't like to
>> see it
>> as the only option, however. One of the main reasons of introducing
>> MPLANE
>> API was to allow capture of meta-data. We are going to finally prepare
>> some
>> RFC regarding usage of a separate plane for meta-data capture. I'm not
>> sure
>> yet how it would look exactly in detail, we've just discussed this topic
>> roughly with Andrzej.
>
> I'm fine that being not the only option; however it's unbeatable when it
> comes to latencies. So perhaps we should allow using multi-plane buffers
> for the same purpose as well.
>
> But how to choose between the two?

I think we need some example implementation for metadata capture over
multi-plane interface and with a separate video node. Without such
implementation/API draft it is a bit difficult to discuss this further.

> In complex media devices the metadata is written into the system memory in
> an entirely different place than the images themselves which typically
> require processing (especially if the sensor produces raw bayer images).
> This would likely mean that there will be multiple device nodes in this
> kind of situations.
>
> That said, in both cases extra infrastructure is required for configuring
> metadata format (possibly hardware-specific) and passing the control
> information between the subdev drivers. This requires new interfaces to the
> V4L2 subdev API. I'd think this part will still be common for both
> approaches.
>
>>> On some devices it seems the metadata consists of much higher level
>>> information.
>>
>> Indeed. It seems in case of devices like OMAP3 ISP we need to deal
>> mostly with
>> raw data from a Bayer sensor, while for the Exynos ISP I would need to
>> expose
>> something produced by the standalone ISP from such a raw metadata.
>
> Can the Exynos ISP also process raw bayer input, or is it YUV only?

Exynos4212 an later have a full camera ISP subsystem and can process raw
bayer data, as opposed to the Exynos4210 and earlier SoCs, where the camera
subsystem was supporting at most capturing raw bayer data transparently
to memory.

Unfortunately the Exynos Imaging Subsystem documentation is not yet
publicly available.

> I remember I have heard of and seen external ISPs but never have used
> those myself.

I think it might not matter that much if an ISP is external or local to
the main CPU/SoC. Presumably it may mean that different data busses/
mechanisms are used to communicate with the actual hardware, which should
be encapsulated by a driver anyway.

Thanks,
Sylwester

[1] http://www.metadataworkinggroup.org/specs
[2] 
http://www.adobe.com/content/dam/Adobe/en/devnet/xmp/pdfs/XMPSpecificationPart2.pdf
