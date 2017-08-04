Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58778 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751144AbdHEIBn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 Aug 2017 04:01:43 -0400
Subject: Re: [PATCH v3 17/23] camss: vfe: Add interface for scaling
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
 <1500287629-23703-18-git-send-email-todor.tomov@linaro.org>
 <20170720152003.34jm4hwhgejy2rsy@valkosipuli.retiisi.org.uk>
 <1025d572-a7cd-727e-4bf4-330a2b1fc7b8@linaro.org>
From: Sakari Ailus <sakari.ailus@iki.fi>
Message-ID: <64a4dadd-3880-c170-d9fc-e194633c68f0@iki.fi>
Date: Fri, 4 Aug 2017 20:59:16 +0300
MIME-Version: 1.0
In-Reply-To: <1025d572-a7cd-727e-4bf4-330a2b1fc7b8@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

Todor Tomov wrote:
> Hi Sakari,
> 
> Thank you for review.
> 
> On 20.07.2017 18:20, Sakari Ailus wrote:
>> Hi Todor,
>>
>> On Mon, Jul 17, 2017 at 01:33:43PM +0300, Todor Tomov wrote:
>>> Add compose selection ioctls to handle scaling configuration.
>>>
>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>>> ---
>>>  drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 189 ++++++++++++++++++++-
>>>  drivers/media/platform/qcom/camss-8x16/camss-vfe.h |   1 +
>>>  2 files changed, 188 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
>>> index 327f158..8ec6ce7 100644
>>> --- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
>>> +++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
>>> @@ -211,6 +211,8 @@
>>>  #define CAMIF_TIMEOUT_SLEEP_US 1000
>>>  #define CAMIF_TIMEOUT_ALL_US 1000000
>>>  
>>> +#define SCALER_RATIO_MAX 16
>>> +
>>>  static const u32 vfe_formats[] = {
>>>  	MEDIA_BUS_FMT_UYVY8_2X8,
>>>  	MEDIA_BUS_FMT_VYUY8_2X8,
>>> @@ -1905,6 +1907,25 @@ __vfe_get_format(struct vfe_line *line,
>>>  	return &line->fmt[pad];
>>>  }
>>>  
>>> +/*
>>> + * __vfe_get_compose - Get pointer to compose selection structure
>>> + * @line: VFE line
>>> + * @cfg: V4L2 subdev pad configuration
>>> + * @which: TRY or ACTIVE format
>>> + *
>>> + * Return pointer to TRY or ACTIVE compose rectangle structure
>>> + */
>>> +static struct v4l2_rect *
>>> +__vfe_get_compose(struct vfe_line *line,
>>> +		  struct v4l2_subdev_pad_config *cfg,
>>> +		  enum v4l2_subdev_format_whence which)
>>> +{
>>> +	if (which == V4L2_SUBDEV_FORMAT_TRY)
>>> +		return v4l2_subdev_get_try_compose(&line->subdev, cfg,
>>> +						   MSM_VFE_PAD_SINK);
>>> +
>>> +	return &line->compose;
>>> +}
>>>  
>>>  /*
>>>   * vfe_try_format - Handle try format by pad subdev method
>>> @@ -1951,7 +1972,14 @@ static void vfe_try_format(struct vfe_line *line,
>>>  		*fmt = *__vfe_get_format(line, cfg, MSM_VFE_PAD_SINK,
>>>  					 which);
>>>  
>>> -		if (line->id == VFE_LINE_PIX)
>>> +		if (line->id == VFE_LINE_PIX) {
>>> +			struct v4l2_rect *rect;
>>> +
>>> +			rect = __vfe_get_compose(line, cfg, which);
>>> +
>>> +			fmt->width = rect->width;
>>> +			fmt->height = rect->height;
>>> +
>>>  			switch (fmt->code) {
>>>  			case MEDIA_BUS_FMT_YUYV8_2X8:
>>>  				if (code == MEDIA_BUS_FMT_YUYV8_1_5X8)
>>> @@ -1979,6 +2007,7 @@ static void vfe_try_format(struct vfe_line *line,
>>>  					fmt->code = MEDIA_BUS_FMT_VYUY8_2X8;
>>>  				break;
>>>  			}
>>> +		}
>>>  
>>>  		break;
>>>  	}
>>> @@ -1987,6 +2016,50 @@ static void vfe_try_format(struct vfe_line *line,
>>>  }
>>>  
>>>  /*
>>> + * vfe_try_compose - Handle try compose selection by pad subdev method
>>> + * @line: VFE line
>>> + * @cfg: V4L2 subdev pad configuration
>>> + * @rect: pointer to v4l2 rect structure
>>> + * @which: wanted subdev format
>>> + */
>>> +static void vfe_try_compose(struct vfe_line *line,
>>> +			    struct v4l2_subdev_pad_config *cfg,
>>> +			    struct v4l2_rect *rect,
>>> +			    enum v4l2_subdev_format_whence which)
>>> +{
>>> +	struct v4l2_mbus_framefmt *fmt;
>>> +
>>> +	rect->width = rect->width - rect->left;
>>> +	rect->left = 0;
>>
>> This is the compose rectangle i.e. left and top should be zero (unless it's
>> about composing on e.g. a frame buffer). No need to decrement from width;
>> similarly for height below.
> 
> Yes, it is not composing, but does the user know that? If left and top are
> set, it makes sense to keep the rectangle size unchanged I think - actually
> decrement width and height (and then clear left and top).

The API documentation tells these values are zero. If the user specifies
non-zero values then I don't think that they should have an effect. This
behaviour is in line with other drivers AFAIK.

> 
>>
>>> +	rect->height = rect->height - rect->top;
>>> +	rect->top = 0;
>>> +
>>> +	fmt = __vfe_get_format(line, cfg, MSM_VFE_PAD_SINK, which);
>>> +
>>> +	if (rect->width > fmt->width)
>>> +		rect->width = fmt->width;
>>> +
>>> +	if (rect->height > fmt->height)
>>> +		rect->height = fmt->height;
>>> +
>>> +	if (fmt->width > rect->width * SCALER_RATIO_MAX)
>>> +		rect->width = (fmt->width + SCALER_RATIO_MAX - 1) /
>>> +							SCALER_RATIO_MAX;
>>> +
>>> +	rect->width &= ~0x1;
>>> +
>>> +	if (fmt->height > rect->height * SCALER_RATIO_MAX)
>>> +		rect->height = (fmt->height + SCALER_RATIO_MAX - 1) /
>>> +							SCALER_RATIO_MAX;
>>> +
>>> +	if (rect->width < 16)
>>> +		rect->width = 16;
>>> +
>>> +	if (rect->height < 4)
>>> +		rect->height = 4;
>>> +}
>>> +
> 
> <snip>
> 


-- 
Sakari Ailus
sakari.ailus@iki.fi
