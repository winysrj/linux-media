Return-path: <linux-media-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:33804 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbZKTTQt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 14:16:49 -0500
Date: Fri, 20 Nov 2009 20:16:52 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
cc: linux-media@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] dvb: SMS_SIANO_MDTV should depend on HAS_DMA
Message-ID: <alpine.DEB.2.00.0911202014530.20819@ayla.of.borg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When building for Sun 3:

drivers/built-in.o: In function `smscore_unregister_device':
drivers/media/dvb/siano/smscoreapi.c:723: undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `smscore_register_device':
drivers/media/dvb/siano/smscoreapi.c:365: undefined reference to `dma_alloc_coherent'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/dvb/siano/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/siano/Kconfig b/drivers/media/dvb/siano/Kconfig
index 8c1aed7..85a222c 100644
--- a/drivers/media/dvb/siano/Kconfig
+++ b/drivers/media/dvb/siano/Kconfig
@@ -4,7 +4,7 @@
 
 config SMS_SIANO_MDTV
 	tristate "Siano SMS1xxx based MDTV receiver"
-	depends on DVB_CORE && INPUT
+	depends on DVB_CORE && INPUT && HAS_DMA
 	---help---
 	  Choose Y or M here if you have MDTV receiver with a Siano chipset.
 
-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
