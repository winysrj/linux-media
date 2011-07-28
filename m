Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab1G1C4A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 22:56:00 -0400
Message-ID: <4E30CFBB.1050009@redhat.com>
Date: Wed, 27 Jul 2011 23:55:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
References: <4E303E5B.9050701@samsung.com>
In-Reply-To: <4E303E5B.9050701@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Em 27-07-2011 13:35, Sylwester Nawrocki escreveu:
> Hi Mauro,
> 
> The following changes since commit f0a21151140da01c71de636f482f2eddec2840cc:
> 
>   Merge tag 'v3.0' into staging/for_v3.1 (2011-07-22 13:33:14 -0300)
> 
> are available in the git repository at:
> 
>   git://git.infradead.org/users/kmpark/linux-2.6-samsung fimc-for-mauro
> 
> Sylwester Nawrocki (28):
>       s5p-fimc: Add support for runtime PM in the mem-to-mem driver
>       s5p-fimc: Add media entity initialization
>       s5p-fimc: Remove registration of video nodes from probe()
>       s5p-fimc: Remove sclk_cam clock handling
>       s5p-fimc: Limit number of available inputs to one
>       s5p-fimc: Remove sensor management code from FIMC capture driver
>       s5p-fimc: Remove v4l2_device from video capture and m2m driver
>       s5p-fimc: Add the media device driver
>       s5p-fimc: Conversion to use struct v4l2_fh
>       s5p-fimc: Conversion to the control framework
>       s5p-fimc: Add media operations in the capture entity driver
>       s5p-fimc: Add PM helper function for streaming control
>       s5p-fimc: Correct color format enumeration
>       s5p-fimc: Convert to use media pipeline operations
>       s5p-fimc: Add subdev for the FIMC processing block
>       s5p-fimc: Add support for camera capture in JPEG format
>       s5p-fimc: Add v4l2_device notification support for single frame capture
>       s5p-fimc: Use consistent names for the buffer list functions
>       s5p-fimc: Add runtime PM support in the camera capture driver
>       s5p-fimc: Correct crop offset alignment on exynos4
>       s5p-fimc: Remove single-planar capability flags
>       noon010pc30: Do not ignore errors in initial controls setup
>       noon010pc30: Convert to the pad level ops
>       noon010pc30: Clean up the s_power callback
>       noon010pc30: Remove g_chip_ident operation handler
>       s5p-csis: Handle all available power supplies
>       s5p-csis: Rework of the system suspend/resume helpers
>       s5p-csis: Enable v4l subdev device node

>From the last time you've submitted a similar set of patches:

>> Why? The proper way to select an input is via S_INPUT. The driver 
> may also
>> optionally allow changing it via the media device, but it should 
> not be
>> a mandatory requirement, as the media device API is optional.
> 
> The problem I'm trying to solve here is sharing the sensors and mipi-csi receivers between multiple FIMC H/W instances. Previously the driver supported attaching a sensor to only one selected FIMC at compile time. You could, for instance, specify all sensors as the selected FIMC's platform data and then use S_INPUT to choose between them. The sensor could not be used together with any other FIMC. But this is desired due to different capabilities of the FIMC IP instances. And now, instead of hardcoding a sensor assigment to particular video node, the sensors are bound to the media device. The media device driver takes the list of sensors and attaches them one by one to subsequent FIMC instances when it is initializing. Each sensor has a link to each FIMC but only one of them is active by default. That said an user application can use selected camera by opening corresponding video node. Which camera is at which node can be queried with G_INPUT.
> 
> I could try to implement the previous S_INPUT behaviour, but IMHO this would lead to considerable and unnecessary driver code complication due to supporting overlapping APIs

>From this current pull request:

>From c6fb462c38be60a45d16a29a9e56c886ee0aa08c Mon Sep 17 00:00:00 2001
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Date: Fri, 10 Jun 2011 20:36:51 +0200
Subject: s5p-fimc: Conversion to the control framework
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>

Make the driver inherit sensor controls when video node only API
compatibility mode is enabled. The control framework allows to
properly handle sensor controls through controls inheritance when
pipeline is re-configured at media device level.

...
-       .vidioc_queryctrl               = fimc_vidioc_queryctrl,
-       .vidioc_g_ctrl                  = fimc_vidioc_g_ctrl,
-       .vidioc_s_ctrl                  = fimc_cap_s_ctrl,
...

I'll need to take some time to review this patchset. So, it will likely
miss the bus for 3.1.

While the code inside this patch looked ok, your comments scared me ;)

In summary: The V4L2 API is not a legacy API that needs a "compatibility
mode". Removing controls like VIDIOC_S_INPUT, VIDIOC_*CTRL, etc in
favor of the media controller API is wrong. This specific patch itself seems
ok, but it is easy to loose the big picture on a series of 28 patches
with about 4000 lines changed.

The media controller API is meant to be used only by specific applications
that might add some extra features to the driver. So, it is an optional
API. In all cases where both API's can do the same thing, the proper way 
is to use the V4L2 API only, and not the media controller API.

So, my current plan is to merge the patches into an experimental tree, after
reviewing the changeset, and test against a V4L2 application, in order to
confirm that everything is ok.

I may need a couple weeks for doing that, as it will take some time for me
to have an available window for hacking with it.

Regards,
Mauro
