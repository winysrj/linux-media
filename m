Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29696 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab0JMIou (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Oct 2010 04:44:50 -0400
Date: Wed, 13 Oct 2010 10:44:46 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 5/6 v5] V4L/DVB: s5p-fimc: Add camera capture support
In-reply-to: <004101cb6a7f$bba53b70$32efb250$%park@samsung.com>
To: Sewoon Park <seuni.park@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com
Message-id: <4CB5717E.7020004@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <1286817993-21558-1-git-send-email-s.nawrocki@samsung.com>
 <1286817993-21558-6-git-send-email-s.nawrocki@samsung.com>
 <004101cb6a7f$bba53b70$32efb250$%park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



On 10/13/2010 04:38 AM, Sewoon Park wrote:
> Hi~ sylwester
> 
> On source code review, they seem to be a good shape.
> I have two comments on this patch.
> 
>> s.nawrocki@samsung.com wrote:
>>
>> Add a video device driver per each FIMC entity to support
>> the camera capture input mode. Video capture node is registered
>> only if CCD sensor data is provided through driver's platfrom data
>> and board setup code.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>  drivers/media/video/s5p-fimc/Makefile       |    2 +-
>>  drivers/media/video/s5p-fimc/fimc-capture.c |  819
>> +++++++++++++++++++++++++++
>>  drivers/media/video/s5p-fimc/fimc-core.c    |  563 +++++++++++++------
>>  drivers/media/video/s5p-fimc/fimc-core.h    |  205 +++++++-
>>  drivers/media/video/s5p-fimc/fimc-reg.c     |  173 +++++-
>>  include/media/s3c_fimc.h                    |   60 ++
>>  6 files changed, 1630 insertions(+), 192 deletions(-)
>>  create mode 100644 drivers/media/video/s5p-fimc/fimc-capture.c
>>  create mode 100644 include/media/s3c_fimc.h
>>
>> diff --git a/drivers/media/video/s5p-fimc/Makefile
>> b/drivers/media/video/s5p-fimc/Makefile
>> index 0d9d541..7ea1b14 100644
>> --- a/drivers/media/video/s5p-fimc/Makefile
>> +++ b/drivers/media/video/s5p-fimc/Makefile
>> @@ -1,3 +1,3 @@
>>
>>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) := s5p-fimc.o
>> -s5p-fimc-y := fimc-core.o fimc-reg.o
>> +s5p-fimc-y := fimc-core.o fimc-reg.o fimc-capture.o
>> diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c
>> b/drivers/media/video/s5p-fimc/fimc-capture.c
>> new file mode 100644
>> index 0000000..e8f13d3
>> --- /dev/null
>> +++ b/drivers/media/video/s5p-fimc/fimc-capture.c
>> @@ -0,0 +1,819 @@

<snip>

>> +
>> +static int fimc_cap_reqbufs(struct file *file, void *priv,
>> +			  struct v4l2_requestbuffers *reqbufs)
>> +{
>> +	struct fimc_ctx *ctx = priv;
>> +	struct fimc_dev *fimc = ctx->fimc_dev;
>> +	struct fimc_vid_cap *cap = &fimc->vid_cap;
>> +	int ret;
>> +
>> +	if (fimc_capture_active(ctx->fimc_dev))
>> +		return -EBUSY;
>> +
>> +	if (mutex_lock_interruptible(&fimc->lock))
>> +		return -ERESTARTSYS;
>> +
>> +	ret = videobuf_reqbufs(&cap->vbq, reqbufs);
> 
> As you know, videobuf framework don't handle about reqbufs.count is zero.
> But, a reqbufs.count value of zero frees all buffers in V4L2 API specification.
> It is better to handle case by zero.

It's true that the current videobuf is not freeing memory when number of
buffers passed to REQBUFS is zero, which is the API requirement. I would like
to avoid any workarounds in the driver for that, it's quite a complex issue
and I am waiting for videobuf2 to get into kernel with introduction of the
memory management related improvements.

> 
>> +	if (!ret)
>> +		cap->reqbufs_count = reqbufs->count;
>> +
>> +	mutex_unlock(&fimc->lock);
>> +	return ret;
>> +}
>> +
>> +static int fimc_cap_querybuf(struct file *file, void *priv,
>> +			   struct v4l2_buffer *buf)
>> +{
>> +	struct fimc_ctx *ctx = priv;
>> +	struct fimc_vid_cap *cap = &ctx->fimc_dev->vid_cap;
>> +
>> +	if (fimc_capture_active(ctx->fimc_dev))
>> +		return -EBUSY;
>> +
>> +	return videobuf_querybuf(&cap->vbq, buf);
>> +}
>> +

