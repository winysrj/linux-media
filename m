Return-Path: <SRS0=5UJH=RM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9363C43381
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 01:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75655204FD
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 01:16:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QyaoFBtu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbfCIBQ2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 20:16:28 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35697 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbfCIBQ2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 20:16:28 -0500
Received: by mail-pf1-f194.google.com with SMTP id j5so15366702pfa.2;
        Fri, 08 Mar 2019 17:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ohcV7zvHWxpNq+r4GJ5Yr/9YHBmrhWhTf8OcMjE1aq0=;
        b=QyaoFBtu3Fz658hKJYO/SHDfArmdQ/5R63O0gQCJS3EhTbgX9oqjwM3rcs7tn+K9TR
         /i81X4P0VrulBQbCdSv8spZ+st1dwyawWttvONbv4/RssTFD0bpKpRYhzWiCgDPkk1ub
         H0KnptkOKfT8olKuWlV5NVXH1l4k5b5Q5+8P/Qp65jLEb3FLFE3CD8rms6SBlD+L1ssp
         TXkNA95TOQaG0bbSbTVvnDBJlBGEF1qY5PkZJI6cx934e8NM/4STBrp3s3itynZHH9EC
         R8dOuFWow12xF/qDX7B3ikfh0EbZjLZKjzhcDE0+qQEYm+CU4I2nKQ4ckkW/Vd+K1owG
         hUDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ohcV7zvHWxpNq+r4GJ5Yr/9YHBmrhWhTf8OcMjE1aq0=;
        b=XoJHC4jGqu0eUMayF/tlmKk6QMtHDioEfMnEvomMNTgsEgBExisnDg/ag/KnUN+6Fa
         OGCF/QITk2XiOwhVE32/D8Ol+Pqg6z8mkOcQs3ww02XL4tac0b+o0JWVL3iaLmPIgYHc
         Ar2pcMJAbMNlt0umo5yUSDQwrZHK78NoFlhBW1ekW8e51DNmaUfUBp5VlTkwLbv8x0Fp
         koE3bEDOLAoe1xw0Rlimhh9AC8CFAof4HxqnWKU7aO3mdYohz3bCQAyO+xhtIdnbMocF
         d4+74rkAS1vgMBmGQwEv654JclrRuyuYNaTGLnySXTH60MxGMImQhwSOAvbmIInrd6Ib
         FpJQ==
X-Gm-Message-State: APjAAAVuwUEKNW6vFxfb6V10RcoLbM3k+LzlERcE+2Y6Jc+Nv7GyS0gG
        Yb2EVD1g9y7w1yHnoxdatAB/k8Sc
X-Google-Smtp-Source: APXvYqxOoJmErALCx05edVDPg5gjJFNpmIEPlkWkuFBZs0CezsGVoIs3PUuDKoaWR7H3A61E7HyKRg==
X-Received: by 2002:a17:902:7614:: with SMTP id k20mr21741935pll.298.1552094186145;
        Fri, 08 Mar 2019 17:16:26 -0800 (PST)
Received: from ?IPv6:2605:e000:d445:6a00:2097:f23b:3b8f:e255? ([2605:e000:d445:6a00:2097:f23b:3b8f:e255])
        by smtp.gmail.com with ESMTPSA id f193sm13024299pgc.3.2019.03.08.17.16.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 17:16:25 -0800 (PST)
Subject: Re: [PATCH v6 3/7] gpu: ipu-v3: ipu-ic: Fully describe colorspace
 conversions
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
References: <20190307233356.23748-1-slongerbeam@gmail.com>
 <20190307233356.23748-4-slongerbeam@gmail.com>
 <1552045591.4009.4.camel@pengutronix.de>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <6ebec765-652b-412a-94fc-66168841e1eb@gmail.com>
