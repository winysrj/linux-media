Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:36727 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751669AbeBVHiw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 02:38:52 -0500
Subject: Re: [PATCH v2] videodev2.h: add helper to validate colorspace
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20180214103643.8245-1-niklas.soderlund+renesas@ragnatech.se>
 <20180219222804.GD8442@bigcity.dyn.berto.se>
 <94142433-a72d-ddd4-22bc-b36380f4efbc@xs4all.nl> <2556801.UsItpXbr2P@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e09a145d-bf1b-6f8e-79aa-80445ce91e25@xs4all.nl>
Date: Thu, 22 Feb 2018 08:38:46 +0100
MIME-Version: 1.0
In-Reply-To: <2556801.UsItpXbr2P@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/21/2018 09:16 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday, 20 February 2018 10:37:22 EET Hans Verkuil wrote:
>> On 02/19/2018 11:28 PM, Niklas Söderlund wrote:
>>> Hi Hans,
>>>
>>> Thanks for your feedback.
>>>
>>> [snip]
>>>
>>>>>>>> Can you then fix v4l2-compliance to stop testing colorspace
>>>>>>>> against 0xff
>>>>>>>> ?
>>>>>>>
>>>>>>> For now I can simply relax this test for subdevs with sources and
>>>>>>> sinks.
>>>>>>
>>>>>> You also need to relax it for video nodes with MC drivers, as the DMA
>>>>>> engines don't care about colorspaces.
>>>>>
>>>>> Yes, they do. Many DMA engines can at least do RGB <-> YUV conversions,
>>>>> so they should get the colorspace info from their source and pass it on
>>>>> to userspace (after correcting for any conversions done by the DMA
>>>>> engine).
>>>>
>>>> Not in the MC case. Video nodes there only model the DMA engine, and are
>>>> thus not aware of colorspaces. What MC drivers do is check at stream on
>>>> time when validating the pipeline that the colorspace set by userspace
>>>> on the video node corresponds to the colorspace on the source pad of the
>>>> connected subdev, but that's only to ensure that userspace gets a
>>>> coherent view of colorspace across the pipeline, not to program the
>>>> hardware. There could be exceptions, but in the general case, the video
>>>> node implementation of an MC driver will accept any colorspace and only
>>>> validate it at stream on time, similarly to how it does for the frame
>>>> size format instance (and in the frame size case it will usually enforce
>>>> min/max limits when the DMA engine limits the frame size).> 
>>> I'm afraid the issue described above by Laurent is what sparked me to
>>> write this commit to begin with. In my never ending VIN Gen3 patch-set I
>>> currency need to carry a patch [1] to implement a hack to make sure
>>> v4l2-compliance do not fail for the VIN Gen3 MC-centric use-case. This
>>> patch was an attempt to be able to validate the colorspace using the
>>> magic value 0xff.
>>
>> This is NOT a magic value. The test that's done here is to memset the
>> format structure with 0xff, then call the ioctl. Afterwards it checks
>> if there are any remaining 0xff bytes left in the struct since it expects
>> the driver to have overwritten it by something else. That's where the 0xff
>> comes from.
> 
> It's no less or more magic than using 0xdeadbeef or any fixed value :-) I 
> think we all agree that it isn't a value that is meant to be handled 
> specifically by drivers, so it's not magic in that sense.
> 
>>> I don't feel strongly for this patch in particular and I'm happy to drop
>>> it.  But I would like to receive some guidance on how to then properly
>>> be able to handle this problem for the MC-centric VIN driver use-case.
>>> One option is as you suggested to relax the test in v4l-compliance to
>>> not check colorspace, but commit [2] is not enough to resolve the issue
>>> for my MC use-case.
>>>
>>> As Laurent stated above, the use-case is that the video device shall
>>> accept any colorspace set from user-space. This colorspace is then only
>>> used as stream on time to validate the MC pipeline. The VIN driver do
>>> not care about colorspace, but I care about not breaking v4l2-compliance
>>> as I find it's a very useful tool :-)
>>
>> I think part of my confusion here is that there are two places where you
>> deal with colorspaces in a DMA engine: first there is a input pad of the
>> DMA engine entity, secondly there is the v4l2_pix_format for the memory
>> description.
>>
>> The second is set by the driver based on what userspace specified for the
>> input pad, together with any changes due to additional conversions such
>> as quantization range and RGB <-> YUV by the DMA engine.
> 
> No, I'm sorry, for MC-based drivers this isn't correct. The media entity that 
> symbolizes the DMA engine indeed has a sink pad, but it's a video node, not a 
> subdev. It thus has no media bus format configured for its sink pad. The 
> closest pad in the pipeline that has a media bus format is the source pad of 
> the subdev connected to the video node.
> 
> There's no communication within the kernel at G/S_FMT time between the video 
> node and its connected subdev. The only time we look at the pipeline as a 
> whole is when starting the stream to validate that the pipeline is correctly 
> configured. We thus have to implement G/S_FMT on the video node without any 
> knowledge about the connected subdev, and thus accept any colorspace.
> 
>> So any colorspace validation is done for the input pad. The question is
>> what that validation should be. It's never been defined.
> 
> No format is set on the video node's entity sink pad for the reason above, so 
> no validation occurs when setting the colorspace on the sink pad as that never 
> happens.

Is this documented anywhere? Certainly VIDIOC_G/S/TRY_FMT doesn't mention it.

It is certainly a surprise to me.

Regards,

	Hans
