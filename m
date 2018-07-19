Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:32924 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727459AbeGSMdS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 08:33:18 -0400
Subject: Re: [PATCH 1/3] media: Add JPEG_RAW format
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Shunqian Zheng <zhengsq@rock-chips.com>
References: <20180705172819.5588-1-ezequiel@collabora.com>
 <20180705172819.5588-2-ezequiel@collabora.com>
 <454afcf7-6047-5c32-3a57-05d32383bf1c@xs4all.nl>
Message-ID: <79b7c550-f90c-5286-4804-b54aaecd55ca@xs4all.nl>
Date: Thu, 19 Jul 2018 13:50:25 +0200
MIME-Version: 1.0
In-Reply-To: <454afcf7-6047-5c32-3a57-05d32383bf1c@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/18/18 11:51, Hans Verkuil wrote:
> On 05/07/18 19:28, Ezequiel Garcia wrote:
>> From: Shunqian Zheng <zhengsq@rock-chips.com>
>>
>> Add V4L2_PIX_FMT_JPEG_RAW format that does not contain
>> JPEG header in the output frame.
>>
>> Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
>> ---
>>  Documentation/media/uapi/v4l/pixfmt-compressed.rst | 5 +++++
>>  drivers/media/v4l2-core/v4l2-ioctl.c               | 1 +
>>  include/uapi/linux/videodev2.h                     | 1 +
>>  3 files changed, 7 insertions(+)
>>
>> diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
>> index abec03937bb3..ebfc3cb7399c 100644
>> --- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
>> +++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
>> @@ -23,6 +23,11 @@ Compressed Formats
>>        - 'JPEG'
>>        - TBD. See also :ref:`VIDIOC_G_JPEGCOMP <VIDIOC_G_JPEGCOMP>`,
>>  	:ref:`VIDIOC_S_JPEGCOMP <VIDIOC_G_JPEGCOMP>`.
>> +    * .. _V4L2-PIX-FMT-JPEG-RAW:
>> +
>> +      - ``V4L2_PIX_FMT_JPEG_RAW``
>> +      - 'Raw JPEG'
>> +      - JPEG without any headers.
>>      * .. _V4L2-PIX-FMT-MPEG:
>>  
>>        - ``V4L2_PIX_FMT_MPEG``
>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
>> index dd210067151f..9f0c76ec7c2c 100644
>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>> @@ -1259,6 +1259,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>>  		/* Max description length mask:	descr = "0123456789012345678901234567890" */
>>  		case V4L2_PIX_FMT_MJPEG:	descr = "Motion-JPEG"; break;
>>  		case V4L2_PIX_FMT_JPEG:		descr = "JFIF JPEG"; break;
>> +		case V4L2_PIX_FMT_JPEG_RAW:	descr = "Raw JPEG"; break;
>>  		case V4L2_PIX_FMT_DV:		descr = "1394"; break;
>>  		case V4L2_PIX_FMT_MPEG:		descr = "MPEG-1/2/4"; break;
>>  		case V4L2_PIX_FMT_H264:		descr = "H.264"; break;
> 
> You missed one more case: JPEG_RAW should also set the COMPRESSED flag.

Sorry, ignore this. This is actually correct.

Regards,

	Hans
