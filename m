Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0233.hostedemail.com ([216.40.44.233]:42627 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751364AbdIOSQe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 14:16:34 -0400
Message-ID: <1505499388.27581.13.camel@perches.com>
Subject: Re: [PATCH 2/2] [media] stm32-dcmi: Improve four size determinations
From: Joe Perches <joe@perches.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Date: Fri, 15 Sep 2017 11:16:28 -0700
In-Reply-To: <f4e400ea-9660-05cd-3194-cdf2495a2376@users.sourceforge.net>
References: <730b535e-39a5-2c2b-f463-e76da967a723@users.sourceforge.net>
         <f4e400ea-9660-05cd-3194-cdf2495a2376@users.sourceforge.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-09-15 at 19:29 +0200, SF Markus Elfring wrote:
> diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
[]
> @@ -1372,9 +1372,8 @@ static int dcmi_formats_init(struct stm32_dcmi *dcmi)
>  	dcmi->sd_formats = devm_kcalloc(dcmi->dev,
> -					num_fmts, sizeof(struct dcmi_format *),
> +					num_fmts, sizeof(*dcmi->sd_formats),
>  					GFP_KERNEL);
>  	if (!dcmi->sd_formats)
>  		return -ENOMEM;
>  
> -	memcpy(dcmi->sd_formats, sd_fmts,
> -	       num_fmts * sizeof(struct dcmi_format *));
> +	memcpy(dcmi->sd_formats, sd_fmts, num_fmts * sizeof(*dcmi->sd_formats));

devm_kmemdup
