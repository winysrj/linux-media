Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:37356 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbcGFJn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 05:43:57 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v3 10/15] [media] lirc_dev: remove compat_ioctl assignment
Date: Wed, 06 Jul 2016 18:01:22 +0900
Message-id: <1467795687-10737-11-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
References: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to check for CONFIG_COMPAT and consequently
assign the compat_ioctl.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 71ff820..09bdd69 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -150,9 +150,6 @@ static const struct file_operations lirc_dev_fops = {
 	.write		= lirc_dev_fop_write,
 	.poll		= lirc_dev_fop_poll,
 	.unlocked_ioctl	= lirc_dev_fop_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= lirc_dev_fop_ioctl,
-#endif
 	.open		= lirc_dev_fop_open,
 	.release	= lirc_dev_fop_close,
 	.llseek		= noop_llseek,
-- 
2.8.1

