Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88779C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 19:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42DF3217F9
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 19:17:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="tU5nocXZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfBETRE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 14:17:04 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:40108 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727847AbfBETRE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 14:17:04 -0500
Received: by mail-wr1-f41.google.com with SMTP id p4so4914997wrt.7
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2019 11:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ozXQ/RpcljUkFz/2H6DouAzJ42vKtpdtnq2jABOCVNs=;
        b=tU5nocXZoJjYtAjb6sdd8ePsAQRQNiGOcfCgL/1KH+RU/VYjusETZTP7lHZtbFnApm
         Uu53aWFX5wyrtNclU8dFBtT3sNJVqbSUy1jvwgXBhXdh7wD8nZ0nafAK/t09Rk0wH0ZX
         1f3GNIN3ViofHObbqBysigALZHsbLBxoxd7hAxBXQ23j41SMChvEkpv8HX05YdJAjehL
         GUn63RGITfzGfJP6DBf9eASf/5b3tkw+SW+1AiLQhuKJ8KBTnlmFBxkpMmaXrhbOeJqt
         YFDYudDz4PszOtaCZCqTJjXF34NHIxq6Hq1SWDr63RY4QrM7ZzEYuZzfZKz6P3hknLlU
         Qdxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ozXQ/RpcljUkFz/2H6DouAzJ42vKtpdtnq2jABOCVNs=;
        b=MDQvQVquq9mOi9fLCBSteXMNVFpKi8C6Sa/wDyTkqnNSpb9c9aQH5g6dIprapeEYY5
         OWyf+PjfHLgpKJu90zBJRRruyOOzirTrBTLcEJeAl0QvDmC3cMCSodRqlyoIAxpS5K5c
         HjCtS1NHngindj5WhTSUt1TtDwGrXfaPYmpPLDmzRpowM0muJQ2oFnkr4RNPFkMRnJwq
         3gyErP/EL7B+TvkV57Ol8wmgG1LhuZ3YduFc0xud5oQL2esnQOkkbW3TLKNiwxNFfST9
         AdYGiZ5w3+iJAHgFcB/OqRBC+GtOc7S69eDqwO7H+Jilzuq31ehmnsem59lle56cxtB6
         KjgQ==
X-Gm-Message-State: AHQUAuaLBVyW5cRXpP+24taZoMoXb8fY+el7QILCez0ansG+Kv+qK42v
        +MVFY7F3hAudN2oTBr1tFp+P6O3jAu5jyYwvPT/GCw==
X-Google-Smtp-Source: AHgI3IZmu6scek1mraMPflhFOxjRro8qHX2VWcDi6VdvG/5pttWLavFamZJ/6tqShGMlHJnrfydFhB1G0pyoqBkEk5k=
X-Received: by 2002:a5d:4e08:: with SMTP id p8mr5074874wrt.235.1549394220554;
 Tue, 05 Feb 2019 11:17:00 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+vNU0ic=wzSC9V4hbmarN0JeQMs121MzD6tH5KQ+ezENUNfA@mail.gmail.com>
 <02e8680c-9fd5-ff54-f292-f6936c76583e@gmail.com> <CAJ+vNU0YQeiPaE8tapJnihoj3DtewCPTj05BZv5cJ65YkE9MeQ@mail.gmail.com>
 <db70e0f7-0ad4-62f5-e64c-49c04c089dd6@gmail.com> <CAJ+vNU3X6ywgobcV+wQxEupkNeNmiWaT85xUOtKF_U44OAfskg@mail.gmail.com>
 <7cfe3570-64e5-d5e3-aeaf-35253c0fa918@gmail.com>
