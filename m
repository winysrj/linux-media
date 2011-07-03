Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:51061 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751253Ab1GCQ5q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 12:57:46 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 10/16] ngene: Fix return code if no demux was found
Date: Sun, 3 Jul 2011 18:57:26 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201107031831.20378@orion.escape-edv.de>
In-Reply-To: <201107031831.20378@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107031857.28037@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Fix return code if no demux was found (cineS2_probe).

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/media/dvb/ngene/ngene-cards.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/ngene/ngene-cards.c b/drivers/media/dvb/ngene/ngene-cards.c
index 0d550a9..0d879cb 100644
--- a/drivers/media/dvb/ngene/ngene-cards.c
+++ b/drivers/media/dvb/ngene/ngene-cards.c
@@ -274,6 +274,7 @@ static int cineS2_probe(struct ngene_channel *chan)
 		demod_attach_drxk(chan, i2c);
 	} else {
 		printk(KERN_ERR "No demod found on chan %d\n", chan->number);
+		return -ENODEV;
 	}
 	return 0;
 }
-- 
1.7.4.1

