Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:55021 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbdKANJk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Nov 2017 09:09:40 -0400
Received: by mail-wm0-f67.google.com with SMTP id r68so4829275wmr.3
        for <linux-media@vger.kernel.org>; Wed, 01 Nov 2017 06:09:39 -0700 (PDT)
Subject: Re: [PATCH] [RFC] media: camss-vfe: always initialize reg at
 vfe_set_xbar_cfg()
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20e982c47af6eafe58274fa299ec587b2fb91d32.1509538566.git.mchehab@s-opensource.com>
 <a3b51962-1316-c7cf-1182-5a5d7f0ed719@linaro.org>
 <20171101110314.482206b6@vento.lan>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <baa710bc-375b-e306-674c-e6ecc6b1d0f5@linaro.org>
Date: Wed, 1 Nov 2017 15:09:36 +0200
MIME-Version: 1.0
In-Reply-To: <20171101110314.482206b6@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On  1.11.2017 15:03, Mauro Carvalho Chehab wrote:
> Hi Todor,
> 
> Em Wed, 1 Nov 2017 14:38:02 +0200
> Todor Tomov <todor.tomov@linaro.org> escreveu:
> 
>> Hi Mauro,
>>
>> Thank you for pointing to this.
>>
>> On  1.11.2017 14:16, Mauro Carvalho Chehab wrote:
>>> if output->wm_num is bigger than 1, the value for reg is  
>> If output->wn_num equals 2, we handle all cases (i == 0, i == 1) and set reg properly.
>> If output->wn_num is bigger than 2, then reg will not be initialized. However this is something that "cannot happen" and because of this the case is not handled.
>>
>> So I think that there is nothing wrong really but we have to do something to remove the warning. I agree with your patch, it is technically not a right value for reg but any cases in which wm_num is bigger than 2 are not supported anyway and should not happen.
> 
> Thanks for your promptly answer. Well, if i is always at the [0..1] range,
> then I guess the enclosed patch is actually better.

I don't think that there is a lot of difference practically. If this one fixes the warning too, then it is fine for me. Thank you for working on this.

Best regards,
Todor

> 
> 
> Thanks,
> Mauro
> 
> 
> [PATCH] media: camss-vfe: always initialize reg at vfe_set_xbar_cfg()
> 
> if output->wm_num is bigger than 2, the value for reg is
> not initialized, as warned by smatch:
> 	drivers/media/platform/qcom/camss-8x16/camss-vfe.c:633 vfe_set_xbar_cfg() error: uninitialized symbol 'reg'.
> 	drivers/media/platform/qcom/camss-8x16/camss-vfe.c:637 vfe_set_xbar_cfg() error: uninitialized symbol 'reg'.
> 
> That shouldn't happen in practice, so add a logic that will
> break the loop if i > 1, fixing the warnings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
> index b22d2dfcd3c2..55232a912950 100644
> --- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
> +++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
> @@ -622,6 +622,9 @@ static void vfe_set_xbar_cfg(struct vfe_device *vfe, struct vfe_output *output,
>  			reg = VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN;
>  			if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV16)
>  				reg |= VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA;
> +		} else {
> +			/* On current devices output->wm_num is always <= 2 */
> +			break;
>  		}
>  
>  		if (output->wm_idx[i] % 2 == 1)
> 
