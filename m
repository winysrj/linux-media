Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:42098 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbeHQNPU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Aug 2018 09:15:20 -0400
Subject: Re: [PATCH v2 5/6] media: Add controls for jpeg quantization tables
To: Tomasz Figa <tfiga@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
References: <20180802200010.24365-1-ezequiel@collabora.com>
 <20180802200010.24365-6-ezequiel@collabora.com>
 <CAAFQd5C4jTfdB5Zmk6LQwTOBB2hs14ensZ+J-ZdTcQzzBNKn0A@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f91a8099-9780-1b90-dfed-23b07668cb27@xs4all.nl>
Date: Fri, 17 Aug 2018 12:12:22 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5C4jTfdB5Zmk6LQwTOBB2hs14ensZ+J-ZdTcQzzBNKn0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/08/18 04:10, Tomasz Figa wrote:
> Hi Ezequiel,
> 
> On Fri, Aug 3, 2018 at 5:00 AM Ezequiel Garcia <ezequiel@collabora.com> wrote:
>>
>> From: Shunqian Zheng <zhengsq@rock-chips.com>
>>
>> Add V4L2_CID_JPEG_LUMA/CHROMA_QUANTIZATION controls to allow userspace
>> configure the JPEG quantization tables.
>>
>> Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
>> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
>> ---
>>  Documentation/media/uapi/v4l/extended-controls.rst | 9 +++++++++
>>  drivers/media/v4l2-core/v4l2-ctrls.c               | 4 ++++
>>  include/uapi/linux/v4l2-controls.h                 | 3 +++
>>  3 files changed, 16 insertions(+)
> 
> Thanks for this series and sorry for being late with review. Please
> see my comments inline.
> 
>>
>> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
>> index 9f7312bf3365..80e26f81900b 100644
>> --- a/Documentation/media/uapi/v4l/extended-controls.rst
>> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
>> @@ -3354,6 +3354,15 @@ JPEG Control IDs
>>      Specify which JPEG markers are included in compressed stream. This
>>      control is valid only for encoders.
>>
>> +.. _jpeg-quant-tables-control:
>> +
>> +``V4L2_CID_JPEG_LUMA_QUANTIZATION (__u8 matrix)``
>> +    Sets the luma quantization table to be used for encoding
>> +    or decoding a V4L2_PIX_FMT_JPEG_RAW format buffer. This table is
>> +    expected to be in JPEG zigzag order, as per the JPEG specification.
> 
> Should we also specify this to be 8x8?
> 
>> +
>> +``V4L2_CID_JPEG_CHROMA_QUANTIZATION (__u8 matrix)``
>> +    Sets the chroma quantization table.
>>
> 
> nit: I guess we aff something like
> 
> "See also V4L2_CID_JPEG_LUMA_QUANTIZATION for details."
> 
> to avoid repeating the V4L2_PIX_FMT_JPEG_RAW and zigzag order bits? Or
> maybe just repeating is better?
> 
>>
>>  .. flat-table::
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index 599c1cbff3b9..5c62c3101851 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -999,6 +999,8 @@ const char *v4l2_ctrl_get_name(u32 id)
>>         case V4L2_CID_JPEG_RESTART_INTERVAL:    return "Restart Interval";
>>         case V4L2_CID_JPEG_COMPRESSION_QUALITY: return "Compression Quality";
>>         case V4L2_CID_JPEG_ACTIVE_MARKER:       return "Active Markers";
>> +       case V4L2_CID_JPEG_LUMA_QUANTIZATION:   return "Luminance Quantization Matrix";
>> +       case V4L2_CID_JPEG_CHROMA_QUANTIZATION: return "Chrominance Quantization Matrix";
>>
>>         /* Image source controls */
>>         /* Keep the order of the 'case's the same as in v4l2-controls.h! */
>> @@ -1284,6 +1286,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>>                 *flags |= V4L2_CTRL_FLAG_READ_ONLY;
>>                 break;
>>         case V4L2_CID_DETECT_MD_REGION_GRID:
>> +       case V4L2_CID_JPEG_LUMA_QUANTIZATION:
>> +       case V4L2_CID_JPEG_CHROMA_QUANTIZATION:
> 
> It looks like with this setup, the driver has to explicitly set dims
> to { 8, 8 } and min/max to 0/255.
> 
> At least for min and max, we could set them here. For dims, i don't
> see it handled in generic code, so I guess we can leave it to the
> driver now and add move into generic code, if another driver shows up.
> Hans, what do you think?

I noticed this when reviewing. I have a slight preference for setting the
dims and min/max in the core. It's pretty standard how this should behave
after all.

Regards,

	Hans
