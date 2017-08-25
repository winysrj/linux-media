Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:33642 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754375AbdHYK4c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 06:56:32 -0400
Subject: Re: [PATCH 2/3] media: videodev2: add a flag for vdev-centric devices
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hansverk@cisco.com>
References: <cover.1503653839.git.mchehab@s-opensource.com>
 <8d504be517755ee9449a007b5f2de52738c2df63.1503653839.git.mchehab@s-opensource.com>
 <4f771cfa-0e0d-3548-a363-6470b32a6634@cisco.com>
 <20170825070632.28580858@vento.lan>
 <44bdeabc-8899-8f7e-dd26-4284c5b589a1@cisco.com>
 <20170825073517.1112d618@vento.lan>
 <7d5f952b-028d-0770-0f37-39ab011ec740@cisco.com>
 <20170825075044.7ffe3232@vento.lan>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d118d078-429b-5ea4-02d1-8852c7c662f2@xs4all.nl>
Date: Fri, 25 Aug 2017 12:56:30 +0200
MIME-Version: 1.0
In-Reply-To: <20170825075044.7ffe3232@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/08/17 12:50, Mauro Carvalho Chehab wrote:
> Em Fri, 25 Aug 2017 12:42:51 +0200
> Hans Verkuil <hansverk@cisco.com> escreveu:
> 
>> On 08/25/2017 12:35 PM, Mauro Carvalho Chehab wrote:
>>> Em Fri, 25 Aug 2017 12:13:53 +0200
>>> Hans Verkuil <hansverk@cisco.com> escreveu:
>>>   
>>>> On 08/25/2017 12:06 PM, Mauro Carvalho Chehab wrote:  
>>>>> Em Fri, 25 Aug 2017 11:44:27 +0200
>>>>> Hans Verkuil <hansverk@cisco.com> escreveu:
>>>>>     
>>>>>> On 08/25/2017 11:40 AM, Mauro Carvalho Chehab wrote:    
>>>>>>> From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>>>>>
>>>>>>> As both vdev-centric and mc-centric devices may implement the
>>>>>>> same APIs, we need a flag to allow userspace to distinguish
>>>>>>> between them.
>>>>>>>
>>>>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>>>>>>> ---
>>>>>>>  Documentation/media/uapi/v4l/open.rst            | 6 ++++++
>>>>>>>  Documentation/media/uapi/v4l/vidioc-querycap.rst | 4 ++++
>>>>>>>  include/uapi/linux/videodev2.h                   | 2 ++
>>>>>>>  3 files changed, 12 insertions(+)
>>>>>>>
>>>>>>> diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
>>>>>>> index a72d142897c0..eb3f0ec57edb 100644
>>>>>>> --- a/Documentation/media/uapi/v4l/open.rst
>>>>>>> +++ b/Documentation/media/uapi/v4l/open.rst
>>>>>>> @@ -33,6 +33,12 @@ For **vdev-centric** control, the device and their corresponding hardware
>>>>>>>  pipelines are controlled via the **V4L2 device** node. They may optionally
>>>>>>>  expose via the :ref:`media controller API <media_controller>`.
>>>>>>>  
>>>>>>> +.. note::
>>>>>>> +
>>>>>>> +   **vdev-centric** devices should report V4L2_VDEV_CENTERED      
>>>>>>
>>>>>> You mean CENTRIC, not CENTERED.    
>>>>>
>>>>> Yeah, true. I'll fix it.
>>>>>     
>>>>>> But I would change this to MC_CENTRIC: the vast majority of drivers are VDEV centric,
>>>>>> so it makes a lot more sense to keep that as the default and only set the cap for
>>>>>> MC-centric drivers.    
>>>>>
>>>>> I actually focused it on what an userspace application would do.
>>>>>
>>>>> An specialized application for a given hardware will likely just
>>>>> ignore whatever flag is added, and use vdev, mc and subdev APIs
>>>>> as it pleases. So, those applications don't need any flag at all.
>>>>>
>>>>> However, a generic application needs a flag to allow them to check
>>>>> if a given hardware can be controlled by the traditional way
>>>>> to control the device (e. g. if it accepts vdev-centric type of
>>>>> hardware control).
>>>>>
>>>>> It is an old desire (since when MC was designed) to allow that
>>>>> generic V4L2 apps to also work with MC-centric hardware somehow.    
>>>>
>>>> No, not true. The desire is that they can use the MC to find the
>>>> various device nodes (video, radio, vbi, rc, cec, ...). But they
>>>> remain vdev-centric. vdev vs mc centric has nothing to do with the
>>>> presence of the MC. It's how they are controlled.  
>>>
>>> No, that's not I'm talking about. I'm talking about libv4l plugin
>>> (or whatever) that would allow a generic app to work with a mc-centric
>>> device. That's there for a long time (since when we were reviewing
>>> the MC patches back in 2009 or 2010).  
>>
>> So? Such a plugin would obviously remove the MC_CENTRIC cap. Which makes
>> perfect sense.
>>
>> There are a lot of userspace applications that do not use libv4l. It's
>> optional, not required, to use that library. We cannot design our API with
>> the assumption that this library will be used.
>>
>>>   
>>>>
>>>> Regarding userspace applications: they can't check for a VDEV_CENTRIC
>>>> cap since we never had any. I.e., if they do:
>>>>
>>>> 	if (!(caps & VDEV_CENTRIC))
>>>> 		/* unsupported device */
>>>>
>>>> then they would fail for older kernels that do not set this flag.
>>>>
>>>> But this works:
>>>>
>>>> 	if (caps & MC_CENTRIC)
>>>> 		/* unsupported device */
>>>>
>>>> So this really needs to be an MC_CENTRIC capability.  
>>>
>>> That won't work. The test should take into account the API version
>>> too.
>>>
>>> Assuming that such flag would be added for version 4.15, with a VDEV_CENTRIC,
>>> the check would be:
>>>
>>>
>>> 	/*
>>>          * There's no need to check version here: libv4l may override it
>>> 	 * to support a mc-centric device even for older versions of the
>>> 	 * Kernel
>>>          */
>>> 	if (caps & V4L2_CAP_VDEV_CENTRIC)
>>> 		is_supported = true;
>>>
>>> 	/*
>>> 	 * For API version lower than 4.15, there's no way to know for
>>> 	 * sure if the device is vdev-centric or not. So, either additional
>>> 	 * tests are needed, or it would assume vdev-centric and output
>>> 	 * some note about that.
>>> 	 */
>>> 	if (version < KERNEL_VERSION(4, 15, 0))
>>> 		maybe_supported = true;  
>>
>>
>> 	is_supported = true;
>> 	if (caps & V4L2_CAP_MC_CENTRIC)
>> 		is_supported = false;
>>  	if (version < KERNEL_VERSION(4, 15, 0))
>>  		maybe_supported = true;
>>
>> I don't see the difference. BTW, no application will ever do that version check.
>> It doesn't help them in any way to know that it 'may' be supported.
> 
> Yeah, this can work. The only drawback is that, if we end by
> implementing vdev compatible support is that such drivers will
> have to clean the V4L2_CAP_MC_CENTRIC flag.

You mean implementing vdev compatible support in libv4l? (Just making sure
I understand you correctly)

In that case it doesn't matter if the libv4l code would set the VDEV_CENTRIC flag
or remove the MC_CENTRIC flag. That makes no difference, or course.

Regards,

	Hans
