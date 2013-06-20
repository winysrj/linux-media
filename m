Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3619 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965461Ab3FTNpD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 09:45:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 07/15] saa7134: use V4L2_IN_ST_NO_SIGNAL instead of NO_SYNC
Date: Thu, 20 Jun 2013 15:44:23 +0200
Message-Id: <1371735871-2658-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371735871-2658-1-git-send-email-hverkuil@xs4all.nl>
References: <1371735871-2658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

NO_SYNC was meant for DVB and shouldn't be used anymore.

In this case NO_SIGNAL is a good alternative.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 9dc6c0d..a3b4fad 100644
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
1.8.3.1

