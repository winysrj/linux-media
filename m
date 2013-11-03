Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.swsoft.eu ([109.70.220.8]:51351 "EHLO relay.swsoft.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab3KCAfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 20:35:47 -0400
Received: from mail.swsoft.eu ([109.70.220.2])
	by relay.swsoft.eu with esmtps (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <mbroemme@parallels.com>)
	id 1VclfO-0001sx-Ac
	for linux-media@vger.kernel.org; Sun, 03 Nov 2013 01:35:46 +0100
Received: from parallels.com (cable-78-34-76-230.netcologne.de [78.34.76.230])
	by code.dyndns.org (Postfix) with ESMTPSA id 8D7CA140CAF	for
 <linux-media@vger.kernel.org>; Sun,  3 Nov 2013 01:35:45 +0100 (CET)
Date: Sun, 3 Nov 2013 01:35:45 +0100
From: Maik Broemme <mbroemme@parallels.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 07/12] ddbridge: Updated ddbridge registers
Message-ID: <20131103003545.GK7956@parallels.com>
References: <20131103002235.GD7956@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20131103002235.GD7956@parallels.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Updated ddbridge registers:

  - Added GPIO and MDIO registers
  - Added Clock Generator (Sil598 @ 0xAA I2c)
  - Added DAC (AD9781/AD9783 SPI)
  - Added Temperature Monitor (2x LM75A @ 0x90,0x92 I2c)
  - Added CI Interface (only CI-Bridge)
  - Added output control registers
  - Added modulator channels
  - Removed unneded defines (might be added later again if needed)

Signed-off-by: Maik Broemme <mbroemme@parallels.com>
---
 drivers/media/pci/ddbridge/ddbridge-regs.h | 273 ++++++++++++++++++-----------
 1 file changed, 168 insertions(+), 105 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-regs.h b/drivers/media/pci/ddbridge/ddbridge-regs.h
index a3ccb31..7d8bda4 100644
--- a/drivers/media/pci/ddbridge/ddbridge-regs.h
+++ b/drivers/media/pci/ddbridge/ddbridge-regs.h
@@ -1,47 +1,53 @@
 /*
- * ddbridge-regs.h: Digital Devices PCIe bridge driver
+ *  ddbridge-regs.h: Digital Devices PCIe bridge driver
  *
- * Copyright (C) 2010-2011 Digital Devices GmbH
+ *  Copyright (C) 2010-2013 Digital Devices GmbH
+ *  Copyright (C) 2013 Maik Broemme <mbroemme@parallels.com>
  *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 only, as published by the Free Software Foundation.
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  version 2 only, as published by the Free Software Foundation.
  *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
  *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA
- * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA
  */
 
-/* DD-DVBBridgeV1.h 273 2010-09-17 05:03:16Z manfred */
+#ifndef _DDBRIDGE_REGS_H_
+#define _DDBRIDGE_REGS_H_
 
 /* Register Definitions */
+#define CUR_REGISTERMAP_VERSION     0x10003
+#define CUR_REGISTERMAP_VERSION_CI  0x10000
+#define CUR_REGISTERMAP_VERSION_MOD 0x10000
 
-#define CUR_REGISTERMAP_VERSION 0x10000
-
-#define HARDWARE_VERSION       0x00
-#define REGISTERMAP_VERSION    0x04
+#define HARDWARE_VERSION            0x00
+#define REGISTERMAP_VERSION         0x04
 
-/* ------------------------------------------------------------------------- */
 /* SPI Controller */
+#define SPI_CONTROL      0x10
+#define SPI_DATA         0x14
 
-#define SPI_CONTROL     0x10
-#define SPI_DATA        0x14
+/* GPIO */
+#define GPIO_OUTPUT      0x20
+#define GPIO_DIRECTION   0x28
 
-/* ------------------------------------------------------------------------- */
+/* MDIO */
+#define MDIO_CTRL        0x20
+#define MDIO_ADR         0x24
+#define MDIO_REG         0x28
+#define MDIO_VAL         0x2C
 
