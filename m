Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3511 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965701Ab3E2LBQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCHv1 30/38] au0828: set reg->size.
Date: Wed, 29 May 2013 13:00:03 +0200
Message-Id: <1369825211-29770-31-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The size field wasn't filled in.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/usb/au0828/au0828-video.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 4944a36..f615454 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1759,6 +1759,7 @@ static int vidioc_g_register(struct file *file, void *priv,
 	struct au0828_dev *dev = fh->dev;
 
 	reg->val = au0828_read(dev, reg->reg);
+	reg->size = 1;
 	return 0;
 }
 
-- 
1.7.10.4

