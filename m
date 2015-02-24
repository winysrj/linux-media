Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:44990 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295AbbBXSxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2015 13:53:38 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: au0828 replace printk KERN_DEBUG with pr_debug
Date: Tue, 24 Feb 2015 11:53:34 -0700
Message-Id: <1424804014-7743-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace printk KERN_DEBUG with pr_debug in dprintk macro
defined in au0828.h

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index eb15187..e3e90ea 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -336,7 +336,7 @@ extern struct vb2_ops au0828_vbi_qops;
 
 #define dprintk(level, fmt, arg...)\
 	do { if (au0828_debug & level)\
-		printk(KERN_DEBUG pr_fmt(fmt), ## arg);\
+		pr_debug(pr_fmt(fmt), ## arg);\
 	} while (0)
 
 /* au0828-input.c */
-- 
2.1.0

