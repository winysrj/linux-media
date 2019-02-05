Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6821C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 23:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46F3F2073D
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 23:54:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FrS1Jlbs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfBEXyr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 18:54:47 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53871 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725967AbfBEXyr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 18:54:47 -0500
Received: by mail-wm1-f67.google.com with SMTP id d15so729424wmb.3
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2019 15:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=SvhjeZUO+H+iV98pLrtx3dtWCVvk6X80ghDoIrjr3y0=;
        b=FrS1Jlbsc1OwcnIbneM0EJWIPRI1c53Q81190yLv5/kHvhcMZpd24wTa4BG0V84jpK
         jX2ZeSqWgLY3Pa7Tpy6gvX0s3k03J7OjVum2SizPVOv4G6jd/PWhYWN+x6vXLqdA1gId
         EUNUDNJtmHJ6lpzUvYOU4lS8HMbOGEXVXujYfuriyKp2/cN2gHQC2dWh0JZ3bFBJoj1D
         Se9bL45TksdfyI/xGe6hyDE5n1E0+SFFaSGU81MfL+MD/6FnqQYNuKgm12jkdYZ+LsEh
         8ko5gHvijBSIvkcMyDhGt7Purn4IsDC0KgiUosQKXhoZ4is7pEroCi3oWVb8d0WSPVhe
         1ePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=SvhjeZUO+H+iV98pLrtx3dtWCVvk6X80ghDoIrjr3y0=;
        b=aqPEs6kN5h0OAqA2k4dMySBtQXb5cZHQBcUnnL/D1L4E7e7kmy53R/fZ8Ud9cLL6sT
         pC70Fger1AZnX3usYjgszJaKkrIDwfW+FPoB1oLdGIWnR2oPqJBYOu4uxTRS2dmCa0HM
         YWQZhTjz3wYgK5To5Cx0fadKPZLn1uwcplTKvSCACRcQ7jBrLSzzOU+0nTAkYBWh9VeM
         C7T3uWARKQ87Tj8VguZRRVlkTsuCJlKjTqRV2wzn/06uouWZPlulPWkYgGO+1kEFqgMx
         449d8XCNehBRISjy4+TyeSa1P+IMSsHTDsjG1wh86AN2d5L9W7A6VkPEvNz4Accp/4JT
         OmhA==
X-Gm-Message-State: AHQUAuZAQx/sIvfO3j5M6Z7nNBMjGwMc/L605+U7Ko7QXcmygtLO6uSg
        ZE+baLyli4nfg1hJy17IYtbPE+JE
X-Google-Smtp-Source: AHgI3IbEq881Li5Nwg8YSXH4Z+F3A5FuAswUNgLqj/5ukYeTRhGDkJFUmmiUOvvx9yvtysLJHIv/sA==
X-Received: by 2002:a7b:c854:: with SMTP id c20mr846022wml.153.1549410883721;
        Tue, 05 Feb 2019 15:54:43 -0800 (PST)
Received: from [172.30.88.194] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id z18sm13913655wml.36.2019.02.05.15.54.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 15:54:43 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: IMX CSI capture issues with tda1997x HDMI receiver
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
References: <CAJ+vNU0ic=wzSC9V4hbmarN0JeQMs121MzD6tH5KQ+ezENUNfA@mail.gmail.com>
 <02e8680c-9fd5-ff54-f292-f6936c76583e@gmail.com>
 <CAJ+vNU0YQeiPaE8tapJnihoj3DtewCPTj05BZv5cJ65YkE9MeQ@mail.gmail.com>
 <db70e0f7-0ad4-62f5-e64c-49c04c089dd6@gmail.com>
 <CAJ+vNU3X6ywgobcV+wQxEupkNeNmiWaT85xUOtKF_U44OAfskg@mail.gmail.com>
 <7cfe3570-64e5-d5e3-aeaf-35253c0fa918@gmail.com>
 <CAJ+vNU2VebBg83vsiGmsx+0PuD=qr4w3fc9a7-bvgji=iyPDyQ@mail.gmail.com>
