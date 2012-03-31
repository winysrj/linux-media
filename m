Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37211 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab2CaL4s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Mar 2012 07:56:48 -0400
Received: by wejx9 with SMTP id x9so842282wej.19
        for <linux-media@vger.kernel.org>; Sat, 31 Mar 2012 04:56:46 -0700 (PDT)
Message-ID: <4F76F0FA.2020306@gmail.com>
Date: Sat, 31 Mar 2012 13:56:42 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sunyoung Kang <sy0816.kang@samsung.com>
CC: linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <mchehab@infradead.org>,
	jonghun.han@samsung.com, khw0178.kim@samsung.com,
	sungchun.kang@samsung.com, younglak1004.kim@samsung.com,
	kgene.kim@samsung.com, a.sim@samsung.com
Subject: Re: [PATCH v2] media: rotator: Add new image rotator driver for EXYNOS
References: <001601cd01b8$873dd8c0$95b98a40$%kang@samsung.com> <4F610BC4.4080408@gmail.com> <006e01cd0efa$dce9dfe0$96bd9fa0$%kang@samsung.com>
In-Reply-To: <006e01cd0efa$dce9dfe0$96bd9fa0$%kang@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sunyoung,

On 03/31/2012 06:58 AM, Sunyoung Kang wrote:
> 
> Hi Sylwester
> 
> Thanks for the review.
> God bless you! :)
> 
> 
>> On 03/15/2012 06:21 AM, Sylwester Nawrocki wrote:
>> Hi Sunyoung,
>>
>> thank you for addressing my previous comments. It looks much better now.
>> I have is a few more comments...
>>
>> On 03/14/2012 09:00 AM, Sunyoung Kang wrote:
>>> This patch adds new rotator driver which is a device for
>>> rotation on EXYNOS SoCs.
>>>
>>> This rotator device supports the belows as key feature.
>>>    1) Image format
>>>      : RGB565/888, YUV422 1p, YUV420 2p/3p
>>>    2) rotation
>>>      : 0/90/180/270 and X/Y Flip
>>>
>>> Signed-off-by: Sunyoung Kang<sy0816.kang@samsung.com>
>>> Signed-off-by: Ayoung Sim<a.sim@samsung.com>
...
>>> +static const struct v4l2_ctrl_ops rot_ctrl_ops = {
>>> +	.s_ctrl = rot_s_ctrl,
>>> +};
>>> +
>>> +static int rot_add_ctrls(struct rot_ctx *ctx)
>>> +{
>>> +	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 4);
>>
>> There are only 3 controls, so s/3/4.
>>
> You're right. Just 3 controls are in here.

OK. (I put it wrong though, should have been s/3/4 :/)

