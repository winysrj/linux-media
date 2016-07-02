Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33843 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbcGBDjF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 23:39:05 -0400
Received: by mail-oi0-f47.google.com with SMTP id s66so134641817oif.1
        for <linux-media@vger.kernel.org>; Fri, 01 Jul 2016 20:38:21 -0700 (PDT)
Subject: Re: [PATCH 00/38] i.MX5/6 Video Capture
To: Tim Harvey <tharvey@gateworks.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <CAJ+vNU2ec4i8CUV8Qdguz-Mm8gCXsQBm7rUmCp+9F-Tu+mh9kg@mail.gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <57773729.6060109@gmail.com>
Date: Fri, 1 Jul 2016 20:38:17 -0700
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU2ec4i8CUV8Qdguz-Mm8gCXsQBm7rUmCp+9F-Tu+mh9kg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

Pardon late reply, I'm on vacation. See below...


On 06/28/2016 11:54 AM, Tim Harvey wrote:
> On Tue, Jun 14, 2016 at 3:48 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
>> Tested on imx6q SabreAuto with ADV7180, and imx6q SabreSD with
>> mipi-csi2 OV5640. There is device-tree support also for imx6qdl
>> SabreLite, but that is not tested. Also, this driver should
>> theoretically work on i.MX5 targets, but that is also untested.
>>
>> Not run through v4l2-compliance yet, but that is in my queue.
>>
>>
> Steve,
>
> I've tested this series successfully with a Gateworks Ventana GW5300
> which has an IMX6Q and an adv7180 attached to IPU2_CSI1.
>
> First of all, a big 'thank you' for taking the time to rebase and
> re-submit this series!
>
> However based on the lack of feedback of the individual patches as
> well as the fact they touch varied subsystems I think we are going to
> have better luck getting this functionality accepted if you broke it
> into separate series.
>
> Here are my thoughts:
>
>>    gpu: ipu-v3: Add Video Deinterlacer unit
>>    gpu: ipu-cpmem: Add ipu_cpmem_set_uv_offset()
>>    gpu: ipu-cpmem: Add ipu_cpmem_get_burstsize()
>>    gpu: ipu-v3: Add ipu_get_num()
>>    gpu: ipu-v3: Add IDMA channel linking support
>>    gpu: ipu-v3: Add ipu_set_vdi_src_mux()
>>    gpu: ipu-v3: Add VDI input IDMAC channels
>>    gpu: ipu-v3: Add ipu_csi_set_src()
>>    gpu: ipu-v3: Add ipu_ic_set_src()
>>    gpu: ipu-v3: set correct full sensor frame for PAL/NTSC
>>    gpu: ipu-v3: Fix CSI data format for 16-bit media bus formats
>>    gpu: ipu-v3: Fix IRT usage
>>    gpu: ipu-v3: Fix CSI0 blur in NTSC format
>>    gpu: ipu-ic: Add complete image conversion support with tiling
>>    gpu: ipu-ic: allow multiple handles to ic
>>    gpu: ipu-v3: rename CSI client device
> These are all enhancements to the ipu-v3 driver shared by DRM and
> maintained by Philipp Zabel and there is no way to 'stage' them.

Just a note here, all these patches to ipu-v3 driver are to the
capture units, and should have no effect on DRM.

> Philipp, these have bee submitted previously with little to no changes
> or feedback - can we get sign-off or comment on these from you?
>
> Next I would submit the set of drivers that depend on the above into
> staging as Hans has said he would accept those (assuming the deps are
> accepted). Also, you should submit the drivers first in your series,
> then the imx6q.dtsi/imx6qdl.dtsi patches following such as:
>
>>    media: imx: Add MIPI CSI-2 Receiver driver
>>    media: Add camera interface driver for i.MX5/6
>>    media: Add i.MX5/6 mem2mem driver
>>    media: imx: Add video switch
>>    ARM: imx_v6_v7_defconfig: Enable staging video4linux drivers
>>    ARM: dts: imx6qdl: Add mipi_ipu1/2 video muxes, mipi_csi, and their connections
>>    ARM: dts: imx6qdl: Flesh out MIPI CSI2 receiver node
>>    ARM: dts: imx6qdl: add mem2mem device for sabre* boards

Ok I will reorder the patches.

> I think this last one should add the mem2mem nodes to imx6q.dtsi and
> imx6dl.dtsi to be useable by all boards with IPUs right?

Yeah, I'll move the mem2mem nodes to imx6qdl.dtsi and imx6q.dtsi.

>
> After this we have a platform that many imx6 boards with capture
> devices can build on.
>
> In parallel, you have a couple of other dependencies before saber*
> boards have full capture support that need to through other trees:
>
>>    gpio: pca953x: Add reset-gpios property
> This should be submitted through the linux-gpio list/subsystem.

I've really got a lot on my plate, I'd appreciate if someone else
could help me out with that.

>
>>    clocksource/drivers/imx: add input capture support
> Not sure what path this one goes through but it looks to me this patch
> adds a feature that only some boards may require (input-capture).

Well, the input-capture support should be usable by any imx6 based
target, and not just for v4l2 subsystem.

>
>>    media: imx: Add support for MIPI CSI-2 OV5640
>>    media: imx: Add support for Parallel OV5642
> shouldn't these be subdev drivers?

Well, they _are_ subdev drivers. I guess you mean they should be
moved to drivers/media/i2c? Agreed, at some point they need some
cleaning up and probably consolidated into a single subdev and moved
there.

>   Perhaps the can make it into
> staging at least in the form you have them now.
>
>>    v4l: Add signal lock status to source change events
>>    media: imx: Add support for ADV7180 Video Decoder
> These should be dropped (the 1st is a dependency of the 2nd) and
> instead we should be using the subdev driver. I believe you have this
> working, and I have been somewhat successful with some of your patches
> as well although I still have a 'rolling image' and do not appear to
> be getting signal detect interrupts after the first one (which is
> likely causing the rolling).

Tim, I've started a new branch 'adv718x' in my mediatree github fork
and moved all the patches to drivers/media/i2c/adv7180.c there. Note
the first commit in that branch!

As I'm currently on vacation and away from the h/w I won't be able to test
this branch with imx6 backend until I return on 7/6. Once the branch is
tested on the SabreAuto I will drop the staging adv7180.c driver.


>
>>    media: adv7180: add power pin control
>>    media: adv7180: implement g_parm
> These seem very reasonable and indeed go to linux-media but perhaps
> should be split out from the imx6 patchset to be able to get more
> attention on them?

Yes, see above.

>
>>    ARM: dts: imx6-sabrelite: add video capture ports and connections
>>    ARM: dts: imx6-sabresd: add video capture ports and connections
>>    ARM: dts: imx6-sabreauto: create i2cmux for i2c3
>>    ARM: dts: imx6-sabreauto: add reset-gpios property for max7310
>>    ARM: dts: imx6-sabreauto: add pinctrl for gpt input capture
>>    ARM: dts: imx6-sabreauto: add video capture ports and connections
> These should probably be last in a series on their own as there are
> several dependencies within them for things that need to take
> alternate submission paths.

Agreed, I will reorder things.

Steve

