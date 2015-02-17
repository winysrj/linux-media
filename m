Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43928 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932954AbbBQIou (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 03:44:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/6] radio-bcm2048: use unlocked_ioctl instead of ioctl
Date: Tue, 17 Feb 2015 09:44:05 +0100
Message-Id: <1424162649-17249-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1424162649-17249-1-git-send-email-hverkuil@xs4all.nl>
References: <1424162649-17249-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver does its own locking, so there is no need to use
ioctl instead of unlocked_ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 5382506..512fa26 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2274,7 +2274,7 @@ done:
  */
 static const struct v4l2_file_operations bcm2048_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	/* for RDS read support */
 	.open		= bcm2048_fops_open,
 	.release	= bcm2048_fops_release,
-- 
2.1.4

