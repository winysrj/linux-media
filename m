Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51586 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbeI0RWO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 13:22:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id y25-v6so5445363wmi.1
        for <linux-media@vger.kernel.org>; Thu, 27 Sep 2018 04:04:29 -0700 (PDT)
Subject: Re: [PATCH] media: intel-ipu3: cio2: register the mdev on v4l2 async
 notifier complete
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>
Cc: Bing Bu Cao <bingbu.cao@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20180831152045.9957-1-javierm@redhat.com>
 <cd307d41-ed19-5ab0-cbdb-a743cdb76e09@linux.intel.com>
 <c1e54228-a21a-b4a2-1083-c75b2dda797c@redhat.com>
 <b15b236e-e0a7-8b2f-1e1f-196c9dc04f4d@linux.intel.com>
 <44eb94a8-3712-155b-b3ab-35538f5b6b38@redhat.com>
 <F4B393EC1A37C8418714AECDAAEF72A93C9A39FC@shsmsx102.ccr.corp.intel.com>
 <20180904064605.6prcawieb4ooxtyl@paasikivi.fi.intel.com>
 <5c6944ec-ee1f-8be6-3eff-2c65fd888222@xs4all.nl>
From: Javier Martinez Canillas <javierm@redhat.com>
Message-ID: <c96b6681-89df-6dbf-f81d-512c016bae8f@redhat.com>
Date: Thu, 27 Sep 2018 13:04:26 +0200
MIME-Version: 1.0
In-Reply-To: <5c6944ec-ee1f-8be6-3eff-2c65fd888222@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks a lot for your feedback.

On 09/27/2018 12:09 PM, Hans Verkuil wrote:
> On 09/04/2018 08:46 AM, Sakari Ailus wrote:
>> Hi Javier, Tian Shu,
>>
>> On Tue, Sep 04, 2018 at 05:01:56AM +0000, Qiu, Tian Shu wrote:
>>> Hi,
>>>
>>> Raise my point.
>>> The case here is that we have multiple sensors connected to CIO2. The sensors work independently. So failure on one sensor should not block the function of the other.
>>> That is, we should not rely on that all sensors are ready before allowing user to operate on the ready cameras.
>>> Sometimes due to hardware issues or incompleteness, we did met the case that one sensor is not probing properly. And in this case, the current implementation blocks us using the working one.
>>> What I can think now to solve this are:
>>> 1. Register multiple media devices. One for each sensor path. This will increase media device count.
>>> 2. Use .bound callback to create the link and register the subdev node for each sensor. Leave .complete empty.
>>>      Not sure if this breaks the rule of media framework. And also have not found an API to register one single subdev node.
>>
>> I'd prefer to keep the driver as-is.
>>
>> Even if the media device is only created once all the sub-devices are
>> around, the devices are still created one by one so there's no way to
>> prevent the user space seeing a partially registered media device complex.
>>
>> In general that doesn't happen as the sensors are typically registered
>> early during system boot.
>>
>> Javier is right in asking a way for the user to know whether everything is
>> fully initialised. That should be added but I don't think it is in any way
>> specific to the cio2 driver.
>>
> 
> Today we have no userspace mechanism to deal with partially initialized topologies.
> Instead if parts fails to come up we shouldn't register any media device and
> instead (once we discover that something is broken) tear everything down.
> 
> In fact, video/subdev/media devices shouldn't be registered until everything is
> complete.
> 
> I know we want to allow for partial bring up as well, and I fully agree with that,
> but in that case someone needs to write an RFC with a proposal how userspace should
> handle this.
>

I'm OK with $SUBJECT to be merged until we have a mechanism to let user-space
know about the media topology state. Later we can revisit the patches in [0],
once we have that support.

[0]: https://patchwork.kernel.org/cover/10587183/

> We've discussed this in the past, but I have not seen such an RFC.
> 
> So until we add support for partial bringup I think this patch does the right
> thing since otherwise this is out-of-spec.
>

Does this mean I have your Acked-by?

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
