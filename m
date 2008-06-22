Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jaswinder@infradead.org>) id 1KAPBa-0004DT-Gn
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 15:00:50 +0200
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-dvb <linux-dvb@linuxtv.org>,
	kernelnewbies <kernelnewbies@nl.linux.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <dwmw2@infradead.org>
Date: Sun, 22 Jun 2008 18:24:19 +0530
Message-Id: <1214139259.2994.8.camel@jaswinder.satnam>
Mime-Version: 1.0
Subject: [linux-dvb] [PATCH] Remove fdump tool for av7110 firmware
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

There's no point in this, since the user can use the BUILTIN_FIRMWARE
option to include arbitrary firmware files directly in the kernel image.

Thanks to David Woodhouse for help.

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
--
drivers/media/dvb/ttpci/Kconfig  |   23 +++----------------
drivers/media/dvb/ttpci/Makefile |    9 -------
drivers/media/dvb/ttpci/av7110.c |   16 -------------
drivers/media/dvb/ttpci/fdump.c    |   44 -------------------------------------
4 files changed, 4 insertions(+), 88 deletions(-)
diff --git a/drivers/media/dvb/ttpci/Kconfig b/drivers/media/dvb/ttpci/Kconfig
index e0bbcaf..6b7a586 100644
--- a/drivers/media/dvb/ttpci/Kconfig
+++ b/drivers/media/dvb/ttpci/Kconfig
@@ -6,7 +6,7 @@ config DVB_AV7110
 	tristate "AV7110 cards"
 	depends on DVB_CORE && PCI && I2C
 	depends on HOTPLUG
-	select FW_LOADER if !DVB_AV7110_FIRMWARE
+	select FW_LOADER
 	select TTPCI_EEPROM
 	select VIDEO_SAA7146_VV
 	depends on VIDEO_DEV	# dependencies of VIDEO_SAA7146_VV
@@ -30,6 +30,9 @@ config DVB_AV7110
 	  download/extract it, and then copy it to /usr/lib/hotplug/firmware
 	  or /lib/firmware (depending on configuration of firmware hotplug).
 
+	  Alternatively, you can download the file and use the 
+	  BUILTIN_FIRMWARE option to build it into your kernel image.
+
 	  Say Y if you own such a card and want to use it.
 
 config DVB_AV7110_BOOTCODE
@@ -39,24 +42,6 @@ config DVB_AV7110_BOOTCODE
 	  This includes firmware for AV7110 bootcode
 	  Say 'N' and let it get loaded from userspace on demand 
 
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
-
-	  All other people say N.
-
-config DVB_AV7110_FIRMWARE_FILE
-	string "Full pathname of av7110 firmware file"
-	depends on DVB_AV7110_FIRMWARE
-	default "/usr/lib/hotplug/firmware/dvb-ttpci-01.fw"
-
 config DVB_AV7110_OSD
 	bool "AV7110 OSD support"
 	depends on DVB_AV7110
diff --git a/drivers/media/dvb/ttpci/Makefile b/drivers/media/dvb/ttpci/Makefile
index d7483f1..a7ff3cd 100644
--- a/drivers/media/dvb/ttpci/Makefile
+++ b/drivers/media/dvb/ttpci/Makefile
@@ -14,12 +14,3 @@ obj-$(CONFIG_DVB_BUDGET_PATCH) += budget-patch.o
 obj-$(CONFIG_DVB_AV7110) += dvb-ttpci.o
 
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
-
-hostprogs-y	:= fdump
-
-ifeq ($(CONFIG_DVB_AV7110_FIRMWARE),y)
-$(obj)/av7110.o: $(obj)/av7110_firm.h
-
-$(obj)/av7110_firm.h: $(obj)/fdump
-	$(obj)/fdump $(CONFIG_DVB_AV7110_FIRMWARE_FILE) dvb_ttpci_fw $@
-endif
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 747e7f1..c11a13c 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -1497,20 +1497,6 @@ static int check_firmware(struct av7110* av7110)
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
@@ -1559,8 +1545,6 @@ static int get_firmware(struct av7110* av7110)
 	release_firmware(fw);
 	return ret;
 }
-#endif
-
 
 static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
 {
diff --git a/drivers/media/dvb/ttpci/fdump.c b/drivers/media/dvb/ttpci/fdump.c
deleted file mode 100644
index c90001d..0000000
--- a/drivers/media/dvb/ttpci/fdump.c
+++ /dev/null
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



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
