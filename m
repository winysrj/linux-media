Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f41.google.com ([209.85.212.41]:64442 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab3HFNtT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 09:49:19 -0400
MIME-Version: 1.0
In-Reply-To: <51FE6C86.1010906@gmail.com>
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com>
	<1375455762-22071-10-git-send-email-arun.kk@samsung.com>
	<51FE6C86.1010906@gmail.com>
Date: Tue, 6 Aug 2013 19:19:15 +0530
Message-ID: <CALt3h7_xnYMW6-oGU0i_0c_ByUYZLYz2uK85EgiaDOebtmKazg@mail.gmail.com>
Subject: Re: [RFC v3 09/13] [media] exynos5-fimc-is: Add the hardware pipeline control
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sun, Aug 4, 2013 at 8:30 PM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Arun,
>
> On 08/02/2013 05:02 PM, Arun Kumar K wrote:
>>
>> This patch adds the crucial hardware pipeline control for the
>> fimc-is driver. All the subdev nodes will call this pipeline
>> interfaces to reach the hardware. Responsibilities of this module
>> involves configuring and maintaining the hardware pipeline involving
>> multiple sub-ips like ISP, DRC, Scalers, ODC, 3DNR, FD etc.
>>
>> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
>> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
>> ---

[snip]


>> +static int fimc_is_pipeline_isp_setparams(struct fimc_is_pipeline
>> *pipeline,
>> +               unsigned int enable)
>> +{
>> +       struct isp_param *isp_param =&pipeline->is_region->parameter.isp;
>> +       struct fimc_is *is = pipeline->is;
>> +       unsigned int indexes, lindex, hindex;
>> +       unsigned int sensor_width, sensor_height, scc_width, scc_height;
>> +       unsigned int crop_x, crop_y, isp_width, isp_height;
>> +       unsigned int sensor_ratio, output_ratio;
>> +       int ret;
>> +
>> +       /* Crop calculation */
>> +       sensor_width = pipeline->sensor_width;
>> +       sensor_height = pipeline->sensor_height;
>> +       scc_width = pipeline->scaler_width[SCALER_SCC];
>> +       scc_height = pipeline->scaler_height[SCALER_SCC];
>> +       isp_width = sensor_width;
>> +       isp_height = sensor_height;
>> +       crop_x = crop_y = 0;
>> +
>> +       sensor_ratio = sensor_width * 1000 / sensor_height;
>> +       output_ratio = scc_width * 1000 / scc_height;
>> +
>> +       if (sensor_ratio == output_ratio) {
>> +               isp_width = sensor_width;
>> +               isp_height = sensor_height;
>> +       } else if (sensor_ratio<  output_ratio) {
>> +               isp_height = (sensor_width * scc_height) / scc_width;
>> +               isp_height = ALIGN(isp_height, 2);
>> +               crop_y = ((sensor_height - isp_height)>>  1)&  0xFFFFFFFE;
>
>
> nit: Use ~1U instead of 0xFFFFFFFE.
>
>
>> +       } else {
>> +               isp_width = (sensor_height * scc_width) / scc_height;
>> +               isp_width = ALIGN(isp_width, 4);
>> +               crop_x =  ((sensor_width - isp_width)>>  1)&  0xFFFFFFFE;
>
>
> Ditto.
>
>> +       }
>> +       pipeline->isp_width = isp_width;
>> +       pipeline->isp_height = isp_height;
>> +
>> +       indexes = hindex = lindex = 0;
>> +
>> +       isp_param->otf_output.cmd = OTF_OUTPUT_COMMAND_ENABLE;
>> +       isp_param->otf_output.width = pipeline->sensor_width;
>> +       isp_param->otf_output.height = pipeline->sensor_height;
>> +       isp_param->otf_output.format = OTF_OUTPUT_FORMAT_YUV444;
>> +       isp_param->otf_output.bitwidth = OTF_OUTPUT_BIT_WIDTH_12BIT;
>> +       isp_param->otf_output.order = OTF_INPUT_ORDER_BAYER_GR_BG;
>> +       lindex |= LOWBIT_OF(PARAM_ISP_OTF_OUTPUT);
>> +       hindex |= HIGHBIT_OF(PARAM_ISP_OTF_OUTPUT);
>> +       indexes++;
>
>
> All right, let's stop this hindex/lindex/indexes madness. I've already
> commented on that IIRC. Nevertheless, this should be replaced with proper
> bitmap operations. A similar issue has been fixed in commit
>
>
>> +       isp_param->dma1_output.cmd = DMA_OUTPUT_COMMAND_DISABLE;
>> +       lindex |= LOWBIT_OF(PARAM_ISP_DMA1_OUTPUT);
>> +       hindex |= HIGHBIT_OF(PARAM_ISP_DMA1_OUTPUT);
>> +       indexes++;
>> +
>> +       isp_param->dma2_output.cmd = DMA_OUTPUT_COMMAND_DISABLE;
>> +       lindex |= LOWBIT_OF(PARAM_ISP_DMA2_OUTPUT);
>> +       hindex |= HIGHBIT_OF(PARAM_ISP_DMA2_OUTPUT);
>> +       indexes++;
>> +
>> +       if (enable)
>> +               isp_param->control.bypass = CONTROL_BYPASS_DISABLE;
>> +       else
>> +               isp_param->control.bypass = CONTROL_BYPASS_ENABLE;
>> +       isp_param->control.cmd = CONTROL_COMMAND_START;
>> +       isp_param->control.run_mode = 1;
>> +       lindex |= LOWBIT_OF(PARAM_ISP_CONTROL);
>> +       hindex |= HIGHBIT_OF(PARAM_ISP_CONTROL);
>> +       indexes++;
>> +
>> +       isp_param->dma1_input.cmd = DMA_INPUT_COMMAND_BUF_MNGR;
>> +       isp_param->dma1_input.width = sensor_width;
>> +       isp_param->dma1_input.height = sensor_height;
>> +       isp_param->dma1_input.dma_crop_offset_x = crop_x;
>> +       isp_param->dma1_input.dma_crop_offset_y = crop_y;
>> +       isp_param->dma1_input.dma_crop_width = isp_width;
>> +       isp_param->dma1_input.dma_crop_height = isp_height;
>> +       isp_param->dma1_input.bayer_crop_offset_x = 0;
>> +       isp_param->dma1_input.bayer_crop_offset_y = 0;
>> +       isp_param->dma1_input.bayer_crop_width = 0;
>> +       isp_param->dma1_input.bayer_crop_height = 0;
>> +       isp_param->dma1_input.user_min_frametime = 0;
>> +       isp_param->dma1_input.user_max_frametime = 66666;
>> +       isp_param->dma1_input.wide_frame_gap = 1;
>> +       isp_param->dma1_input.frame_gap = 4096;
>> +       isp_param->dma1_input.line_gap = 45;
>> +       isp_param->dma1_input.order = DMA_INPUT_ORDER_GR_BG;
>> +       isp_param->dma1_input.plane = 1;
>> +       isp_param->dma1_input.buffer_number = 1;
>> +       isp_param->dma1_input.buffer_address = 0;
>> +       isp_param->dma1_input.reserved[1] = 0;
>> +       isp_param->dma1_input.reserved[2] = 0;
>> +       if (pipeline->isp.fmt->fourcc == V4L2_PIX_FMT_SGRBG8)
>> +               isp_param->dma1_input.bitwidth = DMA_INPUT_BIT_WIDTH_8BIT;
>> +       else if (pipeline->isp.fmt->fourcc == V4L2_PIX_FMT_SGRBG10)
>> +               isp_param->dma1_input.bitwidth =
>> DMA_INPUT_BIT_WIDTH_10BIT;
>> +       else
>> +               isp_param->dma1_input.bitwidth =
>> DMA_INPUT_BIT_WIDTH_12BIT;
>> +       lindex |= LOWBIT_OF(PARAM_ISP_DMA1_INPUT);
>> +       hindex |= HIGHBIT_OF(PARAM_ISP_DMA1_INPUT);
>> +       indexes++;
>> +
>> +       lindex = 0xFFFFFFFF;
>> +       hindex = 0xFFFFFFFF;
>
>
> Hmm, is this a workaround for some firmware bug ? You're setting individual
> bits of lindex, hindex only to set them all to 1 just before using those
> variables ? WTH ? :)
>

We set this 0xffffff so that all the init params which are copied
earlier during pipeline_open
are set to the firmware. FW set_param cannot be done after copying of
init params since
FW expects isp params to be set correctly before accepting any other params.
So this is a workaround to force all init values to go along with the
ISP params.

>
> Anyway, instead of doing this:
>
>         lindex |= LOWBIT_OF(A);
>         hindex |= HIGHBIT_OF(A);
>         indexes++;
>
>         lindex |= LOWBIT_OF(B);
>         hindex |= HIGHBIT_OF(B);
>         indexes++;
>
>         ...
>
>         fimc_is_itf_set_param(..., indexes, lindex, hindex);
>
>
> You could do:
>
>         u32 index[2];
>
>         __set_bit(A, index);
>
>         __set_bit(B, index);
>
>         ...
>
>         indexes = hweight32(index[0]);
>         indexes += hweight32(index[1]);
>
>         fimc_is_itf_set_param(..., indexes, index[0], index[1]);
>
> I.e. the bit operations work well with arbitrary length bitmaps.
>

Ok I will use this method.

> BTW, the firmware interface seems pretty odd with it's requirement to
> pass bitmask and number of bits set in this bitmaks separately. Does
> it ever allow 'indexes' to be different than number of bits set in
> lindex, hindex ? What happens in such case ?

Yes. It is working even when indexes is set as 0 !
I will remove that indexes field and use only bitmask.

Regards
Arun
