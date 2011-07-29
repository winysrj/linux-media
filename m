Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab1G2EDB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 00:03:01 -0400
Message-ID: <4E3230EE.7040602@redhat.com>
Date: Fri, 29 Jul 2011 01:02:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
References: <4E303E5B.9050701@samsung.com> <4E30CFBB.1050009@redhat.com> <4E313563.8090900@samsung.com> <4E316218.30904@redhat.com> <4E31E960.1080008@gmail.com>
In-Reply-To: <4E31E960.1080008@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-07-2011 19:57, Sylwester Nawrocki escreveu:
> On 07/28/2011 03:20 PM, Mauro Carvalho Chehab wrote:

>> Accumulating sub-dev controls at the video node is the right thing to do.
>>
>> An MC-aware application will need to handle with that, but that doesn't sound to
>> be hard. All such application would need to do is to first probe the subdev controls,
>> and, when parsing the videodev controls, not register controls with duplicated ID's,
>> or to mark them with some special attribute.
> 
> IMHO it's not a big issue in general. Still, both subdev and the host device may 
> support same control id. And then even though the control ids are same on the subdev
> and the host they could mean physically different controls (since when registering 
> a subdev at the host driver the host's controls take precedence and doubling subdev
> controls are skipped).

True, but, except for specific usecases, the host control is enough.

> Also there might be some preference at user space, at which stage of the pipeline
> to apply some controls. This is where the subdev API helps, and plain video node
> API does not.

Again, this is for specific usecases. On such cases, what is expected is that the more
generic control will be exported via V4L2 API.

>>
>>> Thus it's a bit hard to imagine that we could do something like "optionally
>>> not to inherit controls" as the subdev/MC API is optional. :)
>>
>> This was actually implemented. There are some cases at ivtv/cx18 driver where both
>> the bridge and a subdev provides the same control (audio volume, for example). The
>> idea is to allow the bridge driver to touch at the subdev control without exposing
>> it to userspace, since the desire was that the bridge driver itself would expose
>> such control, using a logic that combines changing the subdev and the bridge registers
>> for volume.
> 
> This seem like hard coding a policy in the driver;) Then there is no way (it might not
> be worth the effort though) to play with volume level at both devices, e.g. to obtain
> optimal S/N ratio.

In general, playing with just one control is enough. Andy had a different opinion
when this issue were discussed, and he thinks that playing with both is better.
At the end, this is a developers decision, depending on how much information 
(and bug reports) he had.

> This is a hack...sorry, just joking ;-) Seriously, I think the
> situation with the userspace subdevs is a bit different. Because with one API we
> directly expose some functionality for applications, with other we code it in the
> kernel, to make the devices appear uniform at user space.

Not sure if I understood you. V4L2 export drivers functionality to userspace in an
uniform way. MC api is for special applications that might need to access some
internal functions on embedded devices.

Of course, there are some cases where it doesn't make sense to export a subdev control
via V4L2 API.

>>> Also, the sensor subdev can be configured in the video node driver as well as
>>> through the subdev device node. Both APIs can do the same thing but in order
>>> to let the subdev API work as expected the video node driver must be forbidden
>>> to configure the subdev.
>>
>> Why? For the sensor, a V4L2 API call will look just like a bridge driver call.
>> The subdev will need a mutex anyway, as two MC applications may be opening it
>> simultaneously. I can't see why it should forbid changing the control from the
>> bridge driver call.
> 
> Please do not forget there might be more than one subdev to configure and that
> the bridge itself is also a subdev (which exposes a scaler interface, for instance).
> A situation pretty much like in Figure 4.4 [1] (after the scaler there is also
> a video node to configure, but we may assume that pixel resolution at the scaler
> pad 1 is same as at the video node). Assuming the format and crop configuration 
> flow is from sensor to host scaler direction, if we have tried to configure _all_
> subdevs when the last stage of the pipeline is configured (i.e. video node) 
> the whole scaler and crop/composition configuration we have been destroyed at
> that time. And there is more to configure than VIDIOC_S_FMT can do.

Think from users perspective: all user wants is to see a video of a given resolution.
S_FMT (and a few other VIDIOC_* calls) have everything that the user wants: the
desired resolution, framerate and format.

