Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52103 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752604AbdGCJNX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 05:13:23 -0400
From: Colin King <colin.king@canonical.com>
To: Kyungmin Park <kyungmin.park@samsung.com>,
        Heungjun Kim <riverful.kim@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] media: i2c: m5mols: fix spelling mistake: "Machanics" -> "Mechanics"
Date: Mon,  3 Jul 2017 10:13:08 +0100
Message-Id: <20170703091308.10280-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in v4l2_info message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/i2c/m5mols/m5mols_core.c | 2 +-
 drivers/scsi/qedi/qedi_fw.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 9ccb5ee55fa9..463534d44756 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -457,7 +457,7 @@ static int m5mols_get_version(struct v4l2_subdev *sd)
 
 	v4l2_info(sd, "Manufacturer\t[%s]\n",
 			is_manufacturer(info, REG_SAMSUNG_ELECTRO) ?
-			"Samsung Electro-Machanics" :
+			"Samsung Electro-Mechanics" :
 			is_manufacturer(info, REG_SAMSUNG_OPTICS) ?
 			"Samsung Fiber-Optics" :
 			is_manufacturer(info, REG_SAMSUNG_TECHWIN) ?
-- 
2.11.0
