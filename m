Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:52479 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755854Ab1EATGF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 May 2011 15:06:05 -0400
Received: from tobias-t61p.localnet (unknown [10.2.3.10])
	by mail.lorenz.priv (Postfix) with ESMTPS id D84D514490
	for <linux-media@vger.kernel.org>; Sun,  1 May 2011 21:06:01 +0200 (CEST)
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/6] documentation improvements
Date: Sun, 1 May 2011 21:02:48 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105012102.48112.tobias.lorenz@gmx.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch moves the history to the documentation and updated the copyrights.

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
---
 Documentation/video4linux/si470x.txt             |   94 
++++++++++++++++++++++-
 drivers/media/radio/si470x/radio-si470x-common.c |   91 
----------------------
 drivers/media/radio/si470x/radio-si470x-usb.c    |    8 -
 drivers/media/radio/si470x/radio-si470x.h        |    2 
 4 files changed, 93 insertions(+), 102 deletions(-)

diff --git a/Documentation/video4linux/si470x.txt 
b/Documentation/video4linux/si470x.txt
index 3a7823e..8fc6edb 100644
--- a/Documentation/video4linux/si470x.txt
+++ b/Documentation/video4linux/si470x.txt
@@ -1,6 +1,6 @@
 Driver for USB radios for the Silicon Labs Si470x FM Radio Receivers
 
-Copyright (c) 2009 Tobias Lorenz <tobias.lorenz@gmx.net>
+Copyright (c) 2011 Tobias Lorenz <tobias.lorenz@gmx.net>
 
 
 Information from Silicon Labs
@@ -86,6 +86,7 @@ mplayer -radio adevice=hw=1.0:arate=96000 \
 	-rawaudio rate=96000 \
 	radio://<frequency>/capture
 
+
 Module Parameters
 =================
 After loading the module, you still have access to some of them in the sysfs
@@ -111,9 +111,6 @@ currently under discussion.
 There is an USB interface for downloading/uploading new firmware images. 
Support
 for it can be implemented using the request_firmware interface.
 
-There is a RDS interrupt mode. The driver is already using the same interface
-for polling RDS information, but is currently not using the interrupt mode.
-
 There is a LED interface, which can be used to override the LED control
 programmed in the firmware. This can be made available using the LED support
 functions in the kernel.
@@ -122,3 +119,91 @@ functions in the kernel.
 Other useful information and links
 ==================================
 http://www.silabs.com/usbradio
