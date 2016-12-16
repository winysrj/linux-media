Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53061 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760593AbcLPKLf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 05:11:35 -0500
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references
 as needed
To: Shuah Khan <shuahkh@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
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
 <3023f381-1141-df8f-c1ae-2bff36d688ca@osg.samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <150c057f-7ef8-30cb-07ca-885d4c2a4dcd@xs4all.nl>
Date: Fri, 16 Dec 2016 11:11:25 +0100
MIME-Version: 1.0
In-Reply-To: <3023f381-1141-df8f-c1ae-2bff36d688ca@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/12/16 18:51, Shuah Khan wrote:
> On 12/15/2016 10:25 AM, Mauro Carvalho Chehab wrote:
>> Em Thu, 15 Dec 2016 10:09:53 -0700
>> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
>>
>>> On 12/15/2016 09:28 AM, Hans Verkuil wrote:
>>>> On 15/12/16 17:06, Shuah Khan wrote:
>>
>>>>
>>>> I think this will work for interface entities, but for subdev entities this
>>>> certainly won't work. Unbinding subdevs should be blocked (just set
>>>> suppress_bind_attrs to true in all subdev drivers). Most top-level drivers
>>>> have pointers to subdev data, so unbinding them will just fail horribly.
>>>>
>>>
>>> Yes that is an option. I did something similar for au0828 and snd_usb_audio
>>> case, so the module that registers the media_device can't unbound until the
>>> other driver. If au0828 registers media_device, it becomes the owner and if
>>> it gets unbound ioctls will start to see problems.
>
> Sorry I meant to say rmmod'ed not unbound. Unbound will work just fine. If the
> modules that owns the media_devnode goes away, there will be problems with
> cdev trying to load module when application closes the device file and exits.
> In this case, Media Device Allocator API takes module reference, so its use
> count goes up.
>
>>>
>>> What this means though is that drivers can't be unbound easily. But that is
>>> a small price to pay compared to the problems we will see if a driver is
>>> unbound when its entities are still in use. Also, unsetting bind_attrs has
>>> to be done as well, otherwise we can never unbind any driver.
>>
>> I don't think suppress_bind_attrs will work on USB drivers, as the
>> device can be physically removed.
>>
>
> Yeah setting suppress_bind_attrs would cause problems. On one hand keeping
> all entities until all references are gone sound like a good option, however
> this would cause problems coordinating removal especially in the case of
> embedded entities. Can this be done in a simpler way? The way I see it, we
> have /dev/video, /dev/dvb, /dev/snd/* etc. that depend on /dev/media for
> graph nodes. Any one of these devices could be open when any of the drivers
> is unbound (physical removal is a simpler case).
>
> Would it make sense to enforce that dependency. Can we tie /dev/media usecount
> to /dev/video etc. usecount? In other words:
>
> /dev/video is opened, then open /dev/media.

When a device node is registered it should increase the refcount on the media_device
(as I proposed, that would be mdev->dev). When a device node is unregistered and the
last user disappeared, then it can decrease the media_device refcount.

So as long as anyone is using a device node, the media_device will stick around as
well.

No need to take refcounts on open/close.

One note: as I mentioned, the video_device does not set the cdev parent correctly,
so that bug needs to be fixed first for this to work.

> prevent entities being removed if /dev/media is open.
>
> Would that help. The above could be done in a generic way possibly. Would it
> help if /dev/media is kept open when streaming is active? That is just one

Again, it's not about the device nodes, it's about the media_device.

Regards,

	Hans

> use-case, there might be others.
>
> thanks,
> -- Shuah
>
>
> thanks,
> -- Shuah
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

