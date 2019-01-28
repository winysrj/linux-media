Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4236C282CD
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 23:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA9222171F
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 23:04:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gy1I5nRe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfA1XE1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 18:04:27 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35669 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfA1XE0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 18:04:26 -0500
Received: by mail-wr1-f67.google.com with SMTP id 96so20039499wrb.2
        for <linux-media@vger.kernel.org>; Mon, 28 Jan 2019 15:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=06ZxMgzFCCpR4iRnAv3GTMbc3tJtihVCo82+HT+D06w=;
        b=Gy1I5nRe/4Fr/0wJnGBTbkjQxDTVYXk51ezl7mvSchXiiCD8Qa+NR5wZ17e9WKdfn9
         SKBq9/kvxkS/TVIOoa7l3NJseXb7MdwSX6yJDRJxXXhoAP8KMMwwC5QNZ039TiN2wjqG
         Lb+8ZAsiyXFJz7jMAnZlPkWAjFgeK0JuWMIa11eJtQsmW16mEHBFqfcE04QwMFW9RRvs
         9q3P1pRV1QQsM/2jEp/CBStgFBseJFr1imvm9l1kOBpAEauvVR9Tvl8I/nNVLfYMbs4Q
         raaGTQrr/d9FrnQlLZWji1WzxNjgWAK2PI+YULsZcKkevYM3iocyo9Sx0n9kR1tNMRZT
         l3KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=06ZxMgzFCCpR4iRnAv3GTMbc3tJtihVCo82+HT+D06w=;
        b=GtZvMQUT6oxWWSUYpEtv04BlHlQdX81suDXQguoa67dR5PeuTULEyVHoDlLDo7UwhN
         kPTqfiNcFGsIIVzTOYjzW20EcTxj3T5Zps6ZJxD8iJROocRKR0e+7URuUwH+IDR4kLxI
         xFf0vK3ValGUnViQqfEp3vXQtG72rRL5CKOoI5ibdKIUzV0LbwPj9Uzg/QnJyIpmt1x7
         69jAYKmmrInlN9OMkmFYCc3L+u9839iGMMa2pF8uBTq6Nj4nHLmw+25MW70EmWYOn0c7
         Nc7aJRaYzSUGfTTvuH53K0a1BL+OWsceGlNwTf9yxUuN3HH0VckY6Ooo3X6TGD1QmUZp
         swbw==
X-Gm-Message-State: AJcUukeYv1XkJXxppxP5iY2O3rUK0l3QHY7KqXxH+fVT4+kdu9CeCB3c
        F2M6BgRRpo/T13zEJ0E/ti3JoHWk
X-Google-Smtp-Source: ALg8bN4bDF1db03qwejLXUdw48+/sXgPpxd4jQmKP9fBryANAbd2tgsX8iuEyKrvXv9DabBplh1ZNw==
X-Received: by 2002:adf:97d1:: with SMTP id t17mr23660501wrb.283.1548716663214;
        Mon, 28 Jan 2019 15:04:23 -0800 (PST)
Received: from [172.30.88.177] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id o81sm1409864wmd.10.2019.01.28.15.04.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jan 2019 15:04:22 -0800 (PST)
Subject: Re: IMX CSI capture issues with tda1997x HDMI receiver
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
References: <CAJ+vNU0ic=wzSC9V4hbmarN0JeQMs121MzD6tH5KQ+ezENUNfA@mail.gmail.com>
 <02e8680c-9fd5-ff54-f292-f6936c76583e@gmail.com>
 <CAJ+vNU0YQeiPaE8tapJnihoj3DtewCPTj05BZv5cJ65YkE9MeQ@mail.gmail.com>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <db70e0f7-0ad4-62f5-e64c-49c04c089dd6@gmail.com>
