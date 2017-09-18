Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59980 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750813AbdIRWtD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 18:49:03 -0400
From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, jian.xu.zheng@intel.com,
        tian.shu.qiu@intel.com, andy.yeh@intel.com,
        rajmohan.mani@intel.com, hyungwoo.yang@intel.com,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Subject: [PATCH v2] media: ov13858: Fix 4224x3136 video flickering at some vblanks
Date: Mon, 18 Sep 2017 15:47:43 -0700
Message-Id: <d946c138dc7d9657e986bfe37d255a595ad1671c.1505774663.git.chiranjeevi.rapolu@intel.com>
In-Reply-To: <1505342325-9180-1-git-send-email-chiranjeevi.rapolu@intel.com>
References: <1505342325-9180-1-git-send-email-chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, with crop (0, 0), (4255, 3167), VTS < 0xC9E was resulting in blank
frames sometimes. This appeared as video flickering. But we need VTS < 0xC9E to
get ~30fps.

Omni Vision recommends to use crop (0,8), (4255, 3159) for 4224x3136. With this
crop, VTS 0xC8E is supported and yields ~30fps.

Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
---
Changes in v2:
	- Include Tomasz clarifications in the commit message.
 drivers/media/i2c/ov13858.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index af7af0d..f7c5771 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -238,11 +238,11 @@ struct ov13858_mode {
 	{0x3800, 0x00},
 	{0x3801, 0x00},
 	{0x3802, 0x00},
-	{0x3803, 0x00},
+	{0x3803, 0x08},
 	{0x3804, 0x10},
 	{0x3805, 0x9f},
 	{0x3806, 0x0c},
-	{0x3807, 0x5f},
+	{0x3807, 0x57},
 	{0x3808, 0x10},
 	{0x3809, 0x80},
 	{0x380a, 0x0c},
-- 
1.9.1
