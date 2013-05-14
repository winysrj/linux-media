Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:58743 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757884Ab3ENUzT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 16:55:19 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] bttv: stop abusing mbox_we for sw_status
Date: Tue, 14 May 2013 22:54:44 +0200
Message-Id: <1368564885-20940-3-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1368564885-20940-1-git-send-email-linux@rainbow-software.org>
References: <1368564885-20940-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kodicom 4400R and Geovision GV-800 code in bttv driver abuses mbox_we (int)
in struct bttv as char *.
Remove this hack and add a proper sw_status array to struct bttv instead.
This is a a preparation to remove mbox_we.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/pci/bt8xx/bttv-cards.c |   26 +++++++++-----------------
 drivers/media/pci/bt8xx/bttvp.h      |    3 +++
 2 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index b7dc921..24c7511 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -4401,9 +4401,7 @@ static void tibetCS16_init(struct bttv *btv)
  * is {3, 0, 2, 1}, i.e. the first controller to be detected is logical
  * unit 3, the second (which is the master) is logical unit 0, etc.
  * We need to maintain the status of the analog switch (which of the 16
- * cameras is connected to which of the 4 controllers).  Rather than
- * add to the bttv structure for this, we use the data reserved for
- * the mbox (unused for this card type).
+ * cameras is connected to which of the 4 controllers) in sw_status array.
  */
 
 /*
@@ -4438,7 +4436,6 @@ static void kodicom4400r_write(struct bttv *btv,
  */
 static void kodicom4400r_muxsel(struct bttv *btv, unsigned int input)
 {
-	char *sw_status;
 	int xaddr, yaddr;
 	struct bttv *mctlr;
 	static unsigned char map[4] = {3, 0, 2, 1};
@@ -4449,14 +4446,13 @@ static void kodicom4400r_muxsel(struct bttv *btv, unsigned int input)
 	}
 	yaddr = (btv->c.nr - mctlr->c.nr + 1) & 3; /* the '&' is for safety */
 	yaddr = map[yaddr];
-	sw_status = (char *)(&mctlr->mbox_we);
 	xaddr = input & 0xf;
 	/* Check if the controller/camera pair has changed, else ignore */
-	if (sw_status[yaddr] != xaddr)
+	if (mctlr->sw_status[yaddr] != xaddr)
 	{
 		/* "open" the old switch, "close" the new one, save the new */
-		kodicom4400r_write(mctlr, sw_status[yaddr], yaddr, 0);
-		sw_status[yaddr] = xaddr;
+		kodicom4400r_write(mctlr, mctlr->sw_status[yaddr], yaddr, 0);
+		mctlr->sw_status[yaddr] = xaddr;
 		kodicom4400r_write(mctlr, xaddr, yaddr, 1);
 	}
 }
@@ -4469,7 +4465,6 @@ static void kodicom4400r_muxsel(struct bttv *btv, unsigned int input)
  */
 static void kodicom4400r_init(struct bttv *btv)
 {
-	char *sw_status = (char *)(&btv->mbox_we);
 	int ix;
 
 	gpio_inout(0x0003ff, 0x0003ff);
@@ -4477,7 +4472,7 @@ static void kodicom4400r_init(struct bttv *btv)
 	gpio_write(0);
 	/* Preset camera 0 to the 4 controllers */
 	for (ix = 0; ix < 4; ix++) {
-		sw_status[ix] = ix;
+		btv->sw_status[ix] = ix;
 		kodicom4400r_write(btv, ix, ix, 1);
 	}
 	/*
@@ -4754,7 +4749,6 @@ static void gv800s_write(struct bttv *btv,
 static void gv800s_muxsel(struct bttv *btv, unsigned int input)
 {
 	struct bttv *mctlr;
-	char *sw_status;
 	int xaddr, yaddr;
 	static unsigned int map[4][4] = { { 0x0, 0x4, 0xa, 0x6 },
 					  { 0x1, 0x5, 0xb, 0x7 },
@@ -4767,14 +4761,13 @@ static void gv800s_muxsel(struct bttv *btv, unsigned int input)
 		return;
 	}
 	yaddr = (btv->c.nr - mctlr->c.nr) & 3;
-	sw_status = (char *)(&mctlr->mbox_we);
 	xaddr = map[yaddr][input] & 0xf;
 
 	/* Check if the controller/camera pair has changed, ignore otherwise */
-	if (sw_status[yaddr] != xaddr) {
+	if (mctlr->sw_status[yaddr] != xaddr) {
 		/* disable the old switch, enable the new one and save status */
-		gv800s_write(mctlr, sw_status[yaddr], yaddr, 0);
-		sw_status[yaddr] = xaddr;
+		gv800s_write(mctlr, mctlr->sw_status[yaddr], yaddr, 0);
+		mctlr->sw_status[yaddr] = xaddr;
 		gv800s_write(mctlr, xaddr, yaddr, 1);
 	}
 }
@@ -4782,7 +4775,6 @@ static void gv800s_muxsel(struct bttv *btv, unsigned int input)
 /* GeoVision GV-800(S) "master" chip init */
 static void gv800s_init(struct bttv *btv)
 {
-	char *sw_status = (char *)(&btv->mbox_we);
 	int ix;
 
 	gpio_inout(0xf107f, 0xf107f);
@@ -4791,7 +4783,7 @@ static void gv800s_init(struct bttv *btv)
 
 	/* Preset camera 0 to the 4 controllers */
 	for (ix = 0; ix < 4; ix++) {
-		sw_status[ix] = ix;
+		btv->sw_status[ix] = ix;
 		gv800s_write(btv, ix, ix, 1);
 	}
 
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index 9c1cc2c..6eefb59 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -459,6 +459,9 @@ struct bttv {
 	int mbox_iow;
 	int mbox_csel;
 
+	/* switch status for multi-controller cards */
+	char sw_status[4];
+
 	/* risc memory management data
 	   - must acquire s_lock before changing these
 	   - only the irq handler is supported to touch top + bottom + vcurr */
-- 
Ondrej Zary

