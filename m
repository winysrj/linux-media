Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:43048 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbdL1V4M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 16:56:12 -0500
Received: by mail-wm0-f44.google.com with SMTP id n138so45823280wmg.2
        for <linux-media@vger.kernel.org>; Thu, 28 Dec 2017 13:56:12 -0800 (PST)
MIME-Version: 1.0
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 28 Dec 2017 13:56:10 -0800
Message-ID: <CAJ+vNU1mRdxbfhEJY+n+U75cWW_op1Z+AzHOG=To8ooPzt9SJA@mail.gmail.com>
Subject: IMX6 interlaced capture
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hansverk@cisco.com>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve/Hans,

I'm trying to get interlaced capture working with the TDA1997x driver
I've been working on which is connected to an IMX6 CSI.

The particular board I'm currently testing on is an IMX6Q which has
both a TDA19971 HDMI receiver as well as an ADV7180 analog video
decoder. The media-ctl topology for this board can be found at
http://dev.gateworks.com/docs/linux/media/imx6q-gw54xx-media.png.

For adv7180 everything appears to be working as expected:
- media-ctl --get-v4l2 '"adv7180 2-0020":0' shows:
[fmt:UYVY8_2X8/720x480 field:interlaced colorspace:smpte170m]
- he following captures/streams from the adv7180 using the vdic to de-interlace:
media-ctl --link "adv7180 2-0020":0 -> "ipu2_csi1_mux":1[1]
media-ctl --link "ipu2_csi1_mux":2 -> "ipu2_csi1":0[1]
media-ctl --link "ipu2_csi1":1 -> "ipu2_vdic":0[1]
media-ctl --link "ipu2_vdic":2 -> "ipu2_ic_prp":0[1]
media-ctl --link "ipu2_ic_prp":2 -> "ipu2_ic_prpvf":0[1]
media-ctl --link "ipu2_ic_prpvf":1 -> "ipu2_ic_prpvf capture":0[1]
media-ctl --set-v4l2 'adv7180 2-0020':0 [fmt:UYVY2X8/720x480]
media-ctl --set-v4l2 'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480 field:interlaced]
media-ctl --set-v4l2 'ipu2_csi1':1 [fmt:UYVY2X8/720x480 field:interlaced]
media-ctl --set-v4l2 'ipu2_vdic':2 [fmt:UYVY2X8/720x480 field:interlaced]
media-ctl --set-v4l2 'ipu2_ic_prp':2 [fmt:UYVY2X8/720x480 field:none]
media-ctl --set-v4l2 'ipu2_ic_prpvf':1 [fmt:UYVY2X8/720x480 field:none]
v4l2-ctl -d /dev/video3 --set-fmt-video=width=720,height=480,pixelformat=UYVY
# capture 1 frame
v4l2-ctl -d /dev/video1 --stream-mmap --stream-skip=1
--stream-to=/tmp/x.raw --stream-count=1
# stream jpeg/rtp
gst-launch-1.0 v4l2src device=/dev/video3 !
  "video/x-raw,width=720,height=480,format=UYVY" !
   jpegenc ! rtpjpegpay ! udpsink host=$SERVER port=5000"

For the tda1997x I'm trying to do something similar:
- media-ctl --get-v4l2 '"tda19971 2-0048":0' shows:
[fmt:UYVY8_1X16/1920x1080 field:alternate colorspace:srgb]
^^^^ still not sure V4L2_FIELD_ALTERNATE/SRGB returned from tda1997x
get_fmt is correct
- I setup the pipeline with:
media-ctl --link "tda19971 2-0048":0 -> "ipu1_csi0_mux":1[1]
media-ctl --link "ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]
media-ctl --link "ipu1_csi0":1 -> "ipu1_vdic":0[1]
media-ctl --link "ipu1_vdic":2 -> "ipu1_ic_prp":0[1]
media-ctl --link "ipu1_ic_prp":2 -> "ipu1_ic_prpvf":0[1]
media-ctl --link "ipu1_ic_prpvf":1 -> "ipu1_ic_prpvf capture":0[1]
media-ctl --set-v4l2 'tda19971 2-0048':0[fmt:UYVY8_1X16/1920x1080]
media-ctl --set-v4l2 'ipu1_csi0_mux':2[fmt:UYVY8_1X16/1920x1080 field:alternate]
media-ctl --set-v4l2 'ipu1_csi0':1[fmt:UYVY8_1X16/1920x1080 field:alternate]
media-ctl --set-v4l2 'ipu1_vdic':2[fmt:UYVY8_1X16/1920x1080 field:alternate]
media-ctl --set-v4l2 'ipu1_ic_prp':2[fmt:UYVY8_1X16/1920x1080 field:none]
media-ctl --set-v4l2 'ipu1_ic_prpvf':1[fmt:UYVY8_1X16/1920x1080 field:none]
v4l2-ctl -d /dev/video1 --set-fmt-video=width=1920,height=1080,pixelformat=UYVY
v4l2-ctl -d /dev/v4l-subdev1 --set-dv-bt-timings=query
v4l2-ctl -d /dev/video1 --stream-mmap --stream-skip=1
--stream-to=/tmp/x.raw --stream-count=1
ipu1_csi0: bayer/16-bit parallel buses must go to IDMAC pad
ipu1_ic_prpvf: pipeline start failed with -22
VIDIOC_STREAMON: failed: Invalid argument
- if I try to use the idmac for deinterlace I configure the pipeline with:
media-ctl --link "tda19971 2-0048":0 -> "ipu1_csi0_mux":1[1]
media-ctl --link "ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]
media-ctl --link "ipu1_csi0":1 -> "ipu1_ic_prp":0[1]
media-ctl --link "ipu1_ic_prp":2 -> "ipu1_ic_prpvf":0[1]
media-ctl --link "ipu1_ic_prpvf":1 -> "ipu1_ic_prpvf capture":0[1]
media-ctl --set-v4l2 'tda19971 2-0048':0[fmt:UYVY8_1X16/1920x1080]
media-ctl --set-v4l2 'ipu1_csi0_mux':2[fmt:UYVY8_1X16/1920x1080 field:alternate]
media-ctl --set-v4l2 'ipu1_csi0':1[fmt:UYVY8_1X16/1920x1080 field:alternate]
media-ctl --set-v4l2 'ipu1_ic_prp':2[fmt:UYVY8_1X16/1920x1080 field:alternate]
media-ctl --set-v4l2 'ipu1_ic_prpvf':1[fmt:UYVY8_1X16/1920x1080 field:none]
v4l2-ctl -d /dev/video1 --set-fmt-video=width=1920,height=1080,pixelformat=UYVY
v4l2-ctl -d /dev/v4l-subdev1 --set-dv-bt-timings=query
v4l2-ctl -d /dev/video1 --stream-mmap --stream-to=/tmp/x.raw --stream-count=1
ipu1_csi0: bayer/16-bit parallel buses must go to IDMAC pad
ipu1_ic_prpvf: pipeline start failed with -22
VIDIOC_STREAMON: failed: Invalid argument

Any ideas?

Thanks,

Tim
