Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41582 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbeIDMQz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2018 08:16:55 -0400
Received: by mail-wr1-f66.google.com with SMTP id z96-v6so2856962wrb.8
        for <linux-media@vger.kernel.org>; Tue, 04 Sep 2018 00:52:58 -0700 (PDT)
Subject: Re: [PATCH] media: intel-ipu3: cio2: register the mdev on v4l2 async
 notifier complete
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
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
From: Javier Martinez Canillas <javierm@redhat.com>
Message-ID: <b8aab749-e734-c2e8-daa7-5377c2547bc3@redhat.com>
Date: Tue, 4 Sep 2018 09:52:54 +0200
MIME-Version: 1.0
In-Reply-To: <20180904064605.6prcawieb4ooxtyl@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,  Tian Shu,

On 09/04/2018 08:46 AM, Sakari Ailus wrote:
> Hi Javier, Tian Shu,
> 
> On Tue, Sep 04, 2018 at 05:01:56AM +0000, Qiu, Tian Shu wrote:
>> Hi,
>>
>> Raise my point.
>> The case here is that we have multiple sensors connected to CIO2. The sensors work independently. So failure on one sensor should not block the function of the other.
>> That is, we should not rely on that all sensors are ready before allowing user to operate on the ready cameras.
>> Sometimes due to hardware issues or incompleteness, we did met the case that one sensor is not probing properly. And in this case, the current implementation blocks us using the working one.

This is a valid concern, but unfortunately the media graph is created in a quite
static way currently: the port and enpoints are parsed in the hardware topology,
the driver waits for the subdevices to be registered and bound, and is notified
by the .complete callback when there aren't more pending devices to be registered.

With the current infrastructure, I think we have to wait to register the media
device node until all devices have been bound, even if that would mean a single
camera driver not probing will cause the media graph to not be available.

Probably the correct approach would be to allow the media graph to dynamically
change and notify the user when new nodes are added or deleted (currently we
prevent to remove modules for the devices bound to the media device).

>> What I can think now to solve this are:
>> 1. Register multiple media devices. One for each sensor path. This will increase media device count.
>> 2. Use .bound callback to create the link and register the subdev node for each sensor. Leave .complete empty.
>>      Not sure if this breaks the rule of media framework. And also have not found an API to register one single subdev node.
> 
> I'd prefer to keep the driver as-is.
> 
> Even if the media device is only created once all the sub-devices are
> around, the devices are still created one by one so there's no way to
> prevent the user space seeing a partially registered media device complex.
>

Yes, but at least the media device node won't be available.

> In general that doesn't happen as the sensors are typically registered
> early during system boot.
>

It's true if the drivers are built-in, but they can be built as modules.

The goal with this patch was to prevent having a media graph that's not
useful, for example I've a media graph with no sensors media entities
(because there are no drivers supporting the sensors on my machine).

I prefer not having a media node in that case, that way users can know
that something went wrong / some support is missing.

> Javier is right in asking a way for the user to know whether everything is
> fully initialised. That should be added but I don't think it is in any way
> specific to the cio2 driver.
>

I was thinking about using the presence of the media device node as an
indication that the media graph has been fully initialized. And I thought
that was the agreement that lead to the commit 9832e155f1ed ("[media]
media-device: split media initialization and registration").

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
