Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:45896 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbbB0LnQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2015 06:43:16 -0500
From: weiyj_lk@163.com
To: Mike Isely <isely@pobox.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media@vger.kernel.org
Subject: [PATCH] [media] v4l2: remove unused including <linux/version.h>
Date: Fri, 27 Feb 2015 19:42:23 +0800
Message-Id: <1425037343-23394-1-git-send-email-weiyj_lk@163.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 536210b..6489db8 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -21,7 +21,6 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include "pvrusb2-context.h"
 #include "pvrusb2-hdw.h"
 #include "pvrusb2.h"

