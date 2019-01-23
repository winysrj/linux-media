Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C9AC282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 23:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D8F621855
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 23:21:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="wvATJbmb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfAWXVv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 18:21:51 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:39354 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfAWXVv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 18:21:51 -0500
Received: by mail-wr1-f43.google.com with SMTP id t27so4468910wra.6
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 15:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=DoeTaVFrMZ2oKlwxnOYRQHTU66GJ/vPCiRX9lAZnP1s=;
        b=wvATJbmbhQDKIrE8046vsHrhwKQtskULU17ytFrZtWeoZRb8cP4e8K4L/b9kGp4g4f
         HSMo4U2Zj6oTJ7uHN0TVgQzM/FS43bbufDoOQQJ3wOWoc/MZHUGuBjdOriBhJgguezYs
         yb+hLofWGLTGdxL3Vvu0QcS2Epc/rVTmjGlPpFe+p7hbzNjEZeqSgPsKuT+81u53gYDB
         r9gt/sjy3Ts9rT+gkjaWiX1SolV6y4FTw5Xv25AraLwrpd3eH1mo75J+4yrxrkRERoH0
         OXVsQbOBoAq5xDqb+U2Sr3azFNEiYCUwOn+0+2smB/fiOZa5gapjgWnsOV98ufh4kpIy
         OOhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=DoeTaVFrMZ2oKlwxnOYRQHTU66GJ/vPCiRX9lAZnP1s=;
        b=eKU1b2RVc7iauLSqB5t6dvrke9Ocu9aiP1hUcr587T/oauLrX0zIKYqOtZvSWw5DOQ
         vxVD57xoMtn1i2USigPcdNbvm7hUiStlz0WDqWr8AYOmZ9Ye1gvnh8dhPHBVTuTLAHYP
         eyhWntU/SnQGrYwy0mI9rFNT3IY2Ib/wcjignh0zE4LzNeis71nM7pZMF6/wvDCo0LTO
         FuxbizSiYx1FLMmI9PLUmYF+f5cBJiMtuRPqHUtnjdRolcCBtdhzkwjTUGZfVNG/cAG/
         x1mRtL+toqq+yEyv88vKeeKAqlvsahRJEq1U3aj5VyKtHwo/hm4nLDaBiD4RVAH7WSHB
         htkw==
X-Gm-Message-State: AJcUukd+FJ9R62icK47+RydGfSlncGe6YoZ0z9u3M03o1BBOtx4nRxLH
        Ks86XOB620ouD4pjWSjgN3zn/vdtIa957d4/p4aio518
X-Google-Smtp-Source: ALg8bN66OM1S3ud95L5IleYQDl4jDkpjtwqS2ZKpfSAhCPHOWYlk40g3TtUFKLRZc7azMpI/XtTe9y2A3dKlpb9Oea8=
X-Received: by 2002:adf:8228:: with SMTP id 37mr4567727wrb.160.1548285708616;
 Wed, 23 Jan 2019 15:21:48 -0800 (PST)
MIME-Version: 1.0
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Wed, 23 Jan 2019 15:21:37 -0800
Message-ID: <CAJ+vNU0ic=wzSC9V4hbmarN0JeQMs121MzD6tH5KQ+ezENUNfA@mail.gmail.com>
Subject: IMX CSI capture issues with tda1997x HDMI receiver
To:     linux-media <linux-media@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Steve,

I'm testing IMX6 capture again with the tda1997x HDMI receiver found
on Gateworks GW54xx and GW551x boards. This is hooked up to the IMX6
CSI in a way where it can be configured for 8bit BT656 mode
(UYVY8_2X8) or 16bit YUV mode (UYVY8_1X16). Also I have a Marshall
Electronics V-SG4K-HDI HDMI signal generator here so I can test a wide
variety of resolutions, bus formats, interlaced modes, and
colorspaces.

