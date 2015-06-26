Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55125 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbbFZUnZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 16:43:25 -0400
Message-ID: <558DB96C.6040803@infradead.org>
Date: Fri, 26 Jun 2015 13:43:24 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH -next] media/pci/cobalt: fix Kconfig and build when SND is
 not enabled
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors in cobalt driver when CONFIG_SND is not enabled.
Fixes these build errors:

ERROR: "snd_pcm_period_elapsed" [drivers/media/pci/cobalt/cobalt.ko] undefined!
ERROR: "_snd_pcm_stream_lock_irqsave" [drivers/media/pci/cobalt/cobalt.ko] undefined!
ERROR: "snd_pcm_hw_constraint_integer" [drivers/media/pci/cobalt/cobalt.ko] undefined!
ERROR: "snd_pcm_set_ops" [drivers/media/pci/cobalt/cobalt.ko] undefined!
ERROR: "snd_pcm_stream_unlock_irqrestore" [drivers/media/pci/cobalt/cobalt.ko] undefined!
ERROR: "snd_pcm_lib_ioctl" [drivers/media/pci/cobalt/cobalt.ko] undefined!
ERROR: "snd_card_new" [drivers/media/pci/cobalt/cobalt.ko] undefined!
ERROR: "snd_card_free" [drivers/media/pci/cobalt/cobalt.ko] undefined!
ERROR: "snd_card_register" [drivers/media/pci/cobalt/cobalt.ko] undefined!
ERROR: "snd_pcm_new" [drivers/media/pci/cobalt/cobalt.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20150626.orig/drivers/media/pci/cobalt/Kconfig
+++ linux-next-20150626/drivers/media/pci/cobalt/Kconfig
@@ -2,6 +2,7 @@ config VIDEO_COBALT
 	tristate "Cisco Cobalt support"
 	depends on VIDEO_V4L2 && I2C && MEDIA_CONTROLLER
 	depends on PCI_MSI && MTD_COMPLEX_MAPPINGS && GPIOLIB
+	depends on SND
 	select I2C_ALGOBIT
 	select VIDEO_ADV7604
 	select VIDEO_ADV7511
