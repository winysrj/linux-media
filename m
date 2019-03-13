Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A930C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 21:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 116F8213A2
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 21:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfCMVSt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 17:18:49 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:58273 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfCMVSt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 17:18:49 -0400
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MkYsS-1gdLUj2G22-00m5UP; Wed, 13 Mar 2019 22:18:27 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: seco-cec: fix building with RC_CORE=m
Date:   Wed, 13 Mar 2019 22:18:07 +0100
Message-Id: <20190313211825.571994-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:/y0Ua3LOKhN9lVs5dO16orTPEUdx2ZZowrhF4dLm1TLSbqDY943
 NL9Jg8WeK8jA2N6z+jsl/T7awggk16IMBjPIY/39wfL7hgFt23dEmVCz0SWzdyHKZ/1VWqM
 VtZf5jaXwjLKbdT7p1InqQ4tX905RxPtakWXAXYgRyI0gRpmp2x6GLOlXI/7y0CSc4LPAjY
 LBUP6UZNy40DBEmWTV0kQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:AyvQ7t2Xz0g=:24UnJUcG+X2Ez//KBUEmlX
 VddFq9Ai4kOMx3b17cbNRjQtrPfItrXwvZTjv2S6hChI5DmK4ISybsVm09Ri6tBXTmn5hyPE7
 RS36Miy1t/1IUEYYA3PsbslIuOHRFTsJvMzVi3/U5wllWE0zIp+YALfkggDbPXL6GeKkRlwNE
 U1Ig65ODhMXkJRjNisrJK5fRPTilNnxBndK/3E6hYQjW/vAXudde6hI46dtLrjDKwcAlZ6Xep
 eNwmAF8xfKRJValsjal4+CnvL+DJ3b9MYdLjnaHDOlTzQlYyPN9e1GAodgp9QvlJZVbi7/Jmu
 ZZEB4olPB9ACU2pfUt87ZVOoDVe9xZuGDGpMybP/GYWCSZ+h9fpWDzsdcqhkWvjET/ApSpFVe
 e39vF1HeXauSg1JuJ0fGhH9WXCOMh/0tZCOjlOM+bOUmdFeAyCZfxIu1dO44K4f+hHkBEDavH
 qfBnn92Fm+uVb0UWfFeXoqcLulM1baQ6F9H91l7ZKdH3IyVfbaszOjz5jtcTCRfNp+LQCfarl
 feWs8+FHRsVuuGQcnxCXeUSBR1X8A6mkGKIXcgW6PzBDN3k8WTkgciSwIgKDJgMyB1rcpq5NB
 iUYLpiRn2Nj83yB0C3MFfm0D1ORRcmbaspkm/7+IBjJxuEB/JFOjcGTpx7friPN2bLD47l12N
 qNpun4OEdPk4Zjcxyk+tbc/59zoz0eJwkXL5nteP3JSvmRuUd4OftlwzyS74xTRB+zuOdS29Z
 VzmlwRWCekVw0MI0bZpl7/D9NzVUgxyLIScRHQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

I previously added an RC_CORE dependency here, but missed the corner
case of CONFIG_VIDEO_SECO_CEC=y with CONFIG_RC_CORE=m, which still
causes a link error:

drivers/media/platform/seco-cec/seco-cec.o: In function `secocec_probe':
seco-cec.c:(.text+0x1b8): undefined reference to `devm_rc_allocate_device'
seco-cec.c:(.text+0x2e8): undefined reference to `devm_rc_register_device'
drivers/media/platform/seco-cec/seco-cec.o: In function `secocec_irq_handler':
seco-cec.c:(.text+0xa2c): undefined reference to `rc_keydown'

Refine the dependency to disallow building the RC subdriver in this case.
This is the same logic we apply in other drivers like it.

Fixes: f27dd0ad6885 ("media: seco-cec: fix RC_CORE dependency")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 4acbed189644..67e48ff10532 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -649,7 +649,7 @@ config VIDEO_SECO_CEC
 config VIDEO_SECO_RC
 	bool "SECO Boards IR RC5 support"
 	depends on VIDEO_SECO_CEC
-	depends on RC_CORE
+	depends on RC_CORE=y || RC_CORE = VIDEO_SECO_CEC
 	help
 	  If you say yes here you will get support for the
 	  SECO Boards Consumer-IR in seco-cec driver.
-- 
2.20.0

