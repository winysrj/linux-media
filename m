Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37551 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbcBVTJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 14:09:32 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Cheolhyun Park <pch851130@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/9] [media] drxj: set_param_parameters array is too short
Date: Mon, 22 Feb 2016 16:09:20 -0300
Message-Id: <f3b5fcac3472cd6ee0b5ea18a2f21a7dab6179a4.1456167652.git.mchehab@osg.samsung.com>
In-Reply-To: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
In-Reply-To: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes this smatch warning:
	drivers/media/dvb-frontends/drx39xyj/drxj.c:4151 drxj_dap_scu_atomic_read_write_block() error: buffer overflow 'set_param_parameters' 15 <= 17

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index b28b5787b39a..51715421bc4f 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -4131,7 +4131,7 @@ int drxj_dap_scu_atomic_read_write_block(struct i2c_device_addr *dev_addr, u32 a
 {
 	struct drxjscu_cmd scu_cmd;
 	int rc;
-	u16 set_param_parameters[15];
+	u16 set_param_parameters[18];
 	u16 cmd_result[15];
 
 	/* Parameter check */
-- 
2.5.0

