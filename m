Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab2J0UmK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:10 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKg9x6006314
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:10 -0400
Received: from pedra (vpn1-4-98.gru2.redhat.com [10.97.4.98])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKg4xm014043
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:09 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 62/68] [media] bttv-driver: fix two warnings
Date: Sat, 27 Oct 2012 18:41:20 -0200
Message-Id: <1351370486-29040-63-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/bt8xx/bttv-driver.c:308:3: warning: initialized field overwritten [-Woverride-init]
drivers/media/pci/bt8xx/bttv-driver.c:308:3: warning: (near initialization for 'bttv_tvnorms[0].cropcap.bounds.height') [-Woverride-init]
drivers/media/pci/bt8xx/bttv-driver.c: In function 'bttv_remove':
drivers/media/pci/bt8xx/bttv-driver.c:4467:29: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 56c6c77..de6f41f 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -200,7 +200,7 @@ static void flush_request_modules(struct bttv *dev)
 }
 #else
 #define request_modules(dev)
-#define flush_request_modules(dev)
+#define flush_request_modules(dev) do {} while(0)
 #endif /* CONFIG_MODULES */
 
 
@@ -301,11 +301,10 @@ const struct bttv_tvnorm bttv_tvnorms[] = {
 			/* totalwidth */ 1135,
 			/* sqwidth */ 944,
 			/* vdelay */ 0x20,
-			/* sheight */ 576,
-			/* videostart0 */ 23)
 		/* bt878 (and bt848?) can capture another
 		   line below active video. */
-		.cropcap.bounds.height = (576 + 2) + 0x20 - 2,
+			/* sheight */ (576 + 2) + 0x20 - 2,
+			/* videostart0 */ 23)
 	},{
 		.v4l2_id        = V4L2_STD_NTSC_M | V4L2_STD_NTSC_M_KR,
 		.name           = "NTSC",
-- 
1.7.11.7

