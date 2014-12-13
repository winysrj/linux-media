Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:50469 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030568AbaLMLyH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 06:54:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 07/10] m5mols: fix sparse warnings
Date: Sat, 13 Dec 2014 12:52:57 +0100
Message-Id: <1418471580-26510-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
References: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/i2c/m5mols/m5mols_core.c:128:24: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:128:24: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:128:24: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:128:24: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:130:24: warning: cast to restricted __be32
drivers/media/i2c/m5mols/m5mols_core.c:130:24: warning: cast to restricted __be32
drivers/media/i2c/m5mols/m5mols_core.c:130:24: warning: cast to restricted __be32
drivers/media/i2c/m5mols/m5mols_core.c:130:24: warning: cast to restricted __be32
drivers/media/i2c/m5mols/m5mols_core.c:130:24: warning: cast to restricted __be32
drivers/media/i2c/m5mols/m5mols_core.c:130:24: warning: cast to restricted __be32
drivers/media/i2c/m5mols/m5mols_core.c:457:19: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:457:19: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:457:19: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:457:19: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:458:19: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:458:19: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:458:19: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:458:19: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:459:22: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:459:22: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:459:22: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:459:22: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:460:20: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:460:20: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:460:20: warning: cast to restricted __be16
drivers/media/i2c/m5mols/m5mols_core.c:460:20: warning: cast to restricted __be16

The be16_to_cpu conversions in m5mols_get_version() are not needed since the
data is already using cpu endianness. This was never noticed since these
version fields are never used.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/m5mols/m5mols_core.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 2820f7c..6ed16e5 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -125,9 +125,9 @@ static u32 m5mols_swap_byte(u8 *data, u8 length)
 	if (length == 1)
 		return *data;
 	else if (length == 2)
-		return be16_to_cpu(*((u16 *)data));
+		return be16_to_cpu(*((__be16 *)data));
 	else
-		return be32_to_cpu(*((u32 *)data));
+		return be32_to_cpu(*((__be32 *)data));
 }
 
 /**
@@ -454,11 +454,6 @@ static int m5mols_get_version(struct v4l2_subdev *sd)
 			return ret;
 	}
 
-	ver->fw = be16_to_cpu(ver->fw);
-	ver->hw = be16_to_cpu(ver->hw);
-	ver->param = be16_to_cpu(ver->param);
-	ver->awb = be16_to_cpu(ver->awb);
-
 	v4l2_info(sd, "Manufacturer\t[%s]\n",
 			is_manufacturer(info, REG_SAMSUNG_ELECTRO) ?
 			"Samsung Electro-Machanics" :
-- 
2.1.3

