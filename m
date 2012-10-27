Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab2J0UrJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:47:09 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKl8rd020569
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:47:08 -0400
Received: from pedra (vpn1-4-98.gru2.redhat.com [10.97.4.98])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKl5Ug014413
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:47:08 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 54/68] [media] fmdrv: better define fmdbg() macro to avoid warnings
Date: Sat, 27 Oct 2012 18:41:12 -0200
Message-Id: <1351370486-29040-55-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/radio/wl128x/fmdrv_common.c:1619:47: warning: suggest braces around empty body in an 'else' statement [-Wempty-body]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/radio/wl128x/fmdrv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/wl128x/fmdrv.h b/drivers/media/radio/wl128x/fmdrv.h
index d84ad9d..aac0f02 100644
--- a/drivers/media/radio/wl128x/fmdrv.h
+++ b/drivers/media/radio/wl128x/fmdrv.h
@@ -60,7 +60,7 @@
 #define fmdbg(format, ...) \
 	printk(KERN_DEBUG "fmdrv: " format, ## __VA_ARGS__)
 #else /* DEBUG */
-#define fmdbg(format, ...)
+#define fmdbg(format, ...) do {} while(0)
 #endif
 enum {
 	FM_MODE_OFF,
-- 
1.7.11.7

