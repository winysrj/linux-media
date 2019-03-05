Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CD5C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 13:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F151C206DD
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 13:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfCEN3w (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 08:29:52 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:41229 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbfCEN3w (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 08:29:52 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MpUlO-1hJwTb07J6-00prAc; Tue, 05 Mar 2019 14:29:27 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Yong Zhi <yong.zhi@intel.com>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] media: staging/intel-ipu3: reduce kernel stack usage
Date:   Tue,  5 Mar 2019 14:26:29 +0100
Message-Id: <20190305132924.3889416-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Lg/SskIDeHvGAyJNfeHro9IMUKhzdZuNTkJW4Kzls0ly1gshGfo
 BbuOZomN20K8hFMf3BKAY3ygAE2QD8iVW18O8eJJUOk/enUWdnFbQNK/Yra26UPJQMczD0Y
 4UKw1YfrO/LBwE/QIbtTFDOsh1NZ5aOe+bAL/vk5WvfDTpjijbdOXxRxh4qiwWbllcqBby5
 Uc9XPSI8+rAum6g3SLfKw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:DrYNpH9E0Uk=:NVd1Yx8oK8bpALYp0HkTfm
 YpdO1mavC3d3YiC6CX8nkDtjc4JkWXBEp+1Yr7+fibnNPHRp9nxiAQfC8NYzQ0tYuYE7ihsw9
 qZh1YCRTXOxTq8eTkNzSmtWDyn3hJO5JGNYNc0PXKMxd9oecGICv1g4Plk8+JSTVG79MrsR2T
 t3zp33pxMH1xCLiG3inNhG1um2e6FfJO+42lvw1ccyAbmPcyglJykRiEohsl8mjXnbyZB+Jub
 Psk7UyRBXmvjISuTRI94gCQPFn8m6KvemnyDbbFhB63p7C+DJY6mhMVZicb+Sx2QsAqnQnyR+
 1GxPLlpQmT60t59lFi5FawdAHZBn20Z63to9oNIc6gR447c5sqS12vlN4WmBPRbzI9o4iV46L
 5XNADgz4Zb3TzgOb0CCdwTRpkrJQxoxOFMdWaejAVkXsBkMVz6AEYtD74wfkHHVej5v8/LZcB
 LOOyrTMk5HNbyIQqaHF0awLBDej5PDcLwYPtbRwnvnxvZf7mgGxV4JEyp5yIGdS9mcRCWOOUB
 BgE5hbf6G3gkdYLA+EweNM4ofDw9NsP3f4VOdjWX6wjyXpn3eVxTk+lSkFYq3pnC+4AOn1S9B
 ia9w9DLenwi0PP9JZV5aq0hy3UN5SIdNsQrVlc4lTaFv8Ur7GKpmpPHZhHhbpW+r3lrTKcAh6
 Kix3bRsM/Oeibm56TXOT/BfAdLkxMmNT1zsm65JvzUHhcFzgdsiwYkKEhG/ScRlkWNoGH8p7T
 AAmWF6qwn8fbnYJTu6YCULJDDsJPzKO7tlD24Q==
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
v2: restructure to use 'return -ENOMEM' instead of goto for failed
    allocation.
---
 drivers/staging/media/ipu3/ipu3-css.c | 35 ++++++++++++++++++---------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
index 15ab77e4b766..e7f1898874fd 100644
--- a/drivers/staging/media/ipu3/ipu3-css.c
+++ b/drivers/staging/media/ipu3/ipu3-css.c
@@ -3,6 +3,7 @@
 
 #include <linux/device.h>
 #include <linux/iopoll.h>
+#include <linux/slab.h>
 
 #include "ipu3-css.h"
 #include "ipu3-css-fw.h"
@@ -1744,15 +1745,18 @@ int imgu_css_fmt_try(struct imgu_css *css,
 	struct v4l2_rect *const bds = &r[IPU3_CSS_RECT_BDS];
 	struct v4l2_rect *const env = &r[IPU3_CSS_RECT_ENVELOPE];
 	struct v4l2_rect *const gdc = &r[IPU3_CSS_RECT_GDC];
-	struct imgu_css_queue q[IPU3_CSS_QUEUES];
-	struct v4l2_pix_format_mplane *const in =
-					&q[IPU3_CSS_QUEUE_IN].fmt.mpix;
-	struct v4l2_pix_format_mplane *const out =
-					&q[IPU3_CSS_QUEUE_OUT].fmt.mpix;
-	struct v4l2_pix_format_mplane *const vf =
-					&q[IPU3_CSS_QUEUE_VF].fmt.mpix;
+	struct imgu_css_queue *q;
+	struct v4l2_pix_format_mplane *in, *out, *vf;
 	int i, s, ret;
 
+	q = kcalloc(IPU3_CSS_QUEUES, sizeof(struct imgu_css_queue), GFP_KERNEL);
+	if (!q)
+		return -ENOMEM;
+
+	in  = &q[IPU3_CSS_QUEUE_IN].fmt.mpix;
+	out = &q[IPU3_CSS_QUEUE_OUT].fmt.mpix;
+	vf  = &q[IPU3_CSS_QUEUE_VF].fmt.mpix;
+
 	/* Adjust all formats, get statistics buffer sizes and formats */
 	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
 		if (fmts[i])
@@ -1766,7 +1770,8 @@ int imgu_css_fmt_try(struct imgu_css *css,
 					IPU3_CSS_QUEUE_TO_FLAGS(i))) {
 			dev_notice(css->dev, "can not initialize queue %s\n",
 				   qnames[i]);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 	}
 	for (i = 0; i < IPU3_CSS_RECTS; i++) {
@@ -1788,7 +1793,8 @@ int imgu_css_fmt_try(struct imgu_css *css,
 	if (!imgu_css_queue_enabled(&q[IPU3_CSS_QUEUE_IN]) ||
 	    !imgu_css_queue_enabled(&q[IPU3_CSS_QUEUE_OUT])) {
 		dev_warn(css->dev, "required queues are disabled\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	if (!imgu_css_queue_enabled(&q[IPU3_CSS_QUEUE_OUT])) {
@@ -1829,7 +1835,8 @@ int imgu_css_fmt_try(struct imgu_css *css,
 	ret = imgu_css_find_binary(css, pipe, q, r);
 	if (ret < 0) {
 		dev_err(css->dev, "failed to find suitable binary\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 	css->pipes[pipe].bindex = ret;
 
@@ -1843,7 +1850,8 @@ int imgu_css_fmt_try(struct imgu_css *css,
 						IPU3_CSS_QUEUE_TO_FLAGS(i))) {
 				dev_err(css->dev,
 					"final resolution adjustment failed\n");
-				return -EINVAL;
+				ret = -EINVAL;
+				goto out;
 			}
 			*fmts[i] = q[i].fmt.mpix;
 		}
@@ -1859,7 +1867,10 @@ int imgu_css_fmt_try(struct imgu_css *css,
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

