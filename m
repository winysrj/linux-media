Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61750 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab3KTNr2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Nov 2013 08:47:28 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWK007W9EAWYW70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Nov 2013 13:47:25 +0000 (GMT)
Message-id: <528CBD6C.7010801@samsung.com>
Date: Wed, 20 Nov 2013 14:47:24 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH 14/16] s5p-jpeg: Synchronize
 V4L2_CID_JPEG_CHROMA_SUBSAMPLING control value
References: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
 <1384871228-6648-15-git-send-email-j.anaszewski@samsung.com>
 <528B79E1.6050102@xs4all.nl>
In-reply-to: <528B79E1.6050102@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/19/2013 03:46 PM, Hans Verkuil wrote:
> On 11/19/2013 03:27 PM, Jacek Anaszewski wrote:
>> When output queue fourcc is set to any flavour of YUV,
>> the V4L2_CID_JPEG_CHROMA_SUBSAMPLING control value as
>> well as its in-driver cached counterpart have to be
>> updated with the subsampling property of the format
>> so as to be able to provide correct information to the
>> user space and preclude setting an illegal subsampling
>> mode for Exynos4x12 encoder.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>   drivers/media/platform/s5p-jpeg/jpeg-core.c |    5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
>> index 319be0c..d4db612 100644
>> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
>> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
>> @@ -1038,6 +1038,7 @@ static int s5p_jpeg_try_fmt_vid_out(struct file *file, void *priv,
>>   {
>>   	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
>>   	struct s5p_jpeg_fmt *fmt;
>> +	struct v4l2_control ctrl_subs;
>>
>>   	fmt = s5p_jpeg_find_format(ctx, f->fmt.pix.pixelformat,
>>   						FMT_TYPE_OUTPUT);
>> @@ -1048,6 +1049,10 @@ static int s5p_jpeg_try_fmt_vid_out(struct file *file, void *priv,
>>   		return -EINVAL;
>>   	}
>>
>> +	ctrl_subs.id = V4L2_CID_JPEG_CHROMA_SUBSAMPLING;
>> +	ctrl_subs.value = fmt->subsampling;
>> +	v4l2_s_ctrl(priv, &ctx->ctrl_handler, &ctrl_subs);
>
> TRY_FMT should never have side-effects, so this isn't the correct
> way of implementing this.

I am aware of it, but I couldn't have found more suitable place
for implementing this. Below is the rationale standing behind
such an implementation:

   - Exynos4x12 device doesn't generate an eoc interrupt if the
     subsampling property of an output queue format is lower than the
     target jpeg subsampling (e.g. V4L2_PIX_FMT_YUYV [4:2:2 subsampling]
     and JPEG 4:4:4)
   - It should be possible to inform the user space application that the
     subsampling it wants to set is not supported with the current output
     queue fourcc.
   - It is possible that after calling S_EXT_CTRLS the application
     will call S_FMT on output queue with different fourcc which will
     change the allowed scope of JPEG subsampling settings. Let's assume
     the following flow of ioctls:
       - S_FMT V4L2_PIX_FMT_YUYV (4:2:2)
       - S_EXT_CTRLS V4L2_JPEG_CHROMA_SUBSAMPLING_422
       - S_FMT V4L2_PIX_FMT_YUV420
     Now the JPEG subsampling set is illegal as 4:2:2 is lower than 4:2:0
     (lower refers here to the lower number of luma samples assigned
     to the single chroma sample). It is evident now that the change
     of output queue fourcc entails change of the allowed scope of JPEG
     subsampling settings. The way I implemented it reflects this
     constraint precisely. We could go for adjusting the JPEG subsampling
     e.g. in the device_run callback but the user space application
     wouldn't know about it unless it called G_EXT_CTRLS ioctl after end
     of conversion.

In view of the above it is clear that calling S_FMT in this case HAS
side effect no matter whether we take it into account in the driver
implementation or not. Nevertheless maybe there is some more elegant
way of handling this problem I am not aware of. I am open to any
interesting ideas.

Regards,
Jacek Anaszewski


> Also, don't use v4l2_s_ctrl, instead use v4l2_ctrl_s_ctrl. The v4l2_s_ctrl
> function is for core framework use only, not for use in drivers.
>
> Regards,
>
> 	Hans
>
>> +
>>   	return vidioc_try_fmt(f, fmt, ctx, FMT_TYPE_OUTPUT);
>>   }
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

