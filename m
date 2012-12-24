Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39095 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab2LXNXW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 08:23:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, Archit Taneja <archit@ti.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Inki Dae <inki.dae@samsung.com>,
	Jesse Barker <jesse.barker@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Tom Gall <tom.gall@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>
Subject: Re: [RFC v2 0/5] Common Display Framework
Date: Mon, 24 Dec 2012 14:24:45 +0100
Message-ID: <1454784.3gdgnzX4U2@avalon>
In-Reply-To: <CAPM=9txFJzJ0haTyBnr8hEmmqNb+gSAyBno+Zs0Z-qvVMTwz9A@mail.gmail.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <CAPM=9txFJzJ0haTyBnr8hEmmqNb+gSAyBno+Zs0Z-qvVMTwz9A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

On Tuesday 18 December 2012 15:04:02 Dave Airlie wrote:
> > Many developers showed interest in the first RFC, and I've had the
> > opportunity to discuss it with most of them. I would like to thank (in no
> > particular order) Tomi Valkeinen for all the time he spend helping me to
> > draft v2, Marcus Lorentzon for his useful input during Linaro Connect Q4
> > 2012, and Linaro for inviting me to Connect and providing a venue to
> > discuss this topic.
>
> So this might be a bit off topic but this whole CDF triggered me looking at
> stuff I generally avoid:
> 
> The biggest problem I'm having currently with the whole ARM graphics and
> output world is the proliferation of platform drivers for every little
> thing. The whole ordering of operations with respect to things like
> suspend/resume or dynamic power management is going to be a real nightmare
> if there are dependencies between the drivers.

We share the same concern, although my analysis of the problem is somewhat 
different. The power management ordering issues isn't only caused by the 
software architecture, but also comes from complex hardware requirements. The 
root cause, in my opinion, is the split control and data busses: as soon as a 
device sits on multiple busses and has power management ordering requirements 
related to those busses the Linux power management model breaks. Note that the 
problem isn't restricted to the display, we have run into the exact same 
issues years ago on the video capture side.

> How do you enforce ordering of s/r operations between all the various
> components?

The way we have handled this problem on the camera side is to use early 
suspend and late resume operations to handle the data (video) busses suspend 
and resume operations, and let the kernel handle the rest using the control 
bus based device tree model. The camera controller stops the video pipeline in 
its early suspend operation (and resumes it in the late resume operation) by 
calling operations provided by the entities (through function pointers of 
course, we don't want direct dependencies between the drivers). The control 
suspend/resume (such as sending a standby command through I2C to put the chip 
in low-power mode, or turning its power supply or clock off) is then handled 
by the PM core.

> The other thing I'd like you guys to do is kill the idea of fbdev and v4l
> drivers that are "shared" with the drm codebase, really just implement fbdev
> and v4l on top of the drm layer, some people might think this is some sort
> of maintainer thing, but really nothing else makes sense, and having these
> shared display frameworks just to avoid having using drm/kms drivers seems
> totally pointless. Fix the drm fbdev emulation if an fbdev interface is
> needed. But creating a fourth framework because our previous 3 frameworks
> didn't work out doesn't seem like a situation I want to get behind too much.

I think there's a misunderstanding here. I'm definitely not trying to create a 
framework to expose the FBDEV/KMS/V4L2 APIs through different drivers on top 
of the same hardware device. That's an idea I really dislike, and I fully 
agree that the FBDEV API should be provided on top of KMS using the DRM FBDEV 
emulation layer. V4L2 on top of KMS doesn't make too much sense to me, as V4L2 
isn't really a display and graphics API anyway.

My goal here is to share code for chips that are used by different "devices" 
(in the sense of an agregate device, such as a camera or a graphics card) 
supported by different subsystems. For instance, the same I2C-controlled HDMI 
transmitter can be used by a display device when connected to a display 
controller on an SoC, but can also be used by a video output device when 
connected to a video output (some complex TI SoCs have pass-through video 
pipelines with no associated frame buffer, making the V4L2 API better suited 
than DRM/KMS). As the first device would be supported by a DRM/KMS driver and 
the second device by a pure V4L2 driver, we need a common framework to share 
code between both.

If the same framework can be used to share panel drivers between DRM/KMS and 
pure FBDEV drivers (we have a bunch of those, not all of them will be ported 
to DRM/KMS, at least not in the very near future) that's also a bonus.

To summarize my point, CDF aims at creating a self-contained framework that 
can be used by FBDEV, DRM/KMS and V4L2 drivers to interface with various 
display-related devices. It does not provide any userspace API, and does not 
offer any way to share devices between the three subsystems at runtime. In a 
way you can think of CDF as a DRM panel framework, but without the drm_ 
prefix.

I hope this clarifies my goals. If not, or if there's still concerns and/or 
disagreements, let's discuss them.

-- 
Regards,

Laurent Pinchart