Message-ID: <b97bf10a-f4dc-840b-9ffe-b311fdeee374@gmail.com>
Date:   Tue, 5 Feb 2019 15:52:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU2VebBg83vsiGmsx+0PuD=qr4w3fc9a7-bvgji=iyPDyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 2/5/19 11:16 AM, Tim Harvey wrote:
> On Sat, Feb 2, 2019 at 11:10 AM Steve Longerbeam<slongerbeam@gmail.com>  wrote:
>
> <snip>
>> The *real* way to fix this would be to allow programmable encodings in
>> ipu-ic.c. But unfortunately the encodings are hardcoded (grep for
>> ic_csc_rgb2ycbcr in ipu-ic.c).
>>
> Ok, I saw that you went ahead and worked on this (thanks!) and that
> you have a bt.709.v2 branch... is that one ready for testing?

Yes. I tried to test it too, but there is some regression in captured 
images, it could be something in ov5640.c (I'm testing with the SabreSD 
and the OV5640), or something else recently added. The regression looks 
like a stride problem, I'm hoping it wasn't the recently introduced 
compose window changes to relax width alignment. Have you tested with 
those commits and a prpenc/vf pipeline?

>> <snip>
>>> Also can we connect the mem2mem driver to the unused VDIC input in the
>>> media controller so that we can use the VDIC to de-interlace content
>>> captured from non IMX sources (ie PCI or USB capture devices)?
>> Exactly! That's something I have been working on. But it's difficult to
>> connect mem2mem to the unused VDIC IDMAC input pad because as of now the
>> v4l2 mem2mem internal API's do not allow connecting to *existing*
>> processing entities, and there are also issues with how sub-devices are
>> to deal with mem2mem contexts.
>>
>> I do have a WIP branch that creates a video output device that connects
>> to the VDIC IDMAC input pad, which doesn't have the above issues. The
>> only drawback with that is how gstreamer can make use of such an output
>> device.
>>
> ok, keep me posted. Is it the output-vdic or mem2mem.v4-mc branch?

The output-vdic branch. It's almost ready to go, there is only some 
strange issue with low and medium motion-compensation modes (captured 
images show "snow").


> I also noticed you have a add-fim-to-prpencvf branch... are you
> working on adding FIM to ipu_ic_prp/enc still? That would be nice to
> have to deal with sync loss/regain in analog decoders going through
> VDIC de-interlacing.

I've been trying to get this working, I ran into some locking issues 
when enabling lock debug options. Still trying to find a solution.

> <snip>
>>> This one (480i60Hz YUV via BT656 sensor->mux->csi->ic_prp->ic_prpenc)
>>> still baffles me a bit but I've also found that any bt656 capture that
>>> isn't specifically 720x480 (NTSC) or 720x576 (PAL) fails because of
>>> the resolution checks in ipu_csi_init_interface() resulting in
>>> 'Unsupported interlaced video mode'. I'm not sure if
>>> ipu_csi_set_bt_interlaced_codes() can be modified to support other
>>> resolutions?
>> Well, Bt.656 only defines standard definition NTSC and PAL.
>>
> That is true. Do you know of any other sensors that use higher
> resolutions with BT656 SAV/EAV encoding?

Nope all I have for testing is the NTSC/PAL ADV7180 on the SabreAuto.