Date:   Mon, 28 Jan 2019 15:04:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU0YQeiPaE8tapJnihoj3DtewCPTj05BZv5cJ65YkE9MeQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 1/28/19 11:03 AM, Tim Harvey wrote:
> On Fri, Jan 25, 2019 at 3:57 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>> Hi Tim, cc: Philipp,
>>
>> On 1/23/19 3:21 PM, Tim Harvey wrote:
>>> Steve,
>>>
>>> I'm testing IMX6 capture again with the tda1997x HDMI receiver found
>>> on Gateworks GW54xx and GW551x boards. This is hooked up to the IMX6
>>> CSI in a way where it can be configured for 8bit BT656 mode
>>> (UYVY8_2X8) or 16bit YUV mode (UYVY8_1X16). Also I have a Marshall
>>> Electronics V-SG4K-HDI HDMI signal generator here so I can test a wide
>>> variety of resolutions, bus formats, interlaced modes, and
>>> colorspaces.
>>>
>>> I'm using the following for testing:
>>> - Linux 4.20 +
>>>     - media: imx-csi: Input connections to CSI should be optional
>>>     - imx-media: Fixes for interlaced capture
>>>     - media: imx: Stop stream before disabling IDMA channels
>>> - v4l-utils 1.16.1
>>> - gstreamer-1.14.1 (with the ability to test master as well)
>>>
>>> I have a script that generates the media-ctl/v4l2-ctl commands based
>>> on providing a sensor ('adv7180' analog decoder or 'tda1997x' HDMI
>>> decoder) and a 'mode' which I've defined as:
>>> mode0: sensor -> mux -> csi -> /dev/videoN
>>> mode1: sensor -> mux -> csi -> ic_prp -> ic_prpenc -> /dev/videoN (provides a
>>> mode2: sensor -> mux -> csi -> ic_prp -> ic_prpvf -> /dev/videoN
>>> mode3: sensor -> mux -> csi -> vdic -> ic_prp -> ic_prpvf -> /dev/videoN
>>>
>>> The media-ctl topologies for each cpu/board combo are at
>>> http://dev.gateworks.com/docs/linux/media/
>>>
>>> I'm trying to test out simple v4l2-ctl based capture of a single frame
>>> as well as capture and stream via both software JPEG encode and H264
>>> hardware encode via CODA.
>>>
>>> Please let me know of any changes that should be made to the commands
>>> below even if only to purely help document things through clarity.
>>>
>>> One of the issues I run into right away is image size: The imx.rst
>>> docs state that the ic has a 'resize' limit of 1024x1024 but I think
>>> I'm mislead by the word 'resize' and this also means you can't push
>>> say 1080x720 through it (not resizing, just putting that on the src
>>> pad) as it clips it to 1024x720.
>> The IC is limited to a resized *output* frame of 1024x1024, no higher.
>>
> Ok so this means for anything >1024 I need to either use the csi to
> downscale it by factors of 2 first, or use mem2mem solution which
> means I can't use the VDIC (so no interlaced).

Actually that isn't true. You can still use a VDIC pipeline for the 
1280x720 interlaced tda19971 source. It's just that you would need to 
downscale to <=1024 (either using the CSI /2, and/or using the IC prpvf 
scaler). Then use the mem2mem gstreamer element to upscale the prpvf 
capture output to something >1024.


>   I will try your patch
> that adds registration of the mem2mem driver to the media-ctl api.

Ok. That patch doesn't have anything functional to it, but it's nice to 
see the mem2mem device as part of the media graph.

>
>>>    I believe some of Phillip's pending
>>> patches may be aimed at rectifying this limitation?
>> If you mean the mem2mem driver, yes. The mem2mem driver makes use the
>> ipu-image-convert APIs which includes tiled resizing, so it will support
>> greater-than 1024x1024 output frames. Latest status I've heard is that
>> there is some misunderstanding of the behavior of rotation, that will
>> require some rework of the mem2mem driver and ipu-image-convert (and
>> sigh, the ic-prpencvf sub-device which also supports h/w rotation).
>>
>> But you could actually grab the last posted version of mem2mem driver
>> (v7). It works fine except for the rotation misunderstanding (but even
>> that works but doesn't conform to v4l2 expected behavior). You will then
>> have a gstreamer element v4l2convertN for >1024 resizing support.
>>
> Ok, so I've applied that to my kernel and now have a new /dev/video*
> device for ipu_ic_pp. I'll start testing with it.

Cool.

>
>> Also recently merged from Philipp is the work to relax capture width
>> alignment, by DMA'ing to padded frames. But that is not related to mem2mem.
>>
> Ok - I'll merge this one too so I'm testing with it.

Ok.

>
>>> Another issue I'm running into is colorspace conversion, specifically
>>> colorimetry
>>>
>>> Example: imx6q-gw54xx tda19971 720p60Hz YUV via BT656 IPU1_CSI0
>>> MODE1:sensor->mux->csi->ic_prp->ic_prpenc
>>> # set sensor output pad to sensor source format
>>> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
>>> # sensor format
>>> media-ctl --get-v4l2 '"tda19971 2-0048":0' # fmt:UYVY8_2X8/1280x720
>>> field:none colorspace:rec709
>>> # reset all links
>>> media-ctl --reset
>>> # setup links
>>> media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
>>> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>>> media-ctl -l "'ipu1_csi0':1 -> 'ipu1_ic_prp':0[1]"
>>> media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
>>> media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
>>> # configure pads
>>> media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_2X8/1280x720 field:none]"
>>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_2X8/1280x720 field:none]"
>>> media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/1280x720]"
>>> media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/1280x720]"
>>> media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/1280x720]"
>>> # capture device
>>> media-ctl -e 'ipu1_ic_prpenc capture' # /dev/video0
>>> v4l2-ctl --device /dev/video0 --get-fmt-video
>>> Format Video Capture:
>>>           Width/Height      : 1024/720
>>>           Pixel Format      : 'UYVY' (UYVY 4:2:2)
>>>           Field             : None
>>>           Bytes per Line    : 2048
>>>           Size Image        : 1474560
>>>           Colorspace        : Rec. 709
>>>           Transfer Function : Rec. 709
>>>           YCbCr/HSV Encoding: ITU-R 601
>>>           Quantization      : Limited Range
>>>           Flags             :
>>> ^^^ Note 1080x720 has been reduced to 1024x720 - ouch!
>> Yes as discussed above that is correct behavior, you'll need mem2mem
>> device to support >1024 tiled scaling.
>>
>>> # capture 1 frame
>>> v4l2-ctl --device /dev/video0 --stream-mmap --stream-to=x.raw --stream-count=1
>>> ^^^ works
>>> # stream JPEG/RTP/UDP
>>> gst-launch-1.0 v4l2src device=/dev/video0 ! \
>>>     video/x-raw,format=UYVY ! \
>>>     jpegenc ! rtpjpegpay ! udpsink host=172.24.20.19 port=5000
>>> ^^^ works (but of course squashed horizontally because of x=1024)
>>> # stream H264/RTP/UDP (via coda)
>>> # need to make sure we feed coda NV12/rec709
>>> media-ctl --get-v4l2 '"ipu1_ic_prpenc":0' #
>>> fmt:AYUV8_1X32/1280x720@1/25 field:none colorspace:rec709 xfer:709
>>> ycbcr:601 quantization:lim-range
>>> ^^^ input colorspace is rec709 but colorimetry needs to be changed to 709
>>> media-ctl --set-v4l2 '"ipu1_ic_prpenc":0[fmt:AYUV32/1280x720
>>> colorspace:rec709 ycbcr:709]'
>>> ^^^ no error but doing a get-v4l2 shows no change - is this all
>>> because of trying to deal with 1080 instead of 1024?
>> No. The Image Converter can only Y`CbCr encode to ITU-R 601
>> (V4L2_YCBCR_ENC_601). So the driver won't accept Rec. 709 Y`CbCr
>> encoding when using an IC pipeline.
>>
>> See imx_media_fill_default_mbus_fields().
>>
>>> gst-launch-1.0 v4l2src device=/dev/video0 ! \
>>>     v4l2h264enc output-io-mode=dmabuf-import ! \
>>>     rtph264pay ! udpsink host=172.24.20.19 port=5001
>>> v4l2src0: Device '/dev/video0' does not support 2:0:0:0 colorimetry
>>> ^^^ fails because of colorimetry not getting set
>> Right, that is correct behavior also. See above.
>>
>> Philipp, can the coda driver accept V4L2_YCBCR_ENC_601 colorspace?
>>
> I will have to go back and look what the old downstream Freescale
> kernel drivers did here... I could swear I could easily de-interlace
> via VDIC and encode 1080i with that and gstreamer-imx.
>
>>> <snip>
>>>
>>> Let's try an interlaced format...
>>>
>>> Example: imx6q-gw54xx tda19971 480i60Hz YUV via BT656 IPU1_CSI0
>>> MODE1:sensor->mux->csi->ic_prp->ic_prpenc
>>> # set sensor output pad to sensor source format
>>> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
>>> # sensor format
>>> media-ctl --get-v4l2 '"tda19971 2-0048":0' # fmt:UYVY8_2X8/720x480
>>> field:seq-tb colorspace:rec709
>>> # reset all links
>>> media-ctl --reset
>>> # setup links
>>> media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
>>> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>>> media-ctl -l "'ipu1_csi0':1 -> 'ipu1_vdic':0[1]"
>>> media-ctl -l "'ipu1_vdic':2 -> 'ipu1_ic_prp':0[1]"
>>> media-ctl -l "'ipu1_ic_prp':2 -> 'ipu1_ic_prpvf':0[1]"
>>> media-ctl -l "'ipu1_ic_prpvf':1 -> 'ipu1_ic_prpvf capture':0[1]"
>>> # configure pads
>>> media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_2X8/720x480 field:seq-tb]"
>>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_2X8/720x480 field:seq-tb]"
>>> media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/720x480]"
>>> media-ctl -V "'ipu1_vdic':2 [fmt:AYUV32/720x480]"
>>> media-ctl -V "'ipu1_ic_prp':2 [fmt:AYUV32/720x480]"
>>> media-ctl -V "'ipu1_ic_prpvf':1 [fmt:AYUV32/720x480]"
>>> # capture device
>>> media-ctl -e 'ipu1_ic_prpvf capture' # /dev/video1
>>> v4l2-ctl --device /dev/video1 --get-fmt-video
>>> Format Video Capture:
>>>           Width/Height      : 720/480
>>>           Pixel Format      : 'UYVY' (UYVY 4:2:2)
>>>           Field             : None
>>>           Bytes per Line    : 1440
>>>           Size Image        : 691200
>>>           Colorspace        : Rec. 709
>>>           Transfer Function : Rec. 709
>>>           YCbCr/HSV Encoding: ITU-R 601
>>>           Quantization      : Limited Range
>>>           Flags             :
>>> # capture 1 frame
>>> v4l2-ctl --device /dev/video1 --stream-mmap --stream-to=x.raw --stream-count=1
>>> ^^^ fails with ipu1_ic_prpvf: EOF timeout
>>> ^^^ this is almost identical to the adv7180 case which works... the
>>> only exception I see is field:seq-tb vs field:alternate from the
>>> source which should be fine (more specific than 'alternate')
>> Hmm, can you send the complete pad formats from --get-v4l2. I don't see
>> anything obviously wrong here.
>>
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'tda19971 2-0048':0"
>                  [fmt:UYVY8_2X8/720x480 field:seq-tb colorspace:rec709]
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0_mux':2"
>                  [fmt:UYVY8_2X8/720x480 field:seq-tb colorspace:rec709]
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0':1"
>                  [fmt:AYUV8_1X32/720x480@1/30 field:seq-tb
> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_vdic':2"
>                  [fmt:AYUV8_1X32/720x480@1/60 field:none
> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prp':2"
>                  [fmt:AYUV8_1X32/720x480@1/30 field:none
> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_ic_prpvf':1"
>                  [fmt:AYUV8_1X32/720x480@1/30 field:none
> colorspace:rec709 xfer:709 ycbcr:601 quantization:lim-range]
>
> root@imx6q-gw5404:~# v4l2-ctl --device /dev/video1 --get-fmt-video
> Format Video Capture:
>          Width/Height      : 720/480
>          Pixel Format      : 'UYVY' (UYVY 4:2:2)
>          Field             : None
>          Bytes per Line    : 1440
>          Size Image        : 691200
>          Colorspace        : Rec. 709
>          Transfer Function : Rec. 709
>          YCbCr/HSV Encoding: ITU-R 601
>          Quantization      : Limited Range
>          Flags             :
>
> root@imx6q-gw5404:~# v4l2-ctl --device /dev/video1 --stream-mmap
> --stream-to=x.raw --stream-count=1
> [  159.828654] ipu1_ic_prpvf: EOF timeout
> VIDIOC_DQBUF: failed: Input/output error

Sorry everything looks fine, I don't know why that pipeline is failing 
to generate any data.

>
>>> Now lets go back to a 480p60 source but this time include the vdic
>>> (which isn't necessary but should still work right?)
>> No. First, the CSI will only capture in bt.656 mode if it sees
>> interlaced fields (bt.656 interlaced sync codes). Well, let me rephrase,
>> the CSI does support progressive BT.656 but I have never tested that myself.
>>
>> But more importantly, the VDIC must be given interlaced fields at its input.
>>
> ok, I understand now that VDIC can only accept interlaced fields, so
> progressive should skip the VDIC.
>
>>> Example: imx6q-gw54xx tda19971 480p60Hz YUV via BT656 IPU1_CSI0
>>> MODE1:sensor->mux->csi->vdic->ic_prp->ic_prpvf
>>> # set sensor output pad to sensor source format
>>> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
>>> # sensor format
>>> media-ctl --get-v4l2 '"tda19971 2-0048":0' # fmt:UYVY8_2X8/720x480
>>> field:none colorspace:rec709
>>> # reset all links
>>> media-ctl --reset
>>> # setup links
>>> media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
>>> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>>> media-ctl -l "'ipu1_csi0':1 -> 'ipu1_vdic':0[1]"
>>> media-ctl -l "'ipu1_vdic':2 -> 'ipu1_ic_prp':0[1]"
>>> media-ctl -l "'ipu1_ic_prp':2 -> 'ipu1_ic_prpvf':0[1]"
>>> media-ctl -l "'ipu1_ic_prpvf':1 -> 'ipu1_ic_prpvf capture':0[1]"
>>> # configure pads
>>> media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_2X8/720x480 field:none]"
>>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_2X8/720x480 field:none]"
>>> media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/720x480]"
>>> media-ctl -V "'ipu1_vdic':2 [fmt:AYUV32/720x480]"
>>> media-ctl -V "'ipu1_ic_prp':2 [fmt:AYUV32/720x480]"
>>> media-ctl -V "'ipu1_ic_prpvf':1 [fmt:AYUV32/720x480]"
>>> # capture device
>>> media-ctl -e 'ipu1_ic_prpvf capture' # /dev/video1
>>> v4l2-ctl --device /dev/video1 --get-fmt-video
>>> Format Video Capture:
>>>           Width/Height      : 720/480
>>>           Pixel Format      : 'UYVY' (UYVY 4:2:2)
>>>           Field             : None
>>>           Bytes per Line    : 1440
>>>           Size Image        : 691200
>>>           Colorspace        : Rec. 709
>>>           Transfer Function : Rec. 709
>>>           YCbCr/HSV Encoding: ITU-R 601
>>>           Quantization      : Limited Range
>>>           Flags             :
>>> # capture 1 frame
>>> v4l2-ctl --device /dev/video1 --stream-mmap --stream-to=x.raw --stream-count=1
>>> ipu1_ic_prpvf: pipeline start failed with -32
>>> ^^^ maybe because we are feeding progressive to vdic? vdic isn't
>>> needed here but it seems it should not fail to me
>> this is a pipeline src->sink mismatch error, because the VDIC enforces
>> fields at its input pad.
> right... as you said above vdic requires interlaced fields so
> progressive must skip the vdic.
>
>>> ok now I'm going to boot with a different device-tree that connects
>>> the tda1997x to IMX6 via 16bit YUV. Advantages of this mode should be
>>> 1) better pixel bpp 2) colorimetry is rec709 so no conversion needed
>>> for coda 3) ability to capture 1080p60 as I have confirmed tyring to
>>> do so via bt656 exceeds the IMX pixel clock rate and causes CSI
>>> corruption. Downsides to this mode is that I currently have a bug in
>>> the tda1997x driver regarding this mode and interlaced capture.
>>>
>>> Example: imx6q-gw54xx tda19971 480p60Hz YUV via 16bit YUV IPU1_CSI0
>>> MODE0:sensor->mux->csi
>>> # set sensor output pad to sensor source format
>>> v4l2-ctl -d /dev/v4l-subdev15 --set-dv-bt-timings=query
>>> # sensor format
>>> media-ctl --get-v4l2 '"tda19971 2-0048":0' # fmt:UYVY8_1X16/720x480
>>> field:none colorspace:rec709
>>> # reset all links
>>> media-ctl --reset
>>> # setup links
>>> media-ctl -l "'tda19971 2-0048':0 -> 'ipu1_csi0_mux':1[1]"
>>> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>>> media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
>>> # configure pads
>>> media-ctl -V "'tda19971 2-0048':0 [fmt:UYVY8_1X16/720x480 field:none]"
>>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY8_1X16/720x480 field:none]"
>>> media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
>>> media-ctl --get-v4l2 '"ipu1_csi0":2'
>>>                   [fmt:UYVY8_1X16/720x480@1/30 field:none
>> This is passthrough, the CSI can only pass through input pixel data
>> unmodified as "generic" data, when the input bus is 16-bit parallel,
>> which it is in this case (UYVY8_1X16). So the pixel code at the CSI
>> output pad is forced to same as input pad (UYVY8_1X16).
>>
>> But aside from passthrough, that shouldn't be a problem...
>>
>>> colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range]
>>> # capture device
>>> media-ctl -e 'ipu1_csi0 capture' # /dev/video4
>>> v4l2-ctl --device /dev/video4 --get-fmt-video
>>> Format Video Capture:
>>>           Width/Height      : 720/480
>>>           Pixel Format      : 'UYVY' (UYVY 4:2:2)
>>>           Field             : None
>>>           Bytes per Line    : 1440
>>>           Size Image        : 691200
>>>           Colorspace        : Rec. 709
>>>           Transfer Function : Rec. 709
>>>           YCbCr/HSV Encoding: Rec. 709
>>>           Quantization      : Limited Range
>>>           Flags             : premultiplied-alpha
>>> # capture 1 frame
>>> v4l2-ctl --device /dev/video4 --stream-mmap --stream-to=x.raw --stream-count=1
>>> convert -size 720x480 -depth 16 uyvy:x.raw /var/www/html/files/frame.png
>> So capture of 1 frame worked fine?
> yes this worked fine
>
>>> # stream JPEG/RTP/UDP
>>> gst-launch-1.0 v4l2src device=/dev/video4 ! \
>>>     video/x-raw,format=UYVY ! \
>>>     jpegenc ! rtpjpegpay ! udpsink host=172.24.20.19 port=5000
>> and this worked?
> yes this worked fine
>
>>> # stream H264/RTP/UDP
>>> media-ctl --get-v4l2 '"ipu1_csi0":0'
>>>                   [fmt:UYVY8_1X16/720x480@1/30 field:none
>>> colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range
>>>                    crop.bounds:(0,0)/720x480
>>>                    crop:(0,0)/720x480
>>>                    compose.bounds:(0,0)/720x480
>>>                    compose:(0,0)/720x480]
>>> ^^^ no conv needed
>>> media-ctl --get-v4l2 '"ipu1_csi0":0'
>> huh?
> typo'd here and cut-and-pasted another occurrence of the media-ctl
> --get-v4l2 command but my point here is that we have the correct
> colorspace/colorimetry for coda so the H264 below should work fine
>
>>> gst-launch-1.0 v4l2src device=/dev/video4 ! \
>>>     v4l2h264enc output-io-mode=dmabuf-import ! \
>>>     rtph264pay ! udpsink host=172.24.20.19 port=5001
>>> v4l2src0: Internal data stream error.
>> Sorry, I don't have enough info to help here.
>>
> Here's the pad details:
>
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'tda19971 2-0048':0"
>                  [fmt:UYVY8_1X16/720x480 field:none colorspace:rec709]
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0_mux':2"
>                  [fmt:UYVY8_1X16/720x480 field:none colorspace:rec709]
> root@imx6q-gw5404:~# media-ctl --get-v4l2 "'ipu1_csi0':2"
>                  [fmt:UYVY8_1X16/720x480@1/30 field:none
> colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range]
>
> root@imx6q-gw5404:~# v4l2-ctl --device /dev/video4 --get-fmt-video
> Format Video Capture:
>          Width/Height      : 720/480
>          Pixel Format      : 'UYVY' (UYVY 4:2:2)
>          Field             : None
>          Bytes per Line    : 1440
>          Size Image        : 691200
>          Colorspace        : Rec. 709
>          Transfer Function : Rec. 709
>          YCbCr/HSV Encoding: Rec. 709
>          Quantization      : Limited Range
>          Flags             :
>
> So in this passthrough case v4l2-ctl stream capture works, gstreamer
> capture with sw jpeg encode works, but gstreamer capture with h264
> encode fails:
>
> root@imx6q-gw5404:~# gst-launch-1.0 v4l2src device=/dev/video4 ! \
>>     v4l2h264enc output-io-mode=dmabuf-import ! \
>>     rtph264pay ! udpsink host=172.24.20.19 port=5001
> Setting pipeline to PAUSED ...
> Pipeline is live and does not need PREROLL ...
> Setting pipeline to PLAYING ...
> ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> Internal data stream error.
> Additional debug info:
> gstbasesrc.c(3055): gst_base_src_loop ():
> /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> streaming stopped, reason not-negotiated (-4)
> Execution ended after 0:00:00.000416672
> Setting pipeline to PAUSED ...
> Setting pipeline to READY ...
> Setting pipeline to NULL ...
> Freeing pipeline ...
>
> It would appear that this must have something to do with gstreamer.
> The only difference here between this case and the adv7180 is that
> field=none and colorimetry is itu601... I'm guessing the field=none is
> causing an issue. I'll post a question to gstreamer-devel.

Ok. Given that v4l2-ctl stream capture works, gstreamer capture with sw 
jpeg encode works, but gstreamer capture with h264does not, this does 
sound like some issue with gstreamer.

Steve
