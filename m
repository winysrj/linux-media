Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57211 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab3FBXnH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Jun 2013 19:43:07 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/2] Keene
Date: Mon,  3 Jun 2013 02:41:45 +0300
Message-Id: <1370216506-2811-2-git-send-email-crope@iki.fi>
In-Reply-To: <1370216506-2811-1-git-send-email-crope@iki.fi>
References: <1370216506-2811-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil@xs4all.nl>

Can you try this patch:
---
 drivers/media/radio/radio-keene.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index 4c9ae76..99da3d4 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -93,7 +93,7 @@ static int keene_cmd_main(struct keene_device *radio, unsigned freq, bool play)
 	/* If bit 4 is set, then tune to the frequency.
 	   If bit 3 is set, then unmute; if bit 2 is set, then mute.
 	   If bit 1 is set, then enter idle mode; if bit 0 is set,
-	   then enter transit mode.
+	   then enter transmit mode.
 	 */
 	radio->buffer[5] = (radio->muted ? 4 : 8) | (play ? 1 : 2) |
 							(freq ? 0x10 : 0);
@@ -350,7 +350,6 @@ static int usb_keene_probe(struct usb_interface *intf,
 	radio->pa = 118;
 	radio->tx = 0x32;
 	radio->stereo = true;
-	radio->curfreq = 95.16 * FREQ_MUL;
 	if (hdl->error) {
 		retval = hdl->error;
 
@@ -383,6 +382,8 @@ static int usb_keene_probe(struct usb_interface *intf,
 	video_set_drvdata(&radio->vdev, radio);
 	set_bit(V4L2_FL_USE_FH_PRIO, &radio->vdev.flags);
 
+	keene_cmd_main(radio, 95.16 * FREQ_MUL, false);
+
 	retval = video_register_device(&radio->vdev, VFL_TYPE_RADIO, -1);
 	if (retval < 0) {
 		dev_err(&intf->dev, "could not register video device\n");
-- 
1.7.11.7

