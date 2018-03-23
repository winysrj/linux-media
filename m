Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39372 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754017AbeCWL52 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 01/30] media: dvbdev: handle ENOMEM error at dvb_module_probe()
Date: Fri, 23 Mar 2018 07:56:47 -0400
Message-Id: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If allocation of struct board_info fails, return NULL from
dvb_module_probe().

Fix this warning:
	drivers/media/dvb-core/dvbdev.c:958 dvb_module_probe() error: potential null dereference 'board_info'.  (kzalloc returns null)

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvbdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index cf747d753a79..787fe06df217 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -953,6 +953,8 @@ struct i2c_client *dvb_module_probe(const char *module_name,
 	struct i2c_board_info *board_info;
 
 	board_info = kzalloc(sizeof(*board_info), GFP_KERNEL);
+	if (!board_info)
+		return NULL;
 
 	if (name)
 		strlcpy(board_info->type, name, I2C_NAME_SIZE);
-- 
2.14.3
