Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42746
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750841AbdCANpU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Mar 2017 08:45:20 -0500
Subject: Re: [PATCH v6 2/2] [media] s5p-mfc: Handle 'v4l2_pix_format:field' in
 try_fmt and g_fmt
To: Andrzej Hajda <a.hajda@samsung.com>, linux-kernel@vger.kernel.org
References: <20170301115108.14187-1-thibault.saunier@osg.samsung.com>
 <CGME20170301115141epcas2p37801b1fbe0951cc37a4e01bf2bcae3da@epcas2p3.samsung.com>
 <20170301115108.14187-3-thibault.saunier@osg.samsung.com>
 <33dbd3fa-04b2-3d94-5163-0a10589ff1c7@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>
From: Thibault Saunier <thibault.saunier@osg.samsung.com>
Message-ID: <770085b3-8411-a000-7d68-3cb2c88d560b@osg.samsung.com>
Date: Wed, 1 Mar 2017 10:20:27 -0300
MIME-Version: 1.0
In-Reply-To: <33dbd3fa-04b2-3d94-5163-0a10589ff1c7@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,


On 03/01/2017 10:12 AM, Andrzej Hajda wrote:
> On 01.03.2017 12:51, Thibault Saunier wrote:
>> It is required by the standard that the field order is set by the
>> driver, default to NONE in case any is provided, but we can basically
>> accept any value provided by the userspace as we will anyway not
>> be able to do any deinterlacing.
>>
>> In this patch we also make sure to pass the interlacing mode provided
>> by userspace from the output to the capture side of the device so
>> that the information is given back to userspace. This way it can
>> handle it and potentially deinterlace afterward.
> As I wrote previously:
> - on output side you have encoded bytestream - you cannot say about
> interlacing in such case, so the only valid value is NONE,
Well, the encoded stream contains the info about interlacing and
the most logical thing to do from my point of view is to keep that info
passe it along to the capture side, which is what I am doing.
What makes you think this is not the right way of handling that?
> - on capture side you have decoded frames, and in this case it depends
> on the device and driver capabilities, if the driver/device does not
> support (de-)interlacing (I suppose this is MFC case), interlace type
> field should be filled according to decoded bytestream header (on output
> side), but no direct copying from output side!!!
Well, why? If the userspace has already parsed the headers and passed the
info to the decoder, there is no reason we should pass along that info 
to the
capture side.

Currently the bitstream parser in the decoder does not seem to take of
the interlacing properly so if userspace specified it because it already 
parsed the
stream or the info was in the container not in the codec bitstream, then 
using
it is very sensible I think!!!

Regards,

Thibault
>
> Regards
> Andrzej
>
>> Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>
>>
>> ---
>>
>> Changes in v6:
>> - Pass user output field value to the capture as the device is not
>>    doing any deinterlacing and thus decoded content will still be
>>    interlaced on the output.
>>
>> Changes in v5:
>> - Just adapt the field and never error out.
>>
>> Changes in v4: None
>> Changes in v3:
>> - Do not check values in the g_fmt functions as Andrzej explained in previous review
>>
>> Changes in v2:
>> - Fix a silly build error that slipped in while rebasing the patches
>>
>>   drivers/media/platform/s5p-mfc/s5p_mfc_common.h | 2 ++
>>   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    | 6 +++++-
>>   2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> index ab23236aa942..3816a37de4bc 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> @@ -652,6 +652,8 @@ struct s5p_mfc_ctx {
>>   	size_t me_buffer_size;
>>   	size_t tmv_buffer_size;
>>   
>> +	enum v4l2_field field;
>> +
>>   	enum v4l2_mpeg_mfc51_video_force_frame_type force_frame_type;
>>   
>>   	struct list_head ref_queue;
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>> index 367ef8e8dbf0..6e5ca86fb331 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>> @@ -345,7 +345,7 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
>>   		   rectangle. */
>>   		pix_mp->width = ctx->buf_width;
>>   		pix_mp->height = ctx->buf_height;
>> -		pix_mp->field = V4L2_FIELD_NONE;
>> +		pix_mp->field = ctx->field;
>>   		pix_mp->num_planes = 2;
>>   		/* Set pixelformat to the format in which MFC
>>   		   outputs the decoded frame */
>> @@ -380,6 +380,9 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
>>   	struct s5p_mfc_dev *dev = video_drvdata(file);
>>   	struct s5p_mfc_fmt *fmt;
>>   
>> +	if (f->fmt.pix.field == V4L2_FIELD_ANY)
>> +		f->fmt.pix.field = V4L2_FIELD_NONE;
>> +
>>   	mfc_debug(2, "Type is %d\n", f->type);
>>   	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>>   		fmt = find_format(f, MFC_FMT_DEC);
>> @@ -436,6 +439,7 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
>>   		goto out;
>>   	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>>   		/* src_fmt is validated by call to vidioc_try_fmt */
>> +		ctx->field = f->fmt.pix.field;
>>   		ctx->src_fmt = find_format(f, MFC_FMT_DEC);
>>   		ctx->codec_mode = ctx->src_fmt->codec_mode;
>>   		mfc_debug(2, "The codec number is: %d\n", ctx->codec_mode);
>
