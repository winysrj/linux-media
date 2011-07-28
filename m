Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34799 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab1G1W5m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 18:57:42 -0400
Received: by fxh19 with SMTP id 19so1691405fxh.19
        for <linux-media@vger.kernel.org>; Thu, 28 Jul 2011 15:57:41 -0700 (PDT)
Message-ID: <4E31E960.1080008@gmail.com>
Date: Fri, 29 Jul 2011 00:57:36 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
References: <4E303E5B.9050701@samsung.com> <4E30CFBB.1050009@redhat.com> <4E313563.8090900@samsung.com> <4E316218.30904@redhat.com>
In-Reply-To: <4E316218.30904@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/28/2011 03:20 PM, Mauro Carvalho Chehab wrote:
>>> In summary: The V4L2 API is not a legacy API that needs a "compatibility
>>> mode". Removing controls like VIDIOC_S_INPUT, VIDIOC_*CTRL, etc in
>>> favor of the media controller API is wrong. This specific patch itself seems
>>
>> Yes, it's the second time you say MC API is only optional;) I should
>> had formulated the summary from the other point of view. I wrote this
>> in context of two: V4L2 and MC API compatibility modes. Perhaps not too
>> fortunate wording.
> 
> A clear patch description helps for reviewers to understand what, why and how
> the patch is doing. Sometimes, I write a one-line patch, together with a 30+
> lines of patch description. Especially on tricky patches, please be verbose
> at the descriptions.
> 
>>> ok, but it is easy to loose the big picture on a series of 28 patches
>>> with about 4000 lines changed.
>>
>> Yes, I agree. You really have to look carefully at the final result too.
>>
>> When it comes to controls, as you might know, I didn't remove any
>> functionality. Although the ioctl handlers are gotten rid of in the driver,
>> they are handled in the control framework.
> 
> Yes, I noticed, but, on a complex driver with several subdevs, it is not that
> simple to check where the controls are actually created, or if they require a
> MC API call to create them or not. Especially on patch series made by the

Sure, I fully understand.

> manufacturer, I generally don't spend much time to fully understand the driver logic,
> as I assume that the developers are doing the better to make the driver to work.
> My main concern is to be sure that the driver will be doing the right thing,
> in the light of the V4L2 API. The MC API made my work harder, as now, I need to
> check also if, for the device to work, it needs some MC API calls.
> 
> So, I have now 2 alternatives left:
>    a) to test with a device;
>    b) to fully understand the driver's logic.
> 
> Both are very time-consuming, but (a) is quicker, and safer, of course provided that
> I don't need to dig into several trees to get patches because not everything is not
> upstream yet.
> 
> This also means that I'll need the (complex) patches for devices with MC several weeks
> before the next merge window, to give me some time to open a window for testing.
> 
>>> The media controller API is meant to be used only by specific applications
>>> that might add some extra features to the driver. So, it is an optional
>>> API. In all cases where both API's can do the same thing, the proper way
>>> is to use the V4L2 API only, and not the media controller API.
>>
>> Yes I continually keep that in mind. But there are some corner cases when
>> things are not so obvious, e.g. normally a video node inherits controls
>> from a sensor subdev. So all the controls are available at the video node.
>>
>> But when using the subdev API, the right thing to do at the video node is not
>> to inherit sensor's controls. You could of course accumulate all controls at
>> video node at all times, such as same (sensor subdev's) controls are available
>> at /dev/video* and /dev/v4l-subdev*. But this is confusing to MC API aware
>> application which could wrongly assume that there is more controls at the host
>> device than there really is.
> 
> Accumulating sub-dev controls at the video node is the right thing to do.
> 
> An MC-aware application will need to handle with that, but that doesn't sound to
> be hard. All such application would need to do is to first probe the subdev controls,
> and, when parsing the videodev controls, not register controls with duplicated ID's,
> or to mark them with some special attribute.

IMHO it's not a big issue in general. Still, both subdev and the host device may 
support same control id. And then even though the control ids are same on the subdev
and the host they could mean physically different controls (since when registering 
a subdev at the host driver the host's controls take precedence and doubling subdev
controls are skipped).

Also there might be some preference at user space, at which stage of the pipeline
to apply some controls. This is where the subdev API helps, and plain video node
API does not.

> 
>> Thus it's a bit hard to imagine that we could do something like "optionally
>> not to inherit controls" as the subdev/MC API is optional. :)
> 
> This was actually implemented. There are some cases at ivtv/cx18 driver where both
> the bridge and a subdev provides the same control (audio volume, for example). The
> idea is to allow the bridge driver to touch at the subdev control without exposing
> it to userspace, since the desire was that the bridge driver itself would expose
> such control, using a logic that combines changing the subdev and the bridge registers
> for volume.

This seem like hard coding a policy in the driver;) Then there is no way (it might not
be worth the effort though) to play with volume level at both devices, e.g. to obtain
optimal S/N ratio. This is a hack...sorry, just joking ;-) Seriously, I think the
situation with the userspace subdevs is a bit different. Because with one API we
directly expose some functionality for applications, with other we code it in the
kernel, to make the devices appear uniform at user space.

