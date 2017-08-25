Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:65100 "EHLO
        aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754622AbdHYKNz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 06:13:55 -0400
Subject: Re: [PATCH 2/3] media: videodev2: add a flag for vdev-centric devices
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <cover.1503653839.git.mchehab@s-opensource.com>
 <8d504be517755ee9449a007b5f2de52738c2df63.1503653839.git.mchehab@s-opensource.com>
 <4f771cfa-0e0d-3548-a363-6470b32a6634@cisco.com>
 <20170825070632.28580858@vento.lan>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <44bdeabc-8899-8f7e-dd26-4284c5b589a1@cisco.com>
Date: Fri, 25 Aug 2017 12:13:53 +0200
MIME-Version: 1.0
In-Reply-To: <20170825070632.28580858@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/25/2017 12:06 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 25 Aug 2017 11:44:27 +0200
> Hans Verkuil <hansverk@cisco.com> escreveu:
> 
>> On 08/25/2017 11:40 AM, Mauro Carvalho Chehab wrote:
>>> From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>
>>> As both vdev-centric and mc-centric devices may implement the
>>> same APIs, we need a flag to allow userspace to distinguish
>>> between them.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>>> ---
>>>  Documentation/media/uapi/v4l/open.rst            | 6 ++++++
>>>  Documentation/media/uapi/v4l/vidioc-querycap.rst | 4 ++++
>>>  include/uapi/linux/videodev2.h                   | 2 ++
>>>  3 files changed, 12 insertions(+)
>>>
>>> diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
>>> index a72d142897c0..eb3f0ec57edb 100644
>>> --- a/Documentation/media/uapi/v4l/open.rst
>>> +++ b/Documentation/media/uapi/v4l/open.rst
>>> @@ -33,6 +33,12 @@ For **vdev-centric** control, the device and their corresponding hardware
>>>  pipelines are controlled via the **V4L2 device** node. They may optionally
>>>  expose via the :ref:`media controller API <media_controller>`.
>>>  
>>> +.. note::
>>> +
>>> +   **vdev-centric** devices should report V4L2_VDEV_CENTERED  
>>
>> You mean CENTRIC, not CENTERED.
> 
> Yeah, true. I'll fix it.
> 
>> But I would change this to MC_CENTRIC: the vast majority of drivers are VDEV centric,
>> so it makes a lot more sense to keep that as the default and only set the cap for
>> MC-centric drivers.
> 
> I actually focused it on what an userspace application would do.
> 
> An specialized application for a given hardware will likely just
> ignore whatever flag is added, and use vdev, mc and subdev APIs
> as it pleases. So, those applications don't need any flag at all.
> 
> However, a generic application needs a flag to allow them to check
> if a given hardware can be controlled by the traditional way
> to control the device (e. g. if it accepts vdev-centric type of
> hardware control).
> 
> It is an old desire (since when MC was designed) to allow that
> generic V4L2 apps to also work with MC-centric hardware somehow.

No, not true. The desire is that they can use the MC to find the
various device nodes (video, radio, vbi, rc, cec, ...). But they
remain vdev-centric. vdev vs mc centric has nothing to do with the
presence of the MC. It's how they are controlled.

Regarding userspace applications: they can't check for a VDEV_CENTRIC
cap since we never had any. I.e., if they do:

	if (!(caps & VDEV_CENTRIC))
		/* unsupported device */

then they would fail for older kernels that do not set this flag.

But this works:

	if (caps & MC_CENTRIC)
		/* unsupported device */

So this really needs to be an MC_CENTRIC capability.

Regards,

	Hans

> 
> At the moment we add that (either in Kernelspace, as proposed for
> iMX6 [1] or via libv4l), a mc-centric hardware can also be 
> vdev-centric.
> 
> [1] one alternative proposed for iMX6 driver, would be to enable
>     vdev-centric control only for hardware with a single camera
>     slot, like those cheap RPi3-camera compatible hardware, by
>     using some info at the DT.
> 
>>
>> Regards,
>>
>> 	Hans
>>
>>> +   :c:type:`v4l2_capability` flag (see :ref:`VIDIOC_QUERYCAP`).
>>> +
>>> +
>>>  For **MC-centric** control, before using the V4L2 device, it is required to
>>>  set the hardware pipelines via the
>>>  :ref:`media controller API <media_controller>`. For those devices, the
>>> diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
>>> index 12e0d9a63cd8..4856821b7608 100644
>>> --- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
>>> +++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
>>> @@ -252,6 +252,10 @@ specification the ioctl returns an ``EINVAL`` error code.
>>>      * - ``V4L2_CAP_TOUCH``
>>>        - 0x10000000
>>>        - This is a touch device.
>>> +    * - ``V4L2_VDEV_CENTERED``
>>> +      - 0x20000000
>>> +      - This is controlled via V4L2 device nodes (radio, video, vbi,
>>> +        sdr
>>>      * - ``V4L2_CAP_DEVICE_CAPS``
>>>        - 0x80000000
>>>        - The driver fills the ``device_caps`` field. This capability can
>>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>>> index 45cf7359822c..d89090d99042 100644
>>> --- a/include/uapi/linux/videodev2.h
>>> +++ b/include/uapi/linux/videodev2.h
>>> @@ -460,6 +460,8 @@ struct v4l2_capability {
>>>  
>>>  #define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch device */
>>>  
>>> +#define V4L2_CAP_VDEV_CENTERED          0x20000000  /* V4L2 Device is controlled via V4L2 device devnode */
>>> +
>>>  #define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device capabilities field */
>>>  
>>>  /*
>>>   
>>
> 
> 
> 
> Thanks,
> Mauro
> 
