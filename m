Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44139 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753855AbdKAMQV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 08:16:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH] [RFC] media: camss-vfe: always initialize reg at vfe_set_xbar_cfg()
Date: Wed,  1 Nov 2017 08:16:11 -0400
Message-Id: <20e982c47af6eafe58274fa299ec587b2fb91d32.1509538566.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

if output->wm_num is bigger than 1, the value for reg is
not initialized, as warned by smatch:
	drivers/media/platform/qcom/camss-8x16/camss-vfe.c:633 vfe_set_xbar_cfg() error: uninitialized symbol 'reg'.
	drivers/media/platform/qcom/camss-8x16/camss-vfe.c:637 vfe_set_xbar_cfg() error: uninitialized symbol 'reg'.

I didn't check the logic into its details, but there is at least
one point where wm_num is made equal to two. So, something
seem broken.

For now, I just reset it to zero, and added a FIXME. Hopefully,
the driver authors will know if this is OK, or if something else
is needed there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
index b22d2dfcd3c2..388431f747fa 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
@@ -622,6 +622,8 @@ static void vfe_set_xbar_cfg(struct vfe_device *vfe, struct vfe_output *output,
 			reg = VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN;
 			if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV16)
 				reg |= VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA;
+		} else {
+			reg = 0;	/* FIXME: is it the right value for i > 1? */
 		}
 
 		if (output->wm_idx[i] % 2 == 1)
-- 
2.13.6
