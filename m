Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D87C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 16:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0FE5218AD
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 16:31:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="SqBiJuIP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730797AbfBFQbV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 11:31:21 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:43168 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbfBFQbU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 11:31:20 -0500
Received: by mail-wr1-f51.google.com with SMTP id r2so8233664wrv.10
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 08:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Ijh5K/fE0f2jcU9xv3aIXOKfPOpR2ukqblAcLJ2xiA=;
        b=SqBiJuIPGRsk367JiZAaw73OyCsrkN80OBKBH51mpEP+WHZjPRg03qcegqtZ2Zs7JV
         6Svj5lGR3c7JcIrjpJ9pRERc5r7QTLZXb0/qHU7pVCW0MuO0l5TRiXFPrktuz10VQkW+
         RTwFmSa3Tml59V4S3KTkVH6/eEnd24th+b1Bt68Rh9N38GEAW4Yzdq+Rc5wWNhij7rvz
         acPMYsbIKBo50BIJLpbbM9UFmpqoe/4KHHocrkMgqDFCvksYKo4FZjImFb/vHQoao4C+
         HyHSbF0V7Ehifyz71Y0ywoSRQbAYFrxaJ5p1KD1GyGEboL/eLaqedzZMFabrS1BVqoZ9
         1HUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Ijh5K/fE0f2jcU9xv3aIXOKfPOpR2ukqblAcLJ2xiA=;
        b=R4dVTRhRXicntkSED0JqAKsk5urEbxzQE4V5BaLLrrC6rxgACLaeJYKncQ8Md5Pr4u
         ZkrMVCO1OACxG3dKJ3loFHaPeNbJ/e7Q+zsDdbl8+F4wjDNj8t579qnaX+GaqL6Y00ho
         j1SGVvPTjgTU21iRhdfF+LL8VukoiqOog8Jh4Cbh2jxkdjJP7IbgQ7kocY5hlySE4/6e
         gQ654uxX9OToldRgmcgskMXKnHnZnuzCfug1xQKZ+R5LsMsCt7l4Wn5cF9cMLIevqlc2
         uUHP35I4sPvgOo8vZ/nWX8O1Qvwht6gFXDhxU/4TcgMrV9Pgttn3VbgldJTYXMapLkr7
         4YNQ==
X-Gm-Message-State: AHQUAuZB+sikJvDVD9Mtw9Oq+j3p/eZLKvBX2RD34a8gtv7jp/Js+z+J
        TAmQdDKwpk/v9F31xC8HjlYXStE7dKJJUAedEGzFABrmek0=
X-Google-Smtp-Source: AHgI3Ia2nAmKz5D456P/amzWc0FC8bgyZZ/LkeUOd3QswsMjP8gIebkdzNIwVw+ak2+LsWo2wMIUjJeDPKVydcc/z0A=
X-Received: by 2002:a5d:4e08:: with SMTP id p8mr9015904wrt.235.1549470677180;
 Wed, 06 Feb 2019 08:31:17 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+vNU0ic=wzSC9V4hbmarN0JeQMs121MzD6tH5KQ+ezENUNfA@mail.gmail.com>
 <02e8680c-9fd5-ff54-f292-f6936c76583e@gmail.com> <CAJ+vNU0YQeiPaE8tapJnihoj3DtewCPTj05BZv5cJ65YkE9MeQ@mail.gmail.com>
 <db70e0f7-0ad4-62f5-e64c-49c04c089dd6@gmail.com> <CAJ+vNU3X6ywgobcV+wQxEupkNeNmiWaT85xUOtKF_U44OAfskg@mail.gmail.com>
 <7cfe3570-64e5-d5e3-aeaf-35253c0fa918@gmail.com> <CAJ+vNU2VebBg83vsiGmsx+0PuD=qr4w3fc9a7-bvgji=iyPDyQ@mail.gmail.com>
 <b97bf10a-f4dc-840b-9ffe-b311fdeee374@gmail.com>
