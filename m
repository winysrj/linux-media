Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52691 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab1G1KJn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 06:09:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LP100A28G858C10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 28 Jul 2011 11:09:41 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LP100J53G84JD@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 28 Jul 2011 11:09:40 +0100 (BST)
Date: Thu, 28 Jul 2011 12:09:39 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
In-reply-to: <4E30CFBB.1050009@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <4E313563.8090900@samsung.com>
References: <4E303E5B.9050701@samsung.com> <4E30CFBB.1050009@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 07/28/2011 04:55 AM, Mauro Carvalho Chehab wrote:
> Hi Sylwester,
> 
> Em 27-07-2011 13:35, Sylwester Nawrocki escreveu:
>> Hi Mauro,
>>
>> The following changes since commit f0a21151140da01c71de636f482f2eddec2840cc:
>>
>>   Merge tag 'v3.0' into staging/for_v3.1 (2011-07-22 13:33:14 -0300)
>>
>> are available in the git repository at:
>>
>>   git://git.infradead.org/users/kmpark/linux-2.6-samsung fimc-for-mauro
>>
>> Sylwester Nawrocki (28):
>>       s5p-fimc: Add support for runtime PM in the mem-to-mem driver
>>       s5p-fimc: Add media entity initialization
>>       s5p-fimc: Remove registration of video nodes from probe()
>>       s5p-fimc: Remove sclk_cam clock handling
>>       s5p-fimc: Limit number of available inputs to one
>>       s5p-fimc: Remove sensor management code from FIMC capture driver
>>       s5p-fimc: Remove v4l2_device from video capture and m2m driver
>>       s5p-fimc: Add the media device driver
>>       s5p-fimc: Conversion to use struct v4l2_fh
>>       s5p-fimc: Conversion to the control framework
>>       s5p-fimc: Add media operations in the capture entity driver
>>       s5p-fimc: Add PM helper function for streaming control
>>       s5p-fimc: Correct color format enumeration
>>       s5p-fimc: Convert to use media pipeline operations
>>       s5p-fimc: Add subdev for the FIMC processing block
>>       s5p-fimc: Add support for camera capture in JPEG format
>>       s5p-fimc: Add v4l2_device notification support for single frame capture
>>       s5p-fimc: Use consistent names for the buffer list functions
>>       s5p-fimc: Add runtime PM support in the camera capture driver
>>       s5p-fimc: Correct crop offset alignment on exynos4
>>       s5p-fimc: Remove single-planar capability flags
>>       noon010pc30: Do not ignore errors in initial controls setup
>>       noon010pc30: Convert to the pad level ops
>>       noon010pc30: Clean up the s_power callback
>>       noon010pc30: Remove g_chip_ident operation handler
>>       s5p-csis: Handle all available power supplies
>>       s5p-csis: Rework of the system suspend/resume helpers
>>       s5p-csis: Enable v4l subdev device node
> 
> From the last time you've submitted a similar set of patches:
> 
>>> Why? The proper way to select an input is via S_INPUT. The driver 
>> may also
>>> optionally allow changing it via the media device, but it should 
>> not be
>>> a mandatory requirement, as the media device API is optional.
>>
>> The problem I'm trying to solve here is sharing the sensors and
>> mipi-csi receivers between multiple FIMC H/W instances. Previously
>> the driver supported attaching a sensor to only one selected FIMC
>> at compile time. You could, for instance, specify all sensors as
>> the selected FIMC's platform data and then use S_INPUT to choose
>> between them. The sensor could not be used together with any other
>> FIMC. But this is desired due to different capabilities of the FIMC
>> IP instances. And now, instead of hardcoding a sensor assigment to
>> particular video node, the sensors are bound to the media device.
>> The media device driver takes the list of sensors and attaches them
>> one by one to subsequent FIMC instances when it is initializing. Each
>> sensor has a link to each FIMC but only one of them is active by 
>> default. That said an user application can use selected camera by
>> opening corresponding video node. Which camera is at which node
>> can be queried with G_INPUT.
>>
>> I could try to implement the previous S_INPUT behaviour, but IMHO this
>> would lead to considerable and unnecessary driver code complication due
>> to supporting overlapping APIs
> 
> From this current pull request:
> 
> From c6fb462c38be60a45d16a29a9e56c886ee0aa08c Mon Sep 17 00:00:00 2001
> From: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Date: Fri, 10 Jun 2011 20:36:51 +0200
> Subject: s5p-fimc: Conversion to the control framework
> Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> Make the driver inherit sensor controls when video node only API
> compatibility mode is enabled. The control framework allows to
> properly handle sensor controls through controls inheritance when
> pipeline is re-configured at media device level.
> 
> ...
> -       .vidioc_queryctrl               = fimc_vidioc_queryctrl,
> -       .vidioc_g_ctrl                  = fimc_vidioc_g_ctrl,
> -       .vidioc_s_ctrl                  = fimc_cap_s_ctrl,
> ...
> 
> I'll need to take some time to review this patchset. So, it will likely
> miss the bus for 3.1.

