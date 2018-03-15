Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:41237 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751619AbeCOJ3h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 05:29:37 -0400
Received: by mail-wr0-f193.google.com with SMTP id f14so7475995wre.8
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2018 02:29:37 -0700 (PDT)
References: <20180313113311.8617-3-rui.silva@linaro.org> <201803150338.2LzbxAYM%fengguang.wu@intel.com>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: Re: [PATCH v3 2/2] media: ov2680: Add Omnivision OV2680 sensor driver
In-reply-to: <201803150338.2LzbxAYM%fengguang.wu@intel.com>
Date: Thu, 15 Mar 2018 09:29:33 +0000
Message-ID: <m3a7v98z5u.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
On Wed 14 Mar 2018 at 19:39, kbuild test robot wrote:
> Hi Rui,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on v4.16-rc4]
> [cannot apply to next-20180314]
> [if your patch is applied to the wrong git tree, please drop us 
> a note to help improve the system]
>
> url: 
> https://github.com/0day-ci/linux/commits/Rui-Miguel-Silva/media-Introduce-Omnivision-OV2680-driver/20180315-020617
> config: sh-allmodconfig (attached as .config)
> compiler: sh4-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
> reproduce:
>         wget 
>         https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross 
>         -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=sh 
>
> All errors (new ones prefixed by >>):
>
>    drivers/media/i2c/ov2680.c: In function 'ov2680_set_fmt':
>>> drivers/media/i2c/ov2680.c:713:9: error: implicit declaration 
>>> of function 'v4l2_find_nearest_size'; did you mean 
>>> 'v4l2_find_nearest_format'? 
>>> [-Werror=implicit-function-declaration]
>      mode = v4l2_find_nearest_size(ov2680_mode_data,
>             ^~~~~~~~~~~~~~~~~~~~~~
>             v4l2_find_nearest_format

As requested by maintainer this series depend on this patch [0], 
which
introduce this macro. I am not sure of the status of that patch 
though.

---
Cheers,
	Rui

[0] https://patchwork.kernel.org/patch/10207087/

>>> drivers/media/i2c/ov2680.c:714:41: error: 'width' undeclared 
>>> (first use in this function)
>               ARRAY_SIZE(ov2680_mode_data), width,
>                                             ^~~~~
>    drivers/media/i2c/ov2680.c:714:41: note: each undeclared 
>    identifier is reported only once for each function it appears 
>    in
>>> drivers/media/i2c/ov2680.c:715:11: error: 'height' undeclared 
>>> (first use in this function); did you mean 'hweight8'?
>               height, fmt->width, fmt->height);
>               ^~~~~~
>               hweight8
>    cc1: some warnings being treated as errors
>
> vim +713 drivers/media/i2c/ov2680.c
>
>    693	
>    694	static int ov2680_set_fmt(struct v4l2_subdev *sd,
>    695				  struct 
>    v4l2_subdev_pad_config *cfg,
>    696				  struct 
>    v4l2_subdev_format *format)
>    697	{
>    698		struct ov2680_dev *sensor = 
>    to_ov2680_dev(sd);
>    699		struct v4l2_mbus_framefmt *fmt = 
>    &format->format;
>    700		const struct ov2680_mode_info *mode;
>    701		int ret = 0;
>    702	
>    703		if (format->pad != 0)
>    704			return -EINVAL;
>    705	
>    706		mutex_lock(&sensor->lock);
>    707	
>    708		if (sensor->is_streaming) {
>    709			ret = -EBUSY;
>    710			goto unlock;
>    711		}
>    712	
>  > 713		mode = 
>  > v4l2_find_nearest_size(ov2680_mode_data,
>  > 714 
>  > ARRAY_SIZE(ov2680_mode_data), width,
>  > 715					      height, 
>  > fmt->width, fmt->height);
>    716		if (!mode) {
>    717			ret = -EINVAL;
>    718			goto unlock;
>    719		}
>    720	
>    721		if (format->which == 
>    V4L2_SUBDEV_FORMAT_TRY) {
>    722			fmt = 
>    v4l2_subdev_get_try_format(sd, cfg, 0);
>    723	
>    724			*fmt = format->format;
>    725			goto unlock;
>    726		}
>    727	
>    728		fmt->width = mode->width;
>    729		fmt->height = mode->height;
>    730		fmt->code = sensor->fmt.code;
>    731		fmt->colorspace = sensor->fmt.colorspace;
>    732	
>    733		sensor->current_mode = mode;
>    734		sensor->fmt = format->format;
>    735		sensor->mode_pending_changes = true;
>    736	
>    737	unlock:
>    738		mutex_unlock(&sensor->lock);
>    739	
>    740		return ret;
>    741	}
>    742	
>
> ---
> 0-DAY kernel test infrastructure                Open Source 
> Technology Center
> https://lists.01.org/pipermail/kbuild-all 
> Intel Corporation
