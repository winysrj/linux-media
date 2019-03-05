Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDC3C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 13:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2648B206DD
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 13:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfCENaO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 08:30:14 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:43087 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfCENaO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 08:30:14 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N1x2P-1h83r31yvp-012IYJ; Tue, 05 Mar 2019 14:30:04 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mark Brown <broonie@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] media: staging: davinci_vpfe: disallow building with COMPILE_TEST
Date:   Tue,  5 Mar 2019 14:29:48 +0100
Message-Id: <20190305133001.3983736-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:vCJtvYgS+ac79qPjsnK+jOKc+05zOCdmzYdMnEBlhr5fl4PhfjM
 3c3mxVxCfhuNG+jJarNu5XsfdXimkXu9yrTnHUam4cdzAryAV1GHyC1DiwHNudOeDSNx9HS
 RqboLF6JVeDZUNMTf8MndYRzM/BDJLBaQF1NpkRTPXOgSA2yEH3OWeOWxfNtf5DqsBWosuZ
 tun0sRwohd2p99RWytwBQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:rc0q0KBJbY4=:Yl1CjxZ7OCvgjtHXpvdqWw
 YpUWtZUF6InriTzyIHBJu+BCvEoJUw/aPr9n8m6SVWVnCfoZlAwio5PPwb+zuTGrP8/GIWx8h
 oPMX06mMXPMpV6oFCBmJQXtBmu59Nq7bAeqykJK1kGXyQB3VsiY7T246JbXBHmpIR4kFQ40Pm
 45Tgt7PFCCWJqOPQOmDZxsb5N+7JMo4iZ7vPzGT7L2poyCQPP3X53BcWj+PuBbo4kS6h9bDtx
 7gEvMdUESQ/aPTEbIDX4A8+w1Pdrp7ixioWTEWUhFLOxH8ej9HYLUR2gU37RX9EMT1ts5QDgY
 ydijUHtJpDN69KsBEsuZ711H3oBh7sNufjwU5Wl70W5UM0tNacdsf/mNLLcb6x/bIfa6zUlR2
 RlD1lUkCveOq4VSmkigiayhclEown6M8BpT0ib/wL4fvrc17ULCtPVsilsmPtl0U2J9Jw7Upt
 vuavhiXcAl+QcTJLi2LWq9G7vW4qfyI638jh6PQ3w6eGZzrW9oUrhPvBH7Iu6fq2jO/UKI0Bx
 c9BnTklTmLMx+0V6uVFBSB+ppbV/JjM2/khsi0A29NdcdjXBh6htQwQbqUc7gncwT3wU3FefH
 cEk6jGApkzzwDG9vLmT32LFwNvsJc1lrHktynUWxpnUqJQxolPe2AjjbgHIDYasML+w4/i4a3
 +16JHpF+YltoQ5+uHJtg7j8EzEywYKQfyN+zCjCSG8XEFzkpJfxk2JJc39bDEJf1NtLXPU0Wi
 r+DhSOu0QNsi2zXDbw4M4rHIpL5orTjsQwjwrg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The driver should really call dm365_isif_setup_pinmux() through a callback,
but uses a hack to include a davinci specific machine header file when
compile testing instead. This works almost everywhere, but not on the
ARM omap1 platform, which has another header named mach/mux.h. This
causes a build failure:

drivers/staging/media/davinci_vpfe/dm365_isif.c:2028:2: error: implicit declaration of function 'davinci_cfg_reg' [-Werror,-Wimplicit-function-declaration]
        davinci_cfg_reg(DM365_VIN_CAM_WEN);
        ^
drivers/staging/media/davinci_vpfe/dm365_isif.c:2028:2: error: this function declaration is not a prototype [-Werror,-Wstrict-prototypes]
drivers/staging/media/davinci_vpfe/dm365_isif.c:2028:18: error: use of undeclared identifier 'DM365_VIN_CAM_WEN'
        davinci_cfg_reg(DM365_VIN_CAM_WEN);
                        ^
drivers/staging/media/davinci_vpfe/dm365_isif.c:2029:18: error: use of undeclared identifier 'DM365_VIN_CAM_VD'
        davinci_cfg_reg(DM365_VIN_CAM_VD);
                        ^
drivers/staging/media/davinci_vpfe/dm365_isif.c:2030:18: error: use of undeclared identifier 'DM365_VIN_CAM_HD'
        davinci_cfg_reg(DM365_VIN_CAM_HD);
                        ^
drivers/staging/media/davinci_vpfe/dm365_isif.c:2031:18: error: use of undeclared identifier 'DM365_VIN_YIN4_7_EN'
        davinci_cfg_reg(DM365_VIN_YIN4_7_EN);
                        ^
drivers/staging/media/davinci_vpfe/dm365_isif.c:2032:18: error: use of undeclared identifier 'DM365_VIN_YIN0_3_EN'
        davinci_cfg_reg(DM365_VIN_YIN0_3_EN);
                        ^
7 errors generated.

Exclude omap1 from compile-testing, under the assumption that all others
still work.

Fixes: 4907c73deefe ("media: staging: davinci_vpfe: allow building with COMPILE_TEST")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/davinci_vpfe/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/Kconfig b/drivers/staging/media/davinci_vpfe/Kconfig
index aea449a8dbf8..76818cc48ddc 100644
--- a/drivers/staging/media/davinci_vpfe/Kconfig
+++ b/drivers/staging/media/davinci_vpfe/Kconfig
@@ -1,7 +1,7 @@
 config VIDEO_DM365_VPFE
 	tristate "DM365 VPFE Media Controller Capture Driver"
 	depends on VIDEO_V4L2
-	depends on (ARCH_DAVINCI_DM365 && !VIDEO_DM365_ISIF) || COMPILE_TEST
+	depends on (ARCH_DAVINCI_DM365 && !VIDEO_DM365_ISIF) || (COMPILE_TEST && !ARCH_OMAP1)
 	depends on VIDEO_V4L2_SUBDEV_API
 	depends on VIDEO_DAVINCI_VPBE_DISPLAY
 	select VIDEOBUF2_DMA_CONTIG
-- 
2.20.0

