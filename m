Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334Ab2FNUiw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 16:38:52 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5EKcqhC004189
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 16:38:52 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 04/10] [media] firewire: move it one level up
Date: Thu, 14 Jun 2012 17:35:55 -0300
Message-Id: <1339706161-22713-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
References: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move firewire to one level up, as the dvb subdirectory will be
removed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig                          |    6 +++++-
 drivers/media/Makefile                         |    1 +
 drivers/media/dvb/Kconfig                      |    4 ----
 drivers/media/dvb/Makefile                     |    2 --
 drivers/media/{dvb => }/firewire/Kconfig       |    0
 drivers/media/{dvb => }/firewire/Makefile      |    0
 drivers/media/{dvb => }/firewire/firedtv-avc.c |    0
 drivers/media/{dvb => }/firewire/firedtv-ci.c  |    0
 drivers/media/{dvb => }/firewire/firedtv-dvb.c |    0
 drivers/media/{dvb => }/firewire/firedtv-fe.c  |    0
 drivers/media/{dvb => }/firewire/firedtv-fw.c  |    0
 drivers/media/{dvb => }/firewire/firedtv-rc.c  |    0
 drivers/media/{dvb => }/firewire/firedtv.h     |    0
 13 files changed, 6 insertions(+), 7 deletions(-)
 rename drivers/media/{dvb => }/firewire/Kconfig (100%)
 rename drivers/media/{dvb => }/firewire/Makefile (100%)
 rename drivers/media/{dvb => }/firewire/firedtv-avc.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv-ci.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv-dvb.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv-fe.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv-fw.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv-rc.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv.h (100%)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 318c2bf..788be30 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -166,8 +166,12 @@ source "drivers/media/radio/Kconfig"
 source "drivers/media/dvb-core/Kconfig"
 source "drivers/media/dvb/Kconfig"
 
+comment "Supported FireWire (IEEE 1394) Adapters"
+	depends on DVB_CORE && FIREWIRE
+source "drivers/media/firewire/Kconfig"
+
 comment "Supported DVB Frontends"
-        depends on DVB_CORE
+	depends on DVB_CORE
 source "drivers/media/dvb-frontends/Kconfig"
 
 endif # MEDIA_SUPPORT
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index f95b9e3..37e448c 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -12,3 +12,4 @@ obj-y += v4l2-core/ common/ rc/ video/
 
 obj-$(CONFIG_VIDEO_DEV) += radio/
 obj-$(CONFIG_DVB_CORE)  += dvb-core/ dvb/ dvb-frontends/
+obj-$(CONFIG_DVB_FIREDTV) += firewire/
diff --git a/drivers/media/dvb/Kconfig b/drivers/media/dvb/Kconfig
index 874ff53..71bb941 100644
--- a/drivers/media/dvb/Kconfig
+++ b/drivers/media/dvb/Kconfig
@@ -38,10 +38,6 @@ comment "Supported SDMC DM1105 Adapters"
 	depends on DVB_CORE && PCI && I2C
 source "drivers/media/dvb/dm1105/Kconfig"
 
-comment "Supported FireWire (IEEE 1394) Adapters"
-	depends on DVB_CORE && FIREWIRE
-source "drivers/media/dvb/firewire/Kconfig"
-
 comment "Supported Earthsoft PT1 Adapters"
 	depends on DVB_CORE && PCI && I2C
 source "drivers/media/dvb/pt1/Kconfig"
diff --git a/drivers/media/dvb/Makefile b/drivers/media/dvb/Makefile
index 352adaa..dd2864b 100644
--- a/drivers/media/dvb/Makefile
+++ b/drivers/media/dvb/Makefile
@@ -15,5 +15,3 @@ obj-y        :=	ttpci/		\
 		mantis/		\
 		ngene/		\
 		ddbridge/
-
-obj-$(CONFIG_DVB_FIREDTV)	+= firewire/
diff --git a/drivers/media/dvb/firewire/Kconfig b/drivers/media/firewire/Kconfig
similarity index 100%
rename from drivers/media/dvb/firewire/Kconfig
rename to drivers/media/firewire/Kconfig
diff --git a/drivers/media/dvb/firewire/Makefile b/drivers/media/firewire/Makefile
similarity index 100%
rename from drivers/media/dvb/firewire/Makefile
rename to drivers/media/firewire/Makefile
diff --git a/drivers/media/dvb/firewire/firedtv-avc.c b/drivers/media/firewire/firedtv-avc.c
similarity index 100%
rename from drivers/media/dvb/firewire/firedtv-avc.c
rename to drivers/media/firewire/firedtv-avc.c
diff --git a/drivers/media/dvb/firewire/firedtv-ci.c b/drivers/media/firewire/firedtv-ci.c
similarity index 100%
rename from drivers/media/dvb/firewire/firedtv-ci.c
rename to drivers/media/firewire/firedtv-ci.c
diff --git a/drivers/media/dvb/firewire/firedtv-dvb.c b/drivers/media/firewire/firedtv-dvb.c
similarity index 100%
rename from drivers/media/dvb/firewire/firedtv-dvb.c
rename to drivers/media/firewire/firedtv-dvb.c
diff --git a/drivers/media/dvb/firewire/firedtv-fe.c b/drivers/media/firewire/firedtv-fe.c
similarity index 100%
rename from drivers/media/dvb/firewire/firedtv-fe.c
rename to drivers/media/firewire/firedtv-fe.c
diff --git a/drivers/media/dvb/firewire/firedtv-fw.c b/drivers/media/firewire/firedtv-fw.c
similarity index 100%
rename from drivers/media/dvb/firewire/firedtv-fw.c
rename to drivers/media/firewire/firedtv-fw.c
diff --git a/drivers/media/dvb/firewire/firedtv-rc.c b/drivers/media/firewire/firedtv-rc.c
similarity index 100%
rename from drivers/media/dvb/firewire/firedtv-rc.c
rename to drivers/media/firewire/firedtv-rc.c
diff --git a/drivers/media/dvb/firewire/firedtv.h b/drivers/media/firewire/firedtv.h
similarity index 100%
rename from drivers/media/dvb/firewire/firedtv.h
rename to drivers/media/firewire/firedtv.h
-- 
1.7.10.2

