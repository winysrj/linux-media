Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.astim.si ([93.103.6.239]:43849 "EHLO mail.astim.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbcE1Pev (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2016 11:34:51 -0400
Received: from PCSaso ([192.168.10.2])
	by mail.astim.si (8.14.4/8.14.4) with ESMTP id u4SFYmgR036071
	for <linux-media@vger.kernel.org>; Sat, 28 May 2016 17:34:48 +0200
From: "Saso Slavicic" <saso.linux@astim.si>
To: <linux-media@vger.kernel.org>
References: <001001d1b8c5$e8d905a0$ba8b10e0$@astim.si>
In-Reply-To: <001001d1b8c5$e8d905a0$ba8b10e0$@astim.si>
Subject: RE: netup_unidvb CI problem
Date: Sat, 28 May 2016 17:34:40 +0200
Message-ID: <000001d1b8f6$738cd4d0$5aa67e70$@astim.si>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: sl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Another bug in the driver.
According to Netup 2014 drivers, the attributes should be read from _config
not _io

--- drivers/media/pci/netup_unidvb/netup_unidvb_ci.c.orig	2016-05-28
17:16:07.073608043 +0200
+++ drivers/media/pci/netup_unidvb/netup_unidvb_ci.c	2016-05-28
17:16:33.970418997 +0200
@@ -147,7 +147,7 @@
 {
 	struct netup_ci_state *state = en50221->data;
 	struct netup_unidvb_dev *dev = state->dev;
-	u8 val = *((u8 __force *)state->membase8_io + addr);
+	u8 val = *((u8 __force *)state->membase8_config + addr);
 
 	dev_dbg(&dev->pci_dev->dev,
 		"%s(): addr=0x%x val=0x%x\n", __func__, addr, val);
@@ -162,7 +162,7 @@
 
 	dev_dbg(&dev->pci_dev->dev,
 		"%s(): addr=0x%x data=0x%x\n", __func__, addr, data);
-	*((u8 __force *)state->membase8_io + addr) = data;
+	*((u8 __force *)state->membase8_config + addr) = data;
 	return 0;
 }


# rmmod netup_unidvb
# insmod netup-unidvb-vanilla.ko
# dmesg | grep dvb_ca
[ 3997.014209] dvb_ca adapter 1: Invalid PC card inserted :(
[ 3997.691264] dvb_ca adapter 0: Invalid PC card inserted :(
# rmmod netup-unidvb
# insmod netup-unidvb-patched.ko
# dmesg | grep dvb_ca
[ 4030.205352] dvb_ca adapter 1: DVB CAM detected and initialised
successfully
[ 4030.476391] dvb_ca adapter 0: DVB CAM detected and initialised
successfully

Cheers,
Saso Slavicic

