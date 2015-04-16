Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:37608 "EHLO m12-18.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757433AbbDPNLh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 09:11:37 -0400
From: weiyj_lk@163.com
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kiran Padwal <kiran.padwal@smartplayin.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Jingoo Han <jg1.han@samsung.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH -next] staging: dt3155v4l: remove unused including <linux/version.h>
Date: Thu, 16 Apr 2015 21:08:38 +0800
Message-Id: <1429189718-23900-1-git-send-email-weiyj_lk@163.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index e60a53e..7946ee0 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -19,7 +19,6 @@
  ***************************************************************************/
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/stringify.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>

