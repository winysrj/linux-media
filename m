Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44888 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754044AbeCWL5b (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 21/30] media: ir-kbd-i2c: change the if logic to avoid a warning
Date: Fri, 23 Mar 2018 07:57:07 -0400
Message-Id: <9863bc49abade85cad2ef6c1f535f61c2c24f163.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While the code is correct, it produces this warning:
	drivers/media/i2c/ir-kbd-i2c.c:593 zilog_ir_format() error: buffer overflow 'code_block->codes' 61 <= 173

As static analyzers may be tricked by arithmetic expressions on
comparisions. So, change the order, in order to shut up this
false-positive warning.

That also makes easier for humans to understand that it won't
be trying to go past buffer size.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/ir-kbd-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 1d11aab1817a..a7e23bcf845c 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -583,7 +583,7 @@ static int zilog_ir_format(struct rc_dev *rcdev, unsigned int *txbuf,
 		/* first copy any leading non-repeating */
 		int leading = c - rep * 3;
 
-		if (leading + rep >= ARRAY_SIZE(code_block->codes) - 3) {
+		if (leading >= ARRAY_SIZE(code_block->codes) - 3 - rep) {
 			dev_warn(&rcdev->dev, "IR too long, cannot transmit\n");
 			return -EINVAL;
 		}
-- 
2.14.3
