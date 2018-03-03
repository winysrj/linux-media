Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45302 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752448AbeCCUve (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 15:51:34 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 01/11] em28xx: Add SPDX license tags where needed
Date: Sat,  3 Mar 2018 17:51:02 -0300
Message-Id: <3911a4d6ca238fd4eafef7db069ea3b27cbd578d.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most of the files there are missing a SPDX license tag. Add.

While here fix some DRIVER_LICENSE macro in order to reflect
the source file license, as some of the headers are GPL v2
only.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c  | 46 ++++++++++++++--------------
 drivers/media/usb/em28xx/em28xx-camera.c | 36 ++++++++++------------
 drivers/media/usb/em28xx/em28xx-cards.c  | 44 ++++++++++++---------------
 drivers/media/usb/em28xx/em28xx-core.c   | 44 ++++++++++++---------------
 drivers/media/usb/em28xx/em28xx-dvb.c    | 46 ++++++++++++++--------------
 drivers/media/usb/em28xx/em28xx-i2c.c    | 41 ++++++++++++-------------
 drivers/media/usb/em28xx/em28xx-input.c  | 42 ++++++++++++--------------
 drivers/media/usb/em28xx/em28xx-reg.h    |  5 +++
 drivers/media/usb/em28xx/em28xx-v4l.h    | 27 +++++++++--------
 drivers/media/usb/em28xx/em28xx-vbi.c    | 39 +++++++++++-------------
 drivers/media/usb/em28xx/em28xx-video.c  | 52 +++++++++++++++-----------------
 drivers/media/usb/em28xx/em28xx.h        | 41 ++++++++++++-------------
 12 files changed, 219 insertions(+), 244 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 4628d73f46f2..f8854b570f0d 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -1,25 +1,25 @@
