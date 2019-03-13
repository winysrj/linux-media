Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B52C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 21:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B338B213A2
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 21:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfCMVSF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 17:18:05 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:51379 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbfCMVSF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 17:18:05 -0400
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M6DrU-1h6N6r3iMi-006dm8; Wed, 13 Mar 2019 22:17:50 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Rui Miguel Silva <rmfrfs@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: imx7-mipi-csis: fix debugfs compilation
Date:   Wed, 13 Mar 2019 22:17:32 +0100
Message-Id: <20190313211748.534491-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:SNoTQV7pLQFErYrCNqEuueldEPoz3NgvQS/zQAfLXbLZtg4/4XZ
 NqyoHVcn7AhLm+pyB8v/i+4lhKm/81zxi7RYUUZK3aFFrNBiW7EDRJ6+bbH1hVAC/pThdxT
 LDC7HAy5Yn9SKZt5gTSSRdrlRL8si9GPCpFsFMz1D9q3jnjjsOzRAKJ1y4E9ZtegvjqIOUv
 BjjFfwbmoU3Xa3bnRuQ7A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:kKpUg2pwm14=:LFCX4kSxrSCpSEmc9VbExf
 yI1hzlHRzBM71i49cew+IL6e+igPq7iprPxL9WpUqjUNlfrgdbOcoLoXy2U4/pXs8/5ejCphj
 ZKroi7Dw1Nn9md4uITL6kaAPAfxOuMmxgqeobcc7tRQwS06UdkcWUml3vZR7rdnuT/oSPDnpl
 ycUDJzWdnMqzJt4LOxNLKLgcqC5FtNPjDAIfRYR690u11WCZatOLiqN1mA4pYXFa6VJp4GH3W
 SDOX/M6Q81ceWPq/e5m8/2B8dN2m37TEK3dmXzHLuvDPjMWXy5uK4tGV7H0o8l9oZVwYDKgcc
 FmssSwF63XYckaMbI6wn3cqs9UXqk+PTq68YKESA/JETOqcZkgzvjQ5syAmXcXx1qbozcyefJ
 brnCqZ4a/TBrTQUW5d5vCl4ETDoPmHbhJEzsCELg2fIo06WWP1wrdpKOWnE2dqioFTh2i1zVK
 Kai6qWu7hHDIVOkTN8IgAwafDRE221Z9R5PGMj4sj+tEjd+WVS+EwKZBPYUCEmSQNMUna9dTe
 yP1KFvz+3pKzRFw8JqLsLYf/2hiUI8Cls6bJKhjxHS3sBuWuwmOn68RZrEeptjb6frb+RVLAk
 Fc4vHTHq04VgFmnddxekI3vMkpfBVZQg9NoELIElX8kNVhOxAS435UvKDuG73fajoneYnUqu+
 xCPLcCt491MLFJ1Qepf6kOMHcMXbf9fu3Sd+myniIxQHxangIPOAqzyPHM5pKDGmKgiv7AcKF
 diQGrDy9NGJyDMGiHM22m/hTuQi2WvRVSQ2t3Q==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

When CONFIG_DEBUGFS is enabled, we get a warning about an
incorrect section annotation that can lead to undefined
behavior:

WARNING: vmlinux.o(.text+0xd3c7c4): Section mismatch in reference from the function mipi_csis_probe() to the function .init.text:mipi_csis_debugfs_init()
The function mipi_csis_probe() references
the function __init mipi_csis_debugfs_init().
This is often because mipi_csis_probe lacks a __init
annotation or the annotation of mipi_csis_debugfs_init is wrong.

The same function for an unknown reason has a different
version for !CONFIG_DEBUGFS, which does not have this problem,
but behaves the same way otherwise (it does nothing when debugfs
is disabled).
Consolidate the two versions, using the correct section from
one version, and the implementation from the other.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/imx/imx7-mipi-csis.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c b/drivers/staging/media/imx/imx7-mipi-csis.c
index 2ddcc42ab8ff..001ce369ec45 100644
--- a/drivers/staging/media/imx/imx7-mipi-csis.c
+++ b/drivers/staging/media/imx/imx7-mipi-csis.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
@@ -889,8 +890,6 @@ static int mipi_csis_subdev_init(struct v4l2_subdev *mipi_sd,
 	return ret;
 }
 
-#ifdef CONFIG_DEBUG_FS
-#include <linux/debugfs.h>
 
 static int mipi_csis_dump_regs_show(struct seq_file *m, void *private)
 {
@@ -900,7 +899,7 @@ static int mipi_csis_dump_regs_show(struct seq_file *m, void *private)
 }
 DEFINE_SHOW_ATTRIBUTE(mipi_csis_dump_regs);
 
-static int __init_or_module mipi_csis_debugfs_init(struct csi_state *state)
+static int mipi_csis_debugfs_init(struct csi_state *state)
 {
 	struct dentry *d;
 
@@ -934,17 +933,6 @@ static void mipi_csis_debugfs_exit(struct csi_state *state)
 	debugfs_remove_recursive(state->debugfs_root);
 }
 
-#else
-static int mipi_csis_debugfs_init(struct csi_state *state __maybe_unused)
-{
-	return 0;
-}
-
-static void mipi_csis_debugfs_exit(struct csi_state *state __maybe_unused)
-{
-}
-#endif
-
 static int mipi_csis_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-- 
2.20.0

