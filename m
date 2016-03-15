Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46485 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033AbcCOHH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 03:07:26 -0400
Date: Tue, 15 Mar 2016 10:07:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Heungjun Kim <riverful.kim@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] m5mols: potential uninitialized variable
Message-ID: <20160315070710.GD13560@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch complains that there are some paths where "status" isn't
initialized.  The code does assume that m5mols_read_u8() can fail so it
seems as if Smatch is correct.

Let's initialize it to REG_ISO_AUTO which is zero.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/i2c/m5mols/m5mols_controls.c b/drivers/media/i2c/m5mols/m5mols_controls.c
index a60931e..c2218c0 100644
--- a/drivers/media/i2c/m5mols/m5mols_controls.c
+++ b/drivers/media/i2c/m5mols/m5mols_controls.c
@@ -405,7 +405,7 @@ static int m5mols_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct m5mols_info *info = to_m5mols(sd);
 	int ret = 0;
-	u8 status;
+	u8 status = REG_ISO_AUTO;
 
 	v4l2_dbg(1, m5mols_debug, sd, "%s: ctrl: %s (%d)\n",
 		 __func__, ctrl->name, info->isp_ready);
