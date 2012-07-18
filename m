Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37837 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab2GRTxj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 15:53:39 -0400
Message-ID: <5007143E.8040807@gmail.com>
Date: Wed, 18 Jul 2012 21:53:34 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com,
	Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [RFC/PATCH 05/13] media: s5p-fimc: Add device tree support for
 FIMC devices
References: <4FBFE1EC.9060209@samsung.com> <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com> <1337975573-27117-5-git-send-email-s.nawrocki@samsung.com> <Pine.LNX.4.64.1207161110430.12302@axis700.grange> <5005C7E4.3050908@gmail.com> <Pine.LNX.4.64.1207180958540.8472@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1207180958540.8472@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/18/2012 10:17 AM, Guennadi Liakhovetski wrote:
> On Tue, 17 Jul 2012, Sylwester Nawrocki wrote:
>> On 07/16/2012 11:13 AM, Guennadi Liakhovetski wrote:
>>> On Fri, 25 May 2012, Sylwester Nawrocki wrote:
>>>
>>>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>>>> Signed-off-by: Karol Lewandowski<k.lewandowsk@samsung.com>
>>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>>
>>>    From the documentation below I think, I understand what it does, but why
>>> is it needed? It doesn't describe your video subsystem topology, right?
>>> How various subdevices are connected. It just lists them all in one
>>> node... A description for this patch would be very welcome IMHO and,
>>> maybe, such a node can be completely avoided?
>>
>> Sorry, I'll provide better description in next iteration.
>> It's true it doesn't describe the topology in detail, as there are
>> multiple one-to many possible connections between sub-devices. An exact
>> topology is coded in the driver and can be changed through MC API.
>> The "samsung,camif-mux-id" and "video-bus-type" properties at "sensor"
>> nodes just specify to which physical SoC camera port an image sensor
>> is connected.
> 
> So, don't you think my media-link child nodes are a good solution for
> this?

Not quite yet ;) It would be good to see some example implementation
and how it actually works.

>> Originally the all camera devices were supposed to land under common
>> 'camera' node. And a top level driver would be registering all platform
>> devices. With this approach it would be possible to better control PM
>> handling (which currently depends on an order of registering devices to
>> the driver core). But then we discovered that we couldn't use OF_DEV_AUXDATA
>> in such case, which was required to preserve platform device names, in order
>> for the clock API to work. So I've moved some sub-devices out of 'camera'
>> node and have added only a list of phandles to them in that node. This is
>> rather a cheap workaround..
>>
>> I think all camera sub-devices should be placed under common node, as there
>> are some properties that don't belong to any sub-node: GPIO config, clocks,
>> to name a few. Of course simpler devices might not need such a composite
>> node. I think we can treat the sub-device interdependencies as an issue
>> separate from a need for a common node.
>>
>> If some devices need to reflect the topology better, we probably could
>> include in some nodes (a list of) phandles to other nodes. This could ease
>> parsing the topology at the drivers, by using existing OF infrastructure.
> 
> Ok, I think you have some good ideas in your RFC's, an interesting
> question now is - how to proceed. Do you think we'd be able to work out a
> combined RFC? Or would you prefer to make two versions and then see what
> others think? In either case it would be nice, I think, if you could try
> to separate what you see as common V4L DT bindings, then we could discuss
> that separately. Whereas what you think is private to your hardware, we
> can also look at for common ideas, or maybe even some of those properties
> we'll wake to make common too.

I think we need a one combined RFC and continue discussions in one thread.
Still, our proposals are quite different, but I believe we need something
in between. I presume we should focus more to have common bindings for 
subdevs that are reused among different host/ISP devices, i.e. sensors and 
encoders. For simple host interfaces we can likely come up with common
binding patterns, but more complex processing pipelines may require 
a sort of individual approach.

The suspend/resume handling is still something I don't have an idea
on how the solution for might look like..
Instantiating all devices from a top level driver could help, but it
is only going to work when platforms are converted to the common clock
framework and have their clocks instantiated from device tree.

This week I'm out of office, and next one or two I have some pending
assignments. So there might be some delay before I can dedicate some 
reasonable amount of time to carry on with that topic.

I unfortunately won't be attending KS this time.

I'll try to prepare some summary with topics that appear common. And also 
to restructure my RFC series to better separate new common features and 
specific H/W support.

In the meantime we could possibly continue discussions in your RFC thread.

--

Regards,
Sylwester
