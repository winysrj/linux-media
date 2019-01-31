Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBC6C282D7
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 01:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3BF62184D
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 01:18:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="nuDMD+BW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfAaBSU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 20:18:20 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:33262 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfAaBSU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 20:18:20 -0500
Received: by mail-wr1-f43.google.com with SMTP id p7so1524159wru.0
        for <linux-media@vger.kernel.org>; Wed, 30 Jan 2019 17:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uaHBQK8n/p5Ufc8DHxP4idI5hjnZE+ENp+iijTjwxp4=;
        b=nuDMD+BWIQ+BJ2q7RuerxZmltVW1h4iNi6jQ/LqYd1PJ51ZMwGX2Vo2bs1vF6F8Mhr
         BfL4jcBgBYcSBSNYLa3GAGu9SmQmLrnnWcSI5un6NmiW05LM1J2yZ6CSxOVuUoA0P7b3
         qhXWkYLDRk/EEAJ9NDo+pkk5hHE2ThgoCGMV8S+Jdw1nLRlQ1LIrTCQdWhsRZ4dlQuRu
         Izj97iabJJxqMs8UVzdOAzAHRDAOCohiWfF/yWGZHegSBdIHRq5eX0fqFK+o7+d1cQMg
         xXdIy+3tHQUAXGvjE/sCIIFXQFIyUqHzsT0YWWMiAdF2EoChNAsWbPOmmXrrhiPSIORm
         AzAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uaHBQK8n/p5Ufc8DHxP4idI5hjnZE+ENp+iijTjwxp4=;
        b=DM9MDFDmc8kpSNXg28P0vHqp2G5frVYHYxc3g7EILW17lAGNUzBxhbVgyOdeCejmdp
         7rJYt8+5V4RVxGchBdPIsVfl/xnGVq+OSaQrUKt/nf2WXaDwU8FUB8F/xfX80OM7k7GE
         A9sZg15Hkl1A+qea593qD6OvUwULOqxjnmA5y5ZrWabaSyNGn60I8i/Ud0RX1vTs68Fn
         UVpDLoyX346dVuHwd02h75b6MTdTMdn0936B6wOuHv9YKIYH+GOe1fzfrB2pzitSlKn3
         PTpsCkNhKLmKsK7twZW8OwrN9etblztRCylAWmBxuyJSHH8cQdcUEVvOYSe6dP9xEX/w
         kp5w==
X-Gm-Message-State: AJcUukfIqvhvYG03puln85eB4qSKCT3+I/BngK+Utp6WxlRYMUlW/42L
        NL0sgaKFKV4hplR5OuHGXJLxFPysPrAylGogR1OpRg==
X-Google-Smtp-Source: ALg8bN6UiQPfavH72QjzqenFD6nb3JPXtmYMJ1cyZNXDFXl094BGvcdYSZcW+q9eD2+3gcwYnQMULaw3uMTuTGt2WII=
X-Received: by 2002:a05:6000:108d:: with SMTP id y13mr30908452wrw.135.1548897496005;
 Wed, 30 Jan 2019 17:18:16 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+vNU0ic=wzSC9V4hbmarN0JeQMs121MzD6tH5KQ+ezENUNfA@mail.gmail.com>
 <02e8680c-9fd5-ff54-f292-f6936c76583e@gmail.com> <CAJ+vNU0YQeiPaE8tapJnihoj3DtewCPTj05BZv5cJ65YkE9MeQ@mail.gmail.com>
 <db70e0f7-0ad4-62f5-e64c-49c04c089dd6@gmail.com>