+
+
+History
+=======
+2008-01-12	Tobias Lorenz <tobias.lorenz@gmx.net>
+		Version 1.0.0
+		- First working version
+2008-01-13	Tobias Lorenz <tobias.lorenz@gmx.net>
+		Version 1.0.1
+		- Improved error handling, every function now returns errno
+		- Improved multi user access (start/mute/stop)
+		- Channel doesn't get lost anymore after start/mute/stop
+		- RDS support added (polling mode via interrupt EP 1)
+		- marked default module parameters with *value*
+		- switched from bit structs to bit masks
+		- header file cleaned and integrated
+2008-01-14	Tobias Lorenz <tobias.lorenz@gmx.net>
+		Version 1.0.2
+		- hex values are now lower case
+		- commented USB ID for ADS/Tech moved on todo list
+		- blacklisted si470x in hid-quirks.c
+		- rds buffer handling functions integrated into *_work, *_read
+		- rds_command in si470x_poll exchanged against simple retval
+		- check for firmware version 15
+		- code order and prototypes still remain the same
+		- spacing and bottom of band codes remain the same
+2008-01-16	Tobias Lorenz <tobias.lorenz@gmx.net>
+		Version 1.0.3
+		- code reordered to avoid function prototypes
+		- switch/case defaults are now more user-friendly
+		- unified comment style
+		- applied all checkpatch.pl v1.12 suggestions
+		  except the warning about the too long lines with bit comments
+		- renamed FMRADIO to RADIO to cut line length (checkpatch.pl)
+2008-01-22	Tobias Lorenz <tobias.lorenz@gmx.net>
+		Version 1.0.4
+		- avoid poss. locking when doing copy_to_user which may sleep
+		- RDS is automatically activated on read now
+		- code cleaned of unnecessary rds_commands
+		- USB Vendor/Product ID for ADS/Tech FM Radio Receiver verified
+		  (thanks to Guillaume RAMOUSSE)
+2008-01-27	Tobias Lorenz <tobias.lorenz@gmx.net>
+		Version 1.0.5
+		- number of seek_retries changed to tune_timeout
+		- fixed problem with incomplete tune operations by own buffers
+		- optimization of variables and printf types
+		- improved error logging
+2008-01-31	Tobias Lorenz <tobias.lorenz@gmx.net>
+		Oliver Neukum <oliver@neukum.org>
+		Version 1.0.6
+		- fixed coverity checker warnings in *_usb_driver_disconnect
+		- probe()/open() race by correct ordering in probe()
+		- DMA coherency rules by separate allocation of all buffers
+		- use of endianness macros
+		- abuse of spinlock, replaced by mutex
+		- racy handling of timer in disconnect,
+		  replaced by delayed_work
+		- racy interruptible_sleep_on(),
+		  replaced with wait_event_interruptible()
+		- handle signals in read()
+2008-02-08	Tobias Lorenz <tobias.lorenz@gmx.net>
+		Oliver Neukum <oliver@neukum.org>
+		Version 1.0.7
+		- usb autosuspend support
+		- unplugging fixed
+2008-05-07	Tobias Lorenz <tobias.lorenz@gmx.net>
+		Version 1.0.8
+		- hardware frequency seek support
+		- afc indication
+		- more safety checks, let si470x_get_freq return errno
+		- vidioc behavior corrected according to v4l2 spec
+2008-10-20	Alexey Klimov <klimov.linux@gmail.com>
+		- add support for KWorld USB FM Radio FM700
+		- blacklisted KWorld radio in hid-core.c and hid-ids.h
+2008-12-03	Mark Lord <mlord@pobox.com>
+		- add support for DealExtreme USB Radio
+2009-01-31	Bob Ross <pigiron@gmx.com>
+		- correction of stereo detection/setting
+		- correction of signal strength indicator scaling
+2009-01-31	Rick Bronson <rick@efn.org>
+		Tobias Lorenz <tobias.lorenz@gmx.net>
+		- add LED status output
+		- get HW/SW version from scratchpad
+2009-06-16	Edouard Lafargue <edouard@lafargue.name>
+		Version 1.0.10
+		- add support for interrupt mode for RDS endpoint,
+		  instead of polling.
+		- Improves RDS reception significantly
diff --git a/drivers/media/radio/si470x/radio-si470x-common.c 
b/drivers/media/radio/si470x/radio-si470x-common.c
index 6698393..c62fd00 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -3,7 +3,7 @@
  *
  *  Driver for radios with Silicon Labs Si470x FM Radio Receivers
  *
- *  Copyright (c) 2009 Tobias Lorenz <tobias.lorenz@gmx.net>
+ *  Copyright (c) 2011 Tobias Lorenz <tobias.lorenz@gmx.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -21,95 +21,6 @@
  */
 
 
