Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52038 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728172AbeIQWmD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 18:42:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id y2-v6so10539717wma.1
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 10:13:46 -0700 (PDT)
Subject: Re: [PATCH 1/2] [media] v4l: allow to register dev nodes for
 individual v4l2 subdevs
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <20180904113018.14428-1-javierm@redhat.com>
 <20180904113018.14428-2-javierm@redhat.com>
 <20180917164634.arevvwkrvdmmteem@paasikivi.fi.intel.com>
From: Javier Martinez Canillas <javierm@redhat.com>
Message-ID: <0788d9f0-b98b-ecf8-c006-7f2f2172561c@redhat.com>
Date: Mon, 17 Sep 2018 19:13:43 +0200
MIME-Version: 1.0
In-Reply-To: <20180917164634.arevvwkrvdmmteem@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 9/17/18 6:46 PM, Sakari Ailus wrote:
> Hi Javier,
> 
> On Tue, Sep 04, 2018 at 01:30:17PM +0200, Javier Martinez Canillas wrote:
>> Currently there's only a function to register device nodes for all subdevs
>> of a v4l2 device that are marked with the V4L2_SUBDEV_FL_HAS_DEVNODE flag.
>>
>> But drivers may want to register device nodes for individual subdevices,
>> so add a v4l2_device_register_subdev_node() for this purpose.
>>
>> A use case for this function is for media device drivers to register the
>> device nodes in the v4l2 async notifier .bound callback instead of doing
>> a registration for all subdevices in the .complete callback.
> 
> Thanks for the set.
> 
> I've been doing some work to add events to MC; with Hans's property API
> set, assuming it could be used to tell the registration is complete, we
> have all bits for a complete solution.
>

Great.
 
> As the driver is buggy and fails to work correctly in the case if not every
> sub-devices probes successfully, I see no reason to postpone applying the
> two patches now.
>

Yes, agreed.
 
> One more comment below. (No need to resend just for that IMO.)
> 
>>
>> Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>

[snip]

>>  
>> +/**
>> + * v4l2_device_register_subdev_node - Registers a device node for a subdev
>> + *	of the v4l2 device.
>> + *
>> + * @v4l2_dev: pointer to struct v4l2_device
> 
> struct -> &struct
>

Thanks, I'm not well versed in kernel-doc / Sphinx markup syntax so I missed it.

BTW, I copied from another place in include/media/v4l2-device.h, and now I
notice that it has a mix of "&struct foo", "struct &foo" and "struct foo".

It would be nice to fix this so cross-reference works properly in all cases.
 
>> + * @sd: pointer to &struct v4l2_subdev
>> + */
>> +int __must_check v4l2_device_register_subdev_node(struct v4l2_device *v4l2_dev,
>> +						  struct v4l2_subdev *sd);
>> +
>>  /**
>>   * v4l2_device_register_subdev_nodes - Registers device nodes for all subdevs
>>   *	of the v4l2 device that are marked with
> 

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
