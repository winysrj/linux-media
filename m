Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:34412 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937689AbdDSUrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 16:47:06 -0400
Received: by mail-qt0-f175.google.com with SMTP id c45so30140558qtb.1
        for <linux-media@vger.kernel.org>; Wed, 19 Apr 2017 13:47:06 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH]  cx88: Fix regression in initial video standard setting
Date: Wed, 19 Apr 2017 16:46:51 -0400
Message-Id: <1492634811-4435-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Setting initial standard at the top of cx8800_initdev would cause the
first call to cx88_set_tvnorm() to return without programming any
registers (leaving the driver saying it's set to NTSC but the hardware
isn't programmed).  Even worse, any subsequent attempt to explicitly
set it to NTSC-M will return success but actually fail to program the
underlying registers unless first changing the standard to something
other than NTSC-M.

Set the initial standard later in the process, and make sure the field
is zero at the beginning to ensure that the call always goes through.

This regression was introduced in the following commit:

commit ccd6f1d488e7 ("[media] cx88: move width, height and field to core
struct")

Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Sat Sep 20 09:23:44 2014 -0300

[media] cx88: move width, height and field to core struct

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/pci/cx88/cx88-cards.c | 9 ++++++++-
 drivers/media/pci/cx88/cx88-video.c | 2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index 73cc7a6..b7a8c8c 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -3681,7 +3681,14 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	core->nr = nr;
 	sprintf(core->name, "cx88[%d]", core->nr);
 
-	core->tvnorm = V4L2_STD_NTSC_M;
+	/*
+	 * Note: Setting initial standard here would cause first call to
+	 * cx88_set_tvnorm() to return without programming any registers.  Leave
+	 * it blank for at this point and it will get set later in
+	 * cx8800_inittdev()
+	 */
+	core->tvnorm  = 0;
+
 	core->width   = 320;
 	core->height  = 240;
 	core->field   = V4L2_FIELD_INTERLACED;
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index c7d4e87..3c529dd 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1435,7 +1435,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 
 	/* initial device configuration */
 	mutex_lock(&core->lock);
-	cx88_set_tvnorm(core, core->tvnorm);
+	cx88_set_tvnorm(core, V4L2_STD_NTSC_M);
 	v4l2_ctrl_handler_setup(&core->video_hdl);
 	v4l2_ctrl_handler_setup(&core->audio_hdl);
 	cx88_video_mux(core, 0);
-- 
1.9.1