OK, thanks for your time!

> 
> While the code inside this patch looked ok, your comments scared me ;)

I didn't mean to scare you, sorry ;)

> 
> In summary: The V4L2 API is not a legacy API that needs a "compatibility
> mode". Removing controls like VIDIOC_S_INPUT, VIDIOC_*CTRL, etc in
> favor of the media controller API is wrong. This specific patch itself seems

Yes, it's the second time you say MC API is only optional;) I should
had formulated the summary from the other point of view. I wrote this
in context of two: V4L2 and MC API compatibility modes. Perhaps not too
fortunate wording.

> ok, but it is easy to loose the big picture on a series of 28 patches
> with about 4000 lines changed.

Yes, I agree. You really have to look carefully at the final result too.

When it comes to controls, as you might know, I didn't remove any
functionality. Although the ioctl handlers are gotten rid of in the driver,
they are handled in the control framework.
That's a complete patch:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/commitdiff/c6fb462c38be60a45d16a29a9e56c886ee0aa08c

For the full picture it should be noticed that the control ops are created
and the control handler is assigned to a video device node:

...
+
+static const struct v4l2_ctrl_ops fimc_ctrl_ops = {
+       .s_ctrl = fimc_s_ctrl,
+};
...
        .vidioc_cropcap                 = fimc_cap_cropcap,
@@ -727,6 +724,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
        if (ret)
                goto err_ent;

+       vfd->ctrl_handler = &ctx->ctrl_handler;
...

and then in v4l2-ioctl.c all the control ioctl are still handled:

...
	/* --- controls ---------------------------------------------- */
	case VIDIOC_QUERYCTRL:
	{
		struct v4l2_queryctrl *p = arg;

		if (vfh && vfh->ctrl_handler)
			ret = v4l2_queryctrl(vfh->ctrl_handler, p);
		else if (vfd->ctrl_handler)
			ret = v4l2_queryctrl(vfd->ctrl_handler, p);
		else if (ops->vidioc_queryctrl)
			ret = ops->vidioc_queryctrl(file, fh, p);
...

So, as far as controls are concerned, there is no functionality removal,
especially in favour of the MC API. This is just (hopefully) proper
integration with the control framework ;]

> 
> The media controller API is meant to be used only by specific applications
> that might add some extra features to the driver. So, it is an optional
> API. In all cases where both API's can do the same thing, the proper way 
> is to use the V4L2 API only, and not the media controller API.

Yes I continually keep that in mind. But there are some corner cases when
things are not so obvious, e.g. normally a video node inherits controls
from a sensor subdev. So all the controls are available at the video node.

But when using the subdev API, the right thing to do at the video node is not
to inherit sensor's controls. You could of course accumulate all controls at
video node at all times, such as same (sensor subdev's) controls are available
at /dev/video* and /dev/v4l-subdev*. But this is confusing to MC API aware
application which could wrongly assume that there is more controls at the host
device than there really is.

Thus it's a bit hard to imagine that we could do something like "optionally
not to inherit controls" as the subdev/MC API is optional. :)

Also, the sensor subdev can be configured in the video node driver as well as
through the subdev device node. Both APIs can do the same thing but in order
to let the subdev API work as expected the video node driver must be forbidden
to configure the subdev. There is a conflict there that in order to use 
'optional' API the 'main' API behaviour must be affected....
And I really cant use V4L2 API only as is because it's too limited.
Might be that's why I see more and more often migration to OpenMAX recently.

> 
> So, my current plan is to merge the patches into an experimental tree, after
> reviewing the changeset, and test against a V4L2 application, in order to
> confirm that everything is ok.

Sure, thanks. Basically I have been testing with same application before
and after the patchset. Tomasz also tried his libv4l2 mplane patches with
this reworked driver. So in general I do not expect any surprises, but
the testing can only help us:)

> 
> I may need a couple weeks for doing that, as it will take some time for me
> to have an available window for hacking with it.

At first I need to provide you with the board setup patches for smdkv310, in order
to make m5mols camera work on this board. I depend on others to make this job
and this is taking painfully long time. Maybe after the upcomning Linaro Connect
I'll get things speed up.

---
Best regards,
Sylwester
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