In-Reply-To: <db70e0f7-0ad4-62f5-e64c-49c04c089dd6@gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Wed, 30 Jan 2019 17:18:04 -0800
Message-ID: <CAJ+vNU3X6ywgobcV+wQxEupkNeNmiWaT85xUOtKF_U44OAfskg@mail.gmail.com>
Subject: Re: IMX CSI capture issues with tda1997x HDMI receiver
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Jan 28, 2019 at 3:04 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
>
>
> On 1/28/19 11:03 AM, Tim Harvey wrote:
> > On Fri, Jan 25, 2019 at 3:57 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
> >> Hi Tim, cc: Philipp,
> >>
> >> On 1/23/19 3:21 PM, Tim Harvey wrote:
> >>> Steve,
> >>>
> >>> I'm testing IMX6 capture again with the tda1997x HDMI receiver found
> >>> on Gateworks GW54xx and GW551x boards. This is hooked up to the IMX6
> >>> CSI in a way where it can be configured for 8bit BT656 mode
> >>> (UYVY8_2X8) or 16bit YUV mode (UYVY8_1X16). Also I have a Marshall
> >>> Electronics V-SG4K-HDI HDMI signal generator here so I can test a wide
> >>> variety of resolutions, bus formats, interlaced modes, and
> >>> colorspaces.
> >>>
> >>> I'm using the following for testing:
> >>> - Linux 4.20 +
> >>>     - media: imx-csi: Input connections to CSI should be optional
> >>>     - imx-media: Fixes for interlaced capture
> >>>     - media: imx: Stop stream before disabling IDMA channels
> >>> - v4l-utils 1.16.1
> >>> - gstreamer-1.14.1 (with the ability to test master as well)
> >>>
> >>> I have a script that generates the media-ctl/v4l2-ctl commands based
> >>> on providing a sensor ('adv7180' analog decoder or 'tda1997x' HDMI
> >>> decoder) and a 'mode' which I've defined as:
> >>> mode0: sensor -> mux -> csi -> /dev/videoN
> >>> mode1: sensor -> mux -> csi -> ic_prp -> ic_prpenc -> /dev/videoN (provides a
> >>> mode2: sensor -> mux -> csi -> ic_prp -> ic_prpvf -> /dev/videoN
> >>> mode3: sensor -> mux -> csi -> vdic -> ic_prp -> ic_prpvf -> /dev/videoN
> >>>
> >>> The media-ctl topologies for each cpu/board combo are at
> >>> http://dev.gateworks.com/docs/linux/media/
> >>>
> >>> I'm trying to test out simple v4l2-ctl based capture of a single frame
> >>> as well as capture and stream via both software JPEG encode and H264
> >>> hardware encode via CODA.
> >>>
> >>> Please let me know of any changes that should be made to the commands
> >>> below even if only to purely help document things through clarity.
> >>>
> >>> One of the issues I run into right away is image size: The imx.rst
> >>> docs state that the ic has a 'resize' limit of 1024x1024 but I think
> >>> I'm mislead by the word 'resize' and this also means you can't push
> >>> say 1080x720 through it (not resizing, just putting that on the src
> >>> pad) as it clips it to 1024x720.
> >> The IC is limited to a resized *output* frame of 1024x1024, no higher.
> >>
> > Ok so this means for anything >1024 I need to either use the csi to
> > downscale it by factors of 2 first, or use mem2mem solution which
> > means I can't use the VDIC (so no interlaced).
>
> Actually that isn't true. You can still use a VDIC pipeline for the
> 1280x720 interlaced tda19971 source. It's just that you would need to
> downscale to <=1024 (either using the CSI /2, and/or using the IC prpvf
> scaler). Then use the mem2mem gstreamer element to upscale the prpvf
> capture output to something >1024.
>

True, that would work and here are my mem2mem testing findings:

I've found that mem2mem from the CSI works well:
- Using the CSI to downscale 720p then going through mem2mem and
upscaling it (works perfectly!)
# 720p@60Hz YUV BT656
# query current timings and set to this
v4l2-ctl -d $(media-ctl -e "tda19971 2-0048") --set-dv-bt-timings=query
# get timings
media-ctl --get-v4l2 '"tda19971 2-0048":0' # [fmt:UYVY8_2X8/1280x720
field:none colorspace:srgb]
# reset media controller links
media-ctl --reset
# create links
media-ctl --link '"tda19971 2-0048":0 -> "ipu1_csi0_mux":1[1]'
media-ctl --link '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
media-ctl --link '"ipu1_csi0":2 -> "ipu1_csi0 capture":0[1]'
# set pad formats
media-ctl --set-v4l2 '"tda19971 2-0048":0[fmt:UYVY8_2X8/1280x720]'
media-ctl --set-v4l2 '"ipu1_csi0_mux":2[fmt:UYVY8_2X8/1280x720]'
media-ctl --set-v4l2 '"ipu1_csi0":0[fmt:AYUV32/1280x720
colorspace:rec709 ycbcr:709]'
media-ctl --set-v4l2 '"ipu1_csi0":0[compose:(0,0)/640x360]' # 1/2 scale
media-ctl --get-v4l2 '"ipu1_csi0":2' # [fmt:AYUV8_1X32/640x360@1/30
field:none colorspace:rec709 xfer:709 ycbcr:709
quantization:lim-range]
# get video device
media-ctl -e 'ipu1_csi0 capture' # /dev/video4
# stream JPEG/RTP/UDP
gst-launch-1.0 v4l2src device=/dev/video0 ! \
  video/x-raw,format=UYVY ! \
  jpegenc ! rtpjpegpay ! udpsink host=172.24.20.19 port=5000
