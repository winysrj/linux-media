Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:37859 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751654AbeFELe3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 07:34:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Takashi Iwai <tiwai@suse.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: radio: aimslab: restore RADIO_ISA dependency
Date: Tue,  5 Jun 2018 13:33:21 +0200
Message-Id: <20180605113420.1092324-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch that allowed all the ISA drivers to build across architectures
accidentally removed one 'select' statement, which now causes a rare
randconfig build failure in case all the other drivers are disabled:

drivers/media/radio/radio-aimslab.o:(.data+0x0): undefined reference to `radio_isa_match'
drivers/media/radio/radio-aimslab.o:(.data+0x4): undefined reference to `radio_isa_probe'
drivers/media/radio/radio-aimslab.o:(.data+0x8): undefined reference to `radio_isa_remove'

This puts the statement back where it belongs.

Fixes: 258c524bdaab ("media: radio: allow building ISA drivers with COMPILE_TEST")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/radio/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 8fa403c7149e..39b04ad924c0 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -257,6 +257,7 @@ config RADIO_RTRACK
 	tristate "AIMSlab RadioTrack (aka RadioReveal) support"
 	depends on ISA || COMPILE_TEST
 	depends on VIDEO_V4L2
+	select RADIO_ISA
 	---help---
 	  Choose Y here if you have one of these FM radio cards, and then fill
 	  in the port address below.
-- 
2.9.0
