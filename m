Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:51009 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754336AbdKAMiF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Nov 2017 08:38:05 -0400
Received: by mail-wm0-f65.google.com with SMTP id s66so4476669wmf.5
        for <linux-media@vger.kernel.org>; Wed, 01 Nov 2017 05:38:04 -0700 (PDT)
Subject: Re: [PATCH] [RFC] media: camss-vfe: always initialize reg at
 vfe_set_xbar_cfg()
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20e982c47af6eafe58274fa299ec587b2fb91d32.1509538566.git.mchehab@s-opensource.com>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <a3b51962-1316-c7cf-1182-5a5d7f0ed719@linaro.org>
Date: Wed, 1 Nov 2017 14:38:02 +0200
MIME-Version: 1.0
In-Reply-To: <20e982c47af6eafe58274fa299ec587b2fb91d32.1509538566.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for pointing to this.

On  1.11.2017 14:16, Mauro Carvalho Chehab wrote:
> if output->wm_num is bigger than 1, the value for reg is
If output->wn_num equals 2, we handle all cases (i == 0, i == 1) and set reg properly.
If output->wn_num is bigger than 2, then reg will not be initialized. However this is something that "cannot happen" and because of this the case is not handled.

So I think that there is nothing wrong really but we have to do something to remove the warning. I agree with your patch, it is technically not a right value for reg but any cases in which wm_num is bigger than 2 are not supported anyway and should not happen.

> not initialized, as warned by smatch:
> 	drivers/media/platform/qcom/camss-8x16/camss-vfe.c:633 vfe_set_xbar_cfg() error: uninitialized symbol 'reg'.
> 	drivers/media/platform/qcom/camss-8x16/camss-vfe.c:637 vfe_set_xbar_cfg() error: uninitialized symbol 'reg'.
> 
> I didn't check the logic into its details, but there is at least
> one point where wm_num is made equal to two. So, something
> seem broken.
> 
> For now, I just reset it to zero, and added a FIXME. Hopefully,
> the driver authors will know if this is OK, or if something else
> is needed there.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
> index b22d2dfcd3c2..388431f747fa 100644
> --- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
> +++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
> @@ -622,6 +622,8 @@ static void vfe_set_xbar_cfg(struct vfe_device *vfe, struct vfe_output *output,
>  			reg = VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN;
>  			if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV16)
>  				reg |= VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA;
> +		} else {
> +			reg = 0;	/* FIXME: is it the right value for i > 1? */
>  		}
>  
>  		if (output->wm_idx[i] % 2 == 1)
> 

-- 
Best regards,
Todor Tomov
