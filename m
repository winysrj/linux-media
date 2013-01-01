Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:56237 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3AAXVX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jan 2013 18:21:23 -0500
Received: by mail-we0-f169.google.com with SMTP id t49so6695952wey.28
        for <linux-media@vger.kernel.org>; Tue, 01 Jan 2013 15:21:22 -0800 (PST)
Message-ID: <50E36F6F.8090301@gmail.com>
Date: Wed, 02 Jan 2013 00:21:19 +0100
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: j@jannau.net, jarod@redhat.com
Subject: [PATCH] crystalhd git.linuxtv.org kernel driver: crystalhd BC (not
 staging) driver-, examples-, section mismatch-. udev- fixes. v3.10.1
Content-Type: multipart/mixed;
 boundary="------------040507050304040804020009"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040507050304040804020009
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello guys,

I'm working on supporting BCM 970012/15 crystalhd decoder and
can't find where to report bugs of
http://git.linuxtv.org/jarod/crystalhd.git
<devinheitmueller> I think he just borrowed our git server.

and send patches.

So I borrow this list to get more developers, testers and sw- quality guys in until the maintainers in CC say where the right place is.

Patch for crystalhd 3.10.1 attached.

y
tom

-Att: Statuslogs, still no go on x86_64 kernel with x86_32 userspace, PCI-E errors with 00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03):


Jan  2 00:00:55 tom3 kernel: [ 5910.428529] Unloading crystalhd 3.10.0
Jan  2 00:00:55 tom3 kernel: [ 5910.429683] crystalhd 0000:03:00.0: released api device - 250
Jan  2 00:01:00 tom3 kernel: [ 5914.673159] Loading crystalhd v3.10.1
Jan  2 00:01:00 tom3 kernel: [ 5914.673334] crystalhd 0000:03:00.0: Starting Device:0x1612
Jan  2 00:01:00 tom3 kernel: [ 5914.677823] crystalhd 0000:03:00.0: irq 52 for MSI/MSI-X
Jan  2 00:01:00 tom3 kernel: [ 5914.932221] crystalhd 0000:03:00.0: enabling bus mastering
Jan  2 00:01:12 tom3 kernel: [ 5927.335471] crystalhd 0000:03:00.0: Opening new user[0] handle
Jan  2 00:01:13 tom3 kernel: [ 5927.683262] crystalhd 0000:03:00.0: Closing user[0] handle with mode ffffffff

# hellobcm
starting up
Running DIL (3.22.0) Version
DtsDeviceOpen: Opening HW in mode 0
IOCTL Command Failed -1 cmd c2186201 sts 0
DtsGetHwType: Ioctl failed: -1
Get Hardware Type Failed
IOCTL Command Failed -1 cmd c2186211 sts 0
DtsGetDriveStats: Ioctl failed: -1
txThreadProc: Got status -1 from GetDriverStatus
IOCTL Command Failed -1 cmd c2186210 sts 0
DtsAllocIoctlData Error
IOCTL Command Failed -1 cmd c2186214 sts 0
DtsReleaseUserHandle: Ioctl failed: -1
Unable to detach from Dil shared memory ...
DtsDelDilShMem:Unable get shmid ...
crap, DtsDeviceOpen failed
Failed to open device

