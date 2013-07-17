Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([94.23.35.102]:49292 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab3GQInZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 04:43:25 -0400
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] stk1160: Allow to change input while streaming
Date: Wed, 17 Jul 2013 05:43:22 -0300
Message-Id: <1374050602-2516-1-git-send-email-ezequiel.garcia@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the check as there's no reason to prevent the input from
being set when the device is streaming. This allows surveillance
applications (such as motion, zoneminder, etc.) to configure the
input while streaming.

Reported-by: Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>
Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
Cc: Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>
Cc: Hans Verkuil <hans.verkuil@cisco.com>

 drivers/media/usb/stk1160/stk1160-v4l.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 876fc26..ee46d82 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -440,9 +440,6 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
 	struct stk1160 *dev = video_drvdata(file);
 
-	if (vb2_is_busy(&dev->vb_vidq))
-		return -EBUSY;
-
 	if (i > STK1160_MAX_INPUT)
 		return -EINVAL;
 
-- 
1.8.1.5

