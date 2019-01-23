Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC3F8C282C4
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 00:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A54E1217D6
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 00:25:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C2Nlw01A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfAWAZG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 19:25:06 -0500
Received: from mail-oi1-f178.google.com ([209.85.167.178]:42424 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfAWAZG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 19:25:06 -0500
Received: by mail-oi1-f178.google.com with SMTP id w13so361823oiw.9;
        Tue, 22 Jan 2019 16:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=jF3hvu1XyXZfCkM+T8C/6VezkiI5QFXUA1Lnm263OkM=;
        b=C2Nlw01Asq9dHp4h3e1VaucsvAbgLLGCM1xTNW+hJe8lrZM8D3iH0aFakXlh17eXBJ
         ZGACJvIXKJz8d3pqW7BLbCVAlozPTLoRvLbJozntxM5qJh2ygnmsJQu/70TAYj/mdbN8
         /cw/YtzCvPwqMQmxAEAVXzi0hq7Yh/1GB+IjJU+eBmj6XDxkopy+efEMobBZFjSQ2vlU
         KKC7Dr4/1wWN8jbGu+iX5M2SPRnhKUl00mnic4RciyaxsOLXb3TNi8MqPzUsuqUSXFri
         PJnEnygS5gUGvfhl3wxLHejZUZ0xpYqvh7J/UQocE4Q/gsXIBgH2sixjyXZ4WIdDzP35
         kPgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jF3hvu1XyXZfCkM+T8C/6VezkiI5QFXUA1Lnm263OkM=;
        b=FHvABl/w2V+IWiGoVCBbXBCUPcfE5+624Ny2QZsQgrv5Iy80LozfbGpnpp4Nly0Jzk
         /lGymP/O0MbeSymlGbVihQcVDu8cW1Y297i9QUZEKUOG1FkBZ7vrAteDxVBGYWgoqQhK
         jqZoQtvS3ym/mYiPvd0fadBNpK9PUNch6SgCBzsBDgDqJ9keqCwQXEPVa8Wzt3gXAOps
         lugbdPLedTGjxc2v8bSUFJOXJ2yIzKezSCid8ZDMlZLWLLA2MVfYui9rbxhk2kPB6oCQ
         rnLWkSWdCr/FOtF8S2XXg8E+8wdUNR7lv6S1SU2MRi9awc1et+8bp6116N7rTTCwQXsu
         dvog==
X-Gm-Message-State: AJcUukdl4q1bl0G9ACJKGyKGSw4E/jQiku5/Z20DirZh2qo0FTimoDVQ
        9/RwsNz6ZAx5EALqp/XLzXq88nKgJbs=
X-Google-Smtp-Source: ALg8bN7G4a66MSfb0F+e/A2b3TTUHnCPQvIMAzmE1uxBH97RTmTkWAGqTjHss8htVzMymN/q453bSQ==
X-Received: by 2002:aca:f044:: with SMTP id o65mr40196oih.145.1548203103933;
        Tue, 22 Jan 2019 16:25:03 -0800 (PST)
Received: from [192.168.1.76] (162-224-184-144.lightspeed.sntcca.sbcglobal.net. [162.224.184.144])
        by smtp.gmail.com with ESMTPSA id x4sm8373761oix.32.2019.01.22.16.25.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 16:25:03 -0800 (PST)
Subject: Re: [PATCH v8 11/11] media: imx.rst: Update doc to reflect fixes to
 interlaced capture
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     linux-media <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190109183014.20466-1-slongerbeam@gmail.com>
 <20190109183014.20466-12-slongerbeam@gmail.com>
 <CAJ+vNU1r86n1=9gKDw-bTO0sWJL7NMjZcdKMQO23a+WOR1H9tw@mail.gmail.com>
 <6b4c3fb1-929b-8894-e2f9-aca2f392f0e5@gmail.com>
 <CAJ+vNU2827H8C3PN=v++XRjd0LP6Uf1KzMAs0bFTgbX93v7atg@mail.gmail.com>
 <CAJ+vNU3+WiLd6h7efDmaU1nsqVENB-0W5pUsVD3D19doyScRnQ@mail.gmail.com>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <b8cdb7ab-ca06-237f-d683-f688c460a87a@gmail.com>
Date:   Tue, 22 Jan 2019 16:24:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU3+WiLd6h7efDmaU1nsqVENB-0W5pUsVD3D19doyScRnQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 1/22/19 11:51 AM, Tim Harvey wrote:
> On Mon, Jan 21, 2019 at 12:24 PM Tim Harvey <tharvey@gateworks.com> wrote:
>> On Tue, Jan 15, 2019 at 3:54 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>>> Hi Tim,
>>>
>>> On 1/15/19 1:58 PM, Tim Harvey wrote:
>>>> On Wed, Jan 9, 2019 at 10:30 AM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>>>>> Also add an example pipeline for unconverted capture with interweave
>>>>> on SabreAuto.
>>>>>
>>>>> Cleanup some language in various places in the process.
>>>>>
>>>>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>>>>> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
>>>>> ---
>>>>> Changes since v4:
>>>>> - Make clear that it is IDMAC channel that does pixel reordering and
>>>>>     interweave, not the CSI. Caught by Philipp Zabel.
>>>>> Changes since v3:
>>>>> - none.
>>>>> Changes since v2:
>>>>> - expand on idmac interweave behavior in CSI subdev.
>>>>> - switch second SabreAuto pipeline example to PAL to give
>>>>>     both NTSC and PAL examples.
>>>>> - Cleanup some language in various places.
>>>>> ---
>>>>>    Documentation/media/v4l-drivers/imx.rst | 103 +++++++++++++++---------
>>>>>    1 file changed, 66 insertions(+), 37 deletions(-)
>>>>>
>>>> <snip>
>>>>>    Capture Pipelines
>>>>>    -----------------
>>>>> @@ -516,10 +522,33 @@ On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
>>>>>    parallel bus input on the internal video mux to IPU1 CSI0.
>>>>>
>>>>>    The following example configures a pipeline to capture from the ADV7180
>>>>> -video decoder, assuming NTSC 720x480 input signals, with Motion
>>>>> -Compensated de-interlacing. Pad field types assume the adv7180 outputs
>>>>> -"interlaced". $outputfmt can be any format supported by the ipu1_ic_prpvf
>>>>> -entity at its output pad:
>>>>> +video decoder, assuming NTSC 720x480 input signals, using simple
>>>>> +interweave (unconverted and without motion compensation). The adv7180
>>>>> +must output sequential or alternating fields (field type 'seq-bt' for
>>>>> +NTSC, or 'alternate'):
>>>>> +
>>>>> +.. code-block:: none
>>>>> +
>>>>> +   # Setup links
>>>>> +   media-ctl -l "'adv7180 3-0021':0 -> 'ipu1_csi0_mux':1[1]"
>>>>> +   media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>>>>> +   media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
>>>>> +   # Configure pads
>>>>> +   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
>>>>> +   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
>>>>> +   media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
>>>>> +   # Configure "ipu1_csi0 capture" interface (assumed at /dev/video4)
>>>>> +   v4l2-ctl -d4 --set-fmt-video=field=interlaced_bt
>>>>> +
>>>>> +Streaming can then begin on /dev/video4. The v4l2-ctl tool can also be
>>>>> +used to select any supported YUV pixelformat on /dev/video4.
>>>>> +
>>>> Hi Steve,
>>>>
>>>> I'm testing 4.20 with this patchset on top.
>>>>
>>>> I'm on a GW5104 which has an IMX6Q with the adv7180 on ipu1_csi0 like
>>>> the SabeAuto example above I can't get the simple interveave example
>>>> to work:
>>>>
>>>> media-ctl -r # reset all links
>>>> # Setup links (ADV7180 IPU1_CSI0)
>>>> media-ctl -l '"adv7180 2-0020":0 -> "ipu1_csi0_mux":1[1]'
>>>> media-ctl -l '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
>>>> media-ctl -l '"ipu1_csi0":2 -> "ipu1_csi0 capture":0[1]' # /dev/video4
>>>> # Configure pads
>>>> media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
>>>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
>>>> media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/720x480]"
>>> This is the reason. The adv7180 is only allowing to configure alternate
>>> field mode, and thus it reports the field height on the mbus, not the
>>> full frame height. Imx deals with alternate field mode by capturing a
>>> full frame, so the CSI entity sets the output pad height to double the
>>> height.
>>>
>>> So the CSI input pad needs to be configured with the field height:
>>>
>>> media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/720x240]"
>>>
>>> It should work for you after doing that. And better yet, don't bother
>>> configuring the input pad, because media-ctl will propagate formats from
>>> source to sink pads for you, so it's better to rely on the propagation,
>>> and set the CSI output pad format instead (full frame height at output pad):
>>>
>>> media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
>>>
>> Steve,
>>
>> Thanks - that makes sense.
>>
>> I also noticed that if I setup one of the vdic pipelines first then
>> went back after a 'media-ctl -r' and setup the example that failed it
>> no longer failed. I'm thinking that this is because 'media-ctl -r'
>> make reset all the links but does not reset all the V4L2 formats on
>> pads?
>>
>>> Final note: the imx.rst doc is technically correct even though it is
>>> showing full frame heights being configured at the pads, because it is
>>> expecting the adv7180 has accepted 'seq-bt'. But even the example given
>>> in that doc works for alternate field mode, because the pad heights are
>>> forced to the correct field height for alternate mode.
>>>
>> hmmm... I don't quite follow this statement. It sounds like the
>> example would only be correct if you were setting 'field:alternate'
>> but the example sets 'field:seq-bt' instead.
>>
>> I wonder if you should add some verbiage explaining the difference in
>> format (resolution specifically) between the input and output pads
>> and/or change the example to set the output pad format so people don't
>> run into what I did trying to follow the example.
>>
> Steve,
>
> I'm able to link a sensor->mux->csi->vdic->ic_prp->ic_prpenc but not a
> sensor->mux->csi->vdic->ic_prp->ic_prpvf pipeline:

