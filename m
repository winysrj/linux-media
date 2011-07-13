Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:44066 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab1GVQyT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 12:54:19 -0400
Message-Id: <E1QkIhg-0007WQ-5h@www.linuxtv.org>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Thu, 14 Jul 2011 00:40:08 +0200
Subject: [git:v4l-dvb/for_v3.1] [media] media: fix radio-sf16fmr2 build when SND is not enabled
To: linuxtv-commits@linuxtv.org
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Randy Dunlap <randy.dunlap@oracle.com>
Reply-to: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an automatic generated email to let you know that the following patch were queued at the 
http://git.linuxtv.org/media_tree.git tree:

Subject: [media] media: fix radio-sf16fmr2 build when SND is not enabled
Author:  Randy Dunlap <randy.dunlap@oracle.com>
Date:    Thu Jun 30 14:31:04 2011 -0300

When CONFIG_SND is not enabled, radio-sf16fmr2 build fails with:

so make this driver depend on SND.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/media/radio/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=42a741dcf1472cea55193ea8611db3d67808ce22

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 0aeed28..52798a1 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -201,7 +201,7 @@ config RADIO_SF16FMI
 
 config RADIO_SF16FMR2
 	tristate "SF16FMR2 Radio"
-	depends on ISA && VIDEO_V4L2
+	depends on ISA && VIDEO_V4L2 && SND
 	---help---
 	  Choose Y here if you have one of these FM radio cards.
 
