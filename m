Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:57719 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbcF2NVF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 09:21:05 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH 10/15] lirc_dev: remove CONFIG_COMPAT precompiler check
Date: Wed, 29 Jun 2016 22:20:39 +0900
Message-id: <1467206444-9935-11-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
References: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to check in precompilation whether the ioctl is
compat or unlocked, depending on the configuration it will be
called the correct one.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 0c26609..c11cfc0 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -149,9 +149,7 @@ static const struct file_operations lirc_dev_fops = {
 	.write		= lirc_dev_fop_write,
 	.poll		= lirc_dev_fop_poll,
 	.unlocked_ioctl	= lirc_dev_fop_ioctl,
-#ifdef CONFIG_COMPAT
 	.compat_ioctl	= lirc_dev_fop_ioctl,
-#endif
 	.open		= lirc_dev_fop_open,
 	.release	= lirc_dev_fop_close,
 	.llseek		= noop_llseek,
-- 
2.8.1

