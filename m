Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2733 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab1HYOIr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 10:08:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 03/12] wl128x: fix compiler warning + wrong write() return.
Date: Thu, 25 Aug 2011 16:08:26 +0200
Message-Id: <cc3d210aa59d0665ce46f5f9dfd79c0881cd2327.1314281302.git.hans.verkuil@cisco.com>
In-Reply-To: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
References: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
References: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l-dvb-git/drivers/media/radio/wl128x/fmdrv_v4l2.c: In function 'fm_v4l2_fops_write':
v4l-dvb-git/drivers/media/radio/wl128x/fmdrv_v4l2.c:81:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]

The fix is to check for ret and return -EFAULT if non-zero.

I also noticed that write() didn't return the number of bytes written.
Fixed as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/wl128x/fmdrv_v4l2.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 8c0e192..478d1e9 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -84,12 +84,14 @@ static ssize_t fm_v4l2_fops_write(struct file *file, const char __user * buf,
 	ret = copy_from_user(&rds, buf, sizeof(rds));
 	fmdbg("(%d)type: %d, text %s, af %d\n",
 		   ret, rds.text_type, rds.text, rds.af_freq);
+	if (ret)
+		return -EFAULT;
 
 	fmdev = video_drvdata(file);
 	fm_tx_set_radio_text(fmdev, rds.text, rds.text_type);
 	fm_tx_set_af(fmdev, rds.af_freq);
 
-	return 0;
+	return sizeof(rds);
 }
 
 static u32 fm_v4l2_fops_poll(struct file *file, struct poll_table_struct *pts)
-- 
1.7.5.4

