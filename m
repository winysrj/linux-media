Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42390 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444AbZKGVvf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:51:35 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:51:38 +0000
Message-ID: <1257630698.15927.426.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 32/75] cx88-blackbird: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/cx88/cx88-blackbird.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index fbdc1cd..da62b37 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -42,6 +42,7 @@
 MODULE_DESCRIPTION("driver for cx2388x/cx23416 based mpeg encoder cards");
 MODULE_AUTHOR("Jelle Foks <jelle@foks.us>, Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(CX2341X_FIRM_ENC_FILENAME);
 
 static unsigned int mpegbufs = 32;
 module_param(mpegbufs,int,0644);
-- 
1.6.5.2



