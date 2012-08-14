Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41077 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556Ab2HNVRt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 17:17:49 -0400
Received: by wibhr14 with SMTP id hr14so825772wib.1
        for <linux-media@vger.kernel.org>; Tue, 14 Aug 2012 14:17:48 -0700 (PDT)
Message-ID: <502AC079.50902@gmail.com>
Date: Tue, 14 Aug 2012 23:17:45 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/12] media tree reorganization part 2 (second version)
References: <1344977727-16319-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344977727-16319-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/14/2012 10:55 PM, Mauro Carvalho Chehab wrote:
> Ok, it is now everything almost done... there are of course
> cleanups that may happen, and there are still some things
> to do at drivers/media/platform, but most of the things are
> there.
>
> If there isn't any big problem, I'll be merging them tomorrow.

Briefly looking didn't spot any issues. However it could be a bit easier
to review if patches were created with -M option to git-format patch,
for example patch 05/12 looks much smaller then:

8<---------------------------------------------------------------------

 From 83d249058179c26af9b34ecf077d133fb5696153 Mon Sep 17 00:00:00 2001
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Tue, 14 Aug 2012 12:53:09 -0300
Subject: [PATCH 05/12] [media] move analog PCI saa7146 drivers to its 
own dir

Instead of having them under drivers/media/video, move them
to their own directory.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
  drivers/media/pci/Kconfig                          |    2 +
  drivers/media/pci/Makefile                         |    3 +-
  drivers/media/pci/saa7146/Kconfig                  |   38 
++++++++++++++++++++
  drivers/media/pci/saa7146/Makefile                 |    5 +++
  .../media/{video => pci/saa7146}/hexium_gemini.c   |    0
  .../media/{video => pci/saa7146}/hexium_orion.c    |    0
  drivers/media/{video => pci/saa7146}/mxb.c         |    0
  drivers/media/video/Kconfig                        |   38 
--------------------
  drivers/media/video/Makefile                       |    3 --
  9 files changed, 47 insertions(+), 42 deletions(-)
  create mode 100644 drivers/media/pci/saa7146/Kconfig
  create mode 100644 drivers/media/pci/saa7146/Makefile
  rename drivers/media/{video => pci/saa7146}/hexium_gemini.c (100%)
  rename drivers/media/{video => pci/saa7146}/hexium_orion.c (100%)
  rename drivers/media/{video => pci/saa7146}/mxb.c (100%)

diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index b69cb12..e1a9e1a 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -9,6 +9,7 @@ if MEDIA_ANALOG_TV_SUPPORT
  	comment "Media capture/analog TV support"
  source "drivers/media/pci/ivtv/Kconfig"
  source "drivers/media/pci/zoran/Kconfig"
+source "drivers/media/pci/saa7146/Kconfig"
  endif

  if MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
@@ -20,6 +21,7 @@ source "drivers/media/pci/cx88/Kconfig"
  source "drivers/media/pci/bt8xx/Kconfig"
  source "drivers/media/pci/saa7134/Kconfig"
  source "drivers/media/pci/saa7164/Kconfig"
+
  endif

  if MEDIA_DIGITAL_TV_SUPPORT
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index d47c222..bb71e30 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -10,7 +10,8 @@ obj-y        :=	ttpci/		\
  		mantis/		\
  		ngene/		\
  		ddbridge/	\
-		b2c2/
+		b2c2/		\
+		saa7146/

  obj-$(CONFIG_VIDEO_IVTV) += ivtv/
  obj-$(CONFIG_VIDEO_ZORAN) += zoran/
