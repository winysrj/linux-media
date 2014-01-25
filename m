Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:51804 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaAYJ6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 04:58:04 -0500
Received: by mail-lb0-f173.google.com with SMTP id y6so3277930lbh.32
        for <linux-media@vger.kernel.org>; Sat, 25 Jan 2014 01:58:02 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Jarod Wilson <jarod@redhat.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [PATCH] nuvoton-cir: Don't touch PS/2 interrupts while initializing
Date: Sat, 25 Jan 2014 11:57:46 +0200
Message-Id: <1390643866-10350-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are reports[1] that on some motherboards loading the nuvoton-cir
disables PS/2 keyboard input. This is caused by an erroneous write of
CIR_INTR_MOUSE_IRQ_BIT to ACPI control register.

According to datasheet the write enables mouse power management event
interrupts which will probably have ill effects if the motherboard has
only one PS/2 port with keyboard in it.

The cir hardware does not need mouse interrupts to function and should
not touch them. This patch removes the illegal writes and registry
definitions.

[1] http://ubuntuforums.org/showthread.php?t=2106277&p=12461912&mode=threaded#post12461912

Reported-by: Bruno Maire <bruno.maire@besonet.ch>
Tested-by: Bruno Maire <bruno.maire@besonet.ch>
Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 4 ----
 drivers/media/rc/nuvoton-cir.h | 1 -
 2 files changed, 5 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 21ee0dc..b41e52e 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -330,9 +330,6 @@ static void nvt_cir_wake_ldev_init(struct nvt_dev *nvt)
 	/* Enable CIR Wake via PSOUT# (Pin60) */
 	nvt_set_reg_bit(nvt, CIR_WAKE_ENABLE_BIT, CR_ACPI_CIR_WAKE);
 
-	/* enable cir interrupt of mouse/keyboard IRQ event */
-	nvt_set_reg_bit(nvt, CIR_INTR_MOUSE_IRQ_BIT, CR_ACPI_IRQ_EVENTS);
-
 	/* enable pme interrupt of cir wakeup event */
 	nvt_set_reg_bit(nvt, PME_INTR_CIR_PASS_BIT, CR_ACPI_IRQ_EVENTS2);
 
@@ -456,7 +453,6 @@ static void nvt_enable_wake(struct nvt_dev *nvt)
 
 	nvt_select_logical_dev(nvt, LOGICAL_DEV_ACPI);
 	nvt_set_reg_bit(nvt, CIR_WAKE_ENABLE_BIT, CR_ACPI_CIR_WAKE);
-	nvt_set_reg_bit(nvt, CIR_INTR_MOUSE_IRQ_BIT, CR_ACPI_IRQ_EVENTS);
 	nvt_set_reg_bit(nvt, PME_INTR_CIR_PASS_BIT, CR_ACPI_IRQ_EVENTS2);
 
 	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR_WAKE);
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 07e8310..e1cf23c 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -363,7 +363,6 @@ struct nvt_dev {
 #define LOGICAL_DEV_ENABLE	0x01
 
 #define CIR_WAKE_ENABLE_BIT	0x08
-#define CIR_INTR_MOUSE_IRQ_BIT	0x80
 #define PME_INTR_CIR_PASS_BIT	0x08
 
 /* w83677hg CIR pin config */
-- 
1.8.3.2

