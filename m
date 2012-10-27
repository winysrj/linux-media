Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab2J0Ulw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:41:52 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKfqA9019752
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:41:52 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 11/68] [media] cx23885-alsa: fix a false gcc warning at dprintk()
Date: Sat, 27 Oct 2012 18:40:29 -0200
Message-Id: <1351370486-29040-12-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change dprintk logic to avoid the following warning:
drivers/media/pci/cx23885/cx23885-alsa.c: In function 'cx23885_audio_register':
drivers/media/pci/cx23885/cx23885-alsa.c:515:2: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/cx23885/cx23885-alsa.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-alsa.c b/drivers/media/pci/cx23885/cx23885-alsa.c
index 7951692..c6c9bd5 100644
--- a/drivers/media/pci/cx23885/cx23885-alsa.c
+++ b/drivers/media/pci/cx23885/cx23885-alsa.c
@@ -45,8 +45,10 @@
 
 #define AUDIO_SRAM_CHANNEL	SRAM_CH07
 
-#define dprintk(level, fmt, arg...)	if (audio_debug >= level) \
-	printk(KERN_INFO "%s: " fmt, chip->dev->name , ## arg)
+#define dprintk(level, fmt, arg...) do {				\
+	if (audio_debug + 1 > level)					\
+		printk(KERN_INFO "%s: " fmt, chip->dev->name , ## arg);	\
+} while(0)
 
 #define dprintk_core(level, fmt, arg...)	if (audio_debug >= level) \
 	printk(KERN_DEBUG "%s: " fmt, chip->dev->name , ## arg)
-- 
1.7.11.7

