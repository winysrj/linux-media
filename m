Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:34820 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752263AbeADR5e (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 12:57:34 -0500
Received: by mail-wm0-f42.google.com with SMTP id a79so4852057wma.0
        for <linux-media@vger.kernel.org>; Thu, 04 Jan 2018 09:57:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <76a1cd63-7338-7f23-6228-5dc4db276b23@gmail.com>
References: <CAJ+vNU1mRdxbfhEJY+n+U75cWW_op1Z+AzHOG=To8ooPzt9SJA@mail.gmail.com>
 <76a1cd63-7338-7f23-6228-5dc4db276b23@gmail.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 4 Jan 2018 09:57:31 -0800
Message-ID: <CAJ+vNU1EivRc3t2JUvB-bdahm2HXukGNjQSG7BJ3ekO+9-ErSg@mail.gmail.com>
Subject: Re: IMX6 interlaced capture
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Hans Verkuil <hansverk@cisco.com>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 2, 2018 at 6:00 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> Hi Tim,
>
> Happy New Year! And pardon the delay.
>
>
> On 12/28/2017 01:56 PM, Tim Harvey wrote:
>>
>> Steve/Hans,
>>
>> I'm trying to get interlaced capture working with the TDA1997x driver
>> I've been working on which is connected to an IMX6 CSI.
>>
>> The particular board I'm currently testing on is an IMX6Q which has
>> both a TDA19971 HDMI receiver as well as an ADV7180 analog video
>> decoder. The media-ctl topology for this board can be found at
>> http://dev.gateworks.com/docs/linux/media/imx6q-gw54xx-media.png.
>>
>> For adv7180 everything appears to be working as expected:
>> - media-ctl --get-v4l2 '"adv7180 2-0020":0' shows:
>> [fmt:UYVY8_2X8/720x480 field:interlaced colorspace:smpte170m]
>> - he following captures/streams from the adv7180 using the vdic to
>> de-interlace:
>> media-ctl --link "adv7180 2-0020":0 -> "ipu2_csi1_mux":1[1]
>> media-ctl --link "ipu2_csi1_mux":2 -> "ipu2_csi1":0[1]
>> media-ctl --link "ipu2_csi1":1 -> "ipu2_vdic":0[1]
>> media-ctl --link "ipu2_vdic":2 -> "ipu2_ic_prp":0[1]
>> media-ctl --link "ipu2_ic_prp":2 -> "ipu2_ic_prpvf":0[1]
>> media-ctl --link "ipu2_ic_prpvf":1 -> "ipu2_ic_prpvf capture":0[1]
>> media-ctl --set-v4l2 'adv7180 2-0020':0 [fmt:UYVY2X8/720x480]
>> media-ctl --set-v4l2 'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480
>> field:interlaced]
>> media-ctl --set-v4l2 'ipu2_csi1':1 [fmt:UYVY2X8/720x480 field:interlaced]
>> media-ctl --set-v4l2 'ipu2_vdic':2 [fmt:UYVY2X8/720x480 field:interlaced]
>> media-ctl --set-v4l2 'ipu2_ic_prp':2 [fmt:UYVY2X8/720x480 field:none]
>> media-ctl --set-v4l2 'ipu2_ic_prpvf':1 [fmt:UYVY2X8/720x480 field:none]
>> v4l2-ctl -d /dev/video3
>> --set-fmt-video=width=720,height=480,pixelformat=UYVY
>> # capture 1 frame
>> v4l2-ctl -d /dev/video1 --stream-mmap --stream-skip=1
>> --stream-to=/tmp/x.raw --stream-count=1
>> # stream jpeg/rtp
>> gst-launch-1.0 v4l2src device=/dev/video3 !
>>    "video/x-raw,width=720,height=480,format=UYVY" !
>>     jpegenc ! rtpjpegpay ! udpsink host=$SERVER port=5000"
>>
>> For the tda1997x I'm trying to do something similar:
>> - media-ctl --get-v4l2 '"tda19971 2-0048":0' shows:
>> [fmt:UYVY8_1X16/1920x1080 field:alternate colorspace:srgb]
>> ^^^^ still not sure V4L2_FIELD_ALTERNATE/SRGB returned from tda1997x
>> get_fmt is correct
>> - I setup the pipeline with:
>> media-ctl --link "tda19971 2-0048":0 -> "ipu1_csi0_mux":1[1]
>> media-ctl --link "ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]
>> media-ctl --link "ipu1_csi0":1 -> "ipu1_vdic":0[1]
>> media-ctl --link "ipu1_vdic":2 -> "ipu1_ic_prp":0[1]
>> media-ctl --link "ipu1_ic_prp":2 -> "ipu1_ic_prpvf":0[1]
>> media-ctl --link "ipu1_ic_prpvf":1 -> "ipu1_ic_prpvf capture":0[1]
>> media-ctl --set-v4l2 'tda19971 2-0048':0[fmt:UYVY8_1X16/1920x1080]
>> media-ctl --set-v4l2 'ipu1_csi0_mux':2[fmt:UYVY8_1X16/1920x1080
>> field:alternate]
>> media-ctl --set-v4l2 'ipu1_csi0':1[fmt:UYVY8_1X16/1920x1080
>> field:alternate]
>> media-ctl --set-v4l2 'ipu1_vdic':2[fmt:UYVY8_1X16/1920x1080
>> field:alternate]
>> media-ctl --set-v4l2 'ipu1_ic_prp':2[fmt:UYVY8_1X16/1920x1080 field:none]
>> media-ctl --set-v4l2 'ipu1_ic_prpvf':1[fmt:UYVY8_1X16/1920x1080
>> field:none]
>> v4l2-ctl -d /dev/video1
>> --set-fmt-video=width=1920,height=1080,pixelformat=UYVY
>> v4l2-ctl -d /dev/v4l-subdev1 --set-dv-bt-timings=query
>> v4l2-ctl -d /dev/video1 --stream-mmap --stream-skip=1
>> --stream-to=/tmp/x.raw --stream-count=1
>> ipu1_csi0: bayer/16-bit parallel buses must go to IDMAC pad
>> ipu1_ic_prpvf: pipeline start failed with -22
>> VIDIOC_STREAMON: failed: Invalid argument
>

