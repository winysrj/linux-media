Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989DCC43387
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 23:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCA5F208C1
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 23:40:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pt5o26fL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbeLNXkN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 18:40:13 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46842 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbeLNXkM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 18:40:12 -0500
Received: by mail-pg1-f194.google.com with SMTP id w7so3349800pgp.13;
        Fri, 14 Dec 2018 15:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=F8N6S2uihnPNU4dF+soDU7qemLVno4oWsBSBbCIWx40=;
        b=pt5o26fLTKONe9Hk0bYkzSVf2kCpEFbQ/k4hx5ZKvy0ICRX6X/GiK2ZH6qViHIb+9f
         PCIrKoCvgDjQ3I5H1zcIkeYIXleha/PbcBBSGVNUEB64HlK8/btSRSKg0AKsQ/buSw3I
         tW5OzgLKWY5+m0y8/Lkw0IRTMFciKTQYU0tbfHtHaB2FdcqA23CAw8b+uGtenymT110y
         Xc8/Em3aAOpotHTv8SnVL4vW+128CzXwjLNGw5n1YD7kU50aimqWPr+TBdmhRBnw0B2W
         JhPQNC75ii6Uorow98RBqhxgOBkZ9pgyw7pCoet8rlWVNEn6fl5EOMfIdjM7O5hwdd74
         ds+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=F8N6S2uihnPNU4dF+soDU7qemLVno4oWsBSBbCIWx40=;
        b=oTUKegvW9iB3G4r1Gt+0O4v0ekWcBpEOjbmfkqw3ZG+4DpgioFJcC6ASJ0GmnQnFIe
         9LLuwFb5aa2ZMWJMl7u98ZNGrd2cpfYYsCJpJWlrUlS/OH4AUcUrESlnVdl/KmC8Rzv6
         9xR5095Zkw49l0IkA+TW/ZgynGf/L9Qarpqd/AgGTLgp1dck7c0paPX9zHRDa+hz4lbN
         gOscuTaVOmJ+IJMwwD0xJClsqHgMOGS1h4x1JSfms1StQOPwyjw5RY6+ENLPyfCCEx7I
         CrbzyrQqvW5id/YM3G0/TNXMB+aYcTWZua1Yv1c4HtDM46leVuiopKSRbTSrJTUlCVwC
         Ydug==
X-Gm-Message-State: AA+aEWZUO/hb98IIh6Spa6ZBC4khxWEiKnL5zGuupqlgsdC6lnv/ztjo
        A94lmfMpf7IrB02mOQAi/S5vkJlS
X-Google-Smtp-Source: AFSGD/VXZZP8pAJkCEba14fUgXOz3ElWu/K3yQoeFg9XC4zGejEmz7lxMUaBJBaHCfKUJoEGy8oacQ==
X-Received: by 2002:a65:4142:: with SMTP id x2mr4328485pgp.356.1544830810115;
        Fri, 14 Dec 2018 15:40:10 -0800 (PST)
Received: from [172.30.90.17] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id l85sm10062732pfg.161.2018.12.14.15.40.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Dec 2018 15:40:09 -0800 (PST)
Subject: Re: [PATCH v5 02/12] gpu: ipu-csi: Swap fields according to
 input/output field types
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
References: <20181017000027.23696-1-slongerbeam@gmail.com>
 <20181017000027.23696-3-slongerbeam@gmail.com>
 <1544705964.5886.1.camel@pengutronix.de>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <9998c91a-f8b8-9c7e-3c37-10600601f843@gmail.com>
