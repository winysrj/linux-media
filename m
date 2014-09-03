Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44403 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 26/46] [media] msi2500: simplify boolean tests
Date: Wed,  3 Sep 2014 17:32:58 -0300
Message-Id: <4e428fc4adfa1b47b4d19d79ac5866a1ac30e06a.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using if (foo == false), just use
if (!foo).

That allows a faster mental parsing when analyzing the
code.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 71e0960b46c0..e980aaa47b7c 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -1212,7 +1212,7 @@ static int msi2500_probe(struct usb_interface *intf,
 	s->pixelformat = formats[0].pixelformat;
 	s->buffersize = formats[0].buffersize;
 	s->num_formats = NUM_FORMATS;
-	if (msi2500_emulated_fmt == false)
+	if (!msi2500_emulated_fmt)
 		s->num_formats -= 2;
 
 	/* Init videobuf2 queue structure */
-- 
1.9.3

