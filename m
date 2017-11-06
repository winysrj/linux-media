Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47082 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754700AbdKFSVO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Nov 2017 13:21:14 -0500
To: linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Scheller <d.scheller.oss@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] media: ddbridge: fix build warnings
Message-ID: <6e0fb4da-131f-893e-2e54-7936a265da7c@infradead.org>
Date: Mon, 6 Nov 2017 10:21:06 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix 2 build warnings.
These functions are void, so drop the "return"s.

./drivers/media/pci/ddbridge/ddbridge-io.h: warning: 'return' with a value, in function returning void [enabled by default]:  => 50:2, 55:2

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Daniel Scheller <d.scheller.oss@gmail.com>
Cc:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc:	Mauro Carvalho Chehab <mchehab@kernel.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/pci/ddbridge/ddbridge-io.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-414-rc8.orig/drivers/media/pci/ddbridge/ddbridge-io.h
+++ lnx-414-rc8/drivers/media/pci/ddbridge/ddbridge-io.h
@@ -47,12 +47,12 @@ static inline void ddbwritel(struct ddb
 
 static inline void ddbcpyto(struct ddb *dev, u32 adr, void *src, long count)
 {
-	return memcpy_toio(dev->regs + adr, src, count);
+	memcpy_toio(dev->regs + adr, src, count);
 }
 
 static inline void ddbcpyfrom(struct ddb *dev, void *dst, u32 adr, long count)
 {
-	return memcpy_fromio(dst, dev->regs + adr, count);
+	memcpy_fromio(dst, dev->regs + adr, count);
 }
 
 static inline u32 safe_ddbreadl(struct ddb *dev, u32 adr)
