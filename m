Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35872 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab3GXTgI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 15:36:08 -0400
Received: by mail-lb0-f174.google.com with SMTP id x10so823899lbi.19
        for <linux-media@vger.kernel.org>; Wed, 24 Jul 2013 12:36:04 -0700 (PDT)
Message-ID: <51F02CA1.7050603@cogentembedded.com>
Date: Wed, 24 Jul 2013 23:36:01 +0400
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	mchehab@redhat.com, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp
Subject: Re: [PATCH v8] V4L2: soc_camera: Renesas R-Car VIN driver
References: <201307200314.35345.sergei.shtylyov@cogentembedded.com> <Pine.LNX.4.64.1307241731560.2179@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1307241731560.2179@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the v8 review.

On 07/24/2013 08:14 PM, Guennadi Liakhovetski wrote:
> [snip]
>> +	/* output format */
>> +	switch (icd->current_fmt->host_fmt->fourcc) {
>> +	case V4L2_PIX_FMT_NV16:
>> +		iowrite32(ALIGN(cam->width * cam->height, 0x80),
>> +			  priv->base + VNUVAOF_REG);
>> +		dmr = VNDMR_DTMD_YCSEP;
>> +		output_is_yuv = true;
>> +		break;
>> +	case V4L2_PIX_FMT_YUYV:
>> +		dmr = VNDMR_BPSM;
>> +		output_is_yuv = true;
>> +		break;
>> +	case V4L2_PIX_FMT_UYVY:
>> +		dmr = 0;
>> +		output_is_yuv = true;
>> +		break;
>> +	case V4L2_PIX_FMT_RGB555X:
>> +		dmr = VNDMR_DTMD_ARGB1555;
>> +		break;
>> +	case V4L2_PIX_FMT_RGB565:
>> +		dmr = 0;
>> +		break;
>> +	case V4L2_PIX_FMT_RGB32:
>> +		if (priv->chip == RCAR_H1 || priv->chip == RCAR_E1) {
>> +			dmr = VNDMR_EXRGB;
>> +			break;
>> +		}
>> +	default:
>> +		BUG();
> as commented above, please, remove
Does WARN_ON(1) work instead of removal?

Regards,
Vladimir

