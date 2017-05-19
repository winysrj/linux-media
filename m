Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46438
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750728AbdESMKO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 08:10:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 4/6] [media] soc_camera: annotate a switch fall through
Date: Fri, 19 May 2017 09:10:02 -0300
Message-Id: <d0994fe9ba22895e56b943ff3f03f2b39fcaa397.1495195712.git.mchehab@s-opensource.com>
In-Reply-To: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
References: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
In-Reply-To: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
References: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clearly, hsync and vsinc bool vars are part of the return
logic on the second case of the switch. Annotate that, in
order to shut up gcc warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/soc_camera/soc_mediabus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
index e3e665e1c503..57581f626f4c 100644
--- a/drivers/media/platform/soc_camera/soc_mediabus.c
+++ b/drivers/media/platform/soc_camera/soc_mediabus.c
@@ -494,6 +494,7 @@ unsigned int soc_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
 					V4L2_MBUS_HSYNC_ACTIVE_LOW);
 		vsync = common_flags & (V4L2_MBUS_VSYNC_ACTIVE_HIGH |
 					V4L2_MBUS_VSYNC_ACTIVE_LOW);
+		/* fall through */
 	case V4L2_MBUS_BT656:
 		pclk = common_flags & (V4L2_MBUS_PCLK_SAMPLE_RISING |
 				       V4L2_MBUS_PCLK_SAMPLE_FALLING);
-- 
2.9.3
