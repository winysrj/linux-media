Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:49303 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751098AbeFEA4u (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 20:56:50 -0400
Subject: Re: [PATCH v2 04/10] media: imx: interweave only for sequential
 input/interlaced output fields
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
CC: Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-media@vger.kernel.org>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
 <1527813049-3231-5-git-send-email-steve_longerbeam@mentor.com>
 <1527860010.5913.8.camel@pengutronix.de> <m3k1rfnmfr.fsf@t19.piap.pl>
 <1528100849.5808.2.camel@pengutronix.de>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <c9fcc11a-9f0f-0764-cb8e-66fc9c09d7f4@mentor.com>
Date: Mon, 4 Jun 2018 17:56:44 -0700
MIME-Version: 1.0
In-Reply-To: <1528100849.5808.2.camel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/04/2018 01:27 AM, Philipp Zabel wrote:
> On Mon, 2018-06-04 at 07:35 +0200, Krzysztof Hałasa wrote:
>> Philipp Zabel <p.zabel@pengutronix.de> writes:
>>
>>> This is ok in this patch, but we can't use this check in the following
>>> TRY_FMT patch as there is no way to interweave
>>> SEQ_TB -> INTERLACED_BT (because in SEQ_TB the B field is newer than T,
>>> but in INTERLACED_BT it has to be older) or SEQ_BT -> INTERLACED_TB (the
>>> other way around).
>> Actually we can do SEQ_TB -> INTERLACED_BT and SEQ_BT -> INTERLACED_TB
>> rather easily. We only need to skip a single field at start :-)
>> That's what CCIR_CODE_* registers do.
>>
>> To be honest, SEQ_TB and SEQ_BT are precisely the same thing
>> (i.e., SEQUENTIAL). It's up to the user to say which field is the first.
>> There is the progressive sensor exception, though, and the TB/BT could
>> be a hint for downstream elements (i.e., setting the default field
>> order).
>>
>> But I think we should be able to request INTERLACED_TB or INTERLACED_BT
>> (with any analog signal on input) and the CCIR_CODE registers should be
>> set accordingly. This should all magically work fine.
> The CSI subdevice itself can't interweave at all, this is done in the
> IDMAC.
> In my opinion the CSI subdev should allow the following src -> sink
> field transformations for BT.656:
>
> none -> none
> seq-tb -> seq-tb
> seq-tb -> seq-bt
> seq-bt -> seq-bt
> seq-bt -> seq-tb
> alternate -> seq-tb
> alternate -> seq-bt
> interlaced -> interlaced
> interlaced-tb -> interlaced-tb
> interlaced-bt -> interlaced-bt
>
> The capture video device should then additionally allow selecting
> the field order that can be produced by IDMAC interweaving:
> INTERLACED_TB if the pad is seq-tb and INTERLACED_BT if the pad is seq-
> bt, as that is what the IDMAC can convert.

Good idea. This is also in-line with how planar YUV is selected
at the capture interface instead of at the CSI/PRPENCVF source
pad.

Philipp, Krzysztof, please see branch fix-csi-interlaced.3 in my github
mediatree fork. I've implemented the above and it works great for
both NTSC and PAL sources to the ADV7180.

>
> seq-tb -> seq-tb and seq-bt -> seq-bt should always capture field 0
> first, as we currently do for PAL.
> seq->tb -> seq-bt and seq-bt -> seq-tb should always capture field 1
> first, as we currently do for NTSC.
> alternate -> seq-tb and alternate -> seq-bt should match seq-tb -> * for
> PAL and seq-bt -> * for NTSC.

Yes, I had already implemented this idea yesterday, I've added it
to branch fix-csi-interlaced.3. The CSI will swap field capture
(field 1 first, then field 2, by inverting F bit in CCIR registers) if
the field order input to the CSI is different from the requested
output field order.

Philipp, a word about the idea of using negative ILO line stride and
an extra line added to EBA start address, for interweaving. I believe
the result of this is to also invert field order when interweaving
'seq-bt/tb', which would produce 'interlaced-tb/bt' in memory.

I don't think this is necessary now, because field order swapping
can already be done earlier at the CSI sink->src using the CCIR registers.
For example here is a pipeline for an NTSC adv7180 source that swapped
NTSC 'seq-bt' (well assumed NTSC 'seq-bt' since adv7180 is 'alternate') to
'seq-tb' at the CSI source pad:

'adv7180 3-0021':0
         [fmt:UYVY8_2X8/720x480 field:alternate colorspace:smpte170m]
'ipu1_csi0_mux':1
         [fmt:UYVY8_2X8/720x480 field:alternate colorspace:smpte170m]
'ipu1_csi0_mux':2
         [fmt:UYVY8_2X8/720x480 field:alternate colorspace:smpte170m]
'ipu1_csi0':0
         [fmt:UYVY8_2X8/720x480@1/30 field:alternate ...]
          crop.bounds:(0,0)/720x480
          crop:(0,2)/720x480
          compose.bounds:(0,0)/720x480
          compose:(0,0)/720x480]
'ipu1_csi0':2
         [fmt:AYUV8_1X32/720x480@1/30 field:seq-tb ...]

And at the capture interface:

# v4l2-ctl -d4 -V
Format Video Capture:
     Width/Height      : 720/480
     Pixel Format      : 'YV12'
     Field             : Interlaced Top-Bottom
     Bytes per Line    : 1440
     Size Image        : 691200
     Colorspace        : SMPTE 170M
     Transfer Function : Rec. 709
     YCbCr/HSV Encoding: ITU-R 601
     Quantization      : Limited Range
     Flags             :

So we've accomplished 'seq-bt' -> 'interlaced-tb' without needing
to swap field order using the modified interweave idea.

I've run tests for both PAL and NTSC inputs to the adv7180 on SabreAuto,
and the results are consistent:

NTSC seq-bt -> interlaced-tb produces good interweave images as expected
NTSC seq-bt -> interlaced-bt produces interweave images with a "mauve" 
artifact as expected
PAL seq-tb -> interlaced-tb produces good interweave images as expected
PAL seq-tb -> interlaced-bt produces interweave images with a "mauve" 
artifact as expected

Steve
