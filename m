Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33369 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbbGMIEm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 04:04:42 -0400
Message-ID: <55A370DF.2080500@linux.intel.com>
Date: Mon, 13 Jul 2015 11:03:43 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Helen Fornazier <helen.fornazier@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hans.verkuil@cisco.com, s.nawrocki@samsung.com
Subject: Re: [PATCH] [media] v4l2-subdev: return -EPIPE instead of
 -EINVAL in link validate default
References: <1435538742-32447-1-git-send-email-helen.fornazier@gmail.com> <5590F276.40909@linux.intel.com> <1906172.kdU77gsF2d@avalon> <55925F25.5050708@linux.intel.com> <CAPW4XYbQ=Jdbaz0cB79q-nFtG7A9gncu-2TfHB4QfmST18kJkA@mail.gmail.com> <CAPW4XYYETmTK8MfZd941B0rb1DWODH=ZqAJu=FdmkVFrO_=dXQ@mail.gmail.com>
In-Reply-To: <CAPW4XYYETmTK8MfZd941B0rb1DWODH=ZqAJu=FdmkVFrO_=dXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

Helen Fornazier wrote:
> Hi,
> 
> On Tue, Jun 30, 2015 at 4:26 PM, Helen Fornazier <helen.fornazier@gmail.com>
> wrote:
> 
>> Hi Sakari and Laurent,
>>
>> Thanks for reviewing this
>>
>> On Tue, Jun 30, 2015 at 6:19 AM, Sakari Ailus
>> <sakari.ailus@linux.intel.com> wrote:
>>> Hi Laurent,
>>>
>>> Laurent Pinchart wrote:
>>>> Hi Sakari,
>>>>
>>>> On Monday 29 June 2015 10:23:34 Sakari Ailus wrote:
>>>>> Helen Fornazier wrote:
>>>>>> According to the V4L2 API, the VIDIOC_STREAMON ioctl should return
>> EPIPE
>>>>>> when the pipeline configuration is invalid.
>>>>>>
>>>>>> As the .vidioc_streamon in the v4l2_ioctl_ops usually forwards the
>> error
>>>>>> caused by the v4l2_subdev_link_validate_default (if it is in use), it
>>>>>> should return -EPIPE if it detects a format mismatch in the pipeline
>>>>>> configuration
>>>>>
>>>>> Only link configuration errors have yielded -EPIPE so far, sub-device
>>>>> format configuration error has returned -INVAL instead as you noticed.
>>>>
>>>> It should also be noted that while v4l2_subdev_link_validate() will
>> return -
>>>> EINVAL in case of error, the only driver that performs custom link
>> validation
>>>> (omap3isp/ispccdc.c) will return -EPIPE.
>>>
>>> Good point. That has escaped me until now.
>>>
>>>>> There are not many sources of -EINVAL while enabling streaming and all
>>>>> others are directly caused by the application; I lean towards thinking
>>>>> the code is good as it was. The documentation could be improved though.
>>>>> It may not be clear which error codes could be caused by different
>>>>> conditions.
>>>>>
>>>>> The debug level messages from media module
>>>>> (drivers/media/media-entity.c) do provide more information if needed,
>>>>> albeit this certainly is not an application interface.
>>>>>
>>>>> I wonder what others think.
>>>>
>>>> There's a discrepancy between the implementation and the documentation,
>> so at
>>>> least one of them need to be fixed. -EPIPE would be coherent with the
>>>> documentation and seems appropriately named, but another error code
>> would
>>>> allow userspace to tell link configuration and format configuration
>> problems
>>>> apart.
>>>
>>> That was the original intent, I think.
>>>
>>>> Do you think -EINVAL is the most appropriate error code for format
>>>> configuration ? It's already used to indicate that the stream type is
>> invalid
>>>> or that not enough buffers have been allocated, and is also used by
>> drivers
>>>> directly for various purposes.
>>>
>>> That's true, it's been used also for that purpose. At the time this
>>> certainly was not the primary concern. If you can think of a better
>>> error code for the purpose (than EINVAL) I'm certainly fine with using
>> one.
>>>
>>> I still think that -EPIPE is worse for telling about incorrect format
>>> configuration than -EINVAL since it's relatively easy to avoid -EINVAL
>>> for the documented reasons.
>>>
>>> --
>>> Kind regards,
>>>
>>> Sakari Ailus
>>> sakari.ailus@linux.intel.com
>>
>> I'd like just to point out where in the docs EPIPE for format mismatch
>> is specified, as it is not described in the streamon page as I thought
>> it would, but it is in the subdev page in case anyone is looking for
>> it (as I took some time to find it too):
>>
>> http://linuxtv.org/downloads/v4l-dvb-apis/subdev.html
>> "Applications are responsible for configuring coherent parameters on
>> the whole pipeline and making sure that connected pads have compatible
>> formats. The pipeline is checked for formats mismatch at
>> VIDIOC_STREAMON time, and an EPIPE error code is then returned if the
>> configuration is invalid"
>>
>> So maybe the doc should be improved as you already stated.
>>
>> --
>> Helen Fornazier
>>
> 
> I would like to revive this subject.
> 
> Should we change the docs? Change the -EINVAL to -EPIPE, or create another
> error code? What are your opinion?
> 
> I read in the docs of dev-kmsg that EPIPE is returned when messages get
> overwritten, and in other parts of the code EPIPE is returned when there is
> an error in the pipeline communication level while trying to send
> information through the pipe or a pipe broken error.
> 
> But in the error-codes.txt files, the EPIPE error is defined as:
> *EPIPE "The pipe type specified in the URB doesn't match the endpoint's
> actual type"*

This exact definition sound USB specific to me.

> Then, if EPIPE is used when types don't match between two endpoints, it
> seems reasonable to me to use EPIPE when formats don't match either. Or do
> "types" in this context have a specific definition? I don't know much about
> URB, you may be able to judge this better.

A short recap of the current situation as far as I understand it:

- MC link validation failure yields EPIPE to the user space,

- V4L2 sub-device format validation failure generally results in EINVAL,
except that

- omap3isp CCDC driver returns EPIPE instead and

- EINVAL is used for many other purposes.

The issues are inconsistency between omap3isp CCDC and other drivers in
informing the user the sub-device format configuration is wrong. Also
V4L2 sub-device format validation error cannot be told apart from other
errors. These problems should be fixed, so that all three sources of
errors yield a different error code (MC link validation, V4L2 format
configuration and other plain V4L2 related errors).

V4L2 will continue using EINVAL, that's for sure.

Another error code I could think of is EMLINK ("Too many links"), which
is not a perfect match, but could be used. This is a better match for a
link validation failure; V4L2 sub-device link validation failure would
then use EPIPE (as omap3isp CCDC driver already does).

Another option could be that V4L2 format validation failure would use
ENOEXEC ("Exec format error") instead, and EPIPE would be left to link
validation failures.

Better suggestions are welcome of course. I think I'm leaning towards
the first option, but from backwards compatibility point of view the
latter is better. The MC is no longer experimental so the latter might
be the only option.

My view is that this boils down to picking the most suitable error
codes. Then fixing the documentation is easy.

I wonder what Laurent and Hans think.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
