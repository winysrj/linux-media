Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:57643 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbcF2OZ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 10:25:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kamil Debski <kamil@wypas.org>, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] [media] cec: add MEDIA_SUPPORT dependency
Date: Wed, 29 Jun 2016 16:26:35 +0200
Message-Id: <20160629142749.4125434-2-arnd@arndb.de>
In-Reply-To: <20160629142749.4125434-1-arnd@arndb.de>
References: <20160629142749.4125434-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MEDIA_CEC_EDID option is guarded by MEDIA_SUPPORT, so selecting
it from MEDIA_CEC produces a warning:

warning: (MEDIA_CEC) selects MEDIA_CEC_EDID which has unmet direct dependencies (MEDIA_SUPPORT)

The warning is harmless, but it's better to add an explicit
dependency to shut it up, to reduce the noise during randconfig
builds.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: ca684386e6e2 ("[media] cec: add HDMI CEC framework (api)")
---
 drivers/staging/media/cec/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/cec/Kconfig b/drivers/staging/media/cec/Kconfig
index 8a7aceeac815..cd523590ea6f 100644
--- a/drivers/staging/media/cec/Kconfig
+++ b/drivers/staging/media/cec/Kconfig
@@ -1,5 +1,6 @@
 config MEDIA_CEC
 	tristate "CEC API (EXPERIMENTAL)"
+	depends on MEDIA_SUPPORT
 	select MEDIA_CEC_EDID
 	---help---
 	  Enable the CEC API.
-- 
2.9.0