I'm using the following for testing:
- Linux 4.20 +
  - media: imx-csi: Input connections to CSI should be optional
  - imx-media: Fixes for interlaced capture
  - media: imx: Stop stream before disabling IDMA channels
- v4l-utils 1.16.1
- gstreamer-1.14.1 (with the ability to test master as well)

I have a script that generates the media-ctl/v4l2-ctl commands based
on providing a sensor ('adv7180' analog decoder or 'tda1997x' HDMI
decoder) and a 'mode' which I've defined as:
mode0: sensor -> mux -> csi -> /dev/videoN
mode1: sensor -> mux -> csi -> ic_prp -> ic_prpenc -> /dev/videoN (provides a
mode2: sensor -> mux -> csi -> ic_prp -> ic_prpvf -> /dev/videoN
mode3: sensor -> mux -> csi -> vdic -> ic_prp -> ic_prpvf -> /dev/videoN

The media-ctl topologies for each cpu/board combo are at
http://dev.gateworks.com/docs/linux/media/

I'm trying to test out simple v4l2-ctl based capture of a single frame
as well as capture and stream via both software JPEG encode and H264
hardware encode via CODA.

Please let me know of any changes that should be made to the commands
below even if only to purely help document things through clarity.

One of the issues I run into right away is image size: The imx.rst
docs state that the ic has a 'resize' limit of 1024x1024 but I think
I'm mislead by the word 'resize' and this also means you can't push
say 1080x720 through it (not resizing, just putting that on the src
pad) as it clips it to 1024x720. I believe some of Phillip's pending
patches may be aimed at rectifying this limitation?

Another issue I'm running into is colorspace conversion, specifically
colorimetry

Example: imx6q-gw54xx tda19971 720p60Hz YUV via BT656 IPU1_CSI0
MODE1:sensor->mux->csi->ic_prp->ic_prpenc
# set sensor output pad to sensor source format
v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
# sensor format
media-ctl --get-v4l2 '"tda19971 2-0048":0' # fmt:UYVY8_2X8/1280x720
field:none colorspace:rec709
# reset all links
media-ctl --reset
# setup links
media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
media-ctl -l "'ipu1_csi0':1 -> 'ipu1_ic_prp':0[1]"
media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
# configure pads
media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_2X8/1280x720 field:none]"
media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_2X8/1280x720 field:none]"
media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/1280x720]"
media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/1280x720]"
media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/1280x720]"
# capture device
media-ctl -e 'ipu1_ic_prpenc capture' # /dev/video0
v4l2-ctl --device /dev/video0 --get-fmt-video
Format Video Capture:
        Width/Height      : 1024/720
        Pixel Format      : 'UYVY' (UYVY 4:2:2)
        Field             : None
        Bytes per Line    : 2048
        Size Image        : 1474560
        Colorspace        : Rec. 709
        Transfer Function : Rec. 709
        YCbCr/HSV Encoding: ITU-R 601
        Quantization      : Limited Range
        Flags             :
^^^ Note 1080x720 has been reduced to 1024x720 - ouch!
# capture 1 frame
v4l2-ctl --device /dev/video0 --stream-mmap --stream-to=x.raw --stream-count=1
^^^ works
# stream JPEG/RTP/UDP
gst-launch-1.0 v4l2src device=/dev/video0 ! \
  video/x-raw,format=UYVY ! \
  jpegenc ! rtpjpegpay ! udpsink host=172.24.20.19 port=5000
^^^ works (but of course squashed horizontally because of x=1024)
# stream H264/RTP/UDP (via coda)
# need to make sure we feed coda NV12/rec709
media-ctl --get-v4l2 '"ipu1_ic_prpenc":0' #
fmt:AYUV8_1X32/1280x720@1/25 field:none colorspace:rec709 xfer:709
ycbcr:601 quantization:lim-range
^^^ input colorspace is rec709 but colorimetry needs to be changed to 709
media-ctl --set-v4l2 '"ipu1_ic_prpenc":0[fmt:AYUV32/1280x720
colorspace:rec709 ycbcr:709]'
^^^ no error but doing a get-v4l2 shows no change - is this all
because of trying to deal with 1080 instead of 1024?
gst-launch-1.0 v4l2src device=/dev/video0 ! \
  v4l2h264enc output-io-mode=dmabuf-import ! \
  rtph264pay ! udpsink host=172.24.20.19 port=5001
