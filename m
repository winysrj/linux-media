Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246Ab2AEBBH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:07 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05117b3002462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:07 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 09/47] [media] mt2063: Remove unused stuff
Date: Wed,  4 Jan 2012 23:00:20 -0200
Message-Id: <1325725258-27934-10-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |  512 ----------------------------------
 1 files changed, 0 insertions(+), 512 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 85980cc..c181332 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -366,47 +366,6 @@ static void MT2063_Sleep(void *hUserData, u32 nMinDelayTime)
 	msleep(nMinDelayTime);
 }
 
-/*****************************************************************************
-**
-**  Name: MT_TunerGain  (MT2060 only)
-**
-**  Description:    Measure the relative tuner gain using the demodulator
-**
-**  Parameters:     hUserData  - User-specific I/O parameter that was
-**                               passed to tuner's Open function.
-**                  pMeas      - Tuner gain (1/100 of dB scale).
-**                               ie. 1234 = 12.34 (dB)
-**
-**  Returns:        status:
-**                      MT_OK  - No errors
-**                      user-defined errors could be set
-**
-**  Notes:          This is a callback function that is called from the
-**                  the 1st IF location routine.  You MUST provide
-**                  code that measures the relative tuner gain in a dB
-**                  (not linear) scale.  The return value is an integer
-**                  value scaled to 1/100 of a dB.
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   N/A   06-16-2004    DAD    Original
-**   N/A   11-30-2004    DAD    Renamed from MT_DemodInputPower.  This name
-**                              better describes what this function does.
-**
-*****************************************************************************/
-static u32 MT2060_TunerGain(void *hUserData, s32 * pMeas)
-{
-	u32 status = MT2063_OK;	/* Status to be returned        */
-
-	/*
-	 **  ToDo:  Add code here to return the gain / power level measured
-	 **         at the input to the demodulator.
-	 */
-
-	return (status);
-}
 //end of mt2063_userdef.c
 //=================================================================
 //#################################################################
@@ -1412,11 +1371,6 @@ static u32 MT2063_AvoidSpurs(void *h, struct MT2063_AvoidSpursData_t * pAS_Info)
 	return (status);
 }
 
-static u32 MT2063_AvoidSpursVersion(void)
-{
-	return (MT2063_SPUR_VERSION);
-}
-
 //end of mt2063_spuravoid.c
 //=================================================================
 //#################################################################
@@ -1473,8 +1427,6 @@ static const u32 MT2063_Num_Registers = MT2063_REG_END_REGS;
 #define USE_GLOBAL_TUNER			0
 
 static u32 nMT2063MaxTuners = 1;