>>> +	v4l2_ctrl_new_std(&ctx->ctrl_handler,&rot_ctrl_ops,
>>> +			V4L2_CID_VFLIP, 0, 1, 1, 0);
>>> +	v4l2_ctrl_new_std(&ctx->ctrl_handler,&rot_ctrl_ops,
>>> +			V4L2_CID_HFLIP, 0, 1, 1, 0);
>>> +	v4l2_ctrl_new_std(&ctx->ctrl_handler,&rot_ctrl_ops,
>>> +			V4L2_CID_ROTATE, 0, 270, 90, 0);
>>> +
>>> +	if (ctx->ctrl_handler.error) {
>>> +		int err = ctx->ctrl_handler.error;
>>> +		v4l2_err(&ctx->rot_dev->m2m.v4l2_dev,
>>> +				"v4l2_ctrl_handler_init failed\n");
>>> +		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
>>> +		return err;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
...
>> ...
>>> +static irqreturn_t rot_irq_handler(int irq, void *priv)
>>> +{
>>> +	struct rot_dev *rot = priv;
>>> +	struct rot_ctx *ctx;
>>> +	struct vb2_buffer *src_vb, *dst_vb;
>>> +	unsigned int irq_src;
>>> +
>>> +	spin_lock(&rot->slock);
>>> +
>>> +	clear_bit(DEV_RUN,&rot->state);
>>> +	if (timer_pending(&rot->wdt.timer))
>>> +		del_timer(&rot->wdt.timer);
>>> +
>>> +	rot_hwget_irq_src(rot,&irq_src);
>>> +	rot_hwset_irq_clear(rot,&irq_src);
>>> +
>>> +	if (irq_src != ISR_PEND_DONE) {
>>> +		dev_err(rot->dev, "####################\n");
>>> +		dev_err(rot->dev, "set SFR illegally\n");
>>> +		dev_err(rot->dev, "maybe the result is wrong\n");
>>> +		dev_err(rot->dev, "####################\n");
>>> +		rot_dump_register(rot);
>>> +	}
>>
>> How about following instead:
>>
>> 	if (WARN_ON(irq_src != ISR_PEND_DONE),
>> 	    "Illegal SFR configuration, the result might be wrong\n") {
>> 		rot_dump_register(rot);
>> 	}
>> ?
> Um.. I think, here doesn't need debugging information.
> I'd like to just inform the wrong result.
> But the log message will be changed as your guide.

OK, thanks.

...
>>> +static void rot_m2m_device_run(void *priv)
>>> +{
>>> +	struct rot_ctx *ctx = priv;
>>> +	struct rot_frame *s_frame, *d_frame;
>>> +	struct rot_dev *rot;
>>> +	unsigned long flags, tmp;
>>> +	u32 degree = 0, flip = 0;
>>> +
>>> +	spin_lock_irqsave(&ctx->slock, flags);
>>> +
>>> +	rot = ctx->rot_dev;
>>> +
>>> +	if (test_bit(DEV_RUN,&rot->state)) {
>>> +		dev_err(rot->dev, "Rotator is already in progress\n");
>>> +		goto run_unlock;
>>> +	}
>>> +
>>> +	if (test_bit(DEV_SUSPEND,&rot->state)) {
>>> +		dev_err(rot->dev, "Rotator is in suspend state\n");
>>> +		goto run_unlock;
>>> +	}
>>> +
>>> +	if (test_bit(CTX_ABORT,&ctx->flags)) {
>>> +		rot_dbg("aborted rot device run\n");
>>> +		goto run_unlock;
>>> +	}
>>> +
>>> +	pm_runtime_get_sync(ctx->rot_dev->dev);
>>> +
>>> +	s_frame =&ctx->s_frame;
>>> +	d_frame =&ctx->d_frame;
>>> +
>>> +	/* Configuration rotator registers */
>>> +	rot_hwset_image_format(rot, s_frame->rot_fmt->pixelformat);
>>> +	rot_mapping_flip(ctx,&degree,&flip);
>>> +	rot_hwset_flip(rot, flip);
>>> +	rot_hwset_rotation(rot, degree);
>>> +
>>> +	if (ctx->rotation == 90 || ctx->rotation == 270) {
>>> +		tmp                     = d_frame->pix_mp.height;
>>> +		d_frame->pix_mp.height  = d_frame->pix_mp.width;
>>> +		d_frame->pix_mp.width   = tmp;
>>
>> Do you mean:
>> 		swap(d_frame->pix_mp.height, d_frame->pix_mp.width);
>> ?
>>
>> Does it mean setting rotation to 90 or 270 deg changes the output (capture)
>> format ? Maybe you want to do this swapping on temporary variables, that
>> would be used to configure the hardware ?
>>
>> The rotation is a bit tricky, AFAIK the application should swap width/and
>> height. And the driver should scale an image (change aspect ratio) when
>> width/height isn't swapped and 90/270 deg rotation is set. Or return an
>> error when the device doesn't support resizing.
>>
> 
> Ok. As you mentioned, if the application should know about width/height for output,
>   driver doesn't need to care about it. I'll remove this code.

OK, good.

...
>>> +static int rot_probe(struct platform_device *pdev)
>>> +{
>>> +	struct exynos_rot_driverdata *drv_data;
>>> +	struct rot_dev *rot;
>>> +	struct resource *res;
>>> +	int variant_num, ret = 0;
>>> +
>>> +	dev_info(&pdev->dev, "++%s\n", __func__);
>>> +	drv_data = (struct exynos_rot_driverdata *)
>>> +			platform_get_device_id(pdev)->driver_data;
>>> +
>>> +	if (pdev->id>= drv_data->nr_dev) {
>>> +		dev_err(&pdev->dev, "Invalid platform device id\n");
>>> +		return -EINVAL;
>>> +	}
>>
>> If there is always only one device, is this needed ?
>>
> Now the EXYNOS SoCs have only one rotator device, but the number can be increased in future.
> So I considered about it. Should this be removed including the code related with this?

OK, if you anticipate there might be more device instances in the future SoCs
I'm fine with leaving the code as is.
 
...
>>> +/*
>>> + * struct exynos_rot_size_limit - Rotator variant size  information
>>> + *
>>> + * @min_x: minimum pixel x size
>>> + * @min_y: minimum pixel y size
>>> + * @max_x: maximum pixel x size
>>> + * @max_y: maximum pixel y size

Should there be something like:

@align: horizontal and vertical pixel alignment

?
>>> + */
>>> +struct exynos_rot_size_limit {
>>> +	u32 min_x;
>>> +	u32 min_y;
>>> +	u32 max_x;
>>> +	u32 max_y;
>>> +	u32 align;
>>> +};

--

Regards,
Sylwester
