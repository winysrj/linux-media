Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335AFC43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 20:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09CD320823
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 20:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfCDU2N (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 15:28:13 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:33865 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfCDU2N (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2019 15:28:13 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MJWgK-1ghANs1Xuy-00JrRZ; Mon, 04 Mar 2019 21:28:00 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Yong Zhi <yong.zhi@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: staging/intel-ipu3: reduce kernel stack usage
Date:   Mon,  4 Mar 2019 21:27:40 +0100
Message-Id: <20190304202758.1802417-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:iLWJcvC1yYliJhjetU1d1V8vOyR3NSm1Fu9LSQ8C60gRPjWpepO
 qTZ75PauvqQEYU/gLcmTCe0suTzZgPFRfwM07E9bFgJzg0OiyNJ0kdCF397ovbhWIa7sOx0
 xT3lskQX9WYXb2vGSDy+BznQ/zBoZOP1i/NNsOu5oQiZsoOp2tK1ezQdzGqhFxk50+Hsl7/
 RJRdPoKxSPmouJcfpqJwg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:SXpmyngCR04=:zEFWA7PqTPFepgdRpbJcL5
 AYikxm8lNQ9DPzi3Fx74oG9XLO/p+n//woEeYA5bBl1G1L4PVI40d+KrH8YTrqydHEMu3qudi
 nFHFCtqXOlBlrZcSCUneP2u7UX/q4nE1gqGcAyusIWrqxinBEMNxCiixvnuSkX/8zpkMovt3c
 gjArBR86L74nrRhU7KO2nJdyHCzWxGVc2Yum7aK1Jr0w86UHsyqWzya6hdA2GNo0aoca2uIr5
 txYV75e5eSpJ0+wFEUQ7BcuC27cVY9F+E5mXti6zcScecP3Ah+JfhfpIIBBk6vIY60zarSMtB
 eV1zJfV6qQ8dKMmJf/OLrJJdVe8buDVTEGtktZplabqgfp8qlERqZSkCpUyuDXUGYFbufJKSD
 1MFUn/SXz7kLu1fz5CbuQAQ/Ezcl53gYdDNv7aR6b472ae6hlXepCcBmmNL6V5EfKg/nBAWPn
 PLgD/3+fdXwNmleQ326wmVh6d91hlCgdrS53Yon70MoG0Rk920SA8VDLWie/VSHkaaBXPf25q
 trh8iNf+sBhPZivBv0cPXajYz5obPpm0q6V/1Zcz84zlMfFG2zoe3vuKEiYzVHqneHfrc5M1Q
 9xchKzgAcHqZh8AQ/EHnN4zK4XLIkTsHbzkUlKW07GCBfyL2UQo9UcanAkcHU8FO37WxMJFQ4
 uMU8oRsLInBLByKctXAKfICMmXEYaUbmX+D0Ku2uz4oD/TmhUMYf3ZBbe89hMWDSEAYxxjR1H
 pjNfekd1AXKNd1bZfRc3vp5qCLkDklIDgwvnZg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The imgu_css_queue structure is too large to be put on the kernel
stack, as we can see in 32-bit builds:

drivers/staging/media/ipu3/ipu3-css.c: In function 'imgu_css_fmt_try':
drivers/staging/media/ipu3/ipu3-css.c:1863:1: error: the frame size of 1172 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

By dynamically allocating this array, the stack usage goes down to an
acceptable 140 bytes for the same x86-32 configuration.

Fixes: f5f2e4273518 ("media: staging/intel-ipu3: Add css pipeline programming")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/ipu3/ipu3-css.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
index 15ab77e4b766..664c14b7a518 100644
--- a/drivers/staging/media/ipu3/ipu3-css.c
+++ b/drivers/staging/media/ipu3/ipu3-css.c
@@ -3,6 +3,7 @@
 
 #include <linux/device.h>
 #include <linux/iopoll.h>
+#include <linux/slab.h>
 
 #include "ipu3-css.h"
 #include "ipu3-css-fw.h"
@@ -1744,7 +1745,7 @@ int imgu_css_fmt_try(struct imgu_css *css,
 	struct v4l2_rect *const bds = &r[IPU3_CSS_RECT_BDS];
 	struct v4l2_rect *const env = &r[IPU3_CSS_RECT_ENVELOPE];
 	struct v4l2_rect *const gdc = &r[IPU3_CSS_RECT_GDC];
-	struct imgu_css_queue q[IPU3_CSS_QUEUES];
+	struct imgu_css_queue *q = kcalloc(IPU3_CSS_QUEUES, sizeof(struct imgu_css_queue), GFP_KERNEL);
 	struct v4l2_pix_format_mplane *const in =
 					&q[IPU3_CSS_QUEUE_IN].fmt.mpix;
 	struct v4l2_pix_format_mplane *const out =
@@ -1753,6 +1754,11 @@ int imgu_css_fmt_try(struct imgu_css *css,
 					&q[IPU3_CSS_QUEUE_VF].fmt.mpix;
 	int i, s, ret;
 
+	if (!q) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	/* Adjust all formats, get statistics buffer sizes and formats */
 	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
 		if (fmts[i])
@@ -1766,7 +1772,8 @@ int imgu_css_fmt_try(struct imgu_css *css,
 					IPU3_CSS_QUEUE_TO_FLAGS(i))) {
 			dev_notice(css->dev, "can not initialize queue %s\n",
 				   qnames[i]);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 	}
 	for (i = 0; i < IPU3_CSS_RECTS; i++) {
@@ -1788,7 +1795,8 @@ int imgu_css_fmt_try(struct imgu_css *css,
 	if (!imgu_css_queue_enabled(&q[IPU3_CSS_QUEUE_IN]) ||
 	    !imgu_css_queue_enabled(&q[IPU3_CSS_QUEUE_OUT])) {
 		dev_warn(css->dev, "required queues are disabled\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	if (!imgu_css_queue_enabled(&q[IPU3_CSS_QUEUE_OUT])) {
@@ -1829,7 +1837,8 @@ int imgu_css_fmt_try(struct imgu_css *css,
 	ret = imgu_css_find_binary(css, pipe, q, r);
 	if (ret < 0) {
 		dev_err(css->dev, "failed to find suitable binary\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 	css->pipes[pipe].bindex = ret;
 
@@ -1843,7 +1852,8 @@ int imgu_css_fmt_try(struct imgu_css *css,
 						IPU3_CSS_QUEUE_TO_FLAGS(i))) {
 				dev_err(css->dev,
 					"final resolution adjustment failed\n");
-				return -EINVAL;
+				ret = -EINVAL;
+				goto out;
 			}
 			*fmts[i] = q[i].fmt.mpix;
 		}
@@ -1859,7 +1869,10 @@ int imgu_css_fmt_try(struct imgu_css *css,
 		 bds->width, bds->height, gdc->width, gdc->height,
 		 out->width, out->height, vf->width, vf->height);
 
-	return 0;
+	ret = 0;
+out:
+	kfree(q);
+	return ret;
 }
 
 int imgu_css_fmt_set(struct imgu_css *css,
-- 
2.20.0

