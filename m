Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40745C282C2
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 01:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F18DC20869
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 01:54:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UlFAUJAr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfBHByF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 20:54:05 -0500
Received: from mail-wm1-f47.google.com ([209.85.128.47]:50453 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbfBHByE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 20:54:04 -0500
Received: by mail-wm1-f47.google.com with SMTP id z5so1848268wmf.0
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2019 17:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=SIzBjuMi2Kns8ahy6wcJvAt6YCBaRFn/EPFTTGZp4fg=;
        b=UlFAUJArTYQCB7unutrCUastlpGEAWkc37iaRHmGYvTsJ9Ti1or5JePeNWCen24mDd
         NFU48+CN3fNrRGrD9kuTzjsRiQs2Z7eDd/C2iScJV3J71ZsxZ03kQYDGfVs6J/leg7iQ
         xHCLvySqW+MRAbxywaJqnsI1YrKKaz1VaZqjBhdAL0XeYWPNDdWe2VDoi0ysi6uEQirY
         1d+lvBVG7aUyVHEzZVu5/vLyvkAH/QUbdnb9vFAic+feCm4zMMlV2ZQ0zgJU0vxatbYS
         Cp1hxAzczrAKyv6i0ULX4qSMD8hSepoMogbJ1h3jktmHPP6gARaqSKtfe2sR8rcLVS2K
         ZDXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=SIzBjuMi2Kns8ahy6wcJvAt6YCBaRFn/EPFTTGZp4fg=;
        b=tWnqAfXJOvy4TtI+z2CzbdX6hWtJJ43zl/S3/PAEe692xATHiceeZUkKz3MmvKdzoO
         c9r26KEUixGkr+WjMuLmnm+o7YAl0qjWsZfPmDTMsr9XzpsYNfm9097uPgPIiXZ2iyvA
         qmwwk/W59xoTMV5pAQCIvEtd/RzBJWiWSVUx7HKtoG2aQv6uZ6kNDKQZfn6QTo1K/K49
         aOk+ioJE6LRCoHnSk1IqyqKKQaqa8bwpS19MoZj1ghQ6tSPjroHG2Pf9aSAwLV45FoHh
         1w8iW9D7PgD3Whs2UbdtMzJaxteu3rFAalZzJAXwmyOf9YASdIn6L62jvcrbOA90hNGS
         b18A==
X-Gm-Message-State: AHQUAuZ2i5Zi1V2qOTWPiFh/b8OyPz09+l04vM8qgs8LeUTWl2MQMzUI
        bWkp0K/1iy3zVLXtnv8KP8Ls378c
X-Google-Smtp-Source: AHgI3IZTwnA0vxYRGtvbW5M7rVuKNdkFiEHVwj9RWm127Z47F5I4iN3JwODksgNNsOeIMUoj/VIyig==
X-Received: by 2002:a1c:c282:: with SMTP id s124mr9336270wmf.105.1549590841039;
        Thu, 07 Feb 2019 17:54:01 -0800 (PST)
Received: from [172.30.89.10] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id d9sm1065441wrn.72.2019.02.07.17.53.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Feb 2019 17:54:00 -0800 (PST)
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
 <b97bf10a-f4dc-840b-9ffe-b311fdeee374@gmail.com>
 <CAJ+vNU0_-Ti1bAfEo=3kg79hYFSE4ZFx9C4HswqUWXB463yXXA@mail.gmail.com>
 <CAJ+vNU3HpW=K_3ub9iX33GnjaZuHUAqbto=saV13DaC=ZSO2aQ@mail.gmail.com>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <3414560a-0aa0-9c51-28eb-7d3ded0af86e@gmail.com>
Date:   Thu, 7 Feb 2019 17:53:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU3HpW=K_3ub9iX33GnjaZuHUAqbto=saV13DaC=ZSO2aQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 2/7/19 5:15 PM, Tim Harvey wrote:
> On Wed, Feb 6, 2019 at 8:31 AM Tim Harvey <tharvey@gateworks.com> wrote:
>> On Tue, Feb 5, 2019 at 3:54 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>>>
>>>
>>> On 2/5/19 11:16 AM, Tim Harvey wrote:
>>>> On Sat, Feb 2, 2019 at 11:10 AM Steve Longerbeam<slongerbeam@gmail.com>  wrote:
>>>>
>>>> <snip>
>>>>> The *real* way to fix this would be to allow programmable encodings in
>>>>> ipu-ic.c. But unfortunately the encodings are hardcoded (grep for
>>>>> ic_csc_rgb2ycbcr in ipu-ic.c).
>>>>>
>>>> Ok, I saw that you went ahead and worked on this (thanks!) and that
>>>> you have a bt.709.v2 branch... is that one ready for testing?
>>> Yes. I tried to test it too, but there is some regression in captured
>>> images, it could be something in ov5640.c (I'm testing with the SabreSD
>>> and the OV5640), or something else recently added. The regression looks
>>> like a stride problem, I'm hoping it wasn't the recently introduced
>>> compose window changes to relax width alignment. Have you tested with
>>> those commits and a prpenc/vf pipeline?
>> I have been testing v4.20 with:
>> media: imx: lift CSI and PRP ENC/VF width alignment restriction
>> media: imx: set compose rectangle to mbus format
>> media: imx: add capture compose rectangle
>> imx: imx-media: register mem2mem device with media controller
>> media: imx: add mem2mem device
>> media: imx-csi: Skip first few frames from a BT.656 source
>> media: imx.rst: Update doc to reflect fixes to interlaced capture
>> media: imx: Allow interweave with top/bottom lines swapped
>> media: imx-csi: Move crop/compose reset after filling default mbus fields
>> media: imx: vdic: rely on VDIC for correct field order
>> media: imx-csi: Allow skipping odd chroma rows for YVU420
>> media: imx: interweave and odd-chroma-row skip are incompatible
>> media: imx-csi: Double crop height for alternate fields at sink
>> media: imx: Fix field negotiation
>> gpu: ipu-v3: Add planar support to interlaced scan
>> gpu: ipu-csi: Swap fields according to input/output field types
>> media: videodev2.h: Add more field helper macros
>> media: imx: prpencvf: Stop upstream before disabling IDMA channel
>> media: imx: csi: Stop upstream before disabling IDMA channel
>> media: imx: csi: Disable CSI immediately after last EOF
>> media: imx-csi: Input connections to CSI should be optional
>>
>> What kind of artifacts are you seeing?
>>
>> I noticed your 'media: imx: Add support for BT.709 encoding' series
>> don't apply cleanly to 4.20 that I'm working with so perhaps its
>> something else. I'll bump up to linux-media, apply your bt.709.v2 and
>> see what I get. The BT.709 support is critical for me otherwise I
>> can't use coda with any pipelines that go through the IC with the
>> tda1997x HDMI decoder.
>>
> Steve,
>
> I'm testing your bt.709.v2 branch and it works great! I can now
> request ycbcr=709 at the CSI input pad and rec709 propagates all the
> way through the rest of the pipeline and works with coda. I don't see
> any artifacts so I'm still curious what your seeing?

Our emails crossed, see my last reply. Great to hear rec709 is working 
for you.

>
> I did notice it adds a regression in that RGB->RGB ends up erroring
> out with 'Unsupported YCbCr encoding' in ipu_ic_task_init. I'll
> respond to your patch with details and a fix.

Ok, I take a look before submitting v2.

>
> <snip>
>>>>>> # imx6q-gw54xx tda19971 720p 16bit YUV IPU1_CSI0
>>>>>> MODE1:sensor->mux->csi->ic_prp->ic_prpenc
>>>>>> # set sensor output pad to sensor source format
>>>>>> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
>>>>>> # sensor format
>>>>>> media-ctl --get-v4l2 '"tda19971 2-0048":0'
>>>>>>                    [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
>>>>>> # get framerate
>>>>>> v4l2-ctl --device /dev/v4l-subdev15 --get-dv-timings
>>>>>> DV timings:
>>>>>>            Active width: 1280
>>>>>>            Active height: 720
>>>>>>            Total width: 1650
>>>>>>            Total height: 750
>>>>>>            Frame format: progressive
>>>>>>            Polarities: +vsync +hsync
>>>>>>            Pixelclock: 74250000 Hz (60.00 frames per second)
>>>>>>            Horizontal frontporch: 110
>>>>>>            Horizontal sync: 40
>>>>>>            Horizontal backporch: 220
>>>>>>            Vertical frontporch: 5
>>>>>>            Vertical sync: 5
>>>>>>            Vertical backporch: 20
>>>>>>            Standards: CTA-861
>>>>>>            CTA-861 VIC: 0
>>>>>>            Flags: framerate can be reduced by 1/1.001, CE-video, has CTA-861 VIC
>>>>>>
>>>>>> # reset all links
>>>>>> media-ctl --reset
>>>>>> # setup links
>>>>>> media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
>>>>>> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>>>>>> media-ctl -l "'ipu1_csi0':1 -> 'ipu1_ic_prp':0[1]"
>>>>>> media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
>>>>>> media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
>>>>>> # configure pads
>>>>>> media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/1280x720 field:none]"
>>>>>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/1280x720 field:none]"
>>>>>> media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/640x360 ]"
>>>>>> media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x360 ]"
>>>>>> media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/640x360 ]"
>>>>>> media-ctl --get-v4l2 '"ipu1_ic_prpenc":1'
>>>>>> # capture device
>>>>>> media-ctl -e 'ipu1_ic_prpenc capture'
>>>>>> /dev/video0
>>>>>> v4l2-ctl --device /dev/video0 --get-fmt-video
>>>>>> Format Video Capture:
>>>>>>            Width/Height      : 640/360
>>>>>>            Pixel Format      : 'UYVY' (UYVY 4:2:2)
>>>>>>            Field             : None
>>>>>>            Bytes per Line    : 1280
>>>>>>            Size Image        : 460800
>>>>>>            Colorspace        : Rec. 709
>>>>>>            Transfer Function : Rec. 709
>>>>>>            YCbCr/HSV Encoding: ITU-R 601
>>>>>>            Quantization      : Limited Range
>>>>>>            Flags             :
>>>>>>
>>>>>> # capture 1 frame
>>>>>> v4l2-ctl --device /dev/video0 --stream-mmap --stream-to=x.raw --stream-count=1
>>>>>> [  125.966980] ipu1_ic_prpenc: pipeline start failed with -32
>>>>>>
>>>>>> Do you know what the failure is here?
>>>>> You are /2 downscaling in the CSI, but did not set the compose window at
>>>>> the input pad, e.g:
>>>>>
>>>>> media-ctl --set-v4l2 '"ipu1_csi0":0[compose:(0,0)/640x360]' # 1/2 scale
>>>>>
>>>> I don't think this is the issue. Note that I 'was' able to get the
>>>> same pipeline with the div-by-2 downscale without compose working with
>>>> 720p bt656 YUV.
>>>>
>>>> Here is the 720p 16bit YUV bus again with the compose:
>>>> # 720p60Hz YUV 16bit YUV bus
>>>> # imx6q-gw54xx tda19971 2-0048 IPU1_CSI0
>>>> MODE1:sensor->mux->csi->ic_prp->ic_prpenc
>>>> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
>>>> BT timings set
>>>> # sensor format
>>>> media-ctl --get-v4l2 '"tda19971 2-0048":0'
>>>>                   [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
>>>> # reset all links
>>>> media-ctl --reset
>>>> # setup links
>>>> media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
>>>> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>>>> media-ctl -l "'ipu1_csi0':1 -> 'ipu1_ic_prp':0[1]"
>>>> media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
>>>> media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
>>>> # configure pads
>>>> media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/1280x720 field:none]"
>>>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/1280x720 field:none]"
>>>> media-ctl -V "'ipu1_csi0':0 [fmt:UYVY8_1X16/1280x720 field:none]"
>>>> media-ctl -V "'ipu1_csi0':0 [compose:(0,0)/640x360]"
>>>> media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x360 ]"
>>>> media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/640x360 ]"
>>>> media-ctl --get-v4l2 "'ipu1_csi0':0"
>>>>                   [fmt:UYVY8_1X16/1280x720@1/30 field:none
>>>> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range
>>>>                    crop.bounds:(0,0)/1280x720
>>>>                    crop:(0,0)/1280x720
>>>>                    compose.bounds:(0,0)/1280x720
>>>>                    compose:(0,0)/640x360]
>>>> media-ctl --get-v4l2 "'ipu1_csi0':1"
>>>>                   [fmt:UYVY8_1X16/640x360@1/30 field:none
>>>> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
>>>> media-ctl --get-v4l2 "'ipu1_ic_prp':1"
>>>>                   [fmt:AYUV8_1X32/640x480@1/30 field:none
>>> Ah, ipu1_ic_prp:1 pad is 640x480, it looks like you missed setting
>>> ipu1_csi0:1 pad format, so that ipu1_ic_prp pads are still set to
>>> default formats.
>> but I do set it above: media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x360 ]
>>
>> here's a sequence of set/get:
>> root@imx6q-gw5404:~# media-ctl --set-v4l2 "'tda19971 2-0048':0
>> [fmt:UYVY8_1X16/1280x720 field:none]"
>> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'tda19971 2-0048':0"
>>                  [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
>> root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_csi0_mux':2
>> [fmt:UYVY8_1X16/1280x720 field:none]"
>> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0_mux':2"
>>                  [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
>> root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_csi0':0 [fmt:AYUV32/640x360]"
>> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0':0"
>>                  [fmt:UYVY8_2X8/640x360@1/30 field:none
>> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range
>>                   crop.bounds:(0,0)/640x360
>>                   crop:(0,0)/640x360
>>                   compose.bounds:(0,0)/640x360
>>                   compose:(0,0)/640x360]
>> ^^^ the compose setting defaults so I really don't think the next cmd
>> does anything
>> root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_csi0':0
>> [compose:(0,0)/640x360]"
>> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0':0"
>>                  [fmt:UYVY8_2X8/640x360@1/30 field:none
>> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range
>>                   crop.bounds:(0,0)/640x360
>>                   crop:(0,0)/640x360
>>                   compose.bounds:(0,0)/640x360
>>                   compose:(0,0)/640x360]
>> ^^^ see, same as above (but I like adding the compose to pipeline
>> configuration instructions for documentation purposes; makes it
>> obvious they can select the window)
>> root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_ic_prp':1 [fmt:AYUV32/640x360]"
>> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prp':1"
>>                  [fmt:AYUV8_1X32/1280x720@1/30 field:none
>> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
>> ^^^ but yes, this one isn't getting set properly to 640x360... and it
>> looks like its at the input:
>> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prp':0"
>>                  [fmt:AYUV8_1X32/1280x720@1/30 field:none
>> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
>>
>> my understanding is if I set it on the output pad it will propagate
>> back to the input pad. I'm also wondering why I don't get an error if
>> it doesn't change.
>>
>> If I setup the input pad manually and continue on:
>> root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_ic_prp':0 [fmt:AYUV32/640x360]"
>> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prp':0"
>>                  [fmt:AYUV8_1X32/640x360@1/30 field:none
>> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
>> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prp':1"
>>                  [fmt:AYUV8_1X32/640x360@1/30 field:none
>> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
>> root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_ic_prpenc':1
>> [fmt:AYUV32/640x360]"
>> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prpenc':1"
>>                  [fmt:AYUV8_1X32/640x360@1001/30000 field:none
>> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
>> root@imx6q-gw5404:~# v4l2-ctl --device /dev/video0 --stream-mmap
>> --stream-to=x.raw --stream-count=1
>> [ 4695.356802] ipu1_ic_prpenc: pipeline start failed with -32
>> ^^^ still fails
>>
> Ok there is definitely something wrong when using the IC with
> UYVY8_1X16 (passthrough) which works with UYVY8_2X8. It looks to me
> like the ipu1_ic_prp isn't negotiating its format properly. You can't
> re-create this because you don't have any UYVY8_1X16 (passthrough)
> sensors right?

Sorry, maybe I didn't mention this, but passthrough cannot go though the 
IPU, you can only send passthrough pixels out the CSI directly to 
/dev/videoN interface (the ipu_csi:2 pad).

Steve

