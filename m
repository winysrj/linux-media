Return-path: <linux-media-owner@vger.kernel.org>
Received: from crow.cadsoft.de ([217.86.189.86]:58290 "EHLO raven.cadsoft.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbZEUKwL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 06:52:11 -0400
Received: from [192.168.100.20] (weasel.cadsoft.de [192.168.100.20])
	by raven.cadsoft.de (8.14.3/8.14.3) with ESMTP id n4LAqABB006130
	for <linux-media@vger.kernel.org>; Thu, 21 May 2009 12:52:10 +0200
Message-ID: <4A153254.5040402@cadsoft.de>
Date: Thu, 21 May 2009 12:52:04 +0200
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-media] [DVB] compiling av7110 firmware into driver fails
References: <4A11C62F.9020208@cadsoft.de>
In-Reply-To: <4A11C62F.9020208@cadsoft.de>
Content-Type: multipart/mixed;
 boundary="------------010702060408050205020900"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010702060408050205020900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 05/18/09 22:33, Klaus Schmidinger wrote:
> I always compile the current av7110 firmware into my driver,
> so that I can have different driver/firmware versions to test
> with. This used to work by doing
> 
> CONFIG_DVB_AV7110_FIRMWARE=y
> CONFIG_DVB_AV7110_FIRMWARE_FILE="/home/kls/vdr/firmware/FW.current"
> 
> in the v4l/.config file (where FW.current is a symlink to the
> current firmware version).
> 
> With driver version c29ce3e2fc6a (2009-04-25) this still worked,
> but with 0018ed9bbca3 (2009-05-16) it doesn't work any more.
> Am I doing something wrong, or has this been broken?

Well, apparently nobody cares, so I've put together a patch
that fixes this, and attached it to this message - just in case
I'm not the only one who thinks removing this code was a bad idea...

This is a reverse diff, so apply it with 'diff -R'.

Klaus

--------------010702060408050205020900
Content-Type: text/x-patch;
 name="DVB.restore-av7110-fw-compile-in.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="DVB.restore-av7110-fw-compile-in.diff"

diff -ruN v4l-dvb-c29ce3e2fc6a/linux/drivers/media/dvb/ttpci/Kconfig v4l-dvb-0018ed9bbca3/linux/drivers/media/dvb/ttpci/Kconfig
--- v4l-dvb-c29ce3e2fc6a/linux/drivers/media/dvb/ttpci/Kconfig	2009-04-24 21:57:56.000000000 +0200
+++ v4l-dvb-0018ed9bbca3/linux/drivers/media/dvb/ttpci/Kconfig	2009-05-12 18:13:13.000000000 +0200
@@ -28,25 +28,12 @@
 	  download/extract it, and then copy it to /usr/lib/hotplug/firmware
 	  or /lib/firmware (depending on configuration of firmware hotplug).
 
-	  Say Y if you own such a card and want to use it.
-
-config DVB_AV7110_FIRMWARE
-	bool "Compile AV7110 firmware into the driver"
-	depends on DVB_AV7110 && !STANDALONE
-	default y if DVB_AV7110=y
-	help
-	  The AV7110 firmware is normally loaded by the firmware hotplug manager.
-	  If you want to compile the firmware into the driver you need to say
-	  Y here and provide the correct path of the firmware. You need this
-	  option if you want to compile the whole driver statically into the
-	  kernel.
+	  Alternatively, you can download the file and use the kernel's
+	  EXTRA_FIRMWARE configuration option to build it into your
+	  kernel image by adding the filename to the EXTRA_FIRMWARE
+	  configuration option string.
 
-	  All other people say N.
-
-config DVB_AV7110_FIRMWARE_FILE
-	string "Full pathname of av7110 firmware file"
-	depends on DVB_AV7110_FIRMWARE
-	default "/usr/lib/hotplug/firmware/dvb-ttpci-01.fw"
+	  Say Y if you own such a card and want to use it.
 
 config DVB_AV7110_OSD
 	bool "AV7110 OSD support"
diff -ruN v4l-dvb-c29ce3e2fc6a/linux/drivers/media/dvb/ttpci/Makefile v4l-dvb-0018ed9bbca3/linux/drivers/media/dvb/ttpci/Makefile
--- v4l-dvb-c29ce3e2fc6a/linux/drivers/media/dvb/ttpci/Makefile	2009-04-24 21:57:56.000000000 +0200
+++ v4l-dvb-0018ed9bbca3/linux/drivers/media/dvb/ttpci/Makefile	2009-05-12 18:13:13.000000000 +0200
@@ -19,12 +19,3 @@
 
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
 EXTRA_CFLAGS += -Idrivers/media/common/tuners