In-Reply-To: <7cfe3570-64e5-d5e3-aeaf-35253c0fa918@gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Tue, 5 Feb 2019 11:16:48 -0800
Message-ID: <CAJ+vNU2VebBg83vsiGmsx+0PuD=qr4w3fc9a7-bvgji=iyPDyQ@mail.gmail.com>
Subject: Re: IMX CSI capture issues with tda1997x HDMI receiver
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Feb 2, 2019 at 11:10 AM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
>
<snip>
>
> >
> > But when going through the IC we again run into the issue where the
> > output of the IC isn't a suitable colorspace:
> > # 720p@60Hz YUV BT656
> > # set sensor output pad to sensor source format
> > v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
> > # sensor format
> > media-ctl --get-v4l2 '"tda19971 2-0048":0' # fmt:UYVY8_2X8/1280x720
> > field:none colorspace:srgb
> > # reset all links
> > media-ctl --reset
> > # setup links
> > media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
> > media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
> > media-ctl -l "'ipu1_csi0':1 -> 'ipu1_ic_prp':0[1]"
> > media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
> > media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
> > # configure pads
> > media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_2X8/1280x720 field:none]"
> > media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_2X8/1280x720 field:none]"
> > media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/640x360 ]"
> > # downscale because the IC can't do >1024
> > media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x360 ]"
> > media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/640x360 ]"
> > media-ctl --get-v4l2 '"ipu1_ic_prpenc":1' #
> > [fmt:AYUV8_1X32/640x360@1/25 field:none colorspace:srgb xfer:srgb
> > ycbcr:601 quantization:lim-range]
> > # ^^^ note we are itu601 again b/c that's the only format the IC can ouput
> > # stream JPEG/RTP/UDP
> > gst-launch-1.0 v4l2src device=/dev/video0 ! \
> >    video/x-raw,format=UYVY ! \
> >    jpegenc ! rtpjpegpay ! udpsink host=172.24.20.19 port=5000
> > # ^^^ works... SW JPEG can handle itu601
>
> Ok.
>
> > # stream upscale via mem2mem then JPEG/RTP/UDP
> > gst-launch-1.0 v4l2src device=/dev/video4 ! \
> >    v4l2video8convert ! video/x-raw,width=1280,height=720 ! \
> >    jpegenc ! rtpjpegpay ! udpsink host=172.24.20.19 port=5000
> > ERROR: from element
> > /GstPipeline:pipeline0/v4l2video8convert:v4l2video8convert0: Device
> > '/dev/video8' does not support 2:4:7:1 colorimetry
> > # ^^^ fails because mem2mem doesn't support itu601
> > # stream H264/RTP/UDP
> > gst-launch-1.0 v4l2src device=/dev/video4 ! \
> >    v4l2h264enc output-io-mode=dmabuf-import ! \
> >    rtph264pay ! udpsink host=172.24.20.19 port=5001
> > ERROR: from element /GstPipeline:pipeline0/v4l2h264enc:v4l2h264enc0:
> > Device '/dev/video9' does not support 2:4:7:1 colorimetry
> > # ^^^ coda has same issue... can't del with itu601
>
> Well, just to see things working, try hacking
> imx_media_fill_default_mbus_fields() to set Rec. 709 encoding:
>
> --- a/drivers/staging/media/imx/imx-media-utils.c
> +++ b/drivers/staging/media/imx/imx-media-utils.c
> @@ -571,7 +571,7 @@ void imx_media_fill_default_mbus_fields(struct
> v4l2_mbus_framefmt *tryfmt,
>                  tryfmt->quantization = is_rgb ?
>                          V4L2_QUANTIZATION_FULL_RANGE :
>                          V4L2_QUANTIZATION_LIM_RANGE;
> -               tryfmt->ycbcr_enc = V4L2_YCBCR_ENC_601;
> +               tryfmt->ycbcr_enc = V4L2_YCBCR_ENC_709;
>          }
>   }
>   EXPORT_SYMBOL_GPL(imx_media_fill_default_mbus_fields);
>
>
> But of course that's not technically correct because the encoding in
> ipu-ic.c is BT.601.
>
> The *real* way to fix this would be to allow programmable encodings in
> ipu-ic.c. But unfortunately the encodings are hardcoded (grep for
> ic_csc_rgb2ycbcr in ipu-ic.c).
>

Ok, I saw that you went ahead and worked on this (thanks!) and that
you have a bt.709.v2 branch... is that one ready for testing?

> The other option would be to change ic_csc_rgb2ycbcr to use the Rec. 709
> coefficients, and then the above patch is no longer a hack. The inverse
> encoding (ic_csc_ycbcr2rgb) would also need to be changed.
>
>
> >
> > Am I perhaps missing a capsfilter to get the mem2mem driver to convert
> > the colorspace properly? If so, they the mem2mem driver could be used
> > to correct the colorspace to get IC output to coda working.
>
> Well, first I don't think the mem2mem driver is using the correct
> encoding. The mem2mem driver is making use of the IC encoding so it
> should be reporting and accepting only BT.601.
>
> Philipp ^^
>
>
> >
> > Also can we connect the mem2mem driver to the unused VDIC input in the
> > media controller so that we can use the VDIC to de-interlace content
> > captured from non IMX sources (ie PCI or USB capture devices)?
>
> Exactly! That's something I have been working on. But it's difficult to
> connect mem2mem to the unused VDIC IDMAC input pad because as of now the
> v4l2 mem2mem internal API's do not allow connecting to *existing*
> processing entities, and there are also issues with how sub-devices are
> to deal with mem2mem contexts.
>
> I do have a WIP branch that creates a video output device that connects
> to the VDIC IDMAC input pad, which doesn't have the above issues. The
> only drawback with that is how gstreamer can make use of such an output
> device.
>

