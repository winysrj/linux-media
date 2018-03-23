Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40847 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753799AbeCWL53 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>
Subject: [PATCH 03/30] media: dvb_frontend: add proper __user annotations
Date: Fri, 23 Mar 2018 07:56:49 -0400
Message-Id: <f44d6107f87936c0359358184627fd82e60bd4b0.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Solves those warnings:
	drivers/media/dvb-core/dvb_frontend.c:2297:39: warning: incorrect type in argument 1 (different address spaces)
	drivers/media/dvb-core/dvb_frontend.c:2297:39:    expected void const [noderef] <asn:1>*<noident>
	drivers/media/dvb-core/dvb_frontend.c:2297:39:    got struct dtv_property *props
	drivers/media/dvb-core/dvb_frontend.c:2331:39: warning: incorrect type in argument 1 (different address spaces)
	drivers/media/dvb-core/dvb_frontend.c:2331:39:    expected void const [noderef] <asn:1>*<noident>
	drivers/media/dvb-core/dvb_frontend.c:2331:39:    got struct dtv_property *props

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index a7ed16e0841d..21a7d4b47e1a 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2294,7 +2294,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
-		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
+		tvp = memdup_user((void __user *)tvps->props, tvps->num * sizeof(*tvp));
 		if (IS_ERR(tvp))
 			return PTR_ERR(tvp);
 
@@ -2328,7 +2328,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
-		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
+		tvp = memdup_user((void __user *)tvps->props, tvps->num * sizeof(*tvp));
 		if (IS_ERR(tvp))
 			return PTR_ERR(tvp);
 
-- 
2.14.3
