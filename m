Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:38628 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752915AbeDPHyz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 03:54:55 -0400
Received: by mail-qk0-f171.google.com with SMTP id b39so10445767qkb.5
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 00:54:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1523629085.3396.10.camel@pengutronix.de>
References: <CAPQseg2t1-LgmeuQBW2YXSwN26WKcJWakN2KCLfCjKZ_wJeWGw@mail.gmail.com>
 <1523629085.3396.10.camel@pengutronix.de>
From: Ibtsam Ul-Haq <ibtsam.haq.0x01@gmail.com>
Date: Mon, 16 Apr 2018 09:54:53 +0200
Message-ID: <CAPQseg29hJ+vdWxU3RkXtaeJki9209OjqvGOQQ-U45Z_vvjnnw@mail.gmail.com>
Subject: Re: imx-media: MT9P031 Capture issues on IMX6
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thanks a lot for your response.

On Fri, Apr 13, 2018 at 4:18 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi Ibtsam,
>
> On Thu, 2018-04-12 at 16:00 +0200, Ibtsam Ul-Haq wrote:
>> Greetings everyone,
>> I am using Linux 4.14.31 on an IMX6 platform, with an MT9P031 sensor
>> attached to the ipu1_csi0 (parallel).
>> My Gstreamer version is 1.14.0 and v4l-utils version is 1.14.2.
>> The problem is that I am unable to set up a capture pipeline.
>>
>> Even the simplest capture pipeline such as:
>>
>> gst-launch-1.0 v4l2src device=/dev/video4 ! fakesink
>>
>> returns the following error:
>> ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
>> Internal data stream error.
>> Additional debug info:
>> ../../../../gstreamer-1.14.0/libs/gst/base/gstbasesrc.c(3055):
>> gst_base_src_loop (): /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
>> streaming stopped, reason not-negotiated (-4)
>> ERROR: pipeline doesn't want to preroll.
>>
>> I get the same error on any pipeline involving v4l2src.
>>
>> I have set up the media entity links using:
>> media-ctl -l "'mt9p031 0-0048':0 -> 'ipu1_csi0_mux':1[1]"
>> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>> media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
>>
>> And I configure the pads using:
>> media-ctl -V "'mt9p031 0-0048':0 [fmt:SGRBG8/640x480 field:none]"
>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:SGRBG8/640x480 field:none]"
>> media-ctl -V "'ipu1_csi0':2 [fmt:SGRBG8/640x480 field:none]"
>
> What is the actual format that all pads are configured to? I found it
> helpful to double check the whole pipeline after configuring pads (or
> use media-ctl -v):
>
> media-ctl --get-v4l2 "'mt9p031 0-0048':0"
> media-ctl --get-v4l2 "'ipu1_csi0_mux':1"
> media-ctl --get-v4l2 "'ipu1_csi0_mux':2"
> media-ctl --get-v4l2 "'ipu1_csi0':0"
> media-ctl --get-v4l2 "'ipu1_csi0':2"
>


Here is what I get after I have executed the commands to configure all
the pads to SGRBG8/640x480:

:~# media-ctl --get-v4l2 "'mt9p031 0-0048':0"
[fmt:SGRBG12_1X12/648x486 field:none colorspace:srgb

:~# media-ctl --get-v4l2 "'ipu1_csi0_mux':1"
[fmt:SGRBG12_1X12/648x486 field:none colorspace:srgb]

:~# media-ctl --get-v4l2 "'ipu1_csi0_mux':2"
[fmt:SGRBG12_1X12/648x486 field:none colorspace:srgb]

:~# media-ctl --get-v4l2 "'ipu1_csi0':0"
[fmt:SGRBG12_1X12/656x486@1/30 field:none colorspace:srgb xfer:srgb
ycbcr:601 quantization:full-range
crop.bounds:(0,0)/656x486
crop:(0,0)/656x486
compose.bounds:(0,0)/656x486
compose:(0,0)/656x486]

:~# media-ctl --get-v4l2 "'ipu1_csi0':2"
[fmt:SGRBG12_1X12/656x486@1/30 field:none colorspace:srgb xfer:srgb
ycbcr:601 quantization:full-range]


> I assume that because mt9p031 only supports SGRBG12_1X12, that's what
> will be propagated down the pipeline to the CSI, which will then expand
> it to SGRBG16.
>


This indeed looks the case. But then, is 'GR16' the FourCC for 'SGRBG16'?
To be honest, I had not seen GR16 as FourCC before.
And the Gstreamer debug logs (I used GST_DEBUG=5) also say that they
do not know this FourCC:
v4l2 gstv4l2object.c:1541:gst_v4l2_object_v4l2fourcc_to_bare_struct: [00m
Unsupported fourcc 0x36315247 GR16

Is there a way we can get by this?


> I suppose we should allow, at least for parallel input, to let the CSI
> 'convert' 12-bit input formats to 8-bit output formats by just ignoring
> the LSBs.
> Another possibility would be to just allow SGRBG12_1X12 -> SGRBG8_1X8
> mbus codes in link_validate. Actually, does your hardware have 12 data
> lines connected between sensor and i.MX6, or just 8 ?
>

Currently we have 8. Although we can populate extra resistors to
connect the remaining 4.
The device tree is set for 8 lines currently.


>> And I do not get any errors from these commands.
>
> That's because of the way the V4L2 API works, unsupported formats are
> adjusted by the drivers:
>
> https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/vidioc-subdev-g-fmt.html#description
>
> [...]
>> What confuses me here is that the Pixel Format shown by v4l2-ctl is
>> 'GR16', which is not what I expected. And it seems like the media-ctl
>> pad configuration commands are unable to change the Pixel Format, even
>> though they do not return any errors.
>
> Whenever you media-ctl -V on a source pad, it will also try to set the
> connected sink pad to the same format. And for subdevices with sink and
> source pads, the source pads usually mirror (or somehow depend on) the
> format of the sink pad. Due to the way the V4L2 APIs correct your input
> to possible values, calling media-ctl -V on all source pads of the
> pipeline in downstream direction essentially propagates the sensor
> source pad format.
>

Thanks for the nice explanation. This is valuable learning for me as I
am just a beginner in this stuff.

> regards
> Philipp

Best regards,
Ibtsam Haq
