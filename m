Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47594 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259AbZKGVsm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:48:42 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:48:45 +0000
Message-ID: <1257630525.15927.401.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 11/75] xc5000: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/common/tuners/xc5000.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index 432003d..e13165a 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -1130,3 +1130,4 @@ EXPORT_SYMBOL(xc5000_attach);
 MODULE_AUTHOR("Steven Toth");
 MODULE_DESCRIPTION("Xceive xc5000 silicon tuner driver");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dvb-fe-xc5000-1.6.114.fw");
-- 
1.6.5.2



