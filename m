Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:49983 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbcGSIK6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 04:10:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [media] staging: add MEDIA_SUPPORT dependency
Date: Tue, 19 Jul 2016 10:10:12 +0200
Message-Id: <20160719081040.2685845-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

staging media drivers tend to have a build time dependency on the
media support. In particular, the newly added pulse8 cec driver can
only be a loadable module if MEDIA_SUPPORT=m, but its build dependency
is on a 'bool' symbol (MEDIA_CEC), so a randconfig build can fail
with pulse8_cec built-in:

drivers/staging/built-in.o: In function `pulse8_disconnect':
dgnc_utils.c:(.text+0x114): undefined reference to `cec_unregister_adapter'
drivers/staging/built-in.o: In function `pulse8_irq_work_handler':
dgnc_utils.c:(.text+0x1bc): undefined reference to `cec_transmit_done'
dgnc_utils.c:(.text+0x1d8): undefined reference to `cec_received_msg'
dgnc_utils.c:(.text+0x1f4): undefined reference to `cec_transmit_done'
dgnc_utils.c:(.text+0x218): undefined reference to `cec_transmit_done'
dgnc_utils.c:(.text+0x23c): undefined reference to `cec_transmit_done'
drivers/staging/built-in.o: In function `pulse8_connect':
dgnc_utils.c:(.text+0x844): undefined reference to `cec_allocate_adapter'
dgnc_utils.c:(.text+0x8a4): undefined reference to `cec_delete_adapter'
dgnc_utils.c:(.text+0xa10): undefined reference to `cec_register_adapter'

Originally, MEDIA_CEC itself was a tristate symbol, which would have
prevented this, but since 5bb2399a4fe4 ("[media] cec: fix Kconfig
dependency problems"), it doesn't work like that any more.

This encloses all of the staging media drivers in a CONFIG_MEDIA_SUPPORT
dependency in Kconfig, which solves the problem by enforcing that none
of the drivers can be built-in if the media core is a module.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index cae42e56f270..7292f23954df 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -16,7 +16,7 @@ menuconfig STAGING_MEDIA
           If in doubt, say N here.
 
 
-if STAGING_MEDIA
+if STAGING_MEDIA && MEDIA_SUPPORT
 
 # Please keep them in alphabetic order
 source "drivers/staging/media/bcm2048/Kconfig"
-- 
2.9.0

