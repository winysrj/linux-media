Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59634 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab1E1Jff (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 05:35:35 -0400
Received: by wya21 with SMTP id 21so1722592wya.19
        for <linux-media@vger.kernel.org>; Sat, 28 May 2011 02:35:34 -0700 (PDT)
From: =?UTF-8?q?C=C3=A9dric=20Schieli?= <cschieli@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?C=C3=A9dric=20Schieli?= <cschieli@gmail.com>
Subject: [PATCH] keytable: fix segfault when RC driver's module_name is null
Date: Sat, 28 May 2011 11:35:16 +0200
Message-Id: <1306575316-25536-1-git-send-email-cschieli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Some dvb-usb drivers do not set a proper module_name in their rc.core struct
(e.g. the ttusb2 module and various dib0700 submodules as of 2.6.39).
Auto-load mode was segfaulting if trying to match those drivers with a * value.

Signed-off-by: Cédric Schieli <cschieli@gmail.com>
---
 utils/keytable/keytable.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index c406a18..13df13b 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -1427,9 +1427,9 @@ int main(int argc, char *argv[])
 		int rc;
 
 		for (cur = &cfg; cur->next; cur = cur->next) {
-			if (strcasecmp(cur->driver, rc_dev.drv_name) && strcasecmp(cur->driver, "*"))
+			if ((!rc_dev.drv_name || strcasecmp(cur->driver, rc_dev.drv_name)) && strcasecmp(cur->driver, "*"))
 				continue;
-			if (strcasecmp(cur->table, rc_dev.keytable_name) && strcasecmp(cur->table, "*"))
+			if ((!rc_dev.keytable_name || strcasecmp(cur->table, rc_dev.keytable_name)) && strcasecmp(cur->table, "*"))
 				continue;
 			break;
 		}
-- 
1.7.4.1