>   The BT656 mode does work well
> for the progressive modes up to 1080p30 (1080p60 exceeds the IMX6
> pixel clock and can't be used).
>
> I could dig into the bt656 spec to try and understand the various
> codes that get stuffed into the IPUx_CSI0_CCIR_CODE_1/2/3 registers I
> suppose but I'm still not sure I want to push up a device-tree config
> that describes the tda1997x to CSI connection as 8bit BT656 as I would
> prefer to describe it as 16bit YUV instead (as I may be close to
> getting that format working well if we can get the IC able to output
> rec709).
>
> <snip>
>
>>> # imx6q-gw54xx tda19971 720p 16bit YUV IPU1_CSI0
>>> MODE1:sensor->mux->csi->ic_prp->ic_prpenc
>>> # set sensor output pad to sensor source format
>>> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
>>> # sensor format
>>> media-ctl --get-v4l2 '"tda19971 2-0048":0'
>>>                   [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
>>> # get framerate
>>> v4l2-ctl --device /dev/v4l-subdev15 --get-dv-timings
>>> DV timings:
>>>           Active width: 1280
>>>           Active height: 720
>>>           Total width: 1650
>>>           Total height: 750
>>>           Frame format: progressive
>>>           Polarities: +vsync +hsync
>>>           Pixelclock: 74250000 Hz (60.00 frames per second)
>>>           Horizontal frontporch: 110
>>>           Horizontal sync: 40
>>>           Horizontal backporch: 220
>>>           Vertical frontporch: 5
>>>           Vertical sync: 5
>>>           Vertical backporch: 20
>>>           Standards: CTA-861
>>>           CTA-861 VIC: 0
>>>           Flags: framerate can be reduced by 1/1.001, CE-video, has CTA-861 VIC
>>>
>>> # reset all links
>>> media-ctl --reset
>>> # setup links
>>> media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
>>> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>>> media-ctl -l "'ipu1_csi0':1 -> 'ipu1_ic_prp':0[1]"
>>> media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
>>> media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
>>> # configure pads
>>> media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/1280x720 field:none]"
>>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/1280x720 field:none]"
>>> media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/640x360 ]"
>>> media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x360 ]"
>>> media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/640x360 ]"
>>> media-ctl --get-v4l2 '"ipu1_ic_prpenc":1'
>>> # capture device
>>> media-ctl -e 'ipu1_ic_prpenc capture'
>>> /dev/video0
>>> v4l2-ctl --device /dev/video0 --get-fmt-video
>>> Format Video Capture:
>>>           Width/Height      : 640/360
>>>           Pixel Format      : 'UYVY' (UYVY 4:2:2)
>>>           Field             : None
>>>           Bytes per Line    : 1280
>>>           Size Image        : 460800
>>>           Colorspace        : Rec. 709
>>>           Transfer Function : Rec. 709
>>>           YCbCr/HSV Encoding: ITU-R 601
>>>           Quantization      : Limited Range
>>>           Flags             :
>>>
>>> # capture 1 frame
>>> v4l2-ctl --device /dev/video0 --stream-mmap --stream-to=x.raw --stream-count=1
>>> [  125.966980] ipu1_ic_prpenc: pipeline start failed with -32
>>>
>>> Do you know what the failure is here?
>> You are /2 downscaling in the CSI, but did not set the compose window at
>> the input pad, e.g:
>>
>> media-ctl --set-v4l2 '"ipu1_csi0":0[compose:(0,0)/640x360]' # 1/2 scale
>>
> I don't think this is the issue. Note that I 'was' able to get the
> same pipeline with the div-by-2 downscale without compose working with
> 720p bt656 YUV.
>
> Here is the 720p 16bit YUV bus again with the compose:
> # 720p60Hz YUV 16bit YUV bus
> # imx6q-gw54xx tda19971 2-0048 IPU1_CSI0
> MODE1:sensor->mux->csi->ic_prp->ic_prpenc
> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
> BT timings set
> # sensor format
> media-ctl --get-v4l2 '"tda19971 2-0048":0'
>                  [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
> # reset all links
> media-ctl --reset
> # setup links
> media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
> media-ctl -l "'ipu1_csi0':1 -> 'ipu1_ic_prp':0[1]"
> media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
> media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
> # configure pads
> media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/1280x720 field:none]"
> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/1280x720 field:none]"
> media-ctl -V "'ipu1_csi0':0 [fmt:UYVY8_1X16/1280x720 field:none]"
> media-ctl -V "'ipu1_csi0':0 [compose:(0,0)/640x360]"
> media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x360 ]"
> media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/640x360 ]"
> media-ctl --get-v4l2 "'ipu1_csi0':0"
>                  [fmt:UYVY8_1X16/1280x720@1/30 field:none
> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range
>                   crop.bounds:(0,0)/1280x720
>                   crop:(0,0)/1280x720
>                   compose.bounds:(0,0)/1280x720
>                   compose:(0,0)/640x360]
> media-ctl --get-v4l2 "'ipu1_csi0':1"
>                  [fmt:UYVY8_1X16/640x360@1/30 field:none
> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
> media-ctl --get-v4l2 "'ipu1_ic_prp':1"
>                  [fmt:AYUV8_1X32/640x480@1/30 field:none

Ah, ipu1_ic_prp:1 pad is 640x480, it looks like you missed setting 
ipu1_csi0:1 pad format, so that ipu1_ic_prp pads are still set to 
default formats.

> colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
> media-ctl --get-v4l2 "'ipu1_ic_prpenc':1"
>                  [fmt:AYUV8_1X32/640x360@1001/30000 field:none
> colorspace:smpte170m xfer:709 ycbcr:601 quantization:lim-range]
> media-ctl -e 'ipu1_ic_prpenc capture'
> /dev/video0
> v4l2-ctl --device /dev/video0 --get-fmt-video
> Format Video Capture:
>          Width/Height      : 640/360
>          Pixel Format      : 'UYVY' (UYVY 4:2:2)
>          Field             : None
>          Bytes per Line    : 1280
>          Size Image        : 460800
>          Colorspace        : SMPTE 170M
>          Transfer Function : Rec. 709
>          YCbCr/HSV Encoding: ITU-R 601
>          Quantization      : Limited Range
>          Flags             :
> v4l2-ctl --device /dev/video0 --stream-mmap --stream-to=x.raw --stream-count=1
> [ 1279.017148] ipu1_ic_prpenc: pipeline start failed with -32
>
>>> And can you explain why I can't colorspace convert the following CSI
>>> capture case?:
>>>
>>> # imx6q-gw54xx tda19971 720p60 16-bit YUV sensor->mux->csi
>>> # set sensor output pad to sensor source format
>>> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
>>> # sensor format
>>> media-ctl --get-v4l2 '"tda19971 2-0048":0'
>>>                   [fmt:UYVY8_1X16/1280x720 field:none colorspace:srgb]
>>> # reset all links
>>> media-ctl --reset
>>> # setup links
>>> media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
>>> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>>> media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
>>> # configure pads
>>> media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/1280x720 field:none]"
>>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/1280x720 field:none]"
>>> media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/1280x720 colorspace:rec709 ycbcr:709]"
>>> media-ctl --get-v4l2 '"ipu1_csi0":2'
>>>                   [fmt:UYVY8_1X16/1280x720@1/30 field:none
>>> colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range]
>>> ^^^ still itu601
>>>
>>> I have found in my testing when dealing with a BT656 RGB colorspace
>>> input which I need to convert ot rec709 I have to set the 'input' pad
>>> of the csi which doesn't make sense and if I do this with a 16-bit RGB
>>> colorspace (above) it jacks up the fmt:
>>> media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/1280x720 colorspace:rec709 ycbcr:709]"
>>> media-ctl --get-v4l2 '"ipu1_csi0":2'
>>>                   [fmt:UYVY8_2X8/1280x720@1/30 field:none
>>> colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range]
>>> ^^^ changed fmt because AYUV32 at CSI input is invalid so it defaults
>>> fmt to YUVY8_2X8
>>>
>>> So there is something I'm still doing wrong to setup CSC.
>> Sorry I guess I don't understand your question here. Correct the CSI
>> does not accept AYUV32 at its input pad.
>>
> What I was asking here is what is the correct way to configure for
> ITU601 to REC709 CSC at the CSI?  I would expect to set the REC709
> format on the output pad of the CSI but it seems to require me to set
> it on the input pad.

