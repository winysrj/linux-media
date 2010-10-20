Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38043 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab0JTJgI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 05:36:08 -0400
Received: by bwz10 with SMTP id 10so1123351bwz.19
        for <linux-media@vger.kernel.org>; Wed, 20 Oct 2010 02:36:07 -0700 (PDT)
From: Ruslan Pisarev <ruslanpisarev@gmail.com>
To: linux-media@vger.kernel.org
Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH 5/6] Staging: tm6000: fix comments coding style issue in group of files
Date: Wed, 20 Oct 2010 12:35:54 +0300
Message-Id: <1287567354-18908-1-git-send-email-ruslan@rpisarev.org.ua>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a patch to the
tm6000-cards.c
tm6000-core.c
tm6000-dvb.c
tm6000-i2c.c
tm6000-input.c
tm6000-regs.h
tm6000-stds.c
tm6000-usb-isoc.h
tm6000.h
files that fixed up a comments warnings found by the checkpatch.pl tools.

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/tm6000/tm6000-cards.c    |   32 ++++++++++++------------
 drivers/staging/tm6000/tm6000-core.c     |   38 +++++++++++++++---------------
 drivers/staging/tm6000/tm6000-dvb.c      |   32 ++++++++++++------------
 drivers/staging/tm6000/tm6000-i2c.c      |   38 +++++++++++++++---------------
 drivers/staging/tm6000/tm6000-input.c    |   32 ++++++++++++------------
 drivers/staging/tm6000/tm6000-regs.h     |   32 ++++++++++++------------
 drivers/staging/tm6000/tm6000-stds.c     |   32 ++++++++++++------------
 drivers/staging/tm6000/tm6000-usb-isoc.h |   32 ++++++++++++------------
 drivers/staging/tm6000/tm6000.h          |   38 +++++++++++++++---------------
 9 files changed, 153 insertions(+), 153 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 9d091c3..3064d0c 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -1,20 +1,20 @@
 /*
-   tm6000-cards.c - driver for TM5600/TM6000/TM6010 USB video capture devices
-
-   Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation version 2
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *  tm6000-cards.c - driver for TM5600/TM6000/TM6010 USB video capture devices
+ *
+ *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/init.h>
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 9c0bf84..e2fbb6a 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -1,23 +1,23 @@
 /*
-   tm6000-core.c - driver for TM5600/TM6000/TM6010 USB video capture devices
-
-   Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
-
-   Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
-       - DVB-T support
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation version 2
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *  tm6000-core.c - driver for TM5600/TM6000/TM6010 USB video capture devices
+ *
+ *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+ *
+ *  Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
+ *      - DVB-T support
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/module.h>
diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index f501edc..ff04c89 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -1,20 +1,20 @@
 /*
-   tm6000-dvb.c - dvb-t support for TM5600/TM6000/TM6010 USB video capture devices
-
-   Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation version 2
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *  tm6000-dvb.c - dvb-t support for TM5600/TM6000/TM6010 USB video capture devices
+ *
+ *  Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index a08d6a3..13b3bc1 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -1,23 +1,23 @@
 /*
-   tm6000-i2c.c - driver for TM5600/TM6000/TM6010 USB video capture devices
-
-   Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
-
-   Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
-	- Fix SMBus Read Byte command
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation version 2
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *  tm6000-i2c.c - driver for TM5600/TM6000/TM6010 USB video capture devices
+ *
+ *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+ *
+ *  Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
+ *	- Fix SMBus Read Byte command
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/module.h>
diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
index 32f7a0a..b1eabed 100644
--- a/drivers/staging/tm6000/tm6000-input.c
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -1,20 +1,20 @@
 /*
-   tm6000-input.c - driver for TM5600/TM6000/TM6010 USB video capture devices
-
-   Copyright (C) 2010 Stefan Ringel <stefan.ringel@arcor.de>
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation version 2
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *  tm6000-input.c - driver for TM5600/TM6000/TM6010 USB video capture devices
+ *
+ *  Copyright (C) 2010 Stefan Ringel <stefan.ringel@arcor.de>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/module.h>
diff --git a/drivers/staging/tm6000/tm6000-regs.h b/drivers/staging/tm6000/tm6000-regs.h
index c31dbe9..b4349b5 100644
--- a/drivers/staging/tm6000/tm6000-regs.h
+++ b/drivers/staging/tm6000/tm6000-regs.h
@@ -1,20 +1,20 @@
 /*
-   tm6000-regs.h - driver for TM5600/TM6000/TM6010 USB video capture devices
-
-   Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation version 2
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *  tm6000-regs.h - driver for TM5600/TM6000/TM6010 USB video capture devices
+ *
+ *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 /*
diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
index 6bf4a73..357a9de 100644
--- a/drivers/staging/tm6000/tm6000-stds.c
+++ b/drivers/staging/tm6000/tm6000-stds.c
@@ -1,20 +1,20 @@
 /*
-   tm6000-stds.c - driver for TM5600/TM6000/TM6010 USB video capture devices
-
-   Copyright (C) 2007 Mauro Carvalho Chehab <mchehab@redhat.com>
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation version 2
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *  tm6000-stds.c - driver for TM5600/TM6000/TM6010 USB video capture devices
+ *
+ *  Copyright (C) 2007 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/module.h>
diff --git a/drivers/staging/tm6000/tm6000-usb-isoc.h b/drivers/staging/tm6000/tm6000-usb-isoc.h
index 138716a..a9e61d9 100644
--- a/drivers/staging/tm6000/tm6000-usb-isoc.h
+++ b/drivers/staging/tm6000/tm6000-usb-isoc.h
@@ -1,20 +1,20 @@
 /*
-   tm6000-buf.c - driver for TM5600/TM6000/TM6010 USB video capture devices
-
-   Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation version 2
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *  tm6000-buf.c - driver for TM5600/TM6000/TM6010 USB video capture devices
+ *
+ *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/videodev2.h>
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 712ce84..5dc64d4 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -1,23 +1,23 @@
 /*
-   tm6000.h - driver for TM5600/TM6000/TM6010 USB video capture devices
-
-   Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
-
-   Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
-	- DVB-T support
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation version 2
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *  tm6000.h - driver for TM5600/TM6000/TM6010 USB video capture devices
+ *
+ *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+ *
+ *  Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
+ *	- DVB-T support
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 /* Use the tm6000-hack, instead of the proper initialization code i*/
-- 
1.7.0.4

