Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38606 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbbF3JTg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2015 05:19:36 -0400
Message-ID: <55925F25.5050708@linux.intel.com>
Date: Tue, 30 Jun 2015 12:19:33 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Helen Fornazier <helen.fornazier@gmail.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hans.verkuil@cisco.com, s.nawrocki@samsung.com
Subject: Re: [PATCH] [media] v4l2-subdev: return -EPIPE instead of
 -EINVAL in link validate default
References: <1435538742-32447-1-git-send-email-helen.fornazier@gmail.com> <5590F276.40909@linux.intel.com> <1906172.kdU77gsF2d@avalon>
In-Reply-To: <1906172.kdU77gsF2d@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Monday 29 June 2015 10:23:34 Sakari Ailus wrote:
>> Helen Fornazier wrote:
>>> According to the V4L2 API, the VIDIOC_STREAMON ioctl should return EPIPE
>>> when the pipeline configuration is invalid.
>>>
>>> As the .vidioc_streamon in the v4l2_ioctl_ops usually forwards the error
>>> caused by the v4l2_subdev_link_validate_default (if it is in use), it
>>> should return -EPIPE if it detects a format mismatch in the pipeline
>>> configuration
>>
>> Only link configuration errors have yielded -EPIPE so far, sub-device
>> format configuration error has returned -INVAL instead as you noticed.
> 
> It should also be noted that while v4l2_subdev_link_validate() will return -
> EINVAL in case of error, the only driver that performs custom link validation 
> (omap3isp/ispccdc.c) will return -EPIPE.

Good point. That has escaped me until now.

>> There are not many sources of -EINVAL while enabling streaming and all
>> others are directly caused by the application; I lean towards thinking
>> the code is good as it was. The documentation could be improved though.
>> It may not be clear which error codes could be caused by different
>> conditions.
>>
>> The debug level messages from media module
>> (drivers/media/media-entity.c) do provide more information if needed,
>> albeit this certainly is not an application interface.
>>
>> I wonder what others think.
> 
> There's a discrepancy between the implementation and the documentation, so at 
> least one of them need to be fixed. -EPIPE would be coherent with the 
> documentation and seems appropriately named, but another error code would 
> allow userspace to tell link configuration and format configuration problems 
> apart.

That was the original intent, I think.

> Do you think -EINVAL is the most appropriate error code for format 
> configuration ? It's already used to indicate that the stream type is invalid 
> or that not enough buffers have been allocated, and is also used by drivers 
> directly for various purposes.

That's true, it's been used also for that purpose. At the time this
certainly was not the primary concern. If you can think of a better
error code for the purpose (than EINVAL) I'm certainly fine with using one.

I still think that -EPIPE is worse for telling about incorrect format
configuration than -EINVAL since it's relatively easy to avoid -EINVAL
for the documented reasons.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