<snip>

>> diff --git a/drivers/media/video/s5p-fimc/fimc-core.c
>> b/drivers/media/video/s5p-fimc/fimc-core.c
>> index 85a7e72..064e7d5 100644
>> --- a/drivers/media/video/s5p-fimc/fimc-core.c
>> +++ b/drivers/media/video/s5p-fimc/fimc-core.c
>> @@ -1,7 +1,7 @@
>>  /*
>>   * S5P camera interface (video postprocessor) driver
>>   *
>> - * Copyright (c) 2010 Samsung Electronics
>> + * Copyright (c) 2010 Samsung Electronics Co., Ltd
>>   *
>>   * Sylwester Nawrocki, <s.nawrocki@samsung.com>
>>   *
>> @@ -38,85 +38,102 @@ static struct fimc_fmt fimc_formats[] = {
>>  		.depth	= 16,
>>  		.color	= S5P_FIMC_RGB565,
>>  		.buff_cnt = 1,
>> -		.planes_cnt = 1
>> +		.planes_cnt = 1,
>> +		.mbus_code = V4L2_MBUS_FMT_RGB565_2X8_BE,
>> +		.flags = FMT_FLAGS_M2M,
>>  	}, {
>>  		.name	= "BGR666",
>>  		.fourcc	= V4L2_PIX_FMT_BGR666,
>>  		.depth	= 32,
>>  		.color	= S5P_FIMC_RGB666,
>>  		.buff_cnt = 1,
>> -		.planes_cnt = 1
>> +		.planes_cnt = 1,
>> +		.flags = FMT_FLAGS_M2M,
>>  	}, {
>>  		.name = "XRGB-8-8-8-8, 24 bpp",
>>  		.fourcc	= V4L2_PIX_FMT_RGB24,
>>  		.depth = 32,
>>  		.color	= S5P_FIMC_RGB888,
>>  		.buff_cnt = 1,
>> -		.planes_cnt = 1
>> +		.planes_cnt = 1,
>> +		.flags = FMT_FLAGS_M2M,
>>  	}, {
>>  		.name	= "YUV 4:2:2 packed, YCbYCr",
>>  		.fourcc	= V4L2_PIX_FMT_YUYV,
>>  		.depth	= 16,
>>  		.color	= S5P_FIMC_YCBYCR422,
>>  		.buff_cnt = 1,
>> -		.planes_cnt = 1
>> -		}, {
>> +		.planes_cnt = 1,
>> +		.mbus_code = V4L2_MBUS_FMT_YUYV8_2X8,
>> +		.flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
>> +	}, {
>>  		.name	= "YUV 4:2:2 packed, CbYCrY",
>>  		.fourcc	= V4L2_PIX_FMT_UYVY,
>>  		.depth	= 16,
>>  		.color	= S5P_FIMC_CBYCRY422,
>>  		.buff_cnt = 1,
>> -		.planes_cnt = 1
>> +		.planes_cnt = 1,
>> +		.mbus_code = V4L2_MBUS_FMT_UYVY8_2X8,
>> +		.flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
>>  	}, {
>>  		.name	= "YUV 4:2:2 packed, CrYCbY",
>>  		.fourcc	= V4L2_PIX_FMT_VYUY,
>>  		.depth	= 16,
>>  		.color	= S5P_FIMC_CRYCBY422,
>>  		.buff_cnt = 1,
>> -		.planes_cnt = 1
>> +		.planes_cnt = 1,
>> +		.mbus_code = V4L2_MBUS_FMT_VYUY8_2X8,
>> +		.flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
>>  	}, {
>>  		.name	= "YUV 4:2:2 packed, YCrYCb",
>>  		.fourcc	= V4L2_PIX_FMT_YVYU,
>>  		.depth	= 16,
>>  		.color	= S5P_FIMC_YCRYCB422,
>>  		.buff_cnt = 1,
>> -		.planes_cnt = 1
>> +		.planes_cnt = 1,
>> +		.mbus_code = V4L2_MBUS_FMT_YVYU8_2X8,
>> +		.flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
>>  	}, {
>>  		.name	= "YUV 4:2:2 planar, Y/Cb/Cr",
>>  		.fourcc	= V4L2_PIX_FMT_YUV422P,
>>  		.depth	= 12,
>>  		.color	= S5P_FIMC_YCBCR422,
>>  		.buff_cnt = 1,
>> -		.planes_cnt = 3
>> +		.planes_cnt = 3,
>> +		.flags = FMT_FLAGS_M2M,
>>  	}, {
>>  		.name	= "YUV 4:2:2 planar, Y/CbCr",
>>  		.fourcc	= V4L2_PIX_FMT_NV16,
>>  		.depth	= 16,
>>  		.color	= S5P_FIMC_YCBCR422,
>>  		.buff_cnt = 1,
>> -		.planes_cnt = 2
>> +		.planes_cnt = 2,
>> +		.flags = FMT_FLAGS_M2M,
>>  	}, {
>>  		.name	= "YUV 4:2:2 planar, Y/CrCb",
>>  		.fourcc	= V4L2_PIX_FMT_NV61,
>>  		.depth	= 16,
>>  		.color	= S5P_FIMC_RGB565,
>>  		.buff_cnt = 1,
>> -		.planes_cnt = 2
>> +		.planes_cnt = 2,
>> +		.flags = FMT_FLAGS_M2M,
>>  	}, {
>>  		.name	= "YUV 4:2:0 planar, YCbCr",
>>  		.fourcc	= V4L2_PIX_FMT_YUV420,
>>  		.depth	= 12,
>>  		.color	= S5P_FIMC_YCBCR420,
>>  		.buff_cnt = 1,
>> -		.planes_cnt = 3
>> +		.planes_cnt = 3,
>> +		.flags = FMT_FLAGS_M2M,
>>  	}, {
>>  		.name	= "YUV 4:2:0 planar, Y/CbCr",
>>  		.fourcc	= V4L2_PIX_FMT_NV12,
>>  		.depth	= 12,
>>  		.color	= S5P_FIMC_YCBCR420,
>>  		.buff_cnt = 1,
>> -		.planes_cnt = 2
>> -	}
>> +		.planes_cnt = 2,
>> +		.flags = FMT_FLAGS_M2M,
>> +	},
>>  };
> 
> FIMC h/w also have WriteBack path for input.
> WriteBack is a feature to write LCD frame buffer data into memory, 
> for example TV OUT.
> Your code(in fimc-core.h) already have fimc path for this mode.
> In case WriteBack input mode, FIMC must have V4L2_PIX_FMT_YUV444 format.

Right, it seems like I missed that color format. But as you likely know
the writeback feature needs some control interface at the framebuffer driver as
well. So I would like to add YUV444 format together with that additional
(v4l2-subdev) interface at the framebuffer driver.
This would be a good use case for the new Media Controller framework which is
not yet a part of the kernel and that is also a reason why I am holding on
with introduction of the writeback support.

Thanks,
Sylwester

> 
>>
>>  static struct v4l2_queryctrl fimc_ctrls[] = {
>> @@ -156,7 +173,7 @@ static struct v4l2_queryctrl *get_ctrl(int id)
>>  	return NULL;
>>  }
>>
>> -static int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame
>> *f)
>> +int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f)
>>  {
>>  	if (r->width > f->width) {
>>  		if (f->width > (r->width * SCALER_MAX_HRATIO))
>> @@ -199,7 +216,7 @@ static int fimc_get_scaler_factor(u32 src, u32 tar,
>> u32 *ratio, u32 *shift)
>>  	return 0;
>>  }
>>
>> -static int fimc_set_scaler_info(struct fimc_ctx *ctx)
>> +int fimc_set_scaler_info(struct fimc_ctx *ctx)
>>  {
>>  	struct fimc_scaler *sc = &ctx->scaler;
>>  	struct fimc_frame *s_frame = &ctx->s_frame;
>> @@ -259,6 +276,51 @@ static int fimc_set_scaler_info(struct fimc_ctx *ctx)
>>  	return 0;
>>  }
>>

<snip>

>> diff --git a/include/media/s3c_fimc.h b/include/media/s3c_fimc.h
>> new file mode 100644
>> index 0000000..ca1b673
>> --- /dev/null
>> +++ b/include/media/s3c_fimc.h
>> @@ -0,0 +1,60 @@
>> +/*
>> + * Samsung S5P SoC camera interface driver header
>> + *
>> + * Copyright (c) 2010 Samsung Electronics Co., Ltd
>> + * Author: Sylwester Nawrocki, <s.nawrocki@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef S3C_FIMC_H_
>> +#define S3C_FIMC_H_
>> +
>> +enum cam_bus_type {
>> +	FIMC_ITU_601 = 1,
>> +	FIMC_ITU_656,
>> +	FIMC_MIPI_CSI2,
>> +	FIMC_LCD_WB, /* FIFO link from LCD mixer */
>> +};
>> +
>> +#define FIMC_CLK_INV_PCLK	(1 << 0)
>> +#define FIMC_CLK_INV_VSYNC	(1 << 1)
>> +#define FIMC_CLK_INV_HREF	(1 << 2)
>> +#define FIMC_CLK_INV_HSYNC	(1 << 3)
>> +
>> +struct i2c_board_info;
>> +
>> +/**
>> + * struct s3c_fimc_isp_info - image sensor information required for host
>> + *			      interace configuration.
>> + *
>> + * @board_info: pointer to I2C subdevice's board info
>> + * @bus_type: determines bus type, MIPI, ITU-R BT.601 etc.
>> + * @i2c_bus_num: i2c control bus id the sensor is attached to
>> + * @mux_id: FIMC camera interface multiplexer index (separate for MIPI
>> and ITU)
>> + * @bus_width: camera data bus width in bits
>> + * @flags: flags defining bus signals polarity inversion (High by default)
>> + */
>> +struct s3c_fimc_isp_info {
>> +	struct i2c_board_info *board_info;
>> +	enum cam_bus_type bus_type;
>> +	u16 i2c_bus_num;
>> +	u16 mux_id;
>> +	u16 bus_width;
>> +	u16 flags;
>> +};
>> +
>> +
>> +#define FIMC_MAX_CAMIF_CLIENTS	2
>> +
>> +/**
>> + * struct s3c_platform_fimc - camera host interface platform data
>> + *
>> + * @isp_info: properties of camera sensor required for host interface
>> setup
>> + */
>> +struct s3c_platform_fimc {
>> +	struct s3c_fimc_isp_info *isp_info[FIMC_MAX_CAMIF_CLIENTS];
>> +};
>> +#endif /* S3C_FIMC_H_ */
>> --
> 
> Best regards,
> Seuni.
> --
> Sewoon Park <seuni.park@samsung.com>, Engineer, SW Solution 
> Development Team, Samsung Electronics Co., Ltd.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Sylwester Nawrocki
Linux Platform Group
Samsung Poland R&D Center