I think you mean the reverse: can setup a vdic->ic_prp->ic_prpvf 
pipeline but not a vdic->ic_prp->ic_prpenc pipeline.

Anyway there is reason for that, see below.

> - imx6q-gw54xx adv7180 2-0020 IPU2_CSI1 sensor->mux->csi->vdic->ic_prp->ic_prpvf
> # sensor format
> media-ctl --get-v4l2 '"adv7180 2-0020":0' #
> fmt:UYVY8_2X8/720x240@1001/30000 field:alternate colorspace:smpte170m
> # reset all links
> media-ctl --reset
> # setup links
> media-ctl -l "'adv7180 2-0020':0 -> 'ipu2_csi1_mux':1[1]"
> media-ctl -l "'ipu2_csi1_mux':2 -> 'ipu2_csi1':0[1]"
> media-ctl -l "'ipu2_csi1':1 -> 'ipu2_vdic':0[1]"
> media-ctl -l "'ipu2_vdic':2 -> 'ipu2_ic_prp':0[1]"
> media-ctl -l "'ipu2_ic_prp':2 -> 'ipu2_ic_prpvf':0[1]"
> media-ctl -l "'ipu2_ic_prpvf':1 -> 'ipu2_ic_prpvf capture':0[1]"
> # configure pads
> media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
> media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480]"
> media-ctl -V "'ipu2_csi1':1 [fmt:AYUV32/720x480]"
> media-ctl -V "'ipu2_vdic':2 [fmt:AYUV32/720x480 field:none]"
> media-ctl -V "'ipu2_ic_prp':2 [fmt:AYUV32/720x480 field:none]"
> media-ctl -V "'ipu2_ic_prpvf':1 [fmt:AYUV32/720x480]"
> # capture device
> media-ctl -e 'ipu2_ic_prpvf capture' # /dev/video3
> # capture 1 frame
> v4l2-ctl --device /dev/video3 --stream-mmap --stream-to=x.raw --stream-count=1
> ^^^ works
>
> - imx6q-gw54xx adv7180 2-0020 IPU2_CSI1
> sensor->mux->csi->vdic->ic_prp->ic_prpenc
> # sensor format
> media-ctl --get-v4l2 '"adv7180 2-0020":0' #
> fmt:UYVY8_2X8/720x240@1001/30000 field:alternate colorspace:smpte170m
> # reset all links
> media-ctl --reset
> # setup links
> media-ctl -l "'adv7180 2-0020':0 -> 'ipu2_csi1_mux':1[1]"
> media-ctl -l "'ipu2_csi1_mux':2 -> 'ipu2_csi1':0[1]"
> media-ctl -l "'ipu2_csi1':1 -> 'ipu2_vdic':0[1]"
> media-ctl -l "'ipu2_vdic':2 -> 'ipu2_ic_prp':0[1]"
> media-ctl -l "'ipu2_ic_prp':1 -> 'ipu2_ic_prpenc':0[1]"
> Unable to setup formats: Invalid argument (22)
>
> using Linux 4.20 + the following patch series:
>    - media: imx-csi: Input connections to CSI should be optional
>    - imx-media: Fixes for interlaced capture
> v4l-utils 1.16.1
>
> See http://dev.gateworks.com/docs/linux/media/imx6q-gw54xx-media.png
>
> My understanding is that the ic_prpenc and ic_prpvf entities are
> identical and it looks like I'm using the right pads. I'm also seeing
> the same on a board that uses ipu1_csi0 instead.
>
> Any ideas?

The VDIC only outputs to the IC PRPVF task, and not to the IC PRPENC 
task. That's just the way the IPU works. So the driver catches an 
attempt to create a vdic->ic_prp->ic_prpenc link and returns error.

There is some explanation of that in the imx.rst doc under description 
of ipuX_ic_prpvf entity:

"This entity is identical in operation to ipuX_ic_prpenc, with the same 
resizing and CSC operations and flip/rotation controls. It will receive 
and process de-interlaced frames from the ipuX_vdic if ipuX_ic_prp is 
receiving from ipuX_vdic."


Steve

