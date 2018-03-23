Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40864 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754038AbeCWL5a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        mjpeg-users@lists.sourceforge.net
Subject: [PATCH 22/30] media: zoran: don't cast pointers to print them
Date: Fri, 23 Mar 2018 07:57:08 -0400
Message-Id: <70ae6a049fa9886f3d81bb35b7a806eef72351a2.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/zoran/zoran_driver.c:242 v4l_fbuffer_alloc() warn: argument 5 to %lx specifier is cast from pointer

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/zoran/zoran_driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index 8d4e7d930a66..14f9c0e26a1c 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -241,8 +241,8 @@ static int v4l_fbuffer_alloc(struct zoran_fh *fh)
 			SetPageReserved(virt_to_page(mem + off));
 		dprintk(4,
 			KERN_INFO
-			"%s: %s - V4L frame %d mem 0x%lx (bus: 0x%llx)\n",
-			ZR_DEVNAME(zr), __func__, i, (unsigned long) mem,
+			"%s: %s - V4L frame %d mem %p (bus: 0x%llx)\n",
+			ZR_DEVNAME(zr), __func__, i, mem,
 			(unsigned long long)virt_to_bus(mem));
 	}
 
-- 
2.14.3
