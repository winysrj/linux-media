Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A40C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 09:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 848152085A
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 09:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbfAOJcJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 04:32:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:59631 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbfAOJcI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 04:32:08 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jan 2019 01:32:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,481,1539673200"; 
   d="scan'208";a="126156959"
Received: from benkao-pc.itwn.intel.com ([10.5.253.162])
  by orsmga002.jf.intel.com with ESMTP; 15 Jan 2019 01:32:07 -0800
From:   Ben Kao <ben.kao@intel.com>
To:     linux-media@vger.kernel.org
Cc:     sakari.ailus@linux.intel.com, andy.yeh@intel.com,
        tfiga@chromium.org, Ben Kao <ben.kao@intel.com>
Subject: [PATCH] media: ov8856: Modify ov8856 register reading function to be simplified
Date:   Tue, 15 Jan 2019 17:36:07 +0800
Message-Id: <1547544967-19454-1-git-send-email-ben.kao@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

We use put_unaligned_be16() to be simplified for setting register address
in ov8856_read_reg() and use sizeof() to be better suited for bytes
copying.

Signed-off-by: Ben Kao <ben.kao@intel.com>
---
 drivers/media/i2c/ov8856.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ov8856.c b/drivers/media/i2c/ov8856.c
index c0d4408..dbf1095 100644
--- a/drivers/media/i2c/ov8856.c
+++ b/drivers/media/i2c/ov8856.c
@@ -605,16 +605,17 @@ static int ov8856_read_reg(struct ov8856 *ov8856, u16 reg, u16 len, u32 *val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&ov8856->sd);
 	struct i2c_msg msgs[2];
-	u8 addr_buf[2] = {reg >> 8, reg & 0xff};
-	u8 data_buf[4] = {0, };
+	u8 addr_buf[2];
+	u8 data_buf[4] = {0};
 	int ret;
 
 	if (len > 4)
 		return -EINVAL;
 
+	put_unaligned_be16(reg, addr_buf);
 	msgs[0].addr = client->addr;
 	msgs[0].flags = 0;
-	msgs[0].len = ARRAY_SIZE(addr_buf);
+	msgs[0].len = sizeof(addr_buf);
 	msgs[0].buf = addr_buf;
 	msgs[1].addr = client->addr;
 	msgs[1].flags = I2C_M_RD;
-- 
2.7.4