diff --git a/drivers/media/pci/saa7146/Kconfig 
b/drivers/media/pci/saa7146/Kconfig
new file mode 100644
index 0000000..8923b76
--- /dev/null
+++ b/drivers/media/pci/saa7146/Kconfig
@@ -0,0 +1,38 @@
+config VIDEO_HEXIUM_GEMINI
+	tristate "Hexium Gemini frame grabber"
+	depends on PCI && VIDEO_V4L2 && I2C
+	select VIDEO_SAA7146_VV
+	---help---
+	  This is a video4linux driver for the Hexium Gemini frame
+	  grabber card by Hexium. Please note that the Gemini Dual
+	  card is *not* fully supported.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called hexium_gemini.
+
+config VIDEO_HEXIUM_ORION
+	tristate "Hexium HV-PCI6 and Orion frame grabber"
+	depends on PCI && VIDEO_V4L2 && I2C
+	select VIDEO_SAA7146_VV
+	---help---
+	  This is a video4linux driver for the Hexium HV-PCI6 and
+	  Orion frame grabber cards by Hexium.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called hexium_orion.
+
+config VIDEO_MXB
+	tristate "Siemens-Nixdorf 'Multimedia eXtension Board'"
+	depends on PCI && VIDEO_V4L2 && I2C
+	select VIDEO_SAA7146_VV
+	select VIDEO_TUNER
+	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_TDA9840 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_TEA6415C if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_TEA6420 if VIDEO_HELPER_CHIPS_AUTO
+	---help---
+	  This is a video4linux driver for the 'Multimedia eXtension Board'
+	  TV card by Siemens-Nixdorf.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mxb.
diff --git a/drivers/media/pci/saa7146/Makefile 
b/drivers/media/pci/saa7146/Makefile
new file mode 100644
index 0000000..362a38b
--- /dev/null
+++ b/drivers/media/pci/saa7146/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_VIDEO_MXB) += mxb.o
+obj-$(CONFIG_VIDEO_HEXIUM_ORION) += hexium_orion.o
+obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
+
+ccflags-y += -I$(srctree)/drivers/media/video
diff --git a/drivers/media/video/hexium_gemini.c 
b/drivers/media/pci/saa7146/hexium_gemini.c
similarity index 100%
rename from drivers/media/video/hexium_gemini.c
rename to drivers/media/pci/saa7146/hexium_gemini.c
diff --git a/drivers/media/video/hexium_orion.c 
b/drivers/media/pci/saa7146/hexium_orion.c
similarity index 100%
rename from drivers/media/video/hexium_orion.c
rename to drivers/media/pci/saa7146/hexium_orion.c
diff --git a/drivers/media/video/mxb.c b/drivers/media/pci/saa7146/mxb.c
similarity index 100%
rename from drivers/media/video/mxb.c
rename to drivers/media/pci/saa7146/mxb.c
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index a837194..4d79dfd 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -619,29 +619,6 @@ menuconfig V4L_PCI_DRIVERS

  if V4L_PCI_DRIVERS

-config VIDEO_HEXIUM_GEMINI
-	tristate "Hexium Gemini frame grabber"
-	depends on PCI && VIDEO_V4L2 && I2C
-	---help---
-	  This is a video4linux driver for the Hexium Gemini frame
-	  grabber card by Hexium. Please note that the Gemini Dual
-	  card is *not* fully supported.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called hexium_gemini.
-
-config VIDEO_HEXIUM_ORION
-	tristate "Hexium HV-PCI6 and Orion frame grabber"
-	depends on PCI && VIDEO_V4L2 && I2C
-	select VIDEO_SAA7146_VV
-	---help---
-	  This is a video4linux driver for the Hexium HV-PCI6 and
-	  Orion frame grabber cards by Hexium.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called hexium_orion.
-
  config VIDEO_MEYE
  	tristate "Sony Vaio Picturebook Motion Eye Video For Linux"
  	depends on PCI && SONY_LAPTOP && VIDEO_V4L2
@@ -656,21 +633,6 @@ config VIDEO_MEYE
  	  To compile this driver as a module, choose M here: the
  	  module will be called meye.

-config VIDEO_MXB
-	tristate "Siemens-Nixdorf 'Multimedia eXtension Board'"
-	depends on PCI && VIDEO_V4L2 && I2C
-	select VIDEO_SAA7146_VV
-	select VIDEO_TUNER
-	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TDA9840 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TEA6415C if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TEA6420 if VIDEO_HELPER_CHIPS_AUTO
-	---help---
-	  This is a video4linux driver for the 'Multimedia eXtension Board'
-	  TV card by Siemens-Nixdorf.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called mxb.


  config STA2X11_VIP
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 322a159..8df694d 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -93,9 +93,6 @@ obj-$(CONFIG_VIDEO_W9966) += w9966.o
  obj-$(CONFIG_VIDEO_PMS) += pms.o
  obj-$(CONFIG_VIDEO_VINO) += vino.o
  obj-$(CONFIG_VIDEO_MEYE) += meye.o
-obj-$(CONFIG_VIDEO_MXB) += mxb.o
-obj-$(CONFIG_VIDEO_HEXIUM_ORION) += hexium_orion.o
-obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
  obj-$(CONFIG_STA2X11_VIP) += sta2x11_vip.o
  obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o

-- 
1.7.4.1
8<---------------------------------------------------------------------

I think that might be more a hint for the future though. :)

--

Regards,
Sylwester