-/*
- *  Empiatech em28x1 audio extension
- *
- *  Copyright (C) 2006 Markus Rechberger <mrechberger@gmail.com>
- *
- *  Copyright (C) 2007-2016 Mauro Carvalho Chehab
- *	- Port to work with the in-kernel driver
- *	- Cleanups, fixes, alsa-controls, etc.
- *
- *  This driver is based on my previous au600 usb pstn audio driver
- *  and inherits all the copyrights
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
+// SPDX-License-Identifier: GPL-2.0+
+//
+// Empiatech em28x1 audio extension
+//
+// Copyright (C) 2006 Markus Rechberger <mrechberger@gmail.com>
+//
+// Copyright (C) 2007-2016 Mauro Carvalho Chehab
+//	- Port to work with the in-kernel driver
+//	- Cleanups, fixes, alsa-controls, etc.
+//
+// This driver is based on my previous au600 usb pstn audio driver
+// and inherits all the copyrights
+//
+// This program is free software; you can redistribute it and/or modify
+// it under the terms of the GNU General Public License as published by
+// the Free Software Foundation; either version 2 of the License, or
+// (at your option) any later version.
+//
+// This program is distributed in the hope that it will be useful,
+// but WITHOUT ANY WARRANTY; without even the implied warranty of
+// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+// GNU General Public License for more details.
 
 #include "em28xx.h"
 
@@ -1050,7 +1050,7 @@ static void __exit em28xx_alsa_unregister(void)
 	em28xx_unregister_extension(&audio_ops);
 }
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Markus Rechberger <mrechberger@gmail.com>");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_DESCRIPTION(DRIVER_DESC " - audio interface");
diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index ae87dd3e671f..f0c52da17372 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -1,23 +1,19 @@
-/*
-   em28xx-camera.c - driver for Empia EM25xx/27xx/28xx USB video capture devices
-
-   Copyright (C) 2009 Mauro Carvalho Chehab <mchehab@infradead.org>
-   Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2 of the License, or
-   (at your option) any later version.
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
+// SPDX-License-Identifier: GPL-2.0+
+//
+// em28xx-camera.c - driver for Empia EM25xx/27xx/28xx USB video capture devices
+//
+// Copyright (C) 2009 Mauro Carvalho Chehab <mchehab@infradead.org>
+// Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>
+//
+// This program is free software; you can redistribute it and/or modify
+// it under the terms of the GNU General Public License as published by
+// the Free Software Foundation; either version 2 of the License, or
+// (at your option) any later version.
+//
+// This program is distributed in the hope that it will be useful,
+// but WITHOUT ANY WARRANTY; without even the implied warranty of
+// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+// GNU General Public License for more details.
 
 #include "em28xx.h"
 
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 4f08e35eddee..474e3effdb88 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -1,27 +1,23 @@
-/*
-   em28xx-cards.c - driver for Empia EM2800/EM2820/2840 USB
-		    video capture devices
-
-   Copyright (C) 2005 Ludovico Cavedon <cavedon@sssup.it>
-		      Markus Rechberger <mrechberger@gmail.com>
-		      Mauro Carvalho Chehab <mchehab@infradead.org>
-		      Sascha Sommer <saschasommer@freenet.de>
-   Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2 of the License, or
-   (at your option) any later version.
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
+// SPDX-License-Identifier: GPL-2.0+
+//
+// em28xx-cards.c - driver for Empia EM2800/EM2820/2840 USB
+//		    video capture devices
+//
+// Copyright (C) 2005 Ludovico Cavedon <cavedon@sssup.it>
+//		      Markus Rechberger <mrechberger@gmail.com>
+//		      Mauro Carvalho Chehab <mchehab@infradead.org>
+//		      Sascha Sommer <saschasommer@freenet.de>
+// Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
+//
+// This program is free software; you can redistribute it and/or modify
+// it under the terms of the GNU General Public License as published by
+// the Free Software Foundation; either version 2 of the License, or
+// (at your option) any later version.
+//
+// This program is distributed in the hope that it will be useful,
+// but WITHOUT ANY WARRANTY; without even the implied warranty of
+// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+// GNU General Public License for more details.
 
 #include "em28xx.h"
 
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index ee8ef066d1ac..2b1e7e35de20 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1,26 +1,22 @@
-/*
-   em28xx-core.c - driver for Empia EM2800/EM2820/2840 USB video capture devices
-
-   Copyright (C) 2005 Ludovico Cavedon <cavedon@sssup.it>
-		      Markus Rechberger <mrechberger@gmail.com>
-		      Mauro Carvalho Chehab <mchehab@infradead.org>
-		      Sascha Sommer <saschasommer@freenet.de>
-   Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2 of the License, or
-   (at your option) any later version.
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
+// SPDX-License-Identifier: GPL-2.0+
+//
+// em28xx-core.c - driver for Empia EM2800/EM2820/2840 USB video capture devices
+//
+// Copyright (C) 2005 Ludovico Cavedon <cavedon@sssup.it>
+//		      Markus Rechberger <mrechberger@gmail.com>
+//		      Mauro Carvalho Chehab <mchehab@infradead.org>
+//		      Sascha Sommer <saschasommer@freenet.de>
+// Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
+//
+// This program is free software; you can redistribute it and/or modify
+// it under the terms of the GNU General Public License as published by
+// the Free Software Foundation; either version 2 of the License, or
+// (at your option) any later version.
+//
+// This program is distributed in the hope that it will be useful,
+// but WITHOUT ANY WARRANTY; without even the implied warranty of
+// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+// GNU General Public License for more details.
 
 #include "em28xx.h"
 
@@ -41,7 +37,7 @@
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_VERSION(EM28XX_VERSION);
 
 /* #define ENABLE_DEBUG_ISOC_FRAMES */
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 9e692f265118..d9d7da9e9787 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1,25 +1,25 @@
-/*
- DVB device driver for em28xx
-
- (c) 2008-2011 Mauro Carvalho Chehab <mchehab@infradead.org>
-
- (c) 2008 Devin Heitmueller <devin.heitmueller@gmail.com>
-	- Fixes for the driver to properly work with HVR-950
-	- Fixes for the driver to properly work with Pinnacle PCTV HD Pro Stick
-	- Fixes for the driver to properly work with AMD ATI TV Wonder HD 600
-
- (c) 2008 Aidan Thornton <makosoft@googlemail.com>
-
- (c) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
-
- Based on cx88-dvb, saa7134-dvb and videobuf-dvb originally written by:
-	(c) 2004, 2005 Chris Pascoe <c.pascoe@itee.uq.edu.au>
-	(c) 2004 Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
-
- This program is free software; you can redistribute it and/or modify
- it under the terms of the GNU General Public License as published by
- the Free Software Foundation; either version 2 of the License.
- */
+// SPDX-License-Identifier: GPL-2.0
+//
+// DVB device driver for em28xx
+//
+// (c) 2008-2011 Mauro Carvalho Chehab <mchehab@infradead.org>
+//
+// (c) 2008 Devin Heitmueller <devin.heitmueller@gmail.com>
+//	- Fixes for the driver to properly work with HVR-950
+//	- Fixes for the driver to properly work with Pinnacle PCTV HD Pro Stick
+//	- Fixes for the driver to properly work with AMD ATI TV Wonder HD 600
+//
+// (c) 2008 Aidan Thornton <makosoft@googlemail.com>
+//
+// (c) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
+//
+// Based on cx88-dvb, saa7134-dvb and videobuf-dvb originally written by:
+//	(c) 2004, 2005 Chris Pascoe <c.pascoe@itee.uq.edu.au>
+//	(c) 2004 Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
+//
+// This program is free software; you can redistribute it and/or modify
+// it under the terms of the GNU General Public License as published by
+// the Free Software Foundation version 2 of the License.
 
 #include "em28xx.h"
 
