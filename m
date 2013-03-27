Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52175 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3C0NrH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 09:47:07 -0400
Message-id: <5152F857.6010409@samsung.com>
Date: Wed, 27 Mar 2013 14:47:03 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arunkk.samsung@gmail.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	kilyeon.im@samsung.com
Subject: Re: [RFC 01/12] exynos-fimc-is: Adding device tree nodes
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
 <1362754765-2651-2-git-send-email-arun.kk@samsung.com>
 <514DAAC3.4050202@gmail.com>
 <CALt3h7_nXSd6A2t55fi3PD+BkpZh5Lo4suWcg-ZF=jDq+V3NXA@mail.gmail.com>
 <51522671.5080706@gmail.com>
 <CALt3h7_nFQdRCJJA0n4i9_CnRJAeYvu8xCkwzDsfdqBZgf_NNw@mail.gmail.com>
In-reply-to: <CALt3h7_nFQdRCJJA0n4i9_CnRJAeYvu8xCkwzDsfdqBZgf_NNw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/27/2013 05:31 AM, Arun Kumar K wrote:
> On Wed, Mar 27, 2013 at 4:21 AM, Sylwester Nawrocki
> <sylvester.nawrocki@gmail.com> wrote:
>> On 03/26/2013 01:17 PM, Arun Kumar K wrote:
[...]
> Only issue is with the context sharing.
> Right now you can see that the fimc-is context is shared between all
> the subdevs.
> As all of them are part of the same driver, it is possible.
> If sensor is made as an independent i2c device, a separate probe will
> be called for it.
> For ISP sensor subdev to work independently, it needs to call the
> fimc_is_pipeline_* calls
> for FW initialization and other configurations for which it needs the
> fimc-is main context.
> 
> Now there is a workaround here by calling a get_context() macro in
> sensor's probe
> to get the fimc-is context. This will cause the same context to be
> shared and updated by
> 2 drivers though both are part of fimc-is.
> Is this acceptable? Or am I missing some other simple solution of implementing
> it in a better way?

OK, thanks for the explanation.

I can think of at least one possible way to get hold of the fimc-is
context in the subdev. For instance, in subdev's .registered callback
you get a pointer to struct v4l2_device, which is normally embedded
in a top level driver's private data. Then with container_of()
you could get hold of required data at the fimc-is driver.

But... to make the subdev drivers reuse possible subdevs should
normally not be required to know the internals of a host driver they
are registered to. And it looks a bit unusual to have fimc_pipeline_*
calls in the sensor's operation handlers.

I thought that the subdevs could provide basic methods and it would
be the top level media driver that would resolve any dependencies
in calling required subdev ops, according to media graph configuration
done by the user on /dev/media?.

The media driver has a list of media entities (subdevices and video
nodes) and I though it could coordinate any requests involving whole
video/image processing pipeline originating from /dev/video ioctls/fops.

So for instance if /dev/video in this pipeline is opened

sensor (sd) -> mipi-csis (sd) -> fimc-lite (sd) -> memory (/dev/video)

it would call s_power operation on the above subdevs and additionally
on e.g. the isp subdev (or any other we choose as a main subdev
implementing the FIMC-IS slave interface).

Then couldn't it be done that video node ioctls invoke pipeline
operations, and the media device resolves any dependencies/calls
order, as in case of the exynos4 driver ?

As a side note, I'm working on adding a generic method to get any
v4l2_subdev/video_device from a struct media_entity instance, so
it is easier to handle link_notify events, power/streaming enable/
disable sequences, etc.  Currently I have a data structure like:

struct exynos_iss_entity {
	struct video_device vdev;
	struct v4l2_subdev subdev;
	struct exynos_iss_pipeline pipe;
};


Regards,
Sylwester
