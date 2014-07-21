Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55245 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbaGUQ2X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 12:28:23 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/3] xc4000: add module meta-tag with the firmware names
Date: Mon, 21 Jul 2014 13:28:14 -0300
Message-Id: <1405960095-29408-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1405960095-29408-1-git-send-email-m.chehab@samsung.com>
References: <1405960095-29408-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This meta-tag is used by some distros to help them package
the firmware and generate proper initrd images.

So, add the firmware names there.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/xc4000.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index 44df271a78f8..7d008b4d3595 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -1770,3 +1770,5 @@ EXPORT_SYMBOL(xc4000_attach);
 MODULE_AUTHOR("Steven Toth, Davide Ferri");
 MODULE_DESCRIPTION("Xceive xc4000 silicon tuner driver");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(XC4000_DEFAULT_FIRMWARE_NEW);
+MODULE_FIRMWARE(XC4000_DEFAULT_FIRMWARE);
-- 
1.9.3

