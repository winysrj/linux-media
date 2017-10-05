Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:39227 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751408AbdJEVbB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 17:31:01 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] media: rc: pwm-ir-tx needs OF
Date: Thu,  5 Oct 2017 22:30:58 +0100
Message-Id: <20171005213059.11074-2-sean@mess.org>
In-Reply-To: <20171005213059.11074-1-sean@mess.org>
References: <20171005213059.11074-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without device tree, there is no way to use this driver.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 946d2ec419db..88c8ecd13044 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -416,6 +416,7 @@ config IR_PWM_TX
 	depends on RC_CORE
 	depends on LIRC
 	depends on PWM
+	depends on OF || COMPILE_TEST
 	---help---
 	   Say Y if you want to use a PWM based IR transmitter. This is
 	   more power efficient than the bit banging gpio driver.
-- 
2.13.6
