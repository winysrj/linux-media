Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41290 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756832AbeEJL1w (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 May 2018 07:27:52 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] media: update/fix my e-mail on some places
Date: Thu, 10 May 2018 07:27:46 -0400
Message-Id: <901b9dd5e31e8c58e30bf81ea4ab12641fb3ea76.1525951655.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two places pointing to an unexisting "m.chehab@kernel.org"
email. I never had such email, so, I'm unsure how it ends there.
Anyway, it is plain wrong.

While here, use my canonical e-mail on a bunch of places that
are pointing to another e-mail. The idea is that, from now on,
all places will be pointing to the same SMTP server.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/ABI/testing/sysfs-class-rc         | 16 ++++++++--------
 Documentation/ABI/testing/sysfs-class-rc-nuvoton |  2 +-
 Documentation/ABI/testing/sysfs-devices-edac     | 14 +++++++-------
 Documentation/media/uapi/dvb/dvbapi.rst          |  2 +-
 Documentation/media/uapi/v4l/v4l2.rst            |  2 +-
 drivers/media/dvb-frontends/as102_fe.h           |  2 +-
 drivers/media/usb/em28xx/em28xx-v4l.h            |  2 +-
 7 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-rc b/Documentation/ABI/testing/sysfs-class-rc
index 8be1fd3760e0..6c0d6c8cb911 100644
--- a/Documentation/ABI/testing/sysfs-class-rc
+++ b/Documentation/ABI/testing/sysfs-class-rc
@@ -1,7 +1,7 @@
 What:		/sys/class/rc/
 Date:		Apr 2010
 KernelVersion:	2.6.35
-Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 Description:
 		The rc/ class sub-directory belongs to the Remote Controller
 		core and provides a sysfs interface for configuring infrared
@@ -10,7 +10,7 @@ Description:
 What:		/sys/class/rc/rcN/
 Date:		Apr 2010
 KernelVersion:	2.6.35
-Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 Description:
 		A /sys/class/rc/rcN directory is created for each remote
 		control receiver device where N is the number of the receiver.
@@ -18,7 +18,7 @@ Description:
 What:		/sys/class/rc/rcN/protocols
 Date:		Jun 2010
 KernelVersion:	2.6.36
-Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 Description:
 		Reading this file returns a list of available protocols,
 		something like:
@@ -36,7 +36,7 @@ Description:
 What:		/sys/class/rc/rcN/filter
 Date:		Jan 2014
 KernelVersion:	3.15
-Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 Description:
 		Sets the scancode filter expected value.
 		Use in combination with /sys/class/rc/rcN/filter_mask to set the
@@ -49,7 +49,7 @@ Description:
 What:		/sys/class/rc/rcN/filter_mask
 Date:		Jan 2014
 KernelVersion:	3.15
-Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 Description:
 		Sets the scancode filter mask of bits to compare.
 		Use in combination with /sys/class/rc/rcN/filter to set the bits
@@ -64,7 +64,7 @@ Description:
 What:		/sys/class/rc/rcN/wakeup_protocols
 Date:		Feb 2017
 KernelVersion:	4.11
-Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 Description:
 		Reading this file returns a list of available protocols to use
 		for the wakeup filter, something like:
@@ -83,7 +83,7 @@ Description:
 What:		/sys/class/rc/rcN/wakeup_filter
 Date:		Jan 2014
 KernelVersion:	3.15
-Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 Description:
 		Sets the scancode wakeup filter expected value.
 		Use in combination with /sys/class/rc/rcN/wakeup_filter_mask to
@@ -98,7 +98,7 @@ Description:
 What:		/sys/class/rc/rcN/wakeup_filter_mask
 Date:		Jan 2014
 KernelVersion:	3.15
-Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 Description:
 		Sets the scancode wakeup filter mask of bits to compare.
 		Use in combination with /sys/class/rc/rcN/wakeup_filter to set
diff --git a/Documentation/ABI/testing/sysfs-class-rc-nuvoton b/Documentation/ABI/testing/sysfs-class-rc-nuvoton
index 905bcdeedef2..d3abe45f8690 100644
--- a/Documentation/ABI/testing/sysfs-class-rc-nuvoton
+++ b/Documentation/ABI/testing/sysfs-class-rc-nuvoton
@@ -1,7 +1,7 @@
 What:		/sys/class/rc/rcN/wakeup_data
 Date:		Mar 2016
 KernelVersion:	4.6
-Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 Description:
 		Reading this file returns the stored CIR wakeup sequence.
 		It starts with a pulse, followed by a space, pulse etc.
