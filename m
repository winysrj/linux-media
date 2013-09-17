Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:37808 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3IQKLD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Sep 2013 06:11:03 -0400
MIME-Version: 1.0
In-Reply-To: <52363487.6010408@gmail.com>
References: <1378991371-24428-1-git-send-email-shaik.ameer@samsung.com>
	<1378991371-24428-3-git-send-email-shaik.ameer@samsung.com>
	<52363487.6010408@gmail.com>
Date: Tue, 17 Sep 2013 15:40:59 +0530
Message-ID: <CAOD6ATpg8M9M=b+8czdVo+oUA2iVFXdvBUTVPOKncBr2Bzac6Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] [media] exynos-scaler: Add core functionality for
 the SCALER driver
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	posciak@google.com, Inki Dae <inki.dae@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the comments.

On Mon, Sep 16, 2013 at 3:58 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Shaik,
>
> Thanks for addressing my comments, it really looks much better now.
> I have few more comments, mostly minor issues.

[...]

>> +
>> +const struct scaler_fmt *scaler_find_fmt(u32 *pixelformat,
>> +                               u32 *mbus_code, u32 index)
>> +{
>> +       const struct scaler_fmt *fmt, *def_fmt = NULL;
>> +       unsigned int i;
>> +
>> +       if (index>= ARRAY_SIZE(scaler_formats))
>> +               return NULL;
>> +
>> +       for (i = 0; i<  ARRAY_SIZE(scaler_formats); ++i) {
>> +               fmt = scaler_get_format(i);
>> +               if (pixelformat&&  fmt->pixelformat == *pixelformat)
>> +                       return fmt;
>
>
>> +               if (mbus_code&&  fmt->mbus_code == *mbus_code)
>> +                       return fmt;
>
>
> is mbus_code ever used ?

Yes. Currently not used. Will remove this field for now..

>
>> +               if (index == i)
>> +                       def_fmt = fmt;
>> +       }
>> +
>> +       return def_fmt;
>> +}

[...]

>> +
>> +int scaler_try_fmt_mplane(struct scaler_ctx *ctx, struct v4l2_format *f)
>> +{
>> +       struct scaler_dev *scaler = ctx->scaler_dev;
>> +       struct device *dev =&scaler->pdev->dev;
>>
>> +       struct scaler_variant *variant = scaler->variant;
>> +       struct v4l2_pix_format_mplane *pix_mp =&f->fmt.pix_mp;
>>

[...]

>> +
>> +       /*
>> +        * Nothing mentioned about the colorspace in SCALER. Default value
>> is
>> +        * set to V4L2_COLORSPACE_REC709.
>> +        */
>
>
> Isn't scaler_hw_set_csc_coef() function configuring the colorspace ?

Actually speaking this function should do the color space setting part.
What the SCALER ip supports is CSC offset value for Y

YCbCr to RGB : Zero offset of -16 offset for input
RGB to YCbCr : Zero offset of +16 offset for output

I think user should provide this information through some controls.
Anyways, will take it later.

>
>> +       pix_mp->colorspace = V4L2_COLORSPACE_REC709;
>> +
>> +       for (i = 0; i<  pix_mp->num_planes; ++i) {
>> +               int bpl = (pix_mp->width * fmt->depth[i])>>  3;
>> +               pix_mp->plane_fmt[i].bytesperline = bpl;
>> +               pix_mp->plane_fmt[i].sizeimage = bpl * pix_mp->height;
>> +
>> +               scaler_dbg(scaler, "[%d]: bpl: %d, sizeimage: %d",
>> +                               i, bpl, pix_mp->plane_fmt[i].sizeimage);
>> +       }
>> +
>> +       return 0;
>> +}
>> +

[...]

>> +static int scaler_runtime_resume(struct device *dev)
>> +{
>> +       struct scaler_dev *scaler = dev_get_drvdata(dev);
>> +       int ret = 0;
>> +       scaler_dbg(scaler, "state: 0x%lx", scaler->state);
>> +
>> +       ret = clk_enable(scaler->clock);
>> +       if (ret<  0)
>> +               return ret;
>> +
>> +       scaler_sw_reset(scaler);
>> +
>> +       return scaler_m2m_resume(scaler);
>
>
> Shouldn't there be clk_disable() when this function fails ?

this funciton scaler_m2m_resume() never fails.


Regards,
Shaik Ameer Basha
