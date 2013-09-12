Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30460 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3ILKTd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 06:19:33 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MT000HP8CMARA70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 12 Sep 2013 11:19:31 +0100 (BST)
Message-id: <52319531.8040709@samsung.com>
Date: Thu, 12 Sep 2013 12:19:29 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH] V4L: Drop meaningless video_is_registered() call in
 v4l2_open()
References: <1375446449-27066-1-git-send-email-s.nawrocki@samsung.com>
 <51FBAD74.6060603@xs4all.nl> <52027AB7.5080006@samsung.com>
 <520288C1.7040207@xs4all.nl> <522906CD.1000006@gmail.com>
 <522D8FDF.3030006@xs4all.nl> <52306B2D.8060503@samsung.com>
 <523077CE.5070300@xs4all.nl>
In-reply-to: <523077CE.5070300@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 09/11/2013 04:01 PM, Hans Verkuil wrote:
> On 09/11/2013 03:07 PM, Sylwester Nawrocki wrote:
>> On 09/09/2013 11:07 AM, Hans Verkuil wrote:
>>> On 09/06/2013 12:33 AM, Sylwester Nawrocki wrote:
>>>> On 08/07/2013 07:49 PM, Hans Verkuil wrote:
>>>>> On 08/07/2013 06:49 PM, Sylwester Nawrocki wrote:
>>>>>> On 08/02/2013 03:00 PM, Hans Verkuil wrote:
>>>>>>> On 08/02/2013 02:27 PM, Sylwester Nawrocki wrote:
[...]
>>>> So there is lots of things that may fail after first video node is 
>>>> registered, and on which open() may be called immediately.
>>>
>>> The only solution I know off-hand to handle this safely is to unregister all
>>> nodes if some fail, but to return 0 in the probe function. If an open() succeeded,
>>> then that will just work until the node is closed, at which point the v4l2_device
>>> release() is called and you can cleanup.
>>
>> Another solution would be to properly implement struct video_device::release()
>> callback and in video device open() do video_is_registered() check while
>> holding the driver private video device lock. Also video_unregister_device()
>> would need to be called while holding the video device lock.
> 
> How would that help?

By not allowing video_unregister_device() call in the middle of the file op and
serializing whatever does video device unregistration with the file ops. I'm not
sure it is possible in all cases.

For ioctls it's already party taken care of by video_is_registered() check while 
holding the video dev mutex. For other file ops drivers currently need to do 
various checks to ensure that all driver private data/resources that may be needed 
in the file operations callbacks are in place.

[...]
>>> Is this 'could fail', or 'I have seen it fail'? I have never seen problems in probe()
>>> with node creation. The only reason I know of why creating a node might fail is
>>> being out-of-memory.
>>
>> In my case it was top level driver that was triggering device node creation
>> in its probe() and if, e.g. some of sub-device's driver was missing, it called,
>> through subdev internal unregistered(), op video_unregister_device(), but also
>> media_entity_cleanup() which seemed to be the source of trouble.
> 
> Device nodes should always be created at the very end after all other setup
> actions (like loaded subdev drivers) have been done successfully. From your
> description it seems that device nodes were created earlier? 

Yes, let me explain in what configuration it happens (perhaps looking at 
fimc_md_probe() function at drives/media/platform/exynos4-is/media-dev.c makes
it easier to understand; the version closer to what we work with currently
is available at [1]).

There are multiple platform devices that in their driver's probe() just 
initialize the driver private data and platform device resources, like irq, 
IO register, etc.

There is also a top level driver (struct v4l2_device) that walks through 
Device Tree and registers those platform devices as v4l2 subdevs. While 
doing that video nodes are created in some subdevs' .registered() callbacks.

After that image sensors are being registered.

Some platform devices need to be registered before image sensors, due to 
resource dependencies. E.g. some device need to be activated so clock for 
an image sensor is available at an SoC output pin.

So this is a bit more complex issue than with a single device, a single 
driver and its probe() interaction with the file ops.

[1] git.linuxtv.org/snawrocki/samsung.git/v3.11-rc2-dts-exynos4-is-clk

--
Regards,
Sylwester
