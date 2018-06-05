Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:54421 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751836AbeFETA7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 15:00:59 -0400
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
 <c9fcc11a-9f0f-0764-cb8e-66fc9c09d7f4@mentor.com>
 <1528186075.4074.1.camel@pengutronix.de>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <98b3cd1e-32ff-e7bb-b2ba-7b622aa983b6@mentor.com>
Date: Tue, 5 Jun 2018 12:00:52 -0700
MIME-Version: 1.0
In-Reply-To: <1528186075.4074.1.camel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,


On 06/05/2018 01:07 AM, Philipp Zabel wrote:
> Hi Steve,
>
> On Mon, 2018-06-04 at 17:56 -0700, Steve Longerbeam wrote:
>> On 06/04/2018 01:27 AM, Philipp Zabel wrote:
>>> On Mon, 2018-06-04 at 07:35 +0200, Krzysztof Hałasa wrote:
>>>> Philipp Zabel <p.zabel@pengutronix.de> writes:
>>>>
>>>>> This is ok in this patch, but we can't use this check in the following
>>>>> TRY_FMT patch as there is no way to interweave
>>>>> SEQ_TB -> INTERLACED_BT (because in SEQ_TB the B field is newer than T,
>>>>> but in INTERLACED_BT it has to be older) or SEQ_BT -> INTERLACED_TB (the
>>>>> other way around).
>>>> Actually we can do SEQ_TB -> INTERLACED_BT and SEQ_BT -> INTERLACED_TB
>>>> rather easily. We only need to skip a single field at start :-)
>>>> That's what CCIR_CODE_* registers do.
>>>>
>>>> To be honest, SEQ_TB and SEQ_BT are precisely the same thing
>>>> (i.e., SEQUENTIAL). It's up to the user to say which field is the first.
>>>> There is the progressive sensor exception, though, and the TB/BT could
>>>> be a hint for downstream elements (i.e., setting the default field
>>>> order).
>>>>
>>>> But I think we should be able to request INTERLACED_TB or INTERLACED_BT
>>>> (with any analog signal on input) and the CCIR_CODE registers should be
>>>> set accordingly. This should all magically work fine.
>>> The CSI subdevice itself can't interweave at all, this is done in the
>>> IDMAC.
>>> In my opinion the CSI subdev should allow the following src -> sink
>>> field transformations for BT.656:
>>>
>>> none -> none
>>> seq-tb -> seq-tb
>>> seq-tb -> seq-bt
>>> seq-bt -> seq-bt
>>> seq-bt -> seq-tb
>>> alternate -> seq-tb
>>> alternate -> seq-bt
>>> interlaced -> interlaced
>>> interlaced-tb -> interlaced-tb
>>> interlaced-bt -> interlaced-bt
>>>
>>> The capture video device should then additionally allow selecting
>>> the field order that can be produced by IDMAC interweaving:
>>> INTERLACED_TB if the pad is seq-tb and INTERLACED_BT if the pad is seq-
>>> bt, as that is what the IDMAC can convert.
>> Good idea. This is also in-line with how planar YUV is selected
>> at the capture interface instead of at the CSI/PRPENCVF source
>> pad.
>>
>> Philipp, Krzysztof, please see branch fix-csi-interlaced.3 in my github
>> mediatree fork. I've implemented the above and it works great for
>> both NTSC and PAL sources to the ADV7180.
> Thanks! I'll have a look.
>
>>> seq-tb -> seq-tb and seq-bt -> seq-bt should always capture field 0
>>> first, as we currently do for PAL.
>>> seq->tb -> seq-bt and seq-bt -> seq-tb should always capture field 1
>>> first, as we currently do for NTSC.
>>> alternate -> seq-tb and alternate -> seq-bt should match seq-tb -> * for
>>> PAL and seq-bt -> * for NTSC.
>> Yes, I had already implemented this idea yesterday, I've added it
>> to branch fix-csi-interlaced.3. The CSI will swap field capture
>> (field 1 first, then field 2, by inverting F bit in CCIR registers) if
>> the field order input to the CSI is different from the requested
>> output field order.
>>
>> Philipp, a word about the idea of using negative ILO line stride and
>> an extra line added to EBA start address, for interweaving. I believe
>> the result of this is to also invert field order when interweaving
>> 'seq-bt/tb', which would produce 'interlaced-tb/bt' in memory.
> I'm probably misunderstanding you, so at the risk of overexplaining:
> There is no way we can ever produce a correct interlaced-tb frame in
> memory from a seq-bt frame output by the CSI, as the interweaving step
> only has access to a single frame.

