Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:45247 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756118Ab1GCQlY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 12:41:24 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 01/16] tda18271c2dd: Initial check-in
Date: Sun, 3 Jul 2011 18:36:17 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201107031831.20378@orion.escape-edv.de>
In-Reply-To: <201107031831.20378@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107031836.18731@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Ralph Metzler <rjkm@metzlerbros.de>

Driver for the NXP TDA18271c2 silicon tuner.

Signed-off-by: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/media/dvb/frontends/tda18271c2dd.c      | 1063 +++++++++++++++++++++++
 drivers/media/dvb/frontends/tda18271c2dd.h      |    5 +
 drivers/media/dvb/frontends/tda18271c2dd_maps.h |  810 +++++++++++++++++
 3 files changed, 1878 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/tda18271c2dd.c
 create mode 100644 drivers/media/dvb/frontends/tda18271c2dd.h
 create mode 100644 drivers/media/dvb/frontends/tda18271c2dd_maps.h

diff --git a/drivers/media/dvb/frontends/tda18271c2dd.c b/drivers/media/dvb/frontends/tda18271c2dd.c
new file mode 100644
index 0000000..b4a23bf
--- /dev/null
+++ b/drivers/media/dvb/frontends/tda18271c2dd.c
@@ -0,0 +1,1063 @@
+/*
+ * tda18271c2dd: Driver for the TDA18271C2 tuner
+ *
+ * Copyright (C) 2010 Digital Devices GmbH
+ *
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 only, as published by the Free Software Foundation.
+ *
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA
+ * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/i2c.h>
+#include <linux/version.h>
+#include <asm/div64.h>
+
+#include "dvb_frontend.h"
+
+struct SStandardParam {
+	s32   m_IFFrequency;
+	u32   m_BandWidth;
+	u8    m_EP3_4_0;
+	u8    m_EB22;
+};
+
+struct SMap {
+	u32   m_Frequency;
+	u8    m_Param;
+};
+
+struct SMapI {
+	u32   m_Frequency;
+	s32    m_Param;
+};
+
+struct SMap2 {
+	u32   m_Frequency;
+	u8    m_Param1;
+	u8    m_Param2;
+};
+
+struct SRFBandMap {
+	u32   m_RF_max;
+	u32   m_RF1_Default;
+	u32   m_RF2_Default;
+	u32   m_RF3_Default;
+};
+
+enum ERegister
+{
+	ID = 0,
+	TM,
+	PL,
+	EP1, EP2, EP3, EP4, EP5,
+	CPD, CD1, CD2, CD3,
+	MPD, MD1, MD2, MD3,
+	EB1, EB2, EB3, EB4, EB5, EB6, EB7, EB8, EB9, EB10,
+	EB11, EB12, EB13, EB14, EB15, EB16, EB17, EB18, EB19, EB20,
+	EB21, EB22, EB23,
+	NUM_REGS
+};
+
+struct tda_state {
+	struct i2c_adapter *i2c;
+	u8 adr;
+
+	u32   m_Frequency;
+	u32   IF;
+
+	u8    m_IFLevelAnalog;
+	u8    m_IFLevelDigital;
+	u8    m_IFLevelDVBC;
+	u8    m_IFLevelDVBT;
+
+	u8    m_EP4;
+	u8    m_EP3_Standby;
+
+	bool  m_bMaster;
+
+	s32   m_SettlingTime;
+
+	u8    m_Regs[NUM_REGS];
+
+	/* Tracking filter settings for band 0..6 */
+	u32   m_RF1[7];
+	s32   m_RF_A1[7];
+	s32   m_RF_B1[7];
+	u32   m_RF2[7];
+	s32   m_RF_A2[7];
+	s32   m_RF_B2[7];
+	u32   m_RF3[7];
+
+	u8    m_TMValue_RFCal;    /* Calibration temperatur */
+
+	bool  m_bFMInput;         /* true to use Pin 8 for FM Radio */
+
+};
+
+static int PowerScan(struct tda_state *state,
+		     u8 RFBand,u32 RF_in,
+		     u32 * pRF_Out, bool *pbcal);
+
+static int i2c_readn(struct i2c_adapter *adapter, u8 adr, u8 *data, int len)
+{
+	struct i2c_msg msgs[1] = {{.addr = adr,  .flags = I2C_M_RD,
+				   .buf  = data, .len   = len}};
+	return (i2c_transfer(adapter, msgs, 1) == 1) ? 0 : -1;
+}
+
+static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
+{
+	struct i2c_msg msg = {.addr = adr, .flags = 0,
+			      .buf = data, .len = len};
+
+	if (i2c_transfer(adap, &msg, 1) != 1) {
+		printk("i2c_write error\n");
+		return -1;
+	}
+	return 0;
+}
+
+static int WriteRegs(struct tda_state *state,
+		     u8 SubAddr, u8 *Regs, u16 nRegs)
+{
+	u8 data[nRegs+1];
+
+	data[0] = SubAddr;
+	memcpy(data + 1, Regs, nRegs);
+	return i2c_write(state->i2c, state->adr, data, nRegs+1);
+}
+
+static int WriteReg(struct tda_state *state, u8 SubAddr,u8 Reg)
+{
+	u8 msg[2] = {SubAddr, Reg};
+
+	return i2c_write(state->i2c, state->adr, msg, 2);
+}
+
+static int Read(struct tda_state *state, u8 * Regs)
+{
+	return i2c_readn(state->i2c, state->adr, Regs, 16);
+}
+
+static int ReadExtented(struct tda_state *state, u8 * Regs)
+{
+	return i2c_readn(state->i2c, state->adr, Regs, NUM_REGS);
+}
+
+static int UpdateRegs(struct tda_state *state, u8 RegFrom,u8 RegTo)
+{
+	return WriteRegs(state, RegFrom,
+			 &state->m_Regs[RegFrom], RegTo-RegFrom+1);
+}
+static int UpdateReg(struct tda_state *state, u8 Reg)
+{
+	return WriteReg(state, Reg,state->m_Regs[Reg]);
+}
+
+#include "tda18271c2dd_maps.h"
+
+#undef CHK_ERROR
+#define CHK_ERROR(s) if ((status = s) < 0) break
+
+static void reset(struct tda_state *state)
+{
+	u32   ulIFLevelAnalog = 0;
+	u32   ulIFLevelDigital = 2;
+	u32   ulIFLevelDVBC = 7;
+	u32   ulIFLevelDVBT = 6;
+	u32   ulXTOut = 0;
+	u32   ulStandbyMode = 0x06;    // Send in stdb, but leave osc on
+	u32   ulSlave = 0;
+	u32   ulFMInput = 0;
+	u32   ulSettlingTime = 100;
+
+	state->m_Frequency         = 0;
+	state->m_SettlingTime = 100;
+	state->m_IFLevelAnalog = (ulIFLevelAnalog & 0x07) << 2;
+	state->m_IFLevelDigital = (ulIFLevelDigital & 0x07) << 2;
+	state->m_IFLevelDVBC = (ulIFLevelDVBC & 0x07) << 2;
+	state->m_IFLevelDVBT = (ulIFLevelDVBT & 0x07) << 2;
+
+	state->m_EP4 = 0x20;
+	if( ulXTOut != 0 ) state->m_EP4 |= 0x40;
+
+	state->m_EP3_Standby = ((ulStandbyMode & 0x07) << 5) | 0x0F;
+	state->m_bMaster = (ulSlave == 0);
+
+	state->m_SettlingTime = ulSettlingTime;
+
+	state->m_bFMInput = (ulFMInput == 2);
+}
+
+static bool SearchMap1(struct SMap Map[],
+		       u32 Frequency, u8 *pParam)
+{
+	int i = 0;
+
+	while ((Map[i].m_Frequency != 0) && (Frequency > Map[i].m_Frequency) )
+		i += 1;
+	if (Map[i].m_Frequency == 0)
+		return false;
+	*pParam = Map[i].m_Param;
+	return true;
+}
+
+static bool SearchMap2(struct SMapI Map[],
+		       u32 Frequency, s32 *pParam)
+{
+	int i = 0;
+
+	while ((Map[i].m_Frequency != 0) &&
+	       (Frequency > Map[i].m_Frequency) )
+		i += 1;
+	if (Map[i].m_Frequency == 0)
+		return false;
+	*pParam = Map[i].m_Param;
+	return true;
+}
+
+static bool SearchMap3(struct SMap2 Map[],u32 Frequency,
+		       u8 *pParam1, u8 *pParam2)
+{
+	int i = 0;
+
+	while ((Map[i].m_Frequency != 0) &&
+	       (Frequency > Map[i].m_Frequency) )
+		i += 1;
+	if (Map[i].m_Frequency == 0)
+		return false;
+	*pParam1 = Map[i].m_Param1;
+	*pParam2 = Map[i].m_Param2;
+	return true;
+}
+
+static bool SearchMap4(struct SRFBandMap Map[],
+		       u32 Frequency, u8 *pRFBand)
+{
+	int i = 0;
+
+	while (i < 7 && (Frequency > Map[i].m_RF_max))
+		i += 1;
+	if (i == 7)
+		return false;
+	*pRFBand = i;
+	return true;
+}
+
+static int ThermometerRead(struct tda_state *state, u8 *pTM_Value)
+{
+	int status = 0;
+
+	do {
+		u8 Regs[16];
+		state->m_Regs[TM] |= 0x10;
+		CHK_ERROR(UpdateReg(state,TM));
+		CHK_ERROR(Read(state,Regs));
+		if( ( (Regs[TM] & 0x0F) == 0 && (Regs[TM] & 0x20) == 0x20 ) ||
+		    ( (Regs[TM] & 0x0F) == 8 && (Regs[TM] & 0x20) == 0x00 ) ) {
+			state->m_Regs[TM] ^= 0x20;
+			CHK_ERROR(UpdateReg(state,TM));
+			msleep(10);
+			CHK_ERROR(Read(state,Regs));
+		}
+		*pTM_Value = (Regs[TM] & 0x20 ) ? m_Thermometer_Map_2[Regs[TM] & 0x0F] :
+			m_Thermometer_Map_1[Regs[TM] & 0x0F] ;
+		state->m_Regs[TM] &= ~0x10;        // Thermometer off
+		CHK_ERROR(UpdateReg(state,TM));
+		state->m_Regs[EP4] &= ~0x03;       // CAL_mode = 0 ?????????
+		CHK_ERROR(UpdateReg(state,EP4));
+	} while(0);
+
+	return status;
+}
+
+static int StandBy(struct tda_state *state)
+{
+	int status = 0;
+	do {
+		state->m_Regs[EB12] &= ~0x20;  // PD_AGC1_Det = 0
+		CHK_ERROR(UpdateReg(state,EB12));
+		state->m_Regs[EB18] &= ~0x83;  // AGC1_loop_off = 0, AGC1_Gain = 6 dB
+		CHK_ERROR(UpdateReg(state,EB18));
+		state->m_Regs[EB21] |= 0x03; // AGC2_Gain = -6 dB
+		state->m_Regs[EP3] = state->m_EP3_Standby;
+		CHK_ERROR(UpdateReg(state,EP3));
+		state->m_Regs[EB23] &= ~0x06; // ForceLP_Fc2_En = 0, LP_Fc[2] = 0
+		CHK_ERROR(UpdateRegs(state,EB21,EB23));
+	} while(0);
+	return status;
+}
+
+static int CalcMainPLL(struct tda_state *state, u32 freq)
+{
+
+	u8  PostDiv;
+	u8  Div;
+	u64 OscFreq;
+	u32 MainDiv;
+
+	if (!SearchMap3(m_Main_PLL_Map, freq, &PostDiv, &Div)) {
+		return -EINVAL;
+	}
+
+	OscFreq = (u64) freq * (u64) Div;
+	OscFreq *= (u64) 16384;
+	do_div(OscFreq, (u64)16000000);
+	MainDiv = OscFreq;
+
+	state->m_Regs[MPD] = PostDiv & 0x77;
+	state->m_Regs[MD1] = ((MainDiv >> 16) & 0x7F);
+	state->m_Regs[MD2] = ((MainDiv >>  8) & 0xFF);
+	state->m_Regs[MD3] = ((MainDiv      ) & 0xFF);
+
+	return UpdateRegs(state, MPD, MD3);
+}
+
+static int CalcCalPLL(struct tda_state *state, u32 freq)
+{
+	//KdPrintEx((MSG_TRACE " - " __FUNCTION__ "(%d)\n",freq));
+
+	u8 PostDiv;
+	u8 Div;
+	u64 OscFreq;
+	u32 CalDiv;
+
+	if( !SearchMap3(m_Cal_PLL_Map,freq,&PostDiv,&Div) )
+	{
+		return -EINVAL;
+	}
+
+	OscFreq = (u64)freq * (u64)Div;
+	//CalDiv = u32( OscFreq * 16384 / 16000000 );
+	OscFreq*=(u64)16384;
+	do_div(OscFreq, (u64)16000000);
+	CalDiv=OscFreq;
+
+	state->m_Regs[CPD] = PostDiv;
+	state->m_Regs[CD1] = ((CalDiv >> 16) & 0xFF);
+	state->m_Regs[CD2] = ((CalDiv >>  8) & 0xFF);
+	state->m_Regs[CD3] = ((CalDiv      ) & 0xFF);
+
+	return UpdateRegs(state,CPD,CD3);
+}
+
+static int CalibrateRF(struct tda_state *state,
+		       u8 RFBand,u32 freq, s32 * pCprog)
+{
+	//KdPrintEx((MSG_TRACE " - " __FUNCTION__ " ID = %02x\n",state->m_Regs[ID]));
+	int status = 0;
+	u8 Regs[NUM_REGS];
+	do {
+		u8 BP_Filter=0;
+		u8 GainTaper=0;
+		u8 RFC_K=0;
+		u8 RFC_M=0;
+
+		state->m_Regs[EP4] &= ~0x03; // CAL_mode = 0
+		CHK_ERROR(UpdateReg(state,EP4));
+		state->m_Regs[EB18] |= 0x03;  // AGC1_Gain = 3
+		CHK_ERROR(UpdateReg(state,EB18));
+
+		// Switching off LT (as datasheet says) causes calibration on C1 to fail
+		// (Readout of Cprog is allways 255)
+		if( state->m_Regs[ID] != 0x83 )    // C1: ID == 83, C2: ID == 84
+		{
+			state->m_Regs[EP3] |= 0x40; // SM_LT = 1
+		}
+
+		if( ! ( SearchMap1(m_BP_Filter_Map,freq,&BP_Filter) &&
+			SearchMap1(m_GainTaper_Map,freq,&GainTaper) &&
+			SearchMap3(m_KM_Map,freq,&RFC_K,&RFC_M)) )
+		{
+			return -EINVAL;
+		}
+
+		state->m_Regs[EP1] = (state->m_Regs[EP1] & ~0x07) | BP_Filter;
+		state->m_Regs[EP2] = (RFBand << 5) | GainTaper;
+
+		state->m_Regs[EB13] = (state->m_Regs[EB13] & ~0x7C) | (RFC_K << 4) | (RFC_M << 2);
+
+		CHK_ERROR(UpdateRegs(state,EP1,EP3));
+		CHK_ERROR(UpdateReg(state,EB13));
+
+		state->m_Regs[EB4] |= 0x20;    // LO_ForceSrce = 1
+		CHK_ERROR(UpdateReg(state,EB4));
+
+		state->m_Regs[EB7] |= 0x20;    // CAL_ForceSrce = 1
+		CHK_ERROR(UpdateReg(state,EB7));
+
+		state->m_Regs[EB14] = 0; // RFC_Cprog = 0
+		CHK_ERROR(UpdateReg(state,EB14));
+
+		state->m_Regs[EB20] &= ~0x20;  // ForceLock = 0;
+		CHK_ERROR(UpdateReg(state,EB20));
+
+		state->m_Regs[EP4] |= 0x03;  // CAL_Mode = 3
+		CHK_ERROR(UpdateRegs(state,EP4,EP5));
+
+		CHK_ERROR(CalcCalPLL(state,freq));
+		CHK_ERROR(CalcMainPLL(state,freq + 1000000));
+
+		msleep(5);
+		CHK_ERROR(UpdateReg(state,EP2));
+		CHK_ERROR(UpdateReg(state,EP1));
+		CHK_ERROR(UpdateReg(state,EP2));
+		CHK_ERROR(UpdateReg(state,EP1));
+
+		state->m_Regs[EB4] &= ~0x20;    // LO_ForceSrce = 0
+		CHK_ERROR(UpdateReg(state,EB4));
+
+		state->m_Regs[EB7] &= ~0x20;    // CAL_ForceSrce = 0
+		CHK_ERROR(UpdateReg(state,EB7));
+		msleep(10);
+
+		state->m_Regs[EB20] |= 0x20;  // ForceLock = 1;
+		CHK_ERROR(UpdateReg(state,EB20));
+		msleep(60);
+
+		state->m_Regs[EP4] &= ~0x03;  // CAL_Mode = 0
+		state->m_Regs[EP3] &= ~0x40; // SM_LT = 0
+		state->m_Regs[EB18] &= ~0x03;  // AGC1_Gain = 0
+		CHK_ERROR(UpdateReg(state,EB18));
+		CHK_ERROR(UpdateRegs(state,EP3,EP4));
+		CHK_ERROR(UpdateReg(state,EP1));
+
+		CHK_ERROR(ReadExtented(state,Regs));
+
+		*pCprog = Regs[EB14];
+		//KdPrintEx((MSG_TRACE " - " __FUNCTION__ " Cprog = %d\n",Regs[EB14]));
+
+	} while(0);
+	return status;
+}
+
+static int RFTrackingFiltersInit(struct tda_state *state,
+				 u8 RFBand)
+{
+	//KdPrintEx((MSG_TRACE " - " __FUNCTION__ "\n"));
+	int status = 0;
+
+	u32   RF1 = m_RF_Band_Map[RFBand].m_RF1_Default;
+	u32   RF2 = m_RF_Band_Map[RFBand].m_RF2_Default;
+	u32   RF3 = m_RF_Band_Map[RFBand].m_RF3_Default;
+	bool    bcal = false;
+
+	s32    Cprog_cal1 = 0;
+	s32    Cprog_table1 = 0;
+	s32    Cprog_cal2 = 0;
+	s32    Cprog_table2 = 0;
+	s32    Cprog_cal3 = 0;
+	s32    Cprog_table3 = 0;
+
+	state->m_RF_A1[RFBand] = 0;
+	state->m_RF_B1[RFBand] = 0;
+	state->m_RF_A2[RFBand] = 0;
+	state->m_RF_B2[RFBand] = 0;
+
+	do {
+		CHK_ERROR(PowerScan(state,RFBand,RF1,&RF1,&bcal));
+		if( bcal ) {
+			CHK_ERROR(CalibrateRF(state,RFBand,RF1,&Cprog_cal1));
+		}
+		SearchMap2(m_RF_Cal_Map,RF1,&Cprog_table1);
+		if( !bcal ) {
+			Cprog_cal1 = Cprog_table1;
+		}
+		state->m_RF_B1[RFBand] = Cprog_cal1 - Cprog_table1;
+		//state->m_RF_A1[RF_Band] = ????
+
+		if( RF2 == 0 ) break;
+
+		CHK_ERROR(PowerScan(state,RFBand,RF2,&RF2,&bcal));
+		if( bcal ) {
+			CHK_ERROR(CalibrateRF(state,RFBand,RF2,&Cprog_cal2));
+		}
+		SearchMap2(m_RF_Cal_Map,RF2,&Cprog_table2);
+		if( !bcal )
+		{
+			Cprog_cal2 = Cprog_table2;
+		}
+
+		state->m_RF_A1[RFBand] =
+			(Cprog_cal2 - Cprog_table2 - Cprog_cal1 + Cprog_table1) /
+			((s32)(RF2)-(s32)(RF1));
+
+		if( RF3 == 0 ) break;
+
+		CHK_ERROR(PowerScan(state,RFBand,RF3,&RF3,&bcal));
+		if( bcal )
+		{
+			CHK_ERROR(CalibrateRF(state,RFBand,RF3,&Cprog_cal3));
+		}
+		SearchMap2(m_RF_Cal_Map,RF3,&Cprog_table3);
+		if( !bcal )
+		{
+			Cprog_cal3 = Cprog_table3;
+		}
+		state->m_RF_A2[RFBand] = (Cprog_cal3 - Cprog_table3 - Cprog_cal2 + Cprog_table2) / ((s32)(RF3)-(s32)(RF2));
+		state->m_RF_B2[RFBand] = Cprog_cal2 - Cprog_table2;
+
+	} while(0);
+
+	state->m_RF1[RFBand] = RF1;
+	state->m_RF2[RFBand] = RF2;
+	state->m_RF3[RFBand] = RF3;
+
+#if 0
+	printk("%s %d RF1 = %d A1 = %d B1 = %d RF2 = %d A2 = %d B2 = %d RF3 = %d\n", __FUNCTION__,
+	       RFBand,RF1,state->m_RF_A1[RFBand],state->m_RF_B1[RFBand],RF2,
+	       state->m_RF_A2[RFBand],state->m_RF_B2[RFBand],RF3);
+#endif
+
+	return status;
+}
+
+static int PowerScan(struct tda_state *state,
+		     u8 RFBand,u32 RF_in, u32 * pRF_Out, bool *pbcal)
+{
+    //KdPrintEx((MSG_TRACE " - " __FUNCTION__ "(%d,%d)\n",RFBand,RF_in));
+    int status = 0;
+    do {
+	    u8   Gain_Taper=0;
+	    s32  RFC_Cprog=0;
+	    u8   CID_Target=0;
+	    u8   CountLimit=0;
+	    u32  freq_MainPLL;
+	    u8   Regs[NUM_REGS];
+	    u8   CID_Gain;
+	    s32  Count = 0;
+	    int  sign  = 1;
+	    bool wait = false;
+
+	    if( ! (SearchMap2(m_RF_Cal_Map,RF_in,&RFC_Cprog) &&
+		   SearchMap1(m_GainTaper_Map,RF_in,&Gain_Taper) &&
+		   SearchMap3(m_CID_Target_Map,RF_in,&CID_Target,&CountLimit) )) {
+		    printk("%s Search map failed\n", __FUNCTION__);
+		    return -EINVAL;
+	    }
+
+	    state->m_Regs[EP2] = (RFBand << 5) | Gain_Taper;
+	    state->m_Regs[EB14] = (RFC_Cprog);
+	    CHK_ERROR(UpdateReg(state,EP2));
+	    CHK_ERROR(UpdateReg(state,EB14));
+
+	    freq_MainPLL = RF_in + 1000000;
+	    CHK_ERROR(CalcMainPLL(state,freq_MainPLL));
+	    msleep(5);
+	    state->m_Regs[EP4] = (state->m_Regs[EP4] & ~0x03) | 1;    // CAL_mode = 1
+	    CHK_ERROR(UpdateReg(state,EP4));
+	    CHK_ERROR(UpdateReg(state,EP2));  // Launch power measurement
+	    CHK_ERROR(ReadExtented(state,Regs));
+	    CID_Gain = Regs[EB10] & 0x3F;
+	    state->m_Regs[ID] = Regs[ID];  // Chip version, (needed for C1 workarround in CalibrateRF )
+
+	    *pRF_Out = RF_in;
+
+	    while( CID_Gain < CID_Target ) {
+		    freq_MainPLL = RF_in + sign * Count + 1000000;
+		    CHK_ERROR(CalcMainPLL(state,freq_MainPLL));
+		    msleep( wait ? 5 : 1 );
+		    wait = false;
+		    CHK_ERROR(UpdateReg(state,EP2));  // Launch power measurement
+		    CHK_ERROR(ReadExtented(state,Regs));
+		    CID_Gain = Regs[EB10] & 0x3F;
+		    Count += 200000;
+
+		    if( Count < CountLimit * 100000 ) continue;
+		    if( sign < 0 ) break;
+
+		    sign = -sign;
+		    Count = 200000;
+		    wait = true;
+	    }
+	    CHK_ERROR(status);
+	    if( CID_Gain >= CID_Target )
+	    {
+		    *pbcal = true;
+		    *pRF_Out = freq_MainPLL - 1000000;
+	    }
+	    else
+	    {
+		    *pbcal = false;
+	    }
+    } while(0);
+    //KdPrintEx((MSG_TRACE " - " __FUNCTION__ " Found = %d RF = %d\n",*pbcal,*pRF_Out));
+    return status;
+}
+
+static int PowerScanInit(struct tda_state *state)
+{
+	//KdPrintEx((MSG_TRACE " - " __FUNCTION__ "\n"));
+	int status = 0;
+	do
+	{
+		state->m_Regs[EP3] = (state->m_Regs[EP3] & ~0x1F) | 0x12;
+		state->m_Regs[EP4] = (state->m_Regs[EP4] & ~0x1F); // If level = 0, Cal mode = 0
+		CHK_ERROR(UpdateRegs(state,EP3,EP4));
+		state->m_Regs[EB18] = (state->m_Regs[EB18] & ~0x03 ); // AGC 1 Gain = 0
+		CHK_ERROR(UpdateReg(state,EB18));
+		state->m_Regs[EB21] = (state->m_Regs[EB21] & ~0x03 ); // AGC 2 Gain = 0 (Datasheet = 3)
+		state->m_Regs[EB23] = (state->m_Regs[EB23] | 0x06 ); // ForceLP_Fc2_En = 1, LPFc[2] = 1
+		CHK_ERROR(UpdateRegs(state,EB21,EB23));
+	} while(0);
+	return status;
+}
+
+static int CalcRFFilterCurve(struct tda_state *state)
+{
+	//KdPrintEx((MSG_TRACE " - " __FUNCTION__ "\n"));
+	int status = 0;
+	do
+	{
+		msleep(200);      // Temperature stabilisation
+		CHK_ERROR(PowerScanInit(state));
+		CHK_ERROR(RFTrackingFiltersInit(state,0));
+		CHK_ERROR(RFTrackingFiltersInit(state,1));
+		CHK_ERROR(RFTrackingFiltersInit(state,2));
+		CHK_ERROR(RFTrackingFiltersInit(state,3));
+		CHK_ERROR(RFTrackingFiltersInit(state,4));
+		CHK_ERROR(RFTrackingFiltersInit(state,5));
+		CHK_ERROR(RFTrackingFiltersInit(state,6));
+		CHK_ERROR(ThermometerRead(state,&state->m_TMValue_RFCal)); // also switches off Cal mode !!!
+	} while(0);
+
+	return status;
+}
+
+static int FixedContentsI2CUpdate(struct tda_state *state)
+{
+	static u8 InitRegs[] = {
+		0x08,0x80,0xC6,
+		0xDF,0x16,0x60,0x80,
+		0x80,0x00,0x00,0x00,
+		0x00,0x00,0x00,0x00,
+		0xFC,0x01,0x84,0x41,
+		0x01,0x84,0x40,0x07,
+		0x00,0x00,0x96,0x3F,
+		0xC1,0x00,0x8F,0x00,
+		0x00,0x8C,0x00,0x20,
+		0xB3,0x48,0xB0,
+	};
+	int status = 0;
+	memcpy(&state->m_Regs[TM],InitRegs,EB23-TM+1);
+	do {
+		CHK_ERROR(UpdateRegs(state,TM,EB23));
+
+		// AGC1 gain setup
+		state->m_Regs[EB17] = 0x00;
+		CHK_ERROR(UpdateReg(state,EB17));
+		state->m_Regs[EB17] = 0x03;
+		CHK_ERROR(UpdateReg(state,EB17));
+		state->m_Regs[EB17] = 0x43;
+		CHK_ERROR(UpdateReg(state,EB17));
+		state->m_Regs[EB17] = 0x4C;
+		CHK_ERROR(UpdateReg(state,EB17));
+
+		// IRC Cal Low band
+		state->m_Regs[EP3] = 0x1F;
+		state->m_Regs[EP4] = 0x66;
+		state->m_Regs[EP5] = 0x81;
+		state->m_Regs[CPD] = 0xCC;
+		state->m_Regs[CD1] = 0x6C;
+		state->m_Regs[CD2] = 0x00;
+		state->m_Regs[CD3] = 0x00;
+		state->m_Regs[MPD] = 0xC5;
+		state->m_Regs[MD1] = 0x77;
+		state->m_Regs[MD2] = 0x08;
+		state->m_Regs[MD3] = 0x00;
+		CHK_ERROR(UpdateRegs(state,EP2,MD3)); // diff between sw and datasheet (ep3-md3)
+
+		//state->m_Regs[EB4] = 0x61;          // missing in sw
+		//CHK_ERROR(UpdateReg(state,EB4));
+		//msleep(1);
+		//state->m_Regs[EB4] = 0x41;
+		//CHK_ERROR(UpdateReg(state,EB4));
+
+		msleep(5);
+		CHK_ERROR(UpdateReg(state,EP1));
+		msleep(5);
+
+		state->m_Regs[EP5] = 0x85;
+		state->m_Regs[CPD] = 0xCB;
+		state->m_Regs[CD1] = 0x66;
+		state->m_Regs[CD2] = 0x70;
+		CHK_ERROR(UpdateRegs(state,EP3,CD3));
+		msleep(5);
+		CHK_ERROR(UpdateReg(state,EP2));
+		msleep(30);
+
+		// IRC Cal mid band
+		state->m_Regs[EP5] = 0x82;
+		state->m_Regs[CPD] = 0xA8;
+		state->m_Regs[CD2] = 0x00;
+		state->m_Regs[MPD] = 0xA1; // Datasheet = 0xA9
+		state->m_Regs[MD1] = 0x73;
+		state->m_Regs[MD2] = 0x1A;
+		CHK_ERROR(UpdateRegs(state,EP3,MD3));
+
+		msleep(5);
+		CHK_ERROR(UpdateReg(state,EP1));
+		msleep(5);
+
+		state->m_Regs[EP5] = 0x86;
+		state->m_Regs[CPD] = 0xA8;
+		state->m_Regs[CD1] = 0x66;
+		state->m_Regs[CD2] = 0xA0;
+		CHK_ERROR(UpdateRegs(state,EP3,CD3));
+		msleep(5);
+		CHK_ERROR(UpdateReg(state,EP2));
+		msleep(30);
+
+		// IRC Cal high band
+		state->m_Regs[EP5] = 0x83;
+		state->m_Regs[CPD] = 0x98;
+		state->m_Regs[CD1] = 0x65;
+		state->m_Regs[CD2] = 0x00;
+		state->m_Regs[MPD] = 0x91;  // Datasheet = 0x91
+		state->m_Regs[MD1] = 0x71;
+		state->m_Regs[MD2] = 0xCD;
+		CHK_ERROR(UpdateRegs(state,EP3,MD3));
+		msleep(5);
+		CHK_ERROR(UpdateReg(state,EP1));
+		msleep(5);
+		state->m_Regs[EP5] = 0x87;
+		state->m_Regs[CD1] = 0x65;
+		state->m_Regs[CD2] = 0x50;
+		CHK_ERROR(UpdateRegs(state,EP3,CD3));
+		msleep(5);
+		CHK_ERROR(UpdateReg(state,EP2));
+		msleep(30);
+
+		// Back to normal
+		state->m_Regs[EP4] = 0x64;
+		CHK_ERROR(UpdateReg(state,EP4));
+		CHK_ERROR(UpdateReg(state,EP1));
+
+	} while(0);
+	return status;
+}
+
+static int InitCal(struct tda_state *state)
+{
+	int status = 0;
+
+	do
+	{
+		CHK_ERROR(FixedContentsI2CUpdate(state));
+		CHK_ERROR(CalcRFFilterCurve(state));
+		CHK_ERROR(StandBy(state));
+		//m_bInitDone = true;
+	} while(0);
+	return status;
+};
+
+static int RFTrackingFiltersCorrection(struct tda_state *state,
+				       u32 Frequency)
+{
+	int status = 0;
+	s32 Cprog_table;
+	u8 RFBand;
+	u8 dCoverdT;
+
+	if( !SearchMap2(m_RF_Cal_Map,Frequency,&Cprog_table) ||
+	    !SearchMap4(m_RF_Band_Map,Frequency,&RFBand) ||
+	    !SearchMap1(m_RF_Cal_DC_Over_DT_Map,Frequency,&dCoverdT) )
+	{
+		return -EINVAL;
+	}
+
+	do
+	{
+		u8 TMValue_Current;
+		u32   RF1 = state->m_RF1[RFBand];
+		u32   RF2 = state->m_RF1[RFBand];
+		u32   RF3 = state->m_RF1[RFBand];
+		s32    RF_A1 = state->m_RF_A1[RFBand];
+		s32    RF_B1 = state->m_RF_B1[RFBand];
+		s32    RF_A2 = state->m_RF_A2[RFBand];
+		s32    RF_B2 = state->m_RF_B2[RFBand];
+		s32 Capprox = 0;
+		int TComp;
+
+		state->m_Regs[EP3] &= ~0xE0;  // Power up
+		CHK_ERROR(UpdateReg(state,EP3));
+
+		CHK_ERROR(ThermometerRead(state,&TMValue_Current));
+
+		if( RF3 == 0 || Frequency < RF2 )
+		{
+			Capprox = RF_A1 * ((s32)(Frequency) - (s32)(RF1)) + RF_B1 + Cprog_table;
+		}
+		else
+		{
+			Capprox = RF_A2 * ((s32)(Frequency) - (s32)(RF2)) + RF_B2 + Cprog_table;
+		}
+
+		TComp = (int)(dCoverdT) * ((int)(TMValue_Current) - (int)(state->m_TMValue_RFCal))/1000;
+
+		Capprox += TComp;
+
+		if( Capprox < 0 ) Capprox = 0;
+		else if( Capprox > 255 ) Capprox = 255;
+
+
+		// TODO Temperature compensation. There is defenitely a scale factor
+		//      missing in the datasheet, so leave it out for now.
+		state->m_Regs[EB14] = (Capprox );
+
+		CHK_ERROR(UpdateReg(state,EB14));
+
+	} while(0);
+	return status;
+}
+
+static int ChannelConfiguration(struct tda_state *state,
+				u32 Frequency, int Standard)
+{
+
+	s32 IntermediateFrequency = m_StandardTable[Standard].m_IFFrequency;
+	int status = 0;
+
+	u8 BP_Filter = 0;
+	u8 RF_Band = 0;
+	u8 GainTaper = 0;
+	u8 IR_Meas;
+
+	state->IF=IntermediateFrequency;
+	//printk("%s Freq = %d Standard = %d IF = %d\n",__FUNCTION__,Frequency,Standard,IntermediateFrequency);
+	// get values from tables
+
+	if(! ( SearchMap1(m_BP_Filter_Map,Frequency,&BP_Filter) &&
+	       SearchMap1(m_GainTaper_Map,Frequency,&GainTaper) &&
+	       SearchMap1(m_IR_Meas_Map,Frequency,&IR_Meas) &&
+	       SearchMap4(m_RF_Band_Map,Frequency,&RF_Band) ) )
+	{
+		printk("%s SearchMap failed\n", __FUNCTION__);
+		return -EINVAL;
+	}
+
+	do
+	{
+		state->m_Regs[EP3] = (state->m_Regs[EP3] & ~0x1F) | m_StandardTable[Standard].m_EP3_4_0;
+		state->m_Regs[EP3] &= ~0x04;   // switch RFAGC to high speed mode
+
+		// m_EP4 default for XToutOn, CAL_Mode (0)
+		state->m_Regs[EP4] = state->m_EP4 | ((Standard > HF_AnalogMax )? state->m_IFLevelDigital : state->m_IFLevelAnalog );
+		//state->m_Regs[EP4] = state->m_EP4 | state->m_IFLevelDigital;
+		if( Standard <= HF_AnalogMax ) state->m_Regs[EP4] = state->m_EP4 | state->m_IFLevelAnalog;
+		else if( Standard <= HF_ATSC      ) state->m_Regs[EP4] = state->m_EP4 | state->m_IFLevelDVBT;
+		else if( Standard <= HF_DVBC      ) state->m_Regs[EP4] = state->m_EP4 | state->m_IFLevelDVBC;
+		else                                state->m_Regs[EP4] = state->m_EP4 | state->m_IFLevelDigital;
+
+		if( (Standard == HF_FM_Radio) && state->m_bFMInput ) state->m_Regs[EP4] |= 80;
+
+		state->m_Regs[MPD] &= ~0x80;
+		if( Standard > HF_AnalogMax ) state->m_Regs[MPD] |= 0x80; // Add IF_notch for digital
+
+		state->m_Regs[EB22] = m_StandardTable[Standard].m_EB22;
+
+		// Note: This is missing from flowchart in TDA18271 specification ( 1.5 MHz cutoff for FM )
+		if( Standard == HF_FM_Radio ) state->m_Regs[EB23] |=  0x06; // ForceLP_Fc2_En = 1, LPFc[2] = 1
+		else                          state->m_Regs[EB23] &= ~0x06; // ForceLP_Fc2_En = 0, LPFc[2] = 0
+
+		CHK_ERROR(UpdateRegs(state,EB22,EB23));
+
+		state->m_Regs[EP1] = (state->m_Regs[EP1] & ~0x07) | 0x40 | BP_Filter;   // Dis_Power_level = 1, Filter
+		state->m_Regs[EP5] = (state->m_Regs[EP5] & ~0x07) | IR_Meas;
+		state->m_Regs[EP2] = (RF_Band << 5) | GainTaper;
+
+		state->m_Regs[EB1] = (state->m_Regs[EB1] & ~0x07) |
+			(state->m_bMaster ? 0x04 : 0x00); // CALVCO_FortLOn = MS
+		// AGC1_always_master = 0
+		// AGC_firstn = 0
+		CHK_ERROR(UpdateReg(state,EB1));
+
+		if( state->m_bMaster )
+		{
+			CHK_ERROR(CalcMainPLL(state,Frequency + IntermediateFrequency));
+			CHK_ERROR(UpdateRegs(state,TM,EP5));
+			state->m_Regs[EB4] |= 0x20;    // LO_forceSrce = 1
+			CHK_ERROR(UpdateReg(state,EB4));
+			msleep(1);
+			state->m_Regs[EB4] &= ~0x20;   // LO_forceSrce = 0
+			CHK_ERROR(UpdateReg(state,EB4));
+		}
+		else
+		{
+			u8 PostDiv;
+			u8 Div;
+			CHK_ERROR(CalcCalPLL(state,Frequency + IntermediateFrequency));
+
+			SearchMap3(m_Cal_PLL_Map,Frequency + IntermediateFrequency,&PostDiv,&Div);
+			state->m_Regs[MPD] = (state->m_Regs[MPD] & ~0x7F) | (PostDiv & 0x77);
+			CHK_ERROR(UpdateReg(state,MPD));
+			CHK_ERROR(UpdateRegs(state,TM,EP5));
+
+			state->m_Regs[EB7] |= 0x20;    // CAL_forceSrce = 1
+			CHK_ERROR(UpdateReg(state,EB7));
+			msleep(1);
+			state->m_Regs[EB7] &= ~0x20;   // CAL_forceSrce = 0
+			CHK_ERROR(UpdateReg(state,EB7));
+		}
+		msleep(20);
+		if( Standard != HF_FM_Radio )
+		{
+			state->m_Regs[EP3] |= 0x04;    // RFAGC to normal mode
+		}
+		CHK_ERROR(UpdateReg(state,EP3));
+
+	} while(0);
+	return status;
+}
+
+static int sleep(struct dvb_frontend* fe)
+{
+	struct tda_state *state = fe->tuner_priv;
+
+	StandBy(state);
+	return 0;
+}
+
+static int init(struct dvb_frontend* fe)
+{
+	//struct tda_state *state = fe->tuner_priv;
+	return 0;
+}
+
+static int release(struct dvb_frontend* fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+	return 0;
+}
+
+static int set_params(struct dvb_frontend *fe,
+		      struct dvb_frontend_parameters *params)
+{
+	struct tda_state *state = fe->tuner_priv;
+	int status = 0;
+	int Standard;
+
+	state->m_Frequency = params->frequency;
+
+	if (fe->ops.info.type == FE_OFDM)
+		switch (params->u.ofdm.bandwidth) {
+		case BANDWIDTH_6_MHZ:
+			Standard = HF_DVBT_6MHZ;
+			break;
+		case BANDWIDTH_7_MHZ:
+			Standard = HF_DVBT_7MHZ;
+			break;
+		default:
+		case BANDWIDTH_8_MHZ:
+			Standard = HF_DVBT_8MHZ;
+			break;
+		}
+	else if (fe->ops.info.type == FE_QAM) {
+		Standard = HF_DVBC_8MHZ;
+	} else
+		return -EINVAL;
+	do {
+		CHK_ERROR(RFTrackingFiltersCorrection(state,params->frequency));
+		CHK_ERROR(ChannelConfiguration(state,params->frequency,Standard));
+
+		msleep(state->m_SettlingTime);  // Allow AGC's to settle down
+	} while(0);
+	return status;
+}
+
+#if 0
+static int GetSignalStrength(s32 * pSignalStrength,u32 RFAgc,u32 IFAgc)
+{
+	if( IFAgc < 500 ) {
+		// Scale this from 0 to 50000
+		*pSignalStrength = IFAgc * 100;
+	} else {
+		// Scale range 500-1500 to 50000-80000
+		*pSignalStrength = 50000 + (IFAgc - 500) * 30;
+	}
+
+	return 0;
+}
+#endif
+
+static int get_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	struct tda_state *state = fe->tuner_priv;
+
+	*frequency = state->IF;
+	return 0;
+}
+
+static int get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
+{
+	//struct tda_state *state = fe->tuner_priv;
+	//*bandwidth = priv->bandwidth;
+	return 0;
+}
+
+
+static struct dvb_tuner_ops tuner_ops = {
+	.info = {
+		.name = "NXP TDA18271C2D",
+		.frequency_min  =  47125000,
+		.frequency_max  = 865000000,
+		.frequency_step =     62500
+	},
+	.init              = init,
+	.sleep             = sleep,
+	.set_params        = set_params,
+	.release           = release,
+	.get_frequency     = get_frequency,
+	.get_bandwidth     = get_bandwidth,
+};
+
+struct dvb_frontend *tda18271c2dd_attach(struct dvb_frontend *fe,
+					 struct i2c_adapter *i2c, u8 adr)
+{
+	struct tda_state *state;
+
+	state = kzalloc(sizeof(struct tda_state), GFP_KERNEL);
+	if (!state)
+		return NULL;
+
+	fe->tuner_priv = state;
+	state->adr = adr;
+	state->i2c = i2c;
+	memcpy(&fe->ops.tuner_ops, &tuner_ops, sizeof(struct dvb_tuner_ops));
+	reset(state);
+	InitCal(state);
+
+	return fe;
+}
+
+EXPORT_SYMBOL_GPL(tda18271c2dd_attach);
+MODULE_DESCRIPTION("TDA18271C2 driver");
+MODULE_AUTHOR("DD");
+MODULE_LICENSE("GPL");
+
+/*
+ * Local variables:
+ * c-basic-offset: 8
+ * End:
+ */
diff --git a/drivers/media/dvb/frontends/tda18271c2dd.h b/drivers/media/dvb/frontends/tda18271c2dd.h
new file mode 100644
index 0000000..492badd
--- /dev/null
+++ b/drivers/media/dvb/frontends/tda18271c2dd.h
@@ -0,0 +1,5 @@
+#ifndef _TDA18271C2DD_H_
+#define _TDA18271C2DD_H_
+struct dvb_frontend *tda18271c2dd_attach(struct dvb_frontend *fe,
+					 struct i2c_adapter *i2c, u8 adr);
+#endif
diff --git a/drivers/media/dvb/frontends/tda18271c2dd_maps.h b/drivers/media/dvb/frontends/tda18271c2dd_maps.h
new file mode 100644
index 0000000..21fa4e1
--- /dev/null
+++ b/drivers/media/dvb/frontends/tda18271c2dd_maps.h
@@ -0,0 +1,810 @@
+enum HF_S {
+	HF_None=0, HF_B, HF_DK, HF_G, HF_I, HF_L, HF_L1, HF_MN, HF_FM_Radio,
+	HF_AnalogMax, HF_DVBT_6MHZ, HF_DVBT_7MHZ, HF_DVBT_8MHZ,
+	HF_DVBT, HF_ATSC,  HF_DVBC_6MHZ,  HF_DVBC_7MHZ,
+	HF_DVBC_8MHZ, HF_DVBC
+};
+
+struct SStandardParam m_StandardTable[] =
+{
+    {       0,        0, 0x00, 0x00 },    // HF_None
+    { 6000000,  7000000, 0x1D, 0x2C },    // HF_B,
+    { 6900000,  8000000, 0x1E, 0x2C },    // HF_DK,
+    { 7100000,  8000000, 0x1E, 0x2C },    // HF_G,
+    { 7250000,  8000000, 0x1E, 0x2C },    // HF_I,
+    { 6900000,  8000000, 0x1E, 0x2C },    // HF_L,
+    { 1250000,  8000000, 0x1E, 0x2C },    // HF_L1,
+    { 5400000,  6000000, 0x1C, 0x2C },    // HF_MN,
+    { 1250000,   500000, 0x18, 0x2C },    // HF_FM_Radio,
+    {       0,        0, 0x00, 0x00 },    // HF_AnalogMax (Unused)
+    { 3300000,  6000000, 0x1C, 0x58 },    // HF_DVBT_6MHZ
+    { 3500000,  7000000, 0x1C, 0x37 },    // HF_DVBT_7MHZ
+    { 4000000,  8000000, 0x1D, 0x37 },    // HF_DVBT_8MHZ
+    {       0,        0, 0x00, 0x00 },    // HF_DVBT (Unused)
+    { 5000000,  6000000, 0x1C, 0x37 },    // HF_ATSC  (center = 3.25 MHz)
+    { 4000000,  6000000, 0x1D, 0x58 },    // HF_DVBC_6MHZ (Chicago)
+    { 4500000,  7000000, 0x1E, 0x37 },    // HF_DVBC_7MHZ (not documented by NXP)
+    { 5000000,  8000000, 0x1F, 0x37 },    // HF_DVBC_8MHZ
+    {       0,        0, 0x00, 0x00 },    // HF_DVBC (Unused)
+};
+
+struct SMap  m_BP_Filter_Map[] = {
+    {   62000000,  0x00 },
+    {   84000000,  0x01 },
+    {  100000000,  0x02 },
+    {  140000000,  0x03 },
+    {  170000000,  0x04 },
+    {  180000000,  0x05 },
+    {  865000000,  0x06 },
+    {          0,  0x00 },    // Table End
+};
+
+static struct SMapI m_RF_Cal_Map[] = {
+    {   41000000,  0x0F },
+    {   43000000,  0x1C },
+    {   45000000,  0x2F },
+    {   46000000,  0x39 },
+    {   47000000,  0x40 },
+    {   47900000,  0x50 },
+    {   49100000,  0x16 },
+    {   50000000,  0x18 },
+    {   51000000,  0x20 },
+    {   53000000,  0x28 },
+    {   55000000,  0x2B },
+    {   56000000,  0x32 },
+    {   57000000,  0x35 },
+    {   58000000,  0x3E },
+    {   59000000,  0x43 },
+    {   60000000,  0x4E },
+    {   61100000,  0x55 },
+    {   63000000,  0x0F },
+    {   64000000,  0x11 },
+    {   65000000,  0x12 },
+    {   66000000,  0x15 },
+    {   67000000,  0x16 },
+    {   68000000,  0x17 },
+    {   70000000,  0x19 },
+    {   71000000,  0x1C },
+    {   72000000,  0x1D },
+    {   73000000,  0x1F },
+    {   74000000,  0x20 },
+    {   75000000,  0x21 },
+    {   76000000,  0x24 },
+    {   77000000,  0x25 },
+    {   78000000,  0x27 },
+    {   80000000,  0x28 },
+    {   81000000,  0x29 },
+    {   82000000,  0x2D },
+    {   83000000,  0x2E },
+    {   84000000,  0x2F },
+    {   85000000,  0x31 },
+    {   86000000,  0x33 },
+    {   87000000,  0x34 },
+    {   88000000,  0x35 },
+    {   89000000,  0x37 },
+    {   90000000,  0x38 },
+    {   91000000,  0x39 },
+    {   93000000,  0x3C },
+    {   94000000,  0x3E },
+    {   95000000,  0x3F },
+    {   96000000,  0x40 },
+    {   97000000,  0x42 },
+    {   99000000,  0x45 },
+    {  100000000,  0x46 },
+    {  102000000,  0x48 },
+    {  103000000,  0x4A },
+    {  105000000,  0x4D },
+    {  106000000,  0x4E },
+    {  107000000,  0x50 },
+    {  108000000,  0x51 },
+    {  110000000,  0x54 },
+    {  111000000,  0x56 },
+    {  112000000,  0x57 },
+    {  113000000,  0x58 },
+    {  114000000,  0x59 },
+    {  115000000,  0x5C },
+    {  116000000,  0x5D },
+    {  117000000,  0x5F },
+    {  119000000,  0x60 },
+    {  120000000,  0x64 },
+    {  121000000,  0x65 },
+    {  122000000,  0x66 },
+    {  123000000,  0x68 },
+    {  124000000,  0x69 },
+    {  125000000,  0x6C },
+    {  126000000,  0x6D },
+    {  127000000,  0x6E },
+    {  128000000,  0x70 },
+    {  129000000,  0x71 },
+    {  130000000,  0x75 },
+    {  131000000,  0x77 },
+    {  132000000,  0x78 },
+    {  133000000,  0x7B },
+    {  134000000,  0x7E },
+    {  135000000,  0x81 },
+    {  136000000,  0x82 },
+    {  137000000,  0x87 },
+    {  138000000,  0x88 },
+    {  139000000,  0x8D },
+    {  140000000,  0x8E },
+    {  141000000,  0x91 },
+    {  142000000,  0x95 },
+    {  143000000,  0x9A },
+    {  144000000,  0x9D },
+    {  145000000,  0xA1 },
+    {  146000000,  0xA2 },
+    {  147000000,  0xA4 },
+    {  148000000,  0xA9 },
+    {  149000000,  0xAE },
+    {  150000000,  0xB0 },
+    {  151000000,  0xB1 },
+    {  152000000,  0xB7 },
+    {  152600000,  0xBD },
+    {  154000000,  0x20 },
+    {  155000000,  0x22 },
+    {  156000000,  0x24 },
+    {  157000000,  0x25 },
+    {  158000000,  0x27 },
+    {  159000000,  0x29 },
+    {  160000000,  0x2C },
+    {  161000000,  0x2D },
+    {  163000000,  0x2E },
+    {  164000000,  0x2F },
+    {  164700000,  0x30 },
+    {  166000000,  0x11 },
+    {  167000000,  0x12 },
+    {  168000000,  0x13 },
+    {  169000000,  0x14 },
+    {  170000000,  0x15 },
+    {  172000000,  0x16 },
+    {  173000000,  0x17 },
+    {  174000000,  0x18 },
+    {  175000000,  0x1A },
+    {  176000000,  0x1B },
+    {  178000000,  0x1D },
+    {  179000000,  0x1E },
+    {  180000000,  0x1F },
+    {  181000000,  0x20 },
+    {  182000000,  0x21 },
+    {  183000000,  0x22 },
+    {  184000000,  0x24 },
+    {  185000000,  0x25 },
+    {  186000000,  0x26 },
+    {  187000000,  0x27 },
+    {  188000000,  0x29 },
+    {  189000000,  0x2A },
+    {  190000000,  0x2C },
+    {  191000000,  0x2D },
+    {  192000000,  0x2E },
+    {  193000000,  0x2F },
+    {  194000000,  0x30 },
+    {  195000000,  0x33 },
+    {  196000000,  0x35 },
+    {  198000000,  0x36 },
+    {  200000000,  0x38 },
+    {  201000000,  0x3C },
+    {  202000000,  0x3D },
+    {  203500000,  0x3E },
+    {  206000000,  0x0E },
+    {  208000000,  0x0F },
+    {  212000000,  0x10 },
+    {  216000000,  0x11 },
+    {  217000000,  0x12 },
+    {  218000000,  0x13 },
+    {  220000000,  0x14 },
+    {  222000000,  0x15 },
+    {  225000000,  0x16 },
+    {  228000000,  0x17 },
+    {  231000000,  0x18 },
+    {  234000000,  0x19 },
+    {  235000000,  0x1A },
+    {  236000000,  0x1B },
+    {  237000000,  0x1C },
+    {  240000000,  0x1D },
+    {  242000000,  0x1E },
+    {  244000000,  0x1F },
+    {  247000000,  0x20 },
+    {  249000000,  0x21 },
+    {  252000000,  0x22 },
+    {  253000000,  0x23 },
+    {  254000000,  0x24 },
+    {  256000000,  0x25 },
+    {  259000000,  0x26 },
+    {  262000000,  0x27 },
+    {  264000000,  0x28 },
+    {  267000000,  0x29 },
+    {  269000000,  0x2A },
+    {  271000000,  0x2B },
+    {  273000000,  0x2C },
+    {  275000000,  0x2D },
+    {  277000000,  0x2E },
+    {  279000000,  0x2F },
+    {  282000000,  0x30 },
+    {  284000000,  0x31 },
+    {  286000000,  0x32 },
+    {  287000000,  0x33 },
+    {  290000000,  0x34 },
+    {  293000000,  0x35 },
+    {  295000000,  0x36 },
+    {  297000000,  0x37 },
+    {  300000000,  0x38 },
+    {  303000000,  0x39 },
+    {  305000000,  0x3A },
+    {  306000000,  0x3B },
+    {  307000000,  0x3C },
+    {  310000000,  0x3D },
+    {  312000000,  0x3E },
+    {  315000000,  0x3F },
+    {  318000000,  0x40 },
+    {  320000000,  0x41 },
+    {  323000000,  0x42 },
+    {  324000000,  0x43 },
+    {  325000000,  0x44 },
+    {  327000000,  0x45 },
+    {  331000000,  0x46 },
+    {  334000000,  0x47 },
+    {  337000000,  0x48 },
+    {  339000000,  0x49 },
+    {  340000000,  0x4A },
+    {  341000000,  0x4B },
+    {  343000000,  0x4C },
+    {  345000000,  0x4D },
+    {  349000000,  0x4E },
+    {  352000000,  0x4F },
+    {  353000000,  0x50 },
+    {  355000000,  0x51 },
+    {  357000000,  0x52 },
+    {  359000000,  0x53 },
+    {  361000000,  0x54 },
+    {  362000000,  0x55 },
+    {  364000000,  0x56 },
+    {  368000000,  0x57 },
+    {  370000000,  0x58 },
+    {  372000000,  0x59 },
+    {  375000000,  0x5A },
+    {  376000000,  0x5B },
+    {  377000000,  0x5C },
+    {  379000000,  0x5D },
+    {  382000000,  0x5E },
+    {  384000000,  0x5F },
+    {  385000000,  0x60 },
+    {  386000000,  0x61 },
+    {  388000000,  0x62 },
+    {  390000000,  0x63 },
+    {  393000000,  0x64 },
+    {  394000000,  0x65 },
+    {  396000000,  0x66 },
+    {  397000000,  0x67 },
+    {  398000000,  0x68 },
+    {  400000000,  0x69 },
+    {  402000000,  0x6A },
+    {  403000000,  0x6B },
+    {  407000000,  0x6C },
+    {  408000000,  0x6D },
+    {  409000000,  0x6E },
+    {  410000000,  0x6F },
+    {  411000000,  0x70 },
+    {  412000000,  0x71 },
+    {  413000000,  0x72 },
+    {  414000000,  0x73 },
+    {  417000000,  0x74 },
+    {  418000000,  0x75 },
+    {  420000000,  0x76 },
+    {  422000000,  0x77 },
+    {  423000000,  0x78 },
+    {  424000000,  0x79 },
+    {  427000000,  0x7A },
+    {  428000000,  0x7B },
+    {  429000000,  0x7D },
+    {  432000000,  0x7F },
+    {  434000000,  0x80 },
+    {  435000000,  0x81 },
+    {  436000000,  0x83 },
+    {  437000000,  0x84 },
+    {  438000000,  0x85 },
+    {  439000000,  0x86 },
+    {  440000000,  0x87 },
+    {  441000000,  0x88 },
+    {  442000000,  0x89 },
+    {  445000000,  0x8A },
+    {  446000000,  0x8B },
+    {  447000000,  0x8C },
+    {  448000000,  0x8E },
+    {  449000000,  0x8F },
+    {  450000000,  0x90 },
+    {  452000000,  0x91 },
+    {  453000000,  0x93 },
+    {  454000000,  0x94 },
+    {  456000000,  0x96 },
+    {  457800000,  0x98 },
+    {  461000000,  0x11 },
+    {  468000000,  0x12 },
+    {  472000000,  0x13 },
+    {  473000000,  0x14 },
+    {  474000000,  0x15 },
+    {  481000000,  0x16 },
+    {  486000000,  0x17 },
+    {  491000000,  0x18 },
+    {  498000000,  0x19 },
+    {  499000000,  0x1A },
+    {  501000000,  0x1B },
+    {  506000000,  0x1C },
+    {  511000000,  0x1D },
+    {  516000000,  0x1E },
+    {  520000000,  0x1F },
+    {  521000000,  0x20 },
+    {  525000000,  0x21 },
+    {  529000000,  0x22 },
+    {  533000000,  0x23 },
+    {  539000000,  0x24 },
+    {  541000000,  0x25 },
+    {  547000000,  0x26 },
+    {  549000000,  0x27 },
+    {  551000000,  0x28 },
+    {  556000000,  0x29 },
+    {  561000000,  0x2A },
+    {  563000000,  0x2B },
+    {  565000000,  0x2C },
+    {  569000000,  0x2D },
+    {  571000000,  0x2E },
+    {  577000000,  0x2F },
+    {  580000000,  0x30 },
+    {  582000000,  0x31 },
+    {  584000000,  0x32 },
+    {  588000000,  0x33 },
+    {  591000000,  0x34 },
+    {  596000000,  0x35 },
+    {  598000000,  0x36 },
+    {  603000000,  0x37 },
+    {  604000000,  0x38 },
+    {  606000000,  0x39 },
+    {  612000000,  0x3A },
+    {  615000000,  0x3B },
+    {  617000000,  0x3C },
+    {  621000000,  0x3D },
+    {  622000000,  0x3E },
+    {  625000000,  0x3F },
+    {  632000000,  0x40 },
+    {  633000000,  0x41 },
+    {  634000000,  0x42 },
+    {  642000000,  0x43 },
+    {  643000000,  0x44 },
+    {  647000000,  0x45 },
+    {  650000000,  0x46 },
+    {  652000000,  0x47 },
+    {  657000000,  0x48 },
+    {  661000000,  0x49 },
+    {  662000000,  0x4A },
+    {  665000000,  0x4B },
+    {  667000000,  0x4C },
+    {  670000000,  0x4D },
+    {  673000000,  0x4E },
+    {  676000000,  0x4F },
+    {  677000000,  0x50 },
+    {  681000000,  0x51 },
+    {  683000000,  0x52 },
+    {  686000000,  0x53 },
+    {  688000000,  0x54 },
+    {  689000000,  0x55 },
+    {  691000000,  0x56 },
+    {  695000000,  0x57 },
+    {  698000000,  0x58 },
+    {  703000000,  0x59 },
+    {  704000000,  0x5A },
+    {  705000000,  0x5B },
+    {  707000000,  0x5C },
+    {  710000000,  0x5D },
+    {  712000000,  0x5E },
+    {  717000000,  0x5F },
+    {  718000000,  0x60 },
+    {  721000000,  0x61 },
+    {  722000000,  0x62 },
+    {  723000000,  0x63 },
+    {  725000000,  0x64 },
+    {  727000000,  0x65 },
+    {  730000000,  0x66 },
+    {  732000000,  0x67 },
+    {  735000000,  0x68 },
+    {  740000000,  0x69 },
+    {  741000000,  0x6A },
+    {  742000000,  0x6B },
+    {  743000000,  0x6C },
+    {  745000000,  0x6D },
+    {  747000000,  0x6E },
+    {  748000000,  0x6F },
+    {  750000000,  0x70 },
+    {  752000000,  0x71 },
+    {  754000000,  0x72 },
+    {  757000000,  0x73 },
+    {  758000000,  0x74 },
+    {  760000000,  0x75 },
+    {  763000000,  0x76 },
+    {  764000000,  0x77 },
+    {  766000000,  0x78 },
+    {  767000000,  0x79 },
+    {  768000000,  0x7A },
+    {  773000000,  0x7B },
+    {  774000000,  0x7C },
+    {  776000000,  0x7D },
+    {  777000000,  0x7E },
+    {  778000000,  0x7F },
+    {  779000000,  0x80 },
+    {  781000000,  0x81 },
+    {  783000000,  0x82 },
+    {  784000000,  0x83 },
+    {  785000000,  0x84 },
+    {  786000000,  0x85 },
+    {  793000000,  0x86 },
+    {  794000000,  0x87 },
+    {  795000000,  0x88 },
+    {  797000000,  0x89 },
+    {  799000000,  0x8A },
+    {  801000000,  0x8B },
+    {  802000000,  0x8C },
+    {  803000000,  0x8D },
+    {  804000000,  0x8E },
+    {  810000000,  0x90 },
+    {  811000000,  0x91 },
+    {  812000000,  0x92 },
+    {  814000000,  0x93 },
+    {  816000000,  0x94 },
+    {  817000000,  0x96 },
+    {  818000000,  0x97 },
+    {  820000000,  0x98 },
+    {  821000000,  0x99 },
+    {  822000000,  0x9A },
+    {  828000000,  0x9B },
+    {  829000000,  0x9D },
+    {  830000000,  0x9F },
+    {  831000000,  0xA0 },
+    {  833000000,  0xA1 },
+    {  835000000,  0xA2 },
+    {  836000000,  0xA3 },
+    {  837000000,  0xA4 },
+    {  838000000,  0xA6 },
+    {  840000000,  0xA8 },
+    {  842000000,  0xA9 },
+    {  845000000,  0xAA },
+    {  846000000,  0xAB },
+    {  847000000,  0xAD },
+    {  848000000,  0xAE },
+    {  852000000,  0xAF },
+    {  853000000,  0xB0 },
+    {  858000000,  0xB1 },
+    {  860000000,  0xB2 },
+    {  861000000,  0xB3 },
+    {  862000000,  0xB4 },
+    {  863000000,  0xB6 },
+    {  864000000,  0xB8 },
+    {  865000000,  0xB9 },
+    {          0,  0x00 },    // Table End
+};
+
+
+static struct SMap2  m_KM_Map[] = {
+    {   47900000,  3, 2 },
+    {   61100000,  3, 1 },
+    {  350000000,  3, 0 },
+    {  720000000,  2, 1 },
+    {  865000000,  3, 3 },
+    {          0,  0x00 },    // Table End
+};
+
+static struct SMap2 m_Main_PLL_Map[] = {
+    {  33125000, 0x57, 0xF0 },
+    {  35500000, 0x56, 0xE0 },
+    {  38188000, 0x55, 0xD0 },
+    {  41375000, 0x54, 0xC0 },
+    {  45125000, 0x53, 0xB0 },
+    {  49688000, 0x52, 0xA0 },
+    {  55188000, 0x51, 0x90 },
+    {  62125000, 0x50, 0x80 },
+    {  66250000, 0x47, 0x78 },
+    {  71000000, 0x46, 0x70 },
+    {  76375000, 0x45, 0x68 },
+    {  82750000, 0x44, 0x60 },
+    {  90250000, 0x43, 0x58 },
+    {  99375000, 0x42, 0x50 },
+    { 110375000, 0x41, 0x48 },
+    { 124250000, 0x40, 0x40 },
+    { 132500000, 0x37, 0x3C },
+    { 142000000, 0x36, 0x38 },
+    { 152750000, 0x35, 0x34 },
+    { 165500000, 0x34, 0x30 },
+    { 180500000, 0x33, 0x2C },
+    { 198750000, 0x32, 0x28 },
+    { 220750000, 0x31, 0x24 },
+    { 248500000, 0x30, 0x20 },
+    { 265000000, 0x27, 0x1E },
+    { 284000000, 0x26, 0x1C },
+    { 305500000, 0x25, 0x1A },
+    { 331000000, 0x24, 0x18 },
+    { 361000000, 0x23, 0x16 },
+    { 397500000, 0x22, 0x14 },
+    { 441500000, 0x21, 0x12 },
+    { 497000000, 0x20, 0x10 },
+    { 530000000, 0x17, 0x0F },
+    { 568000000, 0x16, 0x0E },
+    { 611000000, 0x15, 0x0D },
+    { 662000000, 0x14, 0x0C },
+    { 722000000, 0x13, 0x0B },
+    { 795000000, 0x12, 0x0A },
+    { 883000000, 0x11, 0x09 },
+    { 994000000, 0x10, 0x08 },
+    {         0, 0x00, 0x00 },    // Table End
+};
+
+static struct SMap2 m_Cal_PLL_Map[] = {
+    {  33813000, 0xDD, 0xD0 },
+    {  36625000, 0xDC, 0xC0 },
+    {  39938000, 0xDB, 0xB0 },
+    {  43938000, 0xDA, 0xA0 },
+    {  48813000, 0xD9, 0x90 },
+    {  54938000, 0xD8, 0x80 },
+    {  62813000, 0xD3, 0x70 },
+    {  67625000, 0xCD, 0x68 },
+    {  73250000, 0xCC, 0x60 },
+    {  79875000, 0xCB, 0x58 },
+    {  87875000, 0xCA, 0x50 },
+    {  97625000, 0xC9, 0x48 },
+    { 109875000, 0xC8, 0x40 },
+    { 125625000, 0xC3, 0x38 },
+    { 135250000, 0xBD, 0x34 },
+    { 146500000, 0xBC, 0x30 },
+    { 159750000, 0xBB, 0x2C },
+    { 175750000, 0xBA, 0x28 },
+    { 195250000, 0xB9, 0x24 },
+    { 219750000, 0xB8, 0x20 },
+    { 251250000, 0xB3, 0x1C },
+    { 270500000, 0xAD, 0x1A },
+    { 293000000, 0xAC, 0x18 },
+    { 319500000, 0xAB, 0x16 },
+    { 351500000, 0xAA, 0x14 },
+    { 390500000, 0xA9, 0x12 },
+    { 439500000, 0xA8, 0x10 },
+    { 502500000, 0xA3, 0x0E },
+    { 541000000, 0x9D, 0x0D },
+    { 586000000, 0x9C, 0x0C },
+    { 639000000, 0x9B, 0x0B },
+    { 703000000, 0x9A, 0x0A },
+    { 781000000, 0x99, 0x09 },
+    { 879000000, 0x98, 0x08 },
+    {         0, 0x00, 0x00 },    // Table End
+};
+
+static struct SMap  m_GainTaper_Map[] = {
+    {  45400000, 0x1F },
+    {  45800000, 0x1E },
+    {  46200000, 0x1D },
+    {  46700000, 0x1C },
+    {  47100000, 0x1B },
+    {  47500000, 0x1A },
+    {  47900000, 0x19 },
+    {  49600000, 0x17 },
+    {  51200000, 0x16 },
+    {  52900000, 0x15 },
+    {  54500000, 0x14 },
+    {  56200000, 0x13 },
+    {  57800000, 0x12 },
+    {  59500000, 0x11 },
+    {  61100000, 0x10 },
+    {  67600000, 0x0D },
+    {  74200000, 0x0C },
+    {  80700000, 0x0B },
+    {  87200000, 0x0A },
+    {  93800000, 0x09 },
+    { 100300000, 0x08 },
+    { 106900000, 0x07 },
+    { 113400000, 0x06 },
+    { 119900000, 0x05 },
+    { 126500000, 0x04 },
+    { 133000000, 0x03 },
+    { 139500000, 0x02 },
+    { 146100000, 0x01 },
+    { 152600000, 0x00 },
+    { 154300000, 0x1F },
+    { 156100000, 0x1E },
+    { 157800000, 0x1D },
+    { 159500000, 0x1C },
+    { 161200000, 0x1B },
+    { 163000000, 0x1A },
+    { 164700000, 0x19 },
+    { 170200000, 0x17 },
+    { 175800000, 0x16 },
+    { 181300000, 0x15 },
+    { 186900000, 0x14 },
+    { 192400000, 0x13 },
+    { 198000000, 0x12 },
+    { 203500000, 0x11 },
+    { 216200000, 0x14 },
+    { 228900000, 0x13 },
+    { 241600000, 0x12 },
+    { 254400000, 0x11 },
+    { 267100000, 0x10 },
+    { 279800000, 0x0F },
+    { 292500000, 0x0E },
+    { 305200000, 0x0D },
+    { 317900000, 0x0C },
+    { 330700000, 0x0B },
+    { 343400000, 0x0A },
+    { 356100000, 0x09 },
+    { 368800000, 0x08 },
+    { 381500000, 0x07 },
+    { 394200000, 0x06 },
+    { 406900000, 0x05 },
+    { 419700000, 0x04 },
+    { 432400000, 0x03 },
+    { 445100000, 0x02 },
+    { 457800000, 0x01 },
+    { 476300000, 0x19 },
+    { 494800000, 0x18 },
+    { 513300000, 0x17 },
+    { 531800000, 0x16 },
+    { 550300000, 0x15 },
+    { 568900000, 0x14 },
+    { 587400000, 0x13 },
+    { 605900000, 0x12 },
+    { 624400000, 0x11 },
+    { 642900000, 0x10 },
+    { 661400000, 0x0F },
+    { 679900000, 0x0E },
+    { 698400000, 0x0D },
+    { 716900000, 0x0C },
+    { 735400000, 0x0B },
+    { 753900000, 0x0A },
+    { 772500000, 0x09 },
+    { 791000000, 0x08 },
+    { 809500000, 0x07 },
+    { 828000000, 0x06 },
+    { 846500000, 0x05 },
+    { 865000000, 0x04 },
+    {         0, 0x00 },    // Table End
+};
+
+static struct SMap m_RF_Cal_DC_Over_DT_Map[] = {
+    {  47900000, 0x00 },
+    {  55000000, 0x00 },
+    {  61100000, 0x0A },
+    {  64000000, 0x0A },
+    {  82000000, 0x14 },
+    {  84000000, 0x19 },
+    { 119000000, 0x1C },
+    { 124000000, 0x20 },
+    { 129000000, 0x2A },
+    { 134000000, 0x32 },
+    { 139000000, 0x39 },
+    { 144000000, 0x3E },
+    { 149000000, 0x3F },
+    { 152600000, 0x40 },
+    { 154000000, 0x40 },
+    { 164700000, 0x41 },
+    { 203500000, 0x32 },
+    { 353000000, 0x19 },
+    { 356000000, 0x1A },
+    { 359000000, 0x1B },
+    { 363000000, 0x1C },
+    { 366000000, 0x1D },
+    { 369000000, 0x1E },
+    { 373000000, 0x1F },
+    { 376000000, 0x20 },
+    { 379000000, 0x21 },
+    { 383000000, 0x22 },
+    { 386000000, 0x23 },
+    { 389000000, 0x24 },
+    { 393000000, 0x25 },
+    { 396000000, 0x26 },
+    { 399000000, 0x27 },
+    { 402000000, 0x28 },
+    { 404000000, 0x29 },
+    { 407000000, 0x2A },
+    { 409000000, 0x2B },
+    { 412000000, 0x2C },
+    { 414000000, 0x2D },
+    { 417000000, 0x2E },
+    { 419000000, 0x2F },
+    { 422000000, 0x30 },
+    { 424000000, 0x31 },
+    { 427000000, 0x32 },
+    { 429000000, 0x33 },
+    { 432000000, 0x34 },
+    { 434000000, 0x35 },
+    { 437000000, 0x36 },
+    { 439000000, 0x37 },
+    { 442000000, 0x38 },
+    { 444000000, 0x39 },
+    { 447000000, 0x3A },
+    { 449000000, 0x3B },
+    { 457800000, 0x3C },
+    { 465000000, 0x0F },
+    { 477000000, 0x12 },
+    { 483000000, 0x14 },
+    { 502000000, 0x19 },
+    { 508000000, 0x1B },
+    { 519000000, 0x1C },
+    { 522000000, 0x1D },
+    { 524000000, 0x1E },
+    { 534000000, 0x1F },
+    { 549000000, 0x20 },
+    { 554000000, 0x22 },
+    { 584000000, 0x24 },
+    { 589000000, 0x26 },
+    { 658000000, 0x27 },
+    { 664000000, 0x2C },
+    { 669000000, 0x2D },
+    { 699000000, 0x2E },
+    { 704000000, 0x30 },
+    { 709000000, 0x31 },
+    { 714000000, 0x32 },
+    { 724000000, 0x33 },
+    { 729000000, 0x36 },
+    { 739000000, 0x38 },
+    { 744000000, 0x39 },
+    { 749000000, 0x3B },
+    { 754000000, 0x3C },
+    { 759000000, 0x3D },
+    { 764000000, 0x3E },
+    { 769000000, 0x3F },
+    { 774000000, 0x40 },
+    { 779000000, 0x41 },
+    { 784000000, 0x43 },
+    { 789000000, 0x46 },
+    { 794000000, 0x48 },
+    { 799000000, 0x4B },
+    { 804000000, 0x4F },
+    { 809000000, 0x54 },
+    { 814000000, 0x59 },
+    { 819000000, 0x5D },
+    { 824000000, 0x61 },
+    { 829000000, 0x68 },
+    { 834000000, 0x6E },
+    { 839000000, 0x75 },
+    { 844000000, 0x7E },
+    { 849000000, 0x82 },
+    { 854000000, 0x84 },
+    { 859000000, 0x8F },
+    { 865000000, 0x9A },
+    {         0, 0x00 },    // Table End
+};
+
+
+static struct SMap  m_IR_Meas_Map[] = {
+    { 200000000, 0x05 },
+    { 400000000, 0x06 },
+    { 865000000, 0x07 },
+    {         0, 0x00 },    // Table End
+};
+
+static struct SMap2 m_CID_Target_Map[] = {
+    {  46000000, 0x04, 18 },
+    {  52200000, 0x0A, 15 },
+    {  70100000, 0x01, 40 },
+    { 136800000, 0x18, 40 },
+    { 156700000, 0x18, 40 },
+    { 186250000, 0x0A, 40 },
+    { 230000000, 0x0A, 40 },
+    { 345000000, 0x18, 40 },
+    { 426000000, 0x0E, 40 },
+    { 489500000, 0x1E, 40 },
+    { 697500000, 0x32, 40 },
+    { 842000000, 0x3A, 40 },
+    {         0, 0x00,  0 },    // Table End
+};
+
+static struct SRFBandMap  m_RF_Band_Map[7] = {
+    {   47900000,   46000000,           0,          0},
+    {   61100000,   52200000,           0,          0},
+    {  152600000,   70100000,   136800000,          0},
+    {  164700000,  156700000,           0,          0},
+    {  203500000,  186250000,           0,          0},
+    {  457800000,  230000000,   345000000,  426000000},
+    {  865000000,  489500000,   697500000,  842000000},
+};
+
+u8 m_Thermometer_Map_1[16] = {
+    60,62,66,64, 74,72,68,70, 90,88,84,86, 76,78,82,80,
+};
+
+u8 m_Thermometer_Map_2[16] = {
+    92,94,98,96, 106,104,100,102, 122,120,116,118, 108,110,114,112,
+};
+
-- 
1.7.4.1

