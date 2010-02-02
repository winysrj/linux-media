Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49978 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0BBOrn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 09:47:43 -0500
Received: by vws20 with SMTP id 20so39334vws.19
        for <linux-media@vger.kernel.org>; Tue, 02 Feb 2010 06:47:42 -0800 (PST)
Message-ID: <4B683B06.8090801@gmail.com>
Date: Tue, 02 Feb 2010 12:47:34 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	linux-media@vger.kernel.org, bob@turbosight.com
Subject: Re: [PATCH] cx23885: fix support for TBS 6920 card
References: <20090819232002.a941c388.kosio.dimitrov@gmail.com> <4A8D4984.4000309@kernellabs.com>
In-Reply-To: <4A8D4984.4000309@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steven,

Steven Toth wrote:
> On 8/19/09 7:20 PM, Konstantin Dimitrov wrote:
>>
>> fix: GPIO initialization for TBS 6920
>> fix: wrong I2C address for demod on TBS 6920
>> fix: wrong I2C bus number for demod on TBS 6920
>> fix: wrong "gen_ctrl_val" value for TS1 port on TBS 6920 (and some
>> other cards)
>> add: module_param "lnb_pwr_ctrl" as option to choose between "type 0"
>> and "type 1" of LNB power control (two TBS 6920 boards no matter that
>> they are marked as the same hardware revision may have different types
>> of LNB power control)
>> fix: LNB power control function for type 0 doesn't preserve the
>> previous GPIO state, which is critical
>> add: LNB power control function for type 1
>>
>> Signed-off-by: Bob Liu<bob@turbosight.com>
>> Signed-off-by: Konstantin Dimitrov<kosio.dimitrov@gmail.com>
> 
> I got a weird HTML related email bounce from vger when I responded
> originally to this via gmail. Maybe this time via thunderbird will bring
> success.
> 
> ...
> 
> Hmm. A custom hanging off of a gpio to something that looks like an i2c
> power control device. I want to review some of these generic (and
> no-so-generic) changes before we merge this patch.
> 
> Is the datasheet for the LNB power control device available to the
> public? I'd like to understand some of the register details.
> 

What's the status of the current patch? It was submitted back on Aug, 2009,
and marked as under review since then. Btw, the patch is currently broken,
probably due to the changes on cx23885 driver during this period of time.

patching file drivers/media/video/cx23885/cx23885-cards.c
Hunk #1 FAILED at 704.
Hunk #2 succeeded at 1020 with fuzz 2 (offset 133 lines).
1 out of 2 hunks FAILED -- saving rejects to file drivers/media/video/cx23885/cx23885-cards.c.rej
patching file drivers/media/video/cx23885/cx23885-dvb.c
Hunk #1 FAILED at 55.
Hunk #2 succeeded at 75 (offset 3 lines).
Hunk #3 FAILED at 427.
Hunk #4 FAILED at 785.
Hunk #5 FAILED at 805.
4 out of 5 hunks FAILED -- saving rejects to file drivers/media/video/cx23885/cx23885-dvb.c.rej
patching file drivers/media/video/cx23885/Makefile
Hunk #1 FAILED at 1.
1 out of 1 hunk FAILED -- saving rejects to file drivers/media/video/cx23885/Makefile.rej
patching file drivers/media/video/cx23885/tbs_lnb_pwr.c
patching file drivers/media/video/cx23885/tbs_lnb_pwr.h
Patch doesn't apply

---

Subject: cx23885: fix support for TBS 6920 card
Date: Wed, 19 Aug 2009 23:20:02 -0000
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
X-Patchwork-Id: 42777

fix: GPIO initialization for TBS 6920
fix: wrong I2C address for demod on TBS 6920
fix: wrong I2C bus number for demod on TBS 6920
fix: wrong "gen_ctrl_val" value for TS1 port on TBS 6920 (and some other cards)
add: module_param "lnb_pwr_ctrl" as option to choose between "type 0" and "type 1" of LNB power control (two TBS 6920 boards no matter that they are marked as the same hardware revision may have different types of LNB power control)
fix: LNB power control function for type 0 doesn't preserve the previous GPIO state, which is critical
add: LNB power control function for type 1

Signed-off-by: Bob Liu <bob@turbosight.com>
Signed-off-by: Konstantin Dimitrov <kosio.dimitrov@gmail.com>

