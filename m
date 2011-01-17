Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:42088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab1AQQbc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 11:31:32 -0500
Message-ID: <4D346ED3.2030703@redhat.com>
Date: Mon, 17 Jan 2011 14:31:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>,
	Andreas Oberritter <obi@linuxtv.org>,
	Ralph Metzler <rjkm@metzlerbros.de>
Subject: Re: [PATCH 07/16] ngene: CXD2099AR Common Interface driver
References: <1294652184-12843-1-git-send-email-o.endriss@gmx.de> <1294652184-12843-8-git-send-email-o.endriss@gmx.de> <4D2B122E.3050803@linuxtv.org> <201101101820.07907@orion.escape-edv.de>
In-Reply-To: <201101101820.07907@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 10-01-2011 15:20, Oliver Endriss escreveu:
> On Monday 10 January 2011 15:05:34 Andreas Oberritter wrote:
>> On 01/10/2011 10:36 AM, Oliver Endriss wrote:
>>> From: Ralph Metzler <rjkm@metzlerbros.de>
>>>
>>> Driver for the Common Interface Controller CXD2099AR.
>>> Supports the CI of the cineS2 DVB-S2.
>>>
>>> For now, data is passed through '/dev/dvb/adapterX/sec0':
>>> - Encrypted data must be written to 'sec0'.
>>> - Decrypted data can be read from 'sec0'.
>>> - Setup the CAM using device 'ca0'.
>>
>> Nack. In DVB API terms, "sec" stands for satellite equipment control,
>> and if I remember correctly, sec0 already existed in the first versions
>> of the API and that's why its leftovers can be abused by this driver.
>>
>> The interfaces for writing data are dvr0 and demux0. If they don't fit
>> for decryption of recorded data, then they should be extended.
>>
>> For decryption of live data, no new user interface needs to be created.
> 
> There was an attempt to find a solution for the problem in thread
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg22196.html
> 
> As that discussion did not come to a final solution, and the driver is
> still experimental, I left the original patch 'as is'.

Drivers that don't use the proper API should be moved to staging. Just making
them as experimental is not good enough. As this is the only issue with
this patch series, I'll be applying them and moving cxd2099 driver to staging
while we don't have a proper fix for it.

Cheers,
Mauro.

PS.: The patch I'm appling to move it to staging is enclosed.

-

commit 96d7f7656af8a348134302d8c36760156ea6428e
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Mon Jan 17 14:20:49 2011 -0200

    [media] Move CI cxd2099 driver to staging
    
    This driver is abusing the kernel<=>userspace API, due to the lack of a
    proper solution for it. A discussion were done at:
    	http://www.mail-archive.com/linux-media@vger.kernel.org/msg22196.html
    But there's not a solution for it yet. So, move the driver to staging, while
    we don't have a final solution.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/ngene/Makefile b/drivers/media/dvb/ngene/Makefile
index 00d12d6..2bc9687 100644
--- a/drivers/media/dvb/ngene/Makefile
+++ b/drivers/media/dvb/ngene/Makefile
@@ -2,10 +2,13 @@
 # Makefile for the nGene device driver
 #
 
-ngene-objs := ngene-core.o ngene-i2c.o ngene-cards.o ngene-dvb.o cxd2099.o
+ngene-objs := ngene-core.o ngene-i2c.o ngene-cards.o ngene-dvb.o
 
 obj-$(CONFIG_DVB_NGENE) += ngene.o
 
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends/
 EXTRA_CFLAGS += -Idrivers/media/common/tuners/
+
+# For the staging CI driver cxd2099
+EXTRA_CFLAGS += -Idrivers/staging/cxd2099/
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index bdc632b..1fc1087 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -51,6 +51,8 @@ source "drivers/staging/cx25821/Kconfig"
 
 source "drivers/staging/tm6000/Kconfig"
 
