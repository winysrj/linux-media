Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:50931 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750848AbdKANDU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 09:03:20 -0400
Date: Wed, 1 Nov 2017 11:03:14 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [RFC] media: camss-vfe: always initialize reg at
 vfe_set_xbar_cfg()
Message-ID: <20171101110314.482206b6@vento.lan>
In-Reply-To: <a3b51962-1316-c7cf-1182-5a5d7f0ed719@linaro.org>
References: <20e982c47af6eafe58274fa299ec587b2fb91d32.1509538566.git.mchehab@s-opensource.com>
        <a3b51962-1316-c7cf-1182-5a5d7f0ed719@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

Em Wed, 1 Nov 2017 14:38:02 +0200
Todor Tomov <todor.tomov@linaro.org> escreveu:

> Hi Mauro,
> 
> Thank you for pointing to this.
> 
> On  1.11.2017 14:16, Mauro Carvalho Chehab wrote:
> > if output->wm_num is bigger than 1, the value for reg is  
> If output->wn_num equals 2, we handle all cases (i == 0, i == 1) and set reg properly.
> If output->wn_num is bigger than 2, then reg will not be initialized. However this is something that "cannot happen" and because of this the case is not handled.
> 
> So I think that there is nothing wrong really but we have to do something to remove the warning. I agree with your patch, it is technically not a right value for reg but any cases in which wm_num is bigger than 2 are not supported anyway and should not happen.

Thanks for your promptly answer. Well, if i is always at the [0..1] range,
then I guess the enclosed patch is actually better.


Thanks,
Mauro


[PATCH] media: camss-vfe: always initialize reg at vfe_set_xbar_cfg()

if output->wm_num is bigger than 2, the value for reg is
not initialized, as warned by smatch:
	drivers/media/platform/qcom/camss-8x16/camss-vfe.c:633 vfe_set_xbar_cfg() error: uninitialized symbol 'reg'.
	drivers/media/platform/qcom/camss-8x16/camss-vfe.c:637 vfe_set_xbar_cfg() error: uninitialized symbol 'reg'.

That shouldn't happen in practice, so add a logic that will
break the loop if i > 1, fixing the warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
index b22d2dfcd3c2..55232a912950 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
@@ -622,6 +622,9 @@ static void vfe_set_xbar_cfg(struct vfe_device *vfe, struct vfe_output *output,
 			reg = VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN;
 			if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV16)
 				reg |= VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA;
+		} else {
+			/* On current devices output->wm_num is always <= 2 */
+			break;
 		}
 
 		if (output->wm_idx[i] % 2 == 1)