-
-hostprogs-y	:= fdump
-
-ifeq ($(CONFIG_DVB_AV7110_FIRMWARE),y)
-$(obj)/av7110.o: $(obj)/av7110_firm.h
-
-$(obj)/av7110_firm.h: $(obj)/fdump
-	$(obj)/fdump $(CONFIG_DVB_AV7110_FIRMWARE_FILE) dvb_ttpci_fw $@
-endif
diff -ruN v4l-dvb-c29ce3e2fc6a/linux/drivers/media/dvb/ttpci/av7110.c v4l-dvb-0018ed9bbca3/linux/drivers/media/dvb/ttpci/av7110.c
--- v4l-dvb-c29ce3e2fc6a/linux/drivers/media/dvb/ttpci/av7110.c	2009-04-24 21:57:56.000000000 +0200
+++ v4l-dvb-0018ed9bbca3/linux/drivers/media/dvb/ttpci/av7110.c	2009-05-12 18:13:13.000000000 +0200
@@ -1521,20 +1521,6 @@
 	return 0;
 }
 
-#ifdef CONFIG_DVB_AV7110_FIRMWARE_FILE
-#include "av7110_firm.h"
-static void put_firmware(struct av7110* av7110)
-{
-	av7110->bin_fw = NULL;
-}
-
-static inline int get_firmware(struct av7110* av7110)
-{
-	av7110->bin_fw = dvb_ttpci_fw;
-	av7110->size_fw = sizeof(dvb_ttpci_fw);
-	return check_firmware(av7110);
-}
-#else
 static void put_firmware(struct av7110* av7110)
 {
 	vfree(av7110->bin_fw);
@@ -1583,8 +1569,6 @@
 	release_firmware(fw);
 	return ret;
 }
