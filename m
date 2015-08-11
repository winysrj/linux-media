Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:55205 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934066AbbHKN0X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 09:26:23 -0400
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NSX021876NXE000@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Aug 2015 22:26:21 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] media: flash: Don't initialize core ops
Date: Tue, 11 Aug 2015 15:26:12 +0200
Message-id: <1439299572-9293-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

queryctrl and querymenu menu ops don't need to be initialized
if sd.ctrl_handler is set. Since no other core ops are required
by the wrapper don't initialize related field of v4l2_flash_subdev_ops.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-flash-led-class.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
index 5bdfb8d..57a1829 100644
--- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
+++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
@@ -609,13 +609,7 @@ static const struct v4l2_subdev_internal_ops v4l2_flash_subdev_internal_ops = {
 	.close = v4l2_flash_close,
 };
 
-static const struct v4l2_subdev_core_ops v4l2_flash_core_ops = {
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
-};
-
 static const struct v4l2_subdev_ops v4l2_flash_subdev_ops = {
-	.core = &v4l2_flash_core_ops,
 };
 
 struct v4l2_flash *v4l2_flash_init(
-- 
1.7.9.5

