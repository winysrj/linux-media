Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3411 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3LNL3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 06:29:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 07/15] saa7134: use V4L2_IN_ST_NO_SIGNAL instead of NO_SYNC
Date: Sat, 14 Dec 2013 12:28:29 +0100
Message-Id: <1387020517-26242-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
References: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
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
index 5cf9cc6..2334bf9 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1524,7 +1524,7 @@ int saa7134_enum_input(struct file *file, void *priv, struct v4l2_input *i)
 		if (0 != (v1 & 0x40))
 			i->status |= V4L2_IN_ST_NO_H_LOCK;
 		if (0 != (v2 & 0x40))
-			i->status |= V4L2_IN_ST_NO_SYNC;
+			i->status |= V4L2_IN_ST_NO_SIGNAL;
 		if (0 != (v2 & 0x0e))
 			i->status |= V4L2_IN_ST_MACROVISION;
 	}
-- 
1.8.4.3

