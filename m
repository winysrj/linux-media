Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:56227 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751639AbdJEVbB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 17:31:01 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] media: rc: hix5hd2 drivers needs OF
Date: Thu,  5 Oct 2017 22:30:59 +0100
Message-Id: <20171005213059.11074-3-sean@mess.org>
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
index 88c8ecd13044..94db0ed1df54 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -178,6 +178,7 @@ config IR_ENE
 config IR_HIX5HD2
 	tristate "Hisilicon hix5hd2 IR remote control"
 	depends on RC_CORE
+	depends on OF || COMPILE_TEST
 	help
 	   Say Y here if you want to use hisilicon hix5hd2 remote control.
 	   To compile this driver as a module, choose M here: the module will be
-- 
2.13.6
