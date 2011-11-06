Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40138 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab1KFUcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 15:32:31 -0500
Received: by mail-fx0-f46.google.com with SMTP id o14so4498572faa.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 12:32:30 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH 11/13] staging: as102: Move variable declarations to the header
Date: Sun,  6 Nov 2011 21:31:48 +0100
Message-Id: <1320611510-3326-12-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes following checkpatch.pl warning:
WARNING: externs should be avoided in .c files

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as102_drv.h |    1 +
 drivers/staging/media/as102/as102_fe.c  |    2 --
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/as102/as102_drv.h b/drivers/staging/media/as102/as102_drv.h
index d32019c..06466fd 100644
--- a/drivers/staging/media/as102/as102_drv.h
+++ b/drivers/staging/media/as102/as102_drv.h
@@ -29,6 +29,7 @@
 
 extern int debug;
 extern struct usb_driver as102_usb_driver;
+extern int elna_enable;
 
 #define dprintk(debug, args...) \
 	do { if (debug) {	\
diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index 7d7dd55..c2adfe5 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -23,8 +23,6 @@
 #include "as10x_types.h"
 #include "as10x_cmd.h"
 
-extern int elna_enable;
-
 static void as10x_fe_copy_tps_parameters(struct dvb_frontend_parameters *dst,
 					 struct as10x_tps *src);
 
-- 
1.7.5.4

