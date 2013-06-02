Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2934 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab3FBK4g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 06:56:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 14/16] saa7134: use V4L2_IN_ST_NO_SIGNAL instead of NO_SYNC
Date: Sun,  2 Jun 2013 12:56:05 +0200
Message-Id: <1370170567-7004-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
References: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

NO_SYNC was meant for DVB and shouldn't be used anymore.

In this case NO_SIGNAL is a good alternative.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index fa6cc17..44b7ed2 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1523,7 +1523,7 @@ int saa7134_enum_input(struct file *file, void *priv, struct v4l2_input *i)
 		if (0 != (v1 & 0x40))
 			i->status |= V4L2_IN_ST_NO_H_LOCK;
 		if (0 != (v2 & 0x40))
-			i->status |= V4L2_IN_ST_NO_SYNC;
+			i->status |= V4L2_IN_ST_NO_SIGNAL;
 		if (0 != (v2 & 0x0e))
 			i->status |= V4L2_IN_ST_MACROVISION;
 	}
-- 
1.7.10.4

