Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34194 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbcF1TAQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 15:00:16 -0400
Received: by mail-io0-f174.google.com with SMTP id g13so25322452ioj.1
        for <linux-media@vger.kernel.org>; Tue, 28 Jun 2016 12:00:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Tue, 28 Jun 2016 11:54:14 -0700
Message-ID: <CAJ+vNU2ec4i8CUV8Qdguz-Mm8gCXsQBm7rUmCp+9F-Tu+mh9kg@mail.gmail.com>
Subject: Re: [PATCH 00/38] i.MX5/6 Video Capture
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 14, 2016 at 3:48 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> Tested on imx6q SabreAuto with ADV7180, and imx6q SabreSD with
> mipi-csi2 OV5640. There is device-tree support also for imx6qdl
> SabreLite, but that is not tested. Also, this driver should
> theoretically work on i.MX5 targets, but that is also untested.
>
> Not run through v4l2-compliance yet, but that is in my queue.
>
>

Steve,

I've tested this series successfully with a Gateworks Ventana GW5300
which has an IMX6Q and an adv7180 attached to IPU2_CSI1.

First of all, a big 'thank you' for taking the time to rebase and
re-submit this series!

However based on the lack of feedback of the individual patches as
well as the fact they touch varied subsystems I think we are going to
have better luck getting this functionality accepted if you broke it
into separate series.

Here are my thoughts:

>   gpu: ipu-v3: Add Video Deinterlacer unit
>   gpu: ipu-cpmem: Add ipu_cpmem_set_uv_offset()
>   gpu: ipu-cpmem: Add ipu_cpmem_get_burstsize()
>   gpu: ipu-v3: Add ipu_get_num()
>   gpu: ipu-v3: Add IDMA channel linking support
>   gpu: ipu-v3: Add ipu_set_vdi_src_mux()
>   gpu: ipu-v3: Add VDI input IDMAC channels
>   gpu: ipu-v3: Add ipu_csi_set_src()
>   gpu: ipu-v3: Add ipu_ic_set_src()
>   gpu: ipu-v3: set correct full sensor frame for PAL/NTSC
>   gpu: ipu-v3: Fix CSI data format for 16-bit media bus formats
>   gpu: ipu-v3: Fix IRT usage
>   gpu: ipu-v3: Fix CSI0 blur in NTSC format
>   gpu: ipu-ic: Add complete image conversion support with tiling
>   gpu: ipu-ic: allow multiple handles to ic
>   gpu: ipu-v3: rename CSI client device

These are all enhancements to the ipu-v3 driver shared by DRM and
maintained by Philipp Zabel and there is no way to 'stage' them.
Philipp, these have bee submitted previously with little to no changes
or feedback - can we get sign-off or comment on these from you?

Next I would submit the set of drivers that depend on the above into
staging as Hans has said he would accept those (assuming the deps are
accepted). Also, you should submit the drivers first in your series,
then the imx6q.dtsi/imx6qdl.dtsi patches following such as:

>   media: imx: Add MIPI CSI-2 Receiver driver
>   media: Add camera interface driver for i.MX5/6
>   media: Add i.MX5/6 mem2mem driver
>   media: imx: Add video switch
>   ARM: imx_v6_v7_defconfig: Enable staging video4linux drivers
>   ARM: dts: imx6qdl: Add mipi_ipu1/2 video muxes, mipi_csi, and their connections
>   ARM: dts: imx6qdl: Flesh out MIPI CSI2 receiver node
>   ARM: dts: imx6qdl: add mem2mem device for sabre* boards

I think this last one should add the mem2mem nodes to imx6q.dtsi and
imx6dl.dtsi to be useable by all boards with IPUs right?

After this we have a platform that many imx6 boards with capture
devices can build on.

In parallel, you have a couple of other dependencies before saber*
boards have full capture support that need to through other trees:

>   gpio: pca953x: Add reset-gpios property

This should be submitted through the linux-gpio list/subsystem.

>   clocksource/drivers/imx: add input capture support

Not sure what path this one goes through but it looks to me this patch
adds a feature that only some boards may require (input-capture).

>   media: imx: Add support for MIPI CSI-2 OV5640
>   media: imx: Add support for Parallel OV5642

shouldn't these be subdev drivers? Perhaps the can make it into
staging at least in the form you have them now.

>   v4l: Add signal lock status to source change events
>   media: imx: Add support for ADV7180 Video Decoder

These should be dropped (the 1st is a dependency of the 2nd) and
instead we should be using the subdev driver. I believe you have this
working, and I have been somewhat successful with some of your patches
as well although I still have a 'rolling image' and do not appear to
be getting signal detect interrupts after the first one (which is
likely causing the rolling).

>   media: adv7180: add power pin control
>   media: adv7180: implement g_parm

These seem very reasonable and indeed go to linux-media but perhaps
should be split out from the imx6 patchset to be able to get more
attention on them?

>   ARM: dts: imx6-sabrelite: add video capture ports and connections
>   ARM: dts: imx6-sabresd: add video capture ports and connections
>   ARM: dts: imx6-sabreauto: create i2cmux for i2c3
>   ARM: dts: imx6-sabreauto: add reset-gpios property for max7310
>   ARM: dts: imx6-sabreauto: add pinctrl for gpt input capture
>   ARM: dts: imx6-sabreauto: add video capture ports and connections

These should probably be last in a series on their own as there are
several dependencies within them for things that need to take
alternate submission paths.

Regards,

Tim