diff --git a/Documentation/ABI/testing/sysfs-devices-edac b/Documentation/ABI/testing/sysfs-devices-edac
index 46ff929fd52a..256a9e990c0b 100644
--- a/Documentation/ABI/testing/sysfs-devices-edac
+++ b/Documentation/ABI/testing/sysfs-devices-edac
@@ -77,7 +77,7 @@ Description:	Read/Write attribute file that controls memory scrubbing.
 
 What:		/sys/devices/system/edac/mc/mc*/max_location
 Date:		April 2012
-Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 		linux-edac@vger.kernel.org
 Description:	This attribute file displays the information about the last
 		available memory slot in this memory controller. It is used by
@@ -85,7 +85,7 @@ Description:	This attribute file displays the information about the last
 
 What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/size
 Date:		April 2012
-Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 		linux-edac@vger.kernel.org
 Description:	This attribute file will display the size of dimm or rank.
 		For dimm*/size, this is the size, in MB of the DIMM memory
@@ -96,14 +96,14 @@ Description:	This attribute file will display the size of dimm or rank.
 
 What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/dimm_dev_type
 Date:		April 2012
-Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 		linux-edac@vger.kernel.org
 Description:	This attribute file will display what type of DRAM device is
 		being utilized on this DIMM (x1, x2, x4, x8, ...).
 
 What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/dimm_edac_mode
 Date:		April 2012
-Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 		linux-edac@vger.kernel.org
 Description:	This attribute file will display what type of Error detection
 		and correction is being utilized. For example: S4ECD4ED would
@@ -111,7 +111,7 @@ Description:	This attribute file will display what type of Error detection
 
 What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/dimm_label
 Date:		April 2012
-Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 		linux-edac@vger.kernel.org
 Description:	This control file allows this DIMM to have a label assigned
 		to it. With this label in the module, when errors occur
@@ -126,14 +126,14 @@ Description:	This control file allows this DIMM to have a label assigned
 
 What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/dimm_location
 Date:		April 2012
-Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 		linux-edac@vger.kernel.org
 Description:	This attribute file will display the location (csrow/channel,
 		branch/channel/slot or channel/slot) of the dimm or rank.
 
 What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/dimm_mem_type
 Date:		April 2012
-Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 		linux-edac@vger.kernel.org
 Description:	This attribute file will display what type of memory is
 		currently on this csrow. Normally, either buffered or
diff --git a/Documentation/media/uapi/dvb/dvbapi.rst b/Documentation/media/uapi/dvb/dvbapi.rst
index 18c86b3a3af1..89ddca38626f 100644
--- a/Documentation/media/uapi/dvb/dvbapi.rst
+++ b/Documentation/media/uapi/dvb/dvbapi.rst
@@ -62,7 +62,7 @@ Authors:
 
  - Original author of the Digital TV API documentation.
 
-- Carvalho Chehab, Mauro <m.chehab@kernel.org>
+- Carvalho Chehab, Mauro <mchehab+samsung@kernel.org>
 
  - Ported document to Docbook XML, addition of DVBv5 API, documentation gaps fix.
 
diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
index 2128717299b3..b89e5621ae69 100644
--- a/Documentation/media/uapi/v4l/v4l2.rst
+++ b/Documentation/media/uapi/v4l/v4l2.rst
@@ -45,7 +45,7 @@ Authors, in alphabetical order:
 
   - Subdev selections API.
 
-- Carvalho Chehab, Mauro <m.chehab@kernel.org>
+- Carvalho Chehab, Mauro <mchehab+samsung@kernel.org>
 
   - Documented libv4l, designed and added v4l2grab example, Remote Controller chapter.
 
diff --git a/drivers/media/dvb-frontends/as102_fe.h b/drivers/media/dvb-frontends/as102_fe.h
index a7c91430ca3d..98d33d5ce872 100644
--- a/drivers/media/dvb-frontends/as102_fe.h
+++ b/drivers/media/dvb-frontends/as102_fe.h
@@ -1,6 +1,6 @@
 /*
  * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2014 Mauro Carvalho Chehab <m.chehab@samsung.com>
+ * Copyright (C) 2014 Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/usb/em28xx/em28xx-v4l.h b/drivers/media/usb/em28xx/em28xx-v4l.h
index 1788dbf9024a..6216cdd182f3 100644
--- a/drivers/media/usb/em28xx/em28xx-v4l.h
+++ b/drivers/media/usb/em28xx/em28xx-v4l.h
@@ -3,7 +3,7 @@
  * em28xx-video.c - driver for Empia EM2800/EM2820/2840 USB
  *		    video capture devices
  *
- * Copyright (C) 2013-2014 Mauro Carvalho Chehab <m.chehab@samsung.com>
+ * Copyright (C) 2013-2014 Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
-- 
2.17.0
