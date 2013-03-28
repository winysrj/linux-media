Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:42555 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3C1FKn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Mar 2013 01:10:43 -0400
MIME-Version: 1.0
In-Reply-To: <5152F857.6010409@samsung.com>
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
	<1362754765-2651-2-git-send-email-arun.kk@samsung.com>
	<514DAAC3.4050202@gmail.com>
	<CALt3h7_nXSd6A2t55fi3PD+BkpZh5Lo4suWcg-ZF=jDq+V3NXA@mail.gmail.com>
	<51522671.5080706@gmail.com>
	<CALt3h7_nFQdRCJJA0n4i9_CnRJAeYvu8xCkwzDsfdqBZgf_NNw@mail.gmail.com>
	<5152F857.6010409@samsung.com>
Date: Thu, 28 Mar 2013 10:40:41 +0530
Message-ID: <CALt3h7-Hi4E6wL-Scd-45k0SGJnhrwZ7Ks_unmwU5ognyY-nmw@mail.gmail.com>
Subject: Re: [RFC 01/12] exynos-fimc-is: Adding device tree nodes
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 27, 2013 at 7:17 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> On 03/27/2013 05:31 AM, Arun Kumar K wrote:
>> On Wed, Mar 27, 2013 at 4:21 AM, Sylwester Nawrocki
>> <sylvester.nawrocki@gmail.com> wrote:
>>> On 03/26/2013 01:17 PM, Arun Kumar K wrote:
> [...]
>> Only issue is with the context sharing.
>> Right now you can see that the fimc-is context is shared between all
>> the subdevs.
>> As all of them are part of the same driver, it is possible.
>> If sensor is made as an independent i2c device, a separate probe will
>> be called for it.
>> For ISP sensor subdev to work independently, it needs to call the
>> fimc_is_pipeline_* calls
>> for FW initialization and other configurations for which it needs the
>> fimc-is main context.
>>
>> Now there is a workaround here by calling a get_context() macro in
>> sensor's probe
>> to get the fimc-is context. This will cause the same context to be
>> shared and updated by
>> 2 drivers though both are part of fimc-is.
>> Is this acceptable? Or am I missing some other simple solution of implementing
>> it in a better way?
>
> OK, thanks for the explanation.
>
> I can think of at least one possible way to get hold of the fimc-is
> context in the subdev. For instance, in subdev's .registered callback
> you get a pointer to struct v4l2_device, which is normally embedded
> in a top level driver's private data. Then with container_of()
> you could get hold of required data at the fimc-is driver.

But as per current implementation, it is not the fimc-is driver that is
registering the ISP subdevs. It will be registered from the
media controller driver. So fimc-is context cannot be obtained by
just using container_of().

>
> But... to make the subdev drivers reuse possible subdevs should
> normally not be required to know the internals of a host driver they
> are registered to. And it looks a bit unusual to have fimc_pipeline_*
> calls in the sensor's operation handlers.

fimc_pipeline_* I mentioned is not the media controller pipeline.
In the fimc-is driver, all the subdevs just implement the interface part.
All the core functionalities happen in fimc-is-pipeline.c and
fimc-is-interface.c.
Since these ISP subdevs (sensor, isp, scc, scp) are not independent
devices, all are controlled by the ISP firmware whose configuration and
interface is done from the fimc_is_pipeline_* and fimc_is_itf_* functions.
So all the ISP subdevs including sensor need to call these functions.

>
> I thought that the subdevs could provide basic methods and it would
> be the top level media driver that would resolve any dependencies
> in calling required subdev ops, according to media graph configuration
> done by the user on /dev/media?.
>

In case of ISP subdevs (isp, scc and scp), there is not much configuration
that the media device can do. Only control possible is to turn on/off
specific scaler DMA outputs which can be done via the video node ioctls.
The role of media device here is mostly to convey the pipeline structure
to the user. For eg. it is not possible to directly connect isp (sd)
--> scp (sd).
In the media controller pipeline1 implementation, we were planning to
put immutable links between these subdevs. Is that acceptable?


> The media driver has a list of media entities (subdevices and video
> nodes) and I though it could coordinate any requests involving whole
> video/image processing pipeline originating from /dev/video ioctls/fops.
>
> So for instance if /dev/video in this pipeline is opened
>
> sensor (sd) -> mipi-csis (sd) -> fimc-lite (sd) -> memory (/dev/video)
>
> it would call s_power operation on the above subdevs and additionally
> on e.g. the isp subdev (or any other we choose as a main subdev
> implementing the FIMC-IS slave interface).
>
> Then couldn't it be done that video node ioctls invoke pipeline
> operations, and the media device resolves any dependencies/calls
> order, as in case of the exynos4 driver ?

On Exynos4 subdevs, it is well and good since all the subdevs are
independent IPs. Here in ISP since the same IP can take one input and
provide multiple outputs, we designed them as separate subdevs. So
here we cannot make the subdevs independent of each other where only
the sequence / dependencies is controlled from the media device.

Regards
Arun