+source "drivers/staging/cxd2099/Kconfig"
+
 source "drivers/staging/dabusb/Kconfig"
 
 source "drivers/staging/se401/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 3eda5c7..2f638e5 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_SLICOSS)		+= slicoss/
 obj-$(CONFIG_VIDEO_GO7007)	+= go7007/
 obj-$(CONFIG_VIDEO_CX25821)	+= cx25821/
 obj-$(CONFIG_VIDEO_TM6000)	+= tm6000/
+obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_USB_DABUSB)        += dabusb/
 obj-$(CONFIG_USB_VICAM)         += usbvideo/
 obj-$(CONFIG_USB_SE401)         += se401/
diff --git a/drivers/staging/cxd2099/Kconfig b/drivers/staging/cxd2099/Kconfig
new file mode 100644
index 0000000..9d638c3
--- /dev/null
+++ b/drivers/staging/cxd2099/Kconfig
@@ -0,0 +1,11 @@
+config DVB_CXD2099
+        tristate "CXD2099AR Common Interface driver"
+        depends on DVB_CORE && PCI && I2C && DVB_NGENE
+        ---help---
+          Support for the CI module found on cineS2 DVB-S2, supported by
+	  the Micronas PCIe device driver (ngene).
+
+	  For now, data is passed through '/dev/dvb/adapterX/sec0':
+	    - Encrypted data must be written to 'sec0'.
+	    - Decrypted data can be read from 'sec0'.
+	    - Setup the CAM using device 'ca0'.
diff --git a/drivers/staging/cxd2099/Makefile b/drivers/staging/cxd2099/Makefile
new file mode 100644
index 0000000..72b1455
--- /dev/null
+++ b/drivers/staging/cxd2099/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_DVB_CXD2099) += cxd2099.o
+
+EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/
+EXTRA_CFLAGS += -Idrivers/media/dvb/frontends/
+EXTRA_CFLAGS += -Idrivers/media/common/tuners/
diff --git a/drivers/staging/cxd2099/TODO b/drivers/staging/cxd2099/TODO
new file mode 100644
index 0000000..375bb6f
--- /dev/null
+++ b/drivers/staging/cxd2099/TODO
@@ -0,0 +1,12 @@
+For now, data is passed through '/dev/dvb/adapterX/sec0':
+ - Encrypted data must be written to 'sec0'.
+ - Decrypted data can be read from 'sec0'.
+ - Setup the CAM using device 'ca0'.
+
+But this is wrong. There are some discussions about the proper way for
+doing it, as seen at:
+	http://www.mail-archive.com/linux-media@vger.kernel.org/msg22196.html
+
+While there's no proper fix for it, the driver should be kept in staging.
+
+Patches should be submitted to: linux-media@vger.kernel.org.
diff --git a/drivers/media/dvb/ngene/cxd2099.c b/drivers/staging/cxd2099/cxd2099.c
similarity index 100%
rename from drivers/media/dvb/ngene/cxd2099.c
rename to drivers/staging/cxd2099/cxd2099.c
diff --git a/drivers/media/dvb/ngene/cxd2099.h b/drivers/staging/cxd2099/cxd2099.h
similarity index 78%
rename from drivers/media/dvb/ngene/cxd2099.h
rename to drivers/staging/cxd2099/cxd2099.h
index f71b807..a313dc2 100644
--- a/drivers/media/dvb/ngene/cxd2099.h
+++ b/drivers/staging/cxd2099/cxd2099.h
@@ -27,6 +27,15 @@
 
 #include <dvb_ca_en50221.h>
 
+#if defined(CONFIG_DVB_CXD2099) || \
+        (defined(CONFIG_DVB_CXD2099_MODULE) && defined(MODULE))
 struct dvb_ca_en50221 *cxd2099_attach(u8 adr, void *priv, struct i2c_adapter *i2c);
+#else
+struct dvb_ca_en50221 *cxd2099_attach(u8 adr, void *priv, struct i2c_adapter *i2c)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
 
 #endif
