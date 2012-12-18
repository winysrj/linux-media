Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51283 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab2LRLFb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Dec 2012 06:05:31 -0500
Message-ID: <50D04C97.4080104@gmail.com>
Date: Tue, 18 Dec 2012 11:59:35 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Rob Clark <rob.clark@linaro.org>
CC: Dave Airlie <airlied@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <CAPM=9txFJzJ0haTyBnr8hEmmqNb+gSAyBno+Zs0Z-qvVMTwz9A@mail.gmail.com> <CAF6AEGsLdLasS4=j1PsX_P8miG8NcTXMUP9VYj+4gdU8Qhm2YQ@mail.gmail.com>
In-Reply-To: <CAF6AEGsLdLasS4=j1PsX_P8miG8NcTXMUP9VYj+4gdU8Qhm2YQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/18/2012 07:21 AM, Rob Clark wrote:
> On Mon, Dec 17, 2012 at 11:04 PM, Dave Airlie<airlied@gmail.com>  wrote:
>> So this might be a bit off topic but this whole CDF triggered me
>> looking at stuff I generally avoid:
>>
>> The biggest problem I'm having currently with the whole ARM graphics
>> and output world is the proliferation of platform drivers for every
>> little thing. The whole ordering of operations with respect to things
>> like suspend/resume or dynamic power management is going to be a real
>> nightmare if there are dependencies between the drivers. How do you
>> enforce ordering of s/r operations between all the various components?

There have been already some ideas proposed to resolve this at the PM
subsystem level [1]. And this problem is of course not only specific
to platform drivers. The idea of having monolithic drivers, just because
we can't get the suspend/resume sequences right otherwise, doesn't really
sound appealing. SoC IPs get reused on multiple different SoC series,
no only by single manufacturer. Whole graphics/video subsystems are
composed from smaller blocks in SoCs, with various number of distinct
sub-blocks and same sub-blocks repeated different number of times in
a specific SoC revision.
Expressing an IP as a platform device seems justified to me, often these
platform devices have enough differences to treat them as such. E.g.
belong in different power domain/use different clocks. Except there is
big issue with the power management... However probably more important
is to be able to have driver for a specific IP in a separate module.

And this suspend/resume ordering issue is not only about the platform
devices. E.g. camera subsystem can be composed of an image sensor
sub-device driver, which is most often an I2C client driver, and of
multiple SoC processing blocks. The image sensor can have dependencies
on the SoC sub-blocks. So even if we created monolithic driver for the
SoC part, there are still two pieces to get s/r ordering right - I2C
client and SoC drivers. And please don't propose to merge the sensor
sub-device driver too. There has been a lot of effort in V4L2 to
separate those various functional blocks into sub-devices, so they can
be freely reused, without reimplementing same functionality in each
driver. BTW, there has been a nice talk about these topics at ELCE [2],
particularly slide 22 is interesting.

I believe the solution for these issues really needs to be sought in the
PM subsystem itself.

> I tend to think that sub-devices are useful just to have a way to
> probe hw which may or may not be there, since on ARM we often don't
> have any alternative.. but beyond that, suspend/resume, and other
> life-cycle aspects, they should really be treated as all one device.
> Especially to avoid undefined suspend/resume ordering.

[1] https://lkml.org/lkml/2009/9/9/373
[2] 
http://elinux.org/images/9/90/ELCE2012-Modular-Graphics-on-Embedded-ARM.pdf

Thanks,
Sylwester
