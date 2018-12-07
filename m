Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9185C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 14:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8923F20837
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 14:38:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8923F20837
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbeLGOi3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 09:38:29 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:43261 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725998AbeLGOi2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 09:38:28 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id VHGngqB3dQMWUVHGrgwwKl; Fri, 07 Dec 2018 15:38:25 +0100
Subject: Re: [PATCH v2] [RFC v2] v4l2: add support for colorspace conversion
 for video capture
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, kernel@pengutronix.de,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180905170932.14370-1-p.zabel@pengutronix.de>
 <2cf2e7e5-f79a-4717-a04f-87eff7d8f3e6@xs4all.nl>
 <20181207123003.6218ce55@coco.lan>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1520e077-2f7d-dc2f-a4f4-5a085048c828@xs4all.nl>
Date:   Fri, 7 Dec 2018 15:38:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20181207123003.6218ce55@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNvB4K2pS7CW7rZKFZSGqGeVkUPzH1KuygJLbUQQBfUEg1MAqwfCAw/ogsQD5rmqcfIP5IoI6DzRJ+1NnrgLZRnqRqPY019dbUTR+rPwpblfi0bST+KA
 8eugsIcWAWcHvP+Sd0YjIzKiE0VjFsYQL7fUc8x9XpcJ3QusQ4dgLsGn/tEwJrSRXbtG8EtdgDCa9Hs48ZmkMan/d8muiUqTf5AXJBRUdJQ20PAPOXLzEx6g
 L1sG5t+Kdb/aZ7t1YxOx5w1ziehniw9/fk7LFwSaLMzn4TBcuv431z8OA6ANqTIzqsgop+4R6JAzZDlONAaaNg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/07/2018 03:30 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 6 Sep 2018 11:02:28 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> Hi Philipp,
>>
>> It is much appreciated that this old RFC of mine is picked up again.
>> I always wanted to get this in, but I never had a driver where it would
>> make sense to do so.
> 
> What's the status of this?

Changes were requested, and there was some discussion. I'm basically
waiting for an update.

I've delegated it to me.

Regards,

	Hans

