Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:43159 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753017AbeFGH1X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Jun 2018 03:27:23 -0400
Subject: Re: [RFC PATCH 2/2] media: docs-rst: Add encoder UAPI specification
 to Codec Interfaces
To: Tomasz Figa <tfiga@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        todor.tomov@linaro.org, nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20180605103328.176255-1-tfiga@chromium.org>
 <20180605103328.176255-3-tfiga@chromium.org>
 <1528199628.4074.15.camel@pengutronix.de>
 <CAAFQd5DYu+Oehr1UUvvdmWk7toO0i_=NFgvZcAKQ8ZURKy51fA@mail.gmail.com>
 <1528208578.4074.19.camel@pengutronix.de>
 <CAAFQd5DqHj65AdzfYmvHWkqHnZntiiA2AhAfgHbLA3AuWvsOTQ@mail.gmail.com>
 <1528278003.3438.3.camel@pengutronix.de>
 <CAAFQd5A2hsgrmwJ3bgv6EDKqqy5Y86CnMcktrWa+YihWGjxtHg@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <41fd04f2-fc44-1792-81e6-a3d4d384adc5@xs4all.nl>
Date: Thu, 7 Jun 2018 09:27:17 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5A2hsgrmwJ3bgv6EDKqqy5Y86CnMcktrWa+YihWGjxtHg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/2018 12:37 PM, Tomasz Figa wrote:
> On Wed, Jun 6, 2018 at 6:40 PM Philipp Zabel <p.zabel@pengutronix.de> wrote:
>>
>> On Wed, 2018-06-06 at 18:17 +0900, Tomasz Figa wrote:
>>> On Tue, Jun 5, 2018 at 11:23 PM Philipp Zabel <p.zabel@pengutronix.de> wrote:
>>>>
>>>> On Tue, 2018-06-05 at 21:31 +0900, Tomasz Figa wrote:
>>>> [...]
>>>>> +Initialization
>>>>>>> +--------------
>>>>>>> +
>>>>>>> +1. (optional) Enumerate supported formats and resolutions. See
>>>>>>> +   capability enumeration.
>>>>>>> +
>>>>>>> +2. Set a coded format on the CAPTURE queue via :c:func:`VIDIOC_S_FMT`
>>>>>>> +
>>>>>>> +   a. Required fields:
>>>>>>> +
>>>>>>> +      i.  type = CAPTURE
>>>>>>> +
>>>>>>> +      ii. fmt.pix_mp.pixelformat set to a coded format to be produced
>>>>>>> +
>>>>>>> +   b. Return values:
>>>>>>> +
>>>>>>> +      i.  EINVAL: unsupported format.
>>>>>>> +
>>>>>>> +      ii. Others: per spec
>>>>>>> +
>>>>>>> +   c. Return fields:
>>>>>>> +
>>>>>>> +      i. fmt.pix_mp.width, fmt.pix_mp.height should be 0.
>>>>>>> +
>>>>>>> +   .. note::
>>>>>>> +
>>>>>>> +      After a coded format is set, the set of raw formats
>>>>>>> +      supported as source on the OUTPUT queue may change.
>>>>>>
>>>>>> So setting CAPTURE potentially also changes OUTPUT format?
>>>>>
>>>>> Yes, but at this point userspace hasn't yet set the desired format.
>>>>>
>>>>>> If the encoded stream supports colorimetry information, should that
>>>>>> information be taken from the CAPTURE queue?
>>>>>
>>>>> What's colorimetry? Is it something that is included in
>>>>> v4l2_pix_format(_mplane)? Is it something that can vary between raw
>>>>> input and encoded output?
>>>>
>>>> FTR, yes, I meant the colorspace, ycbcr_enc, quantization, and xfer_func
>>>> fields of the v4l2_pix_format(_mplane) structs. GStreamer uses the term
>>>> "colorimetry" to pull these fields together into a single parameter.
>>>>
>>>> The codecs usually don't care at all about this information, except some
>>>> streams (such as h.264 in the VUI parameters section of the SPS header)
>>>> may optionally contain a representation of these fields, so it may be
>>>> desirable to let encoders write the configured colorimetry or to let
>>>> decoders return the detected colorimetry via G_FMT(CAP) after a source
>>>> change event.
>>>>
>>>> I think it could be useful to enforce the same colorimetry on CAPTURE
>>>> and OUTPUT queue if the hardware doesn't do any colorspace conversion.
>>>
>>> After thinking a bit more on this, I guess it wouldn't overly
>>> complicate things if we require that the values from OUTPUT queue are
>>> copied to CAPTURE queue, if the stream doesn't include such
>>> information or the hardware just can't parse them.
>>
>> And for encoders it would be copied from CAPTURE queue to OUTPUT queue?
>>
> 
> I guess iy would be from OUTPUT to CAPTURE for encoders as well, since
> the colorimetry of OUTPUT is ultimately defined by the raw frames that
> userspace is going to be feeding to the encoder.

Correct. All mem2mem drivers should just copy the colorimetry from the
output buffers to the capture buffers, unless the decoder hardware is able to
extract that data from the stream, in which case it can overwrite it for
the capture buffer.

Currently colorspace converters are not supported since the V4L2 API does
not provide a way to let userspace define colorimetry for the capture queue.
I have a patch to add a new v4l2_format flag for that since forever, but
since we do not have any drivers that can do this in the kernel it has never
been upstreamed.

What is supported is basic RGB <-> YUV conversions since that's selected through
the provided pixelformat.

Regards,

	Hans
