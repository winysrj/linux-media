Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:46638 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbbIIGly (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2015 02:41:54 -0400
Message-ID: <55EFD467.2030208@xs4all.nl>
Date: Wed, 09 Sep 2015 08:40:39 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH] v4l2-compat-ioctl32: replace pr_warn by pr_debug
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Every time compat32 encounters an unknown ioctl it will call pr_warn.
However, that's very irritating since it is perfectly normal that this
happens. For example, applications often try to call an ioctl to see if
it exists, and if that's used with an older kernel where compat32 doesn't
support that ioctl yet, then it starts spamming the kernel log.

So replace pr_warn by pr_debug.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index af63543..ba26a19 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -1033,8 +1033,8 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 		ret = vdev->fops->compat_ioctl32(file, cmd, arg);
 
 	if (ret == -ENOIOCTLCMD)
-		pr_warn("compat_ioctl32: unknown ioctl '%c', dir=%d, #%d (0x%08x)\n",
-			_IOC_TYPE(cmd), _IOC_DIR(cmd), _IOC_NR(cmd), cmd);
+		pr_debug("compat_ioctl32: unknown ioctl '%c', dir=%d, #%d (0x%08x)\n",
+			 _IOC_TYPE(cmd), _IOC_DIR(cmd), _IOC_NR(cmd), cmd);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(v4l2_compat_ioctl32);
-- 
2.1.4

