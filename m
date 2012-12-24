Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40601 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2LXRSV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 12:18:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Rob Clark <rob.clark@linaro.org>, Dave Airlie <airlied@gmail.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC v2 0/5] Common Display Framework
Date: Mon, 24 Dec 2012 18:19:45 +0100
Message-ID: <3156931.HXaBsp8FS6@avalon>
In-Reply-To: <50D04C97.4080104@gmail.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <CAF6AEGsLdLasS4=j1PsX_P8miG8NcTXMUP9VYj+4gdU8Qhm2YQ@mail.gmail.com> <50D04C97.4080104@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tuesday 18 December 2012 11:59:35 Sylwester Nawrocki wrote:
> On 12/18/2012 07:21 AM, Rob Clark wrote:
> > On Mon, Dec 17, 2012 at 11:04 PM, Dave Airlie<airlied@gmail.com>  wrote:
> >> So this might be a bit off topic but this whole CDF triggered me
> >> looking at stuff I generally avoid:
> >> 
> >> The biggest problem I'm having currently with the whole ARM graphics
> >> and output world is the proliferation of platform drivers for every
> >> little thing. The whole ordering of operations with respect to things
> >> like suspend/resume or dynamic power management is going to be a real
> >> nightmare if there are dependencies between the drivers. How do you
> >> enforce ordering of s/r operations between all the various components?
> 
> There have been already some ideas proposed to resolve this at the PM
> subsystem level [1]. And this problem is of course not only specific to
> platform drivers. The idea of having monolithic drivers, just because we
> can't get the suspend/resume sequences right otherwise, doesn't really sound
> appealing. SoC IPs get reused on multiple different SoC series, no only by
> single manufacturer. Whole graphics/video subsystems are composed from
> smaller blocks in SoCs, with various number of distinct sub-blocks and same
> sub-blocks repeated different number of times in a specific SoC revision.
> Expressing an IP as a platform device seems justified to me, often these
> platform devices have enough differences to treat them as such. E.g. belong
> in different power domain/use different clocks. Except there is big issue
> with the power management... However probably more important is to be able
> to have driver for a specific IP in a separate module.
> 
> And this suspend/resume ordering issue is not only about the platform
> devices. E.g. camera subsystem can be composed of an image sensor sub-device
> driver, which is most often an I2C client driver, and of multiple SoC
> processing blocks. The image sensor can have dependencies on the SoC sub-
> blocks. So even if we created monolithic driver for the SoC part, there are
> still two pieces to get s/r ordering right - I2C client and SoC drivers. And
> please don't propose to merge the sensor sub-device driver too. There has
> been a lot of effort in V4L2 to separate those various functional blocks
> into sub-devices, so they can be freely reused, without reimplementing same
> functionality in each driver. BTW, there has been a nice talk about these
> topics at ELCE [2], particularly slide 22 is interesting.
> 
> I believe the solution for these issues really needs to be sought in the PM
> subsystem itself.

I tend to agree with you, or at least I believe we should research a proper 
solution in the PM framework. In the meantime, though, I think early 
suspend/late resume might provide an intermediate solution.

> > I tend to think that sub-devices are useful just to have a way to
> > probe hw which may or may not be there, since on ARM we often don't
> > have any alternative.. but beyond that, suspend/resume, and other
> > life-cycle aspects, they should really be treated as all one device.
> > Especially to avoid undefined suspend/resume ordering.
> 
> [1] https://lkml.org/lkml/2009/9/9/373
> [2]
> http://elinux.org/images/9/90/ELCE2012-Modular-Graphics-on-Embedded-ARM.pdf

-- 
Regards,

Laurent Pinchart

