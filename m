Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35845 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab2KATdx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2012 15:33:53 -0400
Message-ID: <5092CE9C.1090509@gmail.com>
Date: Thu, 01 Nov 2012 20:33:48 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/2] media: V4L2: support asynchronous subdevice registration
References: <Pine.LNX.4.64.1210192358520.28993@axis700.grange> <2556759.AhNR6Lm65l@avalon> <Pine.LNX.4.64.1211011553560.19489@axis700.grange> <201211011715.07726.hverkuil@xs4all.nl>
In-Reply-To: <201211011715.07726.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/01/2012 05:15 PM, Hans Verkuil wrote:
> On Thu November 1 2012 16:01:59 Guennadi Liakhovetski wrote:
>> On Thu, 1 Nov 2012, Laurent Pinchart wrote:
>>> On Monday 22 October 2012 17:22:16 Hans Verkuil wrote:
>>>> On Mon October 22 2012 16:48:05 Guennadi Liakhovetski wrote:
>>>>> On Mon, 22 Oct 2012, Hans Verkuil wrote:
>>>>>> On Mon October 22 2012 14:50:14 Guennadi Liakhovetski wrote:
>>>>>>> On Mon, 22 Oct 2012, Hans Verkuil wrote:
>>>>>>>> On Mon October 22 2012 13:08:12 Guennadi Liakhovetski wrote:
>>>>>>>>> On Mon, 22 Oct 2012, Hans Verkuil wrote:
>>>>>>>>>> On Sat October 20 2012 00:20:24 Guennadi Liakhovetski wrote:
>>>>>>>>>>> Currently bridge device drivers register devices for all
>>>>>>>>>>> subdevices synchronously, tupically, during their probing.
>>>>>>>>>>> E.g. if an I2C CMOS sensor is attached to a video bridge
>>>>>>>>>>> device, the bridge driver will create an I2C device and wait
>>>>>>>>>>> for the respective I2C driver to probe. This makes linking of
>>>>>>>>>>> devices straight forward, but this approach cannot be used
>>>>>>>>>>> with intrinsically asynchronous and unordered device
>>>>>>>>>>> registration systems like the Flattened Device Tree. To
>>>>>>>>>>> support such systems this patch adds an asynchronous subdevice
>>>>>>>>>>> registration framework to V4L2. To use it respective (e.g.
>>>>>>>>>>> I2C) subdevice drivers must request deferred probing as long
>>>>>>>>>>> as their bridge driver hasn't probed. The bridge driver during
>>>>>>>>>>> its probing submits a an arbitrary number of subdevice
>>>>>>>>>>> descriptor groups to the framework to manage. After that it
>>>>>>>>>>> can add callbacks to each of those groups to be called at
>>>>>>>>>>> various stages during subdevice probing, e.g. after
>>>>>>>>>>> completion. Then the bridge driver can request single groups
>>>>>>>>>>> to be probed, finish its own probing and continue its video
>>>>>>>>>>> subsystem configuration from its callbacks.
>>>>>>>>>>
>>>>>>>>>> What is the purpose of allowing multiple groups?
>>>>>>>>>
>>>>>>>>> To support, e.g. multiple sensors connected to a single bridge.
>>>>>>>>
>>>>>>>> So, isn't that one group with two sensor subdevs?
>>>>>>>
>>>>>>> No, one group consists of all subdevices, necessary to operate a
>>>>>>> single video pipeline. A simple group only contains a sensor. More
>>>>>>> complex groups can contain a CSI-2 interface, a line shifter, or
>>>>>>> anything else.
>>>>>>
>>>>>> Why? Why would you want to wait for completion of multiple groups? You
>>>>>> need all subdevs to be registered. If you split them up in multiple
>>>>>> groups, then you have to wait until all those groups have completed,
>>>>>> which only makes the bridge driver more complex. It adds nothing to the
>>>>>> problem that we're trying to solve.
>>>>>
>>>>> I see it differently. Firstly, there's no waiting.
>>>>
>>>> If they are independent, then that's true. But in almost all cases you need
>>>> them all. Even in cases where theoretically you can 'activate' groups
>>>> independently, it doesn't add anything. It's overengineering, trying to
>>>> solve a problem that doesn't exist.
>>>>
>>>> Just keep it simple, that's hard enough.
>>>
>>> I quite agree here. Sure, in theory groups could be interesting, allowing you
>>> to start using part of the pipeline before everything is properly initialized,
>>> or if a sensor can't be probed for some reason. In practice, however, I don't
>>> think we'll get any substantial gain in real use cases. I propose dropping the
>>> groups for now, and adding them later if we need to.
>>
>> Good, I need them now:-) These groups is what I map to /dev/video* nodes
>> in soc-camera and what corresponds to struct soc_camera_device objects.
>>
>> We need a way to identify how many actual "cameras" (be it decoders,
>> encoders, or whatever else end-devices) we have. And this information is
>> directly related to instantiating subdevices. You need information about
>> subdevices and their possible links - even if you use MC. You need to
>> know, that sensor1 is connected to bridge interface1 and sensor2 can be
>> connected to interfaces 2 and 3. Why do we want to handle this information
>> separately, if it is logically connected to what we're dealing with here
>> and handling it here is simple and natural?
>
> Because these are two separate problems. Determining which sensor is connected
> to which bridge interface should be defined in the device tree and is reflected
> in the topology reported by the media controller. None of this has anything to
> do with the asynchronous subdev registration.
>
> Your 'group' concept seems to be 1) very vague :-) and 2) specific to soc-camera.
> But even for soc-camera I don't see what advantage the group concept brings you
> with respect to async registration.

+1

Regards,
Sylwester
