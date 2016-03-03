Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:57271 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756194AbcCCLYg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 06:24:36 -0500
Received: from [64.103.36.133] (proxy-ams-1.cisco.com [64.103.36.133])
	by tschai.lan (Postfix) with ESMTPSA id 7495D1809C5
	for <linux-media@vger.kernel.org>; Thu,  3 Mar 2016 12:24:30 +0100 (CET)
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] staging/media: add missing TODO files
Message-ID: <56D81EF8.8050306@xs4all.nl>
Date: Thu, 3 Mar 2016 12:24:40 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add TODO files for mx2/mx3/omap1 to explain the status of these drivers
and what needs to be done in order to keep them from being removed soon.

Also a small fix for the mx2/Kconfig that mistakingly mentioned a vb2
conversion. That's not needed for that driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/mx2/Kconfig |  9 ++++++---
 drivers/staging/media/mx2/TODO    | 10 ++++++++++
 drivers/staging/media/mx3/TODO    | 10 ++++++++++
 drivers/staging/media/omap1/TODO  |  8 ++++++++
 4 files changed, 34 insertions(+), 3 deletions(-)
 create mode 100644 drivers/staging/media/mx2/TODO
 create mode 100644 drivers/staging/media/mx3/TODO
 create mode 100644 drivers/staging/media/omap1/TODO

diff --git a/drivers/staging/media/mx2/Kconfig b/drivers/staging/media/mx2/Kconfig
index e080ab9..beaa885 100644
--- a/drivers/staging/media/mx2/Kconfig
+++ b/drivers/staging/media/mx2/Kconfig
@@ -7,6 +7,9 @@ config VIDEO_MX2
 	---help---
 	  This is a v4l2 driver for the i.MX27 Camera Sensor Interface

-	  This driver is deprecated and will be removed soon unless someone
-	  will start the work to convert this driver to the vb2 framework
-	  and remove the soc-camera dependency.
+	  This driver is deprecated: it should become a stand-alone driver
+	  instead of using the soc-camera framework.
+
+	  Unless someone is willing to take this on (unlikely with such
+	  ancient hardware) it is going to be removed from the kernel
+	  soon.
diff --git a/drivers/staging/media/mx2/TODO b/drivers/staging/media/mx2/TODO
new file mode 100644
index 0000000..bc68fa4
--- /dev/null
+++ b/drivers/staging/media/mx2/TODO
@@ -0,0 +1,10 @@
+This driver is deprecated: it should become a stand-alone driver instead of
+using the soc-camera framework.
+
+Unless someone is willing to take this on (unlikely with such ancient
+hardware) it is going to be removed from the kernel soon.
+
+Note that trivial patches will not be accepted anymore, only a full conversion.
+
+If you want to convert this driver, please contact the linux-media mailinglist
+(see http://linuxtv.org/lists.php).
diff --git a/drivers/staging/media/mx3/TODO b/drivers/staging/media/mx3/TODO
new file mode 100644
index 0000000..bc68fa4
--- /dev/null
+++ b/drivers/staging/media/mx3/TODO
@@ -0,0 +1,10 @@
+This driver is deprecated: it should become a stand-alone driver instead of
+using the soc-camera framework.
+
+Unless someone is willing to take this on (unlikely with such ancient
+hardware) it is going to be removed from the kernel soon.
+
+Note that trivial patches will not be accepted anymore, only a full conversion.
+
+If you want to convert this driver, please contact the linux-media mailinglist
+(see http://linuxtv.org/lists.php).
diff --git a/drivers/staging/media/omap1/TODO b/drivers/staging/media/omap1/TODO
new file mode 100644
index 0000000..1025f9f
--- /dev/null
+++ b/drivers/staging/media/omap1/TODO
@@ -0,0 +1,8 @@
+This driver is deprecated and will be removed soon unless someone will start
+the work to convert this driver to the vb2 framework and remove the
+soc-camera dependency.
+
+Note that trivial patches will not be accepted anymore, only a full conversion.
+
+If you want to convert this driver, please contact the linux-media mailinglist
+(see http://linuxtv.org/lists.php).
-- 
2.7.0

