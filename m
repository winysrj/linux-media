Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9627 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab2BTJdq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 04:33:46 -0500
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZO004T4QK7MF@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Feb 2012 09:33:43 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZO00K2XQK7UR@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Feb 2012 09:33:43 +0000 (GMT)
Date: Mon, 20 Feb 2012 10:33:33 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/3] m5mols: Make subdev name independent of the I2C slave
 address
In-reply-to: <1329730414-7757-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1329730414-7757-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1329730414-7757-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialize the subdev name properly so it doesn't have an I2C
bus and slave address appended to it.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 5e50c31..5f9722f 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -997,8 +997,8 @@ static int __devinit m5mols_probe(struct i2c_client *client,
 	}
 
 	sd = &info->sd;
-	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
 	v4l2_i2c_subdev_init(sd, client, &m5mols_ops);
+	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 	sd->internal_ops = &m5mols_subdev_internal_ops;
-- 
1.7.9