In-Reply-To: <b97bf10a-f4dc-840b-9ffe-b311fdeee374@gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Wed, 6 Feb 2019 08:31:05 -0800
Message-ID: <CAJ+vNU0_-Ti1bAfEo=3kg79hYFSE4ZFx9C4HswqUWXB463yXXA@mail.gmail.com>
Subject: Re: IMX CSI capture issues with tda1997x HDMI receiver
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Feb 5, 2019 at 3:54 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
>
>
> On 2/5/19 11:16 AM, Tim Harvey wrote:
> > On Sat, Feb 2, 2019 at 11:10 AM Steve Longerbeam<slongerbeam@gmail.com>  wrote:
> >
> > <snip>
> >> The *real* way to fix this would be to allow programmable encodings in
> >> ipu-ic.c. But unfortunately the encodings are hardcoded (grep for
> >> ic_csc_rgb2ycbcr in ipu-ic.c).
> >>
> > Ok, I saw that you went ahead and worked on this (thanks!) and that
> > you have a bt.709.v2 branch... is that one ready for testing?
>
> Yes. I tried to test it too, but there is some regression in captured
> images, it could be something in ov5640.c (I'm testing with the SabreSD
> and the OV5640), or something else recently added. The regression looks
> like a stride problem, I'm hoping it wasn't the recently introduced
> compose window changes to relax width alignment. Have you tested with
> those commits and a prpenc/vf pipeline?

I have been testing v4.20 with:
media: imx: lift CSI and PRP ENC/VF width alignment restriction
media: imx: set compose rectangle to mbus format
media: imx: add capture compose rectangle
imx: imx-media: register mem2mem device with media controller
media: imx: add mem2mem device
media: imx-csi: Skip first few frames from a BT.656 source
media: imx.rst: Update doc to reflect fixes to interlaced capture
media: imx: Allow interweave with top/bottom lines swapped
media: imx-csi: Move crop/compose reset after filling default mbus fields
media: imx: vdic: rely on VDIC for correct field order
media: imx-csi: Allow skipping odd chroma rows for YVU420
media: imx: interweave and odd-chroma-row skip are incompatible
media: imx-csi: Double crop height for alternate fields at sink
media: imx: Fix field negotiation
gpu: ipu-v3: Add planar support to interlaced scan
gpu: ipu-csi: Swap fields according to input/output field types
media: videodev2.h: Add more field helper macros
media: imx: prpencvf: Stop upstream before disabling IDMA channel
media: imx: csi: Stop upstream before disabling IDMA channel
media: imx: csi: Disable CSI immediately after last EOF
media: imx-csi: Input connections to CSI should be optional

What kind of artifacts are you seeing?

I noticed your 'media: imx: Add support for BT.709 encoding' series
don't apply cleanly to 4.20 that I'm working with so perhaps its
something else. I'll bump up to linux-media, apply your bt.709.v2 and
see what I get. The BT.709 support is critical for me otherwise I
can't use coda with any pipelines that go through the IC with the
tda1997x HDMI decoder.