v4l2src0: Device '/dev/video0' does not support 2:0:0:0 colorimetry
^^^ fails because of colorimetry not getting set

Let me remove the >1024 issue by using a 480p source...

Example: imx6q-gw54xx tda19971 480p60Hz YUV via BT656 IPU1_CSI0
MODE1:sensor->mux->csi->ic_prp->ic_prpenc
# set sensor output pad to sensor source format
v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
# sensor format
media-ctl --get-v4l2 '"tda19971 2-0048":0' # fmt:UYVY8_2X8/720x480
field:none colorspace:rec709
# reset all links
media-ctl --reset
# setup links
media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
media-ctl -l "'ipu1_csi0':1 -> 'ipu1_ic_prp':0[1]"
media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
# configure pads
media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_2X8/720x480 field:none]"
media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_2X8/720x480 field:none]"
media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/720x480]"
media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/720x480]"
media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/720x480]"
media-ctl --get-v4l2 '"ipu1_ic_prpenc":1'
  [fmt:AYUV8_1X32/720x480@1/25 field:none colorspace:rec709 xfer:709
ycbcr:601 quantization:lim-range]
# capture device
media-ctl -e 'ipu1_ic_prpenc capture' # /dev/video0
v4l2-ctl --device /dev/video0 --get-fmt-video
Format Video Capture:
        Width/Height      : 720/480
        Pixel Format      : 'UYVY' (UYVY 4:2:2)
        Field             : None
        Bytes per Line    : 1440
        Size Image        : 691200
        Colorspace        : Rec. 709
        Transfer Function : Rec. 709
        YCbCr/HSV Encoding: ITU-R 601
        Quantization      : Limited Range
        Flags             :
# capture 1 frame
v4l2-ctl --device /dev/video0 --stream-mmap --stream-to=x.raw --stream-count=1
convert -size 720x480 -depth 16 uyvy:x.raw /var/www/html/files/frame.png
^^^ works
# stream JPEG/RTP/UDP
gst-launch-1.0 v4l2src device=/dev/video0 ! \
  video/x-raw,format=UYVY ! \
  jpegenc ! rtpjpegpay ! udpsink host=172.24.20.19 port=5000
# stream H264/RTP/UDP
media-ctl --get-v4l2 '"ipu1_ic_prpenc":0'
 [fmt:AYUV8_1X32/720x480@1/25 field:none colorspace:rec709 xfer:709
ycbcr:601 quantization:lim-range]
^^^ again, need to change colorimetry to 709
media-ctl --set-v4l2 '"ipu1_ic_prpenc":0[fmt:AYUV32/720x480
colorspace:rec709 ycbcr:709]'
media-ctl --get-v4l2 '"ipu1_ic_prpenc":0'
 [fmt:AYUV8_1X32/720x480@1/25 field:none colorspace:rec709 xfer:709
ycbcr:601 quantization:lim-range]
^^^ still not changing
gst-launch-1.0 v4l2src device=/dev/video0 ! \
  v4l2h264enc output-io-mode=dmabuf-import ! \
  rtph264pay ! udpsink host=172.24.20.19 port=5001
v4l2src0: Device '/dev/video0' does not support 2:0:0:0 colorimetry
^^^ fails because of colorimetry not getting set

Let's try an interlaced format...

