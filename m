Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:60387 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871Ab0EXFdJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 01:33:09 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH] tm6000: add include file
Date: Mon, 24 May 2010 07:31:06 +0200
Message-Id: <1274679066-7335-3-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

add xc5000.h

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-dvb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index b504a90..714b384 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -28,6 +28,7 @@
 #include <media/tuner.h>
 
 #include "tuner-xc2028.h"
+#include "xc5000.h"
 
 static void inline print_err_status (struct tm6000_core *dev,
 				     int packet, int status)
-- 
1.7.0.3

