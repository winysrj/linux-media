Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:36678 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752505AbdGYPgl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 11:36:41 -0400
Received: by mail-wr0-f180.google.com with SMTP id y43so120687922wrd.3
        for <linux-media@vger.kernel.org>; Tue, 25 Jul 2017 08:36:40 -0700 (PDT)
Subject: Re: [PATCH v3 17/23] camss: vfe: Add interface for scaling
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
 <1500287629-23703-18-git-send-email-todor.tomov@linaro.org>
 <20170720152003.34jm4hwhgejy2rsy@valkosipuli.retiisi.org.uk>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <1025d572-a7cd-727e-4bf4-330a2b1fc7b8@linaro.org>
Date: Tue, 25 Jul 2017 18:36:36 +0300
MIME-Version: 1.0
In-Reply-To: <20170720152003.34jm4hwhgejy2rsy@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for review.

On 20.07.2017 18:20, Sakari Ailus wrote:
> Hi Todor,
> 
> On Mon, Jul 17, 2017 at 01:33:43PM +0300, Todor Tomov wrote:
>> Add compose selection ioctls to handle scaling configuration.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 189 ++++++++++++++++++++-
>>  drivers/media/platform/qcom/camss-8x16/camss-vfe.h |   1 +
>>  2 files changed, 188 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
>> index 327f158..8ec6ce7 100644
>> --- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
>> +++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
>> @@ -211,6 +211,8 @@
>>  #define CAMIF_TIMEOUT_SLEEP_US 1000
>>  #define CAMIF_TIMEOUT_ALL_US 1000000
>>  
>> +#define SCALER_RATIO_MAX 16
>> +
>>  static const u32 vfe_formats[] = {
>>  	MEDIA_BUS_FMT_UYVY8_2X8,
>>  	MEDIA_BUS_FMT_VYUY8_2X8,
>> @@ -1905,6 +1907,25 @@ __vfe_get_format(struct vfe_line *line,
>>  	return &line->fmt[pad];
>>  }
>>  
>> +/*
>> + * __vfe_get_compose - Get pointer to compose selection structure
>> + * @line: VFE line
>> + * @cfg: V4L2 subdev pad configuration
>> + * @which: TRY or ACTIVE format
>> + *
>> + * Return pointer to TRY or ACTIVE compose rectangle structure
>> + */
>> +static struct v4l2_rect *
>> +__vfe_get_compose(struct vfe_line *line,
>> +		  struct v4l2_subdev_pad_config *cfg,
>> +		  enum v4l2_subdev_format_whence which)
>> +{
>> +	if (which == V4L2_SUBDEV_FORMAT_TRY)
>> +		return v4l2_subdev_get_try_compose(&line->subdev, cfg,
>> +						   MSM_VFE_PAD_SINK);
>> +
>> +	return &line->compose;
>> +}
>>  
>>  /*
>>   * vfe_try_format - Handle try format by pad subdev method
>> @@ -1951,7 +1972,14 @@ static void vfe_try_format(struct vfe_line *line,
>>  		*fmt = *__vfe_get_format(line, cfg, MSM_VFE_PAD_SINK,
>>  					 which);
>>  
>> -		if (line->id == VFE_LINE_PIX)
>> +		if (line->id == VFE_LINE_PIX) {
>> +			struct v4l2_rect *rect;
>> +
>> +			rect = __vfe_get_compose(line, cfg, which);
>> +
>> +			fmt->width = rect->width;
>> +			fmt->height = rect->height;
>> +
>>  			switch (fmt->code) {
>>  			case MEDIA_BUS_FMT_YUYV8_2X8:
>>  				if (code == MEDIA_BUS_FMT_YUYV8_1_5X8)
>> @@ -1979,6 +2007,7 @@ static void vfe_try_format(struct vfe_line *line,
>>  					fmt->code = MEDIA_BUS_FMT_VYUY8_2X8;
>>  				break;
>>  			}
>> +		}
>>  
>>  		break;
>>  	}
>> @@ -1987,6 +2016,50 @@ static void vfe_try_format(struct vfe_line *line,
>>  }
>>  
>>  /*
>> + * vfe_try_compose - Handle try compose selection by pad subdev method
>> + * @line: VFE line
>> + * @cfg: V4L2 subdev pad configuration
>> + * @rect: pointer to v4l2 rect structure
>> + * @which: wanted subdev format
>> + */
>> +static void vfe_try_compose(struct vfe_line *line,
>> +			    struct v4l2_subdev_pad_config *cfg,
>> +			    struct v4l2_rect *rect,
>> +			    enum v4l2_subdev_format_whence which)
>> +{
>> +	struct v4l2_mbus_framefmt *fmt;
>> +
>> +	rect->width = rect->width - rect->left;
>> +	rect->left = 0;
> 
> This is the compose rectangle i.e. left and top should be zero (unless it's
> about composing on e.g. a frame buffer). No need to decrement from width;
> similarly for height below.

Yes, it is not composing, but does the user know that? If left and top are
set, it makes sense to keep the rectangle size unchanged I think - actually
decrement width and height (and then clear left and top).

> 
>> +	rect->height = rect->height - rect->top;
>> +	rect->top = 0;
>> +
>> +	fmt = __vfe_get_format(line, cfg, MSM_VFE_PAD_SINK, which);
>> +
>> +	if (rect->width > fmt->width)
>> +		rect->width = fmt->width;
>> +
>> +	if (rect->height > fmt->height)
>> +		rect->height = fmt->height;
>> +
>> +	if (fmt->width > rect->width * SCALER_RATIO_MAX)
>> +		rect->width = (fmt->width + SCALER_RATIO_MAX - 1) /
>> +							SCALER_RATIO_MAX;
>> +
>> +	rect->width &= ~0x1;
>> +
>> +	if (fmt->height > rect->height * SCALER_RATIO_MAX)
>> +		rect->height = (fmt->height + SCALER_RATIO_MAX - 1) /
>> +							SCALER_RATIO_MAX;
>> +
>> +	if (rect->width < 16)
>> +		rect->width = 16;
>> +
>> +	if (rect->height < 4)
>> +		rect->height = 4;
>> +}
>> +

<snip>

-- 
Best regards,
Todor Tomov
