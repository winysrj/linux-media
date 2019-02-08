Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02060C282C2
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 01:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A115C21916
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 01:48:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F6KVK3xV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfBHBss (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 20:48:48 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44047 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbfBHBss (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 20:48:48 -0500
Received: by mail-wr1-f67.google.com with SMTP id v16so1862176wrn.11
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2019 17:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=g8v3/MsI7rLZyGvRLqFGKwDNCzvj/cTHsJmM9gaUBDU=;
        b=F6KVK3xV2La7Rl9BjX6H7PWlrNw3Wuqpx4VudIt/szo3EyjO47S1i9m0Edi3Dh69Pv
         sTusGdKjja1rsvOE3UoPATTIcDvKPC6JQuhuazfwcz3/q97j3q4T8JbM70Bj3rsuOpy0
         gQIvs6CuTC2F+pVItffNNPlUIYmETvg9PtvGekVSuY57zGrRfVG0ocbYv8mF7q3y2ZKf
         fKjksvXkkFR1jRLpC7am5nUe7tDPdi5wKg1xxzeAO1YcLaDvvBuCtl3Pwnag6L0tqiFM
         Zxw8QbKxSJsIQUV9D5Qc7cYc1dl+zpZbSz/jaW9+CiUJuNKgwtl5brAOcAOWagzFlPZm
         s2zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=g8v3/MsI7rLZyGvRLqFGKwDNCzvj/cTHsJmM9gaUBDU=;
        b=BvD/9onE/N2LoXsuoTaXhlCu+tsV24S4OVq3+4nao2tnaY0iNbgYb+2qZQDuzze108
         Oj4FAa9XHph0OysEQDWOh09Jw3ITo7DCput0ImSow47JO6GooFCy51fS2E4W37In9GRn
         XFuh1CmfiuF/dDMfNVN25nXODLps6dbDpkGc7gR+M7TIdIYOK/2IM14LebYp9lZSz7rN
         0ORU9IySm/tLWxDkiQhNRmI8P2eqoiNQ0NkiYOj5j+6VrZGxjdhXTj4kGe0f51/1z/KX
         mCbYxQv6KgwvrHKaH1oIkVQaiAp4rMZvucUdYc9AG872JHsouKuzr65zB4hlqMPs6Au6
         5P2A==
X-Gm-Message-State: AHQUAuZVq/5zsRKs0dhtGp2ZVxtZmG6C+CyzHeaz86gCCCAvmiOdmB3m
        14mYLu1AFreN60nA+w0USc5IbVIT
X-Google-Smtp-Source: AHgI3IZhj8RwXqPERiyewJ0dERyqJOZvU+WeM0g2sgM/8ziAUi3TLsXohV+1zv9tdip9WFX0XyGeRw==
X-Received: by 2002:adf:db44:: with SMTP id f4mr780679wrj.74.1549590524841;
        Thu, 07 Feb 2019 17:48:44 -0800 (PST)
Received: from [172.30.89.10] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id t12sm1802590wra.63.2019.02.07.17.48.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Feb 2019 17:48:44 -0800 (PST)
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
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <1936a548-02dc-248e-85d3-97ede0f3a4bf@gmail.com>
Date:   Thu, 7 Feb 2019 17:48:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU0_-Ti1bAfEo=3kg79hYFSE4ZFx9C4HswqUWXB463yXXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Tim,

On 2/6/19 8:31 AM, Tim Harvey wrote:
> On Tue, Feb 5, 2019 at 3:54 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>>
>>
>> On 2/5/19 11:16 AM, Tim Harvey wrote:
>>> On Sat, Feb 2, 2019 at 11:10 AM Steve Longerbeam<slongerbeam@gmail.com>  wrote:
>>>
>>> <snip>
>>>> The *real* way to fix this would be to allow programmable encodings in
>>>> ipu-ic.c. But unfortunately the encodings are hardcoded (grep for
>>>> ic_csc_rgb2ycbcr in ipu-ic.c).
>>>>
>>> Ok, I saw that you went ahead and worked on this (thanks!) and that
>>> you have a bt.709.v2 branch... is that one ready for testing?
>> Yes. I tried to test it too, but there is some regression in captured
>> images, it could be something in ov5640.c (I'm testing with the SabreSD
>> and the OV5640), or something else recently added. The regression looks
>> like a stride problem, I'm hoping it wasn't the recently introduced
>> compose window changes to relax width alignment. Have you tested with
>> those commits and a prpenc/vf pipeline?
> I have been testing v4.20 with:
> media: imx: lift CSI and PRP ENC/VF width alignment restriction
> media: imx: set compose rectangle to mbus format
> media: imx: add capture compose rectangle
> imx: imx-media: register mem2mem device with media controller
> media: imx: add mem2mem device
> media: imx-csi: Skip first few frames from a BT.656 source
> media: imx.rst: Update doc to reflect fixes to interlaced capture
> media: imx: Allow interweave with top/bottom lines swapped
> media: imx-csi: Move crop/compose reset after filling default mbus fields
> media: imx: vdic: rely on VDIC for correct field order
> media: imx-csi: Allow skipping odd chroma rows for YVU420
> media: imx: interweave and odd-chroma-row skip are incompatible
> media: imx-csi: Double crop height for alternate fields at sink
> media: imx: Fix field negotiation
> gpu: ipu-v3: Add planar support to interlaced scan
> gpu: ipu-csi: Swap fields according to input/output field types
> media: videodev2.h: Add more field helper macros
> media: imx: prpencvf: Stop upstream before disabling IDMA channel
> media: imx: csi: Stop upstream before disabling IDMA channel
> media: imx: csi: Disable CSI immediately after last EOF
> media: imx-csi: Input connections to CSI should be optional
>
> What kind of artifacts are you seeing?

It was the wrong-stride kind of artifact ("striations" ?? :)

As it turns out the regression was indeed related to the capture compose 
window changes, I submitted a patch that fixes it ("media: imx: Set 
capture compose rectangle in capture_device_set_format").

>
> I noticed your 'media: imx: Add support for BT.709 encoding' series
> don't apply cleanly to 4.20 that I'm working with so perhaps its
> something else. I'll bump up to linux-media, apply your bt.709.v2 and
> see what I get. The BT.709 support is critical for me otherwise I
> can't use coda with any pipelines that go through the IC with the
> tda1997x HDMI decoder.

With the regression fix above, I was able to verify the BT.709 encode 
and inverse encode matrices produce good image colors, with the 
bt.709.v2 branch. So I will submit this today.

>>>> <snip>
>>>>> Also can we connect the mem2mem driver to the unused VDIC input in the
>>>>> media controller so that we can use the VDIC to de-interlace content
>>>>> captured from non IMX sources (ie PCI or USB capture devices)?
>>>> Exactly! That's something I have been working on. But it's difficult to
>>>> connect mem2mem to the unused VDIC IDMAC input pad because as of now the
>>>> v4l2 mem2mem internal API's do not allow connecting to *existing*
>>>> processing entities, and there are also issues with how sub-devices are
>>>> to deal with mem2mem contexts.
>>>>
>>>> I do have a WIP branch that creates a video output device that connects
>>>> to the VDIC IDMAC input pad, which doesn't have the above issues. The
>>>> only drawback with that is how gstreamer can make use of such an output
>>>> device.
>>>>
>>> ok, keep me posted. Is it the output-vdic or mem2mem.v4-mc branch?
>> The output-vdic branch. It's almost ready to go, there is only some
>> strange issue with low and medium motion-compensation modes (captured
>> images show "snow").
>>
>>
>>> I also noticed you have a add-fim-to-prpencvf branch... are you
>>> working on adding FIM to ipu_ic_prp/enc still? That would be nice to
>>> have to deal with sync loss/regain in analog decoders going through
>>> VDIC de-interlacing.
>> I've been trying to get this working, I ran into some locking issues
>> when enabling lock debug options. Still trying to find a solution.
>>
>>> <snip>
>>>>> This one (480i60Hz YUV via BT656 sensor->mux->csi->ic_prp->ic_prpenc)
>>>>> still baffles me a bit but I've also found that any bt656 capture that
>>>>> isn't specifically 720x480 (NTSC) or 720x576 (PAL) fails because of
>>>>> the resolution checks in ipu_csi_init_interface() resulting in
>>>>> 'Unsupported interlaced video mode'. I'm not sure if
>>>>> ipu_csi_set_bt_interlaced_codes() can be modified to support other
>>>>> resolutions?
>>>> Well, Bt.656 only defines standard definition NTSC and PAL.
>>>>
>>> That is true. Do you know of any other sensors that use higher
>>> resolutions with BT656 SAV/EAV encoding?
>> Nope all I have for testing is the NTSC/PAL ADV7180 on the SabreAuto.
>>
>>>    The BT656 mode does work well
>>> for the progressive modes up to 1080p30 (1080p60 exceeds the IMX6
>>> pixel clock and can't be used).
>>>
>>> I could dig into the bt656 spec to try and understand the various
>>> codes that get stuffed into the IPUx_CSI0_CCIR_CODE_1/2/3 registers I
>>> suppose but I'm still not sure I want to push up a device-tree config
>>> that describes the tda1997x to CSI connection as 8bit BT656 as I would
>>> prefer to describe it as 16bit YUV instead (as I may be close to
>>> getting that format working well if we can get the IC able to output
>>> rec709).
>>>
>>> <snip>
>>>
>>>>> # imx6q-gw54xx tda19971 720p 16bit YUV IPU1_CSI0
>>>>> MODE1:sensor->mux->csi->ic_prp->ic_prpenc
>>>>> # set sensor output pad to sensor source format
>>>>> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
>>>>> # sensor format
>>>>> media-ctl --get-v4l2 '"tda19971 2-0048":0'
>>>>>                    [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
>>>>> # get framerate
>>>>> v4l2-ctl --device /dev/v4l-subdev15 --get-dv-timings
>>>>> DV timings:
>>>>>            Active width: 1280
>>>>>            Active height: 720
>>>>>            Total width: 1650
>>>>>            Total height: 750
>>>>>            Frame format: progressive
>>>>>            Polarities: +vsync +hsync
>>>>>            Pixelclock: 74250000 Hz (60.00 frames per second)
>>>>>            Horizontal frontporch: 110
>>>>>            Horizontal sync: 40
>>>>>            Horizontal backporch: 220
>>>>>            Vertical frontporch: 5
>>>>>            Vertical sync: 5
>>>>>            Vertical backporch: 20
>>>>>            Standards: CTA-861
>>>>>            CTA-861 VIC: 0
>>>>>            Flags: framerate can be reduced by 1/1.001, CE-video, has CTA-861 VIC
>>>>>
>>>>> # reset all links
>>>>> media-ctl --reset
>>>>> # setup links
>>>>> media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
>>>>> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>>>>> media-ctl -l "'ipu1_csi0':1 -> 'ipu1_ic_prp':0[1]"
>>>>> media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
>>>>> media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
>>>>> # configure pads
>>>>> media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/1280x720 field:none]"
>>>>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/1280x720 field:none]"
>>>>> media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/640x360 ]"
>>>>> media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x360 ]"
>>>>> media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/640x360 ]"
>>>>> media-ctl --get-v4l2 '"ipu1_ic_prpenc":1'
>>>>> # capture device
>>>>> media-ctl -e 'ipu1_ic_prpenc capture'
>>>>> /dev/video0
>>>>> v4l2-ctl --device /dev/video0 --get-fmt-video
>>>>> Format Video Capture:
>>>>>            Width/Height      : 640/360
>>>>>            Pixel Format      : 'UYVY' (UYVY 4:2:2)
>>>>>            Field             : None
>>>>>            Bytes per Line    : 1280
>>>>>            Size Image        : 460800
>>>>>            Colorspace        : Rec. 709
>>>>>            Transfer Function : Rec. 709
>>>>>            YCbCr/HSV Encoding: ITU-R 601
>>>>>            Quantization      : Limited Range
>>>>>            Flags             :
>>>>>
>>>>> # capture 1 frame
>>>>> v4l2-ctl --device /dev/video0 --stream-mmap --stream-to=x.raw --stream-count=1
>>>>> [  125.966980] ipu1_ic_prpenc: pipeline start failed with -32
>>>>>
>>>>> Do you know what the failure is here?
>>>> You are /2 downscaling in the CSI, but did not set the compose window at
>>>> the input pad, e.g:
>>>>
>>>> media-ctl --set-v4l2 '"ipu1_csi0":0[compose:(0,0)/640x360]' # 1/2 scale
>>>>
>>> I don't think this is the issue. Note that I 'was' able to get the
>>> same pipeline with the div-by-2 downscale without compose working with
>>> 720p bt656 YUV.
>>>
>>> Here is the 720p 16bit YUV bus again with the compose:
>>> # 720p60Hz YUV 16bit YUV bus
>>> # imx6q-gw54xx tda19971 2-0048 IPU1_CSI0
>>> MODE1:sensor->mux->csi->ic_prp->ic_prpenc
>>> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
>>> BT timings set
>>> # sensor format
>>> media-ctl --get-v4l2 '"tda19971 2-0048":0'
>>>                   [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
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
>>> media-ctl -V "'ipu1_csi0':0 [fmt:UYVY8_1X16/1280x720 field:none]"
>>> media-ctl -V "'ipu1_csi0':0 [compose:(0,0)/640x360]"
>>> media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x360 ]"
>>> media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/640x360 ]"
>>> media-ctl --get-v4l2 "'ipu1_csi0':0"
>>>                   [fmt:UYVY8_1X16/1280x720@1/30 field:none
>>> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range
>>>                    crop.bounds:(0,0)/1280x720
>>>                    crop:(0,0)/1280x720
>>>                    compose.bounds:(0,0)/1280x720
>>>                    compose:(0,0)/640x360]
>>> media-ctl --get-v4l2 "'ipu1_csi0':1"
>>>                   [fmt:UYVY8_1X16/640x360@1/30 field:none
>>> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
>>> media-ctl --get-v4l2 "'ipu1_ic_prp':1"
>>>                   [fmt:AYUV8_1X32/640x480@1/30 field:none
>> Ah, ipu1_ic_prp:1 pad is 640x480, it looks like you missed setting
>> ipu1_csi0:1 pad format, so that ipu1_ic_prp pads are still set to
>> default formats.
> but I do set it above: media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x360 ]
>
> here's a sequence of set/get:
> root@imx6q-gw5404:~# media-ctl --set-v4l2 "'tda19971 2-0048':0
> [fmt:UYVY8_1X16/1280x720 field:none]"
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'tda19971 2-0048':0"
>                  [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
> root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_csi0_mux':2
> [fmt:UYVY8_1X16/1280x720 field:none]"
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0_mux':2"
>                  [fmt:UYVY8_1X16/1280x720 field:none colorspace:rec709]
> root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_csi0':0 [fmt:AYUV32/640x360]"
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0':0"
>                  [fmt:UYVY8_2X8/640x360@1/30 field:none
> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range
>                   crop.bounds:(0,0)/640x360
>                   crop:(0,0)/640x360
>                   compose.bounds:(0,0)/640x360
>                   compose:(0,0)/640x360]
> ^^^ the compose setting defaults so I really don't think the next cmd
> does anything
> root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_csi0':0
> [compose:(0,0)/640x360]"
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0':0"
>                  [fmt:UYVY8_2X8/640x360@1/30 field:none
> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range
>                   crop.bounds:(0,0)/640x360
>                   crop:(0,0)/640x360
>                   compose.bounds:(0,0)/640x360
>                   compose:(0,0)/640x360]
> ^^^ see, same as above (but I like adding the compose to pipeline
> configuration instructions for documentation purposes; makes it
> obvious they can select the window)
> root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_ic_prp':1 [fmt:AYUV32/640x360]"
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prp':1"
>                  [fmt:AYUV8_1X32/1280x720@1/30 field:none
> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
> ^^^ but yes, this one isn't getting set properly to 640x360... and it
> looks like its at the input:
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prp':0"
>                  [fmt:AYUV8_1X32/1280x720@1/30 field:none
> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]

No no -- the ipu_ic_prp entity cannot scale, the ipu_ic_prpenc and 
ipu_ic_prpvf scale. Think of ipu_ic_prp as a mux, taking input from 
either CSI0, CSI1, or the VDIC. It can then route that data to PRPENC, 
PRPVF, or both simultaneously.


>
> my understanding is if I set it on the output pad it will propagate
> back to the input pad. I'm also wondering why I don't get an error if
> it doesn't change.

Nope, the other way around. The subdev drivers propagate formats from 
their sink pads to their source pads. And you can rely on media-ctl to 
propagate formats from a subdev's source pad to the next linked subdev's 
sink pad.

In other words, media-ctl does inter-entity format propagation 
(source->sink), and the kernel media driver does intra-entity 
propagation (sink->source).

>
> If I setup the input pad manually and continue on:
> root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_ic_prp':0 [fmt:AYUV32/640x360]"
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prp':0"
>                  [fmt:AYUV8_1X32/640x360@1/30 field:none
> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prp':1"
>                  [fmt:AYUV8_1X32/640x360@1/30 field:none
> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
> root@imx6q-gw5404:~# media-ctl --set-v4l2 "'ipu1_ic_prpenc':1
> [fmt:AYUV32/640x360]"
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prpenc':1"
>                  [fmt:AYUV8_1X32/640x360@1001/30000 field:none
> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
> root@imx6q-gw5404:~# v4l2-ctl --device /dev/video0 --stream-mmap
> --stream-to=x.raw --stream-count=1
> [ 4695.356802] ipu1_ic_prpenc: pipeline start failed with -32
> ^^^ still fails

Again ipu1_ic_prp can't scale. You need to set 640x360 at the 
ipu1_ic_prpenc:1 pad.

>
> If I can get pipelines that go through the IC working with UYVY8_1X16
> then I will use that for the bus format and ditch the UYVY8_2X16 bt656
> which has the limitations of not supporting 1080p60 (not to mention
> the fact that anything other than SD resolutions are out of the bt656
> as discussed), interlaced formats.
>
> <snip>
>>> What I was asking here is what is the correct way to configure for
>>> ITU601 to REC709 CSC at the CSI?  I would expect to set the REC709
>>> format on the output pad of the CSI but it seems to require me to set
>>> it on the input pad.
>> Right, the driver only allows setting colorimetry at the sink pads, and
>> propagates them to the source pads. So you'll need to set colorimetry
>> params at the CSI sink pad.
> oh gosh... I think I had that backwards!

Yep :)

I admit and agree a lot of this is pretty cryptic :-/

But it does actually make sense that imx-media subdevs don't allow 
different colorspace parameters between their sink and source pads, 
because they _cannot_ modify colorspace. There's no support for say, 
transcoding the YCbCr encoding from BT.601 at a sink to BT.709 at the 
source, or quantization, or any of the other colorimetry parameters.

So it is correct behavior to accept userspace-requested colorspace 
params at the sink pad, and force/propagate the colospace params from 
sink pad to source pad.

So what this all means is that, the easiest way to set colorspace all 
throughout the pipeline, is to set it at the external sensor source pad 
(the tda19971 in your case). Media-ctl will then take care to propagate 
that colorimetry to the sink pad of the next linked subdevice, and 
imx-media will take care to propagate colorimetry inside each subdevice 
from sink to source.

>
>>> Consider:
>>> # imx6q-gw54xx tda19971 720p60 16-bit RGB sensor->mux->csi
>>> # set sensor output pad to sensor source format
>>> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
>>> # sensor format
>>> media-ctl --get-v4l2 '"tda19971 2-0048":0'
>>>                    [fmt:UYVY8_1X16/1280x720 field:none colorspace:srgb]
>>> # reset all links
>>> media-ctl --reset
>>> # setup links
>>> media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
>>> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>>> media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
>>> # configure pads
>>> media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/1280x720 field:none]"
>>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/1280x720 field:none]"
>>> media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/1280x720]"
>>> media-ctl --get-v4l2 '"ipu1_csi0":2'
>>>                   [fmt:UYVY8_1X16/1280x720@1/30 field:none
>>> colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range]
>>> ^^^ ITU601, but I want REC709
>>> media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/1280x720 colorspace:rec709 ycbcr:709]"
>>> media-ctl --get-v4l2 '"ipu1_csi0":2'
>>>                  [fmt:UYVY8_1X16/1280x720@1/30 field:none
> So the above was wrong as I was trying to set it on the CSI 'output'
> pad not its 'input'. Is there no error reporting all the way back to
> let the user know this was an invalid choice?

Nope :-/

>
>>> colorspace:srgb xfer:srgb ycbcr:601 quantization:lim-range]
>>> ^^^ No invalid argument but its still ITU601 at CSI output... but what
>>> I've found is if I set it at the CSI input the ycbcr changes but the
>>> fmt gets jacked up (as expected)
>>> media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/1280x720 colorspace:rec709 ycbcr:709]"
>>>                   [fmt:UYVY8_2X8/1280x720@1/30 field:none
>>> colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range]
>>> ^^^ note we are now rec709 but fmt is UYVY8_2X8 because the CSI
>>> doesn't accept UYVY8_1X16 so it deafults to UYVY8_2X8.
>> Why doesn't the CSI accept UYVY8_1X16 at its sink pad?
>>
>> This doesn't work?:
>>
>> media-ctl -V "'ipu1_csi0':0 [fmt:UYVY8_1X16/1280x720 colorspace:rec709 ycbcr:709]"
>>
> that works!
>
> I was trying to set AYUV32 at its input pad which it doesn't support.

