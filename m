Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:48366 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbaAQOAE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 09:00:04 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
	Rob Landley <rob@landley.net>, <linux-doc@vger.kernel.org>
Subject: [PATCH v2 01/15] media: rc: document rc class sysfs API
Date: Fri, 17 Jan 2014 13:58:46 +0000
Message-ID: <1389967140-20704-2-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
References: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Briefly document /sys/class/rc/ API for remote controller devices in
Documentation/ABI/teting.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Cc: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org
---
v2:
- New patch.
---
 Documentation/ABI/testing/sysfs-class-rc | 34 ++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-rc

diff --git a/Documentation/ABI/testing/sysfs-class-rc b/Documentation/ABI/testing/sysfs-class-rc
new file mode 100644
index 0000000..52bc057
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-rc
@@ -0,0 +1,34 @@
+What:		/sys/class/rc/
+Date:		Apr 2010
+KernelVersion:	2.6.35
+Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Description:
+		The rc/ class sub-directory belongs to the Remote Controller
+		core and provides a sysfs interface for configuring infrared
+		remote controller receivers.
+
+What:		/sys/class/rc/rcN/
+Date:		Apr 2010
+KernelVersion:	2.6.35
+Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Description:
+		A /sys/class/rc/rcN directory is created for each remote
+		control receiver device where N is the number of the receiver.
+
+What:		/sys/class/rc/rcN/protocols
+Date:		Jun 2010
+KernelVersion:	2.6.36
+Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Description:
+		Reading this file returns a list of available protocols,
+		something like:
+		    "rc5 [rc6] nec jvc [sony]"
+		Enabled protocols are shown in [] brackets.
+		Writing "+proto" will add a protocol to the list of enabled
+		protocols.
+		Writing "-proto" will remove a protocol from the list of enabled
+		protocols.
+		Writing "proto" will enable only "proto".
+		Writing "none" will disable all protocols.
+		Write fails with EINVAL if an invalid protocol combination or
+		unknown protocol name is used.
-- 
1.8.3.2


