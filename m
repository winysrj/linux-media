Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33083 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbaKCUkE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Nov 2014 15:40:04 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Takashi Iwai <tiwai@suse.de>,
	Julia Lawall <julia.lawall@lip6.fr>,
	kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH] cx231xx: Remove a bogus check for null
Date: Mon,  3 Nov 2014 18:39:49 -0200
Message-Id: <12286cf71e652fa7fe6edfae04dbf1d46f9681df.1415046679.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by kbuild test robot:
	drivers/media/usb/cx231xx/cx231xx-audio.c:445:16-20: ERROR: dev is NULL but dereferenced.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index 6d9a03402faf..de4ae5eb4830 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -439,12 +439,6 @@ static int snd_cx231xx_capture_open(struct snd_pcm_substream *substream)
 	dev_dbg(dev->dev,
 		"opening device and trying to acquire exclusive lock\n");
 
-	if (!dev) {
-		dev_err(dev->dev,
-			"BUG: cx231xx can't find device struct. Can't proceed with open\n");
-		return -ENODEV;
-	}
-
 	if (dev->state & DEV_DISCONNECTED) {
 		dev_err(dev->dev,
 			"Can't open. the device was removed.\n");
-- 
1.9.3

