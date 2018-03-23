Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:53652 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753880AbeCWL5Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 11/30] media: bttv-input: better handle errors at I2C transfer
Date: Fri, 23 Mar 2018 07:56:57 -0400
Message-Id: <d3c449e16fc829dba347dc72106f8d28b15896f9.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The error handling logic at get_key_pv951() is a little bit
akward, with produces this false positive warning:

	drivers/media/pci/bt8xx/bttv-input.c:344 get_key_pv951() error: uninitialized symbol 'b'.

Do a cleanup. As a side effect, it also improves its coding
style.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/bt8xx/bttv-input.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index da49c5567db5..08266b23826e 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -332,11 +332,15 @@ static void bttv_ir_stop(struct bttv *btv)
 static int get_key_pv951(struct IR_i2c *ir, enum rc_proto *protocol,
 			 u32 *scancode, u8 *toggle)
 {
+	int rc;
 	unsigned char b;
 
 	/* poll IR chip */
-	if (1 != i2c_master_recv(ir->c, &b, 1)) {
+	rc = i2c_master_recv(ir->c, &b, 1);
+	if (rc != 1) {
 		dprintk("read error\n");
+		if (rc < 0)
+			return rc;
 		return -EIO;
 	}
 
-- 
2.14.3