Right, the driver only allows setting colorimetry at the sink pads, and 
propagates them to the source pads. So you'll need to set colorimetry 
params at the CSI sink pad.


> Consider:
> # imx6q-gw54xx tda19971 720p60 16-bit RGB sensor->mux->csi
> # set sensor output pad to sensor source format
> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
> # sensor format
> media-ctl --get-v4l2 '"tda19971 2-0048":0'
>                   [fmt:UYVY8_1X16/1280x720 field:none colorspace:srgb]
> # reset all links
> media-ctl --reset
> # setup links
> media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
> media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
> # configure pads
> media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/1280x720 field:none]"
> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/1280x720 field:none]"
> media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/1280x720]"
> media-ctl --get-v4l2 '"ipu1_csi0":2'
>                  [fmt:UYVY8_1X16/1280x720@1/30 field:none
> colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range]
> ^^^ ITU601, but I want REC709
> media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/1280x720 colorspace:rec709 ycbcr:709]"
> media-ctl --get-v4l2 '"ipu1_csi0":2'
>                 [fmt:UYVY8_1X16/1280x720@1/30 field:none
> colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range]
> ^^^ No invalid argument but its still ITU601 at CSI output... but what
> I've found is if I set it at the CSI input the ycbcr changes but the
> fmt gets jacked up (as expected)
> media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/1280x720 colorspace:rec709 ycbcr:709]"
>                  [fmt:UYVY8_2X8/1280x720@1/30 field:none
> colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range]
> ^^^ note we are now rec709 but fmt is UYVY8_2X8 because the CSI
> doesn't accept UYVY8_1X16 so it deafults to UYVY8_2X8.

Why doesn't the CSI accept UYVY8_1X16 at its sink pad?

This doesn't work?:

media-ctl -V "'ipu1_csi0':0 [fmt:UYVY8_1X16/1280x720 colorspace:rec709 ycbcr:709]"


Steve