-/*
- * History:
- * 2008-01-12	Tobias Lorenz <tobias.lorenz@gmx.net>
- *		Version 1.0.0
- *		- First working version
- * 2008-01-13	Tobias Lorenz <tobias.lorenz@gmx.net>
- *		Version 1.0.1
- *		- Improved error handling, every function now returns errno
- *		- Improved multi user access (start/mute/stop)
- *		- Channel doesn't get lost anymore after start/mute/stop
- *		- RDS support added (polling mode via interrupt EP 1)
- *		- marked default module parameters with *value*
- *		- switched from bit structs to bit masks
- *		- header file cleaned and integrated
- * 2008-01-14	Tobias Lorenz <tobias.lorenz@gmx.net>
- * 		Version 1.0.2
- * 		- hex values are now lower case
- * 		- commented USB ID for ADS/Tech moved on todo list
- * 		- blacklisted si470x in hid-quirks.c
- * 		- rds buffer handling functions integrated into *_work, *_read
- * 		- rds_command in si470x_poll exchanged against simple retval
- * 		- check for firmware version 15
- * 		- code order and prototypes still remain the same
- * 		- spacing and bottom of band codes remain the same
- * 2008-01-16	Tobias Lorenz <tobias.lorenz@gmx.net>
- *		Version 1.0.3
- * 		- code reordered to avoid function prototypes
- *		- switch/case defaults are now more user-friendly
- *		- unified comment style
- *		- applied all checkpatch.pl v1.12 suggestions
- *		  except the warning about the too long lines with bit comments
- *		- renamed FMRADIO to RADIO to cut line length (checkpatch.pl)
- * 2008-01-22	Tobias Lorenz <tobias.lorenz@gmx.net>
- *		Version 1.0.4
- *		- avoid poss. locking when doing copy_to_user which may sleep
- *		- RDS is automatically activated on read now
- *		- code cleaned of unnecessary rds_commands
- *		- USB Vendor/Product ID for ADS/Tech FM Radio Receiver verified
- *		  (thanks to Guillaume RAMOUSSE)
- * 2008-01-27	Tobias Lorenz <tobias.lorenz@gmx.net>
- *		Version 1.0.5
- *		- number of seek_retries changed to tune_timeout
- *		- fixed problem with incomplete tune operations by own buffers
- *		- optimization of variables and printf types
- *		- improved error logging
- * 2008-01-31	Tobias Lorenz <tobias.lorenz@gmx.net>
- *		Oliver Neukum <oliver@neukum.org>
- *		Version 1.0.6
- *		- fixed coverity checker warnings in *_usb_driver_disconnect
- *		- probe()/open() race by correct ordering in probe()
- *		- DMA coherency rules by separate allocation of all buffers
- *		- use of endianness macros
- *		- abuse of spinlock, replaced by mutex
- *		- racy handling of timer in disconnect,
- *		  replaced by delayed_work
- *		- racy interruptible_sleep_on(),
- *		  replaced with wait_event_interruptible()
- *		- handle signals in read()
- * 2008-02-08	Tobias Lorenz <tobias.lorenz@gmx.net>
- *		Oliver Neukum <oliver@neukum.org>
- *		Version 1.0.7
- *		- usb autosuspend support
- *		- unplugging fixed
- * 2008-05-07	Tobias Lorenz <tobias.lorenz@gmx.net>
- *		Version 1.0.8
- *		- hardware frequency seek support
- *		- afc indication
- *		- more safety checks, let si470x_get_freq return errno
- *		- vidioc behavior corrected according to v4l2 spec
- * 2008-10-20	Alexey Klimov <klimov.linux@gmail.com>
- * 		- add support for KWorld USB FM Radio FM700
- * 		- blacklisted KWorld radio in hid-core.c and hid-ids.h
- * 2008-12-03	Mark Lord <mlord@pobox.com>
- *		- add support for DealExtreme USB Radio
- * 2009-01-31	Bob Ross <pigiron@gmx.com>
- *		- correction of stereo detection/setting
- *		- correction of signal strength indicator scaling
- * 2009-01-31	Rick Bronson <rick@efn.org>
- *		Tobias Lorenz <tobias.lorenz@gmx.net>
- *		- add LED status output
- *		- get HW/SW version from scratchpad
- * 2009-06-16   Edouard Lafargue <edouard@lafargue.name>
- *		Version 1.0.10
- *		- add support for interrupt mode for RDS endpoint,
- *                instead of polling.
- *                Improves RDS reception significantly
- */
-
-
 /* kernel includes */
 #include "radio-si470x.h"
 
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c 
b/drivers/media/radio/si470x/radio-si470x-usb.c
index 89ca290..12907f7 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -3,7 +3,7 @@
  *
  *  USB driver for radios with Silicon Labs Si470x FM Radio Receivers
  *
- *  Copyright (c) 2009 Tobias Lorenz <tobias.lorenz@gmx.net>
+ *  Copyright (c) 2011 Tobias Lorenz <tobias.lorenz@gmx.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -21,12 +21,6 @@
  */
 
 
-/*
- * ToDo:
- * - add firmware download/update support
- */
-
-
 /* driver definitions */
 #define DRIVER_AUTHOR "Tobias Lorenz <tobias.lorenz@gmx.net>"
 #define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 10)
diff --git a/drivers/media/radio/si470x/radio-si470x.h 
b/drivers/media/radio/si470x/radio-si470x.h
index b9914d7..7e1cc47 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -3,7 +3,7 @@
  *
  *  Driver for radios with Silicon Labs Si470x FM Radio Receivers
  *
- *  Copyright (c) 2009 Tobias Lorenz <tobias.lorenz@gmx.net>
+ *  Copyright (c) 2011 Tobias Lorenz <tobias.lorenz@gmx.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
-- 
1.7.4.1

