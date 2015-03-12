Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:61514 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbbCLKa3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 06:30:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [PATCH] [media] wl128x-radio really depends on TI_ST
Date: Thu, 12 Mar 2015 11:29:42 +0100
Message-ID: <2326941.T7LotG40WY@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All other drivers using the TI_ST infrastructure use
'depends on' for this symbol, and it makes no sense
to only enable that if CONFIG_NET is enable, because
the radio driver also depends on CONFIG_NET itself:

ERROR: "skb_queue_purge" [drivers/media/radio/wl128x/fm_drv.ko] undefined!
ERROR: "skb_push" [drivers/media/radio/wl128x/fm_drv.ko] undefined!
ERROR: "skb_pull" [drivers/media/radio/wl128x/fm_drv.ko] undefined!

Making the driver dependency explicit solves randconfig
build problems and makes it more obvious to the reader.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/media/radio/wl128x/Kconfig b/drivers/media/radio/wl128x/Kconfig
index f359be7e9dd9..9d6574bebf78 100644
--- a/drivers/media/radio/wl128x/Kconfig
+++ b/drivers/media/radio/wl128x/Kconfig
@@ -5,7 +5,7 @@ menu "Texas Instruments WL128x FM driver (ST based)"
 config RADIO_WL128X
 	tristate "Texas Instruments WL128x FM Radio"
 	depends on VIDEO_V4L2 && RFKILL && GPIOLIB && TTY
-	select TI_ST if NET
+	depends on TI_ST
 	help
 	Choose Y here if you have this FM radio chip.
 

