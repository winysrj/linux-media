Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49730 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbeHNSuY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 14:50:24 -0400
To: linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Neil Armstrong <narmstrong@baylibre.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH -next] media: platform: fix cros-ec-cec build error
Message-ID: <314cbfef-ad4f-b0b2-d57b-3f54c062c1f8@infradead.org>
Date: Tue, 14 Aug 2018 09:02:31 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix build when MFD_CROS_EC is not enabled but COMPILE_TEST=y.
Fixes this build error:

ERROR: "cros_ec_cmd_xfer_status" [drivers/media/platform/cros-ec-cec/cros-ec-cec.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
---
 drivers/media/platform/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20180814.orig/drivers/media/platform/Kconfig
+++ linux-next-20180814/drivers/media/platform/Kconfig
@@ -541,6 +541,8 @@ config VIDEO_CROS_EC_CEC
 	depends on MFD_CROS_EC || COMPILE_TEST
 	select CEC_CORE
 	select CEC_NOTIFIER
+	select CHROME_PLATFORMS
+	select CROS_EC_PROTO
 	---help---
 	  If you say yes here you will get support for the
 	  ChromeOS Embedded Controller's CEC.
