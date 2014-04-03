Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40339 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909AbaDCXe3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:34:29 -0400
Subject: [PATCH 38/49] rc-core: rename ir-raw.c
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:34:28 +0200
Message-ID: <20140403233428.27099.43511.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move drivers/media/rc/ir-raw.c to drivers/media/rc/rc-ir-raw.c in
preparation for the next patch.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/Makefile    |    2 +-
 drivers/media/rc/rc-ir-raw.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/media/rc/{ir-raw.c => rc-ir-raw.c} (99%)

diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index de08ee6..661f449 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -1,4 +1,4 @@
-rc-core-objs	:= rc-main.o rc-keytable.o ir-raw.o
+rc-core-objs	:= rc-main.o rc-keytable.o rc-ir-raw.o
 
 obj-y += keymaps/
 
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/rc-ir-raw.c
similarity index 99%
rename from drivers/media/rc/ir-raw.c
rename to drivers/media/rc/rc-ir-raw.c
index aa2503d..5ed8007 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -1,4 +1,4 @@
-/* ir-raw.c - handle IR pulse/space events
+/* rc-ir-raw.c - handle IR pulse/space events
  *
  * Copyright (C) 2010 by Mauro Carvalho Chehab
  *