Example: imx6q-gw54xx tda19971 480i60Hz YUV via BT656 IPU1_CSI0
MODE1:sensor->mux->csi->ic_prp->ic_prpenc
# set sensor output pad to sensor source format
v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
# sensor format
media-ctl --get-v4l2 '"tda19971 2-0048":0' # fmt:UYVY8_2X8/720x480
field:seq-tb colorspace:rec709
# reset all links
media-ctl --reset
# setup links
media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
media-ctl -l "'ipu1_csi0':1 -> 'ipu1_vdic':0[1]"
media-ctl -l "'ipu1_vdic':2 -> 'ipu1_ic_prp':0[1]"
media-ctl -l "'ipu1_ic_prp':2 -> 'ipu1_ic_prpvf':0[1]"
media-ctl -l "'ipu1_ic_prpvf':1 -> 'ipu1_ic_prpvf capture':0[1]"
# configure pads
media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_2X8/720x480 field:seq-tb]"
media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_2X8/720x480 field:seq-tb]"
media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/720x480]"
media-ctl -V "'ipu1_vdic':2 [fmt:AYUV32/720x480]"
media-ctl -V "'ipu1_ic_prp':2 [fmt:AYUV32/720x480]"
media-ctl -V "'ipu1_ic_prpvf':1 [fmt:AYUV32/720x480]"
# capture device
media-ctl -e 'ipu1_ic_prpvf capture' # /dev/video1
v4l2-ctl --device /dev/video1 --get-fmt-video
Format Video Capture:
        Width/Height      : 720/480
        Pixel Format      : 'UYVY' (UYVY 4:2:2)
        Field             : None
        Bytes per Line    : 1440
        Size Image        : 691200
        Colorspace        : Rec. 709
        Transfer Function : Rec. 709
        YCbCr/HSV Encoding: ITU-R 601
        Quantization      : Limited Range
        Flags             :
# capture 1 frame
v4l2-ctl --device /dev/video1 --stream-mmap --stream-to=x.raw --stream-count=1
^^^ fails with ipu1_ic_prpvf: EOF timeout
^^^ this is almost identical to the adv7180 case which works... the
only exception I see is field:seq-tb vs field:alternate from the
source which should be fine (more specific than 'alternate')

Now lets go back to a 480p60 source but this time include the vdic
(which isn't necessary but should still work right?)

Example: imx6q-gw54xx tda19971 480p60Hz YUV via BT656 IPU1_CSI0
MODE1:sensor->mux->csi->vdic->ic_prp->ic_prpvf
# set sensor output pad to sensor source format
v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
# sensor format
media-ctl --get-v4l2 '"tda19971 2-0048":0' # fmt:UYVY8_2X8/720x480
field:none colorspace:rec709
# reset all links
media-ctl --reset
# setup links
media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
media-ctl -l "'ipu1_csi0':1 -> 'ipu1_vdic':0[1]"
media-ctl -l "'ipu1_vdic':2 -> 'ipu1_ic_prp':0[1]"
media-ctl -l "'ipu1_ic_prp':2 -> 'ipu1_ic_prpvf':0[1]"
media-ctl -l "'ipu1_ic_prpvf':1 -> 'ipu1_ic_prpvf capture':0[1]"
# configure pads
media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_2X8/720x480 field:none]"
media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_2X8/720x480 field:none]"
media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/720x480]"
media-ctl -V "'ipu1_vdic':2 [fmt:AYUV32/720x480]"
media-ctl -V "'ipu1_ic_prp':2 [fmt:AYUV32/720x480]"
media-ctl -V "'ipu1_ic_prpvf':1 [fmt:AYUV32/720x480]"
# capture device
media-ctl -e 'ipu1_ic_prpvf capture' # /dev/video1
v4l2-ctl --device /dev/video1 --get-fmt-video
Format Video Capture:
        Width/Height      : 720/480
        Pixel Format      : 'UYVY' (UYVY 4:2:2)
        Field             : None
        Bytes per Line    : 1440
        Size Image        : 691200
        Colorspace        : Rec. 709
        Transfer Function : Rec. 709
        YCbCr/HSV Encoding: ITU-R 601
        Quantization      : Limited Range
        Flags             :