>
> >> <snip>
> >>> Also can we connect the mem2mem driver to the unused VDIC input in the
> >>> media controller so that we can use the VDIC to de-interlace content
> >>> captured from non IMX sources (ie PCI or USB capture devices)?
> >> Exactly! That's something I have been working on. But it's difficult to
> >> connect mem2mem to the unused VDIC IDMAC input pad because as of now the
> >> v4l2 mem2mem internal API's do not allow connecting to *existing*
> >> processing entities, and there are also issues with how sub-devices are
> >> to deal with mem2mem contexts.
> >>
> >> I do have a WIP branch that creates a video output device that connects
> >> to the VDIC IDMAC input pad, which doesn't have the above issues. The
> >> only drawback with that is how gstreamer can make use of such an output
> >> device.
> >>
> > ok, keep me posted. Is it the output-vdic or mem2mem.v4-mc branch?
>
> The output-vdic branch. It's almost ready to go, there is only some
> strange issue with low and medium motion-compensation modes (captured
> images show "snow").
>
>
> > I also noticed you have a add-fim-to-prpencvf branch... are you
> > working on adding FIM to ipu_ic_prp/enc still? That would be nice to
> > have to deal with sync loss/regain in analog decoders going through
> > VDIC de-interlacing.
>
> I've been trying to get this working, I ran into some locking issues
> when enabling lock debug options. Still trying to find a solution.
>
> > <snip>
> >>> This one (480i60Hz YUV via BT656 sensor->mux->csi->ic_prp->ic_prpenc)
> >>> still baffles me a bit but I've also found that any bt656 capture that
> >>> isn't specifically 720x480 (NTSC) or 720x576 (PAL) fails because of
> >>> the resolution checks in ipu_csi_init_interface() resulting in
> >>> 'Unsupported interlaced video mode'. I'm not sure if
> >>> ipu_csi_set_bt_interlaced_codes() can be modified to support other
> >>> resolutions?
> >> Well, Bt.656 only defines standard definition NTSC and PAL.
> >>
> > That is true. Do you know of any other sensors that use higher
> > resolutions with BT656 SAV/EAV encoding?
>
> Nope all I have for testing is the NTSC/PAL ADV7180 on the SabreAuto.
>
> >   The BT656 mode does work well
> > for the progressive modes up to 1080p30 (1080p60 exceeds the IMX6
> > pixel clock and can't be used).
> >
> > I could dig into the bt656 spec to try and understand the various
> > codes that get stuffed into the IPUx_CSI0_CCIR_CODE_1/2/3 registers I
> > suppose but I'm still not sure I want to push up a device-tree config
> > that describes the tda1997x to CSI connection as 8bit BT656 as I would
> > prefer to describe it as 16bit YUV instead (as I may be close to
> > getting that format working well if we can get the IC able to output
> > rec709).
> >
> > <snip>
> >
> >>> # imx6q-gw54xx tda19971 720p 16bit YUV IPU1_CSI0
> >>> MODE1:sensor->mux->csi->ic_prp->ic_prpenc
> >>> # set sensor output pad to sensor source format
> >>> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
> >>> # sensor format
> >>> media-ctl --get-v4l2 '"tda19971 2-0048":0'
> >>>                   [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
> >>> # get framerate
> >>> v4l2-ctl --device /dev/v4l-subdev15 --get-dv-timings
> >>> DV timings:
> >>>           Active width: 1280
> >>>           Active height: 720
> >>>           Total width: 1650
> >>>           Total height: 750
> >>>           Frame format: progressive
> >>>           Polarities: +vsync +hsync
> >>>           Pixelclock: 74250000 Hz (60.00 frames per second)
> >>>           Horizontal frontporch: 110
> >>>           Horizontal sync: 40
> >>>           Horizontal backporch: 220
> >>>           Vertical frontporch: 5
> >>>           Vertical sync: 5
> >>>           Vertical backporch: 20
> >>>           Standards: CTA-861
> >>>           CTA-861 VIC: 0
> >>>           Flags: framerate can be reduced by 1/1.001, CE-video, has CTA-861 VIC
> >>>
> >>> # reset all links
> >>> media-ctl --reset
> >>> # setup links
> >>> media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
> >>> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
> >>> media-ctl -l "'ipu1_csi0':1 -> 'ipu1_ic_prp':0[1]"
> >>> media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
> >>> media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
> >>> # configure pads
> >>> media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/1280x720 field:none]"
> >>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/1280x720 field:none]"
> >>> media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/640x360 ]"
> >>> media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x360 ]"
> >>> media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/640x360 ]"
> >>> media-ctl --get-v4l2 '"ipu1_ic_prpenc":1'
> >>> # capture device
> >>> media-ctl -e 'ipu1_ic_prpenc capture'
> >>> /dev/video0
> >>> v4l2-ctl --device /dev/video0 --get-fmt-video
> >>> Format Video Capture:
> >>>           Width/Height      : 640/360
> >>>           Pixel Format      : 'UYVY' (UYVY 4:2:2)
> >>>           Field             : None
> >>>           Bytes per Line    : 1280
> >>>           Size Image        : 460800
> >>>           Colorspace        : Rec. 709
> >>>           Transfer Function : Rec. 709
> >>>           YCbCr/HSV Encoding: ITU-R 601
> >>>           Quantization      : Limited Range
> >>>           Flags             :
> >>>
> >>> # capture 1 frame
> >>> v4l2-ctl --device /dev/video0 --stream-mmap --stream-to=x.raw --stream-count=1
> >>> [  125.966980] ipu1_ic_prpenc: pipeline start failed with -32
> >>>
> >>> Do you know what the failure is here?
> >> You are /2 downscaling in the CSI, but did not set the compose window at
> >> the input pad, e.g:
> >>
> >> media-ctl --set-v4l2 '"ipu1_csi0":0[compose:(0,0)/640x360]' # 1/2 scale
> >>
> > I don't think this is the issue. Note that I 'was' able to get the
> > same pipeline with the div-by-2 downscale without compose working with
> > 720p bt656 YUV.
> >
> > Here is the 720p 16bit YUV bus again with the compose:
> > # 720p60Hz YUV 16bit YUV bus
> > # imx6q-gw54xx tda19971 2-0048 IPU1_CSI0
> > MODE1:sensor->mux->csi->ic_prp->ic_prpenc
> > v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
> > BT timings set
> > # sensor format
> > media-ctl --get-v4l2 '"tda19971 2-0048":0'
> >                  [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
> > # reset all links
> > media-ctl --reset
> > # setup links
> > media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
> > media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
> > media-ctl -l "'ipu1_csi0':1 -> 'ipu1_ic_prp':0[1]"
> > media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
> > media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
> > # configure pads
> > media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/1280x720 field:none]"
> > media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/1280x720 field:none]"
> > media-ctl -V "'ipu1_csi0':0 [fmt:UYVY8_1X16/1280x720 field:none]"
> > media-ctl -V "'ipu1_csi0':0 [compose:(0,0)/640x360]"
> > media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x360 ]"
> > media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/640x360 ]"
> > media-ctl --get-v4l2 "'ipu1_csi0':0"
> >                  [fmt:UYVY8_1X16/1280x720@1/30 field:none
> > colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range
> >                   crop.bounds:(0,0)/1280x720
> >                   crop:(0,0)/1280x720
> >                   compose.bounds:(0,0)/1280x720
> >                   compose:(0,0)/640x360]
> > media-ctl --get-v4l2 "'ipu1_csi0':1"
> >                  [fmt:UYVY8_1X16/640x360@1/30 field:none
> > colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
> > media-ctl --get-v4l2 "'ipu1_ic_prp':1"
> >                  [fmt:AYUV8_1X32/640x480@1/30 field:none
>
> Ah, ipu1_ic_prp:1 pad is 640x480, it looks like you missed setting
> ipu1_csi0:1 pad format, so that ipu1_ic_prp pads are still set to
> default formats.

but I do set it above: media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x360 ]

here's a sequence of set/get:
root@imx6q-gw5404:~# media-ctl --set-v4l2 "'tda19971 2-0048':0
[fmt:UYVY8_1X16/1280x720 field:none]"
root@imx6q-gw5404:~# media-ctl --get-v4l2 "'tda19971 2-0048':0"
                [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_csi0_mux':2
[fmt:UYVY8_1X16/1280x720 field:none]"
root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0_mux':2"
                [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_csi0':0 [fmt:AYUV32/640x360]"
root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0':0"
                [fmt:UYVY8_2X8/640x360@1/30 field:none
colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range
                 crop.bounds:(0,0)/640x360
                 crop:(0,0)/640x360
                 compose.bounds:(0,0)/640x360
                 compose:(0,0)/640x360]
^^^ the compose setting defaults so I really don't think the next cmd
does anything
root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_csi0':0
[compose:(0,0)/640x360]"
root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0':0"
                [fmt:UYVY8_2X8/640x360@1/30 field:none
colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range
                 crop.bounds:(0,0)/640x360
                 crop:(0,0)/640x360
                 compose.bounds:(0,0)/640x360
                 compose:(0,0)/640x360]
^^^ see, same as above (but I like adding the compose to pipeline
configuration instructions for documentation purposes; makes it
obvious they can select the window)
root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_ic_prp':1 [fmt:AYUV32/640x360]"
root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prp':1"
                [fmt:AYUV8_1X32/1280x720@1/30 field:none
colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
^^^ but yes, this one isn't getting set properly to 640x360... and it
looks like its at the input:
root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prp':0"
                [fmt:AYUV8_1X32/1280x720@1/30 field:none
colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]

my understanding is if I set it on the output pad it will propagate
back to the input pad. I'm also wondering why I don't get an error if
it doesn't change.

If I setup the input pad manually and continue on:
root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_ic_prp':0 [fmt:AYUV32/640x360]"
root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prp':0"
                [fmt:AYUV8_1X32/640x360@1/30 field:none
colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prp':1"
                [fmt:AYUV8_1X32/640x360@1/30 field:none
colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_ic_prpenc':1
[fmt:AYUV32/640x360]"
root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prpenc':1"
                [fmt:AYUV8_1X32/640x360@1001/30000 field:none
colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
root@imx6q-gw5404:~# v4l2-ctl --device /dev/video0 --stream-mmap
--stream-to=x.raw --stream-count=1
[ 4695.356802] ipu1_ic_prpenc: pipeline start failed with -32
^^^ still fails

If I can get pipelines that go through the IC working with UYVY8_1X16
then I will use that for the bus format and ditch the UYVY8_2X16 bt656
which has the limitations of not supporting 1080p60 (not to mention
the fact that anything other than SD resolutions are out of the bt656
as discussed), interlaced formats.

>
<snip>
>
> >>
> > What I was asking here is what is the correct way to configure for
> > ITU601 to REC709 CSC at the CSI?  I would expect to set the REC709
> > format on the output pad of the CSI but it seems to require me to set
> > it on the input pad.
>
> Right, the driver only allows setting colorimetry at the sink pads, and
> propagates them to the source pads. So you'll need to set colorimetry
> params at the CSI sink pad.

oh gosh... I think I had that backwards!

>
> > Consider:
> > # imx6q-gw54xx tda19971 720p60 16-bit RGB sensor->mux->csi
> > # set sensor output pad to sensor source format
> > v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
> > # sensor format
> > media-ctl --get-v4l2 '"tda19971 2-0048":0'
> >                   [fmt:UYVY8_1X16/1280x720 field:none colorspace:srgb]
> > # reset all links
> > media-ctl --reset
> > # setup links
> > media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
> > media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
> > media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
> > # configure pads
> > media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/1280x720 field:none]"
> > media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/1280x720 field:none]"
> > media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/1280x720]"
> > media-ctl --get-v4l2 '"ipu1_csi0":2'
> >                  [fmt:UYVY8_1X16/1280x720@1/30 field:none
> > colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range]
> > ^^^ ITU601, but I want REC709
> > media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/1280x720 colorspace:rec709 ycbcr:709]"
> > media-ctl --get-v4l2 '"ipu1_csi0":2'
> >                 [fmt:UYVY8_1X16/1280x720@1/30 field:none

So the above was wrong as I was trying to set it on the CSI 'output'
pad not its 'input'. Is there no error reporting all the way back to
let the user know this was an invalid choice?

> > colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range]
> > ^^^ No invalid argument but its still ITU601 at CSI output... but what
> > I've found is if I set it at the CSI input the ycbcr changes but the
> > fmt gets jacked up (as expected)
> > media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/1280x720 colorspace:rec709 ycbcr:709]"
> >                  [fmt:UYVY8_2X8/1280x720@1/30 field:none
> > colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range]
> > ^^^ note we are now rec709 but fmt is UYVY8_2X8 because the CSI
> > doesn't accept UYVY8_1X16 so it deafults to UYVY8_2X8.
>
> Why doesn't the CSI accept UYVY8_1X16 at its sink pad?
>
> This doesn't work?:
>
> media-ctl -V "'ipu1_csi0':0 [fmt:UYVY8_1X16/1280x720 colorspace:rec709 ycbcr:709]"
>

that works!

I was trying to set AYUV32 at its input pad which it doesn't support.

Again, do you know why errors don't propagate back to media-ctl? Most
of my difficulties have been not realizing what was valid and
understanding that I have to read back the format after I set it to
determine failures.

Tim
