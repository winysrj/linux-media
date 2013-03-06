Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:38744 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3CFJO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 04:14:58 -0500
Received: by mail-pb0-f51.google.com with SMTP id un15so5735379pbc.10
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 01:14:57 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, sachin.kamat@linaro.org
Subject: [PATCH 1/1] [media] dvb-usb/dw2102: Remove duplicate inclusion of ts2020.h
Date: Wed,  6 Mar 2013 14:34:26 +0530
Message-Id: <1362560666-4249-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ts2020.h was included twice.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/usb/dvb-usb/dw2102.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 9578a67..c629d02 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -29,7 +29,6 @@
 #include "stb6100.h"
 #include "stb6100_proc.h"
 #include "m88rs2000.h"
-#include "ts2020.h"
 
 #ifndef USB_PID_DW2102
 #define USB_PID_DW2102 0x2102
-- 
1.7.4.1