ok, keep me posted. Is it the output-vdic or mem2mem.v4-mc branch?

I also noticed you have a add-fim-to-prpencvf branch... are you
working on adding FIM to ipu_ic_prp/enc still? That would be nice to
have to deal with sync loss/regain in analog decoders going through
VDIC de-interlacing.

>
<snip>
> >>
> > This one (480i60Hz YUV via BT656 sensor->mux->csi->ic_prp->ic_prpenc)
> > still baffles me a bit but I've also found that any bt656 capture that
> > isn't specifically 720x480 (NTSC) or 720x576 (PAL) fails because of
> > the resolution checks in ipu_csi_init_interface() resulting in
> > 'Unsupported interlaced video mode'. I'm not sure if
> > ipu_csi_set_bt_interlaced_codes() can be modified to support other
> > resolutions?
>
> Well, Bt.656 only defines standard definition NTSC and PAL.
>

That is true. Do you know of any other sensors that use higher
resolutions with BT656 SAV/EAV encoding? The BT656 mode does work well
for the progressive modes up to 1080p30 (1080p60 exceeds the IMX6
pixel clock and can't be used).

I could dig into the bt656 spec to try and understand the various
codes that get stuffed into the IPUx_CSI0_CCIR_CODE_1/2/3 registers I
suppose but I'm still not sure I want to push up a device-tree config
that describes the tda1997x to CSI connection as 8bit BT656 as I would
prefer to describe it as 16bit YUV instead (as I may be close to
getting that format working well if we can get the IC able to output
rec709).

<snip>

> >
> > # imx6q-gw54xx tda19971 720p 16bit YUV IPU1_CSI0
> > MODE1:sensor->mux->csi->ic_prp->ic_prpenc
> > # set sensor output pad to sensor source format
> > v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
> > # sensor format
> > media-ctl --get-v4l2 '"tda19971 2-0048":0'
> >                  [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
> > # get framerate
> > v4l2-ctl --device /dev/v4l-subdev15 --get-dv-timings
> > DV timings:
> >          Active width: 1280
> >          Active height: 720
> >          Total width: 1650
> >          Total height: 750
> >          Frame format: progressive
> >          Polarities: +vsync +hsync
> >          Pixelclock: 74250000 Hz (60.00 frames per second)
> >          Horizontal frontporch: 110
> >          Horizontal sync: 40
> >          Horizontal backporch: 220
> >          Vertical frontporch: 5
> >          Vertical sync: 5
> >          Vertical backporch: 20
> >          Standards: CTA-861
> >          CTA-861 VIC: 0
> >          Flags: framerate can be reduced by 1/1.001, CE-video, has CTA-861 VIC
> >
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
> > media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/640x360 ]"
> > media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x360 ]"
> > media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/640x360 ]"
> > media-ctl --get-v4l2 '"ipu1_ic_prpenc":1'
> > # capture device
> > media-ctl -e 'ipu1_ic_prpenc capture'
> > /dev/video0
> > v4l2-ctl --device /dev/video0 --get-fmt-video
> > Format Video Capture:
> >          Width/Height      : 640/360
> >          Pixel Format      : 'UYVY' (UYVY 4:2:2)
> >          Field             : None
> >          Bytes per Line    : 1280
> >          Size Image        : 460800
> >          Colorspace        : Rec. 709
> >          Transfer Function : Rec. 709
> >          YCbCr/HSV Encoding: ITU-R 601
> >          Quantization      : Limited Range
> >          Flags             :
> >
> > # capture 1 frame
> > v4l2-ctl --device /dev/video0 --stream-mmap --stream-to=x.raw --stream-count=1
> > [  125.966980] ipu1_ic_prpenc: pipeline start failed with -32
> >
> > Do you know what the failure is here?
>
> You are /2 downscaling in the CSI, but did not set the compose window at
> the input pad, e.g:
>
> media-ctl --set-v4l2 '"ipu1_csi0":0[compose:(0,0)/640x360]' # 1/2 scale
>

I don't think this is the issue. Note that I 'was' able to get the
same pipeline with the div-by-2 downscale without compose working with
720p bt656 YUV.

Here is the 720p 16bit YUV bus again with the compose:
# 720p60Hz YUV 16bit YUV bus
# imx6q-gw54xx tda19971 2-0048 IPU1_CSI0
MODE1:sensor->mux->csi->ic_prp->ic_prpenc
v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
BT timings set
# sensor format
media-ctl --get-v4l2 '"tda19971 2-0048":0'
                [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
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
media-ctl -V "'ipu1_csi0':0 [fmt:UYVY8_1X16/1280x720 field:none]"
media-ctl -V "'ipu1_csi0':0 [compose:(0,0)/640x360]"
media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x360 ]"
media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/640x360 ]"
media-ctl --get-v4l2 "'ipu1_csi0':0"
                [fmt:UYVY8_1X16/1280x720@1/30 field:none
colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range
                 crop.bounds:(0,0)/1280x720
                 crop:(0,0)/1280x720
                 compose.bounds:(0,0)/1280x720
                 compose:(0,0)/640x360]
