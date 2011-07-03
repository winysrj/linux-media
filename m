Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:49634 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750730Ab1GCRFq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 13:05:46 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 15/16] ngene: Update for latest cxd2099
Date: Sun, 3 Jul 2011 19:03:49 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201107031831.20378@orion.escape-edv.de>
In-Reply-To: <201107031831.20378@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107031903.50571@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Modifications for latest cxd2099.

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/media/dvb/ngene/ngene-core.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
index fa4b3eb..df0f0bd 100644
--- a/drivers/media/dvb/ngene/ngene-core.c
+++ b/drivers/media/dvb/ngene/ngene-core.c
@@ -1582,11 +1582,18 @@ static int init_channels(struct ngene *dev)
 	return 0;
 }
 
+static struct cxd2099_cfg cxd_cfg = {
+	.bitrate = 62000,
+	.adr = 0x40,
+	.polarity = 0,
+	.clock_mode = 0,
+};
+
 static void cxd_attach(struct ngene *dev)
 {
 	struct ngene_ci *ci = &dev->ci;
 
-	ci->en = cxd2099_attach(0x40, dev, &dev->channel[0].i2c_adapter);
+	ci->en = cxd2099_attach(&cxd_cfg, dev, &dev->channel[0].i2c_adapter);
 	ci->dev = dev;
 	return;
 }
-- 
1.7.4.1

