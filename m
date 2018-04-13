Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39783 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753254AbeDMOSG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Apr 2018 10:18:06 -0400
Message-ID: <1523629085.3396.10.camel@pengutronix.de>
Subject: Re: imx-media: MT9P031 Capture issues on IMX6
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Ibtsam Ul-Haq <ibtsam.haq.0x01@gmail.com>,
        linux-media <linux-media@vger.kernel.org>
Date: Fri, 13 Apr 2018 16:18:05 +0200
In-Reply-To: <CAPQseg2t1-LgmeuQBW2YXSwN26WKcJWakN2KCLfCjKZ_wJeWGw@mail.gmail.com>
References: <CAPQseg2t1-LgmeuQBW2YXSwN26WKcJWakN2KCLfCjKZ_wJeWGw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ibtsam,

On Thu, 2018-04-12 at 16:00 +0200, Ibtsam Ul-Haq wrote:
> Greetings everyone,
> I am using Linux 4.14.31 on an IMX6 platform, with an MT9P031 sensor
> attached to the ipu1_csi0 (parallel).
> My Gstreamer version is 1.14.0 and v4l-utils version is 1.14.2.
> The problem is that I am unable to set up a capture pipeline.
> 
> Even the simplest capture pipeline such as:
> 
> gst-launch-1.0 v4l2src device=/dev/video4 ! fakesink
> 
> returns the following error:
> ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> Internal data stream error.
> Additional debug info:
> ../../../../gstreamer-1.14.0/libs/gst/base/gstbasesrc.c(3055):
> gst_base_src_loop (): /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> streaming stopped, reason not-negotiated (-4)
> ERROR: pipeline doesn't want to preroll.
> 
> I get the same error on any pipeline involving v4l2src.
> 
> I have set up the media entity links using:
> media-ctl -l "'mt9p031 0-0048':0 -> 'ipu1_csi0_mux':1[1]"
> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
> media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
>
> And I configure the pads using:
> media-ctl -V "'mt9p031 0-0048':0 [fmt:SGRBG8/640x480 field:none]"
> media-ctl -V "'ipu1_csi0_mux':2 [fmt:SGRBG8/640x480 field:none]"
> media-ctl -V "'ipu1_csi0':2 [fmt:SGRBG8/640x480 field:none]"

What is the actual format that all pads are configured to? I found it
helpful to double check the whole pipeline after configuring pads (or
use media-ctl -v):

media-ctl --get-v4l2 "'mt9p031 0-0048':0"
media-ctl --get-v4l2 "'ipu1_csi0_mux':1"
media-ctl --get-v4l2 "'ipu1_csi0_mux':2"
media-ctl --get-v4l2 "'ipu1_csi0':0"
media-ctl --get-v4l2 "'ipu1_csi0':2"

I assume that because mt9p031 only supports SGRBG12_1X12, that's what
will be propagated down the pipeline to the CSI, which will then expand
it to SGRBG16.

I suppose we should allow, at least for parallel input, to let the CSI
'convert' 12-bit input formats to 8-bit output formats by just ignoring
the LSBs.
Another possibility would be to just allow SGRBG12_1X12 -> SGRBG8_1X8
mbus codes in link_validate. Actually, does your hardware have 12 data
lines connected between sensor and i.MX6, or just 8 ?

> And I do not get any errors from these commands.

That's because of the way the V4L2 API works, unsupported formats are
adjusted by the drivers:

https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/vidioc-subdev-g-fmt.html#description

[...]
> What confuses me here is that the Pixel Format shown by v4l2-ctl is
> 'GR16', which is not what I expected. And it seems like the media-ctl
> pad configuration commands are unable to change the Pixel Format, even
> though they do not return any errors.

Whenever you media-ctl -V on a source pad, it will also try to set the
connected sink pad to the same format. And for subdevices with sink and
source pads, the source pads usually mirror (or somehow depend on) the
format of the sink pad. Due to the way the V4L2 APIs correct your input
to possible values, calling media-ctl -V on all source pads of the
pipeline in downstream direction essentially propagates the sensor
source pad format.

regards
Philipp