media-ctl --get-v4l2 "'ipu1_csi0':1"
                [fmt:UYVY8_1X16/640x360@1/30 field:none
colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
media-ctl --get-v4l2 "'ipu1_ic_prp':1"
                [fmt:AYUV8_1X32/640x480@1/30 field:none
colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
media-ctl --get-v4l2 "'ipu1_ic_prpenc':1"
                [fmt:AYUV8_1X32/640x360@1001/30000 field:none
colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
media-ctl -e 'ipu1_ic_prpenc capture'
/dev/video0
v4l2-ctl --device /dev/video0 --get-fmt-video
Format Video Capture:
        Width/Height      : 640/360
        Pixel Format      : 'UYVY' (UYVY 4:2:2)
        Field             : None
        Bytes per Line    : 1280
        Size Image        : 460800
        Colorspace        : SMPTE 170M
        Transfer Function : Rec. 709
        YCbCr/HSV Encoding: ITU-R 601
        Quantization      : Limited Range
        Flags             :
v4l2-ctl --device /dev/video0 --stream-mmap --stream-to=x.raw --stream-count=1
[ 1279.017148] ipu1_ic_prpenc: pipeline start failed with -32

>
>
> >
> > And can you explain why I can't colorspace convert the following CSI
> > capture case?:
> >
> > # imx6q-gw54xx tda19971 720p60 16-bit YUV sensor->mux->csi
> > # set sensor output pad to sensor source format
> > v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
> > # sensor format
> > media-ctl --get-v4l2 '"tda19971 2-0048":0'
> >                  [fmt:UYVY8_1X16/1280x720 field:none colorspace:srgb]
> > # reset all links
> > media-ctl --reset
> > # setup links
> > media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
> > media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
> > media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
> > # configure pads
> > media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/1280x720 field:none]"
> > media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/1280x720 field:none]"
> > media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/1280x720 colorspace:rec709 ycbcr:709]"
> > media-ctl --get-v4l2 '"ipu1_csi0":2'
> >                  [fmt:UYVY8_1X16/1280x720@1/30 field:none
> > colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range]
> > ^^^ still itu601
> >
> > I have found in my testing when dealing with a BT656 RGB colorspace
> > input which I need to convert ot rec709 I have to set the 'input' pad
> > of the csi which doesn't make sense and if I do this with a 16-bit RGB
> > colorspace (above) it jacks up the fmt:
> > media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/1280x720 colorspace:rec709 ycbcr:709]"
> > media-ctl --get-v4l2 '"ipu1_csi0":2'
> >                  [fmt:UYVY8_2X8/1280x720@1/30 field:none
> > colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range]
> > ^^^ changed fmt because AYUV32 at CSI input is invalid so it defaults
> > fmt to YUVY8_2X8
> >
> > So there is something I'm still doing wrong to setup CSC.
>
> Sorry I guess I don't understand your question here. Correct the CSI
> does not accept AYUV32 at its input pad.
>

What I was asking here is what is the correct way to configure for
ITU601 to REC709 CSC at the CSI?  I would expect to set the REC709
format on the output pad of the CSI but it seems to require me to set
it on the input pad.

Consider:
# imx6q-gw54xx tda19971 720p60 16-bit RGB sensor->mux->csi
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
media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/1280x720]"
media-ctl --get-v4l2 '"ipu1_csi0":2'
                [fmt:UYVY8_1X16/1280x720@1/30 field:none
colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range]
^^^ ITU601, but I want REC709
media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/1280x720 colorspace:rec709 ycbcr:709]"
media-ctl --get-v4l2 '"ipu1_csi0":2'
               [fmt:UYVY8_1X16/1280x720@1/30 field:none
colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range]
^^^ No invalid argument but its still ITU601 at CSI output... but what
I've found is if I set it at the CSI input the ycbcr changes but the
fmt gets jacked up (as expected)
media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/1280x720 colorspace:rec709 ycbcr:709]"
                [fmt:UYVY8_2X8/1280x720@1/30 field:none
colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range]
^^^ note we are now rec709 but fmt is UYVY8_2X8 because the CSI
doesn't accept UYVY8_1X16 so it deafults to UYVY8_2X8. However, again
I expect to have set the CSC on the output pad. If I do this on a
BT656 sensor bus it works because UYVY8_2X8 is valid.

Tim
