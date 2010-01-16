Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:36939 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab0APN0M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 08:26:12 -0500
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Janne Grunau <j@jannau.net>,
	Patrick Boettcher <pboettcher@dibcom.fr>, tstrelar@gmail.com,
	linux-media@vger.kernel.org
Subject: [PATCH] dvb-core: remove unnecessary casting of kmalloc.
Date: Sat, 16 Jan 2010 08:25:38 -0500
Message-Id: <5d6d41f6f7ebbb3c358bb804e01cbc0b7ca8859e.1263648089.git.tfransosi@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 0746122..8eb4a3b 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1536,8 +1536,7 @@ static int dvb_frontend_ioctl_properties(struct inode *inode, struct file *file,
 		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
-		tvp = (struct dtv_property *) kmalloc(tvps->num *
-			sizeof(struct dtv_property), GFP_KERNEL);
+		tvp = kmalloc(tvps->num * sizeof(struct dtv_property), GFP_KERNEL);
 		if (!tvp) {
 			err = -ENOMEM;
 			goto out;
@@ -1569,8 +1568,7 @@ static int dvb_frontend_ioctl_properties(struct inode *inode, struct file *file,
 		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
-		tvp = (struct dtv_property *) kmalloc(tvps->num *
-			sizeof(struct dtv_property), GFP_KERNEL);
+		tvp = kmalloc(tvps->num * sizeof(struct dtv_property), GFP_KERNEL);
 		if (!tvp) {
 			err = -ENOMEM;
 			goto out;
-- 
1.6.6.103.g699d2

