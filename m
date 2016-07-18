Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59563 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbcGRSat (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 14:30:49 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 17/18] [media] doc-rst: fix media kAPI documentation
Date: Mon, 18 Jul 2016 15:30:39 -0300
Message-Id: <cf022874b687f73fa5356edf99f9869523fbb300.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I ended by adding twice each media header, because I saw some
missing stuff at the documents. It seems it was my mistake,
as everything seems to be there.

So, remove those extra stuff, to avoid duplicating the
documentation of the functions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/dtv-core.rst  |  4 ----
 Documentation/media/kapi/mc-core.rst   |  8 --------
 Documentation/media/kapi/rc-core.rst   |  3 +--
 Documentation/media/kapi/v4l2-core.rst | 21 ---------------------
 4 files changed, 1 insertion(+), 35 deletions(-)

diff --git a/Documentation/media/kapi/dtv-core.rst b/Documentation/media/kapi/dtv-core.rst
index 3291190c1865..11da77e141ed 100644
--- a/Documentation/media/kapi/dtv-core.rst
+++ b/Documentation/media/kapi/dtv-core.rst
@@ -130,7 +130,3 @@ Digital TV Conditional Access kABI
 ----------------------------------
 
 .. kernel-doc:: drivers/media/dvb-core/dvb_ca_en50221.h
-
-
-.. kernel-doc:: drivers/media/dvb-core/dvb_ca_en50221.h
-   :export: drivers/media/dvb-core/dvb_ca_en50221.c
diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
index 2ab541ba6e88..c1fe0d69207d 100644
--- a/Documentation/media/kapi/mc-core.rst
+++ b/Documentation/media/kapi/mc-core.rst
@@ -261,11 +261,3 @@ in the end provide a way to use driver-specific callbacks.
 .. kernel-doc:: include/media/media-devnode.h
 
 .. kernel-doc:: include/media/media-entity.h
-
-
-
-.. kernel-doc:: include/media/media-device.h
-   :export: drivers/media/media-device.c
-
-.. kernel-doc:: include/media/media-entity.h
-   :export: drivers/media/media-entity.c
diff --git a/Documentation/media/kapi/rc-core.rst b/Documentation/media/kapi/rc-core.rst
index 9c244ac9ce92..a45895886257 100644
--- a/Documentation/media/kapi/rc-core.rst
+++ b/Documentation/media/kapi/rc-core.rst
@@ -6,8 +6,7 @@ Remote Controller core
 
 .. kernel-doc:: include/media/rc-core.h
 
-.. kernel-doc:: include/media/rc-core.h include/media/rc-map.h
-   :export: drivers/media/rc/rc-main.c drivers/media/rc/rc-raw.c
+.. kernel-doc:: include/media/rc-map.h
 
 LIRC
 ~~~~
diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
index 4e2aa721d9c8..a1b73e8d6795 100644
--- a/Documentation/media/kapi/v4l2-core.rst
+++ b/Documentation/media/kapi/v4l2-core.rst
@@ -34,24 +34,3 @@ Video2Linux devices
 .. kernel-doc:: include/media/videobuf2-v4l2.h
 
 .. kernel-doc:: include/media/videobuf2-memops.h
-
-
-
-
-.. kernel-doc:: include/media/tveeprom.h
-   :export: drivers/media/common/tveeprom.c
-
-.. kernel-doc:: include/media/v4l2-ctrls.h
-   :export: drivers/media/v4l2-core/v4l2-ctrls.c
-
-.. kernel-doc:: include/media/v4l2-dv-timings.h
-   :export: drivers/media/v4l2-core/v4l2-dv-timings.c
-
-.. kernel-doc:: include/media/v4l2-flash-led-class.h
-   :export: drivers/media/v4l2-core/v4l2-flash-led-class.c
-
-.. kernel-doc:: include/media/v4l2-mc.h
-   :export: drivers/media/v4l2-core/v4l2-mc.c
-
-.. kernel-doc:: include/media/videobuf2-core.h
-   :export: drivers/media/v4l2-core/videobuf2-core.c
-- 
2.7.4


