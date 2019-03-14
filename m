Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3911C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 13:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF30F2184C
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 13:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfCNNLL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 09:11:11 -0400
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:54161 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726786AbfCNNLL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 09:11:11 -0400
Received: from [IPv6:2001:420:44c1:2579:e8a7:494:d652:7065] ([IPv6:2001:420:44c1:2579:e8a7:494:d652:7065])
        by smtp-cloud9.xs4all.net with ESMTPA
        id 4Q8WhgPY0I8AW4Q8ahjWoD; Thu, 14 Mar 2019 14:11:09 +0100
Subject: Re: [RFC PATCH] media/doc: Allow sizeimage to be set by v4l clients
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
References: <20190116123701.10344-1-stanimir.varbanov@linaro.org>
 <299e8aeb-6deb-b383-8f63-cf2cbf5d2e9f@xs4all.nl>
 <adecdc4e-1aed-fc33-b14b-083322797c70@linaro.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c103b0d8-0020-17e0-4584-e5c3ca6bbc51@xs4all.nl>
Date:   Thu, 14 Mar 2019 14:11:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <adecdc4e-1aed-fc33-b14b-083322797c70@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNDkJ5evP5sBZWMgZyXh26c5RxV10K9mYOgGtfEhfvmUEuJq5UWoXIsiGetaHLoAhaoGHr7mMwhStLptAbLwI4nOtndjyhahk5GTSe5KHIwCGzJLJjDj
 QqDePI2GezC5MnOJ/gr4mGx/+WC6JFvxZFz4kd0kDkopN4h27pAHbiefYTt9kl2/pihMaiHVN3LXSHvKTZ/RbLJYVmvwFjGPCJpzPyEtfLS+CYvfIZ4kwPFt
 dR8aebEmzrusmZ9H0BMHbFZXLfqJsJNHw8CTpArThwJcaB9usrJw1QOLfipYZfLQPCnnMsmbEWY9rHvolFN/Jp0Kn6kcy3f/mr+vwOs0W4UGLZNDUMm95NV2
 0AaWVSjSOzfRwQGg62I0TkIHQzAJ2/OwrxpvP2sAAmaPTzd2NIY/A2BBmYPic9FY5XCNMaxetnQc6RLyERq4p1LInuqcBVwbxRVQIBFf4gOnWsnruOVMW1/0
 tfVQUb9A8p3me4Jus5uw6eKKsecVLP7sDafERqbLr5mZcVkIBVsuZKK/K6d1+0OgkZOA3xp1qCgNLqdpcfmxv4yE/hv8QvwAxVlY7g==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/21/19 11:48 AM, Stanimir Varbanov wrote:
> Hi Hans,
> 
> On 1/18/19 11:13 AM, Hans Verkuil wrote:
>> On 1/16/19 1:37 PM, Stanimir Varbanov wrote:
>>> This changes v4l2_pix_format and v4l2_plane_pix_format sizeimage
>>> field description to allow v4l clients to set bigger image size
>>> in case of variable length compressed data.
>>>
>>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>>> ---
>>>  Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst | 5 ++++-
>>>  Documentation/media/uapi/v4l/pixfmt-v4l2.rst        | 3 ++-
>>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
>>> index 7f82dad9013a..dbe0b74e9ba4 100644
>>> --- a/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
>>> +++ b/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
>>> @@ -30,7 +30,10 @@ describing all planes of that format.
>>>  
>>>      * - __u32
>>>        - ``sizeimage``
>>> -      - Maximum size in bytes required for image data in this plane.
>>> +      - Maximum size in bytes required for image data in this plane,
>>> +        set by the driver. When the image consists of variable length
>>> +        compressed data this is the maximum number of bytes required
>>> +        to hold an image, and it is allowed to be set by the client.
>>>      * - __u32
>>>        - ``bytesperline``
>>>        - Distance in bytes between the leftmost pixels in two adjacent
>>> diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
>>> index 71eebfc6d853..54b6d2b67bd7 100644
>>> --- a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
>>> +++ b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
>>> @@ -89,7 +89,8 @@ Single-planar format structure
>>>        - Size in bytes of the buffer to hold a complete image, set by the
>>>  	driver. Usually this is ``bytesperline`` times ``height``. When
>>>  	the image consists of variable length compressed data this is the
>>> -	maximum number of bytes required to hold an image.
>>> +	maximum number of bytes required to hold an image, and it is
>>> +	allowed to be set by the client.
>>>      * - __u32
>>>        - ``colorspace``
>>>        - Image colorspace, from enum :c:type:`v4l2_colorspace`.
>>>
>>
>> Hmm. "maximum number of bytes required to hold an image": that's not actually true
>> for bitstream formats like MPEG. It's just the size of the buffer used to store the
>> bitstream, i.e. one buffer may actually contain multiple compressed images, or a
>> compressed image is split over multiple buffers.
>>
> 
> Do you want me to change something in the current documentation, i.e.
> the quoted above?

Hmm, it looks like this discussion stalled (i.e. I forgot to reply).

How about this:

"When the image consists of variable length compressed data this is the
number of bytes required by the encoder to support the worst-case
compression scenario. Clients are allowed to set this field. However,
drivers may ignore the value or modify it."

Regards,

	Hans

> 
>> Only for MJPEG is this statement true since each buffer will contain a single
>> compressed JPEG image.
>>
>> Regards,
>>
>> 	Hans
>>
> 

