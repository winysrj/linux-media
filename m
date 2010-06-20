Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:42561 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab0FTRVe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jun 2010 13:21:34 -0400
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH 2/2] DVB/V4L: mantis: remove unused files
Date: Sun, 20 Jun 2010 19:21:27 +0200
Message-Id: <1277054487-14384-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The files mantis_core.c and mantis_core.h are not used anywhere, so
delete them

Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/media/dvb/mantis/mantis_core.c |  238 --------------------------------
 drivers/media/dvb/mantis/mantis_core.h |   57 --------
 2 files changed, 0 insertions(+), 295 deletions(-)
 delete mode 100644 drivers/media/dvb/mantis/mantis_core.c
 delete mode 100644 drivers/media/dvb/mantis/mantis_core.h

diff --git a/drivers/media/dvb/mantis/mantis_core.c b/drivers/media/dvb/mantis/mantis_core.c
deleted file mode 100644
index 8113b23..0000000
--- a/drivers/media/dvb/mantis/mantis_core.c
+++ /dev/null
@@ -1,238 +0,0 @@
-/*
-	Mantis PCI bridge driver
-
-	Copyright (C) Manu Abraham (abraham.manu@gmail.com)
-
-	This program is free software; you can redistribute it and/or modify
-	it under the terms of the GNU General Public License as published by
-	the Free Software Foundation; either version 2 of the License, or
-	(at your option) any later version.
-
-	This program is distributed in the hope that it will be useful,
-	but WITHOUT ANY WARRANTY; without even the implied warranty of
-	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-	GNU General Public License for more details.
-
-	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the Free Software
-	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
-#include "mantis_common.h"
-#include "mantis_core.h"
-#include "mantis_vp1033.h"
-#include "mantis_vp1034.h"
-#include "mantis_vp1041.h"
-#include "mantis_vp2033.h"
-#include "mantis_vp2040.h"
-#include "mantis_vp3030.h"
-
-static int read_eeprom_byte(struct mantis_pci *mantis, u8 *data, u8 length)
-{
-	int err;
-	struct i2c_msg msg[] = {
-		{
-			.addr = 0x50,
-			.flags = 0,
-			.buf = data,
-			.len = 1
-		}, {
-			.addr = 0x50,
-			.flags = I2C_M_RD,
-			.buf = data,
-			.len = length
-		},
-	};
-
-	err = i2c_transfer(&mantis->adapter, msg, 2);
-	if (err < 0) {
-		dprintk(verbose, MANTIS_ERROR, 1,
-			"ERROR: i2c read: < err=%i d0=0x%02x d1=0x%02x >",
-			err, data[0], data[1]);
-
-		return err;
-	}
-
-	return 0;
-}
-
-static int write_eeprom_byte(struct mantis_pci *mantis, u8 *data, u8 length)
-{
-	int err;
-
-	struct i2c_msg msg = {
-		.addr = 0x50,
-		.flags = 0,
-		.buf = data,
-		.len = length
-	};
-
-	err = i2c_transfer(&mantis->adapter, &msg, 1);
-	if (err < 0) {
-		dprintk(verbose, MANTIS_ERROR, 1,
-			"ERROR: i2c write: < err=%i length=0x%02x d0=0x%02x, d1=0x%02x >",
-			err, length, data[0], data[1]);
-
-		return err;
-	}
-
-	return 0;
-}
-
-static int get_mac_address(struct mantis_pci *mantis)
-{
-	int err;
-
-	mantis->mac_address[0] = 0x08;
-	err = read_eeprom_byte(mantis, &mantis->mac_address[0], 6);
-	if (err < 0) {
-		dprintk(verbose, MANTIS_ERROR, 1, "Mantis EEPROM read error");
-
-		return err;
-	}
-	dprintk(verbose, MANTIS_ERROR, 0,
-		"    MAC Address=[%02x:%02x:%02x:%02x:%02x:%02x]\n",
-		mantis->mac_address[0], mantis->mac_address[1],
-		mantis->mac_address[2],	mantis->mac_address[3],
-		mantis->mac_address[4], mantis->mac_address[5]);
-
-	return 0;
-}
-
-#define MANTIS_MODEL_UNKNOWN	"UNKNOWN"
-#define MANTIS_DEV_UNKNOWN	"UNKNOWN"
-
-struct mantis_hwconfig unknown_device = {
-	.model_name	= MANTIS_MODEL_UNKNOWN,
-	.dev_type	= MANTIS_DEV_UNKNOWN,
-};
-
-static void mantis_load_config(struct mantis_pci *mantis)
-{
-	switch (mantis->subsystem_device) {
-	case MANTIS_VP_1033_DVB_S:	/* VP-1033 */
-		mantis->hwconfig = &vp1033_mantis_config;
-		break;
-	case MANTIS_VP_1034_DVB_S:	/* VP-1034 */
-		mantis->hwconfig = &vp1034_mantis_config;
-		break;
-	case MANTIS_VP_1041_DVB_S2:	/* VP-1041 */
-	case TECHNISAT_SKYSTAR_HD2:
-		mantis->hwconfig = &vp1041_mantis_config;
-		break;
-	case MANTIS_VP_2033_DVB_C:	/* VP-2033 */
-		mantis->hwconfig = &vp2033_mantis_config;
-		break;
-	case MANTIS_VP_2040_DVB_C:	/* VP-2040 */
-	case TERRATEC_CINERGY_C_PCI:	/* VP-2040 clone */
-	case TECHNISAT_CABLESTAR_HD2:
-		mantis->hwconfig = &vp2040_mantis_config;
-		break;
-	case MANTIS_VP_3030_DVB_T:	/* VP-3030 */
-		mantis->hwconfig = &vp3030_mantis_config;
-		break;
-	default:
-		mantis->hwconfig = &unknown_device;
-		break;
-	}
-}
-
-int mantis_core_init(struct mantis_pci *mantis)
-{
-	int err = 0;
-
-	mantis_load_config(mantis);
-	dprintk(verbose, MANTIS_ERROR, 0, "found a %s PCI %s device on (%02x:%02x.%x),\n",
-		mantis->hwconfig->model_name, mantis->hwconfig->dev_type,
-		mantis->pdev->bus->number, PCI_SLOT(mantis->pdev->devfn), PCI_FUNC(mantis->pdev->devfn));
-	dprintk(verbose, MANTIS_ERROR, 0, "    Mantis Rev %d [%04x:%04x], ",
-		mantis->revision,
-		mantis->subsystem_vendor, mantis->subsystem_device);
-	dprintk(verbose, MANTIS_ERROR, 0,
-		"irq: %d, latency: %d\n    memory: 0x%lx, mmio: 0x%p\n",
-		mantis->pdev->irq, mantis->latency,
-		mantis->mantis_addr, mantis->mantis_mmio);
-
-	err = mantis_i2c_init(mantis);
-	if (err < 0) {
-		dprintk(verbose, MANTIS_ERROR, 1, "Mantis I2C init failed");
-		return err;
-	}
-	err = get_mac_address(mantis);
-	if (err < 0) {
-		dprintk(verbose, MANTIS_ERROR, 1, "get MAC address failed");
-		return err;
-	}
-	err = mantis_dma_init(mantis);
-	if (err < 0) {
-		dprintk(verbose, MANTIS_ERROR, 1, "Mantis DMA init failed");
-		return err;
-	}
-	err = mantis_dvb_init(mantis);
-	if (err < 0) {
-		dprintk(verbose, MANTIS_DEBUG, 1, "Mantis DVB init failed");
-		return err;
-	}
-	err = mantis_uart_init(mantis);
-	if (err < 0) {
-		dprintk(verbose, MANTIS_DEBUG, 1, "Mantis UART init failed");
-		return err;
-	}
-
-	return 0;
-}
-
-int mantis_core_exit(struct mantis_pci *mantis)
-{
-	mantis_dma_stop(mantis);
-	dprintk(verbose, MANTIS_ERROR, 1, "DMA engine stopping");
-
-	mantis_uart_exit(mantis);
-	dprintk(verbose, MANTIS_ERROR, 1, "UART exit failed");
-
-	if (mantis_dma_exit(mantis) < 0)
-		dprintk(verbose, MANTIS_ERROR, 1, "DMA exit failed");
-	if (mantis_dvb_exit(mantis) < 0)
-		dprintk(verbose, MANTIS_ERROR, 1, "DVB exit failed");
-	if (mantis_i2c_exit(mantis) < 0)
-		dprintk(verbose, MANTIS_ERROR, 1, "I2C adapter delete.. failed");
-
-	return 0;
-}
-
-/* Turn the given bit on or off. */
-void gpio_set_bits(struct mantis_pci *mantis, u32 bitpos, u8 value)
-{
-	u32 cur;
-
-	cur = mmread(MANTIS_GPIF_ADDR);
-	if (value)
-		mantis->gpio_status = cur | (1 << bitpos);
-	else
-		mantis->gpio_status = cur & (~(1 << bitpos));
-
-	mmwrite(mantis->gpio_status, MANTIS_GPIF_ADDR);
-	mmwrite(0x00, MANTIS_GPIF_DOUT);
-	udelay(100);
-}
-
-/* direction = 0 , no CI passthrough ; 1 , CI passthrough */
-void mantis_set_direction(struct mantis_pci *mantis, int direction)
-{
-	u32 reg;
-
-	reg = mmread(0x28);
-	dprintk(verbose, MANTIS_DEBUG, 1, "TS direction setup");
-	if (direction == 0x01) {
-		/* to CI */
-		reg |= 0x04;
-		mmwrite(reg, 0x28);
-		reg &= 0xff - 0x04;
-		mmwrite(reg, 0x28);
-	} else {
-		reg &= 0xff - 0x04;
-		mmwrite(reg, 0x28);
-		reg |= 0x04;
-		mmwrite(reg, 0x28);
-	}
-}
diff --git a/drivers/media/dvb/mantis/mantis_core.h b/drivers/media/dvb/mantis/mantis_core.h
deleted file mode 100644
index 833ee42..0000000
--- a/drivers/media/dvb/mantis/mantis_core.h
+++ /dev/null
@@ -1,57 +0,0 @@
-/*
-	Mantis PCI bridge driver
-
-	Copyright (C) Manu Abraham (abraham.manu@gmail.com)
-
-	This program is free software; you can redistribute it and/or modify
-	it under the terms of the GNU General Public License as published by
-	the Free Software Foundation; either version 2 of the License, or
-	(at your option) any later version.
-
-	This program is distributed in the hope that it will be useful,
-	but WITHOUT ANY WARRANTY; without even the implied warranty of
-	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-	GNU General Public License for more details.
-
-	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the Free Software
-	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
-#ifndef __MANTIS_CORE_H
-#define __MANTIS_CORE_H
-
-#include "mantis_common.h"
-
-
-#define FE_TYPE_SAT	0
-#define FE_TYPE_CAB	1
-#define FE_TYPE_TER	2
-
-#define FE_TYPE_TS204	0
-#define FE_TYPE_TS188	1
-
-
-struct vendorname {
-	u8  *sub_vendor_name;
-	u32 sub_vendor_id;
-};
-
-struct devicetype {
-	u8  *sub_device_name;
-	u32 sub_device_id;
-	u8  device_type;
-	u32 type_flags;
-};
-
-
-extern int mantis_dma_init(struct mantis_pci *mantis);
-extern int mantis_dma_exit(struct mantis_pci *mantis);
-extern void mantis_dma_start(struct mantis_pci *mantis);
-extern void mantis_dma_stop(struct mantis_pci *mantis);
-extern int mantis_i2c_init(struct mantis_pci *mantis);
-extern int mantis_i2c_exit(struct mantis_pci *mantis);
-extern int mantis_core_init(struct mantis_pci *mantis);
-extern int mantis_core_exit(struct mantis_pci *mantis);
-
-#endif /* __MANTIS_CORE_H */
-- 
1.7.1

