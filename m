Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:39719 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756363Ab2DSTy6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 15:54:58 -0400
Message-Id: <E1SKxRQ-0001Fb-V2@www.linuxtv.org>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Thu, 19 Apr 2012 21:54:29 +0200
Subject: [git:v4l-dvb/for_v3.5] [media] drivers: media: dvb: ddbridge: ddbridge-code: Remove unneeded include of version.h
To: linuxtv-commits@linuxtv.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Reply-to: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an automatic generated email to let you know that the following patch were queued at the 
http://git.linuxtv.org/media_tree.git tree:

Subject: [media] drivers: media: dvb: ddbridge: ddbridge-code: Remove unneeded include of version.h
Author:  Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Date:    Wed Apr 18 00:30:03 2012 -0300

The output of "make versioncheck" told us that the file
drivers/media/dvb/ddbridge/ddbridge-code.c has a incorrect include of
version.h:

linux/drivers/media/dvb/ddbridge/ddbridge-core.c: 34 linux/version.h not
needed.

After take a look in the code, we can agree to remove it.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/media/dvb/ddbridge/ddbridge-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=c1341a16f6c1d25d3d8bd1ad64556b8029cbb4b8

diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
index d88c4aa..115777e 100644
--- a/drivers/media/dvb/ddbridge/ddbridge-core.c
+++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
@@ -31,7 +31,6 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/timer.h>
-#include <linux/version.h>
 #include <linux/i2c.h>
 #include <linux/swab.h>
 #include <linux/vmalloc.h>