-static struct MT2063_Info_t MT2063_Info[1];
-static struct MT2063_Info_t *MT2063_Avail[1];
 static u32 nMT2063OpenTuners = 0;
 
 /*
@@ -1653,64 +1605,6 @@ static u32 MT2063_Close(void *hMT2063)
 	return MT2063_OK;
 }
 
-/******************************************************************************
-**
-**  Name: MT2063_GetGPIO
-**
-**  Description:    Get the current MT2063 GPIO value.
-**
-**  Parameters:     h            - Open handle to the tuner (from MT2063_Open).
-**                  gpio_id      - Selects GPIO0, GPIO1 or GPIO2
-**                  attr         - Selects input readback, I/O direction or
-**                                 output value
-**                  *value       - current setting of GPIO pin
-**
-**  Usage:          status = MT2063_GetGPIO(hMT2063, MT2063_GPIO_OUT, &value);
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_COMM_ERR      - Serial bus communications error
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**                      MT_ARG_NULL      - Null pointer argument passed
-**
-**  Dependencies:   MT_ReadSub  - Read byte(s) of data from the serial bus
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**
-******************************************************************************/
-static u32 MT2063_GetGPIO(void *h, enum MT2063_GPIO_ID gpio_id,
-		       enum MT2063_GPIO_Attr attr, u32 * value)
-{
-	u32 status = MT2063_OK;	/* Status to be returned        */
-	u8 regno;
-	s32 shift;
-	static u8 GPIOreg[3] =
-	    { MT2063_REG_RF_STATUS, MT2063_REG_FIF_OV, MT2063_REG_RF_OV };
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
-
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		return MT2063_INV_HANDLE;
-
-	if (value == NULL)
-		return MT2063_ARG_NULL;
-
-	regno = GPIOreg[attr];
-
-	/*  We'll read the register just in case the write didn't work last time */
-	status =
-	    MT2063_ReadSub(pInfo->hUserData, pInfo->address, regno,
-			   &pInfo->reg[regno], 1);
-
-	shift = (gpio_id - MT2063_GPIO0 + 5);
-	*value = (pInfo->reg[regno] >> shift) & 1;
-
-	return (status);
-}
-
 /****************************************************************************
 **
 **  Name: MT2063_GetLocked
@@ -2303,141 +2197,6 @@ static u32 MT2063_GetReg(void *h, u8 reg, u8 * val)
 
 /******************************************************************************
 **
-**  Name: MT2063_GetTemp
-**
-**  Description:    Get the MT2063 Temperature register.
-**
-**  Parameters:     h            - Open handle to the tuner (from MT2063_Open).
-**                  *value       - value read from the register
-**
-**                                    Binary
-**                  Value Returned    Value    Approx Temp
-**                  ---------------------------------------------
-**                  MT2063_T_0C       0000         0C
-**                  MT2063_T_10C      0001        10C
-**                  MT2063_T_20C      0010        20C
-**                  MT2063_T_30C      0011        30C
-**                  MT2063_T_40C      0100        40C
-**                  MT2063_T_50C      0101        50C
-**                  MT2063_T_60C      0110        60C
-**                  MT2063_T_70C      0111        70C
-**                  MT2063_T_80C      1000        80C
-**                  MT2063_T_90C      1001        90C
-**                  MT2063_T_100C     1010       100C
-**                  MT2063_T_110C     1011       110C
-**                  MT2063_T_120C     1100       120C
-**                  MT2063_T_130C     1101       130C
-**                  MT2063_T_140C     1110       140C
-**                  MT2063_T_150C     1111       150C
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_COMM_ERR      - Serial bus communications error
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**                      MT_ARG_NULL      - Null pointer argument passed
-**                      MT_ARG_RANGE     - Argument out of range
-**
-**  Dependencies:   MT_ReadSub  - Read byte(s) of data from the two-wire bus
-**                  MT_WriteSub - Write byte(s) of data to the two-wire bus
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**
-******************************************************************************/
-static u32 MT2063_GetTemp(void *h, enum MT2063_Temperature * value)
-{
-	u32 status = MT2063_OK;	/* Status to be returned        */
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
-
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		return MT2063_INV_HANDLE;
-
-	if (value == NULL)
-		return MT2063_ARG_NULL;
-
-	if ((MT2063_NO_ERROR(status))
-	    && ((pInfo->reg[MT2063_REG_TEMP_SEL] & 0xE0) != 0x00)) {
-		pInfo->reg[MT2063_REG_TEMP_SEL] &= (0x1F);
-		status |= MT2063_WriteSub(pInfo->hUserData,
-					  pInfo->address,
-					  MT2063_REG_TEMP_SEL,
-					  &pInfo->reg[MT2063_REG_TEMP_SEL], 1);
-	}
-
-	if (MT2063_NO_ERROR(status))
-		status |= MT2063_ReadSub(pInfo->hUserData,
-					 pInfo->address,
-					 MT2063_REG_TEMP_STATUS,
-					 &pInfo->reg[MT2063_REG_TEMP_STATUS],
-					 1);
-
-	if (MT2063_NO_ERROR(status))
-		*value =
-		    (enum MT2063_Temperature)(pInfo->
-					      reg[MT2063_REG_TEMP_STATUS] >> 4);
-
-	return (status);
-}
-
-/****************************************************************************
-**
-**  Name: MT2063_GetUserData
-**
-**  Description:    Gets the user-defined data item.
-**
-**  Parameters:     h           - Tuner handle (returned by MT2063_Open)
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**                      MT_ARG_NULL      - Null pointer argument passed
-**
-**  Dependencies:   USERS MUST CALL MT2063_Open() FIRST!
-**
-**                  The hUserData parameter is a user-specific argument
-**                  that is stored internally with the other tuner-
-**                  specific information.
-**
-**                  For example, if additional arguments are needed
-**                  for the user to identify the device communicating
-**                  with the tuner, this argument can be used to supply
-**                  the necessary information.
-**
-**                  The hUserData parameter is initialized in the tuner's
-**                  Open function to NULL.
-**
-**  See Also:       MT2063_Open
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**
-****************************************************************************/
-static u32 MT2063_GetUserData(void *h, void ** hUserData)
-{
-	u32 status = MT2063_OK;	/* Status to be returned        */
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
-
-	/*  Verify that the handle passed points to a valid tuner         */
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		status = MT2063_INV_HANDLE;
-
-	if (hUserData == NULL)
-		status |= MT2063_ARG_NULL;
-
-	if (MT2063_NO_ERROR(status))
-		*hUserData = pInfo->hUserData;
-
-	return (status);
-}
-
-/******************************************************************************
-**
 **  Name: MT2063_SetReceiverMode
 **
 **  Description:    Set the MT2063 receiver mode
@@ -2929,61 +2688,6 @@ static u32 MT2063_ReInit(void *h)
 	return (status);
 }
 
-/******************************************************************************
-**
-**  Name: MT2063_SetGPIO
-**
-**  Description:    Modify the MT2063 GPIO value.
-**
-**  Parameters:     h            - Open handle to the tuner (from MT2063_Open).
-**                  gpio_id      - Selects GPIO0, GPIO1 or GPIO2
-**                  attr         - Selects input readback, I/O direction or
-**                                 output value
-**                  value        - value to set GPIO pin 15, 14 or 19
-**
-**  Usage:          status = MT2063_SetGPIO(hMT2063, MT2063_GPIO1, MT2063_GPIO_OUT, 1);
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_COMM_ERR      - Serial bus communications error
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**
-**  Dependencies:   MT_WriteSub - Write byte(s) of data to the two-wire-bus
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**
-******************************************************************************/
-static u32 MT2063_SetGPIO(void *h, enum MT2063_GPIO_ID gpio_id,
-		       enum MT2063_GPIO_Attr attr, u32 value)
-{
-	u32 status = MT2063_OK;	/* Status to be returned        */
-	u8 regno;
-	s32 shift;
-	static u8 GPIOreg[3] = { 0x15, 0x19, 0x18 };
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
-
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		return MT2063_INV_HANDLE;
-
-	regno = GPIOreg[attr];
-
-	shift = (gpio_id - MT2063_GPIO0 + 5);
-
-	if (value & 0x01)
-		pInfo->reg[regno] |= (0x01 << shift);
-	else
-		pInfo->reg[regno] &= ~(0x01 << shift);
-	status =
-	    MT2063_WriteSub(pInfo->hUserData, pInfo->address, regno,
-			    &pInfo->reg[regno], 1);
-
-	return (status);
-}
-
 /****************************************************************************
 **
 **  Name: MT2063_SetParam
@@ -3662,63 +3366,6 @@ static u32 MT2063_SetParam(void *h, enum MT2063_Param param, u32 nValue)
 
 /****************************************************************************
 **
-**  Name: MT2063_SetPowerMaskBits
-**
-**  Description:    Sets the power-down mask bits for various sections of
-**                  the MT2063
-**
-**  Parameters:     h           - Tuner handle (returned by MT2063_Open)
-**                  Bits        - Mask bits to be set.
-**
-**                  See definition of MT2063_Mask_Bits type for description
-**                  of each of the power bits.
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**                      MT_COMM_ERR      - Serial bus communications error
-**
-**  Dependencies:   USERS MUST CALL MT2063_Open() FIRST!
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**
-****************************************************************************/
-static u32 MT2063_SetPowerMaskBits(void *h, enum MT2063_Mask_Bits Bits)
-{
-	u32 status = MT2063_OK;	/* Status to be returned        */
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
-
-	/*  Verify that the handle passed points to a valid tuner         */
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		status = MT2063_INV_HANDLE;
-	else {
-		Bits = (enum MT2063_Mask_Bits)(Bits & MT2063_ALL_SD);	/* Only valid bits for this tuner */
-		if ((Bits & 0xFF00) != 0) {
-			pInfo->reg[MT2063_REG_PWR_2] |=
-			    (u8) ((Bits & 0xFF00) >> 8);
-			status |=
-			    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
-					    MT2063_REG_PWR_2,
-					    &pInfo->reg[MT2063_REG_PWR_2], 1);
-		}
-		if ((Bits & 0xFF) != 0) {
-			pInfo->reg[MT2063_REG_PWR_1] |= ((u8) Bits & 0xFF);
-			status |=
-			    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
-					    MT2063_REG_PWR_1,
-					    &pInfo->reg[MT2063_REG_PWR_1], 1);
-		}
-	}
-
-	return (status);
-}
-
-/****************************************************************************
-**
 **  Name: MT2063_ClearPowerMaskBits
 **
 **  Description:    Clears the power-down mask bits for various sections of
@@ -3775,111 +3422,6 @@ static u32 MT2063_ClearPowerMaskBits(void *h, enum MT2063_Mask_Bits Bits)
 
 /****************************************************************************
 **
-**  Name: MT2063_GetPowerMaskBits
-**
-**  Description:    Returns a mask of the enabled power shutdown bits
-**
-**  Parameters:     h           - Tuner handle (returned by MT2063_Open)
-**                  Bits        - Mask bits to currently set.
-**
-**                  See definition of MT2063_Mask_Bits type for description
-**                  of each of the power bits.
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**                      MT_ARG_NULL      - Output argument is NULL
-**                      MT_COMM_ERR      - Serial bus communications error
-**
-**  Dependencies:   USERS MUST CALL MT2063_Open() FIRST!
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**
-****************************************************************************/
-static u32 MT2063_GetPowerMaskBits(void *h, enum MT2063_Mask_Bits * Bits)
-{
-	u32 status = MT2063_OK;	/* Status to be returned        */
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
-
-	/*  Verify that the handle passed points to a valid tuner         */
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		status = MT2063_INV_HANDLE;
-	else {
-		if (Bits == NULL)
-			status |= MT2063_ARG_NULL;
-
-		if (MT2063_NO_ERROR(status))
-			status |=
-			    MT2063_ReadSub(pInfo->hUserData, pInfo->address,
-					   MT2063_REG_PWR_1,
-					   &pInfo->reg[MT2063_REG_PWR_1], 2);
-
-		if (MT2063_NO_ERROR(status)) {
-			*Bits =
-			    (enum
-			     MT2063_Mask_Bits)(((s32) pInfo->
-						reg[MT2063_REG_PWR_2] << 8) +
-					       pInfo->reg[MT2063_REG_PWR_1]);
-			*Bits = (enum MT2063_Mask_Bits)(*Bits & MT2063_ALL_SD);	/* Only valid bits for this tuner */
-		}
-	}
-
-	return (status);
-}
-
-/****************************************************************************
-**
-**  Name: MT2063_EnableExternalShutdown
-**
-**  Description:    Enables or disables the operation of the external
-**                  shutdown pin
-**
-**  Parameters:     h           - Tuner handle (returned by MT2063_Open)
-**                  Enabled     - 0 = disable the pin, otherwise enable it
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**                      MT_COMM_ERR      - Serial bus communications error
-**
-**  Dependencies:   USERS MUST CALL MT2063_Open() FIRST!
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**
-****************************************************************************/
-static u32 MT2063_EnableExternalShutdown(void *h, u8 Enabled)
-{
-	u32 status = MT2063_OK;	/* Status to be returned        */
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
-
-	/*  Verify that the handle passed points to a valid tuner         */
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		status = MT2063_INV_HANDLE;
-	else {
-		if (Enabled == 0)
-			pInfo->reg[MT2063_REG_PWR_1] &= ~0x08;	/* Turn off the bit */
-		else
-			pInfo->reg[MT2063_REG_PWR_1] |= 0x08;	/* Turn the bit on */
-
-		status |=
-		    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
-				    MT2063_REG_PWR_1,
-				    &pInfo->reg[MT2063_REG_PWR_1], 1);
-	}
-
-	return (status);
-}
-
-/****************************************************************************
-**
 **  Name: MT2063_SoftwareShutdown
 **
 **  Description:    Enables or disables software shutdown function.  When
@@ -3948,60 +3490,6 @@ static u32 MT2063_SoftwareShutdown(void *h, u8 Shutdown)
 
 /****************************************************************************
 **
-**  Name: MT2063_SetExtSRO
-**
-**  Description:    Sets the external SRO driver.
-**
-**  Parameters:     h           - Tuner handle (returned by MT2063_Open)
-**                  Ext_SRO_Setting - external SRO drive setting
-**
-**       (default)    MT2063_EXT_SRO_OFF  - ext driver off
-**                    MT2063_EXT_SRO_BY_1 - ext driver = SRO frequency
-**                    MT2063_EXT_SRO_BY_2 - ext driver = SRO/2 frequency
-**                    MT2063_EXT_SRO_BY_4 - ext driver = SRO/4 frequency
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_COMM_ERR      - Serial bus communications error
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**
-**  Dependencies:   USERS MUST CALL MT2063_Open() FIRST!
-**
-**                  The Ext_SRO_Setting settings default to OFF
-**                  Use this function if you need to override the default
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**   189 S 05-13-2008    RSK    Ver 1.16: Correct location for ExtSRO control.
-**
-****************************************************************************/
-static u32 MT2063_SetExtSRO(void *h, enum MT2063_Ext_SRO Ext_SRO_Setting)
-{
-	u32 status = MT2063_OK;	/* Status to be returned        */
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
-
-	/*  Verify that the handle passed points to a valid tuner         */
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		status = MT2063_INV_HANDLE;
-	else {
-		pInfo->reg[MT2063_REG_CTRL_2C] =
-		    (pInfo->
-		     reg[MT2063_REG_CTRL_2C] & 0x3F) | ((u8) Ext_SRO_Setting
-							<< 6);
-		status =
-		    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
-				    MT2063_REG_CTRL_2C,
-				    &pInfo->reg[MT2063_REG_CTRL_2C], 1);
-	}
-
-	return (status);
-}
-
-/****************************************************************************
-**
 **  Name: MT2063_SetReg
 **
 **  Description:    Sets an MT2063 register.
-- 
1.7.7.5

