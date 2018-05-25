Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:35013 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030651AbeEYXVX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 19:21:23 -0400
Received: by mail-pg0-f47.google.com with SMTP id 15-v6so2557440pge.2
        for <linux-media@vger.kernel.org>; Fri, 25 May 2018 16:21:22 -0700 (PDT)
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
Cc: linux-media@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
References: <m37eobudmo.fsf@t19.piap.pl>
 <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com> <m3tvresqfw.fsf@t19.piap.pl>
 <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com> <m3fu2oswjh.fsf@t19.piap.pl>
 <m3603hsa4o.fsf@t19.piap.pl> <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com>
 <m3h8mxqc7t.fsf@t19.piap.pl> <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
 <1527229949.4938.1.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <dee0fb18-faf3-12b7-3014-d5b63a8b3e38@gmail.com>
Date: Fri, 25 May 2018 16:21:19 -0700
MIME-Version: 1.0
In-Reply-To: <1527229949.4938.1.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,


On 05/24/2018 11:32 PM, Philipp Zabel wrote:
> On Thu, 2018-05-24 at 11:12 -0700, Steve Longerbeam wrote:
> [...]
>>> The following is required as well. Now the question is why we can't skip
>>> writing those odd UV rows. Anyway, with these 2 changes, I get a stable
>>> NTSC (and probably PAL) interlaced video stream.
>>>
>>> The manual says: Reduce Double Read or Writes (RDRW):
>>> This bit is relevant for YUV4:2:0 formats. For write channels:
>>> U and V components are not written to odd rows.
>>>
>>> How could it be so? With YUV420, are they normally written?
>> Well, given that this bit exists, and assuming I understand it correctly
>> (1),
>> I guess the U and V components for odd rows normally are placed on the
>> AXI bus. Which is a total waste of bus bandwidth because in 4:2:0,
>> the U and V components are the same for odd and even rows.
>>
>> In other words for writing 4:2:0 to memory, this bit should _always_ be set.
>>
>> (1) OTOH I don't really understand what this bit is trying to say.
>> Whether this bit is set or not, the data in memory is correct
>> for planar 4:2:0: y plane buffer followed by U plane of 1/4 size
>> (decimated by 2 in width and height), followed by Y plane of 1/4
>> size.
>>
>> So I assume it is saying that the IPU normally places U/V components
>> on the AXI bus for odd rows, that are identical to the even row values.
> Whether they are identical depends on the input format.

Right, this is the part I was missing, thanks for clarifying. The
even and odd chroma rows coming into the IDMAC from the
CSI (or IC) may not be identical if the CSI has captured 4:4:4
(or 4:2:2 yeah? 4:2:2 is only decimated in width not height).

But still, when the IDMAC has finished pixel packing/unpacking and
is writing 4:2:0 to memory, it should always skip overwriting the even
rows with the odd rows, whether or not it has received identical chroma
even/odd lines from the CSI.

Unless interweave is enabled :) See below.
>
> The IDMAC always gets fed AYUV32 from the CSI or IC.
> If the CSI captures YUV 4:2:x, odd and even lines will have the same
> chroma values. But if the CSI captures YUV 4:4:4 (or RGB, fed through
> the IC), we can have AYUV32 input with different chroma values on even
> and odd lines.
> In that case the IPU just writes the even chroma line and then
> overwrites it with the odd line, unless the double write reduction bit
> is set.
>
>> IOW somehow those identical odd rows are dropped before writing to
>> the U/V planes in memory.
> potentially identical.

Right.

>
>> Philipp please chime in if you have something to add here.
> I suppose the bit could be used to choose to write the chroma values of
> odd instead of even lines for 4:4:4 inputs, at the cost of increased
> memory bandwidth usage.
>
>> Steve
>>
>>> OTOH it seems that not only UV is broken with this bit set.
>>> Y is broken as well.
> Maybe scanline interlave and double write reduction can't be used at the
> same time?

Yes, I just verified that. I went back to the SabreLite with the
progressive output OV5640, and double-write-reduction for
4:2:0 capture works fine, the images are correct.

Steve