-/* Interrupt controller                                     */
-/* How many MSI's are available depends on HW (Min 2 max 8) */
-/* How many are usable also depends on Host platform        */
+/* How many MSI's are available depends on HW (Min 2 max 8)
+   How many are usable also depends on Host platform */
 
+/* Interrupt controller */
 #define INTERRUPT_BASE   (0x40)
 
 #define INTERRUPT_ENABLE (INTERRUPT_BASE + 0x00)
@@ -57,95 +63,152 @@
 #define INTERRUPT_STATUS (INTERRUPT_BASE + 0x20)
 #define INTERRUPT_ACK    (INTERRUPT_BASE + 0x20)
 
-#define INTMASK_I2C1        (0x00000001)
-#define INTMASK_I2C2        (0x00000002)
-#define INTMASK_I2C3        (0x00000004)
-#define INTMASK_I2C4        (0x00000008)
-
-#define INTMASK_CIRQ1       (0x00000010)
-#define INTMASK_CIRQ2       (0x00000020)
-#define INTMASK_CIRQ3       (0x00000040)
-#define INTMASK_CIRQ4       (0x00000080)
-
-#define INTMASK_TSINPUT1    (0x00000100)
-#define INTMASK_TSINPUT2    (0x00000200)
-#define INTMASK_TSINPUT3    (0x00000400)
-#define INTMASK_TSINPUT4    (0x00000800)
-#define INTMASK_TSINPUT5    (0x00001000)
-#define INTMASK_TSINPUT6    (0x00002000)
-#define INTMASK_TSINPUT7    (0x00004000)
-#define INTMASK_TSINPUT8    (0x00008000)
-
-#define INTMASK_TSOUTPUT1   (0x00010000)
-#define INTMASK_TSOUTPUT2   (0x00020000)
-#define INTMASK_TSOUTPUT3   (0x00040000)
-#define INTMASK_TSOUTPUT4   (0x00080000)
-
-/* ------------------------------------------------------------------------- */
-/* I2C Master Controller */
-
-#define I2C_BASE        (0x80)  /* Byte offset */
-
-#define I2C_COMMAND     (0x00)
-#define I2C_TIMING      (0x04)
-#define I2C_TASKLENGTH  (0x08)     /* High read, low write */
-#define I2C_TASKADDRESS (0x0C)     /* High read, low write */
+/* Clock Generator (Sil598 @ 0xAA I2c) */
+#define CLOCKGEN_BASE       (0x80)
+#define CLOCKGEN_CONTROL    (CLOCKGEN_BASE + 0x00)
+#define CLOCKGEN_INDEX      (CLOCKGEN_BASE + 0x04)
+#define CLOCKGEN_WRITEDATA  (CLOCKGEN_BASE + 0x08)
+#define CLOCKGEN_READDATA   (CLOCKGEN_BASE + 0x0C)
 
-#define I2C_MONITOR     (0x1C)
+/* DAC (AD9781/AD9783 SPI) */
+#define DAC_BASE            (0x090)
+#define DAC_CONTROL         (DAC_BASE)
+#define DAC_WRITE_DATA      (DAC_BASE+4)
+#define DAC_READ_DATA       (DAC_BASE+8)
 
-#define I2C_BASE_1      (I2C_BASE + 0x00)
-#define I2C_BASE_2      (I2C_BASE + 0x20)
-#define I2C_BASE_3      (I2C_BASE + 0x40)
-#define I2C_BASE_4      (I2C_BASE + 0x60)
+#define DAC_CONTROL_STARTIO (0x100)
+#define DAC_CONTROL_RESET   (0x200)
 
