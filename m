Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:38527 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755479AbdHYLmM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 07:42:12 -0400
Subject: Re: [PATCH 2/3] media: videodev2: add a flag for vdev-centric devices
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <cover.1503653839.git.mchehab@s-opensource.com>
 <8d504be517755ee9449a007b5f2de52738c2df63.1503653839.git.mchehab@s-opensource.com>
 <4f771cfa-0e0d-3548-a363-6470b32a6634@cisco.com>
 <20170825070632.28580858@vento.lan>
 <44bdeabc-8899-8f7e-dd26-4284c5b589a1@cisco.com>
 <20170825073517.1112d618@vento.lan>
 <7d5f952b-028d-0770-0f37-39ab011ec740@cisco.com>
 <20170825075044.7ffe3232@vento.lan>
 <d118d078-429b-5ea4-02d1-8852c7c662f2@xs4all.nl>
 <20170825081503.13e4df80@vento.lan> <20170825083037.772cb089@vento.lan>
 <20170825083531.6e5e2c84@vento.lan>
Cc: Hans Verkuil <hansverk@cisco.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e807ef53-6dcb-410a-f188-c8cdcdf25df6@xs4all.nl>
Date: Fri, 25 Aug 2017 13:42:10 +0200
MIME-Version: 1.0
In-Reply-To: <20170825083531.6e5e2c84@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/08/17 13:35, Mauro Carvalho Chehab wrote:
> Em Fri, 25 Aug 2017 08:30:37 -0300
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
> 
>> Em Fri, 25 Aug 2017 08:15:03 -0300
>> Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
>>
>>> Em Fri, 25 Aug 2017 12:56:30 +0200
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>> On 25/08/17 12:50, Mauro Carvalho Chehab wrote:  
>>>>> Em Fri, 25 Aug 2017 12:42:51 +0200
>>>>> Hans Verkuil <hansverk@cisco.com> escreveu:
>>>>>     
>>>>>> On 08/25/2017 12:35 PM, Mauro Carvalho Chehab wrote:    
>>>>>>> Em Fri, 25 Aug 2017 12:13:53 +0200
>>>>>>> Hans Verkuil <hansverk@cisco.com> escreveu:
>>>>>>>       
>>>>>>>> On 08/25/2017 12:06 PM, Mauro Carvalho Chehab wrote:      
>>>>>>>>> Em Fri, 25 Aug 2017 11:44:27 +0200
>>>>>>>>> Hans Verkuil <hansverk@cisco.com> escreveu:
>>>>>>>>>         
>>>>>>>>>> On 08/25/2017 11:40 AM, Mauro Carvalho Chehab wrote:        
>>>>>>>>>>> From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>>>>>>>>>
>>>>>>>>>>> As both vdev-centric and mc-centric devices may implement the
>>>>>>>>>>> same APIs, we need a flag to allow userspace to distinguish
>>>>>>>>>>> between them.
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>>>>>>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>>>>>>>>>>> ---
>>>>>>>>>>>  Documentation/media/uapi/v4l/open.rst            | 6 ++++++
>>>>>>>>>>>  Documentation/media/uapi/v4l/vidioc-querycap.rst | 4 ++++
>>>>>>>>>>>  include/uapi/linux/videodev2.h                   | 2 ++
>>>>>>>>>>>  3 files changed, 12 insertions(+)
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
>>>>>>>>>>> index a72d142897c0..eb3f0ec57edb 100644
>>>>>>>>>>> --- a/Documentation/media/uapi/v4l/open.rst
>>>>>>>>>>> +++ b/Documentation/media/uapi/v4l/open.rst
>>>>>>>>>>> @@ -33,6 +33,12 @@ For **vdev-centric** control, the device and their corresponding hardware
>>>>>>>>>>>  pipelines are controlled via the **V4L2 device** node. They may optionally
>>>>>>>>>>>  expose via the :ref:`media controller API <media_controller>`.
>>>>>>>>>>>  
>>>>>>>>>>> +.. note::
>>>>>>>>>>> +
>>>>>>>>>>> +   **vdev-centric** devices should report V4L2_VDEV_CENTERED          
>>>>>>>>>>
>>>>>>>>>> You mean CENTRIC, not CENTERED.        
>>>>>>>>>
>>>>>>>>> Yeah, true. I'll fix it.
>>>>>>>>>         
>>>>>>>>>> But I would change this to MC_CENTRIC: the vast majority of drivers are VDEV centric,
>>>>>>>>>> so it makes a lot more sense to keep that as the default and only set the cap for
>>>>>>>>>> MC-centric drivers.        
>>>>>>>>>
>>>>>>>>> I actually focused it on what an userspace application would do.
>>>>>>>>>
>>>>>>>>> An specialized application for a given hardware will likely just
>>>>>>>>> ignore whatever flag is added, and use vdev, mc and subdev APIs
>>>>>>>>> as it pleases. So, those applications don't need any flag at all.
>>>>>>>>>
>>>>>>>>> However, a generic application needs a flag to allow them to check
>>>>>>>>> if a given hardware can be controlled by the traditional way
>>>>>>>>> to control the device (e. g. if it accepts vdev-centric type of
>>>>>>>>> hardware control).
>>>>>>>>>
>>>>>>>>> It is an old desire (since when MC was designed) to allow that
>>>>>>>>> generic V4L2 apps to also work with MC-centric hardware somehow.        
>>>>>>>>
>>>>>>>> No, not true. The desire is that they can use the MC to find the
>>>>>>>> various device nodes (video, radio, vbi, rc, cec, ...). But they
>>>>>>>> remain vdev-centric. vdev vs mc centric has nothing to do with the
>>>>>>>> presence of the MC. It's how they are controlled.      
>>>>>>>
>>>>>>> No, that's not I'm talking about. I'm talking about libv4l plugin
>>>>>>> (or whatever) that would allow a generic app to work with a mc-centric
>>>>>>> device. That's there for a long time (since when we were reviewing
>>>>>>> the MC patches back in 2009 or 2010).      
>>>>>>
>>>>>> So? Such a plugin would obviously remove the MC_CENTRIC cap. Which makes
>>>>>> perfect sense.
>>>>>>
>>>>>> There are a lot of userspace applications that do not use libv4l. It's
>>>>>> optional, not required, to use that library. We cannot design our API with
>>>>>> the assumption that this library will be used.
>>>>>>    
>>>>>>>       
>>>>>>>>
>>>>>>>> Regarding userspace applications: they can't check for a VDEV_CENTRIC
>>>>>>>> cap since we never had any. I.e., if they do:
>>>>>>>>
>>>>>>>> 	if (!(caps & VDEV_CENTRIC))
>>>>>>>> 		/* unsupported device */
>>>>>>>>
>>>>>>>> then they would fail for older kernels that do not set this flag.
>>>>>>>>
>>>>>>>> But this works:
>>>>>>>>
>>>>>>>> 	if (caps & MC_CENTRIC)
>>>>>>>> 		/* unsupported device */
>>>>>>>>
>>>>>>>> So this really needs to be an MC_CENTRIC capability.      
>>>>>>>
>>>>>>> That won't work. The test should take into account the API version
>>>>>>> too.
>>>>>>>
>>>>>>> Assuming that such flag would be added for version 4.15, with a VDEV_CENTRIC,
>>>>>>> the check would be:
>>>>>>>
>>>>>>>
>>>>>>> 	/*
>>>>>>>          * There's no need to check version here: libv4l may override it
>>>>>>> 	 * to support a mc-centric device even for older versions of the
>>>>>>> 	 * Kernel
>>>>>>>          */
>>>>>>> 	if (caps & V4L2_CAP_VDEV_CENTRIC)
>>>>>>> 		is_supported = true;
>>>>>>>
>>>>>>> 	/*
>>>>>>> 	 * For API version lower than 4.15, there's no way to know for
>>>>>>> 	 * sure if the device is vdev-centric or not. So, either additional
>>>>>>> 	 * tests are needed, or it would assume vdev-centric and output
>>>>>>> 	 * some note about that.
>>>>>>> 	 */
>>>>>>> 	if (version < KERNEL_VERSION(4, 15, 0))
>>>>>>> 		maybe_supported = true;      
>>>>>>
>>>>>>
>>>>>> 	is_supported = true;
>>>>>> 	if (caps & V4L2_CAP_MC_CENTRIC)
>>>>>> 		is_supported = false;
>>>>>>  	if (version < KERNEL_VERSION(4, 15, 0))
>>>>>>  		maybe_supported = true;
>>>>>>
>>>>>> I don't see the difference. BTW, no application will ever do that version check.
>>>>>> It doesn't help them in any way to know that it 'may' be supported.    
>>>>>
>>>>> Yeah, this can work. The only drawback is that, if we end by
>>>>> implementing vdev compatible support is that such drivers will
>>>>> have to clean the V4L2_CAP_MC_CENTRIC flag.    
>>>>
>>>> You mean implementing vdev compatible support in libv4l? (Just making sure
>>>> I understand you correctly)  
>>>
>>> Yes, either there or at the Kernel, as it seems we'll never have it
>>> there, as nobody is working on it anymore.
>>>
>>>> In that case it doesn't matter if the libv4l code would set the VDEV_CENTRIC flag
>>>> or remove the MC_CENTRIC flag. That makes no difference, or course.  
>>>
>>> True, but the text will have to be clear that a MC_CENTRIC device is a
>>> device that can't be controlled by a V4L2-centric application.
>>
>> Ok, that's the "reverse" patch. IMHO, it is very confusing, as we're
>> actually using MC_CENTRIC to actually describe the lack of a capability.
>>
>> Perhaps we should name it as NOT_VDEV_CENTRIC instead.
> 
> Hans suggested an alternative word at the IRC ("require"), with actually
> sounds better. Patch follows.
> 
> I can live it that :-)
> 
> Regards,
> Mauro
> 
> -
> 
> media: videodev2: add a flag for vdev-centric devices
>     
> As both vdev-centric and mc-centric devices may implement the
> same APIs, we need a flag to allow userspace to distinguish
> between them.
>     
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> index a72d142897c0..4b344dccd2ac 100644
> --- a/Documentation/media/uapi/v4l/open.rst
> +++ b/Documentation/media/uapi/v4l/open.rst
> @@ -6,6 +6,8 @@
>  Opening and Closing Devices
>  ***************************
>  
> +.. _v4l2_hardware_control:
> +
>  Types of V4L2 hardware control
>  ==============================
>  
> @@ -33,6 +35,13 @@ For **vdev-centric** control, the device and their corresponding hardware
>  pipelines are controlled via the **V4L2 device** node. They may optionally
>  expose via the :ref:`media controller API <media_controller>`.
>  
> +.. note::
> +
> +   Devices that require **mc-centric** hardware control should report

