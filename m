Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:51279 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbcF2O0G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 10:26:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kamil Debski <kamil@wypas.org>, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] [media] cec: add RC_CORE dependency
Date: Wed, 29 Jun 2016 16:26:36 +0200
Message-Id: <20160629142749.4125434-3-arnd@arndb.de>
In-Reply-To: <20160629142749.4125434-1-arnd@arndb.de>
References: <20160629142749.4125434-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We cannot build the cec driver when the RC core is a module
and cec is built-in:

drivers/staging/built-in.o: In function `cec_allocate_adapter':
:(.text+0x134): undefined reference to `rc_allocate_device'
drivers/staging/built-in.o: In function `cec_register_adapter':
:(.text+0x304): undefined reference to `rc_register_device'

This adds an explicit dependency to avoid this case. We still
allow building when CONFIG_RC_CORE is disabled completely,
as the driver has checks for this case itself.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/cec/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/cec/Kconfig b/drivers/staging/media/cec/Kconfig
index cd523590ea6f..b83b4d83946d 100644
--- a/drivers/staging/media/cec/Kconfig
+++ b/drivers/staging/media/cec/Kconfig
@@ -1,6 +1,7 @@
 config MEDIA_CEC
 	tristate "CEC API (EXPERIMENTAL)"
 	depends on MEDIA_SUPPORT
+	depends on RC_CORE || !RC_CORE
 	select MEDIA_CEC_EDID
 	---help---
 	  Enable the CEC API.
-- 
2.9.0