I don't follow you, yes the interweaving step only has access to
a single frame, but why would interweave need access to another
frame to carry out seq-bt -> interlaced-tb ? See below...
>
> A seq-tb PAL frame has the older top field in lines 0-287 and the newer
> bottom field in lines 288-576. From that interlaced-tb can be written
> via 0-287 -> 0,2,4,...,286 and 288-575 -> 1,3,5,...,287 [1]. This is
> what interweaving does if the interlace offset is set to positive line
> stride.

Right, that was my understanding as well. And how interweave
actually works in the IDMAC to achieve the above is :

By turning on SO bit in cpmem, the IDMAC will write the first one-half
lines of the frame received by the IDMAC channel to memory, starting
at the EBA address, with a line stride equal to cpmem SLY. When it
completes writing out the first half lines of the frame, the IDMAC begins
to write the lines from the second half of frame to memory, but starts
again at EBA address, and with an offset equal to cpmem ILO.

So by setting SO=1, SLY=2*linestride, and ILO=linestride, we achieve
interweave where:

lines from first half of frame are written to lines 0,2,4,...,HEIGHT-2 
in memory, and
lines from the second half of the frame are written to lines 
1,3,...,HEIGHT-1 in memory.

So this setting achieves seq-bt -> interlaced-bt or seq-tb -> 
interlaced-tb, e.g.
interweave *does not change field order*, bottom lines 1,3,,, are written to
0,2,4,,, in memory if IDMAC receives seq-bt, or top lines 0,2,4,,, are 
written to
0,2,4,,, in memory if IDMAC receives seq-tb.

And by setting SO=1, SLY=2*linestride, ILO=-linestride, and adding one
linestride to EBA:

lines from first half of the frame are written to lines 1,3,...,HEIGHT-1 
in memory, and
lines from the second half of the frame are written to lines 
0,2,...,HEIGHT-2 in memory.

So this achieves  seq-bt -> interlaced-tb or seq-tb -> interlaced-bt, 
e.g. field order
has been swapped in memory.


> A seq-bt NTSC frame has the older bottom field in lines 0-239 and the
> newer top field in lines 240-439. We can create an interlaced-bt frame
> from that by writing 0-239 -> 1,3,5,...,239 and 240-439 -> 0,2,4,...,238
> [2]. This can be achieved by offsetting EBA by +stride and setting ILO
> to -stride.

Agreed except that this is seq-bt -> interlaced-tb, not
seq-bt -> interlaced-bt:

Bottom lines = 1,3,5,...,H-1
Top lines = 0,2,4,...,H-2

So seq-bt is written as interlaced-tb to memory:

Bottom lines = 1,3,5,...,H-1 go to memory lines 1,3,5,...H-1
Top lines = 0,2,4,...,H-2 go to memory lines 0,2,4,...,H-2.

So this is TB order in memory.

