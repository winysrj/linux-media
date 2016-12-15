Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38387
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932876AbcLORvi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 12:51:38 -0500
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references
 as needed
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <20161109154608.1e578f9e@vento.lan>
 <20161213102447.60990b1c@vento.lan>
 <20161215113041.GE16630@valkosipuli.retiisi.org.uk>
 <7529355.zfqFdROYdM@avalon> <896ef36c-435e-6899-5ae8-533da7731ec1@xs4all.nl>
 <fa996ec5-0650-9774-7baf-5eaca60d76c7@osg.samsung.com>
 <47bf7ca7-2375-3dfa-775c-a56d6bd9dabd@xs4all.nl>
 <ea29010f-ffdc-f10f-8b4f-fb1337320863@osg.samsung.com>
 <2f5a7ca0-70d1-c6a9-9966-2a169a62e405@xs4all.nl>
 <b83be9ed-5ce3-3667-08c8-2b4d4cd047a0@osg.samsung.com>
 <20161215152501.11ce2b2a@vento.lan>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <3023f381-1141-df8f-c1ae-2bff36d688ca@osg.samsung.com>
Date: Thu, 15 Dec 2016 10:51:35 -0700
MIME-Version: 1.0
In-Reply-To: <20161215152501.11ce2b2a@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/2016 10:25 AM, Mauro Carvalho Chehab wrote:
> Em Thu, 15 Dec 2016 10:09:53 -0700
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> On 12/15/2016 09:28 AM, Hans Verkuil wrote:
>>> On 15/12/16 17:06, Shuah Khan wrote:  
> 
>>>
>>> I think this will work for interface entities, but for subdev entities this
>>> certainly won't work. Unbinding subdevs should be blocked (just set
>>> suppress_bind_attrs to true in all subdev drivers). Most top-level drivers
>>> have pointers to subdev data, so unbinding them will just fail horribly.
>>>   
>>
>> Yes that is an option. I did something similar for au0828 and snd_usb_audio
>> case, so the module that registers the media_device can't unbound until the
>> other driver. If au0828 registers media_device, it becomes the owner and if
>> it gets unbound ioctls will start to see problems.

Sorry I meant to say rmmod'ed not unbound. Unbound will work just fine. If the
modules that owns the media_devnode goes away, there will be problems with
cdev trying to load module when application closes the device file and exits.
In this case, Media Device Allocator API takes module reference, so its use
count goes up.

>>
>> What this means though is that drivers can't be unbound easily. But that is
>> a small price to pay compared to the problems we will see if a driver is
>> unbound when its entities are still in use. Also, unsetting bind_attrs has
>> to be done as well, otherwise we can never unbind any driver.
> 
> I don't think suppress_bind_attrs will work on USB drivers, as the
> device can be physically removed. 
> 

Yeah setting suppress_bind_attrs would cause problems. On one hand keeping
all entities until all references are gone sound like a good option, however
this would cause problems coordinating removal especially in the case of
embedded entities. Can this be done in a simpler way? The way I see it, we
have /dev/video, /dev/dvb, /dev/snd/* etc. that depend on /dev/media for
graph nodes. Any one of these devices could be open when any of the drivers
is unbound (physical removal is a simpler case).

Would it make sense to enforce that dependency. Can we tie /dev/media usecount
to /dev/video etc. usecount? In other words:

/dev/video is opened, then open /dev/media.
prevent entities being removed if /dev/media is open.

Would that help. The above could be done in a generic way possibly. Would it
help if /dev/media is kept open when streaming is active? That is just one
use-case, there might be others.

thanks,
-- Shuah


thanks,
-- Shuah

