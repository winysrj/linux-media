Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933334Ab2J0Umq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:46 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgjtE006407
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:45 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 43/68] [media] cx88: reorder inline to prevent a gcc warning
Date: Sat, 27 Oct 2012 18:41:01 -0200
Message-Id: <1351370486-29040-44-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/cx88/cx88.h:97:1: warning: 'inline' is not at beginning of declaration [-Wold-style-declaration]
drivers/media/pci/cx88/cx88.h:103:1: warning: 'inline' is not at beginning of declaration [-Wold-style-declaration]
drivers/media/pci/cx88/cx88-core.c:649:1: warning: 'inline' is not at beginning of declaration [-Wold-style-declaration]
drivers/media/pci/cx88/cx88-core.c:654:1: warning: 'inline' is not at beginning of declaration [-Wold-style-declaration]
drivers/media/pci/cx88/cx88-core.c:659:1: warning: 'inline' is not at beginning of declaration [-Wold-style-declaration]
drivers/media/pci/cx88/cx88-core.c:664:1: warning: 'inline' is not at beginning of declaration [-Wold-style-declaration]
drivers/media/pci/cx88/cx88-core.c:684:1: warning: 'inline' is not at beginning of declaration [-Wold-style-declaration]
drivers/media/pci/cx88/cx88-core.c:695:1: warning: 'inline' is not at beginning of declaration [-Wold-style-declaration]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/cx88/cx88-core.c | 12 ++++++------
 drivers/media/pci/cx88/cx88.h      |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index c97b174..19a5875 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -646,22 +646,22 @@ int cx88_reset(struct cx88_core *core)
 
 /* ------------------------------------------------------------------ */
 
-static unsigned int inline norm_swidth(v4l2_std_id norm)
+static inline unsigned int norm_swidth(v4l2_std_id norm)
 {
 	return (norm & (V4L2_STD_MN & ~V4L2_STD_PAL_Nc)) ? 754 : 922;
 }
 
-static unsigned int inline norm_hdelay(v4l2_std_id norm)
+static inline unsigned int norm_hdelay(v4l2_std_id norm)
 {
 	return (norm & (V4L2_STD_MN & ~V4L2_STD_PAL_Nc)) ? 135 : 186;
 }
 
-static unsigned int inline norm_vdelay(v4l2_std_id norm)
+static inline unsigned int norm_vdelay(v4l2_std_id norm)
 {
 	return (norm & V4L2_STD_625_50) ? 0x24 : 0x18;
 }
 
-static unsigned int inline norm_fsc8(v4l2_std_id norm)
+static inline unsigned int norm_fsc8(v4l2_std_id norm)
 {
 	if (norm & V4L2_STD_PAL_M)
 		return 28604892;      // 3.575611 MHz
@@ -681,7 +681,7 @@ static unsigned int inline norm_fsc8(v4l2_std_id norm)
 	return 35468950;      // 4.43361875 MHz +/- 5 Hz
 }
 
-static unsigned int inline norm_htotal(v4l2_std_id norm)
+static inline unsigned int norm_htotal(v4l2_std_id norm)
 {
 
 	unsigned int fsc4=norm_fsc8(norm)/2;
@@ -692,7 +692,7 @@ static unsigned int inline norm_htotal(v4l2_std_id norm)
 				((fsc4+262)/525*1001+15000)/30000;
 }
 
-static unsigned int inline norm_vbipack(v4l2_std_id norm)
+static inline unsigned int norm_vbipack(v4l2_std_id norm)
 {
 	return (norm & V4L2_STD_625_50) ? 511 : 400;
 }
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 44ffc8b..ba0dba4 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -94,13 +94,13 @@ enum cx8802_board_access {
 /* ----------------------------------------------------------- */
 /* tv norms                                                    */
 
-static unsigned int inline norm_maxw(v4l2_std_id norm)
+static inline unsigned int norm_maxw(v4l2_std_id norm)
 {
 	return (norm & (V4L2_STD_MN & ~V4L2_STD_PAL_Nc)) ? 720 : 768;
 }
 
 
-static unsigned int inline norm_maxh(v4l2_std_id norm)
+static inline unsigned int norm_maxh(v4l2_std_id norm)
 {
 	return (norm & V4L2_STD_625_50) ? 576 : 480;
 }
-- 
1.7.11.7

