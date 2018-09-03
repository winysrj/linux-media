Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37914 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727457AbeICUMM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2018 16:12:12 -0400
Subject: Re: [PATCH v4 5/6] media: Add controls for JPEG quantization tables
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>,
        Shunqian Zheng <zhengsq@rock-chips.com>
References: <20180831155245.19235-1-ezequiel@collabora.com>
 <ec1dab04-1890-5555-44cf-2cdadc79c1a6@xs4all.nl>
 <b5715198-eff0-30d2-6f84-cd1441d3f7ba@gmail.com>
 <8d9cb4b73c4dc4af66ace5205bd6af5fc193d72a.camel@collabora.com>
 <0beecc48-6974-c12f-00a2-3823690108c0@xs4all.nl>
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <1d0c0685-7d91-b422-7e34-b6472a090eb2@gmail.com>
Date: Mon, 3 Sep 2018 16:51:25 +0100
MIME-Version: 1.0
In-Reply-To: <0beecc48-6974-c12f-00a2-3823690108c0@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Ezequiel,

On 03/09/2018 16:33, Hans Verkuil wrote:
> On 09/03/2018 05:27 PM, Ezequiel Garcia wrote:
>> Hi Ian, Hans:
>>
>> On Mon, 2018-09-03 at 14:29 +0100, Ian Arkver wrote:
>>> Hi,
>>>
>>> On 03/09/2018 10:50, Hans Verkuil wrote:
>>>> On 08/31/2018 05:52 PM, Ezequiel Garcia wrote:
>>>>> From: Shunqian Zheng <zhengsq@rock-chips.com>
>>>>>
>>>>> Add V4L2_CID_JPEG_QUANTIZATION compound control to allow userspace
>>>>> configure the JPEG quantization tables.
>>>>>
>>>>> Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
>>>>> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
>>>>> ---
>>>>>    .../media/uapi/v4l/extended-controls.rst      | 23 +++++++++++++++++++
>>>>>    .../media/videodev2.h.rst.exceptions          |  1 +
>>>>>    drivers/media/v4l2-core/v4l2-ctrls.c          | 10 ++++++++
>>>>>    include/uapi/linux/v4l2-controls.h            |  5 ++++
>>>>>    include/uapi/linux/videodev2.h                |  1 +
>>>>>    5 files changed, 40 insertions(+)
>>>>>
>>>>> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
>>>>> index 9f7312bf3365..e0dd03e452de 100644
>>>>> --- a/Documentation/media/uapi/v4l/extended-controls.rst
>>>>> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
>>>>> @@ -3354,7 +3354,30 @@ JPEG Control IDs
>>>>>        Specify which JPEG markers are included in compressed stream. This
>>>>>        control is valid only for encoders.
>>>>>    
>>>>> +.. _jpeg-quant-tables-control:
>>>>>    
>>>>> +``V4L2_CID_JPEG_QUANTIZATION (struct)``
>>>>> +    Specifies the luma and chroma quantization matrices for encoding
>>>>> +    or decoding a V4L2_PIX_FMT_JPEG_RAW format buffer. The two matrices
>>>>> +    must be set in JPEG zigzag order, as per the JPEG specification.
>>>>
>>>> Can you change "JPEG specification" to a reference to the JPEG spec entry
>>>> in bibio.rst?
>>>>
>>>>> +
>>>>> +
>>>>> +.. c:type:: struct v4l2_ctrl_jpeg_quantization
>>>>> +
>>>>> +.. cssclass:: longtable
>>>>> +
>>>>> +.. flat-table:: struct v4l2_ctrl_jpeg_quantization
>>>>> +    :header-rows:  0
>>>>> +    :stub-columns: 0
>>>>> +    :widths:       1 1 2
>>>>> +
>>>>> +    * - __u8
>>>>> +      - ``luma_quantization_matrix[64]``
>>>>> +      - Sets the luma quantization table.
>>>>> +
>>>>> +    * - __u8
>>>>> +      - ``chroma_quantization_matrix[64]``
>>>>> +      - Sets the chroma quantization table.
>>>>
>>>> Just checking: the JPEG standard specifies this as unsigned 8-bit values as well?
>>>
>>
>> I thought this was already discussed, but I think the only thing I've added
>> is this comment in one of the driver's headers:
>>
>>   JPEG encoder
>>   ------------
>>   The VPU JPEG encoder produces JPEG baseline sequential format.
>>   The quantization coefficients are 8-bit values, complying with
>>   the baseline specification. Therefore, it requires application-defined
>>   luma and chroma quantization tables. The hardware does entrophy
>>   encoding using internal Huffman tables, as specified in the JPEG
>>   specification.
>>
>> Certainly controls should be specified better.
>>
>>> As far as I can see ISO/IEC 10918-1 does not specify the precision or
>>> signedness of the quantisation value Qvu. The default tables for 8-bit
>>> baseline JPEG all fit into __u8 though.
>>>
>>
>> Paragraph 4.7 of that spec, indicates the "sample" precision:
>> 8-bit for baseline; 8-bit or 12-bit for extended.
>>
>> For the quantization coefficients, the DQT segment contains a bit
>> that indicates if the quantization coefficients are 8-bit or 16-bit.
>> See B.2.4.1 for details.

See below (and Tq which follows the Pq field)

>>
>>> However there can be four sets of tables in non-baseline JPEG and it's
>>
>> You lost me here, which four sets of tables are you refering to?
>>
>>> not clear (to me) whether 12-bit JPEG would need more precision (I'd
>>> guess it would).
>>
>> It seems it would. From B.2.4.1:
>>
>> "An 8-bit DCT-based process shall not use a 16-bit precision quantization table."
>>
>>> Since this patch is defining UAPI I think it might be
>>> good to build in some additional information, eg. number of tables,
>>> element size. Maybe this can all be inferred from the selected pixel
>>> format? If so then it would need documented that the above structure
>>> only applies to baseline.
>>>
>>
>> For quantization coefficients, I can only see two tables: one for luma
>> one for chroma. Huffman coefficients are a different story and we are
>> not really adding them here.

I was looking at the definition of Tqi in the frame header in B.2.2 
which seems to allow up to four (sets of?) quantization tables. 
Rereading it, it seems these are per component. Table B.2 implies that 
this applies to Baseline Sequential too. In the DQT marker description 
there's a Tq field to specify the destination for the new table. I think 
this means that an encoder can use up to four (sets of) tables and a 
decoder should be able to store four from the stream.

This may well not be relevant to the encoder under discussion, but if 
it's not allowed for in UAPI it's almost a given that it'll need to be 
added later.

BTW, my copy of the spec is dated 1993(E). Maybe it's out of date?

> 
> Since (if I understand this correctly) we would need u16 for extended precision
> JPEG, shouldn't we use u16 instead of u8? That makes the control more generic.

This seems like a safer option to me.

Regards,
Ian

> 
> BTW, are the coefficients always unsigned? I think so, but I never read the
> JPEG spec.
> 
> Regards,
> 
> 	Hans
> 
>>
>> Thanks,
>> Eze
>>
> 
