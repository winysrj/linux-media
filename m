Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57905
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752106AbdFHPZU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 11:25:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Peter Griffin <peter.griffin@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Rick Chang <rick.chang@mediatek.com>,
        Songjun Wu <songjun.wu@microchip.com>
Subject: [PATCH] [media] platform/Makefile: don't depend on arch to include dirs
Date: Thu,  8 Jun 2017 12:24:52 -0300
Message-Id: <6c4ae51b700d303165afed802dac81b0e32c0f53.1496935487.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Depending on arch configs to include dirs is evil, and makes
harder to change drivers to work with COMPILE_TEST.

Replace them by obj-y.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 231f3c2894c9..c3588d570f5d 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -44,9 +44,9 @@ obj-$(CONFIG_VIDEO_STI_HDMI_CEC) 	+= sti/cec/
 
 obj-$(CONFIG_VIDEO_STI_DELTA)		+= sti/delta/
 
-obj-$(CONFIG_BLACKFIN)                  += blackfin/
+obj-y                                   += blackfin/
 
-obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
+obj-y					+= davinci/
 
 obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
 
-- 
2.9.4
