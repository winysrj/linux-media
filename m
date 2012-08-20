Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47453 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab2HTBYM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Aug 2012 21:24:12 -0400
Received: by ghrr11 with SMTP id r11so4807916ghr.19
        for <linux-media@vger.kernel.org>; Sun, 19 Aug 2012 18:24:11 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 1/4] stk1160: Make kill/free urb debug message more verbose
Date: Sun, 19 Aug 2012 22:23:43 -0300
Message-Id: <1345425826-13429-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is just a cleaning patch to produce more useful
debug messages.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-video.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 3785269..022092a 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -342,18 +342,18 @@ static void stk1160_isoc_irq(struct urb *urb)
  */
 void stk1160_cancel_isoc(struct stk1160 *dev)
 {
-	int i;
+	int i, num_bufs = dev->isoc_ctl.num_bufs;
 
 	/*
 	 * This check is not necessary, but we add it
 	 * to avoid a spurious debug message
 	 */
-	if (!dev->isoc_ctl.num_bufs)
+	if (!num_bufs)
 		return;
 
-	stk1160_dbg("killing urbs...\n");
+	stk1160_dbg("killing %d urbs...\n", num_bufs);
 
-	for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
+	for (i = 0; i < num_bufs; i++) {
 
 		/*
 		 * To kill urbs we can't be in atomic context.
@@ -373,11 +373,11 @@ void stk1160_cancel_isoc(struct stk1160 *dev)
 void stk1160_free_isoc(struct stk1160 *dev)
 {
 	struct urb *urb;
-	int i;
+	int i, num_bufs = dev->isoc_ctl.num_bufs;
 
-	stk1160_dbg("freeing urb buffers...\n");
+	stk1160_dbg("freeing %d urb buffers...\n", num_bufs);
 
-	for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
+	for (i = 0; i < num_bufs; i++) {
 
 		urb = dev->isoc_ctl.urb[i];
 		if (urb) {
-- 
1.7.8.6