-#define I2C_BASE_N(i)   (I2C_BASE + (i) * 0x20)
+/* Temperature Monitor (2x LM75A @ 0x90,0x92 I2c) */
+#define TEMPMON_BASE        (0xA0)
+#define TEMPMON_CONTROL     (TEMPMON_BASE + 0x00)
+#define TEMPMON_SENSOR1     (TEMPMON_BASE + 0x08)    // SHORT Temperature in °C x 256
+#define TEMPMON_SENSOR2     (TEMPMON_BASE + 0x0C)    // SHORT Temperature in °C x 256
 
-#define I2C_TASKMEM_BASE    (0x1000)    /* Byte offset */
-#define I2C_TASKMEM_SIZE    (0x1000)
-
-#define I2C_SPEED_400   (0x04030404)
-#define I2C_SPEED_200   (0x09080909)
-#define I2C_SPEED_154   (0x0C0B0C0C)
-#define I2C_SPEED_100   (0x13121313)
-#define I2C_SPEED_77    (0x19181919)
-#define I2C_SPEED_50    (0x27262727)
-
-
-/* ------------------------------------------------------------------------- */
-/* DMA  Controller */
-
-#define DMA_BASE_WRITE        (0x100)
-#define DMA_BASE_READ         (0x140)
+/* I2C Master Controller */
+#define I2C_BASE            (0x80)   /* Byte offset */
 
-#define DMA_CONTROL     (0x00)                  /* 64 */
-#define DMA_ERROR       (0x04)                  /* 65 ( only read instance ) */
+#define I2C_COMMAND         (0x00)
+#define I2C_TIMING          (0x04)
+#define I2C_TASKLENGTH      (0x08)   /* High read, low write */
+#define I2C_TASKADDRESS     (0x0C)   /* High read, low write */
+#define I2C_TASKMEM_BASE    (0x1000) /* Byte offset */
+#define I2C_TASKMEM_SIZE    (0x0800)
 
-#define DMA_DIAG_CONTROL                (0x1C)  /* 71 */
-#define DMA_DIAG_PACKETCOUNTER_LOW      (0x20)  /* 72 */
-#define DMA_DIAG_PACKETCOUNTER_HIGH     (0x24)  /* 73 */
-#define DMA_DIAG_TIMECOUNTER_LOW        (0x28)  /* 74 */
-#define DMA_DIAG_TIMECOUNTER_HIGH       (0x2C)  /* 75 */
-#define DMA_DIAG_RECHECKCOUNTER         (0x30)  /* 76  ( Split completions on read ) */
-#define DMA_DIAG_WAITTIMEOUTINIT        (0x34)  /* 77 */
-#define DMA_DIAG_WAITOVERFLOWCOUNTER    (0x38)  /* 78 */
-#define DMA_DIAG_WAITCOUNTER            (0x3C)  /* 79 */
+#define I2C_SPEED_400       (0x04030404)
+#define I2C_SPEED_100       (0x13121313)
 
-/* ------------------------------------------------------------------------- */
-/* DMA  Buffer */
+/* DMA Controller */
+#define DMA_BASE_WRITE      (0x100)
+#define DMA_BASE_READ       (0x140)
 
+/* DMA Buffer */
 #define TS_INPUT_BASE       (0x200)
-#define TS_INPUT_CONTROL(i)         (TS_INPUT_BASE + (i) * 16 + 0x00)
+#define TS_INPUT_CONTROL(i)         (TS_INPUT_BASE + (i) * 0x10 + 0x00) 
+#define TS_INPUT_CONTROL2(i)        (TS_INPUT_BASE + (i) * 0x10 + 0x04) 
 
-#define TS_OUTPUT_BASE       (0x280)
-#define TS_OUTPUT_CONTROL(i)         (TS_OUTPUT_BASE + (i) * 16 + 0x00)
+#define TS_OUTPUT_BASE      (0x280)
+#define TS_OUTPUT_CONTROL(i)        (TS_OUTPUT_BASE + (i) * 0x10 + 0x00) 
+#define TS_OUTPUT_CONTROL2(i)       (TS_OUTPUT_BASE + (i) * 0x10 + 0x04) 
 
 #define DMA_BUFFER_BASE     (0x300)
