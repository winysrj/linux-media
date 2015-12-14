Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35625 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbbLNPHd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 10:07:33 -0500
Received: by iofq126 with SMTP id q126so36413941iof.2
        for <linux-media@vger.kernel.org>; Mon, 14 Dec 2015 07:07:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5D=wX0aW73U9t+tsaPOB4Y4kCG35e4dDQVL6U+T6QxB_A@mail.gmail.com>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
	<CAOMZO5Beow0HGHDVUTL=nwMGGOu6nKViYnRN7E=EAj2KsYvzLg@mail.gmail.com>
	<CAOMZO5D=wX0aW73U9t+tsaPOB4Y4kCG35e4dDQVL6U+T6QxB_A@mail.gmail.com>
Date: Mon, 14 Dec 2015 07:07:32 -0800
Message-ID: <CAJ+vNU13kH5Bvq=+TYP17ErOGeANcnptcODuk0b+KmUKmuLZXg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/26] i.MX5/6 IPUv3 CSI/IC
From: Tim Harvey <tharvey@gateworks.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Fabio Estevam <festevam@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 1, 2015 at 4:08 AM, Fabio Estevam <festevam@gmail.com> wrote:
> Hi Philipp,
>
> On Tue, Oct 27, 2015 at 11:10 AM, Fabio Estevam <festevam@gmail.com> wrote:
>> Hi Philipp,
>>
>>
>> On Thu, Jun 12, 2014 at 2:06 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
>>> Hi,
>>>
>>> attached is a series of our work in progress i.MX6 capture drivers.
>>> I'm posting this now in reaction to Steve's i.MX6 Video capture series,
>>> as a reference for further discussion.
>>> Of the Image Converter (IC) we only use the postprocessor task, with
>>> tiling for larger frames, to implement v4l2 mem2mem scaler/colorspace
>>> converter and deinterlacer devices.
>>> The capture code capture code already uses the media controller framework
>>> and creates a subdevice representing the CSI, but the path to memory is
>>> fixed to IDMAC via SMFC, which is the only possible path for grayscale
>>> and  and anything with multiple output ports connected
>>> to the CSIs (such as the CSI2IPU gasket on i.MX6) doesn't work yet. Also,
>>> I think the CSI subdevice driver should be completely separate from the
>>> capture driver.
>>>
>>> regards
>>> Philipp
>>>
>>> Philipp Zabel (16):
>>>   gpu: ipu-v3: Add function to setup CP channel as interlaced
>>>   gpu: ipu-v3: Add ipu_cpmem_get_buffer function
>>>   gpu: ipu-v3: Add support for partial interleaved YCbCr 4:2:0 (NV12)
>>>     format
>>>   gpu: ipu-v3: Add support for planar YUV 4:2:2 (YUV422P) format
>>>   imx-drm: currently only IPUv3 is supported, make it mandatory
>>>   [media] Add i.MX SoC wide media device driver
>>>   [media] imx-ipu: Add i.MX IPUv3 capture driver
>>>   [media] ipuv3-csi: Skip 3 lines for NTSC BT.656
>>>   [media] imx-ipuv3-csi: Add support for temporarily stopping the stream
>>>     on sync loss
>>>   [media] imx-ipuv3-csi: Export sync lock event to userspace
>>>   [media] v4l2-subdev.h: Add lock status notification
>>>   [media] v4l2-subdev: Export v4l2_subdev_fops
>>>   mfd: syscon: add child device support
>>>   [media] imx: Add video switch
>>>   ARM: dts: Add IPU aliases on i.MX6
>>>   ARM: dts: imx6qdl: Add mipi_ipu1/2 multiplexers, mipi_csi, and their
>>>     connections
>>>
>>> Sascha Hauer (10):
>>>   gpu: ipu-v3: Add IC support
>>>   gpu: ipu-v3: Register IC with IPUv3
>>>   [media] imx-ipu: add ipu media common code
>>>   [media] imx-ipu: Add i.MX IPUv3 scaler driver
>>>   [media] imx-ipu: Add i.MX IPUv3 deinterlacer driver
>>>   [media] v4l2: subdev: Add v4l2_device_register_subdev_node function
>>>   [media] v4l2: Fix V4L2_CID_PIXEL_RATE
>>>   [media] v4l2 async: remove from notifier list
>>>   [media] ipuv3-csi: Pass ipucsi to v4l2_media_subdev_s_power
>>>   [media] ipuv3-csi: make subdev controls available on video device
>>
>> Do you have plans to resubmit this series?
>
> Any news about this series?
>
> Thanks

Philipp / Steve,

I'm also curious as to what your plans are with this work. I have IMX6
boards in mainline (Gateworks Ventana product family) that have both
composite input (adv7180) and HDMI input (tda1997x) via the IMX6 CSI
and am wondering what is left to achieve mainline video capture on the
IMX6. Video capture and crypto are the last things I know of that can
eliminate the common need of a downstream vendor kernel with 100's of
Freescale patches.

Can you point me to the most recent git tree that you were working
with and tell me what devices you were using to capture with?

Regards,

Tim

Tim Harvey - Principal Software Engineer
Gateworks Corporation - http://www.gateworks.com/
3026 S. Higuera St. San Luis Obispo CA 93401
805-781-2000
