Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab2HEXLI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Aug 2012 19:11:08 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q75NB8Fj013080
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 5 Aug 2012 19:11:08 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] move dvb-usb-ids.h to dvb-core
Date: Sun,  5 Aug 2012 20:11:03 -0300
Message-Id: <1344208263-7305-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344207197-26468-1-git-send-email-mchehab@redhat.com>
References: <1344207197-26468-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While this header were meant to be used just by dvb-usb driver, it
is now being used also by dvb-usb-v2 and cx231xx. So, move it to a
better place.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---

This fixes dvb-usb-v2 build at the out-of-tree media_tree.git.

V.2: Send it with git -M, to better show the changes at dvb-usb-ids.h
(E. g., no changes there ;) )

 drivers/media/dvb/{dvb-usb => dvb-core}/dvb-usb-ids.h | 0
 drivers/media/dvb/dvb-usb-v2/dvb_usb.h                | 2 +-
 drivers/media/dvb/dvb-usb/Makefile                    | 1 -
 drivers/media/video/cx231xx/Makefile                  | 1 -
 4 files changed, 1 insertion(+), 3 deletions(-)
 rename drivers/media/dvb/{dvb-usb => dvb-core}/dvb-usb-ids.h (100%)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-core/dvb-usb-ids.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dvb-usb-ids.h
rename to drivers/media/dvb/dvb-core/dvb-usb-ids.h
diff --git a/drivers/media/dvb/dvb-usb-v2/dvb_usb.h b/drivers/media/dvb/dvb-usb-v2/dvb_usb.h
index 4db591b..773817b 100644
--- a/drivers/media/dvb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/dvb/dvb-usb-v2/dvb_usb.h
@@ -30,7 +30,7 @@
 #include "dvb_demux.h"
 #include "dvb_net.h"
 #include "dmxdev.h"
-#include "../dvb-usb/dvb-usb-ids.h"
+#include "dvb-usb-ids.h"
 
 /*
  * device file: /dev/dvb/adapter[0-1]/frontend[0-2]
diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
index 29fa0f0..4b70599 100644
--- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -92,4 +92,3 @@ ccflags-y += -I$(srctree)/drivers/media/dvb/frontends/
 # due to tuner-xc3028
 ccflags-y += -I$(srctree)/drivers/media/common/tuners
 ccflags-y += -I$(srctree)/drivers/media/dvb/ttpci
-
diff --git a/drivers/media/video/cx231xx/Makefile b/drivers/media/video/cx231xx/Makefile
index b334897..cb06b02 100644
--- a/drivers/media/video/cx231xx/Makefile
+++ b/drivers/media/video/cx231xx/Makefile
@@ -12,5 +12,4 @@ ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
 ccflags-y += -Idrivers/media/dvb/dvb-core
 ccflags-y += -Idrivers/media/dvb/frontends
-ccflags-y += -Idrivers/media/dvb/dvb-usb
 
-- 
1.7.11.2