Right.

Keep in mind also, that the i.MX IPU internally handles only ARGB32 or 
AYUV32 on an internal 32-bit bus. So the IPU internal pads (ipu_csi:1, 
ipu_csi:2, and all pads of ipu_vdic, ipu_prp, ipu_prpenc, and ipu_prpvf) 
only accept media bus codes ARGB8888_1X32 or AYUV8_1X32.

But ipu_csi:0 is a pad external to the IPU, so it accepts other media 
bus codes like UYVY8_1X16.

For example, say you want to setup a pipeline that converts pixels from 
a sensor that sends RGB565_2X8_LE, to YUV space. So you would need 
ipu_prpenc or ipu_prpvf to carry out RGB->YUV CSC. At the ipu_prpencvf:1 
source pad, you must set the mbus code to AYUV8_1X32. The IDMAC can then 
carry out pixel reordering _within YUV space_, to produce many of the 
other YUV pixel formats like YUYV, YV12, 422P, etc. The IDMAC format is 
set at the capture interface with 'v4l2-ctl -dN 
--set-fmt-video=pixelformat=..."

Here is such an example on the SabreSD with the OV5640, which is 
transmitting RGB565_2X8_LE and BT.709 YCbCr encoded, and ipu1_ic_prpenc 
color converts that to AYUV8_1X32, and finally at the capture interface 
/dev/video0, the format is set to YV12 (in fact, this is the pipeline I 
used to test the new BT.709 encoding matrix):

