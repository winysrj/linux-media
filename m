Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:45600 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbZILObD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 10:31:03 -0400
Received: by ewy2 with SMTP id 2so1828559ewy.17
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 07:31:05 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 12 Sep 2009 10:31:05 -0400
Message-ID: <37219a840909120731j1166b2b0r8c51dc7ba8dbea6a@mail.gmail.com>
Subject: [2.6.30.y PATCH 1/1] V4L: em28xx: set up tda9887_conf in
	em28xx_card_setup()
From: Michael Krufky <mkrufky@linuxtv.org>
To: stable@kernel.org
Cc: Franklin Meng <fmeng2002@yahoo.com>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L: em28xx: set up tda9887_conf in em28xx_card_setup()

From: Franklin Meng <fmeng2002@yahoo.com>

Added tda9887_conf set up into em28xx_card_setup()

Signed-off-by: Franklin Meng <fmeng2002@yahoo.com>
Signed-off-by: Douglas Schilling Landgraf <dougsland@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
(cherry picked from commit ae3340cbf59ea362c2016eea762456cc0969fd9e)
---
 drivers/media/video/em28xx/em28xx-cards.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c
b/drivers/media/video/em28xx/em28xx-cards.c
index 7c70738..168e892 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1886,6 +1886,9 @@ void em28xx_card_setup(struct em28xx *dev)
 	if (em28xx_boards[dev->model].tuner_addr)
 		dev->tuner_addr = em28xx_boards[dev->model].tuner_addr;

+	if (em28xx_boards[dev->model].tda9887_conf)
+		dev->tda9887_conf = em28xx_boards[dev->model].tda9887_conf;
+
 	/* request some modules */
 	switch (dev->model) {
 	case EM2820_BOARD_HAUPPAUGE_WINTV_USB_2:
-- 
1.6.0.4
