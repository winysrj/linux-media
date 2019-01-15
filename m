Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 379B8C43444
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA9A020656
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:55:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQv4Db/t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbfAOXzC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 18:55:02 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51773 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbfAOXzB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 18:55:01 -0500
Received: by mail-wm1-f68.google.com with SMTP id b11so202192wmj.1;
        Tue, 15 Jan 2019 15:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=KP9qe94xdrGH+UzqBZI3QUOLlZbNIItYwnFY35wvSx4=;
        b=PQv4Db/tL3S6Xh0+g826Yt1vCExrBzRUkMFNlM5I3VkL/fnv8SDYLldlDEm0RwNyTu
         6b9phojCBF1ratJHoknvDwGXoAdeExqfe8PWkbmEPk/hsOnqqBpQqY0/LfmZJhX6zsO3
         qYLlFCW22ql7uow06hWZVAO1QASuKHFvo02PwsOA4mvLJ4W3Ihbyt9YwqbtOZ+FEuNLR
         9K0rlvSz/WksRuBa1ILgHe3LmO9YhyASIufAvIs7diFqnTgMw16Mm8uIgOA6Z3lk/+HQ
         yAwF3K+UQ/6JTWhGDc0h1GVRCOYV/NhrZ9+0honrFblk5zx/4OOjAwPIkgkUirsCEA9q
         z2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KP9qe94xdrGH+UzqBZI3QUOLlZbNIItYwnFY35wvSx4=;
        b=LcE/kGtOUyxmosEdBbF3DTqyJHe0S1KItCvVthVpdpFsJyTpp2Dj1WpzhRcXJCdGKf
         lwTJ1oORflwHA8e48gn47/IXpqN5Gmn7wXL1kPHAqpPlYYZk3Sg620X2SIdIawNArvVD
         J/WdhrOYti3blE4CobVCp7IW9BG+UigLtqCgpYDUcXyEk9jHEOr40S6KVBW9zJuEVBPh
         OWLhXnyQgbe58ZzlCWPdRbp9DKQw8tI1eNMp27AqXO4rdaVyk2kO2qJK7WSUQEqnVKK3
         3mYts+cTR7fxBpAngtwT91wwvYX5UyvhauBO+6OC2JB8lDQ2QnfSgCdOpZSR1vPimO1c
         lhyA==
X-Gm-Message-State: AJcUukfvTeht40xUf6LMYjjA67k4kLZV4P/hvSZNwBU4iJyWwCIzrwMa
        WECbn7u/gLn0hm3niF1T4OCUvcMM
X-Google-Smtp-Source: ALg8bN5oEL1UNodTKkdB16l8rtp4ZnRZjrgPAxYKTcGAmt7jfws1flNKvKBIFgHI1Ta5L0g12n3cCQ==
X-Received: by 2002:a1c:6508:: with SMTP id z8mr5262157wmb.28.1547596498762;
        Tue, 15 Jan 2019 15:54:58 -0800 (PST)
Received: from [172.30.90.107] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id o5sm59569255wmg.25.2019.01.15.15.54.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 15:54:57 -0800 (PST)
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
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <6b4c3fb1-929b-8894-e2f9-aca2f392f0e5@gmail.com>
Date:   Tue, 15 Jan 2019 15:54:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU1r86n1=9gKDw-bTO0sWJL7NMjZcdKMQO23a+WOR1H9tw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Tim,