Date:   Fri, 14 Dec 2018 15:40:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1544705964.5886.1.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 12/13/18 4:59 AM, Philipp Zabel wrote:
> Hi Steve,
>
> On Tue, 2018-10-16 at 17:00 -0700, Steve Longerbeam wrote:
>> The function ipu_csi_init_interface() was inverting the F-bit for
>> NTSC case, in the CCIR_CODE_1/2 registers. The result being that
>> for NTSC bottom-top field order, the CSI would swap fields and
>> capture in top-bottom order.
>>
>> Instead, base field swap on the field order of the input to the CSI,
>> and the field order of the requested output. If the input/output
>> fields are sequential but different, swap fields, otherwise do
>> not swap. This requires passing both the input and output mbus
>> frame formats to ipu_csi_init_interface().
>>
>> Move this code to a new private function ipu_csi_set_bt_interlaced_codes()
>> that programs the CCIR_CODE_1/2 registers for interlaced BT.656 (and
>> possibly interlaced BT.1120 in the future).
>>
>> When detecting input video standard from the input frame width/height,
>> make sure to double height if input field type is alternate, since
>> in that case input height only includes lines for one field.
>>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>> ---
>> Changes since v4:
>> - Cleaned up some convoluted code in ipu_csi_init_interface(), suggested
>>    by Philipp Zabel.
>> - Fixed a regression in csi_setup(), caught by Philipp.
>> ---
>>   drivers/gpu/ipu-v3/ipu-csi.c              | 119 +++++++++++++++-------
>>   drivers/staging/media/imx/imx-media-csi.c |  17 +---
>>   include/video/imx-ipu-v3.h                |   3 +-
>>   3 files changed, 88 insertions(+), 51 deletions(-)
>>
>> diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
>> index aa0e30a2ba18..4a15e513fa05 100644
>> --- a/drivers/gpu/ipu-v3/ipu-csi.c
>> +++ b/drivers/gpu/ipu-v3/ipu-csi.c
>> @@ -325,6 +325,15 @@ static int mbus_code_to_bus_cfg(struct ipu_csi_bus_config *cfg, u32 mbus_code,
>>   	return 0;
>>   }
>>   
>> +/* translate alternate field mode based on given standard */
>> +static inline enum v4l2_field
>> +ipu_csi_translate_field(enum v4l2_field field, v4l2_std_id std)
>> +{
>> +	return (field != V4L2_FIELD_ALTERNATE) ? field :
>> +		((std & V4L2_STD_525_60) ?
>> +		 V4L2_FIELD_SEQ_BT : V4L2_FIELD_SEQ_TB);
>> +}
>> +
>>   /*
>>    * Fill a CSI bus config struct from mbus_config and mbus_framefmt.
>>    */
>> @@ -374,22 +383,75 @@ static int fill_csi_bus_cfg(struct ipu_csi_bus_config *csicfg,
>>   	return 0;
>>   }
>>   
>> +static int ipu_csi_set_bt_interlaced_codes(struct ipu_csi *csi,
>> +					   struct v4l2_mbus_framefmt *infmt,
>> +					   struct v4l2_mbus_framefmt *outfmt,
> infmt and outfmt parameters could be const.

Agreed, I will convert these pointer args to const. And since we are 
changing the API to ipu_csi_init_interface() anyway, I went ahead and 
converted the mbus_cfg, infmt, and outfmt pointer args to const there as 
well.


>> +					   v4l2_std_id std)
>> +{
>> +	enum v4l2_field infield, outfield;
>> +	bool swap_fields;
>> +
>> +	/* get translated field type of input and output */
>> +	infield = ipu_csi_translate_field(infmt->field, std);
>> +	outfield = ipu_csi_translate_field(outfmt->field, std);
>> +
>> +	/*
>> +	 * Write the H-V-F codes the CSI will match against the
>> +	 * incoming data for start/end of active and blanking
>> +	 * field intervals. If input and output field types are
>> +	 * sequential but not the same (one is SEQ_BT and the other
>> +	 * is SEQ_TB), swap the F-bit so that the CSI will capture
>> +	 * field 1 lines before field 0 lines.
>> +	 */
>> +	swap_fields = (V4L2_FIELD_IS_SEQUENTIAL(infield) &&
>> +		       V4L2_FIELD_IS_SEQUENTIAL(outfield) &&
>> +		       infield != outfield);
>> +
>> +	if (!swap_fields) {
>> +		/*
>> +		 * Field0BlankEnd  = 110, Field0BlankStart  = 010
>> +		 * Field0ActiveEnd = 100, Field0ActiveStart = 000
>> +		 * Field1BlankEnd  = 111, Field1BlankStart  = 011
>> +		 * Field1ActiveEnd = 101, Field1ActiveStart = 001
>> +		 */
>> +		ipu_csi_write(csi, 0x40596 | CSI_CCIR_ERR_DET_EN,
>> +			      CSI_CCIR_CODE_1);
>> +		ipu_csi_write(csi, 0xD07DF, CSI_CCIR_CODE_2);
>> +	} else {
>> +		dev_dbg(csi->ipu->dev, "capture field swap\n");
>> +
>> +		/* same as above but with F-bit inverted */
>> +		ipu_csi_write(csi, 0xD07DF | CSI_CCIR_ERR_DET_EN,
>> +			      CSI_CCIR_CODE_1);
>> +		ipu_csi_write(csi, 0x40596, CSI_CCIR_CODE_2);
>> +	}
>> +
>> +	ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
>> +
>> +	return 0;
>> +}
>> +
>> +
>>   int ipu_csi_init_interface(struct ipu_csi *csi,
>>   			   struct v4l2_mbus_config *mbus_cfg,
>> -			   struct v4l2_mbus_framefmt *mbus_fmt)
>> +			   struct v4l2_mbus_framefmt *infmt,
>> +			   struct v4l2_mbus_framefmt *outfmt)
>>   {
>>   	struct ipu_csi_bus_config cfg;
>>   	unsigned long flags;
>>   	u32 width, height, data = 0;
>> +	v4l2_std_id std;
>>   	int ret;
>>   
>> -	ret = fill_csi_bus_cfg(&cfg, mbus_cfg, mbus_fmt);
>> +	ret = fill_csi_bus_cfg(&cfg, mbus_cfg, infmt);
>>   	if (ret < 0)
>>   		return ret;
>>   
>>   	/* set default sensor frame width and height */
>> -	width = mbus_fmt->width;
>> -	height = mbus_fmt->height;
>> +	width = infmt->width;
>> +	height = infmt->height;
>> +	if (infmt->field == V4L2_FIELD_ALTERNATE)
>> +		height *= 2;
>>   
>>   	/* Set the CSI_SENS_CONF register remaining fields */
>>   	data |= cfg.data_width << CSI_SENS_CONF_DATA_WIDTH_SHIFT |
>> @@ -416,42 +478,22 @@ int ipu_csi_init_interface(struct ipu_csi *csi,
>>   		ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
>>   		break;
>>   	case IPU_CSI_CLK_MODE_CCIR656_INTERLACED:
>> -		if (mbus_fmt->width == 720 && mbus_fmt->height == 576) {
>> -			/*
>> -			 * PAL case
>> -			 *
>> -			 * Field0BlankEnd = 0x6, Field0BlankStart = 0x2,
>> -			 * Field0ActiveEnd = 0x4, Field0ActiveStart = 0
>> -			 * Field1BlankEnd = 0x7, Field1BlankStart = 0x3,
>> -			 * Field1ActiveEnd = 0x5, Field1ActiveStart = 0x1
>> -			 */
>> -			height = 625; /* framelines for PAL */
>> -
>> -			ipu_csi_write(csi, 0x40596 | CSI_CCIR_ERR_DET_EN,
>> -					  CSI_CCIR_CODE_1);
>> -			ipu_csi_write(csi, 0xD07DF, CSI_CCIR_CODE_2);
>> -			ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
>> -		} else if (mbus_fmt->width == 720 && mbus_fmt->height == 480) {
>> -			/*
>> -			 * NTSC case
>> -			 *
>> -			 * Field0BlankEnd = 0x7, Field0BlankStart = 0x3,
>> -			 * Field0ActiveEnd = 0x5, Field0ActiveStart = 0x1
>> -			 * Field1BlankEnd = 0x6, Field1BlankStart = 0x2,
>> -			 * Field1ActiveEnd = 0x4, Field1ActiveStart = 0
>> -			 */
>> -			height = 525; /* framelines for NTSC */
>> -
>> -			ipu_csi_write(csi, 0xD07DF | CSI_CCIR_ERR_DET_EN,
>> -					  CSI_CCIR_CODE_1);
>> -			ipu_csi_write(csi, 0x40596, CSI_CCIR_CODE_2);
>> -			ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
>> +		if (width == 720 && height == 480) {
>> +			std = V4L2_STD_NTSC;
>> +			height = 525;
>> +		} else if (width == 720 && height == 576) {
>> +			std = V4L2_STD_PAL;
>> +			height = 625;
>>   		} else {
>>   			dev_err(csi->ipu->dev,
>> -				"Unsupported CCIR656 interlaced video mode\n");
>> -			spin_unlock_irqrestore(&csi->lock, flags);
>> -			return -EINVAL;
>> +				"Unsupported interlaced video mode\n");
>> +			ret = -EINVAL;
>> +			goto out_unlock;
>>   		}
>> +
>> +		ret = ipu_csi_set_bt_interlaced_codes(csi, infmt, outfmt, std);
>> +		if (ret)
>> +			goto out_unlock;
>>   		break;
>>   	case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_DDR:
>>   	case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_SDR:
>> @@ -476,9 +518,10 @@ int ipu_csi_init_interface(struct ipu_csi *csi,
>>   	dev_dbg(csi->ipu->dev, "CSI_ACT_FRM_SIZE = 0x%08X\n",
>>   		ipu_csi_read(csi, CSI_ACT_FRM_SIZE));
>>   
>> +out_unlock:
>>   	spin_unlock_irqrestore(&csi->lock, flags);
>>   
>> -	return 0;
>> +	return ret;
>>   }
>>   EXPORT_SYMBOL_GPL(ipu_csi_init_interface);
>>   
>> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
>> index 4223f8d418ae..7ecbd4d76d09 100644
>> --- a/drivers/staging/media/imx/imx-media-csi.c
>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>> @@ -663,15 +663,14 @@ static void csi_idmac_stop(struct csi_priv *priv)
>>   /* Update the CSI whole sensor and active windows */
>>   static int csi_setup(struct csi_priv *priv)
>>   {
>> -	struct v4l2_mbus_framefmt *infmt, *outfmt;
>> +	struct v4l2_mbus_framefmt infmt, outfmt;
>>   	const struct imx_media_pixfmt *incc;
>>   	struct v4l2_mbus_config mbus_cfg;
>> -	struct v4l2_mbus_framefmt if_fmt;
>>   	struct v4l2_rect crop;
>>   
>> -	infmt = &priv->format_mbus[CSI_SINK_PAD];
>> +	infmt = priv->format_mbus[CSI_SINK_PAD];
> Maybe still call this if_fmt, or maybe csi_fmt, to indicate this is not
> just the userspace visible input format as determined by the pad, but
> the modified format we set the interface to? Not a strong preference,
> though.

Ok, I brought back if_fmt.

>
>>   	incc = priv->cc[CSI_SINK_PAD];
>> -	outfmt = &priv->format_mbus[priv->active_output_pad];
>> +	outfmt = priv->format_mbus[priv->active_output_pad];
> Copying the output format onto the stack seems unnecessary to me.

Yes, I did this for consistency with on-stack infmt, but it's not 
necessary, I restored outfmt to a pointer.

>
>>   
>>   	/* compose mbus_config from the upstream endpoint */
>>   	mbus_cfg.type = priv->upstream_ep.bus_type;
>> @@ -679,12 +678,6 @@ static int csi_setup(struct csi_priv *priv)
>>   		priv->upstream_ep.bus.parallel.flags :
>>   		priv->upstream_ep.bus.mipi_csi2.flags;
>>   
>> -	/*
>> -	 * we need to pass input frame to CSI interface, but
>> -	 * with translated field type from output format
>> -	 */
>> -	if_fmt = *infmt;
>> -	if_fmt.field = outfmt->field;
>>   	crop = priv->crop;
>>   
>>   	/*
>> @@ -692,7 +685,7 @@ static int csi_setup(struct csi_priv *priv)
>>   	 * generic/bayer data
>>   	 */
>>   	if (is_parallel_bus(&priv->upstream_ep) && incc->cycles) {
>> -		if_fmt.width *= incc->cycles;
>> +		infmt.width *= incc->cycles;
>>   		crop.width *= incc->cycles;
>>   	}
>>   
>> @@ -702,7 +695,7 @@ static int csi_setup(struct csi_priv *priv)
>>   			     priv->crop.width == 2 * priv->compose.width,
>>   			     priv->crop.height == 2 * priv->compose.height);
>>   
>> -	ipu_csi_init_interface(priv->csi, &mbus_cfg, &if_fmt);
>> +	ipu_csi_init_interface(priv->csi, &mbus_cfg, &infmt, &outfmt);
> We can just pass the &priv->format_mbus[priv->active_output_pad] here,
> or keep using struct v4l2_mbus_framefmt *outfmt as a shorthand.

I just kept it as a short-hand.

Steve

>
>>   
>>   	ipu_csi_set_dest(priv->csi, priv->dest);
>>   
>> diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
>> index abbad94e14a1..f44a35192313 100644
>> --- a/include/video/imx-ipu-v3.h
>> +++ b/include/video/imx-ipu-v3.h
>> @@ -352,7 +352,8 @@ int ipu_prg_channel_configure(struct ipuv3_channel *ipu_chan,
>>   struct ipu_csi;
>>   int ipu_csi_init_interface(struct ipu_csi *csi,
>>   			   struct v4l2_mbus_config *mbus_cfg,
>> -			   struct v4l2_mbus_framefmt *mbus_fmt);
>> +			   struct v4l2_mbus_framefmt *infmt,
>> +			   struct v4l2_mbus_framefmt *outfmt);
>>   bool ipu_csi_is_interlaced(struct ipu_csi *csi);
>>   void ipu_csi_get_window(struct ipu_csi *csi, struct v4l2_rect *w);
>>   void ipu_csi_set_window(struct ipu_csi *csi, struct v4l2_rect *w);
> Either way,
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
>
> regards
> Philipp