# ^^^^ works but video is 1/4scale 640x360
# get mem2mem device (here is perhaps a great reason to have the
mem2mem device in the media graph... so its easy to find the device
name)
grep ipu_ic_pp /sys/class/video4linux/*/name #
/sys/class/video4linux/video8/name:ipu_ic_pp mem2mem - so its
v4l2video8convert
# stream upscale via mem2mem then JPEG/RTP/UDP
gst-launch-1.0 v4l2src device=/dev/video4 ! \
  video/x-raw,format=UYVY ! \
  v4l2video8convert ! video/x-raw,width=1280,height=720 ! \
  jpegenc ! rtpjpegpay ! udpsink host=172.24.20.19 port=5000
# ^^^ works and video is back at 720p!
# stream H264/RTP/UDP
gst-launch-1.0 v4l2src device=/dev/video4 ! \
  v4l2video8convert ! video/x-raw,width=1280,height=720 ! \
  v4l2h264enc output-io-mode=dmabuf-import ! \
  rtph264pay ! udpsink host=172.24.20.19 port=5001
# ^^^ works - 720p via coda

But when going through the IC we again run into the issue where the
output of the IC isn't a suitable colorspace:
# 720p@60Hz YUV BT656
# set sensor output pad to sensor source format
v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
# sensor format
media-ctl --get-v4l2 '"tda19971 2-0048":0' # fmt:UYVY8_2X8/1280x720
field:none colorspace:srgb
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
media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/640x360 ]"
# downscale because the IC can't do >1024
media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x360 ]"
media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/640x360 ]"
media-ctl --get-v4l2 '"ipu1_ic_prpenc":1' #
[fmt:AYUV8_1X32/640x360@1/25 field:none colorspace:srgb xfer:srgb
ycbcr:601 quantization:lim-range]
# ^^^ note we are itu601 again b/c that's the only format the IC can ouput
# stream JPEG/RTP/UDP
gst-launch-1.0 v4l2src device=/dev/video0 ! \
  video/x-raw,format=UYVY ! \
  jpegenc ! rtpjpegpay ! udpsink host=172.24.20.19 port=5000
# ^^^ works... SW JPEG can handle itu601
# stream upscale via mem2mem then JPEG/RTP/UDP
gst-launch-1.0 v4l2src device=/dev/video4 ! \
  v4l2video8convert ! video/x-raw,width=1280,height=720 ! \
  jpegenc ! rtpjpegpay ! udpsink host=172.24.20.19 port=5000
ERROR: from element
/GstPipeline:pipeline0/v4l2video8convert:v4l2video8convert0: Device
'/dev/video8' does not support 2:4:7:1 colorimetry
# ^^^ fails because mem2mem doesn't support itu601
# stream H264/RTP/UDP
gst-launch-1.0 v4l2src device=/dev/video4 ! \
  v4l2h264enc output-io-mode=dmabuf-import ! \
  rtph264pay ! udpsink host=172.24.20.19 port=5001
ERROR: from element /GstPipeline:pipeline0/v4l2h264enc:v4l2h264enc0:
Device '/dev/video9' does not support 2:4:7:1 colorimetry
# ^^^ coda has same issue... can't del with itu601

Am I perhaps missing a capsfilter to get the mem2mem driver to convert
the colorspace properly? If so, they the mem2mem driver could be used
to correct the colorspace to get IC output to coda working.

Also can we connect the mem2mem driver to the unused VDIC input in the
media controller so that we can use the VDIC to de-interlace content
captured from non IMX sources (ie PCI or USB capture devices)?

<snip>
> >
> >>> Another issue I'm running into is colorspace conversion, specifically
> >>> colorimetry
> >>>
> >>> Example: imx6q-gw54xx tda19971 720p60Hz YUV via BT656 IPU1_CSI0
> >>> MODE1:sensor->mux->csi->ic_prp->ic_prpenc
> >>> # set sensor output pad to sensor source format
> >>> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
> >>> # sensor format
> >>> media-ctl --get-v4l2 '"tda19971 2-0048":0' # fmt:UYVY8_2X8/1280x720
> >>> field:none colorspace:rec709
> >>> # reset all links
> >>> media-ctl --reset
> >>> # setup links
> >>> media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
> >>> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
> >>> media-ctl -l "'ipu1_csi0':1 -> 'ipu1_ic_prp':0[1]"
> >>> media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
> >>> media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
> >>> # configure pads
> >>> media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_2X8/1280x720 field:none]"
> >>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_2X8/1280x720 field:none]"
> >>> media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/1280x720]"
> >>> media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/1280x720]"
> >>> media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/1280x720]"
> >>> # capture device
> >>> media-ctl -e 'ipu1_ic_prpenc capture' # /dev/video0
> >>> v4l2-ctl --device /dev/video0 --get-fmt-video
> >>> Format Video Capture:
> >>>           Width/Height      : 1024/720
> >>>           Pixel Format      : 'UYVY' (UYVY 4:2:2)
> >>>           Field             : None
> >>>           Bytes per Line    : 2048
> >>>           Size Image        : 1474560
> >>>           Colorspace        : Rec. 709
> >>>           Transfer Function : Rec. 709
> >>>           YCbCr/HSV Encoding: ITU-R 601
> >>>           Quantization      : Limited Range
> >>>           Flags             :
> >>> ^^^ Note 1080x720 has been reduced to 1024x720 - ouch!
> >> Yes as discussed above that is correct behavior, you'll need mem2mem
> >> device to support >1024 tiled scaling.
> >>
> >>> # capture 1 frame
> >>> v4l2-ctl --device /dev/video0 --stream-mmap --stream-to=x.raw --stream-count=1
> >>> ^^^ works
> >>> # stream JPEG/RTP/UDP
> >>> gst-launch-1.0 v4l2src device=/dev/video0 ! \
> >>>     video/x-raw,format=UYVY ! \
> >>>     jpegenc ! rtpjpegpay ! udpsink host=172.24.20.19 port=5000
> >>> ^^^ works (but of course squashed horizontally because of x=1024)
> >>> # stream H264/RTP/UDP (via coda)
> >>> # need to make sure we feed coda NV12/rec709
> >>> media-ctl --get-v4l2 '"ipu1_ic_prpenc":0' #
> >>> fmt:AYUV8_1X32/1280x720@1/25 field:none colorspace:rec709 xfer:709
> >>> ycbcr:601 quantization:lim-range
> >>> ^^^ input colorspace is rec709 but colorimetry needs to be changed to 709
> >>> media-ctl --set-v4l2 '"ipu1_ic_prpenc":0[fmt:AYUV32/1280x720
> >>> colorspace:rec709 ycbcr:709]'
> >>> ^^^ no error but doing a get-v4l2 shows no change - is this all
> >>> because of trying to deal with 1080 instead of 1024?
> >> No. The Image Converter can only Y`CbCr encode to ITU-R 601
> >> (V4L2_YCBCR_ENC_601). So the driver won't accept Rec. 709 Y`CbCr
> >> encoding when using an IC pipeline.
> >>
> >> See imx_media_fill_default_mbus_fields().
> >>
> >>> gst-launch-1.0 v4l2src device=/dev/video0 ! \
> >>>     v4l2h264enc output-io-mode=dmabuf-import ! \
> >>>     rtph264pay ! udpsink host=172.24.20.19 port=5001
> >>> v4l2src0: Device '/dev/video0' does not support 2:0:0:0 colorimetry
> >>> ^^^ fails because of colorimetry not getting set
> >> Right, that is correct behavior also. See above.
> >>
> >> Philipp, can the coda driver accept V4L2_YCBCR_ENC_601 colorspace?
> >>
> > I will have to go back and look what the old downstream Freescale
> > kernel drivers did here... I could swear I could easily de-interlace
> > via VDIC and encode 1080i with that and gstreamer-imx.

The old freescale kernel + gstreamer-imx does require using the IPU to
transform the colorspace before it goes to CODA but I'm still trying
to understand the gstreamer code. The pixel formats vs colorspace vs
colorimetry still confuse me.

So again, I'm struggling with how to get the output of the IC into coda.

> >
> >>> <snip>
> >>>
> >>> Let's try an interlaced format...
> >>>
> >>> Example: imx6q-gw54xx tda19971 480i60Hz YUV via BT656 IPU1_CSI0
> >>> MODE1:sensor->mux->csi->ic_prp->ic_prpenc
> >>> # set sensor output pad to sensor source format
> >>> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
> >>> # sensor format
> >>> media-ctl --get-v4l2 '"tda19971 2-0048":0' # fmt:UYVY8_2X8/720x480
> >>> field:seq-tb colorspace:rec709
> >>> # reset all links
> >>> media-ctl --reset
> >>> # setup links
> >>> media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
> >>> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
> >>> media-ctl -l "'ipu1_csi0':1 -> 'ipu1_vdic':0[1]"
> >>> media-ctl -l "'ipu1_vdic':2 -> 'ipu1_ic_prp':0[1]"
> >>> media-ctl -l "'ipu1_ic_prp':2 -> 'ipu1_ic_prpvf':0[1]"
> >>> media-ctl -l "'ipu1_ic_prpvf':1 -> 'ipu1_ic_prpvf capture':0[1]"
> >>> # configure pads
> >>> media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_2X8/720x480 field:seq-tb]"
> >>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_2X8/720x480 field:seq-tb]"
> >>> media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/720x480]"
> >>> media-ctl -V "'ipu1_vdic':2 [fmt:AYUV32/720x480]"
> >>> media-ctl -V "'ipu1_ic_prp':2 [fmt:AYUV32/720x480]"
> >>> media-ctl -V "'ipu1_ic_prpvf':1 [fmt:AYUV32/720x480]"
> >>> # capture device
> >>> media-ctl -e 'ipu1_ic_prpvf capture' # /dev/video1
> >>> v4l2-ctl --device /dev/video1 --get-fmt-video
> >>> Format Video Capture:
> >>>           Width/Height      : 720/480
> >>>           Pixel Format      : 'UYVY' (UYVY 4:2:2)
> >>>           Field             : None
> >>>           Bytes per Line    : 1440
> >>>           Size Image        : 691200
> >>>           Colorspace        : Rec. 709
> >>>           Transfer Function : Rec. 709
> >>>           YCbCr/HSV Encoding: ITU-R 601
> >>>           Quantization      : Limited Range
> >>>           Flags             :
> >>> # capture 1 frame
> >>> v4l2-ctl --device /dev/video1 --stream-mmap --stream-to=x.raw --stream-count=1
> >>> ^^^ fails with ipu1_ic_prpvf: EOF timeout
> >>> ^^^ this is almost identical to the adv7180 case which works... the
> >>> only exception I see is field:seq-tb vs field:alternate from the
> >>> source which should be fine (more specific than 'alternate')
> >> Hmm, can you send the complete pad formats from --get-v4l2. I don't see
> >> anything obviously wrong here.
> >>
> > root@imx6q-gw5404:~# media-ctl --get-v4l2 "'tda19971 2-0048':0"
> >                  [fmt:UYVY8_2X8/720x480 field:seq-tb colorspace:rec709]
> > root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0_mux':2"
> >                  [fmt:UYVY8_2X8/720x480 field:seq-tb colorspace:rec709]
> > root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0':1"
> >                  [fmt:AYUV8_1X32/720x480@1/30 field:seq-tb
> > colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
> > root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_vdic':2"
> >                  [fmt:AYUV8_1X32/720x480@1/60 field:none
> > colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
> > root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prp':2"
> >                  [fmt:AYUV8_1X32/720x480@1/30 field:none
> > colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
> > root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prpvf':1"
> >                  [fmt:AYUV8_1X32/720x480@1/30 field:none
> > colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
> >
> > root@imx6q-gw5404:~# v4l2-ctl --device /dev/video1 --get-fmt-video
> > Format Video Capture:
> >          Width/Height      : 720/480
> >          Pixel Format      : 'UYVY' (UYVY 4:2:2)
> >          Field             : None
> >          Bytes per Line    : 1440
> >          Size Image        : 691200
> >          Colorspace        : Rec. 709
> >          Transfer Function : Rec. 709
> >          YCbCr/HSV Encoding: ITU-R 601
> >          Quantization      : Limited Range
> >          Flags             :
> >
> > root@imx6q-gw5404:~# v4l2-ctl --device /dev/video1 --stream-mmap
> > --stream-to=x.raw --stream-count=1
> > [  159.828654] ipu1_ic_prpvf: EOF timeout
> > VIDIOC_DQBUF: failed: Input/output error
>
> Sorry everything looks fine, I don't know why that pipeline is failing
> to generate any data.
>

This one (480i60Hz YUV via BT656 sensor->mux->csi->ic_prp->ic_prpenc)
still baffles me a bit but I've also found that any bt656 capture that
isn't specifically 720x480 (NTSC) or 720x576 (PAL) fails because of
the resolution checks in ipu_csi_init_interface() resulting in
'Unsupported interlaced video mode'. I'm not sure if
ipu_csi_set_bt_interlaced_codes() can be modified to support other
resolutions?

> >
<snip>
> >
> >>> ok now I'm going to boot with a different device-tree that connects
> >>> the tda1997x to IMX6 via 16bit YUV. Advantages of this mode should be
> >>> 1) better pixel bpp 2) colorimetry is rec709 so no conversion needed
> >>> for coda 3) ability to capture 1080p60 as I have confirmed tyring to
> >>> do so via bt656 exceeds the IMX pixel clock rate and causes CSI
> >>> corruption. Downsides to this mode is that I currently have a bug in
> >>> the tda1997x driver regarding this mode and interlaced capture.
> >>>
> >>> Example: imx6q-gw54xx tda19971 480p60Hz YUV via 16bit YUV IPU1_CSI0
> >>> MODE0:sensor->mux->csi
> >>> # set sensor output pad to sensor source format
> >>> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
> >>> # sensor format
> >>> media-ctl --get-v4l2 '"tda19971 2-0048":0' # fmt:UYVY8_1X16/720x480
> >>> field:none colorspace:rec709
> >>> # reset all links
> >>> media-ctl --reset
> >>> # setup links
> >>> media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
> >>> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
> >>> media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
> >>> # configure pads
> >>> media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/720x480 field:none]"
> >>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/720x480 field:none]"
> >>> media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
> >>> media-ctl --get-v4l2 '"ipu1_csi0":2'
> >>>                   [fmt:UYVY8_1X16/720x480@1/30 field:none
> >> This is passthrough, the CSI can only pass through input pixel data
> >> unmodified as "generic" data, when the input bus is 16-bit parallel,
> >> which it is in this case (UYVY8_1X16). So the pixel code at the CSI
> >> output pad is forced to same as input pad (UYVY8_1X16).
> >>
> >> But aside from passthrough, that shouldn't be a problem...
> >>
> >>> colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range]
> >>> # capture device
> >>> media-ctl -e 'ipu1_csi0 capture' # /dev/video4
> >>> v4l2-ctl --device /dev/video4 --get-fmt-video
> >>> Format Video Capture:
> >>>           Width/Height      : 720/480
> >>>           Pixel Format      : 'UYVY' (UYVY 4:2:2)
> >>>           Field             : None
> >>>           Bytes per Line    : 1440
> >>>           Size Image        : 691200
> >>>           Colorspace        : Rec. 709
> >>>           Transfer Function : Rec. 709
> >>>           YCbCr/HSV Encoding: Rec. 709
> >>>           Quantization      : Limited Range
> >>>           Flags             : premultiplied-alpha
> >>> # capture 1 frame
> >>> v4l2-ctl --device /dev/video4 --stream-mmap --stream-to=x.raw --stream-count=1
> >>> convert -size 720x480 -depth 16 uyvy:x.raw /var/www/html/files/frame.png
> >> So capture of 1 frame worked fine?
> > yes this worked fine
> >
> >>> # stream JPEG/RTP/UDP
> >>> gst-launch-1.0 v4l2src device=/dev/video4 ! \
> >>>     video/x-raw,format=UYVY ! \
> >>>     jpegenc ! rtpjpegpay ! udpsink host=172.24.20.19 port=5000
> >> and this worked?
> > yes this worked fine
> >
> >>> # stream H264/RTP/UDP
> >>> media-ctl --get-v4l2 '"ipu1_csi0":0'
> >>>                   [fmt:UYVY8_1X16/720x480@1/30 field:none
> >>> colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range
> >>>                    crop.bounds:(0,0)/720x480
> >>>                    crop:(0,0)/720x480
> >>>                    compose.bounds:(0,0)/720x480
> >>>                    compose:(0,0)/720x480]
> >>> ^^^ no conv needed
> >>> media-ctl --get-v4l2 '"ipu1_csi0":0'
> >> huh?
> > typo'd here and cut-and-pasted another occurrence of the media-ctl
> > --get-v4l2 command but my point here is that we have the correct
> > colorspace/colorimetry for coda so the H264 below should work fine
> >
> >>> gst-launch-1.0 v4l2src device=/dev/video4 ! \
> >>>     v4l2h264enc output-io-mode=dmabuf-import ! \
> >>>     rtph264pay ! udpsink host=172.24.20.19 port=5001
> >>> v4l2src0: Internal data stream error.
> >> Sorry, I don't have enough info to help here.
> >>
> > Here's the pad details:
> >
> > root@imx6q-gw5404:~# media-ctl --get-v4l2 "'tda19971 2-0048':0"
> >                  [fmt:UYVY8_1X16/720x480 field:none colorspace:rec709]
> > root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0_mux':2"
> >                  [fmt:UYVY8_1X16/720x480 field:none colorspace:rec709]
> > root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0':2"
> >                  [fmt:UYVY8_1X16/720x480@1/30 field:none
> > colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range]
> >
> > root@imx6q-gw5404:~# v4l2-ctl --device /dev/video4 --get-fmt-video
> > Format Video Capture:
> >          Width/Height      : 720/480
> >          Pixel Format      : 'UYVY' (UYVY 4:2:2)
> >          Field             : None
> >          Bytes per Line    : 1440
> >          Size Image        : 691200
> >          Colorspace        : Rec. 709
> >          Transfer Function : Rec. 709
> >          YCbCr/HSV Encoding: Rec. 709
> >          Quantization      : Limited Range
> >          Flags             :
> >
> > So in this passthrough case v4l2-ctl stream capture works, gstreamer
> > capture with sw jpeg encode works, but gstreamer capture with h264
> > encode fails:
> >
> > root@imx6q-gw5404:~# gst-launch-1.0 v4l2src device=/dev/video4 ! \
> >>     v4l2h264enc output-io-mode=dmabuf-import ! \
> >>     rtph264pay ! udpsink host=172.24.20.19 port=5001
> > Setting pipeline to PAUSED ...
> > Pipeline is live and does not need PREROLL ...
> > Setting pipeline to PLAYING ...
> > ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> > Internal data stream error.
> > Additional debug info:
> > gstbasesrc.c(3055): gst_base_src_loop ():
> > /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> > streaming stopped, reason not-negotiated (-4)
> > Execution ended after 0:00:00.000416672
> > Setting pipeline to PAUSED ...
> > Setting pipeline to READY ...
> > Setting pipeline to NULL ...
> > Freeing pipeline ...
> >
> > It would appear that this must have something to do with gstreamer.
> > The only difference here between this case and the adv7180 is that
> > field=none and colorimetry is itu601... I'm guessing the field=none is
> > causing an issue. I'll post a question to gstreamer-devel.
>
> Ok. Given that v4l2-ctl stream capture works, gstreamer capture with sw
> jpeg encode works, but gstreamer capture with h264does not, this does
> sound like some issue with gstreamer.
>

While the 480p60Hz YUV via 16bit YUV sensor->mux->csi appears to work
from a V4L2 capture perspective I find that this input with the IC
causes 'pipeline start failed with -32' errors:

# imx6q-gw54xx tda19971 720p 16bit YUV IPU1_CSI0
MODE1:sensor->mux->csi->ic_prp->ic_prpenc
# set sensor output pad to sensor source format
v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
# sensor format
media-ctl --get-v4l2 '"tda19971 2-0048":0'
                [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
# get framerate
v4l2-ctl --device /dev/v4l-subdev15 --get-dv-timings
DV timings:
        Active width: 1280
        Active height: 720
        Total width: 1650
        Total height: 750
        Frame format: progressive
        Polarities: +vsync +hsync
        Pixelclock: 74250000 Hz (60.00 frames per second)
        Horizontal frontporch: 110
        Horizontal sync: 40
        Horizontal backporch: 220
        Vertical frontporch: 5
        Vertical sync: 5
        Vertical backporch: 20
        Standards: CTA-861
        CTA-861 VIC: 0
        Flags: framerate can be reduced by 1/1.001, CE-video, has CTA-861 VIC

# reset all links
media-ctl --reset
# setup links
media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
media-ctl -l "'ipu1_csi0':1 -> 'ipu1_ic_prp':0[1]"
media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
# configure pads
media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/1280x720 field:none]"
media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/1280x720 field:none]"
media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/640x360 ]"
media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x360 ]"
media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/640x360 ]"
media-ctl --get-v4l2 '"ipu1_ic_prpenc":1'
# capture device
media-ctl -e 'ipu1_ic_prpenc capture'
/dev/video0
v4l2-ctl --device /dev/video0 --get-fmt-video
Format Video Capture:
        Width/Height      : 640/360
        Pixel Format      : 'UYVY' (UYVY 4:2:2)
        Field             : None
        Bytes per Line    : 1280
        Size Image        : 460800
        Colorspace        : Rec. 709
        Transfer Function : Rec. 709
        YCbCr/HSV Encoding: ITU-R 601
        Quantization      : Limited Range
        Flags             :

# capture 1 frame
v4l2-ctl --device /dev/video0 --stream-mmap --stream-to=x.raw --stream-count=1
[  125.966980] ipu1_ic_prpenc: pipeline start failed with -32

Do you know what the failure is here?

And can you explain why I can't colorspace convert the following CSI
capture case?:

# imx6q-gw54xx tda19971 720p60 16-bit YUV sensor->mux->csi
# set sensor output pad to sensor source format
v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
# sensor format
media-ctl --get-v4l2 '"tda19971 2-0048":0'
                [fmt:UYVY8_1X16/1280x720 field:none colorspace:srgb]
# reset all links
media-ctl --reset
# setup links
media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
# configure pads
media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/1280x720 field:none]"
media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/1280x720 field:none]"
media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/1280x720 colorspace:rec709 ycbcr:709]"
media-ctl --get-v4l2 '"ipu1_csi0":2'
                [fmt:UYVY8_1X16/1280x720@1/30 field:none
colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range]
^^^ still itu601

I have found in my testing when dealing with a BT656 RGB colorspace
input which I need to convert ot rec709 I have to set the 'input' pad
of the csi which doesn't make sense and if I do this with a 16-bit RGB
colorspace (above) it jacks up the fmt:
media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/1280x720 colorspace:rec709 ycbcr:709]"
media-ctl --get-v4l2 '"ipu1_csi0":2'
                [fmt:UYVY8_2X8/1280x720@1/30 field:none
colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range]
^^^ changed fmt because AYUV32 at CSI input is invalid so it defaults
fmt to YUVY8_2X8

So there is something I'm still doing wrong to setup CSC.

Thanks,

Tim