On 1/15/19 1:58 PM, Tim Harvey wrote:
> On Wed, Jan 9, 2019 at 10:30 AM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>> Also add an example pipeline for unconverted capture with interweave
>> on SabreAuto.
>>
>> Cleanup some language in various places in the process.
>>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
>> ---
>> Changes since v4:
>> - Make clear that it is IDMAC channel that does pixel reordering and
>>    interweave, not the CSI. Caught by Philipp Zabel.
>> Changes since v3:
>> - none.
>> Changes since v2:
>> - expand on idmac interweave behavior in CSI subdev.
>> - switch second SabreAuto pipeline example to PAL to give
>>    both NTSC and PAL examples.
>> - Cleanup some language in various places.
>> ---
>>   Documentation/media/v4l-drivers/imx.rst | 103 +++++++++++++++---------
>>   1 file changed, 66 insertions(+), 37 deletions(-)
>>
> <snip>
>>   Capture Pipelines
>>   -----------------
>> @@ -516,10 +522,33 @@ On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
>>   parallel bus input on the internal video mux to IPU1 CSI0.
>>
>>   The following example configures a pipeline to capture from the ADV7180
>> -video decoder, assuming NTSC 720x480 input signals, with Motion
>> -Compensated de-interlacing. Pad field types assume the adv7180 outputs
>> -"interlaced". $outputfmt can be any format supported by the ipu1_ic_prpvf
>> -entity at its output pad:
>> +video decoder, assuming NTSC 720x480 input signals, using simple
>> +interweave (unconverted and without motion compensation). The adv7180
>> +must output sequential or alternating fields (field type 'seq-bt' for
>> +NTSC, or 'alternate'):
>> +
>> +.. code-block:: none
>> +
>> +   # Setup links
>> +   media-ctl -l "'adv7180 3-0021':0 -> 'ipu1_csi0_mux':1[1]"
>> +   media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>> +   media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
>> +   # Configure pads
>> +   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
>> +   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
>> +   media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
>> +   # Configure "ipu1_csi0 capture" interface (assumed at /dev/video4)
>> +   v4l2-ctl -d4 --set-fmt-video=field=interlaced_bt
>> +
>> +Streaming can then begin on /dev/video4. The v4l2-ctl tool can also be
>> +used to select any supported YUV pixelformat on /dev/video4.
>> +
> Hi Steve,
>
> I'm testing 4.20 with this patchset on top.
>
> I'm on a GW5104 which has an IMX6Q with the adv7180 on ipu1_csi0 like
> the SabeAuto example above I can't get the simple interveave example
> to work:
>
> media-ctl -r # reset all links
> # Setup links (ADV7180 IPU1_CSI0)
> media-ctl -l '"adv7180 2-0020":0 -> "ipu1_csi0_mux":1[1]'
> media-ctl -l '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
> media-ctl -l '"ipu1_csi0":2 -> "ipu1_csi0 capture":0[1]' # /dev/video4
> # Configure pads
> media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
> media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/720x480]"

This is the reason. The adv7180 is only allowing to configure alternate 
field mode, and thus it reports the field height on the mbus, not the 
full frame height. Imx deals with alternate field mode by capturing a 
full frame, so the CSI entity sets the output pad height to double the 
height.

So the CSI input pad needs to be configured with the field height:

media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/720x240]"

It should work for you after doing that. And better yet, don't bother 
configuring the input pad, because media-ctl will propagate formats from 
source to sink pads for you, so it's better to rely on the propagation, 
and set the CSI output pad format instead (full frame height at output pad):

media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"


Final note: the imx.rst doc is technically correct even though it is 
showing full frame heights being configured at the pads, because it is 
expecting the adv7180 has accepted 'seq-bt'. But even the example given 
in that doc works for alternate field mode, because the pad heights are 
forced to the correct field height for alternate mode.

Steve



> # Configure 'ipu1_csi0 capture' interface (/dev/video4)
> v4l2-ctl -d4 --set-fmt-video=field=interlaced_bt
> # streaming can now begin on the raw capture device node at /dev/video4
> v4l2-ctl -d4 --stream-mmap --stream-to=/x.raw --stream-count=1 # capture 1 frame
> [ 5547.354460] ipu1_csi0: pipeline start failed with -32
> VIDIOC_STREAMON: failed: Broken pipe
>
> Any ideas what is causing this pipeline failure.
>
>> +This example configures a pipeline to capture from the ADV7180
>> +video decoder, assuming PAL 720x576 input signals, with Motion
>> +Compensated de-interlacing. The adv7180 must output sequential or
>> +alternating fields (field type 'seq-tb' for PAL, or 'alternate').
>> +$outputfmt can be any format supported by the ipu1_ic_prpvf entity
>> +at its output pad:
>>
>>   .. code-block:: none
>>
>> @@ -531,11 +560,11 @@ entity at its output pad:
>>      media-ctl -l "'ipu1_ic_prp':2 -> 'ipu1_ic_prpvf':0[1]"
>>      media-ctl -l "'ipu1_ic_prpvf':1 -> 'ipu1_ic_prpvf capture':0[1]"
>>      # Configure pads
>> -   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480]"
>> -   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480 field:interlaced]"
>> -   media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/720x480 field:interlaced]"
>> -   media-ctl -V "'ipu1_vdic':2 [fmt:AYUV32/720x480 field:none]"
>> -   media-ctl -V "'ipu1_ic_prp':2 [fmt:AYUV32/720x480 field:none]"
>> +   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x576 field:seq-tb]"
>> +   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x576]"
>> +   media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/720x576]"
>> +   media-ctl -V "'ipu1_vdic':2 [fmt:AYUV32/720x576 field:none]"
>> +   media-ctl -V "'ipu1_ic_prp':2 [fmt:AYUV32/720x576 field:none]"
>>      media-ctl -V "'ipu1_ic_prpvf':1 [fmt:$outputfmt field:none]"
>>
>>   Streaming can then begin on the capture device node at
> The above motion-compensation example pipeline does now work with this
> patch series - thanks for addressing this!
>
> Regards,
>
> Tim