# capture 1 frame
v4l2-ctl --device /dev/video1 --stream-mmap --stream-to=x.raw --stream-count=1
ipu1_ic_prpvf: pipeline start failed with -32
^^^ maybe because we are feeding progressive to vdic? vdic isn't
needed here but it seems it should not fail to me

ok now I'm going to boot with a different device-tree that connects
the tda1997x to IMX6 via 16bit YUV. Advantages of this mode should be
1) better pixel bpp 2) colorimetry is rec709 so no conversion needed
for coda 3) ability to capture 1080p60 as I have confirmed tyring to
do so via bt656 exceeds the IMX pixel clock rate and causes CSI
corruption. Downsides to this mode is that I currently have a bug in
the tda1997x driver regarding this mode and interlaced capture.

Example: imx6q-gw54xx tda19971 480p60Hz YUV via 16bit YUV IPU1_CSI0
MODE0:sensor->mux->csi
# set sensor output pad to sensor source format
v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
# sensor format
media-ctl --get-v4l2 '"tda19971 2-0048":0' # fmt:UYVY8_1X16/720x480
field:none colorspace:rec709
# reset all links
media-ctl --reset
# setup links
media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
# configure pads
media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/720x480 field:none]"
media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/720x480 field:none]"
media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
media-ctl --get-v4l2 '"ipu1_csi0":2'
                [fmt:UYVY8_1X16/720x480@1/30 field:none
colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range]
# capture device
media-ctl -e 'ipu1_csi0 capture' # /dev/video4
v4l2-ctl --device /dev/video4 --get-fmt-video
Format Video Capture:
        Width/Height      : 720/480
        Pixel Format      : 'UYVY' (UYVY 4:2:2)
        Field             : None
        Bytes per Line    : 1440
        Size Image        : 691200
        Colorspace        : Rec. 709
        Transfer Function : Rec. 709
        YCbCr/HSV Encoding: Rec. 709
        Quantization      : Limited Range
        Flags             : premultiplied-alpha
# capture 1 frame
v4l2-ctl --device /dev/video4 --stream-mmap --stream-to=x.raw --stream-count=1
convert -size 720x480 -depth 16 uyvy:x.raw /var/www/html/files/frame.png
# stream JPEG/RTP/UDP
gst-launch-1.0 v4l2src device=/dev/video4 ! \
  video/x-raw,format=UYVY ! \
  jpegenc ! rtpjpegpay ! udpsink host=172.24.20.19 port=5000
# stream H264/RTP/UDP
media-ctl --get-v4l2 '"ipu1_csi0":0'
                [fmt:UYVY8_1X16/720x480@1/30 field:none
colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range
                 crop.bounds:(0,0)/720x480
                 crop:(0,0)/720x480
                 compose.bounds:(0,0)/720x480
                 compose:(0,0)/720x480]
^^^ no conv needed
media-ctl --get-v4l2 '"ipu1_csi0":0'
gst-launch-1.0 v4l2src device=/dev/video4 ! \
  v4l2h264enc output-io-mode=dmabuf-import ! \
  rtph264pay ! udpsink host=172.24.20.19 port=5001
v4l2src0: Internal data stream error.
^^^ fails... lets set the csi format again
media-ctl --set-v4l2 '"ipu1_csi0":0[fmt:AYUV32/720x480
colorspace:rec709 ycbcr:709]'
media-ctl --get-v4l2 '"ipu1_csi0":0'
                [fmt:UYVY8_2X8/720x480@1/30 field:none
colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range
                 crop.bounds:(0,0)/720x480
                 crop:(0,0)/720x480
                 compose.bounds:(0,0)/720x480
                 compose:(0,0)/720x480]
^^^ wtf... the fcc is not showing UYVY8_2X8 which is just wrong and
even v4l2 frame capture will fail now

Any ideas on any of the above issues?

Best Regards,

Tim