>
> [1] https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/field-order.html?highlight=field#field-order-top-field-first-transmitted
> [2] https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/field-order.html?highlight=field#field-order-bottom-field-first-transmitted
>
> Writing a seq-tb frame with negative ILO or a seq-bt frame with positive
> ILO causes misaligned interlaced frames with even and odd lines
> switched.
>
>> I don't think this is necessary now, because field order swapping
>> can already be done earlier at the CSI sink->src using the CCIR registers.
>> For example here is a pipeline for an NTSC adv7180 source that swapped
>> NTSC 'seq-bt' (well assumed NTSC 'seq-bt' since adv7180 is 'alternate') to
>> 'seq-tb' at the CSI source pad:
>>
>> 'adv7180 3-0021':0
>>           [fmt:UYVY8_2X8/720x480 field:alternate colorspace:smpte170m]
>> 'ipu1_csi0_mux':1
>>           [fmt:UYVY8_2X8/720x480 field:alternate colorspace:smpte170m]
>> 'ipu1_csi0_mux':2
>>           [fmt:UYVY8_2X8/720x480 field:alternate colorspace:smpte170m]
>> 'ipu1_csi0':0
>>           [fmt:UYVY8_2X8/720x480@1/30 field:alternate ...]
> Yes, and due to 480 height the CSI would behave as if field:seq-bt was
> set.

Right. So input to CSI is (assumed to be) seq-bt.

>
>>            crop.bounds:(0,0)/720x480
>>            crop:(0,2)/720x480
>>            compose.bounds:(0,0)/720x480
>>            compose:(0,0)/720x480]
>> 'ipu1_csi0':2
>>           [fmt:AYUV8_1X32/720x480@1/30 field:seq-tb ...]
> So this causes CSI to sample field 1 first, and then field 0 of the next
> frame.

Right. So output from CSI is seq-tb.


>
>> And at the capture interface:
>>
>> # v4l2-ctl -d4 -V
>> Format Video Capture:
>>       Width/Height      : 720/480
>>       Pixel Format      : 'YV12'
>>       Field             : Interlaced Top-Bottom
>>       Bytes per Line    : 1440
>>       Size Image        : 691200
>>       Colorspace        : SMPTE 170M
>>       Transfer Function : Rec. 709
>>       YCbCr/HSV Encoding: ITU-R 601
>>       Quantization      : Limited Range
>>       Flags             :
>>
>> So we've accomplished 'seq-bt' -> 'interlaced-tb' without needing
>> to swap field order using the modified interweave idea.
> I don't follow. For NTSC this setting looks exactly like it should swap
> field order in the CSI by first capturing field F=1 (top) and then field
> F=0 of the next frame (bottom) into a single frame.

Right! CSI swaps seq-bt at its sink pad to seq-tb at its source pad.
>
>> I've run tests for both PAL and NTSC inputs to the adv7180 on SabreAuto,
>> and the results are consistent:
>>
>> NTSC seq-bt -> interlaced-tb produces good interweave images as expected
> So that is seq-bt or alternate on the CSI sink pad, seq-tb on the CSI
> src pad and interlaced-tb in the video capture device?

Correct! The final outcome is seq-bt from the originating source,
to interlaced-tb in memory.


>
>> NTSC seq-bt -> interlaced-bt produces interweave images with a "mauve"
>> artifact as expected
> We can fix this to produce perfect results with seq-bt or alternate on
> the CSI sink pad, seq-bt on the src pad, and interlaced-bt in the video
> capture device by implementing the negative ILO idea.

Well sure, we could use the negative ILO idea to swap field order
(for a second time) at the CSI src pad to capture interface, e.g.
seq-bt at CSI sink -> seq-tb at CSI src -> interlaced-bt at capture
interface.

But I don't see the need for doing that. If the user wishes to swap
field order, it can do that at the CSI source pad. Why swap field
order for a second time? But sure we could provide that ability.

>
>> PAL seq-tb -> interlaced-tb produces good interweave images as expected
>> PAL seq-tb -> interlaced-bt produces interweave images with a "mauve"
>> artifact as expected
> Same as above, with negative ILO we should be able to do field switching
> in the CSI, setting the sink pad to alternate or seq-tb, the src pad to
> seq-bt, and create proper interlaced-bt from that in the IDMAC.

seq-bt at src pad to interlaced-bt in memory doesn't require negative
ILO as I explained above.

Steve
