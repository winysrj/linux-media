Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([92.60.52.57]:55585 "EHLO shell.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbcFANEG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2016 09:04:06 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Federico Simoncelli <fsimonce@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Patrick Keshishian <pkeshish@gmail.com>,
	linux-media@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] [media] usbtv: clarify the licensing
Date: Wed,  1 Jun 2016 15:03:44 +0200
Message-Id: <1464786224-15612-1-git-send-email-lkundrak@v3.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OpenBSD would like to reuse some code but consider the licensing not
clear enough. Let's clarify it a bit so that it suits their conventions:

1.) Keep the "extra text" away from the copyright statement and the
rights grant.

2.) Add the warranty disclaimer -- it should not be legally required,
nevertheless the clause 1. of the rights grant refest to it.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Acked-by: Federico Simoncelli <fsimonce@redhat.com>
---
 drivers/media/usb/usbtv/usbtv-audio.c | 28 ++++++++++++++++++------
 drivers/media/usb/usbtv/usbtv-core.c  | 40 +++++++++++++++++++++++------------
 drivers/media/usb/usbtv/usbtv-video.c | 40 +++++++++++++++++++++++------------
 drivers/media/usb/usbtv/usbtv.h       | 22 +++++++++++++++----
 4 files changed, 93 insertions(+), 37 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-audio.c b/drivers/media/usb/usbtv/usbtv-audio.c
index 78c12d2..d4b4db3 100644
--- a/drivers/media/usb/usbtv/usbtv-audio.c
+++ b/drivers/media/usb/usbtv/usbtv-audio.c
@@ -1,13 +1,6 @@
 /*
- * Fushicai USBTV007 Audio-Video Grabber Driver
- *
- * Product web site:
- * http://www.fushicai.com/products_detail/&productId=d05449ee-b690-42f9-a661-aa7353894bed.html
- *
  * Copyright (c) 2013 Federico Simoncelli
  * All rights reserved.
- * No physical hardware was harmed running Windows during the
- * reverse-engineering activity
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -20,6 +13,27 @@
  *
  * Alternatively, this software may be distributed under the terms of the
  * GNU General Public License ("GPL").
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+/*
+ * Fushicai USBTV007 Audio-Video Grabber Driver
+ *
+ * Product web site:
+ * http://www.fushicai.com/products_detail/&productId=d05449ee-b690-42f9-a661-aa7353894bed.html
+ *
+ * No physical hardware was harmed running Windows during the
+ * reverse-engineering activity
  */
 
 #include <sound/core.h>
diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index 29428be..dc76fd4 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -1,19 +1,6 @@
 /*
- * Fushicai USBTV007 Audio-Video Grabber Driver
- *
- * Product web site:
- * http://www.fushicai.com/products_detail/&productId=d05449ee-b690-42f9-a661-aa7353894bed.html
- *
- * Following LWN articles were very useful in construction of this driver:
- * Video4Linux2 API series: http://lwn.net/Articles/203924/
- * videobuf2 API explanation: http://lwn.net/Articles/447435/
- * Thanks go to Jonathan Corbet for providing this quality documentation.
- * He is awesome.
- *
  * Copyright (c) 2013 Lubomir Rintel
  * All rights reserved.
- * No physical hardware was harmed running Windows during the
- * reverse-engineering activity
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -26,6 +13,33 @@
  *
  * Alternatively, this software may be distributed under the terms of the
  * GNU General Public License ("GPL").
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+/*
+ * Fushicai USBTV007 Audio-Video Grabber Driver
+ *
+ * Product web site:
+ * http://www.fushicai.com/products_detail/&productId=d05449ee-b690-42f9-a661-aa7353894bed.html
+ *
+ * Following LWN articles were very useful in construction of this driver:
+ * Video4Linux2 API series: http://lwn.net/Articles/203924/
+ * videobuf2 API explanation: http://lwn.net/Articles/447435/
+ * Thanks go to Jonathan Corbet for providing this quality documentation.
+ * He is awesome.
+ *
+ * No physical hardware was harmed running Windows during the
+ * reverse-engineering activity
  */
 
 #include "usbtv.h"
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index f6cfad4..d94d5c5 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -1,19 +1,6 @@
 /*
- * Fushicai USBTV007 Audio-Video Grabber Driver
- *
- * Product web site:
- * http://www.fushicai.com/products_detail/&productId=d05449ee-b690-42f9-a661-aa7353894bed.html
- *
- * Following LWN articles were very useful in construction of this driver:
- * Video4Linux2 API series: http://lwn.net/Articles/203924/
- * videobuf2 API explanation: http://lwn.net/Articles/447435/
- * Thanks go to Jonathan Corbet for providing this quality documentation.
- * He is awesome.
- *
  * Copyright (c) 2013 Lubomir Rintel
  * All rights reserved.
- * No physical hardware was harmed running Windows during the
- * reverse-engineering activity
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -26,6 +13,33 @@
  *
  * Alternatively, this software may be distributed under the terms of the
  * GNU General Public License ("GPL").
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+/*
+ * Fushicai USBTV007 Audio-Video Grabber Driver
+ *
+ * Product web site:
+ * http://www.fushicai.com/products_detail/&productId=d05449ee-b690-42f9-a661-aa7353894bed.html
+ *
+ * Following LWN articles were very useful in construction of this driver:
+ * Video4Linux2 API series: http://lwn.net/Articles/203924/
+ * videobuf2 API explanation: http://lwn.net/Articles/447435/
+ * Thanks go to Jonathan Corbet for providing this quality documentation.
+ * He is awesome.
+ *
+ * No physical hardware was harmed running Windows during the
+ * reverse-engineering activity
  */
 
 #include <media/v4l2-ioctl.h>
diff --git a/drivers/media/usb/usbtv/usbtv.h b/drivers/media/usb/usbtv/usbtv.h
index 161b38d..011f9fd 100644
--- a/drivers/media/usb/usbtv/usbtv.h
+++ b/drivers/media/usb/usbtv/usbtv.h
@@ -1,10 +1,6 @@
 /*
- * Fushicai USBTV007 Audio-Video Grabber Driver
- *
  * Copyright (c) 2013 Lubomir Rintel
  * All rights reserved.
- * No physical hardware was harmed running Windows during the
- * reverse-engineering activity
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -17,6 +13,24 @@
  *
  * Alternatively, this software may be distributed under the terms of the
  * GNU General Public License ("GPL").
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+/*
+ * Fushicai USBTV007 Audio-Video Grabber Driver
+ *
+ * No physical hardware was harmed running Windows during the
+ * reverse-engineering activity
  */
 
 #include <linux/module.h>
-- 
2.5.5