@@ -64,7 +64,7 @@
 #include "qm1d1c0042.h"
 
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION(DRIVER_DESC " - digital TV interface");
 MODULE_VERSION(EM28XX_VERSION);
 
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index e9892a98eb6e..677f08b3b51d 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -1,26 +1,23 @@
-/*
-   em28xx-i2c.c - driver for Empia EM2800/EM2820/2840 USB video capture devices
+// SPDX-License-Identifier: GPL-2.0+
+//
+// em28xx-i2c.c - driver for Empia EM2800/EM2820/2840 USB video capture devices
+//
+// Copyright (C) 2005 Ludovico Cavedon <cavedon@sssup.it>
+//		      Markus Rechberger <mrechberger@gmail.com>
+//		      Mauro Carvalho Chehab <mchehab@infradead.org>
+//		      Sascha Sommer <saschasommer@freenet.de>
+// Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>
+//
+// This program is free software; you can redistribute it and/or modify
+// it under the terms of the GNU General Public License as published by
+// the Free Software Foundation; either version 2 of the License, or
+// (at your option) any later version.
+//
+// This program is distributed in the hope that it will be useful,
+// but WITHOUT ANY WARRANTY; without even the implied warranty of
+// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+// GNU General Public License for more details.
 
-   Copyright (C) 2005 Ludovico Cavedon <cavedon@sssup.it>
-		      Markus Rechberger <mrechberger@gmail.com>
-		      Mauro Carvalho Chehab <mchehab@infradead.org>
-		      Sascha Sommer <saschasommer@freenet.de>
-   Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2 of the License, or
-   (at your option) any later version.
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
 
 #include "em28xx.h"
 
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 270cd68df4a2..c7afcf67ccc5 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -1,25 +1,21 @@
-/*
-  handle em28xx IR remotes via linux kernel input layer.
-
-   Copyright (C) 2005 Ludovico Cavedon <cavedon@sssup.it>
-		      Markus Rechberger <mrechberger@gmail.com>
-		      Mauro Carvalho Chehab <mchehab@infradead.org>
-		      Sascha Sommer <saschasommer@freenet.de>
-
-  This program is free software; you can redistribute it and/or modify
-  it under the terms of the GNU General Public License as published by
-  the Free Software Foundation; either version 2 of the License, or
-  (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- */
+// SPDX-License-Identifier: GPL-2.0+
+//
+// handle em28xx IR remotes via linux kernel input layer.
+//
+// Copyright (C) 2005 Ludovico Cavedon <cavedon@sssup.it>
+//		      Markus Rechberger <mrechberger@gmail.com>
+//		      Mauro Carvalho Chehab <mchehab@infradead.org>
+//		      Sascha Sommer <saschasommer@freenet.de>
+//
+// This program is free software; you can redistribute it and/or modify
+// it under the terms of the GNU General Public License as published by
+// the Free Software Foundation; either version 2 of the License, or
+// (at your option) any later version.
+//
+// This program is distributed in the hope that it will be useful,
+// but WITHOUT ANY WARRANTY; without even the implied warranty of
+// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+// GNU General Public License for more details.
 
 #include "em28xx.h"
 
@@ -926,7 +922,7 @@ static void __exit em28xx_rc_unregister(void)
 	em28xx_unregister_extension(&rc_ops);
 }
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_DESCRIPTION(DRIVER_DESC " - input interface");
 MODULE_VERSION(EM28XX_VERSION);
diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index 9e5cdfb25a73..26a06b1b1077 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -1,4 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * em28xx-reg.h - Register definitions for em28xx driver
+ */
+
 #define EM_GPIO_0  (1 << 0)
 #define EM_GPIO_1  (1 << 1)
 #define EM_GPIO_2  (1 << 2)
