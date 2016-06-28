Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:55111 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186AbcF1UM0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 16:12:26 -0400
Subject: Re: [PATCH 00/38] i.MX5/6 Video Capture
To: Tim Harvey <tharvey@gateworks.com>,
	Steve Longerbeam <slongerbeam@gmail.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <CAJ+vNU2ec4i8CUV8Qdguz-Mm8gCXsQBm7rUmCp+9F-Tu+mh9kg@mail.gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <69694ba5-287d-bb5d-5f44-e0cf9bf1f021@xs4all.nl>
Date: Tue, 28 Jun 2016 22:10:08 +0200
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU2ec4i8CUV8Qdguz-Mm8gCXsQBm7rUmCp+9F-Tu+mh9kg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/28/2016 08:54 PM, Tim Harvey wrote:
> On Tue, Jun 14, 2016 at 3:48 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
>> Tested on imx6q SabreAuto with ADV7180, and imx6q SabreSD with
>> mipi-csi2 OV5640. There is device-tree support also for imx6qdl
>> SabreLite, but that is not tested. Also, this driver should
>> theoretically work on i.MX5 targets, but that is also untested.
>>
>> Not run through v4l2-compliance yet, but that is in my queue.
>>
>>
> 
> Steve,
> 
> I've tested this series successfully with a Gateworks Ventana GW5300
> which has an IMX6Q and an adv7180 attached to IPU2_CSI1.
> 
> First of all, a big 'thank you' for taking the time to rebase and
> re-submit this series!
> 
> However based on the lack of feedback of the individual patches as

It's on my TODO list, but the series was a lot larger than I expected (and
touched on a lot of subsystems as well), so I postponed looking at this
until I have a bit more time.

> well as the fact they touch varied subsystems I think we are going to
> have better luck getting this functionality accepted if you broke it
> into separate series.
> 
> Here are my thoughts:
> 
>>   gpu: ipu-v3: Add Video Deinterlacer unit
>>   gpu: ipu-cpmem: Add ipu_cpmem_set_uv_offset()
>>   gpu: ipu-cpmem: Add ipu_cpmem_get_burstsize()
>>   gpu: ipu-v3: Add ipu_get_num()
>>   gpu: ipu-v3: Add IDMA channel linking support
>>   gpu: ipu-v3: Add ipu_set_vdi_src_mux()
>>   gpu: ipu-v3: Add VDI input IDMAC channels
>>   gpu: ipu-v3: Add ipu_csi_set_src()
>>   gpu: ipu-v3: Add ipu_ic_set_src()
>>   gpu: ipu-v3: set correct full sensor frame for PAL/NTSC
>>   gpu: ipu-v3: Fix CSI data format for 16-bit media bus formats
>>   gpu: ipu-v3: Fix IRT usage
>>   gpu: ipu-v3: Fix CSI0 blur in NTSC format
>>   gpu: ipu-ic: Add complete image conversion support with tiling
>>   gpu: ipu-ic: allow multiple handles to ic
>>   gpu: ipu-v3: rename CSI client device
> 
> These are all enhancements to the ipu-v3 driver shared by DRM and
> maintained by Philipp Zabel and there is no way to 'stage' them.
> Philipp, these have bee submitted previously with little to no changes
> or feedback - can we get sign-off or comment on these from you?

I'd like to know the status of this as well. If this can't go in, then
accepting the v4l2 driver in staging will likely be very difficult if not
impossible.

Regards,

	Hans