-#endif
-
 
 static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
 {
diff -ruN v4l-dvb-c29ce3e2fc6a/linux/drivers/media/dvb/ttpci/av7110_hw.c v4l-dvb-0018ed9bbca3/linux/drivers/media/dvb/ttpci/av7110_hw.c
--- v4l-dvb-c29ce3e2fc6a/linux/drivers/media/dvb/ttpci/av7110_hw.c	2009-04-24 21:57:56.000000000 +0200
+++ v4l-dvb-0018ed9bbca3/linux/drivers/media/dvb/ttpci/av7110_hw.c	2009-05-12 18:13:13.000000000 +0200
@@ -198,29 +198,10 @@
 
 /* we cannot write av7110 DRAM directly, so load a bootloader into
  * the DPRAM which implements a simple boot protocol */
-static u8 bootcode[] = {
-  0xea, 0x00, 0x00, 0x0e, 0xe1, 0xb0, 0xf0, 0x0e, 0xe2, 0x5e, 0xf0, 0x04,
-  0xe2, 0x5e, 0xf0, 0x04, 0xe2, 0x5e, 0xf0, 0x08, 0xe2, 0x5e, 0xf0, 0x04,
-  0xe2, 0x5e, 0xf0, 0x04, 0xe2, 0x5e, 0xf0, 0x04, 0x2c, 0x00, 0x00, 0x24,
-  0x00, 0x00, 0x00, 0x0c, 0x00, 0x00, 0x00, 0x00, 0x2c, 0x00, 0x00, 0x34,
-  0x00, 0x00, 0x00, 0x00, 0xa5, 0xa5, 0x5a, 0x5a, 0x00, 0x1f, 0x15, 0x55,
-  0x00, 0x00, 0x00, 0x09, 0xe5, 0x9f, 0xd0, 0x7c, 0xe5, 0x9f, 0x40, 0x74,
-  0xe3, 0xa0, 0x00, 0x00, 0xe5, 0x84, 0x00, 0x00, 0xe5, 0x84, 0x00, 0x04,
-  0xe5, 0x9f, 0x10, 0x70, 0xe5, 0x9f, 0x20, 0x70, 0xe5, 0x9f, 0x30, 0x64,
-  0xe8, 0xb1, 0x1f, 0xe0, 0xe8, 0xa3, 0x1f, 0xe0, 0xe1, 0x51, 0x00, 0x02,
-  0xda, 0xff, 0xff, 0xfb, 0xe5, 0x9f, 0xf0, 0x50, 0xe1, 0xd4, 0x10, 0xb0,
-  0xe3, 0x51, 0x00, 0x00, 0x0a, 0xff, 0xff, 0xfc, 0xe1, 0xa0, 0x10, 0x0d,
-  0xe5, 0x94, 0x30, 0x04, 0xe1, 0xd4, 0x20, 0xb2, 0xe2, 0x82, 0x20, 0x3f,
-  0xe1, 0xb0, 0x23, 0x22, 0x03, 0xa0, 0x00, 0x02, 0xe1, 0xc4, 0x00, 0xb0,
-  0x0a, 0xff, 0xff, 0xf4, 0xe8, 0xb1, 0x1f, 0xe0, 0xe8, 0xa3, 0x1f, 0xe0,
-  0xe8, 0xb1, 0x1f, 0xe0, 0xe8, 0xa3, 0x1f, 0xe0, 0xe2, 0x52, 0x20, 0x01,
-  0x1a, 0xff, 0xff, 0xf9, 0xe2, 0x2d, 0xdb, 0x05, 0xea, 0xff, 0xff, 0xec,
-  0x2c, 0x00, 0x03, 0xf8, 0x2c, 0x00, 0x04, 0x00, 0x9e, 0x00, 0x08, 0x00,
-  0x2c, 0x00, 0x00, 0x74, 0x2c, 0x00, 0x00, 0xc0
-};
-
 int av7110_bootarm(struct av7110 *av7110)
 {
+	const struct firmware *fw;
+	const char *fw_name = "av7110/bootcode.bin";
 	struct saa7146_dev *dev = av7110->dev;
 	u32 ret;
 	int i;
@@ -261,7 +242,15 @@
 	//saa7146_setgpio(dev, DEBI_DONE_LINE, SAA7146_GPIO_INPUT);
 	//saa7146_setgpio(dev, 3, SAA7146_GPIO_INPUT);
 
-	mwdebi(av7110, DEBISWAB, DPRAM_BASE, bootcode, sizeof(bootcode));
+	ret = request_firmware(&fw, fw_name, &dev->pci->dev);
+	if (ret) {
+		printk(KERN_ERR "dvb-ttpci: Failed to load firmware \"%s\"\n",
+			fw_name);
+		return ret;
+	}
+
+	mwdebi(av7110, DEBISWAB, DPRAM_BASE, fw->data, fw->size);
+	release_firmware(fw);
 	iwdebi(av7110, DEBINOSWAP, AV7110_BOOT_STATE, BOOTSTATE_BUFFER_FULL, 2);
 
 	if (saa7146_wait_for_debi_done(av7110->dev, 1)) {
@@ -302,7 +291,7 @@
 	av7110->arm_ready = 1;
 	return 0;
 }
-
+MODULE_FIRMWARE("av7110/bootcode.bin");
 
 /****************************************************************************
  * DEBI command polling
diff -ruN v4l-dvb-c29ce3e2fc6a/linux/drivers/media/dvb/ttpci/fdump.c v4l-dvb-0018ed9bbca3/linux/drivers/media/dvb/ttpci/fdump.c
--- v4l-dvb-c29ce3e2fc6a/linux/drivers/media/dvb/ttpci/fdump.c	2009-04-24 21:57:56.000000000 +0200
+++ v4l-dvb-0018ed9bbca3/linux/drivers/media/dvb/ttpci/fdump.c	1970-01-01 01:00:00.000000000 +0100
@@ -1,44 +0,0 @@
-#include <stdio.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <unistd.h>
-
-int main(int argc, char **argv)
-{
-    unsigned char buf[8];
-    unsigned int i, count, bytes = 0;
-    FILE *fd_in, *fd_out;
-
-    if (argc != 4) {
-	fprintf(stderr, "\n\tusage: %s <ucode.bin> <array_name> <output_name>\n\n", argv[0]);
-	return -1;
-    }
-
-    fd_in = fopen(argv[1], "rb");
-    if (fd_in == NULL) {
-	fprintf(stderr, "firmware file '%s' not found\n", argv[1]);
-	return -1;
-    }
-
-    fd_out = fopen(argv[3], "w+");
-    if (fd_out == NULL) {
-	fprintf(stderr, "cannot create output file '%s'\n", argv[3]);
-	return -1;
-    }
-
-    fprintf(fd_out, "\n#include <asm/types.h>\n\nu8 %s [] = {", argv[2]);
-
-    while ((count = fread(buf, 1, 8, fd_in)) > 0) {
-	fprintf(fd_out, "\n\t");
-	for (i = 0; i < count; i++, bytes++)
-	    fprintf(fd_out, "0x%02x, ", buf[i]);
-    }
-
-    fprintf(fd_out, "\n};\n\n");
-
-    fclose(fd_in);
-    fclose(fd_out);
-
-    return 0;
-}

--------------010702060408050205020900--
