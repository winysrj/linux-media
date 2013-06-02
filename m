Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34902 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab3FBXnH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Jun 2013 19:43:07 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] keene: add delay in order to settle hardware
Date: Mon,  3 Jun 2013 02:41:46 +0300
Message-Id: <1370216506-2811-3-git-send-email-crope@iki.fi>
In-Reply-To: <1370216506-2811-1-git-send-email-crope@iki.fi>
References: <1370216506-2811-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It was found by trial and error testing that at least 11 ms delay is
needed before first I/O, otherwise device will skip given command.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/radio/radio-keene.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index 99da3d4..21db23b 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -382,6 +382,8 @@ static int usb_keene_probe(struct usb_interface *intf,
 	video_set_drvdata(&radio->vdev, radio);
 	set_bit(V4L2_FL_USE_FH_PRIO, &radio->vdev.flags);
 
+	/* at least 11ms is needed in order to settle hardware */
+	msleep(20);
 	keene_cmd_main(radio, 95.16 * FREQ_MUL, false);
 
 	retval = video_register_device(&radio->vdev, VFL_TYPE_RADIO, -1);
-- 
1.7.11.7

