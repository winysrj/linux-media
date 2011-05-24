Return-path: <mchehab@pedra>
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16220 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467Ab1EXX5p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 19:57:45 -0400
From: <achew@nvidia.com>
To: <g.liahkovetski@gmx.de>, <mchehab@redhat.com>, <olof@lixom.net>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Andrew Chew <achew@nvidia.com>
Subject: [PATCH 2/3] [media] ov9740: Correct print in ov9740_reg_rmw()
Date: Tue, 24 May 2011 16:55:37 -0700
Message-ID: <1306281338-20247-2-git-send-email-achew@nvidia.com>
In-Reply-To: <1306281338-20247-1-git-send-email-achew@nvidia.com>
References: <1306281338-20247-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andrew Chew <achew@nvidia.com>

The register width of the ov9740 is 16-bits, so correct the debug print
to reflect this.

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
 drivers/media/video/ov9740.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index 96811e4..d5c9061 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -537,7 +537,8 @@ static int ov9740_reg_rmw(struct i2c_client *client, u16 reg, u8 set, u8 unset)
 	ret = ov9740_reg_read(client, reg, &val);
 	if (ret < 0) {
 		dev_err(&client->dev,
-			"[Read]-Modify-Write of register %02x failed!\n", reg);
+			"[Read]-Modify-Write of register 0x%04x failed!\n",
+			reg);
 		return ret;
 	}
 
@@ -547,7 +548,8 @@ static int ov9740_reg_rmw(struct i2c_client *client, u16 reg, u8 set, u8 unset)
 	ret = ov9740_reg_write(client, reg, val);
 	if (ret < 0) {
 		dev_err(&client->dev,
-			"Read-Modify-[Write] of register %02x failed!\n", reg);
+			"Read-Modify-[Write] of register 0x%04x failed!\n",
+			reg);
 		return ret;
 	}
 
-- 
1.7.5.1