Steve,

Thanks for the help.

>
> Right, according to the i.MX6 reference manual, if the CSI muxes
> are receiving from the parallel bus input with width >= 16 bits,
> that data can't be passed to the IC. It never really made much sense
> to me, and I can't remember if I ever tried it, maybe not, because
> I don't have such hardware.

hmmm... that's not good. I may have to dig into what's being done in
my 3.14 kernel with the Freescale capture driver where I can capture
1080p60 fine with my tda1997x driver there.

>
> Try this hack as an experiment: modify is_parallel_16bit_bus() in
> imx-media-csi.c to simply return false, and see if the above pipeline
> works.

I'm currently on 4.15-rc1 which doesn't have a
'is_parallel_16bit_bus()' but if I comment out the check we are
talking about in csi_link_validate as such:

--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -999,6 +999,7 @@ static int csi_link_validate(struct v4l2_subdev *sd,
        is_csi2 = (sensor_ep->bus_type == V4L2_MBUS_CSI2);
        incc = priv->cc[CSI_SINK_PAD];

+/*
        if (priv->dest != IPU_CSI_DEST_IDMAC &&
            (incc->bayer || (!is_csi2 &&
                             sensor_ep->bus.parallel.bus_width >= 16))) {
@@ -1007,6 +1008,7 @@ static int csi_link_validate(struct v4l2_subdev *sd,
                ret = -EINVAL;
                goto out;
        }
+*/

        if (is_csi2) {
                int vc_num = 0;

I get a pipeline start failure for ipu1_ic_prpvf:

root@ventana:~# v4l2-ctl -d /dev/video1 --stream-mmap --stream-skip=1
--stream-to=/tmp/x.raw --stream-count=1
[  909.993353] tda1997x 2-0048: tda1997x_get_pad_format
[  909.998342] tda1997x 2-0048: tda1997x_fill_format
^^^^ my tda1997x driver debug messages
[  910.004483] ipu1_ic_prpvf: pipeline start failed with -32
VIDIOC_STREAMON: failed: Broken pipe

>
>> - if I try to use the idmac for deinterlace I configure the pipeline with:
>> media-ctl --link "tda19971 2-0048":0 -> "ipu1_csi0_mux":1[1]
>> media-ctl --link "ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]
>> media-ctl --link "ipu1_csi0":1 -> "ipu1_ic_prp":0[1]
>> media-ctl --link "ipu1_ic_prp":2 -> "ipu1_ic_prpvf":0[1]
>> media-ctl --link "ipu1_ic_prpvf":1 -> "ipu1_ic_prpvf capture":0[1]
>> media-ctl --set-v4l2 'tda19971 2-0048':0[fmt:UYVY8_1X16/1920x1080]
>> media-ctl --set-v4l2 'ipu1_csi0_mux':2[fmt:UYVY8_1X16/1920x1080
>> field:alternate]
>> media-ctl --set-v4l2 'ipu1_csi0':1[fmt:UYVY8_1X16/1920x1080
>> field:alternate]
>> media-ctl --set-v4l2 'ipu1_ic_prp':2[fmt:UYVY8_1X16/1920x1080
>> field:alternate]
>> media-ctl --set-v4l2 'ipu1_ic_prpvf':1[fmt:UYVY8_1X16/1920x1080
>> field:none]
>> v4l2-ctl -d /dev/video1
>> --set-fmt-video=width=1920,height=1080,pixelformat=UYVY
>> v4l2-ctl -d /dev/v4l-subdev1 --set-dv-bt-timings=query
>> v4l2-ctl -d /dev/video1 --stream-mmap --stream-to=/tmp/x.raw
>> --stream-count=1
>> ipu1_csi0: bayer/16-bit parallel buses must go to IDMAC pad
>> ipu1_ic_prpvf: pipeline start failed with -22
>> VIDIOC_STREAMON: failed: Invalid argument
>
>
> For idmac de-interlace (interweaving w/o motion compensation), you
> don't need to use the Image Converter paths (and the IC is not required
> here because I don't see any scaling or colorspace conversion in your
> pipeline). Send directly to the "ipu1_csi0 capture" device node. Try this,
> which doesn't need the hack I mentioned above:
>
> media-ctl --link "tda19971 2-0048":0 -> "ipu1_csi0_mux":1[1]
> media-ctl --link "ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]
> media-ctl --link "ipu1_csi0":2 -> "ipu1_csi0 capture":0[1]
>
> media-ctl --set-v4l2 'tda19971 2-0048':0[fmt:UYVY8_1X16/1920x1080]
> media-ctl --set-v4l2 'ipu1_csi0_mux':2[fmt:UYVY8_1X16/1920x1080
> field:alternate]
> media-ctl --set-v4l2 'ipu1_csi0':2[fmt:UYVY8_1X16/1920x1080 field:none
>
> v4l2-ctl -d /dev/video4
> --set-fmt-video=width=1920,height=1080,pixelformat=UYVY
> v4l2-ctl -d /dev/v4l-subdev1 --set-dv-bt-timings=query
> v4l2-ctl -d /dev/video4 --stream-mmap --stream-to=/tmp/x.raw
> --stream-count=1
>

This produced a 4147200 byte frame
(http://dev.gateworks.com/docs/linux/media/x.raw) yet I couldn't seem
to convert it with 'convert -size 1920x1080 -depth 16'.

If I stream with gstreamer (gst-launch-1.0 v4l2src device=/dev/video4
! video/x-raw,width=1920,height=1080,format=UYVY ! jpegenc !
rtpjpegpay ! udpsink host=172.24.20.19 port=5000) I see both top/bot
frames within the same image whereas a non-interlaced source looks
fine. Perhaps my gstreamer config is wrong?

Tim