s/should/shall/

Shouldn't we use MC-centric? (i.e. capital MC) I think that's better.

> +   a ``V4L2_MC_CENTRIC`` :c:type:`v4l2_capability` flag

s/a/the/

> +   (see :ref:`VIDIOC_QUERYCAP`).
> +
> +
>  For **MC-centric** control, before using the V4L2 device, it is required to
>  set the hardware pipelines via the
>  :ref:`media controller API <media_controller>`. For those devices, the
> diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
> index 12e0d9a63cd8..2b08723375bc 100644
> --- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
> @@ -252,6 +252,11 @@ specification the ioctl returns an ``EINVAL`` error code.
>      * - ``V4L2_CAP_TOUCH``
>        - 0x10000000
>        - This is a touch device.
> +    * - ``V4L2_MC_CENTRIC``
> +      - 0x20000000
> +      - Indicates that the device require **mc-centric** hardware

requires

> +        control, and thus can't be used by **v4l2-centric** applications.

So are we using V4L2-centric or vdev-centric? It seems to be mixed now.
And if we use V4L2-centric then it should be capitals as well.

> +        See :ref:`v4l2_hardware_control` for more details.
>      * - ``V4L2_CAP_DEVICE_CAPS``
>        - 0x80000000
>        - The driver fills the ``device_caps`` field. This capability can
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 45cf7359822c..7b490fe97980 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -460,6 +460,8 @@ struct v4l2_capability {
>  
>  #define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch device */
>  
> +#define V4L2_CAP_MC_CENTRIC             0x20000000  /* Device require mc-centric hardware control */

requires

> +
>  #define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device capabilities field */
>  
>  /*
> 

This is getting close. Can you post the whole patch series for the next revision?
It's a bit hard to review with patches in replies.

Regards,

	Hans
