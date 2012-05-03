Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51180 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758908Ab2ECWWg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 18:22:36 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so3032860pbb.19
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 15:22:35 -0700 (PDT)
From: mathieu.poirier@linaro.org
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 3/6] media/rc: IR_SONY_DECODER depends on BITREVERSE
Date: Thu,  3 May 2012 16:22:24 -0600
Message-Id: <1336083747-3142-4-git-send-email-mathieu.poirier@linaro.org>
In-Reply-To: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
References: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

The IR sony decoder is making use of 'bitrev8' that,
in turn, requires BITREVERSE.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/media/rc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index a3fbb21..f97eeb8 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -69,6 +69,7 @@ config IR_JVC_DECODER
 config IR_SONY_DECODER
 	tristate "Enable IR raw decoder for the Sony protocol"
 	depends on RC_CORE
+	select BITREVERSE
 	default y
 
 	---help---
-- 
1.7.5.4