'ov5640 1-003c':0
         [fmt:RGB565_2X8_LE/1024x768@1/30 field:none colorspace:srgb 
xfer:srgb ycbcr:709 quantization:full-range]

'imx6-mipi-csi2':0
         [fmt:RGB565_2X8_LE/1024x768 field:none colorspace:srgb 
xfer:srgb ycbcr:709 quantization:full-range]

'imx6-mipi-csi2':2
         [fmt:RGB565_2X8_LE/1024x768 field:none colorspace:srgb 
xfer:srgb ycbcr:709 quantization:full-range]

'ipu1_csi1':0
         [fmt:RGB565_2X8_LE/1024x768@1/30 field:none colorspace:srgb 
xfer:srgb ycbcr:709 quantization:full-range
          crop.bounds:(0,0)/1024x768
          crop:(0,0)/1024x768
          compose.bounds:(0,0)/1024x768
          compose:(0,0)/1024x768]

'ipu1_csi1':1
         [fmt:ARGB8888_1X32/1024x768@1/30 field:none colorspace:srgb 
xfer:srgb ycbcr:709 quantization:full-range]

'ipu1_ic_prp':0
         [fmt:ARGB8888_1X32/1024x768@1/30 field:none colorspace:srgb 
xfer:srgb ycbcr:709 quantization:full-range]

