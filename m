Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73538C282C3
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 00:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31E3421726
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 00:10:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tB9LDtDy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfAWAKX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 19:10:23 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40282 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfAWAKW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 19:10:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id p4so371450wrt.7;
        Tue, 22 Jan 2019 16:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ZxDb0vYd3PO4jWllQVwieKYYm2BFu1ttqZZCmMjmCDA=;
        b=tB9LDtDyzeSIrMeXEmfK40M5+bjBEbFRwo3UwAKsFb5Kgd9a2Nl5NlN6rKlcOIN5fR
         mHzJ5VsJ5/tbNr6SvcsgpQA2prQgTlCy+9aOx/fXerLrOiLCW716ZFVTB7WIQulKaY4K
         K4sXzJDM4y+qfMhO9wWu5BEuv63SeDZfTG2cVnJphWoo8HFV6OIW/Qe2JUWqF5h/rNE9
         uFWHJ727hQVfcj1a6OAbtibsoMhoPK5vy5ZdSSs57AqJTIacFqtL+sZxDLmTi4stOwzw
         7b6TFRHH3KkW4xyGNVnCET5l6SQNhX3+7Eit/DvMp86bpOFxEjfl/0A28BnrQwRQ8IjF
         w1RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZxDb0vYd3PO4jWllQVwieKYYm2BFu1ttqZZCmMjmCDA=;
        b=Lhqu+qe0bf3tIkEbfNNzfvUM6gsJUMM0PtAqViff5y3Quvqwl+B/m5butp2nTwhvkP
         U+izA6XcybaypMyucJ5uY/2Z37tpatqYrrGghizIJlEeHv70nzhYJx2Gd73Sa46mSPCd
         hb9UjptSwlDiva4wJWINBBYLCBUYqwilCrQ5ZLqi7dPzeokVq/URPLmV3xX1QhFxyLZq
         tgbhWVDOZoUSxnSvJ2L813LQ0c/wSgjkAbWOPql8CMg+nDF7W9K3eLPNm+Q/VeqUz8Nv
         GscuGQjPcoh1DEUW6FKQruUh5OhhcLSu5BaNQqpMpJREq8A4eV0axikWVbZTdZiGp+2E
         ogIg==
X-Gm-Message-State: AJcUukeE4bVLCuId0OHni7bq0aOo+xGqO1KIKFHYYlP2+S/3AUZLbI1z
        YRMzKXP3AwYORSHbfpaWTptOYVJK
X-Google-Smtp-Source: ALg8bN7mkX3lz7jsBxC2qC+jVEovCfHoaRFPTVfjjrHqY4WztjKW3bcOhts6gIKWX2+1UBCcrC9/gg==
X-Received: by 2002:a05:6000:51:: with SMTP id k17mr15302wrx.259.1548202219742;
        Tue, 22 Jan 2019 16:10:19 -0800 (PST)
