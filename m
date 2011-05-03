Return-path: <mchehab@pedra>
Received: from connie.slackware.com ([64.57.102.36]:51844 "EHLO
	connie.slackware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab1ECElN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 00:41:13 -0400
From: Robby Workman <rworkman@slackware.com>
Message-Id: <201105030416.p434GQdV026556@connie.slackware.com>
Date: Mon, 02 May 2011 21:16:25 -0700
To: linux-media@vger.kernel.org
Cc: <hdegoede@redhat.com>, Goede@connie.slackware.com,
	De@connie.slackware.com, Hans@connie.slackware.com,
	<volkerdi@slackware.com>, Volkerding@connie.slackware.com,
	Patrick@connie.slackware.com, <obi@linuxtv.org>,
	Oberritter@connie.slackware.com, Andreas@connie.slackware.com,
	<mchehab@redhat.com>, Chehab@connie.slackware.com,
	Carvalho@connie.slackware.com, Mauro@connie.slackware.com
Subject: [PATCH 1/2] Install udev rules to /lib/udev/ instead of /etc/udev
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>From d9ad48f6d4e8358d7f5490bd49fcdfcac64b988d Mon Sep 17 00:00:00 2001
From: Robby Workman <rworkman@slackware.com>
Date: Mon, 11 Apr 2011 20:41:28 -0500
Subject: [PATCH 1/2] Install udev rules to /lib/udev/ instead of /etc/udev

In moderately recent versions of udev, packages should install
rules files to /lib/udev/rules.d/ instead of /etc/udev/rules.d/,
as /etc/udev/rules.d/ is now for generated rules and overrides
of the packaged rules.
---
 utils/keytable/70-infrared.rules |    4 +---
 utils/keytable/Makefile          |    4 ++--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/utils/keytable/70-infrared.rules b/utils/keytable/70-infrared.rules
index 308a6d4..afffd95 100644
--- a/utils/keytable/70-infrared.rules
+++ b/utils/keytable/70-infrared.rules
@@ -1,6 +1,4 @@
 # Automatically load the proper keymaps after the Remote Controller device
-# creation.
-# Copy this file at /etc/udev/rules.d/70-infrared.rules in order to load keytables
-# during boot time. The keycode tables rules should be at /etc/rc_maps.cfg
+# creation.  The keycode tables rules should be at /etc/rc_maps.cfg
 
 ACTION=="add", SUBSYSTEM=="rc", RUN+="/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s $name"
diff --git a/utils/keytable/Makefile b/utils/keytable/Makefile
index aa020ef..29a6ac4 100644
--- a/utils/keytable/Makefile
+++ b/utils/keytable/Makefile
@@ -37,8 +37,8 @@ install: $(TARGETS)
 	install -m 644 -p rc_maps.cfg $(DESTDIR)/etc
 	install -m 755 -d $(DESTDIR)/etc/rc_keymaps
 	install -m 644 -p rc_keymaps/* $(DESTDIR)/etc/rc_keymaps
-	install -m 755 -d $(DESTDIR)/etc/udev/rules.d
-	install -m 644 -p 70-infrared.rules $(DESTDIR)/etc/udev/rules.d
+	install -m 755 -d $(DESTDIR)/lib/udev/rules.d
+	install -m 644 -p 70-infrared.rules $(DESTDIR)/lib/udev/rules.d
 	install -m 755 -d $(DESTDIR)$(PREFIX)/share/man/man1
 	install -m 644 -p ir-keytable.1 $(DESTDIR)$(PREFIX)/share/man/man1
 
-- 
1.7.4.4