'ipu1_ic_prp':1
         [fmt:ARGB8888_1X32/1024x768@1/30 field:none colorspace:srgb 
xfer:srgb ycbcr:709 quantization:full-range]

'ipu1_ic_prpenc':0
         [fmt:ARGB8888_1X32/1024x768@1/30 field:none colorspace:srgb 
xfer:srgb ycbcr:709 quantization:full-range]

'ipu1_ic_prpenc':1
         [fmt:AYUV8_1X32/800x600@1/30 field:none colorspace:srgb 
xfer:srgb ycbcr:709 quantization:full-range]

/dev/video0:0
Format Video Capture:
     Width/Height      : 800/600
     Pixel Format      : 'YV12'
     Field             : None
     Bytes per Line    : 800
     Size Image        : 720000
     Colorspace        : sRGB
     Transfer Function : sRGB
     YCbCr/HSV Encoding: Rec. 709
     Quantization      : Full Range
     Flags             : 30ad6792



>
> Again, do you know why errors don't propagate back to media-ctl? Most
> of my difficulties have been not realizing what was valid and
> understanding that I have to read back the format after I set it to
> determine failures.

Yeah, like most media drivers, imx-media will force parameters to 
something supported when userland asks for something unsupported, 
without letting the user know that happened. I agree it can be difficult.

Steve

