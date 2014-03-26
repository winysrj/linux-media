Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53702 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbaCZVLD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 17:11:03 -0400
Received: by mail-wi0-f175.google.com with SMTP id cc10so5177662wib.8
        for <linux-media@vger.kernel.org>; Wed, 26 Mar 2014 14:11:01 -0700 (PDT)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH 3/3] rc: img-ir: Expand copyright headers with GPL notices
Date: Wed, 26 Mar 2014 21:08:33 +0000
Message-Id: <1395868113-17950-4-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1395868113-17950-1-git-send-email-james.hogan@imgtec.com>
References: <1395868113-17950-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the basic GPLv2+ license notice to the copyright headers at the top
of all the source files in the img-ir driver.

Reported-by: David Härdeman <david@hardeman.nu>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/img-ir/img-ir-core.c  | 5 +++++
 drivers/media/rc/img-ir/img-ir-hw.c    | 5 +++++
 drivers/media/rc/img-ir/img-ir-hw.h    | 5 +++++
 drivers/media/rc/img-ir/img-ir-jvc.c   | 5 +++++
 drivers/media/rc/img-ir/img-ir-nec.c   | 5 +++++
 drivers/media/rc/img-ir/img-ir-raw.c   | 5 +++++
 drivers/media/rc/img-ir/img-ir-raw.h   | 5 +++++
 drivers/media/rc/img-ir/img-ir-sanyo.c | 5 +++++
 drivers/media/rc/img-ir/img-ir-sharp.c | 5 +++++
 drivers/media/rc/img-ir/img-ir-sony.c  | 5 +++++
 drivers/media/rc/img-ir/img-ir.h       | 5 +++++
 11 files changed, 55 insertions(+)

diff --git a/drivers/media/rc/img-ir/img-ir-core.c b/drivers/media/rc/img-ir/img-ir-core.c
index 6b78348..a0cac2f 100644
--- a/drivers/media/rc/img-ir/img-ir-core.c
+++ b/drivers/media/rc/img-ir/img-ir-core.c
@@ -3,6 +3,11 @@
  *
  * Copyright 2010-2014 Imagination Technologies Ltd.
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
  * This contains core img-ir code for setting up the driver. The two interfaces
  * (raw and hardware decode) are handled separately.
  */
diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 579a52b..23b47c7 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -3,6 +3,11 @@
  *
  * Copyright 2010-2014 Imagination Technologies Ltd.
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
  * This ties into the input subsystem using the RC-core. Protocol support is
  * provided in separate modules which provide the parameters and scancode
  * translation functions to set up the hardware decoder and interpret the
diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img-ir/img-ir-hw.h
index 6c9a94a..450f17d 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.h
+++ b/drivers/media/rc/img-ir/img-ir-hw.h
@@ -2,6 +2,11 @@
  * ImgTec IR Hardware Decoder found in PowerDown Controller.
  *
  * Copyright 2010-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
  */
 
 #ifndef _IMG_IR_HW_H_
diff --git a/drivers/media/rc/img-ir/img-ir-jvc.c b/drivers/media/rc/img-ir/img-ir-jvc.c
index 10209d2..85ee90f 100644
--- a/drivers/media/rc/img-ir/img-ir-jvc.c
+++ b/drivers/media/rc/img-ir/img-ir-jvc.c
@@ -2,6 +2,11 @@
  * ImgTec IR Decoder setup for JVC protocol.
  *
  * Copyright 2012-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
  */
 
 #include "img-ir-hw.h"
diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/img-ir/img-ir-nec.c
index e7a731b..cff3212 100644
--- a/drivers/media/rc/img-ir/img-ir-nec.c
+++ b/drivers/media/rc/img-ir/img-ir-nec.c
@@ -2,6 +2,11 @@
  * ImgTec IR Decoder setup for NEC protocol.
  *
  * Copyright 2010-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
  */
 
 #include "img-ir-hw.h"
diff --git a/drivers/media/rc/img-ir/img-ir-raw.c b/drivers/media/rc/img-ir/img-ir-raw.c
index cfb01d9..33f37ed 100644
--- a/drivers/media/rc/img-ir/img-ir-raw.c
+++ b/drivers/media/rc/img-ir/img-ir-raw.c
@@ -3,6 +3,11 @@
  *
  * Copyright 2010-2014 Imagination Technologies Ltd.
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
  * This ties into the input subsystem using the RC-core in raw mode. Raw IR
  * signal edges are reported and decoded by generic software decoders.
  */
diff --git a/drivers/media/rc/img-ir/img-ir-raw.h b/drivers/media/rc/img-ir/img-ir-raw.h
index 9802ffd..4c9b767 100644
--- a/drivers/media/rc/img-ir/img-ir-raw.h
+++ b/drivers/media/rc/img-ir/img-ir-raw.h
@@ -2,6 +2,11 @@
  * ImgTec IR Raw Decoder found in PowerDown Controller.
  *
  * Copyright 2010-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
  */
 
 #ifndef _IMG_IR_RAW_H_
diff --git a/drivers/media/rc/img-ir/img-ir-sanyo.c b/drivers/media/rc/img-ir/img-ir-sanyo.c
index c2c763e..6755c94 100644
--- a/drivers/media/rc/img-ir/img-ir-sanyo.c
+++ b/drivers/media/rc/img-ir/img-ir-sanyo.c
@@ -3,6 +3,11 @@
  *
  * Copyright 2012-2014 Imagination Technologies Ltd.
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
  * From ir-sanyo-decoder.c:
  *
  * This protocol uses the NEC protocol timings. However, data is formatted as:
diff --git a/drivers/media/rc/img-ir/img-ir-sharp.c b/drivers/media/rc/img-ir/img-ir-sharp.c
index 3397cc5..5867be0 100644
--- a/drivers/media/rc/img-ir/img-ir-sharp.c
+++ b/drivers/media/rc/img-ir/img-ir-sharp.c
@@ -2,6 +2,11 @@
  * ImgTec IR Decoder setup for Sharp protocol.
  *
  * Copyright 2012-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
  */
 
 #include "img-ir-hw.h"
diff --git a/drivers/media/rc/img-ir/img-ir-sony.c b/drivers/media/rc/img-ir/img-ir-sony.c
index 993409a..b9029ae 100644
--- a/drivers/media/rc/img-ir/img-ir-sony.c
+++ b/drivers/media/rc/img-ir/img-ir-sony.c
@@ -2,6 +2,11 @@
  * ImgTec IR Decoder setup for Sony (SIRC) protocol.
  *
  * Copyright 2012-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
  */
 
 #include "img-ir-hw.h"
diff --git a/drivers/media/rc/img-ir/img-ir.h b/drivers/media/rc/img-ir/img-ir.h
index afb1893..2ddf560 100644
--- a/drivers/media/rc/img-ir/img-ir.h
+++ b/drivers/media/rc/img-ir/img-ir.h
@@ -2,6 +2,11 @@
  * ImgTec IR Decoder found in PowerDown Controller.
  *
  * Copyright 2010-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
  */
 
 #ifndef _IMG_IR_H_
-- 
1.8.3.2