> 
> Hans,
> As this is an old RFC from you, I'll delegate it to you at patchwork,
> for you to track it.
> 
> Regards,
> Mauro
> 
>>
>> On 09/05/2018 07:09 PM, Philipp Zabel wrote:
>>> For video capture it is the driver that reports the colorspace,  
>>
>> add: "transfer function,"
>>
>>> Y'CbCr/HSV encoding and quantization range used by the video, and there
>>> is no way to request something different, even though many HDTV
>>> receivers have some sort of colorspace conversion capabilities.
>>>
>>> For output video this feature already exists since the application
>>> specifies this information for the video format it will send out, and
>>> the transmitter will enable any available CSC if a format conversion has
>>> to be performed in order to match the capabilities of the sink.
>>>
>>> For video capture we propose adding new pix_format flags:
>>> V4L2_PIX_FMT_FLAG_CSC_COLORSPACE, V4L2_PIX_FMT_FLAG_CSC_YCBCR_ENC,
>>> V4L2_PIX_FMT_FLAG_CSC_HSV_ENC, V4L2_PIX_FMT_FLAG_CSC_QUANTIZATION, and
>>> V4L2_PIX_FMT_FLAG_CSC_XFER_FUNC. These are set by the driver to indicate
>>> its conversion features. When set by the application, the driver will
>>> interpret the colorspace, ycbcr_enc/hsv_enc, quantization and xfer_func
>>> fields as the requested colorspace information and will attempt to do
>>> the conversion it supports.
>>>
>>> Drivers do not have to actually look at the flags: if the flags are not
>>> set, then the colorspace, ycbcr_enc and quantization fields are set to
>>> the default values by the core, i.e. just pass on the received format
>>> without conversion.  
>>
>> Thinking about this some more, I don't think this is quite the right approach.
>> Having userspace set these flags with S_FMT if they want to do explicit
>> conversions makes sense, and that part we can keep.
>>
>> But to signal the capabilities I think should be done via new flags for
>> VIDIOC_ENUM_FMT. Basically the same set of flags, but for the flags field
>> of struct v4l2_fmtdesc.
>>
>> One thing that's not clear to me is what happens if userspace sets one or
>> more flags and calls S_FMT for a driver that doesn't support this. Are the
>> flags zeroed in that case upon return? I don't think so, but I think that
>> is already true for the existing flag V4L2_PIX_FMT_FLAG_PREMUL_ALPHA.
>>
>> I wonder if V4L2_PIX_FMT_FLAG_PREMUL_ALPHA should also get an equivalent
>> flag for v4l2_fmtdesc.
>>
>> Then we can just document that v4l2_format flags are only valid if they
>> are also defined in v4l2_fmtdesc.
>>
>> Does anyone have better ideas for this?
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>> Signed-off-by: Hans Verkuil <Hans Verkuil@cisco.com>
>>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>>> ---
>>> Changes since v1 [1]
>>>  - convert to rst
>>>  - split V4L2_PIX_FMT_FLAG_REQUEST_CSC into four separate flags for
>>>    colorspace, ycbcr_enc/hsv_enc, quantization, and xfer_func
>>>  - let driver set flags to indicate supported features
>>>
>>> [1] https://patchwork.linuxtv.org/patch/28847/
>>> ---
>>>  .../media/uapi/v4l/pixfmt-reserved.rst        | 41 +++++++++++++++++++
>>>  .../media/uapi/v4l/pixfmt-v4l2-mplane.rst     | 16 ++------
>>>  Documentation/media/uapi/v4l/pixfmt-v4l2.rst  | 37 ++++++++++++++---
>>>  drivers/media/v4l2-core/v4l2-ioctl.c          | 12 ++++++
>>>  include/uapi/linux/videodev2.h                |  5 +++
>>>  5 files changed, 94 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/Documentation/media/uapi/v4l/pixfmt-reserved.rst b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
>>> index 38af1472a4b4..c1090027626c 100644
>>> --- a/Documentation/media/uapi/v4l/pixfmt-reserved.rst
>>> +++ b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
>>> @@ -261,3 +261,44 @@ please make a proposal on the linux-media mailing list.
>>>  	by RGBA values (128, 192, 255, 128), the same pixel described with
>>>  	premultiplied colors would be described by RGBA values (64, 96,
>>>  	128, 128)
>>> +    * - ``V4L2_PIX_FMT_FLAG_CSC_COLORSPACE``
>>> +      - 0x00000002
>>> +      - Set by the driver to indicate colorspace conversion support. Set by the
>>> +	application to request conversion to the specified colorspace. It is
>>> +	only used for capture and is ignored for output streams. If set by the
>>> +	application, then request the driver to do colorspace conversion from
>>> +	the received colorspace to the requested colorspace by setting the
>>> +	``colorspace`` field of struct :c:type:`v4l2_pix_format`.
>>> +    * - ``V4L2_PIX_FMT_FLAG_CSC_YCBCR_ENC``
>>> +      - 0x00000004
>>> +      - Set by the driver to indicate Y'CbCr encoding conversion support. Set
>>> +	by the application to request conversion to the specified Y'CbCr
>>> +	encoding.  It is only used for capture and is ignored for output
>>> +	streams. If set by the application, then request the driver to convert
>>> +	from the received Y'CbCr encoding to the requested encoding by setting
>>> +	the ``ycbcr_enc`` field of struct :c:type:`v4l2_pix_format`.
>>> +    * - ``V4L2_PIX_FMT_FLAG_CSC_HSV_ENC``
>>> +      - 0x00000004
>>> +      - Set by the driver to indicate HSV encoding conversion support. Set
>>> +	by the application to request conversion to the specified HSV encoding.
>>> +	It is only used for capture and is ignored for output streams. If set
>>> +	by the application, then request the driver to convert from the
>>> +	received HSV encoding to the requested encoding by setting the
>>> +	``hsv_enc`` field of struct :c:type:`v4l2_pix_format`.
>>> +    * - ``V4L2_PIX_FMT_FLAG_CSC_QUANTIZATION``
>>> +      - 0x00000008
>>> +      - Set by the driver to indicate quantization range conversion support.
>>> +	Set by the application to request conversion to the specified
>>> +	quantization range. It is only used for capture and is ignored for
>>> +	output streams. If set by the application, then request the driver to
>>> +	convert from the received quantization range to the requested
>>> +	quantization by setting the ``quantization`` field of struct
>>> +	:c:type:`v4l2_pix_format`.
>>> +    * - ``V4L2_PIX_FMT_FLAG_CSC_XFER_FUNC``
>>> +      - 0x00000010
>>> +      - Set by the driver to indicate transfer function conversion support.
>>> +	Set by the application to request conversion to the specified transfer
>>> +	function. It is only used for capture and is ignored for output
>>> +	streams. If set by the application, then request the driver to convert
>>> +	from the received transfer function to the requested transfer function
>>> +	by setting the ``xfer_func`` field of struct :c:type:`v4l2_pix_format`.
>>> diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
>>> index ef52f637d8e9..7ff07411db77 100644
>>> --- a/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
>>> +++ b/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
>>> @@ -81,30 +81,22 @@ describing all planes of that format.
>>>      * - __u8
>>>        - ``ycbcr_enc``
>>>        - Y'CbCr encoding, from enum :c:type:`v4l2_ycbcr_encoding`.
>>> -        This information supplements the ``colorspace`` and must be set by
>>> -	the driver for capture streams and by the application for output
>>> -	streams, see :ref:`colorspaces`.
>>> +	See struct :c:type:`v4l2_pix_format`.
>>>      * - __u8
>>>        - ``hsv_enc``
>>>        - HSV encoding, from enum :c:type:`v4l2_hsv_encoding`.
>>> -        This information supplements the ``colorspace`` and must be set by
>>> -	the driver for capture streams and by the application for output
>>> -	streams, see :ref:`colorspaces`.
>>> +	See struct :c:type:`v4l2_pix_format`.
>>>      * - }
>>>        -
>>>        -
>>>      * - __u8
>>>        - ``quantization``
>>>        - Quantization range, from enum :c:type:`v4l2_quantization`.
>>> -        This information supplements the ``colorspace`` and must be set by
>>> -	the driver for capture streams and by the application for output
>>> -	streams, see :ref:`colorspaces`.
>>> +	See struct :c:type:`v4l2_pix_format`.
>>>      * - __u8
>>>        - ``xfer_func``
>>>        - Transfer function, from enum :c:type:`v4l2_xfer_func`.
>>> -        This information supplements the ``colorspace`` and must be set by
>>> -	the driver for capture streams and by the application for output
>>> -	streams, see :ref:`colorspaces`.
>>> +	See struct :c:type:`v4l2_pix_format`.
>>>      * - __u8
>>>        - ``reserved[7]``
>>>        - Reserved for future extensions. Should be zeroed by drivers and
>>> diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
>>> index 826f2305da01..932b6a546e61 100644
>>> --- a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
>>> +++ b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
>>> @@ -88,7 +88,12 @@ Single-planar format structure
>>>        - Image colorspace, from enum :c:type:`v4l2_colorspace`.
>>>          This information supplements the ``pixelformat`` and must be set
>>>  	by the driver for capture streams and by the application for
>>> -	output streams, see :ref:`colorspaces`.
>>> +	output streams, see :ref:`colorspaces`. If the application sets the
>>> +	flag ``V4L2_PIX_FMT_FLAG_CSC_COLORSPACE`` then the application can set
>>> +	this field for a capture stream to request a specific colorspace for
>>> +	the captured image data. The driver will attempt to do colorspace
>>> +	conversion to the specified colorspace or return the colorspace it will
>>> +	use if it can't do the conversion.
>>>      * - __u32
>>>        - ``priv``
>>>        - This field indicates whether the remaining fields of the
>>> @@ -126,13 +131,25 @@ Single-planar format structure
>>>        - Y'CbCr encoding, from enum :c:type:`v4l2_ycbcr_encoding`.
>>>          This information supplements the ``colorspace`` and must be set by
>>>  	the driver for capture streams and by the application for output
>>> -	streams, see :ref:`colorspaces`.
>>> +	streams, see :ref:`colorspaces`. If the application sets the
>>> +	flag ``V4L2_PIX_FMT_FLAG_CSC_YCBCR_ENC`` then the application can set
>>> +	this field for a capture stream to request a specific Y'CbCr encoding
>>> +	for the captured image data. The driver will attempt to do the
>>> +	conversion to the specified Y'CbCr encoding or return the encoding it
>>> +	will use if it can't do the conversion. This field is ignored for
>>> +	non-Y'CbCr pixelformats.
>>>      * - __u32
>>>        - ``hsv_enc``
>>>        - HSV encoding, from enum :c:type:`v4l2_hsv_encoding`.
>>>          This information supplements the ``colorspace`` and must be set by
>>>  	the driver for capture streams and by the application for output
>>> -	streams, see :ref:`colorspaces`.
>>> +	streams, see :ref:`colorspaces`. If the application sets the flag
>>> +	``V4L2_PIX_FMT_FLAG_CSC_HSV_ENC`` then the application can set this
>>> +	field for a capture stream to request a specific HSV encoding for the
>>> +	captured image data. The driver will attempt to do the conversion to
>>> +	the specified HSV encoding or return the encoding it will use if it
>>> +	can't do the conversion. This field is ignored for non-HSV
>>> +	pixelformats.
>>>      * - }
>>>        -
>>>        -
>>> @@ -141,10 +158,20 @@ Single-planar format structure
>>>        - Quantization range, from enum :c:type:`v4l2_quantization`.
>>>          This information supplements the ``colorspace`` and must be set by
>>>  	the driver for capture streams and by the application for output
>>> -	streams, see :ref:`colorspaces`.
>>> +	streams, see :ref:`colorspaces`. If the application sets the flag
>>> +	``V4L2_PIX_FMT_FLAG_CSC_QUANTIZATION`` then the application can set
>>> +	this field for a capture stream to request a specific quantization
>>> +	range for the captured image data. The driver will attempt to do the
>>> +	conversion to the specified quantization range or return the
>>> +	quantization it will use if it can't do the conversion.
>>>      * - __u32
>>>        - ``xfer_func``
>>>        - Transfer function, from enum :c:type:`v4l2_xfer_func`.
>>>          This information supplements the ``colorspace`` and must be set by
>>>  	the driver for capture streams and by the application for output
>>> -	streams, see :ref:`colorspaces`.
>>> +	streams, see :ref:`colorspaces`. If the application sets the flag
>>> +	``V4L2_PIX_FMT_FLAG_CSC_XFER_FUNC`` then the application can set
>>> +	this field for a capture stream to request a specific transfer function
>>> +	for the captured image data. The driver will attempt to do the
>>> +	conversion to the specified transfer function or return the transfer
>>> +	function it will use if it can't do the conversion.
>>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
>>> index 54afc9c7ee6e..39def068f13e 100644
>>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>>> @@ -1019,6 +1019,18 @@ static void v4l_sanitize_format(struct v4l2_format *fmt)
>>>  	 * isn't used by applications.
>>>  	 */
>>>  
>>> +	if (fmt->type == V4L2_BUF_TYPE_VIDEO_CAPTURE ||
>>> +	    fmt->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>>> +		if (!(fmt->fmt.pix.flags & V4L2_PIX_FMT_FLAG_CSC_COLORSPACE))
>>> +			fmt->fmt.pix.colorspace = V4L2_COLORSPACE_DEFAULT;
>>> +		if (!(fmt->fmt.pix.flags & V4L2_PIX_FMT_FLAG_CSC_YCBCR_ENC))
>>> +			fmt->fmt.pix.ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
>>> +		if (!(fmt->fmt.pix.flags & V4L2_PIX_FMT_FLAG_CSC_QUANTIZATION))
>>> +			fmt->fmt.pix.quantization = V4L2_QUANTIZATION_DEFAULT;
>>> +		if (!(fmt->fmt.pix.flags & V4L2_PIX_FMT_FLAG_CSC_XFER_FUNC))
>>> +			fmt->fmt.pix.xfer_func = V4L2_XFER_FUNC_DEFAULT;
>>> +	}
>>> +
>>>  	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
>>>  	    fmt->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
>>>  		return;
>>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>>> index 622f0479d668..4cbc8f23b828 100644
>>> --- a/include/uapi/linux/videodev2.h
>>> +++ b/include/uapi/linux/videodev2.h
>>> @@ -709,6 +709,11 @@ struct v4l2_pix_format {
>>>  
>>>  /* Flags */
>>>  #define V4L2_PIX_FMT_FLAG_PREMUL_ALPHA	0x00000001
>>> +#define V4L2_PIX_FMT_FLAG_CSC_COLORSPACE	0x00000002
>>> +#define V4L2_PIX_FMT_FLAG_CSC_YCBCR_ENC		0x00000004
>>> +#define V4L2_PIX_FMT_FLAG_CSC_HSV_ENC		0x00000004
>>> +#define V4L2_PIX_FMT_FLAG_CSC_QUANTIZATION	0x00000008
>>> +#define V4L2_PIX_FMT_FLAG_CSC_XFER_FUNC		0x00000010
>>>  
>>>  /*
>>>   *	F O R M A T   E N U M E R A T I O N
>>>   
>>
> 
> 
> 
> Thanks,
> Mauro
> 

