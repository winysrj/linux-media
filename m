Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42384 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847AbZKGVvY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:51:24 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:51:27 +0000
Message-ID: <1257630687.15927.424.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 30/75] cx23885: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/cx23885/cx23885-417.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
index 0eed852..ff36155 100644
--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -41,6 +41,7 @@
 
 #define CX23885_FIRM_IMAGE_SIZE 376836
 #define CX23885_FIRM_IMAGE_NAME "v4l-cx23885-enc.fw"
+MODULE_FIRMWARE(CX23885_FIRM_IMAGE_NAME);
 
 static unsigned int mpegbufs = 32;
 module_param(mpegbufs, int, 0644);
-- 
1.6.5.2



