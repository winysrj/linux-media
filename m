Return-path: <linux-media-owner@vger.kernel.org>
Received: from nautilus.laiva.org ([62.142.120.74]:55160 "EHLO
	nautilus.laiva.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbcCBLNN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 06:13:13 -0500
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/2] dw2102: ts2020 included twice
Date: Wed,  2 Mar 2016 13:06:05 +0200
Message-Id: <1456916766-28165-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ts2020.h was already included a few lines earlier. Remove the unnecessary entry.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb/dw2102.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index dd46d6c..8fd1aae 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -33,7 +33,6 @@
 #include "tda18271.h"
 #include "cxd2820r.h"
 #include "m88ds3103.h"
-#include "ts2020.h"
 
 /* Max transfer size done by I2C transfer functions */
 #define MAX_XFER_SIZE  64
-- 
1.7.0.4

