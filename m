Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53855 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793Ab3APKNe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 05:13:34 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGP007YLR21M520@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Jan 2013 10:13:32 +0000 (GMT)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MGP009DZR2JEC80@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Jan 2013 10:13:32 +0000 (GMT)
Message-id: <50F67D4A.9010909@samsung.com>
Date: Wed, 16 Jan 2013 11:13:30 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, ajaykumar.rs@samsung.com,
	patches@linaro.org, Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH] s5p-g2d: Add support for G2D H/W Rev.4.1
References: <1357541069-7898-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1357541069-7898-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

I have just one small comment...

On 01/07/2013 07:44 AM, Sachin Kamat wrote:
> +static void *g2d_get_drv_data(struct platform_device *pdev)
> +{
> +	struct g2d_variant *driver_data = NULL;
> +
> +	driver_data = (struct g2d_variant *)
> +		platform_get_device_id(pdev)->driver_data;
> +
> +	return driver_data;
> +}

How about adding this to g2d.h as:

static inline struct g2d_variant *g2d_get_drv_data(struct platform_device *pdev)
{
	return (struct g2d_variant *)platform_get_device_id(pdev)->driver_data;
}

?

Otherwise the patch looks OK to me.

--

Thanks,
Sylwester