Specialized applications indeed need more, in order to get the best images for
certain types of usages. So, MC is there.

Such applications will probably need to know exactly what's the sensor, what are
their bugs, how it is connected, what are the DSP blocks in the patch, how the
DSP algorithms are implemented, etc, in order to obtain the the perfect image.

Even on embedded devices like smartphones and tablets, I predict that both
types of applications will be developed and used: people may use a generic
application like flash player, and an specialized application provided by
the manufacturer. Users can even develop their own applications generic 
apps using V4L2 directly, at the devices that allow that.

As I said before: both application types are welcome. We just need to warrant 
that a pure V4L application will work reasonably well.

> Allowing the bridge driver to configure subdevs at all times would prevent
> the subdev/MC API to work. 

Well, then we need to think on an alternative for that. It seems an interesting
theme for the media workshop at the Kernel Summit/2011.

>>> There is a conflict there that in order to use
>>> 'optional' API the 'main' API behaviour must be affected....
>>
>> It is optional from userspace perspective. A V4L2-only application should be able
>> to work with all drivers. However, a MC-aware application will likely be specific
>> for some hardware, as it will need to know some device-specific stuff.
>>
>> Both kinds of applications are welcome, but dropping support for V4L2-only applications
>> is the wrong thing to do.
>>
>>> And I really cant use V4L2 API only as is because it's too limited.
>>
>> Why?
> 
> For instance there is really yet no support for scaler and composition onto
> a target buffer in the Video Capture Interface (we also use sensors with 
> built in scalers). It's difficult to efficiently manage capture/preview pipelines.
> It is impossible to discover the system topology.

Scaler were always supported by V4L2: if the resolution specified by S_FMT is not
what the sensor provides, then scale. All non-embedded drivers with sensor or bridge
supports scale does that.

Composition is not properly supported yet. It could make sense to add it to V4L. How do you
think MC API would help with composite?

Managing capture/preview pipelines will require some support at V4L2 level. This is
a problem that needs to be addressed there anyway, as buffers for preview/capture
need to be allocated. There's an RFC about that, but I don't think it covers the
pipelines for it.

Discovering the system topology indeed is not part of V4L2 API and will never be.
This is MC API business. There's no overlap with V4L2.

>>> Might be that's why I see more and more often migration to OpenMAX recently.
>>
>> I don't think so. People may be adopting OpenMAX just because of some marketing strategy
>> from the OpenMAX forum. We don't spend money to announce V4L2 ;)
> 
> :) 
> 
>>
>> I think that writing a pure OpenMAX driver is the wrong thing to do, as, at the long
>> term, it will cost _a_lot_ for the vendors to maintain something that will never be
>> merged upstream.
> 
> In general it depends on priorities. For some chip vendors it might be more important
> to provide a solution in short time frame. Getting something in mainline isn't effortless
> and spending lot's of time on this for some parties is unacceptable.

Adding something at a forum like OpenMAX is probably not an easy task ;) It generally
takes a long time to change something on open forum specifications. Also, participating 
on those forums require lots of money, with membership and travel expenses.

Adding a new driver that follows the API's is not a long-term effort. The delay is 
basically one kernel cycle, e. g. about 3-4 months.

Most of the delays on merging drivers for embedded systems, however, take a
way longer than that, unfortunately. From what I see, what is delaying driver
submission is due to:
	- the lack of how to work with the Linux community. Some developers take a
long time to get the 'modus operandi';
	- the need of API changes. It is still generally faster to add a new API 
addition at the Kernel than on an open forum;
	- the discussions inside the various teams (generally from the same company,
or the company and their customers) about the better way to implement some feature.

All the above also happens when developing an OpenMAX driver: companies need to
learn how to work with the OpenMax forums, API changes may be required, so they
need to participate at the forums, the several internal teams and customers
will be discussing the requirements.

I bet that there's also one additional step: to submit the driver to some company
that will check the driver compliance with the official API. Such certification
process is generally expensive and takes a long time.

At the end of the day, they'll also spend a lot of time to have the driver done,
or they'll end by releasing a "not-quite-openmax" driver, and then needing to
rework on that, due to customers complains, or to certification-compliance,
loosing time and money.

Regards,
Mauro.
