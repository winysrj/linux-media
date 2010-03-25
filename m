Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:59892 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab0CYBgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 21:36:01 -0400
Received: by fxm23 with SMTP id 23so679983fxm.21
        for <linux-media@vger.kernel.org>; Wed, 24 Mar 2010 18:35:59 -0700 (PDT)
Subject: [PATCH] pwc Kconfig dependency fix
From: Christoph Fritz <chf.fritz@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Luc Saillard <luc@saillard.org>,
	Pham Thanh Nam <phamthanhnam.ptn@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain
Date: Thu, 25 Mar 2010 02:40:41 +0100
Message-Id: <1269481241.3855.5.camel@lovely>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

makes USB_PWC_INPUT_EVDEV to depend also on USB_PWC

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
---
 drivers/media/video/pwc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/pwc/Kconfig b/drivers/media/video/pwc/Kconfig
index 340f954..11980db 100644
--- a/drivers/media/video/pwc/Kconfig
+++ b/drivers/media/video/pwc/Kconfig
@@ -39,7 +39,7 @@ config USB_PWC_DEBUG
 config USB_PWC_INPUT_EVDEV
 	bool "USB Philips Cameras input events device support"
 	default y
-	depends on USB_PWC=INPUT || INPUT=y
+	depends on USB_PWC && (USB_PWC=INPUT || INPUT=y)
 	---help---
 	  This option makes USB Philips cameras register the snapshot button as
 	  an input device to report button events.
-- 
1.5.6.5



