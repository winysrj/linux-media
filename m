Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44888 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754038AbeCWL5d (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Dean A <dean@sensoray.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Bhumika Goyal <bhumirks@gmail.com>,
        =?UTF-8?q?Christopher=20D=C3=ADaz=20Riveros?= <chrisadr@gentoo.org>
Subject: [PATCH 18/30] media: s2255drv: fix a casting warning
Date: Fri, 23 Mar 2018 07:57:04 -0400
Message-Id: <86f181c766218390ed8fff247a6dd4c9c2c1c5ae.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/s2255/s2255drv.c:651 s2255_fillbuff() warn: argument 3 to %08lx specifier is cast from pointer

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/s2255/s2255drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index a00a15f55d37..82927eb334c4 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -648,8 +648,8 @@ static void s2255_fillbuff(struct s2255_vc *vc,
 		pr_err("s2255: =======no frame\n");
 		return;
 	}
-	dprintk(dev, 2, "s2255fill at : Buffer 0x%08lx size= %d\n",
-		(unsigned long)vbuf, pos);
+	dprintk(dev, 2, "s2255fill at : Buffer %p size= %d\n",
+		vbuf, pos);
 }
 
 
-- 
2.14.3
