Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:36900 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1E0M6P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 08:58:15 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LLU0096EUOYJTU0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 May 2011 21:58:10 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LLU00DYAUOY16@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 May 2011 21:58:10 +0900 (KST)
Date: Fri, 27 May 2011 21:58:13 +0900
From: "HeungJun, Kim" <riverful.kim@samsung.com>
Subject: [PATCH 3/5] m5mols: remove union in the m5mols_get_version(),
 and VERSION_SIZE
In-reply-to: <20110525135435.GA3547@valkosipuli.localdomain>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com, sakari.ailus@iki.fi,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1306501095-28267-4-git-send-email-riverful.kim@samsung.com>
Content-transfer-encoding: 7BIT
References: <20110525135435.GA3547@valkosipuli.localdomain>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Remove union version in the m5mols_get_version(), and read version information
directly. Also remove VERSION_SIZE.

Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h      |    1 -
 drivers/media/video/m5mols/m5mols_core.c |   42 +++++++++++++++---------------
 drivers/media/video/m5mols/m5mols_reg.h  |   13 ++++++++-
 3 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index dbe8928..9ae1709 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -154,7 +154,6 @@ struct m5mols_version {
 	u8	str[VERSION_STRING_SIZE];
 	u8	af;
 };
-#define VERSION_SIZE sizeof(struct m5mols_version)
 
 /**
  * struct m5mols_info - M-5MOLS driver data structure
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 2b1f23f..8ccab95 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -386,33 +386,33 @@ int m5mols_mode(struct m5mols_info *info, u8 mode)
 static int m5mols_get_version(struct v4l2_subdev *sd)
 {
 	struct m5mols_info *info = to_m5mols(sd);
-	union {
-		struct m5mols_version ver;
-		u8 bytes[VERSION_SIZE];
-	} version;
-	u8 cmd = CAT0_VER_CUSTOMER;
+	struct m5mols_version *ver = &info->ver;
+	u8 *str = ver->str;
+	int i;
 	int ret;
 
-	do {
-		ret = m5mols_read_u8(sd, SYSTEM_CMD(cmd), &version.bytes[cmd]);
-		if (ret)
-			return ret;
-	} while (cmd++ != CAT0_VER_AWB);
+	ret = m5mols_read_u8(sd, SYSTEM_VER_CUSTOMER, &ver->customer);
+	if (!ret)
+		ret = m5mols_read_u8(sd, SYSTEM_VER_PROJECT, &ver->project);
+	if (!ret)
+		ret = m5mols_read_u16(sd, SYSTEM_VER_FIRMWARE, &ver->fw);
+	if (!ret)
+		ret = m5mols_read_u16(sd, SYSTEM_VER_HARDWARE, &ver->hw);
+	if (!ret)
+		ret = m5mols_read_u16(sd, SYSTEM_VER_PARAMETER, &ver->param);
+	if (!ret)
+		ret = m5mols_read_u16(sd, SYSTEM_VER_AWB, &ver->awb);
+	if (!ret)
+		ret = m5mols_read_u8(sd, AF_VERSION, &ver->af);
+	if (ret)
+		return ret;
 
-	do {
-		ret = m5mols_read_u8(sd, SYSTEM_VER_STRING, &version.bytes[cmd]);
+	for (i = 0; i < VERSION_STRING_SIZE; i++) {
+		ret = m5mols_read_u8(sd, SYSTEM_VER_STRING, &str[i]);
 		if (ret)
 			return ret;
-		if (cmd >= VERSION_SIZE - 1)
-			return -EINVAL;
-	} while (version.bytes[cmd++]);
-
-	ret = m5mols_read_u8(sd, AF_VERSION, &version.bytes[cmd]);
-	if (ret)
-		return ret;
+	}
 
-	/* store version information swapped for being readable */
-	info->ver	= version.ver;
 	info->ver.fw	= be16_to_cpu(info->ver.fw);
 	info->ver.hw	= be16_to_cpu(info->ver.hw);
 	info->ver.param	= be16_to_cpu(info->ver.param);
diff --git a/drivers/media/video/m5mols/m5mols_reg.h b/drivers/media/video/m5mols/m5mols_reg.h
index 8260f50..5f5bdcf 100644
--- a/drivers/media/video/m5mols/m5mols_reg.h
+++ b/drivers/media/video/m5mols/m5mols_reg.h
@@ -56,13 +56,24 @@
  * more specific contents, see definition if file m5mols.h.
  */
 #define CAT0_VER_CUSTOMER	0x00	/* customer version */
-#define CAT0_VER_AWB		0x09	/* Auto WB version */
+#define CAT0_VER_PROJECT	0x01	/* project version */
+#define CAT0_VER_FIRMWARE	0x02	/* Firmware version */
+#define CAT0_VER_HARDWARE	0x04	/* Hardware version */
+#define CAT0_VER_PARAMETER	0x06	/* Parameter version */
+#define CAT0_VER_AWB		0x08	/* Auto WB version */
 #define CAT0_VER_STRING		0x0a	/* string including M-5MOLS */
 #define CAT0_SYSMODE		0x0b	/* SYSTEM mode register */
 #define CAT0_STATUS		0x0c	/* SYSTEM mode status register */
 #define CAT0_INT_FACTOR		0x10	/* interrupt pending register */
 #define CAT0_INT_ENABLE		0x11	/* interrupt enable register */
 
+#define SYSTEM_VER_CUSTOMER	I2C_REG(CAT_SYSTEM, CAT0_VER_CUSTOMER, 1)
+#define SYSTEM_VER_PROJECT	I2C_REG(CAT_SYSTEM, CAT0_VER_PROJECT, 1)
+#define SYSTEM_VER_FIRMWARE	I2C_REG(CAT_SYSTEM, CAT0_VER_FIRMWARE, 2)
+#define SYSTEM_VER_HARDWARE	I2C_REG(CAT_SYSTEM, CAT0_VER_HARDWARE, 2)
+#define SYSTEM_VER_PARAMETER	I2C_REG(CAT_SYSTEM, CAT0_VER_PARAMETER, 2)
+#define SYSTEM_VER_AWB		I2C_REG(CAT_SYSTEM, CAT0_VER_AWB, 2)
+
 #define SYSTEM_SYSMODE		I2C_REG(CAT_SYSTEM, CAT0_SYSMODE, 1)
 #define REG_SYSINIT		0x00	/* SYSTEM mode */
 #define REG_PARAMETER		0x01	/* PARAMETER mode */
-- 
1.7.0.4