---
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--- a/drivers/media/video/cx23885/cx23885-cards.c	2009-08-19 14:11:49.000000000 +0300
+++ a/drivers/media/video/cx23885/cx23885-cards.c	2009-08-19 14:30:10.000000000 +0300
@@ -704,7 +704,14 @@ void cx23885_gpio_setup(struct cx23885_d
 	case CX23885_BOARD_TEVII_S470:
 		cx_write(MC417_CTL, 0x00000036);
 		cx_write(MC417_OEN, 0x00001000);
-		cx_write(MC417_RWD, 0x00001800);
+
+		cx_set(MC417_RWD, 0x00000002);
+		mdelay(200);
+
+		cx_clear(MC417_RWD, 0x00000800);
+		mdelay(200);
+		cx_set(MC417_RWD, 0x00000800);
+		mdelay(200);
 		break;
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
 		/* GPIO-0 INTA from CiMax1
@@ -880,7 +887,7 @@ void cx23885_card_setup(struct cx23885_d
 	case CX23885_BOARD_TEVII_S470:
 	case CX23885_BOARD_TBS_6920:
 	case CX23885_BOARD_DVBWORLD_2005:
-		ts1->gen_ctrl_val  = 0x5; /* Parallel */
+		ts1->gen_ctrl_val  = 0x4; /* Parallel */
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
--- a/drivers/media/video/cx23885/cx23885-dvb.c	2009-08-19 14:11:49.000000000 +0300
+++ a/drivers/media/video/cx23885/cx23885-dvb.c	2009-08-19 15:25:57.000000000 +0300
@@ -55,6 +55,7 @@
 #include "netup-eeprom.h"
 #include "netup-init.h"
 #include "lgdt3305.h"
+#include "tbs_lnb_pwr.h"
 
 static unsigned int debug;
 
@@ -71,6 +72,10 @@ MODULE_PARM_DESC(alt_tuner, "Enable alte
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
+static unsigned int lnb_pwr_ctrl;
+module_param(lnb_pwr_ctrl, int, 0644);
+MODULE_PARM_DESC(lnb_pwr_ctrl,"set LNB power control 0=default type, 1=another type");
+
 /* ------------------------------------------------------------------ */
 
 static int dvb_buf_setup(struct videobuf_queue *q,
@@ -419,22 +424,31 @@ static struct stv6110_config netup_stv61
 	.clk_div = 1,
 };
 
-static int tbs_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
+static int tbs6920_set_voltage(struct dvb_frontend *fe,
+				fe_sec_voltage_t voltage)
 {
 	struct cx23885_tsport *port = fe->dvb->priv;
 	struct cx23885_dev *dev = port->dev;
 
-	if (voltage == SEC_VOLTAGE_18)
-		cx_write(MC417_RWD, 0x00001e00);/* GPIO-13 high */
-	else if (voltage == SEC_VOLTAGE_13)
-		cx_write(MC417_RWD, 0x00001a00);/* GPIO-13 low */
-	else
-		cx_write(MC417_RWD, 0x00001800);/* GPIO-12 low */
+	switch (voltage) {
+	case SEC_VOLTAGE_13:
+		cx_set(MC417_RWD, 0x00000200);
+		cx_clear(MC417_RWD, 0x00000400);
+		break;
+	case SEC_VOLTAGE_18:
+		cx_set(MC417_RWD, 0x00000200);
+		cx_set(MC417_RWD, 0x00000400);
+		break;
+	case SEC_VOLTAGE_OFF:
+		cx_clear(MC417_RWD, 0x00000200);
+		break;
+	}
+
 	return 0;
 }
 
 static struct cx24116_config tbs_cx24116_config = {
-	.demod_address = 0x05,
+	.demod_address = 0x55,
 };
 
 static struct cx24116_config tevii_cx24116_config = {
@@ -768,14 +782,18 @@ static int dvb_register(struct cx23885_t
 		}
 		break;
 	case CX23885_BOARD_TBS_6920:
-		i2c_bus = &dev->i2c_bus[0];
+		i2c_bus = &dev->i2c_bus[1];
 
 		fe0->dvb.frontend = dvb_attach(cx24116_attach,
 			&tbs_cx24116_config,
 			&i2c_bus->i2c_adap);
-		if (fe0->dvb.frontend != NULL)
-			fe0->dvb.frontend->ops.set_voltage = tbs_set_voltage;
-
+		if (fe0->dvb.frontend != NULL) {
+			if (!lnb_pwr_ctrl)
+				fe0->dvb.frontend->ops.set_voltage = tbs6920_set_voltage;
+			else 
+				fe0->dvb.frontend->ops.set_voltage = tbs_set_voltage;
+		}
+				
 		break;
 	case CX23885_BOARD_TEVII_S470:
 		i2c_bus = &dev->i2c_bus[1];
@@ -784,7 +802,7 @@ static int dvb_register(struct cx23885_t
 			&tevii_cx24116_config,
 			&i2c_bus->i2c_adap);
 		if (fe0->dvb.frontend != NULL)
-			fe0->dvb.frontend->ops.set_voltage = tbs_set_voltage;
+			fe0->dvb.frontend->ops.set_voltage = tbs6920_set_voltage;
 
 		break;
 	case CX23885_BOARD_DVBWORLD_2005:
--- a/drivers/media/video/cx23885/Makefile	2009-08-19 14:11:49.000000000 +0300
+++ a/drivers/media/video/cx23885/Makefile	2009-08-19 14:30:10.000000000 +0300
@@ -1,6 +1,6 @@
 cx23885-objs	:= cx23885-cards.o cx23885-video.o cx23885-vbi.o \
 		    cx23885-core.o cx23885-i2c.o cx23885-dvb.o cx23885-417.o \
-		    netup-init.o cimax2.o netup-eeprom.o
+		    netup-init.o cimax2.o netup-eeprom.o tbs_lnb_pwr.o
 
 obj-$(CONFIG_VIDEO_CX23885) += cx23885.o
 
--- a/drivers/media/video/cx23885/tbs_lnb_pwr.c	2009-08-19 15:54:46.000000000 +0300
+++ a/drivers/media/video/cx23885/tbs_lnb_pwr.c	2009-08-19 14:30:10.000000000 +0300
@@ -0,0 +1,353 @@
+/*
+    LNB Power Control for TurboSight DVB-S/S2 PCI-Express cards
+    Copyright (C) 2009 Bob Liu <bob@turbosight.com>
+
+    Copyright (C) 2009 TurboSight.com
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include "cx23885.h"
+
+/*
+    Direction bits are at offset 23:16
+    This will create a mask value that needs to be ored with the old
+    value to set the relevant bit.
+*/
+#define Set_GPIO_Direction_Bit_To_OUTPUT(Bit)   ((1 << Bit) << 16)
+
+/*
+    This will create a mask value that needs to be anded with the old
+    value to clear the relevant bit.
+*/
+#define Set_GPIO_Direction_Bit_To_INPUT(Bit)    (~((1 << Bit) << 16))
+
+/*
+    This will create a mask value that needs to be ored with the old
+    value to set the relevant bit.
+*/
+#define Set_GPIO_Bit(Bit)                       (1 << Bit)
+
+/*
+    This will create a mask value that needs to be anded with the old
+    value to clear the relevant bit.
+*/
+#define Clear_GPIO_Bit(Bit)                     (~(1 << Bit))
+
+void SetGpioPinDirection(struct dvb_frontend *fe, int pinNumber, int pinLogicValue)
+{
+	u32 gpioRegister, value = 0;
+	struct cx23885_tsport *port = fe->dvb->priv;
+	struct cx23885_dev *dev = port->dev;
+
+	gpioRegister = cx_read(GP0_IO);
+
+	if (pinLogicValue == 0) {
+		value = gpioRegister & Set_GPIO_Direction_Bit_To_INPUT(pinNumber) ;
+	} else {
+		value = gpioRegister | Set_GPIO_Direction_Bit_To_OUTPUT(pinNumber) ;
+	}
+
+	cx_write(GP0_IO, value);
+}
+
+void SetGpioPinLogicValue(struct dvb_frontend *fe, int pinNumber, int pinLogicValue)
+{
+	u32 gpioRegister, value = 0;
+	struct cx23885_tsport *port = fe->dvb->priv;
+	struct cx23885_dev *dev = port->dev;
+
+	gpioRegister = cx_read(GP0_IO);
+	/* first do a sanity check - if the Pin is not output, make it output */
+	if ((gpioRegister & Set_GPIO_Direction_Bit_To_OUTPUT(pinNumber)) == 0x00) {
+		/* it's input */
+		value = gpioRegister | Set_GPIO_Direction_Bit_To_OUTPUT(pinNumber) ;
+		cx_write(GP0_IO, value);
+		value = 0;
+		/* read the value back */
+		gpioRegister = cx_read(GP0_IO);
+	}
+
+	if (pinLogicValue == 0) {
+		value = gpioRegister & Clear_GPIO_Bit(pinNumber);
+	} else {
+		value = gpioRegister | Set_GPIO_Bit(pinNumber);
+	}
+
+	cx_write(GP0_IO, value);
+}
+
+u32 GetGpioPinValue(struct dvb_frontend *fe, int pinNumber)
+{
+	u32 gpioRegister, value = 0;
+	struct cx23885_tsport *port = fe->dvb->priv;
+	struct cx23885_dev *dev = port->dev;
+
+	gpioRegister = cx_read(GP0_IO);
+
+	value = ((gpioRegister >> pinNumber) >> 8) & 1;
+
+	return value;
+}
+
+void Set_IC_CLK(struct dvb_frontend *fe, unsigned char HL_Level)
+{
+	if (HL_Level == 1) {
+		SetGpioPinDirection(fe, 2, 1);
+		SetGpioPinLogicValue(fe, 2, 1);
+	} else {
+		SetGpioPinDirection(fe, 2, 1);
+		SetGpioPinLogicValue(fe, 2, 0);
+	}
+
+	return;
+}
+
+void Set_IC_IO(struct dvb_frontend *fe, unsigned char HL_Level)
+{
+	if (HL_Level == 1) {
+		SetGpioPinDirection(fe, 0, 1);
+		SetGpioPinLogicValue(fe, 0, 1);
+	} else {
+		SetGpioPinDirection(fe, 0, 1);
+		SetGpioPinLogicValue(fe, 0, 0);
+	}
+
+	return;
+}
+
+int Get_IC_IO(struct dvb_frontend *fe)
+{
+	int HL_Level;
+
+	SetGpioPinDirection(fe, 0, 0);
+	HL_Level = GetGpioPinValue(fe, 0);
+	return HL_Level;
+}
+
+void Set_IC_RST(struct dvb_frontend *fe, unsigned char HL_Level)
+{
+	if (HL_Level == 1) {
+		SetGpioPinDirection(fe, 1, 1);
+		SetGpioPinLogicValue(fe, 1, 1);
+	} else {
+		SetGpioPinDirection(fe, 1, 1);
+		SetGpioPinLogicValue(fe, 1, 0);
+	}
+
+	return;
+}
+
+static unsigned char Get_IC_BUSY(struct dvb_frontend *fe)
+{
+	unsigned char HL_Level;
+
+	SetGpioPinDirection(fe, 3, 0);
+	HL_Level = (unsigned char)GetGpioPinValue(fe, 3);
+
+	return HL_Level;
+}
+
+static void Delay1mS(void)
+{
+	udelay(800);
+}
+
+static void Clk_Delay(void)
+{
+	udelay(30);
+}
+
+static void SetMCU_CLk(struct dvb_frontend *fe, unsigned char HL_level)
+{
+	if (HL_level != 0)
+		HL_level = 1;
+
+	Set_IC_CLK(fe, HL_level);
+
+	Clk_Delay();
+
+	return;
+}
+
+static void SetMCU_Data(struct dvb_frontend *fe, unsigned char HL_level)
+{
+	if (HL_level != 0)
+		HL_level = 1;
+
+	Set_IC_IO(fe, HL_level);
+
+	return;
+}
+
+static void SetMCU_Cs(struct dvb_frontend *fe, unsigned char HL_level)
+{
+	if (HL_level != 0)
+		HL_level = 1;
+
+	Set_IC_RST(fe, HL_level);
+
+	return;
+}
+
+static unsigned char GetMCU_Data(struct dvb_frontend *fe)
+{
+	unsigned char linedata;
+
+	linedata = (unsigned char)Get_IC_IO(fe);
+
+	if (linedata != 0)
+		return 1;
+	else
+		return 0;
+}
+
+static unsigned char GetMCU_Busy(struct dvb_frontend *fe)
+{
+	unsigned char LineBusy;
+
+	LineBusy = Get_IC_BUSY(fe);
+
+	if (LineBusy != 0)
+		return 1;
+	else
+		return 0;
+}
+
+static void SendOneByteData(struct dvb_frontend *fe, unsigned char OneByteData)
+{
+	unsigned char i;
+
+	for (i = 0;i < 8;i++) {
+		SetMCU_CLk(fe, 0);
+		SetMCU_Data(fe, OneByteData & 0x80);
+		OneByteData *= 2;
+		SetMCU_CLk(fe, 1);
+	}
+	return;
+}
+
+static unsigned char GetOneByteData(struct dvb_frontend *fe)
+{
+	unsigned char i, OneByteData = 0;
+
+
+	for (i = 0;i < 8;i++) {
+		SetMCU_CLk(fe, 0);
+		OneByteData *= 2;
+		SetMCU_CLk(fe, 1);
+		OneByteData += GetMCU_Data(fe);
+	}
+
+	return OneByteData;
+}
+
+static unsigned char QuestionAndAnswer(struct dvb_frontend *fe, unsigned char *QuestionBuffer)
+{
+	unsigned char i, temp, result;
+
+	temp = QuestionBuffer[0];
+	for (i = 0;i < QuestionBuffer[0]; i++)
+		temp += QuestionBuffer[i+1];
+	temp = (~temp + 1);
+	QuestionBuffer[1+ QuestionBuffer[0]] = temp;
+
+	SetMCU_Cs(fe, 1);
+	SetMCU_CLk(fe, 1);
+	SetMCU_Data(fe, 1);
+	Delay1mS();
+
+	SetMCU_Cs(fe, 0);
+	Delay1mS();
+	SendOneByteData(fe, 0xe0);
+	Delay1mS();
+	temp = QuestionBuffer[0];
+	temp += 2;
+	for (i = 0;i < temp;i++)
+		SendOneByteData(fe, QuestionBuffer[i]);
+	SetMCU_Cs(fe, 1);
+	SetMCU_Data(fe, 1);
+
+	temp = 0;
+	for (i = 0;((i < 8)&(temp == 0));i++) {
+		Delay1mS();
+		if (GetMCU_Busy(fe) == 0)
+			temp = 1;
+	}
+	if (i > 7) {
+		result = 0;
+	} else {
+		SetMCU_Cs(fe, 0);
+		Delay1mS();
+		SendOneByteData(fe, 0xe1);
+		Delay1mS();
+		temp = GetOneByteData(fe);
+		if (temp > 14)
+			temp = 14;
+		QuestionBuffer[0] = temp;
+		for (i = 0;i < (temp + 1);i++)
+			QuestionBuffer[i+1] = GetOneByteData(fe);
+		SetMCU_Cs(fe, 1);
+		SetMCU_Data(fe, 1);
+
+		temp = 0;
+		for (i = 0;i < (QuestionBuffer[0] + 2);i++)
+			temp += QuestionBuffer[i];
+		if (temp == 0) {
+			result = 1;
+		} else {
+			result = 0;
+		}
+	}
+
+	return result;
+}
+
+int tbs_set_voltage(struct dvb_frontend *fe,
+			fe_sec_voltage_t voltage)
+{
+	unsigned char QuestionBuffer[16];
+
+	switch (voltage) {
+	case SEC_VOLTAGE_13:
+		QuestionBuffer[0] = 0x05;
+		QuestionBuffer[1] = 0x38;
+		QuestionBuffer[2] = 0x01;
+		QuestionBuffer[3] = 0x01;
+		QuestionBuffer[4] = 0x02;
+		QuestionBuffer[5] = 0x00;
+		break;
+	case SEC_VOLTAGE_18:
+		QuestionBuffer[0] = 0x05;
+		QuestionBuffer[1] = 0x38;
+		QuestionBuffer[2] = 0x01;
+		QuestionBuffer[3] = 0x01;
+		QuestionBuffer[4] = 0x02;
+		QuestionBuffer[5] = 0x01;
+		break;
+	case SEC_VOLTAGE_OFF:
+		QuestionBuffer[0] = 0x05;
+		QuestionBuffer[1] = 0x38;
+		QuestionBuffer[2] = 0x01;
+		QuestionBuffer[3] = 0x00;
+		QuestionBuffer[4] = 0x00;
+		QuestionBuffer[5] = 0x00;
+		break;
+	}
+
+	QuestionAndAnswer(fe, QuestionBuffer);
+
+	return 0;
+}
--- a/drivers/media/video/cx23885/tbs_lnb_pwr.h	2009-08-19 15:54:48.000000000 +0300
+++ a/drivers/media/video/cx23885/tbs_lnb_pwr.h	2009-08-19 14:30:10.000000000 +0300
@@ -0,0 +1,28 @@
+/*
+    LNB Power Control for TurboSight DVB-S/S2 PCI-Express cards
+    Copyright (C) 2009 Bob Liu <bob@turbosight.com>
+
+    Copyright (C) 2009 TurboSight.com
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef TBS_LNB_PWR_H
+#define TBS_LNB_PWR_H
+
+extern int tbs_set_voltage(struct dvb_frontend *fe,
+				fe_sec_voltage_t voltage);
+
+#endif



