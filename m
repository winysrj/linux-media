Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab0CKN0z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 08:26:55 -0500
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2BDQtHS009760
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 11 Mar 2010 08:26:55 -0500
Received: from pedra (vpn-234-51.phx2.redhat.com [10.3.234.51])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o2BDQqeu015794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 11 Mar 2010 08:26:54 -0500
Date: Thu, 11 Mar 2010 10:26:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/7] V4L/DVB: tm6000: Replace naming convention for
 registers of req 05 group
Message-ID: <20100311102645.1d4cb95a@pedra>
In-Reply-To: <cover.1268311636.git.mchehab@redhat.com>
References: <cover.1268311636.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After looking at the "magic" registers, it is clear that usb registers
belong to request 5.

Replace them with this script:

cat /tmp/reg3 |perl -ne 'if (m/define (TM6000_U_)([^\s]+)\s+0x([A-F0-9].)/) { \
$name=$2; $val=$3; printf "s,$1$2,TM6010_REQ05_R%s_%s,g\n", $val, $name; }' >a;
sed -f a tm6000-regs.h >b; mv b tm6000-regs.h

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-regs.h b/drivers/staging/tm6000/tm6000-regs.h
index 631984a..6be16b7 100644
--- a/drivers/staging/tm6000/tm6000-regs.h
+++ b/drivers/staging/tm6000/tm6000-regs.h
@@ -280,202 +280,202 @@ enum {
 #define TM6010_REQ07_RFF_SOFT_RESET			0x07, 0xff
 
 /* Define TM6000/TM6010 USB registers */
-#define TM6000_U_MAIN_CTRL		0x00
-#define TM6000_U_DEVADDR		0x01
-#define TM6000_U_TEST			0x02
-#define TM6000_U_SOFN0			0x04
-#define TM6000_U_SOFN1			0x05
-#define TM6000_U_SOFTM0			0x06
-#define TM6000_U_SOFTM1			0x07
-#define TM6000_U_PHY_TEST		0x08
-#define TM6000_U_VCTL			0x09
-#define TM6000_U_VSTA			0x0A
-#define TM6000_U_CX_CFG			0x0B
-#define TM6000_U_ENDP0_REG0		0x0C
-#define TM6000_U_GMASK			0x10
-#define TM6000_U_IMASK0			0x11
-#define TM6000_U_IMASK1			0x12
-#define TM6000_U_IMASK2			0x13
-#define TM6000_U_IMASK3			0x14
-#define TM6000_U_IMASK4			0x15
-#define TM6000_U_IMASK5			0x16
-#define TM6000_U_IMASK6			0x17
-#define TM6000_U_IMASK7			0x18
-#define TM6000_U_ZEROP0			0x19
-#define TM6000_U_ZEROP1			0x1A
-#define TM6000_U_FIFO_EMP0		0x1C
-#define TM6000_U_FIFO_EMP1		0x1D
-#define TM6000_U_IRQ_GROUP		0x20
-#define TM6000_U_IRQ_SOURCE0		0x21
-#define TM6000_U_IRQ_SOURCE1		0x22
-#define TM6000_U_IRQ_SOURCE2		0x23
-#define TM6000_U_IRQ_SOURCE3		0x24
-#define TM6000_U_IRQ_SOURCE4		0x25
-#define TM6000_U_IRQ_SOURCE5		0x26
-#define TM6000_U_IRQ_SOURCE6		0x27
-#define TM6000_U_IRQ_SOURCE7		0x28
-#define TM6000_U_SEQ_ERR0		0x29
-#define TM6000_U_SEQ_ERR1		0x2A
-#define TM6000_U_SEQ_ABORT0		0x2B
-#define TM6000_U_SEQ_ABORT1		0x2C
-#define TM6000_U_TX_ZERO0		0x2D
-#define TM6000_U_TX_ZERO1		0x2E
-#define TM6000_U_IDLE_CNT		0x2F
-#define TM6000_U_FNO_P1			0x30
-#define TM6000_U_FNO_P2			0x31
-#define TM6000_U_FNO_P3			0x32
-#define TM6000_U_FNO_P4			0x33
-#define TM6000_U_FNO_P5			0x34
-#define TM6000_U_FNO_P6			0x35
-#define TM6000_U_FNO_P7			0x36
-#define TM6000_U_FNO_P8			0x37
-#define TM6000_U_FNO_P9			0x38
-#define TM6000_U_FNO_P10		0x39
-#define TM6000_U_FNO_P11		0x3A
-#define TM6000_U_FNO_P12		0x3B
-#define TM6000_U_FNO_P13		0x3C
-#define TM6000_U_FNO_P14		0x3D
-#define TM6000_U_FNO_P15		0x3E
-#define TM6000_U_IN_MAXPS_LOW1		0x40
-#define TM6000_U_IN_MAXPS_HIGH1		0x41
-#define TM6000_U_IN_MAXPS_LOW2		0x42
-#define TM6000_U_IN_MAXPS_HIGH2		0x43
-#define TM6000_U_IN_MAXPS_LOW3		0x44
-#define TM6000_U_IN_MAXPS_HIGH3		0x45
-#define TM6000_U_IN_MAXPS_LOW4		0x46
-#define TM6000_U_IN_MAXPS_HIGH4		0x47
-#define TM6000_U_IN_MAXPS_LOW5		0x48
-#define TM6000_U_IN_MAXPS_HIGH5		0x49
-#define TM6000_U_IN_MAXPS_LOW6		0x4A
-#define TM6000_U_IN_MAXPS_HIGH6		0x4B
-#define TM6000_U_IN_MAXPS_LOW7		0x4C
-#define TM6000_U_IN_MAXPS_HIGH7		0x4D
-#define TM6000_U_IN_MAXPS_LOW8		0x4E
-#define TM6000_U_IN_MAXPS_HIGH8		0x4F
-#define TM6000_U_IN_MAXPS_LOW9		0x50
-#define TM6000_U_IN_MAXPS_HIGH9		0x51
-#define TM6000_U_IN_MAXPS_LOW10		0x52
-#define TM6000_U_IN_MAXPS_HIGH10	0x53
-#define TM6000_U_IN_MAXPS_LOW11		0x54
-#define TM6000_U_IN_MAXPS_HIGH11	0x55
-#define TM6000_U_IN_MAXPS_LOW12		0x56
-#define TM6000_U_IN_MAXPS_HIGH12	0x57
-#define TM6000_U_IN_MAXPS_LOW13		0x58
-#define TM6000_U_IN_MAXPS_HIGH13	0x59
-#define TM6000_U_IN_MAXPS_LOW14		0x5A
-#define TM6000_U_IN_MAXPS_HIGH14	0x5B
-#define TM6000_U_IN_MAXPS_LOW15		0x5C
-#define TM6000_U_IN_MAXPS_HIGH15	0x5D
-#define TM6000_U_OUT_MAXPS_LOW1		0x60
-#define TM6000_U_OUT_MAXPS_HIGH1	0x61
-#define TM6000_U_OUT_MAXPS_LOW2		0x62
-#define TM6000_U_OUT_MAXPS_HIGH2	0x63
-#define TM6000_U_OUT_MAXPS_LOW3		0x64
-#define TM6000_U_OUT_MAXPS_HIGH3	0x65
-#define TM6000_U_OUT_MAXPS_LOW4		0x66
-#define TM6000_U_OUT_MAXPS_HIGH4	0x67
-#define TM6000_U_OUT_MAXPS_LOW5		0x68
-#define TM6000_U_OUT_MAXPS_HIGH5	0x69
-#define TM6000_U_OUT_MAXPS_LOW6		0x6A
-#define TM6000_U_OUT_MAXPS_HIGH6	0x6B
-#define TM6000_U_OUT_MAXPS_LOW7		0x6C
-#define TM6000_U_OUT_MAXPS_HIGH7	0x6D
-#define TM6000_U_OUT_MAXPS_LOW8		0x6E
-#define TM6000_U_OUT_MAXPS_HIGH8	0x6F
-#define TM6000_U_OUT_MAXPS_LOW9		0x70
-#define TM6000_U_OUT_MAXPS_HIGH9	0x71
-#define TM6000_U_OUT_MAXPS_LOW10	0x72
-#define TM6000_U_OUT_MAXPS_HIGH10	0x73
-#define TM6000_U_OUT_MAXPS_LOW11	0x74
-#define TM6000_U_OUT_MAXPS_HIGH11	0x75
-#define TM6000_U_OUT_MAXPS_LOW12	0x76
-#define TM6000_U_OUT_MAXPS_HIGH12	0x77
-#define TM6000_U_OUT_MAXPS_LOW13	0x78
-#define TM6000_U_OUT_MAXPS_HIGH13	0x79
-#define TM6000_U_OUT_MAXPS_LOW14	0x7A
-#define TM6000_U_OUT_MAXPS_HIGH14	0x7B
-#define TM6000_U_OUT_MAXPS_LOW15	0x7C
-#define TM6000_U_OUT_MAXPS_HIGH15	0x7D
-#define TM6000_U_FIFO0			0x80
-#define TM6000_U_FIFO1			0x81
-#define TM6000_U_FIFO2			0x82
-#define TM6000_U_FIFO3			0x83
-#define TM6000_U_FIFO4			0x84
-#define TM6000_U_FIFO5			0x85
-#define TM6000_U_FIFO6			0x86
-#define TM6000_U_FIFO7			0x87
-#define TM6000_U_FIFO8			0x88
-#define TM6000_U_FIFO9			0x89
-#define TM6000_U_FIFO10			0x8A
-#define TM6000_U_FIFO11			0x8B
-#define TM6000_U_FIFO12			0x8C
-#define TM6000_U_FIFO13			0x8D
-#define TM6000_U_FIFO14			0x8E
-#define TM6000_U_FIFO15			0x8F
-#define TM6000_U_CFG_FIFO0		0x90
-#define TM6000_U_CFG_FIFO1		0x91
-#define TM6000_U_CFG_FIFO2		0x92
-#define TM6000_U_CFG_FIFO3		0x93
-#define TM6000_U_CFG_FIFO4		0x94
-#define TM6000_U_CFG_FIFO5		0x95
-#define TM6000_U_CFG_FIFO6		0x96
-#define TM6000_U_CFG_FIFO7		0x97
-#define TM6000_U_CFG_FIFO8		0x98
-#define TM6000_U_CFG_FIFO9		0x99
-#define TM6000_U_CFG_FIFO10		0x9A
-#define TM6000_U_CFG_FIFO11		0x9B
-#define TM6000_U_CFG_FIFO12		0x9C
-#define TM6000_U_CFG_FIFO13		0x9D
-#define TM6000_U_CFG_FIFO14		0x9E
-#define TM6000_U_CFG_FIFO15		0x9F
-#define TM6000_U_CTL_FIFO0		0xA0
-#define TM6000_U_CTL_FIFO1		0xA1
-#define TM6000_U_CTL_FIFO2		0xA2
-#define TM6000_U_CTL_FIFO3		0xA3
-#define TM6000_U_CTL_FIFO4		0xA4
-#define TM6000_U_CTL_FIFO5		0xA5
-#define TM6000_U_CTL_FIFO6		0xA6
-#define TM6000_U_CTL_FIFO7		0xA7
-#define TM6000_U_CTL_FIFO8		0xA8
-#define TM6000_U_CTL_FIFO9		0xA9
-#define TM6000_U_CTL_FIFO10		0xAA
-#define TM6000_U_CTL_FIFO11		0xAB
-#define TM6000_U_CTL_FIFO12		0xAC
-#define TM6000_U_CTL_FIFO13		0xAD
-#define TM6000_U_CTL_FIFO14		0xAE
-#define TM6000_U_CTL_FIFO15		0xAF
-#define TM6000_U_BC_LOW_FIFO0		0xB0
-#define TM6000_U_BC_LOW_FIFO1		0xB1
-#define TM6000_U_BC_LOW_FIFO2		0xB2
-#define TM6000_U_BC_LOW_FIFO3		0xB3
-#define TM6000_U_BC_LOW_FIFO4		0xB4
-#define TM6000_U_BC_LOW_FIFO5		0xB5
-#define TM6000_U_BC_LOW_FIFO6		0xB6
-#define TM6000_U_BC_LOW_FIFO7		0xB7
-#define TM6000_U_BC_LOW_FIFO8		0xB8
-#define TM6000_U_BC_LOW_FIFO9		0xB9
-#define TM6000_U_BC_LOW_FIFO10		0xBA
-#define TM6000_U_BC_LOW_FIFO11		0xBB
-#define TM6000_U_BC_LOW_FIFO12		0xBC
-#define TM6000_U_BC_LOW_FIFO13		0xBD
-#define TM6000_U_BC_LOW_FIFO14		0xBE
-#define TM6000_U_BC_LOW_FIFO15		0xBF
-#define TM6000_U_DATA_FIFO0		0xC0
-#define TM6000_U_DATA_FIFO1		0xC4
-#define TM6000_U_DATA_FIFO2		0xC8
-#define TM6000_U_DATA_FIFO3		0xCC
-#define TM6000_U_DATA_FIFO4		0xD0
-#define TM6000_U_DATA_FIFO5		0xD4
-#define TM6000_U_DATA_FIFO6		0xD8
-#define TM6000_U_DATA_FIFO7		0xDC
-#define TM6000_U_DATA_FIFO8		0xE0
-#define TM6000_U_DATA_FIFO9		0xE4
-#define TM6000_U_DATA_FIFO10		0xE8
-#define TM6000_U_DATA_FIFO11		0xEC
-#define TM6000_U_DATA_FIFO12		0xF0
-#define TM6000_U_DATA_FIFO13		0xF4
-#define TM6000_U_DATA_FIFO14		0xF8
-#define TM6000_U_DATA_FIFO15		0xFC
+#define TM6010_REQ05_R00_MAIN_CTRL		0x00
+#define TM6010_REQ05_R01_DEVADDR		0x01
+#define TM6010_REQ05_R02_TEST			0x02
+#define TM6010_REQ05_R04_SOFN0			0x04
+#define TM6010_REQ05_R05_SOFN1			0x05
+#define TM6010_REQ05_R06_SOFTM0			0x06
+#define TM6010_REQ05_R07_SOFTM1			0x07
+#define TM6010_REQ05_R08_PHY_TEST		0x08
+#define TM6010_REQ05_R09_VCTL			0x09
+#define TM6010_REQ05_R0A_VSTA			0x0A
+#define TM6010_REQ05_R0B_CX_CFG			0x0B
+#define TM6010_REQ05_R0C_ENDP0_REG0		0x0C
+#define TM6010_REQ05_R10_GMASK			0x10
+#define TM6010_REQ05_R11_IMASK0			0x11
+#define TM6010_REQ05_R12_IMASK1			0x12
+#define TM6010_REQ05_R13_IMASK2			0x13
+#define TM6010_REQ05_R14_IMASK3			0x14
+#define TM6010_REQ05_R15_IMASK4			0x15
+#define TM6010_REQ05_R16_IMASK5			0x16
+#define TM6010_REQ05_R17_IMASK6			0x17
+#define TM6010_REQ05_R18_IMASK7			0x18
+#define TM6010_REQ05_R19_ZEROP0			0x19
+#define TM6010_REQ05_R1A_ZEROP1			0x1A
+#define TM6010_REQ05_R1C_FIFO_EMP0		0x1C
+#define TM6010_REQ05_R1D_FIFO_EMP1		0x1D
+#define TM6010_REQ05_R20_IRQ_GROUP		0x20
+#define TM6010_REQ05_R21_IRQ_SOURCE0		0x21
+#define TM6010_REQ05_R22_IRQ_SOURCE1		0x22
+#define TM6010_REQ05_R23_IRQ_SOURCE2		0x23
+#define TM6010_REQ05_R24_IRQ_SOURCE3		0x24
+#define TM6010_REQ05_R25_IRQ_SOURCE4		0x25
+#define TM6010_REQ05_R26_IRQ_SOURCE5		0x26
+#define TM6010_REQ05_R27_IRQ_SOURCE6		0x27
+#define TM6010_REQ05_R28_IRQ_SOURCE7		0x28
+#define TM6010_REQ05_R29_SEQ_ERR0		0x29
+#define TM6010_REQ05_R2A_SEQ_ERR1		0x2A
+#define TM6010_REQ05_R2B_SEQ_ABORT0		0x2B
+#define TM6010_REQ05_R2C_SEQ_ABORT1		0x2C
+#define TM6010_REQ05_R2D_TX_ZERO0		0x2D
+#define TM6010_REQ05_R2E_TX_ZERO1		0x2E
+#define TM6010_REQ05_R2F_IDLE_CNT		0x2F
+#define TM6010_REQ05_R30_FNO_P1			0x30
+#define TM6010_REQ05_R31_FNO_P2			0x31
+#define TM6010_REQ05_R32_FNO_P3			0x32
+#define TM6010_REQ05_R33_FNO_P4			0x33
+#define TM6010_REQ05_R34_FNO_P5			0x34
+#define TM6010_REQ05_R35_FNO_P6			0x35
+#define TM6010_REQ05_R36_FNO_P7			0x36
+#define TM6010_REQ05_R37_FNO_P8			0x37
+#define TM6010_REQ05_R38_FNO_P9			0x38
+#define TM6010_REQ05_R30_FNO_P10		0x39
+#define TM6010_REQ05_R30_FNO_P11		0x3A
+#define TM6010_REQ05_R30_FNO_P12		0x3B
+#define TM6010_REQ05_R30_FNO_P13		0x3C
+#define TM6010_REQ05_R30_FNO_P14		0x3D
+#define TM6010_REQ05_R30_FNO_P15		0x3E
+#define TM6010_REQ05_R40_IN_MAXPS_LOW1		0x40
+#define TM6010_REQ05_R41_IN_MAXPS_HIGH1		0x41
+#define TM6010_REQ05_R42_IN_MAXPS_LOW2		0x42
+#define TM6010_REQ05_R43_IN_MAXPS_HIGH2		0x43
+#define TM6010_REQ05_R44_IN_MAXPS_LOW3		0x44
+#define TM6010_REQ05_R45_IN_MAXPS_HIGH3		0x45
+#define TM6010_REQ05_R46_IN_MAXPS_LOW4		0x46
+#define TM6010_REQ05_R47_IN_MAXPS_HIGH4		0x47
+#define TM6010_REQ05_R48_IN_MAXPS_LOW5		0x48
+#define TM6010_REQ05_R49_IN_MAXPS_HIGH5		0x49
+#define TM6010_REQ05_R4A_IN_MAXPS_LOW6		0x4A
+#define TM6010_REQ05_R4B_IN_MAXPS_HIGH6		0x4B
+#define TM6010_REQ05_R4C_IN_MAXPS_LOW7		0x4C
+#define TM6010_REQ05_R4D_IN_MAXPS_HIGH7		0x4D
+#define TM6010_REQ05_R4E_IN_MAXPS_LOW8		0x4E
+#define TM6010_REQ05_R4F_IN_MAXPS_HIGH8		0x4F
+#define TM6010_REQ05_R50_IN_MAXPS_LOW9		0x50
+#define TM6010_REQ05_R51_IN_MAXPS_HIGH9		0x51
+#define TM6010_REQ05_R40_IN_MAXPS_LOW10		0x52
+#define TM6010_REQ05_R41_IN_MAXPS_HIGH10	0x53
+#define TM6010_REQ05_R40_IN_MAXPS_LOW11		0x54
+#define TM6010_REQ05_R41_IN_MAXPS_HIGH11	0x55
+#define TM6010_REQ05_R40_IN_MAXPS_LOW12		0x56
+#define TM6010_REQ05_R41_IN_MAXPS_HIGH12	0x57
+#define TM6010_REQ05_R40_IN_MAXPS_LOW13		0x58
+#define TM6010_REQ05_R41_IN_MAXPS_HIGH13	0x59
+#define TM6010_REQ05_R40_IN_MAXPS_LOW14		0x5A
+#define TM6010_REQ05_R41_IN_MAXPS_HIGH14	0x5B
+#define TM6010_REQ05_R40_IN_MAXPS_LOW15		0x5C
+#define TM6010_REQ05_R41_IN_MAXPS_HIGH15	0x5D
+#define TM6010_REQ05_R60_OUT_MAXPS_LOW1		0x60
+#define TM6010_REQ05_R61_OUT_MAXPS_HIGH1	0x61
+#define TM6010_REQ05_R62_OUT_MAXPS_LOW2		0x62
+#define TM6010_REQ05_R63_OUT_MAXPS_HIGH2	0x63
+#define TM6010_REQ05_R64_OUT_MAXPS_LOW3		0x64
+#define TM6010_REQ05_R65_OUT_MAXPS_HIGH3	0x65
+#define TM6010_REQ05_R66_OUT_MAXPS_LOW4		0x66
+#define TM6010_REQ05_R67_OUT_MAXPS_HIGH4	0x67
+#define TM6010_REQ05_R68_OUT_MAXPS_LOW5		0x68
+#define TM6010_REQ05_R69_OUT_MAXPS_HIGH5	0x69
+#define TM6010_REQ05_R6A_OUT_MAXPS_LOW6		0x6A
+#define TM6010_REQ05_R6B_OUT_MAXPS_HIGH6	0x6B
+#define TM6010_REQ05_R6C_OUT_MAXPS_LOW7		0x6C
+#define TM6010_REQ05_R6D_OUT_MAXPS_HIGH7	0x6D
+#define TM6010_REQ05_R6E_OUT_MAXPS_LOW8		0x6E
+#define TM6010_REQ05_R6F_OUT_MAXPS_HIGH8	0x6F
+#define TM6010_REQ05_R70_OUT_MAXPS_LOW9		0x70
+#define TM6010_REQ05_R71_OUT_MAXPS_HIGH9	0x71
+#define TM6010_REQ05_R60_OUT_MAXPS_LOW10	0x72
+#define TM6010_REQ05_R61_OUT_MAXPS_HIGH10	0x73
+#define TM6010_REQ05_R60_OUT_MAXPS_LOW11	0x74
+#define TM6010_REQ05_R61_OUT_MAXPS_HIGH11	0x75
+#define TM6010_REQ05_R60_OUT_MAXPS_LOW12	0x76
+#define TM6010_REQ05_R61_OUT_MAXPS_HIGH12	0x77
+#define TM6010_REQ05_R60_OUT_MAXPS_LOW13	0x78
+#define TM6010_REQ05_R61_OUT_MAXPS_HIGH13	0x79
+#define TM6010_REQ05_R60_OUT_MAXPS_LOW14	0x7A
+#define TM6010_REQ05_R61_OUT_MAXPS_HIGH14	0x7B
+#define TM6010_REQ05_R60_OUT_MAXPS_LOW15	0x7C
+#define TM6010_REQ05_R61_OUT_MAXPS_HIGH15	0x7D
+#define TM6010_REQ05_R80_FIFO0			0x80
+#define TM6010_REQ05_R81_FIFO1			0x81
+#define TM6010_REQ05_R82_FIFO2			0x82
+#define TM6010_REQ05_R83_FIFO3			0x83
+#define TM6010_REQ05_R84_FIFO4			0x84
+#define TM6010_REQ05_R85_FIFO5			0x85
+#define TM6010_REQ05_R86_FIFO6			0x86
+#define TM6010_REQ05_R87_FIFO7			0x87
+#define TM6010_REQ05_R88_FIFO8			0x88
+#define TM6010_REQ05_R89_FIFO9			0x89
+#define TM6010_REQ05_R81_FIFO10			0x8A
+#define TM6010_REQ05_R81_FIFO11			0x8B
+#define TM6010_REQ05_R81_FIFO12			0x8C
+#define TM6010_REQ05_R81_FIFO13			0x8D
+#define TM6010_REQ05_R81_FIFO14			0x8E
+#define TM6010_REQ05_R81_FIFO15			0x8F
+#define TM6010_REQ05_R90_CFG_FIFO0		0x90
+#define TM6010_REQ05_R91_CFG_FIFO1		0x91
+#define TM6010_REQ05_R92_CFG_FIFO2		0x92
+#define TM6010_REQ05_R93_CFG_FIFO3		0x93
+#define TM6010_REQ05_R94_CFG_FIFO4		0x94
+#define TM6010_REQ05_R95_CFG_FIFO5		0x95
+#define TM6010_REQ05_R96_CFG_FIFO6		0x96
+#define TM6010_REQ05_R97_CFG_FIFO7		0x97
+#define TM6010_REQ05_R98_CFG_FIFO8		0x98
+#define TM6010_REQ05_R99_CFG_FIFO9		0x99
+#define TM6010_REQ05_R91_CFG_FIFO10		0x9A
+#define TM6010_REQ05_R91_CFG_FIFO11		0x9B
+#define TM6010_REQ05_R91_CFG_FIFO12		0x9C
+#define TM6010_REQ05_R91_CFG_FIFO13		0x9D
+#define TM6010_REQ05_R91_CFG_FIFO14		0x9E
+#define TM6010_REQ05_R91_CFG_FIFO15		0x9F
+#define TM6010_REQ05_RA0_CTL_FIFO0		0xA0
+#define TM6010_REQ05_RA1_CTL_FIFO1		0xA1
+#define TM6010_REQ05_RA2_CTL_FIFO2		0xA2
+#define TM6010_REQ05_RA3_CTL_FIFO3		0xA3
+#define TM6010_REQ05_RA4_CTL_FIFO4		0xA4
+#define TM6010_REQ05_RA5_CTL_FIFO5		0xA5
+#define TM6010_REQ05_RA6_CTL_FIFO6		0xA6
+#define TM6010_REQ05_RA7_CTL_FIFO7		0xA7
+#define TM6010_REQ05_RA8_CTL_FIFO8		0xA8
+#define TM6010_REQ05_RA9_CTL_FIFO9		0xA9
+#define TM6010_REQ05_RA1_CTL_FIFO10		0xAA
+#define TM6010_REQ05_RA1_CTL_FIFO11		0xAB
+#define TM6010_REQ05_RA1_CTL_FIFO12		0xAC
+#define TM6010_REQ05_RA1_CTL_FIFO13		0xAD
+#define TM6010_REQ05_RA1_CTL_FIFO14		0xAE
+#define TM6010_REQ05_RA1_CTL_FIFO15		0xAF
+#define TM6010_REQ05_RB0_BC_LOW_FIFO0		0xB0
+#define TM6010_REQ05_RB1_BC_LOW_FIFO1		0xB1
+#define TM6010_REQ05_RB2_BC_LOW_FIFO2		0xB2
+#define TM6010_REQ05_RB3_BC_LOW_FIFO3		0xB3
+#define TM6010_REQ05_RB4_BC_LOW_FIFO4		0xB4
+#define TM6010_REQ05_RB5_BC_LOW_FIFO5		0xB5
+#define TM6010_REQ05_RB6_BC_LOW_FIFO6		0xB6
+#define TM6010_REQ05_RB7_BC_LOW_FIFO7		0xB7
+#define TM6010_REQ05_RB8_BC_LOW_FIFO8		0xB8
+#define TM6010_REQ05_RB9_BC_LOW_FIFO9		0xB9
+#define TM6010_REQ05_RB1_BC_LOW_FIFO10		0xBA
+#define TM6010_REQ05_RB1_BC_LOW_FIFO11		0xBB
+#define TM6010_REQ05_RB1_BC_LOW_FIFO12		0xBC
+#define TM6010_REQ05_RB1_BC_LOW_FIFO13		0xBD
+#define TM6010_REQ05_RB1_BC_LOW_FIFO14		0xBE
+#define TM6010_REQ05_RB1_BC_LOW_FIFO15		0xBF
+#define TM6010_REQ05_RC0_DATA_FIFO0		0xC0
+#define TM6010_REQ05_RC4_DATA_FIFO1		0xC4
+#define TM6010_REQ05_RC8_DATA_FIFO2		0xC8
+#define TM6010_REQ05_RCC_DATA_FIFO3		0xCC
+#define TM6010_REQ05_RD0_DATA_FIFO4		0xD0
+#define TM6010_REQ05_RD4_DATA_FIFO5		0xD4
+#define TM6010_REQ05_RD8_DATA_FIFO6		0xD8
+#define TM6010_REQ05_RDC_DATA_FIFO7		0xDC
+#define TM6010_REQ05_RE0_DATA_FIFO8		0xE0
+#define TM6010_REQ05_RE4_DATA_FIFO9		0xE4
+#define TM6010_REQ05_RC4_DATA_FIFO10		0xE8
+#define TM6010_REQ05_RC4_DATA_FIFO11		0xEC
+#define TM6010_REQ05_RC4_DATA_FIFO12		0xF0
+#define TM6010_REQ05_RC4_DATA_FIFO13		0xF4
+#define TM6010_REQ05_RC4_DATA_FIFO14		0xF8
+#define TM6010_REQ05_RC4_DATA_FIFO15		0xFC
 
 /* Define TM6000/TM6010 Audio decoder registers */
 #define TM6010_REQ08_R00_A_VERSION		0x08, 0x00
-- 
1.6.6.1


