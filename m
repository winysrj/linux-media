Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:58285 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727015AbeI0QkO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 12:40:14 -0400
Subject: Re: [PATCH 0/2] media: intel-ipu3: allow the media graph to be used
 even if a subdev fails
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Javier Martinez Canillas <javierm@redhat.com>,
        linux-kernel@vger.kernel.org,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>, linux-media@vger.kernel.org
References: <20180904113018.14428-1-javierm@redhat.com>
 <0e31ae40-276e-22be-c6aa-b62f8dbea79e@xs4all.nl>
 <20180927071330.1fa3cfdd@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <865b545d-3c3a-a2d3-4c1b-2a5b41a7ff37@xs4all.nl>
Date: Thu, 27 Sep 2018 12:22:37 +0200
MIME-Version: 1.0
In-Reply-To: <20180927071330.1fa3cfdd@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/27/2018 12:13 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 27 Sep 2018 11:52:35 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> Hi Javier,
>>
>> On 09/04/2018 01:30 PM, Javier Martinez Canillas wrote:
>>> Hello,
>>>
>>> This series allows the ipu3-cio2 driver to properly expose a subset of the
>>> media graph even if some drivers for the pending subdevices fail to probe.
>>>
>>> Currently the driver exposes a non-functional graph since the pad links are
>>> created and the subdev dev nodes are registered in the v4l2 async .complete
>>> callback. Instead, these operations should be done in the .bound callback.
>>>
>>> Patch #1 just adds a v4l2_device_register_subdev_node() function to allow
>>> registering a single device node for a subdev of a v4l2 device.
>>>
>>> Patch #2 moves the logic of the ipu3-cio2 .complete callback to the .bound
>>> callback. The .complete callback is just removed since is empy after that.  
>>
>> Sorry, I missed this series until you pointed to it on irc just now :-)
>>
>> I have discussed this topic before with Sakari and Laurent. My main problem
>> with this is how an application can discover that not everything is online?
>> And which parts are offline?
> 
> Via the media controller? It should be possible for an application to see
> if a videonode is missing using it.
> 
>> Perhaps a car with 10 cameras can function with 9, but not with 8. How would
>> userspace know?
> 
> I guess this is not the only case where someone submitted a patch for
> a driver that would keep working if some device node registration fails.
> 
> It could be just déjà vu, but I have a vague sensation that I merged something 
> similar to it in the past on another driver, but I can't remember any details.
> 
>>
>> I completely agree that we need to support these advanced scenarios (including
>> what happens when a camera suddenly fails), but it is the userspace aspects
>> for which I would like to see an RFC first before you can do these things.
> 
> Dynamic runtime fails should likely rise some signal. Perhaps a sort of
> media controller event?

See this old discussion: https://patchwork.kernel.org/patch/9849317/

My point is that someone needs to think about this and make a proposal.
There may well be a simple approach, but it needs to be specced first.

Regards,

	Hans

> 
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>> Best regards,
>>> Javier
>>>
>>>
>>> Javier Martinez Canillas (2):
>>>   [media] v4l: allow to register dev nodes for individual v4l2 subdevs
>>>   media: intel-ipu3: create pad links and register subdev nodes at bound
>>>     time
>>>
>>>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 66 ++++++-----------
>>>  drivers/media/v4l2-core/v4l2-device.c    | 90 ++++++++++++++----------
>>>  include/media/v4l2-device.h              | 10 +++
>>>  3 files changed, 85 insertions(+), 81 deletions(-)
>>>   
>>
> 
> 
> 
> Thanks,
> Mauro
> 