Date:   Fri, 8 Mar 2019 17:16:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <1552045591.4009.4.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 3/8/19 3:46 AM, Philipp Zabel wrote:
> On Thu, 2019-03-07 at 15:33 -0800, Steve Longerbeam wrote:
>> Only providing the input and output RGB/YUV space to the IC task init
>> functions is not sufficient. To fully characterize a colorspace
>> conversion, the colorspace (chromaticities), Y'CbCr encoding standard,
>> and quantization also need to be specified.
>>
>> Define a 'struct ipu_ic_colorspace' that includes all the above, and pass
>> the input and output ipu_ic_colorspace to the IC task init functions.
>>
>> This allows to actually enforce the fact that the IC:
>>
>> - can only encode to/from YUV full range (follow-up patch will remove
>>    this restriction).
>> - can only encode to/from RGB full range.
>> - can only encode using BT.601 standard (follow-up patch will add
>>    Rec.709 encoding support).
>> - cannot convert colorspaces from input to output, the
>>    input and output colorspace chromaticities must be the same.
>>
>> The determination of the CSC coefficients based on the input/output
>> colorspace parameters are moved to a new function calc_csc_coeffs(),
>> called by init_csc().
>>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>> ---
>>   drivers/gpu/ipu-v3/ipu-ic.c                 | 136 +++++++++++++-------
>>   drivers/gpu/ipu-v3/ipu-image-convert.c      |  27 ++--
>>   drivers/staging/media/imx/imx-ic-prpencvf.c |  22 +++-
>>   include/video/imx-ipu-v3.h                  |  37 +++++-
>>   4 files changed, 154 insertions(+), 68 deletions(-)
>>
>> diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
>> index b63a2826b629..c4048c921801 100644
>> --- a/drivers/gpu/ipu-v3/ipu-ic.c
>> +++ b/drivers/gpu/ipu-v3/ipu-ic.c
>> @@ -146,8 +146,10 @@ struct ipu_ic {
>>   	const struct ic_task_regoffs *reg;
>>   	const struct ic_task_bitfields *bit;
>>   
>> -	enum ipu_color_space in_cs, g_in_cs;
>> -	enum ipu_color_space out_cs;
>> +	struct ipu_ic_colorspace in_cs;
>> +	struct ipu_ic_colorspace g_in_cs;
>> +	struct ipu_ic_colorspace out_cs;
>> +
>>   	bool graphics;
>>   	bool rotation;
>>   	bool in_use;
>> @@ -235,42 +237,83 @@ static const struct ic_encode_coeff ic_encode_ycbcr2rgb_601 = {
>>   	.scale = 2,
>>   };
>>   
>> +static int calc_csc_coeffs(struct ipu_ic_priv *priv,
>> +			   struct ic_encode_coeff *coeff_out,
>> +			   const struct ipu_ic_colorspace *in,
>> +			   const struct ipu_ic_colorspace *out)
>> +{
>> +	bool inverse_encode;
>> +
>> +	if (in->colorspace != out->colorspace) {
>> +		dev_err(priv->ipu->dev, "Cannot convert colorspaces\n");
>> +		return -ENOTSUPP;
>> +	}
> I don't think this is useful enough to warrant having the colorspace
> field in ipu_ic_colorspace. Let the caller make sure of this, same as
> for xfer_func.

Ok, for xfer_func it is implicit that the gamma function must be the 
same for input and output, so I agree it might as well be implicit for 
chromaticities too.


>
>> +	if (out->enc != V4L2_YCBCR_ENC_601) {
>> +		dev_err(priv->ipu->dev, "Only BT.601 encoding supported\n");
>> +		return -ENOTSUPP;
>> +	}
> This is only important if out->cs is IPUV3_COLORSPACE_YUV, right? If the
> output is RGB this field shouldn't matter.

It matters for encoding YUV to RGB, or the inverse RGB to YUV. The 
encoding standard doesn't matter only if no encoding/inverse encoding is 
requested (YUV to YUV or RGB to RGB).

>
>> +
>> +	if ((in->cs == IPUV3_COLORSPACE_YUV &&
>> +	     in->quant != V4L2_QUANTIZATION_FULL_RANGE) ||
>> +	    (out->cs == IPUV3_COLORSPACE_YUV &&
>> +	     out->quant != V4L2_QUANTIZATION_FULL_RANGE)) {
>> +		dev_err(priv->ipu->dev, "Limited range YUV not supported\n");
>> +		return -ENOTSUPP;
>> +	}
>> +
>> +	if ((in->cs == IPUV3_COLORSPACE_RGB &&
>> +	     in->quant != V4L2_QUANTIZATION_FULL_RANGE) ||
>> +	    (out->cs == IPUV3_COLORSPACE_RGB &&
>> +	     out->quant != V4L2_QUANTIZATION_FULL_RANGE)) {
>> +		dev_err(priv->ipu->dev, "Limited range RGB not supported\n");
>> +		return -ENOTSUPP;
>> +	}
>> +
>> +	if (in->cs == out->cs) {
>> +		*coeff_out = ic_encode_identity;
>> +
>> +		return 0;
>> +	}
>> +
>> +	inverse_encode = (in->cs == IPUV3_COLORSPACE_YUV);
> What does inverse_encode mean in this context?

It means YUV to RGB. At this point in the function it is determined that 
encoding or inverse encoding is requested.

>
>> +
>> +	*coeff_out = inverse_encode ?
>> +		ic_encode_ycbcr2rgb_601 : ic_encode_rgb2ycbcr_601;
>> +
>> +	return 0;
>> +}
>> +
>>   static int init_csc(struct ipu_ic *ic,
>> -		    enum ipu_color_space inf,
>> -		    enum ipu_color_space outf,
>> +		    const struct ipu_ic_colorspace *in,
>> +		    const struct ipu_ic_colorspace *out,
>>   		    int csc_index)
>>   {
>>   	struct ipu_ic_priv *priv = ic->priv;
>> -	const struct ic_encode_coeff *coeff;
>> +	struct ic_encode_coeff coeff;
> I understand this is a preparation for patch 5, but on its own this
> introduces an unnecessary copy.

True, I'll try to remove the copy in this patch.

>
>>   	u32 __iomem *base;
>>   	const u16 (*c)[3];
>>   	const u16 *a;
>>   	u32 param;
>> +	int ret;
>> +
>> +	ret = calc_csc_coeffs(priv, &coeff, in, out);
>> +	if (ret)
>> +		return ret;
>>   
>>   	base = (u32 __iomem *)
>>   		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
>>   
>> -	if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB)
>> -		coeff = &ic_encode_ycbcr2rgb_601;
>> -	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV)
>> -		coeff = &ic_encode_rgb2ycbcr_601;
>> -	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_RGB)
>> -		coeff = &ic_encode_identity;
>> -	else {
>> -		dev_err(priv->ipu->dev, "Unsupported color space conversion\n");
>> -		return -EINVAL;
>> -	}
>> -
>>   	/* Cast to unsigned */
>> -	c = (const u16 (*)[3])coeff->coeff;
>> -	a = (const u16 *)coeff->offset;
>> +	c = (const u16 (*)[3])coeff.coeff;
>> +	a = (const u16 *)coeff.offset;
>>   
>>   	param = ((a[0] & 0x1f) << 27) | ((c[0][0] & 0x1ff) << 18) |
>>   		((c[1][1] & 0x1ff) << 9) | (c[2][2] & 0x1ff);
>>   	writel(param, base++);
>>   
>> -	param = ((a[0] & 0x1fe0) >> 5) | (coeff->scale << 8) |
>> -		(coeff->sat << 10);
>> +	param = ((a[0] & 0x1fe0) >> 5) | (coeff.scale << 8) |
>> +		(coeff.sat << 10);
>>   	writel(param, base++);
>>   
>>   	param = ((a[1] & 0x1f) << 27) | ((c[0][1] & 0x1ff) << 18) |
>> @@ -357,14 +400,14 @@ void ipu_ic_task_enable(struct ipu_ic *ic)
>>   	if (ic->rotation)
>>   		ic_conf |= ic->bit->ic_conf_rot_en;
>>   
>> -	if (ic->in_cs != ic->out_cs)
>> +	if (ic->in_cs.cs != ic->out_cs.cs)
>>   		ic_conf |= ic->bit->ic_conf_csc1_en;
>>   
>>   	if (ic->graphics) {
>>   		ic_conf |= ic->bit->ic_conf_cmb_en;
>>   		ic_conf |= ic->bit->ic_conf_csc1_en;
>>   
>> -		if (ic->g_in_cs != ic->out_cs)
>> +		if (ic->g_in_cs.cs != ic->out_cs.cs)
>>   			ic_conf |= ic->bit->ic_conf_csc2_en;
>>   	}
>>   
>> @@ -399,7 +442,7 @@ void ipu_ic_task_disable(struct ipu_ic *ic)
>>   EXPORT_SYMBOL_GPL(ipu_ic_task_disable);
>>   
>>   int ipu_ic_task_graphics_init(struct ipu_ic *ic,
>> -			      enum ipu_color_space in_g_cs,
>> +			      const struct ipu_ic_colorspace *g_in_cs,
> What made you decide not to expose the task parameter structure?
>
> I was hoping we could eventually move the V4L2 colorimetry settings to
> conversion matrix translation into imx-media.

Sure, I'm fine with that. I'll move the task parameter struct to 
imx-ipu-v3.h.

>
> Btw, do you have any plans for using IC composition?
> ipu_ic_task_graphics_init() is currently unused...

No plans for IC composition, I've only been keeping the function 
up-to-date. I've never even tested this, it might not even work. Should 
it be removed?

>
>>   			      bool galpha_en, u32 galpha,
>>   			      bool colorkey_en, u32 colorkey)
>>   {
>> @@ -416,20 +459,25 @@ int ipu_ic_task_graphics_init(struct ipu_ic *ic,
>>   	ic_conf = ipu_ic_read(ic, IC_CONF);
>>   
>>   	if (!(ic_conf & ic->bit->ic_conf_csc1_en)) {
>> +		struct ipu_ic_colorspace rgb_cs;
>> +
>> +		ipu_ic_fill_colorspace(&rgb_cs,
>> +				       V4L2_COLORSPACE_SRGB,
>> +				       V4L2_YCBCR_ENC_601,
>> +				       V4L2_QUANTIZATION_FULL_RANGE,
>> +				       IPUV3_COLORSPACE_RGB);
>> +
>>   		/* need transparent CSC1 conversion */
>> -		ret = init_csc(ic, IPUV3_COLORSPACE_RGB,
>> -			       IPUV3_COLORSPACE_RGB, 0);
>> +		ret = init_csc(ic, &rgb_cs, &rgb_cs, 0);
>>   		if (ret)
>>   			goto unlock;
>>   	}
>>   
>> -	ic->g_in_cs = in_g_cs;
>> +	ic->g_in_cs = *g_in_cs;
>>   
>> -	if (ic->g_in_cs != ic->out_cs) {
>> -		ret = init_csc(ic, ic->g_in_cs, ic->out_cs, 1);
>> -		if (ret)
>> -			goto unlock;
>> -	}
>> +	ret = init_csc(ic, &ic->g_in_cs, &ic->out_cs, 1);
>> +	if (ret)
>> +		goto unlock;
> I had to look twice, but this is fine. If ic->g_in_cs == ic->out_cs,
> ipu_ic_task_enable() won't enable CSC2 in IC_CONF, and these TPMEM
> values will be ignored.
>
>>   
>>   	if (galpha_en) {
>>   		ic_conf |= IC_CONF_IC_GLB_LOC_A;
>> @@ -456,10 +504,10 @@ int ipu_ic_task_graphics_init(struct ipu_ic *ic,
>>   EXPORT_SYMBOL_GPL(ipu_ic_task_graphics_init);
>>   
>>   int ipu_ic_task_init_rsc(struct ipu_ic *ic,
>> +			 const struct ipu_ic_colorspace *in_cs,
>> +			 const struct ipu_ic_colorspace *out_cs,
>>   			 int in_width, int in_height,
>>   			 int out_width, int out_height,
>> -			 enum ipu_color_space in_cs,
>> -			 enum ipu_color_space out_cs,
>>   			 u32 rsc)
>>   {
>>   	struct ipu_ic_priv *priv = ic->priv;
>> @@ -491,28 +539,24 @@ int ipu_ic_task_init_rsc(struct ipu_ic *ic,
>>   	ipu_ic_write(ic, rsc, ic->reg->rsc);
>>   
>>   	/* Setup color space conversion */
>> -	ic->in_cs = in_cs;
>> -	ic->out_cs = out_cs;
>> +	ic->in_cs = *in_cs;
>> +	ic->out_cs = *out_cs;
>>   
>> -	if (ic->in_cs != ic->out_cs) {
>> -		ret = init_csc(ic, ic->in_cs, ic->out_cs, 0);
>> -		if (ret)
>> -			goto unlock;
>> -	}
>> +	ret = init_csc(ic, &ic->in_cs, &ic->out_cs, 0);
> Same as above for CSC1.
>   
>> -unlock:
>>   	spin_unlock_irqrestore(&priv->lock, flags);
>>   	return ret;
>>   }
>>   
>>   int ipu_ic_task_init(struct ipu_ic *ic,
>> +		     const struct ipu_ic_colorspace *in_cs,
>> +		     const struct ipu_ic_colorspace *out_cs,
>>   		     int in_width, int in_height,
>> -		     int out_width, int out_height,
>> -		     enum ipu_color_space in_cs,
>> -		     enum ipu_color_space out_cs)
>> +		     int out_width, int out_height)
>>   {
>> -	return ipu_ic_task_init_rsc(ic, in_width, in_height, out_width,
>> -				    out_height, in_cs, out_cs, 0);
>> +	return ipu_ic_task_init_rsc(ic, in_cs, out_cs,
>> +				    in_width, in_height,
>> +				    out_width, out_height, 0);
>>   }
>>   EXPORT_SYMBOL_GPL(ipu_ic_task_init);
>>   
>> diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
>> index 13103ab86050..ccbc8f4d95d7 100644
>> --- a/drivers/gpu/ipu-v3/ipu-image-convert.c
>> +++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
>> @@ -1317,7 +1317,7 @@ static int convert_start(struct ipu_image_convert_run *run, unsigned int tile)
>>   	struct ipu_image_convert_priv *priv = chan->priv;
>>   	struct ipu_image_convert_image *s_image = &ctx->in;
>>   	struct ipu_image_convert_image *d_image = &ctx->out;
>> -	enum ipu_color_space src_cs, dest_cs;
>> +	struct ipu_ic_colorspace src_cs, dest_cs;
>>   	unsigned int dst_tile = ctx->out_tile_map[tile];
>>   	unsigned int dest_width, dest_height;
>>   	unsigned int col, row;
>> @@ -1327,8 +1327,16 @@ static int convert_start(struct ipu_image_convert_run *run, unsigned int tile)
>>   	dev_dbg(priv->ipu->dev, "%s: task %u: starting ctx %p run %p tile %u -> %u\n",
>>   		__func__, chan->ic_task, ctx, run, tile, dst_tile);
>>   
>> -	src_cs = ipu_pixelformat_to_colorspace(s_image->fmt->fourcc);
>> -	dest_cs = ipu_pixelformat_to_colorspace(d_image->fmt->fourcc);
>> +	ipu_ic_fill_colorspace(&src_cs,
>> +			s_image->base.pix.colorspace,
>> +			s_image->base.pix.ycbcr_enc,
>> +			s_image->base.pix.quantization,
>> +			ipu_pixelformat_to_colorspace(s_image->fmt->fourcc));
>> +	ipu_ic_fill_colorspace(&dest_cs,
>> +			d_image->base.pix.colorspace,
>> +			d_image->base.pix.ycbcr_enc,
>> +			d_image->base.pix.quantization,
>> +			ipu_pixelformat_to_colorspace(d_image->fmt->fourcc));
> If ipu_ic_task_init(_rsc) could be passed the task parameter structure,
> it could be calculated once in ipu_image_convert_prepare and stored in
> ipu_image_convert_ctx for repeated use.

Yes, I'll add this for v7.

Steve

