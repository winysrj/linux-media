Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:44112 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932413AbdJXPXY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Oct 2017 11:23:24 -0400
Received: by mail-pf0-f195.google.com with SMTP id x7so19933011pfa.1
        for <linux-media@vger.kernel.org>; Tue, 24 Oct 2017 08:23:24 -0700 (PDT)
Date: Tue, 24 Oct 2017 08:23:21 -0700
From: Kees Cook <keescook@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Mike Isely <isely@pobox.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: s2255: Convert timers to use timer_setup()
Message-ID: <20171024152321.GA105022@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Bhumika Goyal <bhumirks@gmail.com>
Cc: Mike Isely <isely@pobox.com>
Cc: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/usb/s2255/s2255drv.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index b2f239c4ba42..7fee5766587a 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -485,9 +485,10 @@ static void s2255_reset_dsppower(struct s2255_dev *dev)
 
 /* kickstarts the firmware loading. from probe
  */
-static void s2255_timer(unsigned long user_data)
+static void s2255_timer(struct timer_list *t)
 {
-	struct s2255_fw *data = (struct s2255_fw *)user_data;
+	struct s2255_dev *dev = from_timer(dev, t, timer);
+	struct s2255_fw *data = dev->fw_data;
 	if (usb_submit_urb(data->fw_urb, GFP_ATOMIC) < 0) {
 		pr_err("s2255: can't submit urb\n");
 		atomic_set(&data->fw_state, S2255_FW_FAILED);
@@ -2283,7 +2284,7 @@ static int s2255_probe(struct usb_interface *interface,
 		dev_err(&interface->dev, "Could not find bulk-in endpoint\n");
 		goto errorEP;
 	}
-	setup_timer(&dev->timer, s2255_timer, (unsigned long)dev->fw_data);
+	timer_setup(&dev->timer, s2255_timer, 0);
 	init_waitqueue_head(&dev->fw_data->wait_fw);
 	for (i = 0; i < MAX_CHANNELS; i++) {
 		struct s2255_vc *vc = &dev->vc[i];
-- 
2.7.4


-- 
Kees Cook
Pixel Security