# lspci -vvvnnn -s 03:00.0
03:00.0 Multimedia controller [0480]: Broadcom Corporation BCM70012 Video Decoder [Crystal HD] [14e4:1612] (rev 01)
	Subsystem: Broadcom Corporation Device [14e4:2612]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR+ <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 52
	Region 0: Memory at deff0000 (64-bit, non-prefetchable) [size=64K]
	Region 2: Memory at df000000 (64-bit, non-prefetchable) [size=4M]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [60] Vendor Specific Information: Len=6c <?>
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4183
	Capabilities: [cc] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [13c v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Capabilities: [16c v1] Power Budgeting <?>
	Kernel driver in use: crystalhd







--------------040507050304040804020009
Content-Type: text/x-diff;
 name="crystalhd-examples-secmismatch-udev-fixes.schorpp.02.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="crystalhd-examples-secmismatch-udev-fixes.schorpp.02.patch"

diff --git a/driver/linux/20-crystalhd.rules b/driver/linux/20-crystalhd.rules
index 93b21b8..11ef3fc 100644
--- a/driver/linux/20-crystalhd.rules
+++ b/driver/linux/20-crystalhd.rules
@@ -1 +1,2 @@
-KERNEL=="crystalhd", MODE="0666"
+KERNEL=="crystalhd", MODE="0660" GROUP="video"
+
diff --git a/driver/linux/crystalhd_lnx.c b/driver/linux/crystalhd_lnx.c
index 64e66ad..7b7130e 100644
--- a/driver/linux/crystalhd_lnx.c
+++ b/driver/linux/crystalhd_lnx.c
@@ -498,7 +498,7 @@ fail:
 	return rc;
 }
 
-static void __devexit chd_dec_release_chdev(struct crystalhd_adp *adp)
+static void chd_dec_release_chdev(struct crystalhd_adp *adp)
 {
 	crystalhd_ioctl_data *temp = NULL;
 	if (!adp)
@@ -582,7 +582,7 @@ static int __devinit chd_pci_reserve_mem(struct crystalhd_adp *pinfo)
 	return 0;
 }
 
-static void __devexit chd_pci_release_mem(struct crystalhd_adp *pinfo)
+static void chd_pci_release_mem(struct crystalhd_adp *pinfo)
 {
 	if (!pinfo)
 		return;
diff --git a/examples/Makefile b/examples/Makefile
index 58bf57f..22704d3 100644
--- a/examples/Makefile
+++ b/examples/Makefile
@@ -1,5 +1,5 @@
 CPP := g++
-CPPFLAGS += -D__LINUX_USER__
+CPPFLAGS += -D__LINUX_USER__ -g3 -O0
 LDFLAGS += -lcrystalhd -lpthread
 INCLUDES += -I../include/ -I../linux_lib/libcrystalhd/
 
diff --git a/examples/hellobcm.cpp b/examples/hellobcm.cpp
index 76f53f9..3be04c6 100644
--- a/examples/hellobcm.cpp
+++ b/examples/hellobcm.cpp
@@ -1,6 +1,7 @@
 #include <stdlib.h>
 #include <stdio.h>
 #include <stdint.h>
+#include <unistd.h>
 #include <string.h>
 #include <semaphore.h>
 #include "bc_dts_types.h"
@@ -70,7 +71,7 @@ int main()
     printf("try calls done\n");
 
     // Open the input stream
-    inFile.open("/tmp/test_video.264", std::ios::in | std::ios::binary);
+    inFile.open("./test_video.264", std::ios::in | std::ios::binary);
     if (!inFile.is_open())
       throw "Unable to open input file";
     else
diff --git a/examples/mpeg2test.cpp b/examples/mpeg2test.cpp
index 916085c..3faf8ec 100644
--- a/examples/mpeg2test.cpp
+++ b/examples/mpeg2test.cpp
@@ -1,6 +1,7 @@
 #include <stdlib.h>
 #include <stdio.h>
 #include <stdint.h>
+#include <unistd.h>
 #include <string.h>
 #include <semaphore.h>
 #include <iostream>
diff --git a/include/bc_dts_glob_lnx.h b/include/bc_dts_glob_lnx.h
index 9b74882..b90f796 100644
--- a/include/bc_dts_glob_lnx.h
+++ b/include/bc_dts_glob_lnx.h
@@ -324,7 +324,7 @@ typedef struct _crystalhd_ioctl_data {
 enum _crystalhd_kmod_ver{
 	crystalhd_kmod_major	= 3,
 	crystalhd_kmod_minor	= 10,
-	crystalhd_kmod_rev		= 0,
+	crystalhd_kmod_rev		= 1,
 };
 
 

--------------040507050304040804020009--
