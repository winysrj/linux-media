Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38052 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754527AbcHVQDf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 12:03:35 -0400
Received: by mail-wm0-f47.google.com with SMTP id o80so152247898wme.1
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2016 09:03:35 -0700 (PDT)
Subject: Re: [PATCH 2/8] media: vidc: adding core part and helper functions
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1471871619-25873-1-git-send-email-stanimir.varbanov@linaro.org>
 <1471871619-25873-3-git-send-email-stanimir.varbanov@linaro.org>
 <416fe812-5ea9-0191-d744-e5706606ea45@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <d1a0c77b-d85e-206e-0cba-ce915a53bffb@linaro.org>
Date: Mon, 22 Aug 2016 19:03:25 +0300
MIME-Version: 1.0
In-Reply-To: <416fe812-5ea9-0191-d744-e5706606ea45@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the express comments!

<cut>

>> +
>> +struct vidc_core {
>> +	struct list_head list;
>> +	void __iomem *base;
>> +	int irq;
>> +	struct clk *clks[VIDC_CLKS_NUM_MAX];
>> +	struct mutex lock;
>> +	struct hfi_core hfi;
>> +	struct video_device vdev_dec;
>> +	struct video_device vdev_enc;
> 
> I know that many drivers embed struct video_device, but this can cause subtle
> refcounting problems. I recommend changing this to a pointer and using video_device_alloc().
> 
> I have plans to reorganize the way video_devices are allocated and registered in
> the near future, and you might just as well prepare this driver for that by switching
> to a pointer.

OK, thanks for the info, I will change to pointers.

<cut>

>> +
>> +int vidc_set_color_format(struct vidc_inst *inst, u32 type, u32 pixfmt)
>> +{
>> +	struct hfi_uncompressed_format_select fmt;
>> +	struct hfi_core *hfi = &inst->core->hfi;
>> +	u32 ptype = HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SELECT;
>> +	int ret;
>> +
>> +	fmt.buffer_type = type;
>> +
>> +	switch (pixfmt) {
>> +	case V4L2_PIX_FMT_NV12:
>> +		fmt.format = HFI_COLOR_FORMAT_NV12;
>> +		break;
>> +	case V4L2_PIX_FMT_NV21:
>> +		fmt.format = HFI_COLOR_FORMAT_NV21;
>> +		break;
>> +	default:
>> +		return -ENOTSUPP;
> 
> I'm not really sure how this error code is used, but normally -EINVAL is returned
> for invalid pixel formats. -ENOTSUPP is not used by V4L2.
> 

you are right, I need to change this to EINVAL.

-- 
regards,
Stan