diff --git a/drivers/media/usb/em28xx/em28xx-v4l.h b/drivers/media/usb/em28xx/em28xx-v4l.h
index 9c411aac3878..1788dbf9024a 100644
--- a/drivers/media/usb/em28xx/em28xx-v4l.h
+++ b/drivers/media/usb/em28xx/em28xx-v4l.h
@@ -1,17 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
-   em28xx-video.c - driver for Empia EM2800/EM2820/2840 USB
-		    video capture devices
-
-   Copyright (C) 2013-2014 Mauro Carvalho Chehab <m.chehab@samsung.com>
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation version 2 of the License.
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
+ * em28xx-video.c - driver for Empia EM2800/EM2820/2840 USB
+ *		    video capture devices
+ *
+ * Copyright (C) 2013-2014 Mauro Carvalho Chehab <m.chehab@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  */
 
 int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count);
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index f5123651ef30..63c48361d3f2 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -1,25 +1,20 @@
-/*
-   em28xx-vbi.c - VBI driver for em28xx
-
-   Copyright (C) 2009 Devin Heitmueller <dheitmueller@kernellabs.com>
-
-   This work was sponsored by EyeMagnet Limited.
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2 of the License, or
-   (at your option) any later version.
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
-   02110-1301, USA.
- */
+// SPDX-License-Identifier: GPL-2.0+
+//
+// em28xx-vbi.c - VBI driver for em28xx
+//
+// Copyright (C) 2009 Devin Heitmueller <dheitmueller@kernellabs.com>
+//
+// This work was sponsored by EyeMagnet Limited.
+//
+// This program is free software; you can redistribute it and/or modify
+// it under the terms of the GNU General Public License as published by
+// the Free Software Foundation; either version 2 of the License, or
+// (at your option) any later version.
+//
+// This program is distributed in the hope that it will be useful,
+// but WITHOUT ANY WARRANTY; without even the implied warranty of
+// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+// GNU General Public License for more details.
 
 #include "em28xx.h"
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 407850d9cae0..540c62c87f3f 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1,30 +1,26 @@
-/*
-   em28xx-video.c - driver for Empia EM2800/EM2820/2840 USB
-		    video capture devices
-
-   Copyright (C) 2005 Ludovico Cavedon <cavedon@sssup.it>
-		      Markus Rechberger <mrechberger@gmail.com>
-		      Mauro Carvalho Chehab <mchehab@infradead.org>
-		      Sascha Sommer <saschasommer@freenet.de>
-   Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
-
-	Some parts based on SN9C10x PC Camera Controllers GPL driver made
-		by Luca Risolia <luca.risolia@studio.unibo.it>
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2 of the License, or
-   (at your option) any later version.
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
+// SPDX-License-Identifier: GPL-2.0+
+//
+// em28xx-video.c - driver for Empia EM2800/EM2820/2840 USB
+//		    video capture devices
+//
+// Copyright (C) 2005 Ludovico Cavedon <cavedon@sssup.it>
+//		      Markus Rechberger <mrechberger@gmail.com>
+//		      Mauro Carvalho Chehab <mchehab@infradead.org>
+//		      Sascha Sommer <saschasommer@freenet.de>
+// Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
+//
+//	Some parts based on SN9C10x PC Camera Controllers GPL driver made
+//		by Luca Risolia <luca.risolia@studio.unibo.it>
+//
+// This program is free software; you can redistribute it and/or modify
+// it under the terms of the GNU General Public License as published by
+// the Free Software Foundation; either version 2 of the License, or
+// (at your option) any later version.
+//
+// This program is distributed in the hope that it will be useful,
+// but WITHOUT ANY WARRANTY; without even the implied warranty of
+// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+// GNU General Public License for more details.
 
 #include "em28xx.h"
 
@@ -77,7 +73,7 @@ MODULE_PARM_DESC(alt, "alternate setting to use for video endpoint");
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC " - v4l2 interface");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_VERSION(EM28XX_VERSION);
 
 #define EM25XX_FRMDATAHDR_BYTE1			0x02
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 220e7a7a6124..46ecf17758e8 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -1,26 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
-   em28xx.h - driver for Empia EM2800/EM2820/2840 USB video capture devices
-
-   Copyright (C) 2005 Markus Rechberger <mrechberger@gmail.com>
-		      Ludovico Cavedon <cavedon@sssup.it>
-		      Mauro Carvalho Chehab <mchehab@infradead.org>
-   Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
-
-   Based on the em2800 driver from Sascha Sommer <saschasommer@freenet.de>
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2 of the License, or
-   (at your option) any later version.
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * em28xx.h - driver for Empia EM2800/EM2820/2840 USB video capture devices
+ *
+ * Copyright (C) 2005 Markus Rechberger <mrechberger@gmail.com>
+ *		      Ludovico Cavedon <cavedon@sssup.it>
+ *		      Mauro Carvalho Chehab <mchehab@infradead.org>
+ * Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
+ *
+ * Based on the em2800 driver from Sascha Sommer <saschasommer@freenet.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  */
 
 #ifndef _EM28XX_H
-- 
2.14.3