-
-#define DMA_BUFFER_CONTROL(i)       (DMA_BUFFER_BASE + (i) * 16 + 0x00)
-#define DMA_BUFFER_ACK(i)           (DMA_BUFFER_BASE + (i) * 16 + 0x04)
-#define DMA_BUFFER_CURRENT(i)       (DMA_BUFFER_BASE + (i) * 16 + 0x08)
-#define DMA_BUFFER_SIZE(i)          (DMA_BUFFER_BASE + (i) * 16 + 0x0c)
+#define DMA_BUFFER_CONTROL(i)       (DMA_BUFFER_BASE + (i) * 0x10 + 0x00) 
+#define DMA_BUFFER_ACK(i)           (DMA_BUFFER_BASE + (i) * 0x10 + 0x04)
+#define DMA_BUFFER_CURRENT(i)       (DMA_BUFFER_BASE + (i) * 0x10 + 0x08)
+#define DMA_BUFFER_SIZE(i)          (DMA_BUFFER_BASE + (i) * 0x10 + 0x0c)
 
 #define DMA_BASE_ADDRESS_TABLE  (0x2000)
-#define DMA_BASE_ADDRESS_TABLE_ENTRIES (512)
 
+/* CI Interface (only CI-Bridge) */
+#define CI_BASE                     (0x400)
+#define CI_CONTROL(i)               (CI_BASE + (i) * 32 + 0x00)
+
+#define CI_DO_ATTRIBUTE_RW(i)       (CI_BASE + (i) * 32 + 0x04)
+#define CI_DO_IO_RW(i)              (CI_BASE + (i) * 32 + 0x08)
+#define CI_READDATA(i)              (CI_BASE + (i) * 32 + 0x0c)
+#define CI_DO_READ_ATTRIBUTES(i)    (CI_BASE + (i) * 32 + 0x10)
+
+#define CI_RESET_CAM                    (0x00000001)
+#define CI_POWER_ON                     (0x00000002)
+#define CI_ENABLE                       (0x00000004)
+#define CI_BYPASS_DISABLE               (0x00000010)
+
+#define CI_CAM_READY                    (0x00010000)
+#define CI_CAM_DETECT                   (0x00020000)
+#define CI_READY                        (0x80000000)
+
+#define CI_READ_CMD                     (0x40000000)
+#define CI_WRITE_CMD                    (0x80000000)
+
+#define CI_BUFFER_BASE                  (0x3000)
+#define CI_BUFFER_SIZE                  (0x0800)
+
+#define CI_BUFFER(i)                    (CI_BUFFER_BASE + (i) * CI_BUFFER_SIZE )
+
+#define VCO1_BASE           (0xC0)
+#define VCO1_CONTROL        (VCO1_BASE + 0x00)
+#define VCO1_DATA           (VCO1_BASE + 0x04)  // 24 Bit
+#define VCO1_CONTROL_WRITE  (0x00000001)   // 1 = Trigger write, resets when done
+#define VCO1_CONTROL_CE     (0x00000002)   // 0 = Put VCO into power down
+
+#define VCO2_BASE           (0xC8)
+#define VCO2_CONTROL        (VCO2_BASE + 0x00)
+#define VCO2_DATA           (VCO2_BASE + 0x04)  // 24 Bit
+#define VCO2_CONTROL_WRITE  (0x00000001)   // 1 = Trigger write, resets when done
+#define VCO2_CONTROL_CE     (0x00000002)   // 0 = Put VCO into power down
+
+#define VCO3_BASE           (0xD0)
+#define VCO3_CONTROL        (VCO3_BASE + 0x00)
+#define VCO3_DATA           (VCO3_BASE + 0x04)  // 32 Bit
+#define VCO3_CONTROL_WRITE  (0x00000001)   // 1 = Trigger write, resets when done
+#define VCO3_CONTROL_CE     (0x00000002)   // 0 = Put VCO into power down
+
+#define RF_ATTENUATOR   (0xD8)
+
+/* Output control */
+#define IQOUTPUT_BASE           (0x240)
+#define IQOUTPUT_CONTROL        (IQOUTPUT_BASE + 0x00)
+#define IQOUTPUT_CONTROL2       (IQOUTPUT_BASE + 0x04)    
+#define IQOUTPUT_POSTSCALER     (IQOUTPUT_BASE + 0x0C)
+#define IQOUTPUT_PRESCALER      (IQOUTPUT_BASE + 0x10)
+
+#define IQOUTPUT_EQUALIZER_0    (IQOUTPUT_BASE + 0x14)
+
+#define IQOUTPUT_CONTROL_RESET              (0x00000001)
+#define IQOUTPUT_CONTROL_ENABLE             (0x00000002)
+#define IQOUTPUT_CONTROL_BYPASS_EQUALIZER   (0x00000010)
+
+#define MODULATOR_BASE            (0x200)
+#define MODULATOR_CONTROL         (MODULATOR_BASE)
+#define MODULATOR_IQTABLE_END     (MODULATOR_BASE+4)
+#define MODULATOR_IQTABLE_INDEX   (MODULATOR_BASE+8)
+#define MODULATOR_IQTABLE_DATA    (MODULATOR_BASE+12)
+
+#define MODULATOR_IQTABLE_INDEX_IQ_MASK       ( 0x00008000 )
+#define MODULATOR_IQTABLE_INDEX_SEL_I         ( 0x00000000 )
+#define MODULATOR_IQTABLE_INDEX_SEL_Q         ( MODULATOR_IQTABLE_INDEX_IQ_MASK )
+
+/* Modulator Channels */
+#define CHANNEL_BASE                (0x400)
+#define CHANNEL_CONTROL(i)          (CHANNEL_BASE + (i) * 64 + 0x00)
+#define CHANNEL_SETTINGS(i)         (CHANNEL_BASE + (i) * 64 + 0x04)
+#define CHANNEL_RATE_INCR(i)        (CHANNEL_BASE + (i) * 64 + 0x0C)
+#define CHANNEL_PCR_ADJUST_OUTL(i)  (CHANNEL_BASE + (i) * 64 + 0x10)
+#define CHANNEL_PCR_ADJUST_OUTH(i)  (CHANNEL_BASE + (i) * 64 + 0x14)
+#define CHANNEL_PCR_ADJUST_INL(i)   (CHANNEL_BASE + (i) * 64 + 0x18)
+#define CHANNEL_PCR_ADJUST_INH(i)   (CHANNEL_BASE + (i) * 64 + 0x1C)
+#define CHANNEL_PCR_ADJUST_ACCUL(i) (CHANNEL_BASE + (i) * 64 + 0x20)
+#define CHANNEL_PCR_ADJUST_ACCUH(i) (CHANNEL_BASE + (i) * 64 + 0x24)
+#define CHANNEL_PKT_COUNT_OUT(i)    (CHANNEL_BASE + (i) * 64 + 0x28)
+#define CHANNEL_PKT_COUNT_IN(i)     (CHANNEL_BASE + (i) * 64 + 0x2C)
+
+#define CHANNEL_CONTROL_RESET               (0x00000001)
+#define CHANNEL_CONTROL_ENABLE_DVB          (0x00000002)
+#define CHANNEL_CONTROL_ENABLE_IQ           (0x00000004)
+#define CHANNEL_CONTROL_ENABLE_SOURCE       (0x00000008)
+#define CHANNEL_CONTROL_ENABLE_PCRADJUST    (0x00000010)
+#define CHANNEL_CONTROL_FREEZE_STATUS       (0x00000100)
+
+#define CHANNEL_CONTROL_BUSY                (0x01000000)
+
+#endif
-- 
1.8.4.2