Received: from [172.30.88.84] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id q12sm87947890wrx.31.2019.01.22.16.10.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 16:10:18 -0800 (PST)
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
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <aca68d5d-25ef-daef-c396-d32e4099c28f@gmail.com>
Date:   Tue, 22 Jan 2019 16:08:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU2827H8C3PN=v++XRjd0LP6Uf1KzMAs0bFTgbX93v7atg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 1/21/19 12:24 PM, Tim Harvey wrote:
> On Tue, Jan 15, 2019 at 3:54 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>> Hi Tim,
>>
>> On 1/15/19 1:58 PM, Tim Harvey wrote:
>>> On Wed, Jan 9, 2019 at 10:30 AM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>>>> Also add an example pipeline for unconverted capture with interweave
>>>> on SabreAuto.
>>>>
>>>> Cleanup some language in various places in the process.
>>>>
>>>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>>>> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
>>>> ---
>>>> Changes since v4:
>>>> - Make clear that it is IDMAC channel that does pixel reordering and
>>>>     interweave, not the CSI. Caught by Philipp Zabel.
>>>> Changes since v3:
>>>> - none.
>>>> Changes since v2:
>>>> - expand on idmac interweave behavior in CSI subdev.
>>>> - switch second SabreAuto pipeline example to PAL to give
>>>>     both NTSC and PAL examples.
>>>> - Cleanup some language in various places.
>>>> ---
>>>>    Documentation/media/v4l-drivers/imx.rst | 103 +++++++++++++++---------
>>>>    1 file changed, 66 insertions(+), 37 deletions(-)
>>>>
>>> <snip>
>>>>    Capture Pipelines
>>>>    -----------------
>>>> @@ -516,10 +522,33 @@ On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
>>>>    parallel bus input on the internal video mux to IPU1 CSI0.
>>>>
>>>>    The following example configures a pipeline to capture from the ADV7180
>>>> -video decoder, assuming NTSC 720x480 input signals, with Motion
>>>> -Compensated de-interlacing. Pad field types assume the adv7180 outputs
>>>> -"interlaced". $outputfmt can be any format supported by the ipu1_ic_prpvf
>>>> -entity at its output pad:
>>>> +video decoder, assuming NTSC 720x480 input signals, using simple
>>>> +interweave (unconverted and without motion compensation). The adv7180
>>>> +must output sequential or alternating fields (field type 'seq-bt' for
>>>> +NTSC, or 'alternate'):
>>>> +
>>>> +.. code-block:: none
>>>> +
>>>> +   # Setup links
>>>> +   media-ctl -l "'adv7180 3-0021':0 -> 'ipu1_csi0_mux':1[1]"
>>>> +   media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>>>> +   media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
>>>> +   # Configure pads
>>>> +   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
>>>> +   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
>>>> +   media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
>>>> +   # Configure "ipu1_csi0 capture" interface (assumed at /dev/video4)
>>>> +   v4l2-ctl -d4 --set-fmt-video=field=interlaced_bt
>>>> +
>>>> +Streaming can then begin on /dev/video4. The v4l2-ctl tool can also be
>>>> +used to select any supported YUV pixelformat on /dev/video4.
>>>> +
>>> Hi Steve,
>>>
>>> I'm testing 4.20 with this patchset on top.
>>>
>>> I'm on a GW5104 which has an IMX6Q with the adv7180 on ipu1_csi0 like
>>> the SabeAuto example above I can't get the simple interveave example
>>> to work:
>>>
>>> media-ctl -r # reset all links
>>> # Setup links (ADV7180 IPU1_CSI0)
>>> media-ctl -l '"adv7180 2-0020":0 -> "ipu1_csi0_mux":1[1]'
>>> media-ctl -l '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
>>> media-ctl -l '"ipu1_csi0":2 -> "ipu1_csi0 capture":0[1]' # /dev/video4
>>> # Configure pads
>>> media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
>>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
>>> media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/720x480]"
>> This is the reason. The adv7180 is only allowing to configure alternate
>> field mode, and thus it reports the field height on the mbus, not the
>> full frame height. Imx deals with alternate field mode by capturing a
>> full frame, so the CSI entity sets the output pad height to double the
>> height.
>>
>> So the CSI input pad needs to be configured with the field height:
>>
>> media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/720x240]"
>>
>> It should work for you after doing that. And better yet, don't bother
>> configuring the input pad, because media-ctl will propagate formats from
>> source to sink pads for you, so it's better to rely on the propagation,
>> and set the CSI output pad format instead (full frame height at output pad):
>>
>> media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
>>
> Steve,
>
> Thanks - that makes sense.
>
> I also noticed that if I setup one of the vdic pipelines first then
> went back after a 'media-ctl -r' and setup the example that failed it
> no longer failed. I'm thinking that this is because 'media-ctl -r'
> make reset all the links but does not reset all the V4L2 formats on
> pads?
>
>> Final note: the imx.rst doc is technically correct even though it is
>> showing full frame heights being configured at the pads, because it is
>> expecting the adv7180 has accepted 'seq-bt'. But even the example given
>> in that doc works for alternate field mode, because the pad heights are
>> forced to the correct field height for alternate mode.
>>
> hmmm... I don't quite follow this statement. It sounds like the
> example would only be correct if you were setting 'field:alternate'
> but the example sets 'field:seq-bt' instead.

The example is consistent for a sensor that sends seq-bt. Here is the 
example config from the imx.rst doc again, a (ntsc) height of 480 lines 
is correct for a seq-bt source:

    # Setup links
    media-ctl -l "'adv7180 3-0021':0 -> 'ipu1_csi0_mux':1[1]"
    media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
    media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
    # Configure pads
    media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
    media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
    media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
    # Configure "ipu1_csi0 capture" interface (assumed at /dev/video4)
    v4l2-ctl -d4 --set-fmt-video=field=interlaced_bt

> I wonder if you should add some verbiage explaining the difference in
> format (resolution specifically) between the input and output pads
> and/or change the example to set the output pad format so people don't
> run into what I did trying to follow the example.
>

Well, the example *is* setting the output pad format (media-ctl -V 
"ipu1_csi0:2 ...").

But I suppose wording could be added such as "this example assumes the 
sensor (adv7180) supports seq-bt".

Steve