> 
>> Also, the sensor subdev can be configured in the video node driver as well as
>> through the subdev device node. Both APIs can do the same thing but in order
>> to let the subdev API work as expected the video node driver must be forbidden
>> to configure the subdev.
> 
> Why? For the sensor, a V4L2 API call will look just like a bridge driver call.
> The subdev will need a mutex anyway, as two MC applications may be opening it
> simultaneously. I can't see why it should forbid changing the control from the
> bridge driver call.

Please do not forget there might be more than one subdev to configure and that
the bridge itself is also a subdev (which exposes a scaler interface, for instance).
A situation pretty much like in Figure 4.4 [1] (after the scaler there is also
a video node to configure, but we may assume that pixel resolution at the scaler
pad 1 is same as at the video node). Assuming the format and crop configuration 
flow is from sensor to host scaler direction, if we have tried to configure _all_
subdevs when the last stage of the pipeline is configured (i.e. video node) 
the whole scaler and crop/composition configuration we have been destroyed at
that time. And there is more to configure than VIDIOC_S_FMT can do.

Allowing the bridge driver to configure subdevs at all times would prevent
the subdev/MC API to work. 

> 
>> There is a conflict there that in order to use
>> 'optional' API the 'main' API behaviour must be affected....
> 
> It is optional from userspace perspective. A V4L2-only application should be able
> to work with all drivers. However, a MC-aware application will likely be specific
> for some hardware, as it will need to know some device-specific stuff.
> 
> Both kinds of applications are welcome, but dropping support for V4L2-only applications
> is the wrong thing to do.
> 
>> And I really cant use V4L2 API only as is because it's too limited.
> 
> Why?

For instance there is really yet no support for scaler and composition onto
a target buffer in the Video Capture Interface (we also use sensors with 
built in scalers). It's difficult to efficiently manage capture/preview pipelines.
It is impossible to discover the system topology.

> 
>> Might be that's why I see more and more often migration to OpenMAX recently.
> 
> I don't think so. People may be adopting OpenMAX just because of some marketing strategy
> from the OpenMAX forum. We don't spend money to announce V4L2 ;)

:) 

> 
> I think that writing a pure OpenMAX driver is the wrong thing to do, as, at the long
> term, it will cost _a_lot_ for the vendors to maintain something that will never be
> merged upstream.

In general it depends on priorities. For some chip vendors it might be more important
to provide a solution in short time frame. Getting something in mainline isn't effortless
and spending lot's of time on this for some parties is unacceptable.

> 
> On the other hand, a V4L2/MC<==>  OpenMAX abstraction layer/library at userspace makes
> sense, as it will open support for OpenMAX-aware userspace applications. Using an
> standard there would allow someone to write an application that would work on more
> than one operational system.

I think this is called OpenMAX IL (integration layer). And it seems it indeed makes
sense, given that a video4linux API isn't a bottleneck. I think with Media Controller
API it is not. MC API seems to be integrating quite nicely with OMX as IL.

> 
> Yet, if I would be requested to write a multi-OS application, I would probably be
> opting to write an OS-specific driver for each OS, as it would allow the application
> to be optimized for that OS. The OS-specific layer is the small part of such application.
> Btw, successfully xawtv does that, supporting both V4L2 and a BSD-specific API.
> The size of the driver corresponds to about 2.5% of the total size of the application.
> So, writing two or tree drivers won't have any significant impact at the TCO of such
> application, especially because maintaining a generic multi-OS driver requires much more
> time for debugging/testing/maintaining than a per-OS driver. But, of course, this
> is a matter of developer's taste.
> 
>>> So, my current plan is to merge the patches into an experimental tree, after
>>> reviewing the changeset, and test against a V4L2 application, in order to
>>> confirm that everything is ok.
>>
>> Sure, thanks. Basically I have been testing with same application before
>> and after the patchset. Tomasz also tried his libv4l2 mplane patches with
>> this reworked driver. So in general I do not expect any surprises,
> 
> Good to know.
> 
>> but the testing can only help us:)
>>
>>>
>>> I may need a couple weeks for doing that, as it will take some time for me
>>> to have an available window for hacking with it.
>>
>> At first I need to provide you with the board setup patches for smdkv310, in order
>> to make m5mols camera work on this board. I depend on others to make this job
>> and this is taking painfully long time. Maybe after the upcoming Linaro Connect
>> I'll get things speed up.
> 
> Ok. I'll be waiting for you.
> 
> Thanks!
> Mauro

[1] http://linuxtv.org/downloads/v4l-dvb-apis/subdev.html

---
Regards,
Sylwester
