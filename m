Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35678 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751550AbdHJNGr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 09:06:47 -0400
Date: Thu, 10 Aug 2017 18:36:41 +0530
From: Harold Gomez <haroldgmz11@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media:atomisp:ap1302 Fix style warning
Message-ID: <20170810130641.GA3051@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a blank line after declarations
to avoid checkpatch.pl script warning

Signed-off-by: Harold Gomez <haroldgmz11@gmail.com>
---
 drivers/staging/media/atomisp/i2c/ap1302.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/i2c/ap1302.c b/drivers/staging/media/atomisp/i2c/ap1302.c
index 7a0c0d5..fba4f96 100644
--- a/drivers/staging/media/atomisp/i2c/ap1302.c
+++ b/drivers/staging/media/atomisp/i2c/ap1302.c
@@ -263,6 +263,7 @@ static int ap1302_read_context_reg(struct v4l2_subdev *sd,
 {
 	struct ap1302_device *dev = to_ap1302_device(sd);
 	u16 reg_addr = ap1302_calculate_context_reg_addr(context, offset);
+
 	if (reg_addr == 0)
 		return -EINVAL;
 	return ap1302_i2c_read_reg(sd, reg_addr, len,
-- 
2.1.4
