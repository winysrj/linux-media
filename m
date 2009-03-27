Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41182 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZC0SP3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 14:15:29 -0400
Date: Fri, 27 Mar 2009 15:15:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Wong <davidtlwong@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Support for ASUS U3100 Mini DMB-TH USB Dongle
Message-ID: <20090327151520.1fe40869@pedra.chehab.org>
In-Reply-To: <15ed362e0903262101iadbfd97iad20a38ca5c4f083@mail.gmail.com>
References: <15ed362e0903262101iadbfd97iad20a38ca5c4f083@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 27 Mar 2009 12:01:12 +0800
David Wong <davidtlwong@gmail.com> wrote:

> This patch adds support for ASUS U3100 Mini DMB-TH USB Dongle, using
> unified LGS8GXX driver and partial Analog Device ADMTV102 support
> 
> Signed-off-by: David T.L. Wong <davidtlwong@gmail.com>

The patch has many CodingStyle troubles. Please, fix those errors and resubmit.

When the driver has so many errors, sometimes, the easiest way is to run
Lindent script, from kernel tree. Lindent will do some bad things and won't fix
everything. So, a manual review is required. Yet, in general, it is easier than
to to just fix everything.

The whitespacing troubles can be easily fixed with "make whitespace", using the
mercurial scripts.

Cheers,
Mauro

ERROR: trailing whitespace
#54: FILE: linux/drivers/media/common/tuners/admtv102.c:9:
+/* define the register address and data of Tuner that need to be initialized when power on */ $

WARNING: line over 80 characters
#54: FILE: linux/drivers/media/common/tuners/admtv102.c:9:
+/* define the register address and data of Tuner that need to be initialized when power on */ 

ERROR: spaces required around that '=' (ctx:VxE)
#55: FILE: linux/drivers/media/common/tuners/admtv102.c:10:
+u8 AddrDataMemADMTV102_UHF[100]=
                                ^

ERROR: do not use C99 // comments
#57: FILE: linux/drivers/media/common/tuners/admtv102.c:12:
+//Addr Data

WARNING: line over 80 characters
#58: FILE: linux/drivers/media/common/tuners/admtv102.c:13:
+ 0x10,0x6A,      // LNA current, 0x4C will degrade 1 dB performance but get better power consumption.

ERROR: do not use C99 // comments
#58: FILE: linux/drivers/media/common/tuners/admtv102.c:13:
+ 0x10,0x6A,      // LNA current, 0x4C will degrade 1 dB performance but get better power consumption.

ERROR: space required after that ',' (ctx:VxV)
#58: FILE: linux/drivers/media/common/tuners/admtv102.c:13:
+ 0x10,0x6A,      // LNA current, 0x4C will degrade 1 dB performance but get better power consumption.
      ^

ERROR: do not use C99 // comments
#59: FILE: linux/drivers/media/common/tuners/admtv102.c:14:
+ 0x11,0xD8,      // Mixer current

ERROR: space required after that ',' (ctx:VxV)
#59: FILE: linux/drivers/media/common/tuners/admtv102.c:14:
+ 0x11,0xD8,      // Mixer current
      ^

ERROR: do not use C99 // comments
#60: FILE: linux/drivers/media/common/tuners/admtv102.c:15:
+ 0x12,0xC0,      // Mixer gain

ERROR: space required after that ',' (ctx:VxV)
#60: FILE: linux/drivers/media/common/tuners/admtv102.c:15:
+ 0x12,0xC0,      // Mixer gain
      ^

ERROR: trailing whitespace
#61: FILE: linux/drivers/media/common/tuners/admtv102.c:16:
+ 0x15,0x3D,      // TOP and ADJ to optimize SNR and ACI $

ERROR: do not use C99 // comments
#61: FILE: linux/drivers/media/common/tuners/admtv102.c:16:
+ 0x15,0x3D,      // TOP and ADJ to optimize SNR and ACI 

ERROR: space required after that ',' (ctx:VxV)
#61: FILE: linux/drivers/media/common/tuners/admtv102.c:16:
+ 0x15,0x3D,      // TOP and ADJ to optimize SNR and ACI 
      ^

WARNING: line over 80 characters
#62: FILE: linux/drivers/media/common/tuners/admtv102.c:17:
+ 0x17,0x97,      // TOP and ADJ to optimize SNR and ACI //*9A->97,Changed TOP and ADJ to optimize SNR and ACI

ERROR: do not use C99 // comments
#62: FILE: linux/drivers/media/common/tuners/admtv102.c:17:
+ 0x17,0x97,      // TOP and ADJ to optimize SNR and ACI //*9A->97,Changed TOP and ADJ to optimize SNR and ACI

ERROR: space required after that ',' (ctx:VxV)
#62: FILE: linux/drivers/media/common/tuners/admtv102.c:17:
+ 0x17,0x97,      // TOP and ADJ to optimize SNR and ACI //*9A->97,Changed TOP and ADJ to optimize SNR and ACI
      ^

WARNING: line over 80 characters
#63: FILE: linux/drivers/media/common/tuners/admtv102.c:18:
+ 0x18,0x03,      // Changed power detector saturation voltage point and warning voltage point //* new insert

ERROR: trailing whitespace
#64: FILE: linux/drivers/media/common/tuners/admtv102.c:19:
+ 0x1F,0x17,      // VCOSEL,PLLF RFPGA amp current $

WARNING: line over 80 characters
#75: FILE: linux/drivers/media/common/tuners/admtv102.c:30:
+ 0X2C,0xFF,      // CONBUF0/1 for L-Band Buffer amp and first Buffer amp current control

ERROR: trailing whitespace
#78: FILE: linux/drivers/media/common/tuners/admtv102.c:33:
+ 0x32,0xc2,      // LOOP filter boundary $

ERROR: trailing whitespace
#93: FILE: linux/drivers/media/common/tuners/admtv102.c:48:
+}; $

ERROR: trailing whitespace
#102: FILE: linux/drivers/media/common/tuners/admtv102.c:57:
+ 0x1F,0x17,      // VCOSEL,PLLF RFPGA amp current $

ERROR: trailing whitespace
#112: FILE: linux/drivers/media/common/tuners/admtv102.c:67:
+ 0x2D,0x9C,     $

ERROR: trailing whitespace
#116: FILE: linux/drivers/media/common/tuners/admtv102.c:71:
+ 0x32,0xc2,      // LOOP filter boundary $

ERROR: trailing whitespace
#126: FILE: linux/drivers/media/common/tuners/admtv102.c:81:
+}; $

ERROR: trailing whitespace
#132: FILE: linux/drivers/media/common/tuners/admtv102.c:87:
+^I{0x1F,0x04,0x50}, //16.384MHz $

ERROR: trailing whitespace
#137: FILE: linux/drivers/media/common/tuners/admtv102.c:92:
+^I{0x5A,0x04,0x51}, //30.4MHz  //* special set for 30.4MHz case $

WARNING: line over 80 characters
#148: FILE: linux/drivers/media/common/tuners/admtv102.c:103:
+#define dprintk(args...) do { if (debug) {printk(KERN_DEBUG "admtv102: " args); printk("\n"); }} while (0)

WARNING: line over 80 characters
#154: FILE: linux/drivers/media/common/tuners/admtv102.c:109:
+		{ .addr = priv->cfg->i2c_address, .flags = 0,        .buf = &reg, .len = 1 },

WARNING: line over 80 characters
#155: FILE: linux/drivers/media/common/tuners/admtv102.c:110:
+		{ .addr = priv->cfg->i2c_address, .flags = I2C_M_RD, .buf = val,  .len = 1 },

WARNING: line over 80 characters
#188: FILE: linux/drivers/media/common/tuners/admtv102.c:143:
+		.addr = priv->cfg->i2c_address, .flags = 0, .buf = buf, .len = len

WARNING: line over 80 characters
#191: FILE: linux/drivers/media/common/tuners/admtv102.c:146:
+		printk(KERN_WARNING "mt2060 I2C write failed (len=%i)\n",(int)len);

ERROR: do not use C99 // comments
#200: FILE: linux/drivers/media/common/tuners/admtv102.c:155:
+//u8 g_icp,

ERROR: do not use C99 // comments
#201: FILE: linux/drivers/media/common/tuners/admtv102.c:156:
+//g_convco,g_curTempState,g_CTUNE_CLKOFS;

ERROR: do not use C99 // comments
#202: FILE: linux/drivers/media/common/tuners/admtv102.c:157:
+//int g_VHFSet=UHFSupport;

ERROR: do not use C99 // comments
#203: FILE: linux/drivers/media/common/tuners/admtv102.c:158:
+//int g_TunerPLLType=REFCLK16384;

ERROR: do not use C99 // comments
#204: FILE: linux/drivers/media/common/tuners/admtv102.c:159:
+//ChannelInfo  FindChannel[50];

ERROR: do not use C99 // comments
#205: FILE: linux/drivers/media/common/tuners/admtv102.c:160:
+//MPEG_PROGINFO myMpegInfo[MaxProgNum];

WARNING: line over 80 characters
#206: FILE: linux/drivers/media/common/tuners/admtv102.c:161:
+//int FindProgNum;   // indicate how many program is found in one certain channel

ERROR: do not use C99 // comments
#206: FILE: linux/drivers/media/common/tuners/admtv102.c:161:
+//int FindProgNum;   // indicate how many program is found in one certain channel

ERROR: trailing whitespace
#219: FILE: linux/drivers/media/common/tuners/admtv102.c:174:
+// Function:  Configure Tuner chip registers                                            $

ERROR: trailing whitespace
#220: FILE: linux/drivers/media/common/tuners/admtv102.c:175:
+// Input: target -- Device I2C address $

ERROR: trailing whitespace
#221: FILE: linux/drivers/media/common/tuners/admtv102.c:176:
+//        AddrData -- Register address and Config data array $

ERROR: trailing whitespace
#230: FILE: linux/drivers/media/common/tuners/admtv102.c:185:
+   { $

ERROR: trailing whitespace
#238: FILE: linux/drivers/media/common/tuners/admtv102.c:193:
+// Function:  Set Tuner LPF configuration                                            $

ERROR: trailing whitespace
#239: FILE: linux/drivers/media/common/tuners/admtv102.c:194:
+// Input: target -- Tuner I2C device Address $

ERROR: trailing whitespace
#240: FILE: linux/drivers/media/common/tuners/admtv102.c:195:
+//        refClkType -- Tuner PLL Type $

ERROR: trailing whitespace
#251: FILE: linux/drivers/media/common/tuners/admtv102.c:206:
+^Iadmtv102_writereg(state, 0x25 , (_EXTUNEOFF << 2) | (_TUNEEN<<1) );  $

ERROR: trailing whitespace
#252: FILE: linux/drivers/media/common/tuners/admtv102.c:207:
+^Imsleep(10);  //change from 1 to 10 $

ERROR: trailing whitespace
#254: FILE: linux/drivers/media/common/tuners/admtv102.c:209:
+^Ituneval=0x10; //default value $

ERROR: trailing whitespace
#257: FILE: linux/drivers/media/common/tuners/admtv102.c:212:
+^I^Ituneval = t;^I$

ERROR: trailing whitespace
#258: FILE: linux/drivers/media/common/tuners/admtv102.c:213:
+^I$

WARNING: line over 80 characters
#259: FILE: linux/drivers/media/common/tuners/admtv102.c:214:
+    admtv102_writereg(state, 0x25 , (_EXTUNEON << 2) | (_TUNEEN << 1) );   //change Tuning mode : auto-tune => manual tune(hold mode).

WARNING: line over 80 characters
#262: FILE: linux/drivers/media/common/tuners/admtv102.c:217:
+		admtv102_writereg(state, 0x25, (u8)(((tuneval+state->CTUNE_CLKOFS)<<3) | (_EXTUNEON << 2) | (_TUNEEN << 1)) );   //Write CTUNE val. in order to store tuned value.

WARNING: line over 80 characters
#264: FILE: linux/drivers/media/common/tuners/admtv102.c:219:
+		admtv102_writereg(state, 0x25, (u8)((tuneval<<3) | (_EXTUNEON << 2) | (_TUNEEN << 1)) );   //Write CTUNE val. in order to store tuned value.

ERROR: trailing whitespace
#270: FILE: linux/drivers/media/common/tuners/admtv102.c:225:
+// Function: Tuner PLL Register Setting $

ERROR: trailing whitespace
#271: FILE: linux/drivers/media/common/tuners/admtv102.c:226:
+// Input: target -- Tuner I2C device Address $

ERROR: trailing whitespace
#272: FILE: linux/drivers/media/common/tuners/admtv102.c:227:
+//        RegDat -- Reg set value table   $

ERROR: trailing whitespace
#288: FILE: linux/drivers/media/common/tuners/admtv102.c:243:
+^I^I^Idata=REFCLK30400_CLKSEL_REG_SPLITID0E;  // 0x5A $

ERROR: trailing whitespace
#290: FILE: linux/drivers/media/common/tuners/admtv102.c:245:
+^I^I^Idata=REFCLK30400_CLKSEL_REG_SPLITID0F;  // 0x6A, for mass product $

WARNING: line over 80 characters
#290: FILE: linux/drivers/media/common/tuners/admtv102.c:245:
+			data=REFCLK30400_CLKSEL_REG_SPLITID0F;  // 0x6A, for mass product 

ERROR: trailing whitespace
#306: FILE: linux/drivers/media/common/tuners/admtv102.c:261:
+ $

ERROR: trailing whitespace
#309: FILE: linux/drivers/media/common/tuners/admtv102.c:264:
+^Iadmtv102_writereg(state, addr, data); $

ERROR: trailing whitespace
#310: FILE: linux/drivers/media/common/tuners/admtv102.c:265:
+^I$

ERROR: trailing whitespace
#314: FILE: linux/drivers/media/common/tuners/admtv102.c:269:
+// Function:  Distinguish Tuner Chip type by read SplidID                                              $

ERROR: trailing whitespace
#315: FILE: linux/drivers/media/common/tuners/admtv102.c:270:
+// Input: target -- Device I2C address $

ERROR: trailing whitespace
#316: FILE: linux/drivers/media/common/tuners/admtv102.c:271:
+//        $

ERROR: trailing whitespace
#317: FILE: linux/drivers/media/common/tuners/admtv102.c:272:
+// Return: Tuner Type, MTV102 or ADMTV102 $

ERROR: trailing whitespace
#321: FILE: linux/drivers/media/common/tuners/admtv102.c:276:
+^Iu8 splitid,RetTunerType; $

ERROR: trailing whitespace
#349: FILE: linux/drivers/media/common/tuners/admtv102.c:304:
+//            only support ADMTV102 type, do not support MTV102 any more                                              $

WARNING: line over 80 characters
#349: FILE: linux/drivers/media/common/tuners/admtv102.c:304:
+//            only support ADMTV102 type, do not support MTV102 any more                                              

ERROR: trailing whitespace
#360: FILE: linux/drivers/media/common/tuners/admtv102.c:315:
+^Istate->curTempState=HIGH_TEMP; $

ERROR: trailing whitespace
#372: FILE: linux/drivers/media/common/tuners/admtv102.c:327:
+// Function:  frequency setting for ADMTV102                                              $

ERROR: trailing whitespace
#380: FILE: linux/drivers/media/common/tuners/admtv102.c:335:
+//  Return: None $

ERROR: trailing whitespace
#384: FILE: linux/drivers/media/common/tuners/admtv102.c:339:
+^Iu32    MTV10x_REFCLK; $

ERROR: trailing whitespace
#386: FILE: linux/drivers/media/common/tuners/admtv102.c:341:
+^Iu32    DIVSEL=0,VCOSEL=0;^I$

ERROR: trailing whitespace
#389: FILE: linux/drivers/media/common/tuners/admtv102.c:344:
+^Iu8    PLLR; $

ERROR: trailing whitespace
#395: FILE: linux/drivers/media/common/tuners/admtv102.c:350:
+^I$

ERROR: trailing whitespace
#397: FILE: linux/drivers/media/common/tuners/admtv102.c:352:
+^I// judge if the VFHset has conflict with frequency value or not $

ERROR: trailing whitespace
#398: FILE: linux/drivers/media/common/tuners/admtv102.c:353:
+^Iif( frequency >400 &&  VHFSupport==state->VHFSet) // VHF is 174MHz ~ 245MHz $

WARNING: line over 80 characters
#398: FILE: linux/drivers/media/common/tuners/admtv102.c:353:
+	if( frequency >400 &&  VHFSupport==state->VHFSet) // VHF is 174MHz ~ 245MHz 

ERROR: trailing whitespace
#413: FILE: linux/drivers/media/common/tuners/admtv102.c:368:
+^I$

ERROR: trailing whitespace
#418: FILE: linux/drivers/media/common/tuners/admtv102.c:373:
+^Ielse ^I$

ERROR: trailing whitespace
#427: FILE: linux/drivers/media/common/tuners/admtv102.c:382:
+^I^IMultiFactor=10;^I$

ERROR: trailing whitespace
#432: FILE: linux/drivers/media/common/tuners/admtv102.c:387:
+   case ADMTV102_REFCLK16384: { $

ERROR: trailing whitespace
#433: FILE: linux/drivers/media/common/tuners/admtv102.c:388:
+^I   MTV10x_REFCLK = 16384; $

ERROR: trailing whitespace
#437: FILE: linux/drivers/media/common/tuners/admtv102.c:392:
+^I   div_2=1; // 16384== 2^14 $

ERROR: trailing whitespace
#440: FILE: linux/drivers/media/common/tuners/admtv102.c:395:
+^I   MTV10x_REFCLK = 192; $

ERROR: trailing whitespace
#444: FILE: linux/drivers/media/common/tuners/admtv102.c:399:
+^I   div_2=3; //  192 = 2^6 *3 $

ERROR: trailing whitespace
#447: FILE: linux/drivers/media/common/tuners/admtv102.c:402:
+^I   MTV10x_REFCLK = 2048; $

ERROR: trailing whitespace
#451: FILE: linux/drivers/media/common/tuners/admtv102.c:406:
+^I   div_2=1; //  2048 = 2^11   $

ERROR: trailing whitespace
#454: FILE: linux/drivers/media/common/tuners/admtv102.c:409:
+^I   MTV10x_REFCLK = 24576; $

ERROR: trailing whitespace
#458: FILE: linux/drivers/media/common/tuners/admtv102.c:413:
+^I   div_2=3; // 24576 = 2^13*3 $

ERROR: trailing whitespace
#461: FILE: linux/drivers/media/common/tuners/admtv102.c:416:
+^I   MTV10x_REFCLK = 260; $

ERROR: trailing whitespace
#462: FILE: linux/drivers/media/common/tuners/admtv102.c:417:
+^I   MultiFactor=10;^I$

ERROR: trailing whitespace
#465: FILE: linux/drivers/media/common/tuners/admtv102.c:420:
+^I   div_2=13; // 260=13*5*(2^2)   $

WARNING: line over 80 characters
#472: FILE: linux/drivers/media/common/tuners/admtv102.c:427:
+		admtv102_writereg(state, 0x19, PLLR); //Ref. Clock Divider PLL0 register , bit[7:4] is reserved, bit[3:0] is PLLR

ERROR: trailing whitespace
#475: FILE: linux/drivers/media/common/tuners/admtv102.c:430:
+^I   div_2=19; // 304 = 16*19   $

ERROR: trailing whitespace
#478: FILE: linux/drivers/media/common/tuners/admtv102.c:433:
+   case ADMTV102_REFCLK36000: { $

ERROR: trailing whitespace
#480: FILE: linux/drivers/media/common/tuners/admtv102.c:435:
+^I   MultiFactor=10;^I$

ERROR: trailing whitespace
#483: FILE: linux/drivers/media/common/tuners/admtv102.c:438:
+^I   div_2=9; // 360=2^3*9*5 ^I   $

ERROR: trailing whitespace
#485: FILE: linux/drivers/media/common/tuners/admtv102.c:440:
+   case ADMTV102_REFCLK38400:{ $

ERROR: trailing whitespace
#486: FILE: linux/drivers/media/common/tuners/admtv102.c:441:
+^I   MTV10x_REFCLK = 384; $

ERROR: trailing whitespace
#490: FILE: linux/drivers/media/common/tuners/admtv102.c:445:
+^I   div_2=3; // 384 = 2^7 *3    $

ERROR: trailing whitespace
#492: FILE: linux/drivers/media/common/tuners/admtv102.c:447:
+   case ADMTV102_REFCLK20000:{ $

ERROR: trailing whitespace
#493: FILE: linux/drivers/media/common/tuners/admtv102.c:448:
+^I   MTV10x_REFCLK = 200; $

ERROR: trailing whitespace
#494: FILE: linux/drivers/media/common/tuners/admtv102.c:449:
+^I   MultiFactor=10;^I$

ERROR: trailing whitespace
#499: FILE: linux/drivers/media/common/tuners/admtv102.c:454:
+   default: { $

ERROR: trailing whitespace
#500: FILE: linux/drivers/media/common/tuners/admtv102.c:455:
+^I   MTV10x_REFCLK = 16384; $

ERROR: trailing whitespace
#504: FILE: linux/drivers/media/common/tuners/admtv102.c:459:
+^I   div_2=1; // 16384== 2^14 $

ERROR: trailing whitespace
#507: FILE: linux/drivers/media/common/tuners/admtv102.c:462:
+   $

WARNING: line over 80 characters
#508: FILE: linux/drivers/media/common/tuners/admtv102.c:463:
+   PLLN = (Freq*MultiFactor* PLLR/MTV10x_REFCLK ); //new formula, liu dong, 2007/12/11

ERROR: trailing whitespace
#509: FILE: linux/drivers/media/common/tuners/admtv102.c:464:
+   tmp = ((PLLR*Freq*MultiFactor/div_1) << (20-sub_exp) )/div_2;   $

ERROR: trailing whitespace
#514: FILE: linux/drivers/media/common/tuners/admtv102.c:469:
+   $

ERROR: trailing whitespace
#515: FILE: linux/drivers/media/common/tuners/admtv102.c:470:
+   if (PLLN<=66)   $

ERROR: trailing whitespace
#516: FILE: linux/drivers/media/common/tuners/admtv102.c:471:
+   {   $

ERROR: trailing whitespace
#520: FILE: linux/drivers/media/common/tuners/admtv102.c:475:
+       DATA47 = (u8)(DATA47 | (PC4<<6) | (PC8_16<<5)); $

ERROR: trailing whitespace
#527: FILE: linux/drivers/media/common/tuners/admtv102.c:482:
+       DATA47 = (u8) (DATA47 | (PC4<<6) | (PC8_16<<5)); $

ERROR: trailing whitespace
#530: FILE: linux/drivers/media/common/tuners/admtv102.c:485:
+   // do a reset operation $

WARNING: line over 80 characters
#531: FILE: linux/drivers/media/common/tuners/admtv102.c:486:
+   admtv102_writereg(state, 0x27, 0x00 ); //added : v1.6.3 at PM 20:39 2007-07-26

WARNING: line over 80 characters
#533: FILE: linux/drivers/media/common/tuners/admtv102.c:488:
+   admtv102_writereg(state, 0x2f, DATA47 );      //Reset Seq. 0 => 1  : //updated : v1.6.3 at PM 20:39 2007-07-26

ERROR: trailing whitespace
#543: FILE: linux/drivers/media/common/tuners/admtv102.c:498:
+   _temper &= 0x3f; // get low 6 bits $

ERROR: trailing whitespace
#544: FILE: linux/drivers/media/common/tuners/admtv102.c:499:
+   $

WARNING: line over 80 characters
#545: FILE: linux/drivers/media/common/tuners/admtv102.c:500:
+   dpPhaseTuning(state, lofreq,_temper); //these value may changes: g_icp=0, state->convco=0, state->curTempState=HIGH_TEMP;

ERROR: trailing whitespace
#546: FILE: linux/drivers/media/common/tuners/admtv102.c:501:
+   $

ERROR: trailing whitespace
#548: FILE: linux/drivers/media/common/tuners/admtv102.c:503:
+   {   $

WARNING: line over 80 characters
#549: FILE: linux/drivers/media/common/tuners/admtv102.c:504:
+      admtv102_writereg(state, 0x1a, (u8)((state->icp<<2)| ((PLLN&0x300)>>8)));    // change 1C to 7C. 2007/07/09

ERROR: trailing whitespace
#551: FILE: linux/drivers/media/common/tuners/admtv102.c:506:
+   else $

WARNING: line over 80 characters
#558: FILE: linux/drivers/media/common/tuners/admtv102.c:513:
+   admtv102_writereg(state, 0x1c, (u8)( (DIVSEL<<4) | (VCOSEL<<7) | ((PLLF&0xF0000)>>16) ) );

WARNING: line over 80 characters
#564: FILE: linux/drivers/media/common/tuners/admtv102.c:519:
+   admtv102_writereg(state, 0x2f, DATA47);      //Reset Seq. 0 => 1 => 0 : //updated : v1.5 at PM 20:39 2007-06-8

ERROR: trailing whitespace
#567: FILE: linux/drivers/media/common/tuners/admtv102.c:522:
+   $

ERROR: trailing whitespace
#569: FILE: linux/drivers/media/common/tuners/admtv102.c:524:
+   if (lofreq>400000)    admtv102_writereg(state, 0x29, 0xBF );^I $

ERROR: trailing whitespace
#570: FILE: linux/drivers/media/common/tuners/admtv102.c:525:
+   return; ^I$

ERROR: trailing whitespace
#573: FILE: linux/drivers/media/common/tuners/admtv102.c:528:
+// Function:  calculate DIVSEL according to lofreq                                             $

ERROR: trailing whitespace
#574: FILE: linux/drivers/media/common/tuners/admtv102.c:529:
+//  Input:   lofreq  -- Frequency point value in kHz unit $

ERROR: trailing whitespace
#575: FILE: linux/drivers/media/common/tuners/admtv102.c:530:
+//  Return:  m_DIVSEL -- DIVSEL in register 0x1C  $

ERROR: trailing whitespace
#582: FILE: linux/drivers/media/common/tuners/admtv102.c:537:
+    $

ERROR: trailing whitespace
#595: FILE: linux/drivers/media/common/tuners/admtv102.c:550:
+// Input: lofreq -- frequency in kHz unit $

ERROR: trailing whitespace
#596: FILE: linux/drivers/media/common/tuners/admtv102.c:551:
+//        temper -- Tuner 0x09 register content  $

ERROR: trailing whitespace
#603: FILE: linux/drivers/media/common/tuners/admtv102.c:558:
+{  $

ERROR: code indent should use tabs where possible
#607: FILE: linux/drivers/media/common/tuners/admtv102.c:562:
+   ^Iif (temper<=vlowDegBoundary)  //low boundary$

ERROR: trailing whitespace
#609: FILE: linux/drivers/media/common/tuners/admtv102.c:564:
+^I  state->convco=rglowDegCONVCO_VHF; $

ERROR: trailing whitespace
#617: FILE: linux/drivers/media/common/tuners/admtv102.c:572:
+^I  }^I$

ERROR: trailing whitespace
#619: FILE: linux/drivers/media/common/tuners/admtv102.c:574:
+   else {   ^I$

WARNING: line over 80 characters
#643: FILE: linux/drivers/media/common/tuners/admtv102.c:598:
+		if (( lofreq > 610000  ) && ( lofreq < 648000  )) //610MHz ~ 648MHz

ERROR: trailing whitespace
#646: FILE: linux/drivers/media/common/tuners/admtv102.c:601:
+^I      }^I$

ERROR: trailing whitespace
#653: FILE: linux/drivers/media/common/tuners/admtv102.c:608:
+// Function: Do tuner temperature compensate, it can be called by processor $

ERROR: trailing whitespace
#654: FILE: linux/drivers/media/common/tuners/admtv102.c:609:
+//           for every 5~10 seconds. This may improve the tuner performance.  $

ERROR: trailing whitespace
#655: FILE: linux/drivers/media/common/tuners/admtv102.c:610:
+//  $

ERROR: trailing whitespace
#656: FILE: linux/drivers/media/common/tuners/admtv102.c:611:
+// Input: lofreq -- frequency in kHz unit $

ERROR: trailing whitespace
#660: FILE: linux/drivers/media/common/tuners/admtv102.c:615:
+{  $

ERROR: trailing whitespace
#663: FILE: linux/drivers/media/common/tuners/admtv102.c:618:
+    Ori_Reg_0x1A=0xFC; $

ERROR: trailing whitespace
#666: FILE: linux/drivers/media/common/tuners/admtv102.c:621:
+    _temper &= 0x3F; // get low 6 bits $

WARNING: line over 80 characters
#670: FILE: linux/drivers/media/common/tuners/admtv102.c:625:
+    admtv102_readreg(state, 0x1A, &Ori_Reg_0x1A) ;  //To get Temperature sensor value

ERROR: trailing whitespace
#673: FILE: linux/drivers/media/common/tuners/admtv102.c:628:
+    Reg_0x1A= (u8)((state->icp <<2) | (Ori_Reg_0x1A & 0x83)); $

ERROR: trailing whitespace
#674: FILE: linux/drivers/media/common/tuners/admtv102.c:629:
+    // write state->icp into 0x1A register bit[6:2] $

ERROR: trailing whitespace
#682: FILE: linux/drivers/media/common/tuners/admtv102.c:637:
+ *  Function: calculate signal power using Tuner related registers $

ERROR: trailing whitespace
#684: FILE: linux/drivers/media/common/tuners/admtv102.c:639:
+ *   Return: signal power in dBm unit  $

ERROR: code indent should use tabs where possible
#697: FILE: linux/drivers/media/common/tuners/admtv102.c:652:
+ ^Iint PowerDBValue=0; // in dBm unit$

ERROR: do not use C99 // comments
#697: FILE: linux/drivers/media/common/tuners/admtv102.c:652:
+ 	int PowerDBValue=0; // in dBm unit

ERROR: spaces required around that '=' (ctx:VxV)
#697: FILE: linux/drivers/media/common/tuners/admtv102.c:652:
+ 	int PowerDBValue=0; // in dBm unit
  	                ^

ERROR: spaces required around that '=' (ctx:WxV)
#698: FILE: linux/drivers/media/common/tuners/admtv102.c:653:
+	unsigned char RF_AGC_LowByte =0,RF_AGC_HighByte=0,LNA_Gain=0,GVBB=0;
 	                             ^

ERROR: space required after that ',' (ctx:VxV)
#698: FILE: linux/drivers/media/common/tuners/admtv102.c:653:
+	unsigned char RF_AGC_LowByte =0,RF_AGC_HighByte=0,LNA_Gain=0,GVBB=0;
 	                               ^

ERROR: spaces required around that '=' (ctx:VxV)
#698: FILE: linux/drivers/media/common/tuners/admtv102.c:653:
+	unsigned char RF_AGC_LowByte =0,RF_AGC_HighByte=0,LNA_Gain=0,GVBB=0;
 	                                               ^

ERROR: space required after that ',' (ctx:VxV)
#698: FILE: linux/drivers/media/common/tuners/admtv102.c:653:
+	unsigned char RF_AGC_LowByte =0,RF_AGC_HighByte=0,LNA_Gain=0,GVBB=0;
 	                                                 ^

ERROR: spaces required around that '=' (ctx:VxV)
#698: FILE: linux/drivers/media/common/tuners/admtv102.c:653:
+	unsigned char RF_AGC_LowByte =0,RF_AGC_HighByte=0,LNA_Gain=0,GVBB=0;
 	                                                          ^

ERROR: space required after that ',' (ctx:VxV)
#698: FILE: linux/drivers/media/common/tuners/admtv102.c:653:
+	unsigned char RF_AGC_LowByte =0,RF_AGC_HighByte=0,LNA_Gain=0,GVBB=0;
 	                                                            ^

ERROR: spaces required around that '=' (ctx:VxV)
#698: FILE: linux/drivers/media/common/tuners/admtv102.c:653:
+	unsigned char RF_AGC_LowByte =0,RF_AGC_HighByte=0,LNA_Gain=0,GVBB=0;
 	                                                                 ^

ERROR: do not use C99 // comments
#702: FILE: linux/drivers/media/common/tuners/admtv102.c:657:
+	//int CompTab[2]={ 497, -530};

ERROR: do not use C99 // comments
#703: FILE: linux/drivers/media/common/tuners/admtv102.c:658:
+	//int FreqTab[2]={ 474, 858 };

ERROR: space required after that ',' (ctx:VxV)
#704: FILE: linux/drivers/media/common/tuners/admtv102.c:659:
+	int Freq_Comp,BBAGC_Part;
 	             ^

ERROR: space required after that ',' (ctx:VxV)
#705: FILE: linux/drivers/media/common/tuners/admtv102.c:660:
+	unsigned char Val_0x3D,Val_0x3e,Val_0x3f;
 	                      ^

ERROR: space required after that ',' (ctx:VxV)
#705: FILE: linux/drivers/media/common/tuners/admtv102.c:660:
+	unsigned char Val_0x3D,Val_0x3e,Val_0x3f;
 	                               ^

ERROR: trailing whitespace
#707: FILE: linux/drivers/media/common/tuners/admtv102.c:662:
+^I$

ERROR: trailing whitespace
#708: FILE: linux/drivers/media/common/tuners/admtv102.c:663:
+^I$

ERROR: trailing whitespace
#709: FILE: linux/drivers/media/common/tuners/admtv102.c:664:
+^IFreq_Comp= -( $

ERROR: spaces required around that '=' (ctx:VxW)
#709: FILE: linux/drivers/media/common/tuners/admtv102.c:664:
+	Freq_Comp= -( 
 	         ^

ERROR: trailing whitespace
#712: FILE: linux/drivers/media/common/tuners/admtv102.c:667:
+^I^I^I^I(FREQ858 - FREQ474) $

ERROR: do not use C99 // comments
#713: FILE: linux/drivers/media/common/tuners/admtv102.c:668:
+		+ COMP497 ); //0.01dB

ERROR: space prohibited before that close parenthesis ')'
#713: FILE: linux/drivers/media/common/tuners/admtv102.c:668:
+		+ COMP497 ); //0.01dB

ERROR: spaces required around that '=' (ctx:VxV)
#715: FILE: linux/drivers/media/common/tuners/admtv102.c:670:
+	GVBB=0;
 	    ^

ERROR: trailing whitespace
#716: FILE: linux/drivers/media/common/tuners/admtv102.c:671:
+^Iadmtv102_readreg (state, 0x05, &RF_AGC_LowByte); $

WARNING: space prohibited between function name and open parenthesis '('
#716: FILE: linux/drivers/media/common/tuners/admtv102.c:671:
+	admtv102_readreg (state, 0x05, &RF_AGC_LowByte); 

ERROR: trailing whitespace
#717: FILE: linux/drivers/media/common/tuners/admtv102.c:672:
+^Iadmtv102_readreg (state, 0x06, &RF_AGC_HighByte); $

WARNING: space prohibited between function name and open parenthesis '('
#717: FILE: linux/drivers/media/common/tuners/admtv102.c:672:
+	admtv102_readreg (state, 0x06, &RF_AGC_HighByte); 

ERROR: trailing whitespace
#718: FILE: linux/drivers/media/common/tuners/admtv102.c:673:
+^I$

ERROR: spaces required around that '=' (ctx:VxW)
#719: FILE: linux/drivers/media/common/tuners/admtv102.c:674:
+	RF_AGC= (RF_AGC_HighByte & 0x01);
 	      ^

ERROR: spaces required around that '=' (ctx:VxW)
#720: FILE: linux/drivers/media/common/tuners/admtv102.c:675:
+	RF_AGC= (RF_AGC<<8) + RF_AGC_LowByte;
 	      ^

ERROR: trailing whitespace
#721: FILE: linux/drivers/media/common/tuners/admtv102.c:676:
+^I$

ERROR: trailing whitespace
#722: FILE: linux/drivers/media/common/tuners/admtv102.c:677:
+^Iadmtv102_readreg (state, 0x0d, &LNA_Gain); $

WARNING: space prohibited between function name and open parenthesis '('
#722: FILE: linux/drivers/media/common/tuners/admtv102.c:677:
+	admtv102_readreg (state, 0x0d, &LNA_Gain); 

ERROR: need consistent spacing around '>>' (ctx:VxW)
#723: FILE: linux/drivers/media/common/tuners/admtv102.c:678:
+	LNA_Gain = ( (LNA_Gain & 0x60 )>> 5 );
 	                               ^

ERROR: space prohibited after that open parenthesis '('
#723: FILE: linux/drivers/media/common/tuners/admtv102.c:678:
+	LNA_Gain = ( (LNA_Gain & 0x60 )>> 5 );

ERROR: space prohibited before that close parenthesis ')'
#723: FILE: linux/drivers/media/common/tuners/admtv102.c:678:
+	LNA_Gain = ( (LNA_Gain & 0x60 )>> 5 );

ERROR: trailing whitespace
#725: FILE: linux/drivers/media/common/tuners/admtv102.c:680:
+^Iadmtv102_readreg (state, 0x04, &GVBB); $

WARNING: space prohibited between function name and open parenthesis '('
#725: FILE: linux/drivers/media/common/tuners/admtv102.c:680:
+	admtv102_readreg (state, 0x04, &GVBB); 

ERROR: spaces required around that '=' (ctx:VxV)
#726: FILE: linux/drivers/media/common/tuners/admtv102.c:681:
+	GVBB=(GVBB&0xf0)>>4;
 	    ^

ERROR: spaces required around that '=' (ctx:VxV)
#728: FILE: linux/drivers/media/common/tuners/admtv102.c:683:
+	Val_0x3D=0;
 	        ^

ERROR: spaces required around that '=' (ctx:VxV)
#729: FILE: linux/drivers/media/common/tuners/admtv102.c:684:
+	Val_0x3e=0;
 	        ^

ERROR: spaces required around that '=' (ctx:VxV)
#730: FILE: linux/drivers/media/common/tuners/admtv102.c:685:
+	Val_0x3f=0;
 	        ^

ERROR: trailing whitespace
#731: FILE: linux/drivers/media/common/tuners/admtv102.c:686:
+^I$

WARNING: space prohibited between function name and open parenthesis '('
#733: FILE: linux/drivers/media/common/tuners/admtv102.c:688:
+	admtv102_readreg (state, lowDemodI2CAdr, 0x3d, &Val_0x3D);

WARNING: space prohibited between function name and open parenthesis '('
#734: FILE: linux/drivers/media/common/tuners/admtv102.c:689:
+	admtv102_readreg (state, lowDemodI2CAdr, 0x3e, &Val_0x3e);

WARNING: space prohibited between function name and open parenthesis '('
#735: FILE: linux/drivers/media/common/tuners/admtv102.c:690:
+	admtv102_readreg (state, lowDemodI2CAdr, 0x3f, &Val_0x3f);

ERROR: trailing whitespace
#736: FILE: linux/drivers/media/common/tuners/admtv102.c:691:
+^Iif (Val_0x3f & 0x10) $

ERROR: do not use C99 // comments
#737: FILE: linux/drivers/media/common/tuners/admtv102.c:692:
+		Val_0x3f= (Val_0x3f & 0x0f);// two's complement to offset binary

ERROR: spaces required around that '=' (ctx:VxW)
#737: FILE: linux/drivers/media/common/tuners/admtv102.c:692:
+		Val_0x3f= (Val_0x3f & 0x0f);// two's complement to offset binary
 		        ^

ERROR: trailing whitespace
#738: FILE: linux/drivers/media/common/tuners/admtv102.c:693:
+^Ielse $

ERROR: trailing whitespace
#743: FILE: linux/drivers/media/common/tuners/admtv102.c:698:
+^IBBAGC_Part = ( BBAGC_Part <<8) + Val_0x3e; $

ERROR: trailing whitespace
#746: FILE: linux/drivers/media/common/tuners/admtv102.c:701:
+^Iif (LNA_Gain==0 && GVBB==4)  CaseNumber=1; //[0,-31dBm], case 1 $

WARNING: line over 80 characters
#747: FILE: linux/drivers/media/common/tuners/admtv102.c:702:
+	if (LNA_Gain==3 && GVBB==4 && RF_AGC<383)  CaseNumber=2; //[-34dBm,-59dBm], case 2

WARNING: line over 80 characters
#748: FILE: linux/drivers/media/common/tuners/admtv102.c:703:
+	if (LNA_Gain==3 && GVBB>4 && RF_AGC>=383)  CaseNumber=3; //[-61Bm,-93dBm], case 3

ERROR: trailing whitespace
#749: FILE: linux/drivers/media/common/tuners/admtv102.c:704:
+^Iif ( (LNA_Gain==0 && GVBB>4) || (LNA_Gain==3 && GVBB<4) ) CaseNumber=4; //[-2,-52dBm], case 4 $

WARNING: line over 80 characters
#749: FILE: linux/drivers/media/common/tuners/admtv102.c:704:
+	if ( (LNA_Gain==0 && GVBB>4) || (LNA_Gain==3 && GVBB<4) ) CaseNumber=4; //[-2,-52dBm], case 4 

ERROR: trailing whitespace
#750: FILE: linux/drivers/media/common/tuners/admtv102.c:705:
+^Iif (LNA_Gain==3 && GVBB>4 && RF_AGC<383)  CaseNumber=5; //[-53,-78dBm], case 5 $

WARNING: line over 80 characters
#750: FILE: linux/drivers/media/common/tuners/admtv102.c:705:
+	if (LNA_Gain==3 && GVBB>4 && RF_AGC<383)  CaseNumber=5; //[-53,-78dBm], case 5 

WARNING: line over 80 characters
#751: FILE: linux/drivers/media/common/tuners/admtv102.c:706:
+	if (GetTunerType(state,lowTunerI2CAdr)==Tuner_MTV102) CaseNumber=0; //use default formula

ERROR: trailing whitespace
#752: FILE: linux/drivers/media/common/tuners/admtv102.c:707:
+^I$

ERROR: space required before that '!' (ctx:VxO)
#754: FILE: linux/drivers/media/common/tuners/admtv102.c:709:
+	// basically all the tests I've found have ended up with cast 5!!!1
 	                                                               ^

ERROR: trailing whitespace
#755: FILE: linux/drivers/media/common/tuners/admtv102.c:710:
+^I$

ERROR: trailing whitespace
#756: FILE: linux/drivers/media/common/tuners/admtv102.c:711:
+^I$

ERROR: do not use C99 // comments
#757: FILE: linux/drivers/media/common/tuners/admtv102.c:712:
+	// if BBAGC > 0.97, case number is forced to 0, liu dong, 2008/04/22

ERROR: spaces required around that '=' (ctx:VxV)
#758: FILE: linux/drivers/media/common/tuners/admtv102.c:713:
+	if(Val_0x3f >= 0x10) CaseNumber=0;
 	                               ^

ERROR: space required before the open parenthesis '('
#758: FILE: linux/drivers/media/common/tuners/admtv102.c:713:
+	if(Val_0x3f >= 0x10) CaseNumber=0;

ERROR: trailing statements should be on next line
#758: FILE: linux/drivers/media/common/tuners/admtv102.c:713:
+	if(Val_0x3f >= 0x10) CaseNumber=0;
+	if(Val_0x3f >= 0x10) CaseNumber=0;
ERROR: that open brace { should be on the previous line
#760: FILE: linux/drivers/media/common/tuners/admtv102.c:715:
+	switch(CaseNumber)
+	{  case 1:  { 

ERROR: space required before the open parenthesis '('
#760: FILE: linux/drivers/media/common/tuners/admtv102.c:715:
+	switch(CaseNumber)

ERROR: trailing whitespace
#761: FILE: linux/drivers/media/common/tuners/admtv102.c:716:
+^I{  case 1:  { $

ERROR: trailing whitespace
#762: FILE: linux/drivers/media/common/tuners/admtv102.c:717:
+^I^I      Coef[0]=-25;  Coef[1]=-1000; Coef[2]=-287; Coef[3]=-11400 ; Coef[4]=-310;  $

WARNING: line over 80 characters
#762: FILE: linux/drivers/media/common/tuners/admtv102.c:717:
+		      Coef[0]=-25;  Coef[1]=-1000; Coef[2]=-287; Coef[3]=-11400 ; Coef[4]=-310;  

ERROR: spaces required around that '=' (ctx:VxO)
#762: FILE: linux/drivers/media/common/tuners/admtv102.c:717:
+		      Coef[0]=-25;  Coef[1]=-1000; Coef[2]=-287; Coef[3]=-11400 ; Coef[4]=-310;  
 		             ^

ERROR: space required before that '-' (ctx:OxV)
#762: FILE: linux/drivers/media/common/tuners/admtv102.c:717:
+		      Coef[0]=-25;  Coef[1]=-1000; Coef[2]=-287; Coef[3]=-11400 ; Coef[4]=-310;  
 		              ^

ERROR: spaces required around that '=' (ctx:VxO)
#762: FILE: linux/drivers/media/common/tuners/admtv102.c:717:
+		      Coef[0]=-25;  Coef[1]=-1000; Coef[2]=-287; Coef[3]=-11400 ; Coef[4]=-310;  
 		                           ^

ERROR: space required before that '-' (ctx:OxV)
#762: FILE: linux/drivers/media/common/tuners/admtv102.c:717:
+		      Coef[0]=-25;  Coef[1]=-1000; Coef[2]=-287; Coef[3]=-11400 ; Coef[4]=-310;  
 		                            ^

ERROR: spaces required around that '=' (ctx:VxO)
#762: FILE: linux/drivers/media/common/tuners/admtv102.c:717:
+		      Coef[0]=-25;  Coef[1]=-1000; Coef[2]=-287; Coef[3]=-11400 ; Coef[4]=-310;  
 		                                          ^

ERROR: space required before that '-' (ctx:OxV)
#762: FILE: linux/drivers/media/common/tuners/admtv102.c:717:
+		      Coef[0]=-25;  Coef[1]=-1000; Coef[2]=-287; Coef[3]=-11400 ; Coef[4]=-310;  
 		                                           ^

ERROR: spaces required around that '=' (ctx:VxO)
#762: FILE: linux/drivers/media/common/tuners/admtv102.c:717:
+		      Coef[0]=-25;  Coef[1]=-1000; Coef[2]=-287; Coef[3]=-11400 ; Coef[4]=-310;  
 		                                                        ^

ERROR: space required before that '-' (ctx:OxV)
#762: FILE: linux/drivers/media/common/tuners/admtv102.c:717:
+		      Coef[0]=-25;  Coef[1]=-1000; Coef[2]=-287; Coef[3]=-11400 ; Coef[4]=-310;  
 		                                                         ^

ERROR: spaces required around that '=' (ctx:VxO)
#762: FILE: linux/drivers/media/common/tuners/admtv102.c:717:
+		      Coef[0]=-25;  Coef[1]=-1000; Coef[2]=-287; Coef[3]=-11400 ; Coef[4]=-310;  
 		                                                                         ^

ERROR: space required before that '-' (ctx:OxV)
#762: FILE: linux/drivers/media/common/tuners/admtv102.c:717:
+		      Coef[0]=-25;  Coef[1]=-1000; Coef[2]=-287; Coef[3]=-11400 ; Coef[4]=-310;  
 		                                                                          ^

WARNING: line over 80 characters
#763: FILE: linux/drivers/media/common/tuners/admtv102.c:718:
+		      BBAGC_Part=((Coef[3]*BBAGC_Part)/8192) + 5016;   // 5016 = Coef[3]*0.44

ERROR: do not use C99 // comments
#763: FILE: linux/drivers/media/common/tuners/admtv102.c:718:
+		      BBAGC_Part=((Coef[3]*BBAGC_Part)/8192) + 5016;   // 5016 = Coef[3]*0.44

ERROR: spaces required around that '=' (ctx:VxV)
#763: FILE: linux/drivers/media/common/tuners/admtv102.c:718:
+		      BBAGC_Part=((Coef[3]*BBAGC_Part)/8192) + 5016;   // 5016 = Coef[3]*0.44
 		                ^

WARNING: line over 80 characters
#764: FILE: linux/drivers/media/common/tuners/admtv102.c:719:
+	              PowerDBValue=Coef[0]*RF_AGC+Coef[1]*LNA_Gain+Coef[2]*(GVBB-5)+BBAGC_Part+Coef[4]+Freq_Comp;

ERROR: code indent should use tabs where possible
#764: FILE: linux/drivers/media/common/tuners/admtv102.c:719:
+^I              PowerDBValue=Coef[0]*RF_AGC+Coef[1]*LNA_Gain+Coef[2]*(GVBB-5)+BBAGC_Part+Coef[4]+Freq_Comp;$

ERROR: spaces required around that '=' (ctx:VxV)
#764: FILE: linux/drivers/media/common/tuners/admtv102.c:719:
+	              PowerDBValue=Coef[0]*RF_AGC+Coef[1]*LNA_Gain+Coef[2]*(GVBB-5)+BBAGC_Part+Coef[4]+Freq_Comp;
 	                          ^

ERROR: code indent should use tabs where possible
#765: FILE: linux/drivers/media/common/tuners/admtv102.c:720:
+^I              break;$

ERROR: trailing whitespace
#767: FILE: linux/drivers/media/common/tuners/admtv102.c:722:
+       case 2:  { $

ERROR: trailing whitespace
#768: FILE: linux/drivers/media/common/tuners/admtv102.c:723:
+^I^I  Coef[0]=-13;  Coef[1]=-752; Coef[2]=214; Coef[3]=1000 ; Coef[4]=886; $

WARNING: line over 80 characters
#768: FILE: linux/drivers/media/common/tuners/admtv102.c:723:
+		  Coef[0]=-13;  Coef[1]=-752; Coef[2]=214; Coef[3]=1000 ; Coef[4]=886; 

ERROR: spaces required around that '=' (ctx:VxO)
#768: FILE: linux/drivers/media/common/tuners/admtv102.c:723:
+		  Coef[0]=-13;  Coef[1]=-752; Coef[2]=214; Coef[3]=1000 ; Coef[4]=886; 
 		         ^

ERROR: space required before that '-' (ctx:OxV)
#768: FILE: linux/drivers/media/common/tuners/admtv102.c:723:
+		  Coef[0]=-13;  Coef[1]=-752; Coef[2]=214; Coef[3]=1000 ; Coef[4]=886; 
 		          ^

ERROR: spaces required around that '=' (ctx:VxO)
#768: FILE: linux/drivers/media/common/tuners/admtv102.c:723:
+		  Coef[0]=-13;  Coef[1]=-752; Coef[2]=214; Coef[3]=1000 ; Coef[4]=886; 
 		                       ^

ERROR: space required before that '-' (ctx:OxV)
#768: FILE: linux/drivers/media/common/tuners/admtv102.c:723:
+		  Coef[0]=-13;  Coef[1]=-752; Coef[2]=214; Coef[3]=1000 ; Coef[4]=886; 
 		                        ^

ERROR: spaces required around that '=' (ctx:VxV)
#768: FILE: linux/drivers/media/common/tuners/admtv102.c:723:
+		  Coef[0]=-13;  Coef[1]=-752; Coef[2]=214; Coef[3]=1000 ; Coef[4]=886; 
 		                                     ^

ERROR: spaces required around that '=' (ctx:VxV)
#768: FILE: linux/drivers/media/common/tuners/admtv102.c:723:
+		  Coef[0]=-13;  Coef[1]=-752; Coef[2]=214; Coef[3]=1000 ; Coef[4]=886; 
 		                                                  ^

ERROR: spaces required around that '=' (ctx:VxV)
#768: FILE: linux/drivers/media/common/tuners/admtv102.c:723:
+		  Coef[0]=-13;  Coef[1]=-752; Coef[2]=214; Coef[3]=1000 ; Coef[4]=886; 
 		                                                                 ^

WARNING: line over 80 characters
#769: FILE: linux/drivers/media/common/tuners/admtv102.c:724:
+		  BBAGC_Part=((Coef[3]*BBAGC_Part)/8192)- 440;   // 440 = Coef[3]*0.44

ERROR: do not use C99 // comments
#769: FILE: linux/drivers/media/common/tuners/admtv102.c:724:
+		  BBAGC_Part=((Coef[3]*BBAGC_Part)/8192)- 440;   // 440 = Coef[3]*0.44

ERROR: spaces required around that '=' (ctx:VxV)
#769: FILE: linux/drivers/media/common/tuners/admtv102.c:724:
+		  BBAGC_Part=((Coef[3]*BBAGC_Part)/8192)- 440;   // 440 = Coef[3]*0.44
 		            ^

ERROR: need consistent spacing around '-' (ctx:VxW)
#769: FILE: linux/drivers/media/common/tuners/admtv102.c:724:
+		  BBAGC_Part=((Coef[3]*BBAGC_Part)/8192)- 440;   // 440 = Coef[3]*0.44
 		                                        ^

WARNING: line over 80 characters
#770: FILE: linux/drivers/media/common/tuners/admtv102.c:725:
+                  PowerDBValue=Coef[0]*RF_AGC+Coef[1]*LNA_Gain+Coef[2]*(GVBB-5)+BBAGC_Part+Coef[4]+Freq_Comp;

ERROR: code indent should use tabs where possible
#770: FILE: linux/drivers/media/common/tuners/admtv102.c:725:
+                  PowerDBValue=Coef[0]*RF_AGC+Coef[1]*LNA_Gain+Coef[2]*(GVBB-5)+BBAGC_Part+Coef[4]+Freq_Comp;$

ERROR: spaces required around that '=' (ctx:VxV)
#770: FILE: linux/drivers/media/common/tuners/admtv102.c:725:
+                  PowerDBValue=Coef[0]*RF_AGC+Coef[1]*LNA_Gain+Coef[2]*(GVBB-5)+BBAGC_Part+Coef[4]+Freq_Comp;
                               ^

ERROR: code indent should use tabs where possible
#771: FILE: linux/drivers/media/common/tuners/admtv102.c:726:
+^I          break;$

ERROR: trailing whitespace
#773: FILE: linux/drivers/media/common/tuners/admtv102.c:728:
+       case 3:  { $

ERROR: trailing whitespace
#774: FILE: linux/drivers/media/common/tuners/admtv102.c:729:
+                  Coef[0]=-12;  Coef[1]=-952; Coef[2]=-347; Coef[3]=-11400 ; Coef[4]=120; $

WARNING: line over 80 characters
#774: FILE: linux/drivers/media/common/tuners/admtv102.c:729:
+                  Coef[0]=-12;  Coef[1]=-952; Coef[2]=-347; Coef[3]=-11400 ; Coef[4]=120; 

ERROR: code indent should use tabs where possible
#774: FILE: linux/drivers/media/common/tuners/admtv102.c:729:
+                  Coef[0]=-12;  Coef[1]=-952; Coef[2]=-347; Coef[3]=-11400 ; Coef[4]=120; $

ERROR: spaces required around that '=' (ctx:VxO)
#774: FILE: linux/drivers/media/common/tuners/admtv102.c:729:
+                  Coef[0]=-12;  Coef[1]=-952; Coef[2]=-347; Coef[3]=-11400 ; Coef[4]=120; 
                          ^

ERROR: space required before that '-' (ctx:OxV)
#774: FILE: linux/drivers/media/common/tuners/admtv102.c:729:
+                  Coef[0]=-12;  Coef[1]=-952; Coef[2]=-347; Coef[3]=-11400 ; Coef[4]=120; 
                           ^

ERROR: spaces required around that '=' (ctx:VxO)
#774: FILE: linux/drivers/media/common/tuners/admtv102.c:729:
+                  Coef[0]=-12;  Coef[1]=-952; Coef[2]=-347; Coef[3]=-11400 ; Coef[4]=120; 
                                        ^

ERROR: space required before that '-' (ctx:OxV)
#774: FILE: linux/drivers/media/common/tuners/admtv102.c:729:
+                  Coef[0]=-12;  Coef[1]=-952; Coef[2]=-347; Coef[3]=-11400 ; Coef[4]=120; 
                                         ^

ERROR: spaces required around that '=' (ctx:VxO)
#774: FILE: linux/drivers/media/common/tuners/admtv102.c:729:
+                  Coef[0]=-12;  Coef[1]=-952; Coef[2]=-347; Coef[3]=-11400 ; Coef[4]=120; 
                                                      ^

ERROR: space required before that '-' (ctx:OxV)
#774: FILE: linux/drivers/media/common/tuners/admtv102.c:729:
+                  Coef[0]=-12;  Coef[1]=-952; Coef[2]=-347; Coef[3]=-11400 ; Coef[4]=120; 
                                                       ^

ERROR: spaces required around that '=' (ctx:VxO)
#774: FILE: linux/drivers/media/common/tuners/admtv102.c:729:
+                  Coef[0]=-12;  Coef[1]=-952; Coef[2]=-347; Coef[3]=-11400 ; Coef[4]=120; 
                                                                    ^

ERROR: space required before that '-' (ctx:OxV)
#774: FILE: linux/drivers/media/common/tuners/admtv102.c:729:
+                  Coef[0]=-12;  Coef[1]=-952; Coef[2]=-347; Coef[3]=-11400 ; Coef[4]=120; 
                                                                     ^

ERROR: spaces required around that '=' (ctx:VxV)
#774: FILE: linux/drivers/media/common/tuners/admtv102.c:729:
+                  Coef[0]=-12;  Coef[1]=-952; Coef[2]=-347; Coef[3]=-11400 ; Coef[4]=120; 
                                                                                     ^

WARNING: line over 80 characters
#775: FILE: linux/drivers/media/common/tuners/admtv102.c:730:
+		  BBAGC_Part=((Coef[3]*BBAGC_Part)/8192) + 5016;   // 502 = Coef[3]*0.44

ERROR: do not use C99 // comments
#775: FILE: linux/drivers/media/common/tuners/admtv102.c:730:
+		  BBAGC_Part=((Coef[3]*BBAGC_Part)/8192) + 5016;   // 502 = Coef[3]*0.44

ERROR: spaces required around that '=' (ctx:VxV)
#775: FILE: linux/drivers/media/common/tuners/admtv102.c:730:
+		  BBAGC_Part=((Coef[3]*BBAGC_Part)/8192) + 5016;   // 502 = Coef[3]*0.44
 		            ^

WARNING: line over 80 characters
#776: FILE: linux/drivers/media/common/tuners/admtv102.c:731:
+	          PowerDBValue=Coef[0]*RF_AGC+Coef[1]*LNA_Gain+Coef[2]*(GVBB-5)+BBAGC_Part+Coef[4]+Freq_Comp;

ERROR: code indent should use tabs where possible
#776: FILE: linux/drivers/media/common/tuners/admtv102.c:731:
+^I          PowerDBValue=Coef[0]*RF_AGC+Coef[1]*LNA_Gain+Coef[2]*(GVBB-5)+BBAGC_Part+Coef[4]+Freq_Comp;$

ERROR: spaces required around that '=' (ctx:VxV)
#776: FILE: linux/drivers/media/common/tuners/admtv102.c:731:
+	          PowerDBValue=Coef[0]*RF_AGC+Coef[1]*LNA_Gain+Coef[2]*(GVBB-5)+BBAGC_Part+Coef[4]+Freq_Comp;
 	                      ^

ERROR: code indent should use tabs where possible
#777: FILE: linux/drivers/media/common/tuners/admtv102.c:732:
+^I          break;$

ERROR: trailing whitespace
#779: FILE: linux/drivers/media/common/tuners/admtv102.c:734:
+       case 4:  { ^I$

ERROR: trailing whitespace
#780: FILE: linux/drivers/media/common/tuners/admtv102.c:735:
+  ^I^I  Coef[0]=-12;  Coef[1]=-1000; Coef[2]=-330; Coef[3]=-11400 ; Coef[4]=70; $

WARNING: line over 80 characters
#780: FILE: linux/drivers/media/common/tuners/admtv102.c:735:
+  		  Coef[0]=-12;  Coef[1]=-1000; Coef[2]=-330; Coef[3]=-11400 ; Coef[4]=70; 

ERROR: code indent should use tabs where possible
#780: FILE: linux/drivers/media/common/tuners/admtv102.c:735:
+  ^I^I  Coef[0]=-12;  Coef[1]=-1000; Coef[2]=-330; Coef[3]=-11400 ; Coef[4]=70; $

ERROR: spaces required around that '=' (ctx:VxO)
#780: FILE: linux/drivers/media/common/tuners/admtv102.c:735:
+  		  Coef[0]=-12;  Coef[1]=-1000; Coef[2]=-330; Coef[3]=-11400 ; Coef[4]=70; 
   		         ^

ERROR: space required before that '-' (ctx:OxV)
#780: FILE: linux/drivers/media/common/tuners/admtv102.c:735:
+  		  Coef[0]=-12;  Coef[1]=-1000; Coef[2]=-330; Coef[3]=-11400 ; Coef[4]=70; 
   		          ^

ERROR: spaces required around that '=' (ctx:VxO)
#780: FILE: linux/drivers/media/common/tuners/admtv102.c:735:
+  		  Coef[0]=-12;  Coef[1]=-1000; Coef[2]=-330; Coef[3]=-11400 ; Coef[4]=70; 
   		                       ^

ERROR: space required before that '-' (ctx:OxV)
#780: FILE: linux/drivers/media/common/tuners/admtv102.c:735:
+  		  Coef[0]=-12;  Coef[1]=-1000; Coef[2]=-330; Coef[3]=-11400 ; Coef[4]=70; 
   		                        ^

ERROR: spaces required around that '=' (ctx:VxO)
#780: FILE: linux/drivers/media/common/tuners/admtv102.c:735:
+  		  Coef[0]=-12;  Coef[1]=-1000; Coef[2]=-330; Coef[3]=-11400 ; Coef[4]=70; 
   		                                      ^

ERROR: space required before that '-' (ctx:OxV)
#780: FILE: linux/drivers/media/common/tuners/admtv102.c:735:
+  		  Coef[0]=-12;  Coef[1]=-1000; Coef[2]=-330; Coef[3]=-11400 ; Coef[4]=70; 
   		                                       ^

ERROR: spaces required around that '=' (ctx:VxO)
#780: FILE: linux/drivers/media/common/tuners/admtv102.c:735:
+  		  Coef[0]=-12;  Coef[1]=-1000; Coef[2]=-330; Coef[3]=-11400 ; Coef[4]=70; 
   		                                                    ^

ERROR: space required before that '-' (ctx:OxV)
#780: FILE: linux/drivers/media/common/tuners/admtv102.c:735:
+  		  Coef[0]=-12;  Coef[1]=-1000; Coef[2]=-330; Coef[3]=-11400 ; Coef[4]=70; 
   		                                                     ^

ERROR: spaces required around that '=' (ctx:VxV)
#780: FILE: linux/drivers/media/common/tuners/admtv102.c:735:
+  		  Coef[0]=-12;  Coef[1]=-1000; Coef[2]=-330; Coef[3]=-11400 ; Coef[4]=70; 
   		                                                                     ^

WARNING: line over 80 characters
#781: FILE: linux/drivers/media/common/tuners/admtv102.c:736:
+		  BBAGC_Part=((Coef[3]*BBAGC_Part)/8192) + 5016;   // 5016 = Coef[3]*0.44

ERROR: do not use C99 // comments
#781: FILE: linux/drivers/media/common/tuners/admtv102.c:736:
+		  BBAGC_Part=((Coef[3]*BBAGC_Part)/8192) + 5016;   // 5016 = Coef[3]*0.44

ERROR: spaces required around that '=' (ctx:VxV)
#781: FILE: linux/drivers/media/common/tuners/admtv102.c:736:
+		  BBAGC_Part=((Coef[3]*BBAGC_Part)/8192) + 5016;   // 5016 = Coef[3]*0.44
 		            ^

ERROR: trailing whitespace
#782: FILE: linux/drivers/media/common/tuners/admtv102.c:737:
+^I          PowerDBValue=Coef[0]*RF_AGC+Coef[1]*LNA_Gain+Coef[2]*(GVBB-5)+BBAGC_Part+Coef[4]+Freq_Comp;             $

WARNING: line over 80 characters
#782: FILE: linux/drivers/media/common/tuners/admtv102.c:737:
+	          PowerDBValue=Coef[0]*RF_AGC+Coef[1]*LNA_Gain+Coef[2]*(GVBB-5)+BBAGC_Part+Coef[4]+Freq_Comp;             

ERROR: code indent should use tabs where possible
#782: FILE: linux/drivers/media/common/tuners/admtv102.c:737:
+^I          PowerDBValue=Coef[0]*RF_AGC+Coef[1]*LNA_Gain+Coef[2]*(GVBB-5)+BBAGC_Part+Coef[4]+Freq_Comp;             $

ERROR: spaces required around that '=' (ctx:VxV)
#782: FILE: linux/drivers/media/common/tuners/admtv102.c:737:
+	          PowerDBValue=Coef[0]*RF_AGC+Coef[1]*LNA_Gain+Coef[2]*(GVBB-5)+BBAGC_Part+Coef[4]+Freq_Comp;             
 	                      ^

ERROR: code indent should use tabs where possible
#783: FILE: linux/drivers/media/common/tuners/admtv102.c:738:
+^I          break;$

ERROR: trailing whitespace
#785: FILE: linux/drivers/media/common/tuners/admtv102.c:740:
+       case 5:  { ^I$

ERROR: trailing whitespace
#786: FILE: linux/drivers/media/common/tuners/admtv102.c:741:
+^I^I  Coef[0]=-12;  $

ERROR: spaces required around that '=' (ctx:VxO)
#786: FILE: linux/drivers/media/common/tuners/admtv102.c:741:
+		  Coef[0]=-12;  
 		         ^

ERROR: space required before that '-' (ctx:OxV)
#786: FILE: linux/drivers/media/common/tuners/admtv102.c:741:
+		  Coef[0]=-12;  
 		          ^

ERROR: trailing whitespace
#787: FILE: linux/drivers/media/common/tuners/admtv102.c:742:
+^I^I  Coef[1]=-952; $

ERROR: spaces required around that '=' (ctx:VxO)
#787: FILE: linux/drivers/media/common/tuners/admtv102.c:742:
+		  Coef[1]=-952; 
 		         ^

ERROR: space required before that '-' (ctx:OxV)
#787: FILE: linux/drivers/media/common/tuners/admtv102.c:742:
+		  Coef[1]=-952; 
 		          ^

ERROR: trailing whitespace
#788: FILE: linux/drivers/media/common/tuners/admtv102.c:743:
+^I^I  Coef[2]=-280; $

ERROR: spaces required around that '=' (ctx:VxO)
#788: FILE: linux/drivers/media/common/tuners/admtv102.c:743:
+		  Coef[2]=-280; 
 		         ^

ERROR: space required before that '-' (ctx:OxV)
#788: FILE: linux/drivers/media/common/tuners/admtv102.c:743:
+		  Coef[2]=-280; 
 		          ^

ERROR: trailing whitespace
#789: FILE: linux/drivers/media/common/tuners/admtv102.c:744:
+^I^I  Coef[3]=-11400 ; $

ERROR: spaces required around that '=' (ctx:VxO)
#789: FILE: linux/drivers/media/common/tuners/admtv102.c:744:
+		  Coef[3]=-11400 ; 
 		         ^

ERROR: space required before that '-' (ctx:OxV)
#789: FILE: linux/drivers/media/common/tuners/admtv102.c:744:
+		  Coef[3]=-11400 ; 
 		          ^

ERROR: trailing whitespace
#790: FILE: linux/drivers/media/common/tuners/admtv102.c:745:
+^I^I  Coef[4]=120; $

ERROR: spaces required around that '=' (ctx:VxV)
#790: FILE: linux/drivers/media/common/tuners/admtv102.c:745:
+		  Coef[4]=120; 
 		         ^

ERROR: trailing whitespace
#791: FILE: linux/drivers/media/common/tuners/admtv102.c:746:
+^I^I  $

WARNING: line over 80 characters
#792: FILE: linux/drivers/media/common/tuners/admtv102.c:747:
+		  BBAGC_Part=((Coef[3]*BBAGC_Part)/8192) + 5016;   // 502 = Coef[3]*0.44

ERROR: do not use C99 // comments
#792: FILE: linux/drivers/media/common/tuners/admtv102.c:747:
+		  BBAGC_Part=((Coef[3]*BBAGC_Part)/8192) + 5016;   // 502 = Coef[3]*0.44

ERROR: spaces required around that '=' (ctx:VxV)
#792: FILE: linux/drivers/media/common/tuners/admtv102.c:747:
+		  BBAGC_Part=((Coef[3]*BBAGC_Part)/8192) + 5016;   // 502 = Coef[3]*0.44
 		            ^

ERROR: do not use C99 // comments
#793: FILE: linux/drivers/media/common/tuners/admtv102.c:748:
+		  // LNA Gail == alway s3 ... (due to case)

ERROR: trailing whitespace
#794: FILE: linux/drivers/media/common/tuners/admtv102.c:749:
+^I^I  // @ 562 => Good:AGC < 290 ,  (GVBB-5) < 5 $

ERROR: do not use C99 // comments
#794: FILE: linux/drivers/media/common/tuners/admtv102.c:749:
+		  // @ 562 => Good:AGC < 290 ,  (GVBB-5) < 5 

ERROR: do not use C99 // comments
#795: FILE: linux/drivers/media/common/tuners/admtv102.c:750:
+		  // @ 602 => Good:AGC < 290 ,  (GVBB-5) < 4

ERROR: trailing whitespace
#796: FILE: linux/drivers/media/common/tuners/admtv102.c:751:
+^I^I  // @ 746 ?? => Good:AGC < 290 ,  (GVBB-5) < 4  * at this freq,  $

WARNING: line over 80 characters
#796: FILE: linux/drivers/media/common/tuners/admtv102.c:751:
+		  // @ 746 ?? => Good:AGC < 290 ,  (GVBB-5) < 4  * at this freq,  

ERROR: do not use C99 // comments
#796: FILE: linux/drivers/media/common/tuners/admtv102.c:751:
+		  // @ 746 ?? => Good:AGC < 290 ,  (GVBB-5) < 4  * at this freq,  

ERROR: trailing whitespace
#797: FILE: linux/drivers/media/common/tuners/admtv102.c:752:
+^I^I  $

ERROR: trailing whitespace
#798: FILE: linux/drivers/media/common/tuners/admtv102.c:753:
+^I^I  $

WARNING: line over 80 characters
#799: FILE: linux/drivers/media/common/tuners/admtv102.c:754:
+		  //printk("(freq=%d) RF_AGC=%d, LNA_Gain=%d, GVBB=%d, BBAGC_Part=%d, Freq_Comp=%d\n",

ERROR: do not use C99 // comments
#799: FILE: linux/drivers/media/common/tuners/admtv102.c:754:
+		  //printk("(freq=%d) RF_AGC=%d, LNA_Gain=%d, GVBB=%d, BBAGC_Part=%d, Freq_Comp=%d\n",

WARNING: line over 80 characters
#800: FILE: linux/drivers/media/common/tuners/admtv102.c:755:
+			//	freq, RF_AGC, LNA_Gain, GVBB-5, BBAGC_Part, Freq_Comp);

ERROR: do not use C99 // comments
#800: FILE: linux/drivers/media/common/tuners/admtv102.c:755:
+			//	freq, RF_AGC, LNA_Gain, GVBB-5, BBAGC_Part, Freq_Comp);

ERROR: trailing whitespace
#801: FILE: linux/drivers/media/common/tuners/admtv102.c:756:
+^I^I  $

ERROR: spaces required around that '=' (ctx:VxW)
#802: FILE: linux/drivers/media/common/tuners/admtv102.c:757:
+		  PowerDBValue=	Coef[0] * RF_AGC +
 		              ^

ERROR: code indent should use tabs where possible
#808: FILE: linux/drivers/media/common/tuners/admtv102.c:763:
+^I          break;$

ERROR: trailing whitespace
#810: FILE: linux/drivers/media/common/tuners/admtv102.c:765:
+       default:  {  ^I$

ERROR: code indent should use tabs where possible
#811: FILE: linux/drivers/media/common/tuners/admtv102.c:766:
+^I          Coef[0]=-12;  Coef[1]=-830; Coef[2]=800;$

ERROR: spaces required around that '=' (ctx:VxO)
#811: FILE: linux/drivers/media/common/tuners/admtv102.c:766:
+	          Coef[0]=-12;  Coef[1]=-830; Coef[2]=800;
 	                 ^

ERROR: space required before that '-' (ctx:OxV)
#811: FILE: linux/drivers/media/common/tuners/admtv102.c:766:
+	          Coef[0]=-12;  Coef[1]=-830; Coef[2]=800;
 	                  ^

ERROR: spaces required around that '=' (ctx:VxO)
#811: FILE: linux/drivers/media/common/tuners/admtv102.c:766:
+	          Coef[0]=-12;  Coef[1]=-830; Coef[2]=800;
 	                               ^

ERROR: space required before that '-' (ctx:OxV)
#811: FILE: linux/drivers/media/common/tuners/admtv102.c:766:
+	          Coef[0]=-12;  Coef[1]=-830; Coef[2]=800;
 	                                ^

ERROR: spaces required around that '=' (ctx:VxV)
#811: FILE: linux/drivers/media/common/tuners/admtv102.c:766:
+	          Coef[0]=-12;  Coef[1]=-830; Coef[2]=800;
 	                                             ^

ERROR: code indent should use tabs where possible
#812: FILE: linux/drivers/media/common/tuners/admtv102.c:767:
+^I          PowerDBValue=RF_AGC*Coef[0]+LNA_Gain*Coef[1] +Coef[2];$

ERROR: spaces required around that '=' (ctx:VxV)
#812: FILE: linux/drivers/media/common/tuners/admtv102.c:767:
+	          PowerDBValue=RF_AGC*Coef[0]+LNA_Gain*Coef[1] +Coef[2];
 	                      ^

ERROR: need consistent spacing around '+' (ctx:WxV)
#812: FILE: linux/drivers/media/common/tuners/admtv102.c:767:
+	          PowerDBValue=RF_AGC*Coef[0]+LNA_Gain*Coef[1] +Coef[2];
 	                                                       ^

ERROR: trailing whitespace
#813: FILE: linux/drivers/media/common/tuners/admtv102.c:768:
+               ^I  BBAGC_Part=  -1000*BBAGC_Part/8192;^I$

ERROR: code indent should use tabs where possible
#813: FILE: linux/drivers/media/common/tuners/admtv102.c:768:
+               ^I  BBAGC_Part=  -1000*BBAGC_Part/8192;^I$

ERROR: spaces required around that '=' (ctx:VxW)
#813: FILE: linux/drivers/media/common/tuners/admtv102.c:768:
+               	  BBAGC_Part=  -1000*BBAGC_Part/8192;	
                	            ^

ERROR: trailing whitespace
#814: FILE: linux/drivers/media/common/tuners/admtv102.c:769:
+^I^I  PowerDBValue=PowerDBValue-300*(GVBB-5)+BBAGC_Part + Freq_Comp;  // for 8934 case $

WARNING: line over 80 characters
#814: FILE: linux/drivers/media/common/tuners/admtv102.c:769:
+		  PowerDBValue=PowerDBValue-300*(GVBB-5)+BBAGC_Part + Freq_Comp;  // for 8934 case 

ERROR: do not use C99 // comments
#814: FILE: linux/drivers/media/common/tuners/admtv102.c:769:
+		  PowerDBValue=PowerDBValue-300*(GVBB-5)+BBAGC_Part + Freq_Comp;  // for 8934 case 

ERROR: spaces required around that '=' (ctx:VxV)
#814: FILE: linux/drivers/media/common/tuners/admtv102.c:769:
+		  PowerDBValue=PowerDBValue-300*(GVBB-5)+BBAGC_Part + Freq_Comp;  // for 8934 case 
 		              ^

ERROR: code indent should use tabs where possible
#815: FILE: linux/drivers/media/common/tuners/admtv102.c:770:
+                  break;$

ERROR: trailing whitespace
#818: FILE: linux/drivers/media/common/tuners/admtv102.c:773:
+^I$

ERROR: return is not a function, parentheses are not required
#819: FILE: linux/drivers/media/common/tuners/admtv102.c:774:
+	return(PowerDBValue);

ERROR: trailing whitespace
#822: FILE: linux/drivers/media/common/tuners/admtv102.c:777:
+ $

ERROR: trailing whitespace
#823: FILE: linux/drivers/media/common/tuners/admtv102.c:778:
+ $

ERROR: trailing whitespace
#824: FILE: linux/drivers/media/common/tuners/admtv102.c:779:
+int TunerRSSICalcAvg(struct admtv102_priv *state, int freq) $

ERROR: trailing whitespace
#826: FILE: linux/drivers/media/common/tuners/admtv102.c:781:
+^I$

ERROR: trailing whitespace
#827: FILE: linux/drivers/media/common/tuners/admtv102.c:782:
+^Iint i,RSSI_val_total=0;^I$

ERROR: space required after that ',' (ctx:VxV)
#827: FILE: linux/drivers/media/common/tuners/admtv102.c:782:
+	int i,RSSI_val_total=0;	
 	     ^

ERROR: spaces required around that '=' (ctx:VxV)
#827: FILE: linux/drivers/media/common/tuners/admtv102.c:782:
+	int i,RSSI_val_total=0;	
 	                    ^

ERROR: that open brace { should be on the previous line
#828: FILE: linux/drivers/media/common/tuners/admtv102.c:783:
+	for(i=0;i<RSSIAveTimes;i++) // measure RSSI for RSSIAveTimes times.
+	{ 

ERROR: do not use C99 // comments
#828: FILE: linux/drivers/media/common/tuners/admtv102.c:783:
+	for(i=0;i<RSSIAveTimes;i++) // measure RSSI for RSSIAveTimes times.

ERROR: spaces required around that '=' (ctx:VxV)
#828: FILE: linux/drivers/media/common/tuners/admtv102.c:783:
+	for(i=0;i<RSSIAveTimes;i++) // measure RSSI for RSSIAveTimes times.
 	     ^

ERROR: space required after that ';' (ctx:VxV)
#828: FILE: linux/drivers/media/common/tuners/admtv102.c:783:
+	for(i=0;i<RSSIAveTimes;i++) // measure RSSI for RSSIAveTimes times.
 	       ^

ERROR: spaces required around that '<' (ctx:VxV)
#828: FILE: linux/drivers/media/common/tuners/admtv102.c:783:
+	for(i=0;i<RSSIAveTimes;i++) // measure RSSI for RSSIAveTimes times.
 	         ^

ERROR: space required after that ';' (ctx:VxV)
#828: FILE: linux/drivers/media/common/tuners/admtv102.c:783:
+	for(i=0;i<RSSIAveTimes;i++) // measure RSSI for RSSIAveTimes times.
 	                      ^

ERROR: space required before the open parenthesis '('
#828: FILE: linux/drivers/media/common/tuners/admtv102.c:783:
+	for(i=0;i<RSSIAveTimes;i++) // measure RSSI for RSSIAveTimes times.

ERROR: trailing statements should be on next line
#828: FILE: linux/drivers/media/common/tuners/admtv102.c:783:
+	for(i=0;i<RSSIAveTimes;i++) // measure RSSI for RSSIAveTimes times.
+	for(i=0;i<RSSIAveTimes;i++) // measure RSSI for RSSIAveTimes times.
ERROR: trailing whitespace
#829: FILE: linux/drivers/media/common/tuners/admtv102.c:784:
+^I{ $

ERROR: trailing whitespace
#830: FILE: linux/drivers/media/common/tuners/admtv102.c:785:
+^I^IRSSI_val_total+= TunerRSSICalc(state, freq);   ^I    $

ERROR: spaces required around that '+=' (ctx:VxW)
#830: FILE: linux/drivers/media/common/tuners/admtv102.c:785:
+		RSSI_val_total+= TunerRSSICalc(state, freq);   	    
 		              ^

ERROR: trailing whitespace
#831: FILE: linux/drivers/media/common/tuners/admtv102.c:786:
+^I     ^I     $

ERROR: trailing whitespace
#832: FILE: linux/drivers/media/common/tuners/admtv102.c:787:
+^I} $

ERROR: trailing whitespace
#838: FILE: linux/drivers/media/common/tuners/admtv102.c:793:
+{  $

ERROR: trailing whitespace
#839: FILE: linux/drivers/media/common/tuners/admtv102.c:794:
+   int TunerI2C_status, DemodI2C_status1, DemodI2C_status2; //record the I2C access status $

WARNING: line over 80 characters
#839: FILE: linux/drivers/media/common/tuners/admtv102.c:794:
+   int TunerI2C_status, DemodI2C_status1, DemodI2C_status2; //record the I2C access status 

ERROR: do not use C99 // comments
#839: FILE: linux/drivers/media/common/tuners/admtv102.c:794:
+   int TunerI2C_status, DemodI2C_status1, DemodI2C_status2; //record the I2C access status 

ERROR: trailing whitespace
#840: FILE: linux/drivers/media/common/tuners/admtv102.c:795:
+   int Tuner_pll_lock, Demod_CALOCK, Demod_AutoDone; //record the bit status $

ERROR: do not use C99 // comments
#840: FILE: linux/drivers/media/common/tuners/admtv102.c:795:
+   int Tuner_pll_lock, Demod_CALOCK, Demod_AutoDone; //record the bit status 

ERROR: trailing whitespace
#841: FILE: linux/drivers/media/common/tuners/admtv102.c:796:
+   int check_mode; $

ERROR: space required after that ',' (ctx:VxV)
#842: FILE: linux/drivers/media/common/tuners/admtv102.c:797:
+   int Tuner0x06Lock,TunerADout;
                     ^

ERROR: trailing whitespace
#844: FILE: linux/drivers/media/common/tuners/admtv102.c:799:
+    $

ERROR: spaces required around that '=' (ctx:VxV)
#845: FILE: linux/drivers/media/common/tuners/admtv102.c:800:
+   TunerI2C_status=DemodI2C_status1=DemodI2C_status2=0;
                   ^

ERROR: spaces required around that '=' (ctx:VxV)
#845: FILE: linux/drivers/media/common/tuners/admtv102.c:800:
+   TunerI2C_status=DemodI2C_status1=DemodI2C_status2=0;
                                    ^

ERROR: spaces required around that '=' (ctx:VxV)
#845: FILE: linux/drivers/media/common/tuners/admtv102.c:800:
+   TunerI2C_status=DemodI2C_status1=DemodI2C_status2=0;
                                                     ^

ERROR: spaces required around that '=' (ctx:VxV)
#846: FILE: linux/drivers/media/common/tuners/admtv102.c:801:
+   Tuner_pll_lock=Demod_CALOCK=Demod_AutoDone=0;
                  ^

ERROR: spaces required around that '=' (ctx:VxV)
#846: FILE: linux/drivers/media/common/tuners/admtv102.c:801:
+   Tuner_pll_lock=Demod_CALOCK=Demod_AutoDone=0;
                               ^

ERROR: spaces required around that '=' (ctx:VxV)
#846: FILE: linux/drivers/media/common/tuners/admtv102.c:801:
+   Tuner_pll_lock=Demod_CALOCK=Demod_AutoDone=0;
                                              ^

ERROR: trailing whitespace
#847: FILE: linux/drivers/media/common/tuners/admtv102.c:802:
+    $

ERROR: spaces required around that '=' (ctx:VxV)
#848: FILE: linux/drivers/media/common/tuners/admtv102.c:803:
+   check_mode=1;
              ^

ERROR: trailing whitespace
#850: FILE: linux/drivers/media/common/tuners/admtv102.c:805:
+   // check if the Tuner PLL is locked or not $

ERROR: do not use C99 // comments
#850: FILE: linux/drivers/media/common/tuners/admtv102.c:805:
+   // check if the Tuner PLL is locked or not 

ERROR: trailing whitespace
#853: FILE: linux/drivers/media/common/tuners/admtv102.c:808:
+^I^ITuner0x06Lock=1; $

ERROR: spaces required around that '=' (ctx:VxV)
#853: FILE: linux/drivers/media/common/tuners/admtv102.c:808:
+		Tuner0x06Lock=1; 
 		             ^

ERROR: trailing whitespace
#855: FILE: linux/drivers/media/common/tuners/admtv102.c:810:
+^I^ITuner0x06Lock=0; $

ERROR: spaces required around that '=' (ctx:VxV)
#855: FILE: linux/drivers/media/common/tuners/admtv102.c:810:
+		Tuner0x06Lock=0; 
 		             ^

ERROR: spaces required around that '=' (ctx:VxV)
#858: FILE: linux/drivers/media/common/tuners/admtv102.c:813:
+	TunerADout=0xff;
 	          ^

WARNING: line over 80 characters
#861: FILE: linux/drivers/media/common/tuners/admtv102.c:816:
+   if ( ( ( TunerADout > TunerADOutMin ) && ( TunerADout < TunerADOutMax ) ) && Tuner0x06Lock )  //pll lock cross check

ERROR: do not use C99 // comments
#861: FILE: linux/drivers/media/common/tuners/admtv102.c:816:
+   if ( ( ( TunerADout > TunerADOutMin ) && ( TunerADout < TunerADOutMax ) ) && Tuner0x06Lock )  //pll lock cross check

ERROR: space prohibited after that open parenthesis '('
#861: FILE: linux/drivers/media/common/tuners/admtv102.c:816:
+   if ( ( ( TunerADout > TunerADOutMin ) && ( TunerADout < TunerADOutMax ) ) && Tuner0x06Lock )  //pll lock cross check

ERROR: space prohibited before that close parenthesis ')'
#861: FILE: linux/drivers/media/common/tuners/admtv102.c:816:
+   if ( ( ( TunerADout > TunerADOutMin ) && ( TunerADout < TunerADOutMax ) ) && Tuner0x06Lock )  //pll lock cross check

ERROR: trailing statements should be on next line
#861: FILE: linux/drivers/media/common/tuners/admtv102.c:816:
+   if ( ( ( TunerADout > TunerADOutMin ) && ( TunerADout < TunerADOutMax ) ) && Tuner0x06Lock )  //pll lock cross check
+   if ( ( ( TunerADout > TunerADOutMin ) && ( TunerADout < TunerADOutMax ) ) && Tuner0x06Lock )  //pll lock cross check
ERROR: spaces required around that '=' (ctx:VxV)
#862: FILE: linux/drivers/media/common/tuners/admtv102.c:817:
+	  Tuner_pll_lock=1;
 	                ^

ERROR: spaces required around that '=' (ctx:VxV)
#863: FILE: linux/drivers/media/common/tuners/admtv102.c:818:
+   else Tuner_pll_lock=0;
                       ^

ERROR: trailing statements should be on next line
#863: FILE: linux/drivers/media/common/tuners/admtv102.c:818:
+   else Tuner_pll_lock=0;

WARNING: line over 80 characters
#870: FILE: linux/drivers/media/common/tuners/admtv102.c:825:
+static int admtv102_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)

ERROR: do not use C99 // comments
#882: FILE: linux/drivers/media/common/tuners/admtv102.c:837:
+	freq = params->frequency / 1000 / 1000; // Hz -> MHz

WARNING: line over 80 characters
#887: FILE: linux/drivers/media/common/tuners/admtv102.c:842:
+		printk("params->u.ofdm.bandwidth = %d\n", params->u.ofdm.bandwidth);

WARNING: printk() should include KERN_ facility level
#887: FILE: linux/drivers/media/common/tuners/admtv102.c:842:
+		printk("params->u.ofdm.bandwidth = %d\n", params->u.ofdm.bandwidth);

ERROR: trailing whitespace
#888: FILE: linux/drivers/media/common/tuners/admtv102.c:843:
+^I$

ERROR: switch and case should be at the same indent
#889: FILE: linux/drivers/media/common/tuners/admtv102.c:844:
+		switch (params->u.ofdm.bandwidth) {
+			case BANDWIDTH_6_MHZ:
[...]
+			case BANDWIDTH_7_MHZ:
[...]
+			case BANDWIDTH_8_MHZ:

ERROR: do not use C99 // comments
#904: FILE: linux/drivers/media/common/tuners/admtv102.c:859:
+	//Waits for pll lock or timeout

WARNING: printk() should include KERN_ facility level
#908: FILE: linux/drivers/media/common/tuners/admtv102.c:863:
+			printk("Tuner PLL Locked\n");

ERROR: spaces required around that '<' (ctx:VxV)
#913: FILE: linux/drivers/media/common/tuners/admtv102.c:868:
+	} while (i<10);
 	          ^

ERROR: trailing whitespace
#939: FILE: linux/drivers/media/common/tuners/admtv102.c:894:
+^ITunerInit(state);  // init Tuner   ^I^I$

ERROR: do not use C99 // comments
#939: FILE: linux/drivers/media/common/tuners/admtv102.c:894:
+	TunerInit(state);  // init Tuner   		

WARNING: line over 80 characters
#974: FILE: linux/drivers/media/common/tuners/admtv102.c:929:
+/* This functions tries to identify a MT2060 tuner by reading the PART/REV register. This is hasty. */

WARNING: line over 80 characters
#975: FILE: linux/drivers/media/common/tuners/admtv102.c:930:
+struct dvb_frontend * admtv102_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct admtv102_config *cfg)

ERROR: "foo * bar" should be "foo *bar"
#975: FILE: linux/drivers/media/common/tuners/admtv102.c:930:
+struct dvb_frontend * admtv102_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct admtv102_config *cfg)

ERROR: space required after that ',' (ctx:VxV)
#990: FILE: linux/drivers/media/common/tuners/admtv102.c:945:
+	if (admtv102_readreg(priv,0,&id) != 0) {
 	                         ^

ERROR: space required after that ',' (ctx:VxO)
#990: FILE: linux/drivers/media/common/tuners/admtv102.c:945:
+	if (admtv102_readreg(priv,0,&id) != 0) {
 	                           ^

ERROR: space required before that '&' (ctx:OxV)
#990: FILE: linux/drivers/media/common/tuners/admtv102.c:945:
+	if (admtv102_readreg(priv,0,&id) != 0) {
 	                            ^

ERROR: do not use C99 // comments
#1001: FILE: linux/drivers/media/common/tuners/admtv102.c:956:
+	//printk(KERN_INFO "ADMTV102: successfully identified (ID = %d)\n", id);

WARNING: line over 80 characters
#1002: FILE: linux/drivers/media/common/tuners/admtv102.c:957:
+	memcpy(&fe->ops.tuner_ops, &admtv102_tuner_ops, sizeof(struct dvb_tuner_ops));

WARNING: line over 80 characters
#1064: FILE: linux/drivers/media/common/tuners/admtv102.h:45:
+#if defined(CONFIG_MEDIA_TUNER_ADMTV102) || (defined(CONFIG_MEDIA_TUNER_ADMTV102_MODULE) && defined(MODULE))

WARNING: line over 80 characters
#1065: FILE: linux/drivers/media/common/tuners/admtv102.h:46:
+extern struct dvb_frontend * admtv102_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct admtv102_config *cfg);

ERROR: "foo * bar" should be "foo *bar"
#1065: FILE: linux/drivers/media/common/tuners/admtv102.h:46:
+extern struct dvb_frontend * admtv102_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct admtv102_config *cfg);

WARNING: line over 80 characters
#1067: FILE: linux/drivers/media/common/tuners/admtv102.h:48:
+static inline struct dvb_frontend * admtv102_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct admtv102_config *cfg)

ERROR: "foo * bar" should be "foo *bar"
#1067: FILE: linux/drivers/media/common/tuners/admtv102.h:48:
+static inline struct dvb_frontend * admtv102_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct admtv102_config *cfg)

ERROR: do not use C99 // comments
#1072: FILE: linux/drivers/media/common/tuners/admtv102.h:53:
+#endif // CONFIG_MEDIA_TUNER_MT2060

WARNING: adding a line without newline at end of file
#1074: FILE: linux/drivers/media/common/tuners/admtv102.h:55:
+#endif

ERROR: trailing whitespace
#1094: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:15:
+#define Tuner_MTV102^I^I0x00 $

ERROR: trailing whitespace
#1095: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:16:
+#define Tuner_ADMTV102^I^I0x01 $

ERROR: trailing whitespace
#1096: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:17:
+#define  Tuner_NewMTV102^I0x02 $

ERROR: trailing whitespace
#1098: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:19:
+#define  VHFSupport               1  // $

ERROR: do not use C99 // comments
#1098: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:19:
+#define  VHFSupport               1  // 

ERROR: trailing whitespace
#1099: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:20:
+#define  UHFSupport               0  // $

ERROR: do not use C99 // comments
#1099: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:20:
+#define  UHFSupport               0  // 

ERROR: trailing whitespace
#1111: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:32:
+#define _EXTUNEOFF   0  $

ERROR: trailing whitespace
#1112: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:33:
+#define _EXTUNEON    1  $

ERROR: trailing whitespace
#1113: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:34:
+#define _TUNEEN      1 $

ERROR: trailing whitespace
#1114: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:35:
+#define _TUNEDIS     0 $

ERROR: trailing whitespace
#1115: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:36:
+#define CTUNEOFS     0x01  //default = 0 ;  $

ERROR: do not use C99 // comments
#1115: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:36:
+#define CTUNEOFS     0x01  //default = 0 ;  

ERROR: trailing whitespace
#1118: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:39:
+#define CTUNE_CLKOFS_SPLIT0F   0x00 // for mass product $

ERROR: do not use C99 // comments
#1118: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:39:
+#define CTUNE_CLKOFS_SPLIT0F   0x00 // for mass product 

ERROR: do not use C99 // comments
#1119: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:40:
+#define REFCLK30400_CLKSEL_REG_SPLITID0E   0x5A   //for split ID is 0x0e

ERROR: do not use C99 // comments
#1120: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:41:
+#define REFCLK30400_CLKSEL_REG_SPLITID0F   0x6A   //for split ID is 0x0f

ERROR: space required after that ',' (ctx:VxV)
#1129: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:50:
+void SetLPF(struct admtv102_priv *state,u32 refClkType,u8 lpfBW);
                                        ^

ERROR: space required after that ',' (ctx:VxV)
#1129: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:50:
+void SetLPF(struct admtv102_priv *state,u32 refClkType,u8 lpfBW);
                                                       ^

ERROR: space required after that ',' (ctx:VxV)
#1132: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:53:
+int   TunerRSSICalc(struct admtv102_priv *state,int freq);
                                                ^

ERROR: space required after that ',' (ctx:VxV)
#1133: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:54:
+int   TunerRSSICalcAvg(struct admtv102_priv *state,int freq);
                                                   ^

ERROR: space required after that ',' (ctx:VxV)
#1134: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:55:
+void dpPhaseTuning(struct admtv102_priv *state,u32 lofreq, u8 temper);
                                               ^

ERROR: space required after that ',' (ctx:VxV)
#1135: FILE: linux/drivers/media/common/tuners/admtv102_priv.h:56:
+void TunerTemperatureComp(struct admtv102_priv *state,long lofreq);
                                                      ^

ERROR: trailing whitespace
#1148: FILE: linux/drivers/media/dvb/dvb-usb/Kconfig:70:
+^Itristate "ASUS U3100 Mini DMB-TH USB Stick" $

WARNING: line over 80 characters
#1177: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:7:
+ *	under the terms of the GNU General Public License as published by the Free

ERROR: do not use C99 // comments
#1194: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:24:
+	printk("u3100dmb_probe");//JHA

WARNING: printk() should include KERN_ facility level
#1194: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:24:
+	printk("u3100dmb_probe");//JHA

WARNING: line over 80 characters
#1195: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:25:
+	return dvb_usb_device_init(intf,&u3100dmb_properties,THIS_MODULE,NULL,adapter_nr);

ERROR: space required after that ',' (ctx:VxO)
#1195: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:25:
+	return dvb_usb_device_init(intf,&u3100dmb_properties,THIS_MODULE,NULL,adapter_nr);
 	                               ^

ERROR: space required before that '&' (ctx:OxV)
#1195: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:25:
+	return dvb_usb_device_init(intf,&u3100dmb_properties,THIS_MODULE,NULL,adapter_nr);
 	                                ^

ERROR: space required after that ',' (ctx:VxV)
#1195: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:25:
+	return dvb_usb_device_init(intf,&u3100dmb_properties,THIS_MODULE,NULL,adapter_nr);
 	                                                    ^

ERROR: space required after that ',' (ctx:VxV)
#1195: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:25:
+	return dvb_usb_device_init(intf,&u3100dmb_properties,THIS_MODULE,NULL,adapter_nr);
 	                                                                ^

ERROR: space required after that ',' (ctx:VxV)
#1195: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:25:
+	return dvb_usb_device_init(intf,&u3100dmb_properties,THIS_MODULE,NULL,adapter_nr);
 	                                                                     ^

ERROR: do not use C99 // comments
#1198: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:28:
+// 20080513, chihming

WARNING: space prohibited between function name and open parenthesis '('
#1199: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:29:
+static int asus_dmbth_identify_state (struct usb_device *udev, struct

WARNING: line over 80 characters
#1200: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:30:
+		dvb_usb_device_properties *props, struct dvb_usb_device_description **desc,

ERROR: need consistent spacing around '*' (ctx:WxV)
#1200: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:30:
+		dvb_usb_device_properties *props, struct dvb_usb_device_description **desc,
 		                          ^

ERROR: do not initialise statics to 0 or NULL
#1204: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:34:
+	static unsigned short int pid=0;

ERROR: spaces required around that '=' (ctx:VxV)
#1204: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:34:
+	static unsigned short int pid=0;
 	                             ^

WARNING: line over 80 characters
#1205: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:35:
+	//printk("%s: iManufacturer => %d, iProduct => 0x%0x\n",__FUNCTION__, udev->descriptor.iManufacturer, udev->descriptor.iProduct);//20080513, chihming

ERROR: do not use C99 // comments
#1205: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:35:
+	//printk("%s: iManufacturer => %d, iProduct => 0x%0x\n",__FUNCTION__, udev->descriptor.iManufacturer, udev->descriptor.iProduct);//20080513, chihming

WARNING: line over 80 characters
#1206: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:36:
+	*cold = udev->descriptor.iManufacturer == 0 && udev->descriptor.iProduct == 0;

ERROR: spaces required around that ':' (ctx:VxV)
#1216: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:46:
+	printk("time_before => %s\n", (*cold) ? "true":"false");
 	                                              ^

ERROR: do not use C99 // comments
#1218: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:48:
+	// 20071103, chihming

WARNING: line over 80 characters
#1220: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:50:
+	//printk("%s: pid => 0x%x, idProduct => 0x%x\n", __FUNCTION__, pid, le16_to_cpu(udev->descriptor.idProduct))

ERROR: do not use C99 // comments
#1220: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:50:
+	//printk("%s: pid => 0x%x, idProduct => 0x%x\n", __FUNCTION__, pid, le16_to_cpu(udev->descriptor.idProduct))

ERROR: that open brace { should be on the previous line
#1221: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:51:
+	if (pid == 0 && (0x1749 == le16_to_cpu(udev->descriptor.idProduct)))
+	{

ERROR: do not use C99 // comments
#1227: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:57:
+			//printk("usb_reset_device1");

ERROR: do not use C99 // comments
#1230: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:60:
+			//printk("usb_reset_device2");

ERROR: do not use C99 // comments
#1233: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:63:
+		//printk("%s\n", __FUNCTION__);

ERROR: do not use C99 // comments
#1236: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:66:
+	//printk("%s: Now pid => 0x%x\n", __FUNCTION__, pid);

ERROR: do not use C99 // comments
#1238: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:68:
+	//

ERROR: do not use C99 // comments
#1246: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:76:
+	#if 1 //20080515, chihming, dont remove

WARNING: line over 80 characters
#1248: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:78:
+		u8 b[3] = { DIBUSB_REQ_SET_IOCTL, DIBUSB_IOCTL_CMD_POWER_MODE, DIBUSB_IOCTL_POWER_WAKEUP };

ERROR: space required after that ',' (ctx:VxV)
#1249: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:79:
+		int ret =  dvb_usb_generic_write(d,b,3);
 		                                  ^

ERROR: space required after that ',' (ctx:VxV)
#1249: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:79:
+		int ret =  dvb_usb_generic_write(d,b,3);
 		                                    ^

WARNING: line over 80 characters
#1250: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:80:
+		printk("dibusb2_0_power_ctrl: ret of dvb_usb_generic_write ==> %d\n", ret);

WARNING: printk() should include KERN_ facility level
#1250: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:80:
+		printk("dibusb2_0_power_ctrl: ret of dvb_usb_generic_write ==> %d\n", ret);

ERROR: do not use C99 // comments
#1252: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:82:
+		//return dvb_usb_generic_write(d,b,3);

WARNING: line over 80 characters
#1279: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:109:
+	if ((adap->fe = dvb_attach(dib3000mc_attach, &adap->dev->i2c_adap, DEFAULT_DIB3000P_I2C_ADDRESS,  &mod3000p_dib3000p_config)) != NULL ||

ERROR: do not use assignment in if condition
#1279: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:109:
+	if ((adap->fe = dvb_attach(dib3000mc_attach, &adap->dev->i2c_adap, DEFAULT_DIB3000P_I2C_ADDRESS,  &mod3000p_dib3000p_config)) != NULL ||

WARNING: line over 80 characters
#1280: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:110:
+		(adap->fe = dvb_attach(dib3000mc_attach, &adap->dev->i2c_adap, DEFAULT_DIB3000MC_I2C_ADDRESS, &mod3000p_dib3000p_config)) != NULL) {

ERROR: trailing whitespace
#1289: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:119:
+^Iif ((adap->fe = $

ERROR: do not use assignment in if condition
#1289: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:119:
+	if ((adap->fe = 

ERROR: trailing whitespace
#1292: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:122:
+^I^I^I&adap->dev->i2c_adap)) $

ERROR: trailing whitespace
#1294: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:124:
+^I^I$

ERROR: do not use C99 // comments
#1307: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:137:
+// 	struct dibusb_state *st = adap->priv;

ERROR: do not use C99 // comments
#1308: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:138:
+// 	struct i2c_adapter *tun_i2c;

ERROR: do not use C99 // comments
#1310: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:140:
+	//tun_i2c = dib3000mc_get_tuner_i2c_master(adap->fe, 1);

WARNING: line over 80 characters
#1311: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:141:
+	//if (dvb_attach(adimtv102_attach, adap->fe, &adap->dev->i2c_adap, &stk3000p_adimtv102_config, if1) == NULL) {

ERROR: do not use C99 // comments
#1311: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:141:
+	//if (dvb_attach(adimtv102_attach, adap->fe, &adap->dev->i2c_adap, &stk3000p_adimtv102_config, if1) == NULL) {

WARNING: line over 80 characters
#1313: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:143:
+	//	if (dvb_attach(dvb_pll_attach, adap->fe, 0x60, tun_i2c, DVB_PLL_ENV57H1XD5) == NULL)

WARNING: suspect code indent for conditional statements (8, 8)
#1313: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:143:
+	//	if (dvb_attach(dvb_pll_attach, adap->fe, 0x60, tun_i2c, DVB_PLL_ENV57H1XD5) == NULL)
+	//		return -ENOMEM;

ERROR: do not use C99 // comments
#1313: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:143:
+	//	if (dvb_attach(dvb_pll_attach, adap->fe, 0x60, tun_i2c, DVB_PLL_ENV57H1XD5) == NULL)

ERROR: do not use C99 // comments
#1314: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:144:
+	//		return -ENOMEM;

ERROR: do not use C99 // comments
#1315: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:145:
+	//} else {

ERROR: do not use C99 // comments
#1316: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:146:
+		//st->mt2060_present = 1;

ERROR: do not use C99 // comments
#1318: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:148:
+		//dib3000mc_set_config(adap->fe, &stk3000p_dib3000p_config); JHA

ERROR: do not use C99 // comments
#1319: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:149:
+	//}

WARNING: line over 80 characters
#1331: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:161:
+	u8 sndbuf[wlen+4+1]; /* lead(1) devaddr,direction(1) addr(2) data(wlen) (len(2) (when reading)) */

ERROR: space required after that ',' (ctx:VxV)
#1340: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:170:
+		memcpy(&sndbuf[2],wbuf,wlen);
 		                 ^

ERROR: space required after that ',' (ctx:VxV)
#1340: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:170:
+		memcpy(&sndbuf[2],wbuf,wlen);
 		                      ^

ERROR: space required after that ',' (ctx:VxV)
#1342: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:172:
+		memcpy(&sndbuf[3],wbuf,wlen);
 		                 ^

ERROR: space required after that ',' (ctx:VxV)
#1342: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:172:
+		memcpy(&sndbuf[3],wbuf,wlen);
 		                      ^

ERROR: do not use C99 // comments
#1348: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:178:
+	//printk("%s: addr %x sb:%x %x %x %x %x %x slen %d \n",__func__,

WARNING: line over 80 characters
#1349: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:179:
+	// addr,sndbuf[0],sndbuf[1], sndbuf[2],sndbuf[3],sndbuf[4],sndbuf[5],len);

ERROR: do not use C99 // comments
#1349: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:179:
+	// addr,sndbuf[0],sndbuf[1], sndbuf[2],sndbuf[3],sndbuf[4],sndbuf[5],len);

ERROR: space required after that ',' (ctx:VxV)
#1350: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:180:
+	return dvb_usb_generic_rw(d,sndbuf,len,rbuf,rlen,0);
 	                           ^

ERROR: space required after that ',' (ctx:VxV)
#1350: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:180:
+	return dvb_usb_generic_rw(d,sndbuf,len,rbuf,rlen,0);
 	                                  ^

ERROR: space required after that ',' (ctx:VxV)
#1350: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:180:
+	return dvb_usb_generic_rw(d,sndbuf,len,rbuf,rlen,0);
 	                                      ^

ERROR: space required after that ',' (ctx:VxV)
#1350: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:180:
+	return dvb_usb_generic_rw(d,sndbuf,len,rbuf,rlen,0);
 	                                           ^

ERROR: space required after that ',' (ctx:VxV)
#1350: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:180:
+	return dvb_usb_generic_rw(d,sndbuf,len,rbuf,rlen,0);
 	                                                ^

WARNING: line over 80 characters
#1356: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:186:
+static int u3100dmb_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msg[],int num)

ERROR: space required after that ',' (ctx:VxV)
#1356: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:186:
+static int u3100dmb_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msg[],int num)
                                                      ^

ERROR: space required after that ',' (ctx:VxV)
#1356: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:186:
+static int u3100dmb_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msg[],int num)
                                                                           ^

ERROR: do not use C99 // comments
#1361: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:191:
+	//printk("dibusb_i2c_xfer: num %x \n",num); //JHA

ERROR: trailing whitespace
#1366: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:196:
+^I^I/* write/read request */^I^I$

WARNING: line over 80 characters
#1368: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:198:
+			if (u3100dmb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,

ERROR: space required after that ',' (ctx:VxV)
#1368: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:198:
+			if (u3100dmb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,
 			                                               ^

ERROR: space required after that ',' (ctx:VxV)
#1369: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:199:
+						msg[i+1].buf,msg[i+1].len) < 0)
 						            ^

WARNING: line over 80 characters
#1373: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:203:
+			if (u3100dmb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,NULL,0) < 0)

ERROR: space required after that ',' (ctx:VxV)
#1373: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:203:
+			if (u3100dmb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,NULL,0) < 0)
 			                                               ^

ERROR: space required after that ',' (ctx:VxV)
#1373: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:203:
+			if (u3100dmb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,NULL,0) < 0)
 			                                                          ^

ERROR: space required after that ',' (ctx:VxV)
#1373: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:203:
+			if (u3100dmb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,NULL,0) < 0)
 			                                                               ^

ERROR: space prohibited before open square bracket '['
#1392: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:222:
+static struct usb_device_id dibusb_u3100dmb_table [] = {

WARNING: line over 80 characters
#1393: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:223:
+/* 0 */  {USB_DEVICE (USB_VID_ASUS,		USB_PID_U3100_8934_COLD) }, //JHA

ERROR: do not use C99 // comments
#1393: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:223:
+/* 0 */  {USB_DEVICE (USB_VID_ASUS,		USB_PID_U3100_8934_COLD) }, //JHA

WARNING: space prohibited between function name and open parenthesis '('
#1393: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:223:
+/* 0 */  {USB_DEVICE (USB_VID_ASUS,		USB_PID_U3100_8934_COLD) }, //JHA

WARNING: line over 80 characters
#1394: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:224:
+/* 1 */  {USB_DEVICE (USB_VID_ASUS,		USB_PID_U3100_8934_WARM) }, //JHA

ERROR: do not use C99 // comments
#1394: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:224:
+/* 1 */  {USB_DEVICE (USB_VID_ASUS,		USB_PID_U3100_8934_WARM) }, //JHA

WARNING: space prohibited between function name and open parenthesis '('
#1394: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:224:
+/* 1 */  {USB_DEVICE (USB_VID_ASUS,		USB_PID_U3100_8934_WARM) }, //JHA

WARNING: line over 80 characters
#1395: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:225:
+/* 2 */  {USB_DEVICE (USB_VID_ASUS,		USB_PID_U3100_8GL5_COLD) }, //JHA

ERROR: do not use C99 // comments
#1395: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:225:
+/* 2 */  {USB_DEVICE (USB_VID_ASUS,		USB_PID_U3100_8GL5_COLD) }, //JHA

WARNING: space prohibited between function name and open parenthesis '('
#1395: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:225:
+/* 2 */  {USB_DEVICE (USB_VID_ASUS,		USB_PID_U3100_8GL5_COLD) }, //JHA

WARNING: line over 80 characters
#1396: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:226:
+/* 3 */  {USB_DEVICE (USB_VID_ASUS,		USB_PID_U3100_8GL5_WARM) }, //JHA

ERROR: do not use C99 // comments
#1396: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:226:
+/* 3 */  {USB_DEVICE (USB_VID_ASUS,		USB_PID_U3100_8GL5_WARM) }, //JHA

WARNING: space prohibited between function name and open parenthesis '('
#1396: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:226:
+/* 3 */  {USB_DEVICE (USB_VID_ASUS,		USB_PID_U3100_8GL5_WARM) }, //JHA

WARNING: space prohibited between function name and open parenthesis '('
#1399: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:229:
+MODULE_DEVICE_TABLE (usb, dibusb_u3100dmb_table);

WARNING: line over 80 characters
#1410: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:240:
+			.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,

ERROR: do not use C99 // comments
#1432: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:262:
+	.identify_state   = asus_dmbth_identify_state, // 20080513, chihming

ERROR: do not use C99 // comments
#1448: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:278:
+		//{,JHA

ERROR: code indent should use tabs where possible
#1450: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:280:
+ ^I^I^I{ &dibusb_u3100dmb_table[0], NULL },$

ERROR: code indent should use tabs where possible
#1451: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:281:
+ ^I^I^I{ &dibusb_u3100dmb_table[1], NULL },$

ERROR: code indent should use tabs where possible
#1452: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:282:
+ ^I^I},$

ERROR: code indent should use tabs where possible
#1454: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:284:
+ ^I^I^I{ &dibusb_u3100dmb_table[2], NULL },$

ERROR: code indent should use tabs where possible
#1455: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:285:
+ ^I^I^I{ &dibusb_u3100dmb_table[3], NULL },$

ERROR: code indent should use tabs where possible
#1456: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:286:
+ ^I^I},$

ERROR: do not use C99 // comments
#1457: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:287:
+		//},JHA

ERROR: do not use assignment in if condition
#1476: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:306:
+	if ((result = usb_register(&u3100dmb_driver))) {

ERROR: space required after that ',' (ctx:VxV)
#1477: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:307:
+		err("usb_register failed. Error number %d",result);
 		                                          ^

WARNING: space prohibited between function name and open parenthesis '('
#1490: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:320:
+module_init (u3100dmb_module_init);

WARNING: space prohibited between function name and open parenthesis '('
#1491: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:321:
+module_exit (u3100dmb_module_exit);

WARNING: line over 80 characters
#1494: FILE: linux/drivers/media/dvb/dvb-usb/dibusb-u3100dmb.c:324:
+MODULE_DESCRIPTION("Driver for DiBcom USB2.0 DVB-T (DiB3000M-C/P based) devices");

ERROR: trailing whitespace
#1506: FILE: linux/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c:129:
+^I// added??? to fix something - ak based on diff..^I$

ERROR: do not use C99 // comments
#1506: FILE: linux/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c:129:
+	// added??? to fix something - ak based on diff..	

ERROR: space prohibited after that open parenthesis '('
#1507: FILE: linux/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c:130:
+	hx->addr = le16_to_cpu( *((u16 *) &b[1]) );

ERROR: space prohibited before that close parenthesis ')'
#1507: FILE: linux/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c:130:
+	hx->addr = le16_to_cpu( *((u16 *) &b[1]) );

ERROR: do not use C99 // comments
#1508: FILE: linux/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c:131:
+	//hx->addr = b[1] | (b[2] << 8);

ERROR: trailing whitespace
#1534: FILE: linux/drivers/media/dvb/dvb-usb/dvb-usb-urb.c:11:
+int usb_bulk_msg2(struct usb_device *usb_dev, unsigned int pipe, $

ERROR: do not use C99 // comments
#1543: FILE: linux/drivers/media/dvb/dvb-usb/dvb-usb-urb.c:20:
+	// modify the intervall. to match the old spec...

ERROR: trailing whitespace
#1550: FILE: linux/drivers/media/dvb/dvb-usb/dvb-usb-urb.c:27:
+^I $

ERROR: space required after that ',' (ctx:VxV)
#1560: FILE: linux/drivers/media/dvb/dvb-usb/dvb-usb-urb.c:61:
+		ret = usb_bulk_msg2(d->udev,usb_rcvbulkpipe(d->udev,
 		                           ^

WARNING: line over 80 characters
#1561: FILE: linux/drivers/media/dvb/dvb-usb/dvb-usb-urb.c:62:
+				d->props.generic_bulk_ctrl_endpoint),rbuf,rlen,&actlen,

ERROR: space required after that ',' (ctx:VxV)
#1561: FILE: linux/drivers/media/dvb/dvb-usb/dvb-usb-urb.c:62:
+				d->props.generic_bulk_ctrl_endpoint),rbuf,rlen,&actlen,
 				                                    ^

ERROR: space required after that ',' (ctx:VxV)
#1561: FILE: linux/drivers/media/dvb/dvb-usb/dvb-usb-urb.c:62:
+				d->props.generic_bulk_ctrl_endpoint),rbuf,rlen,&actlen,
 				                                         ^

ERROR: space required after that ',' (ctx:VxO)
#1561: FILE: linux/drivers/media/dvb/dvb-usb/dvb-usb-urb.c:62:
+				d->props.generic_bulk_ctrl_endpoint),rbuf,rlen,&actlen,
 				                                              ^

ERROR: space required before that '&' (ctx:OxV)
#1561: FILE: linux/drivers/media/dvb/dvb-usb/dvb-usb-urb.c:62:
+				d->props.generic_bulk_ctrl_endpoint),rbuf,rlen,&actlen,
 				                                               ^

ERROR: do not initialise statics to 0 or NULL
#1648: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:43:
+static int debug = 0;

WARNING: printk() should include KERN_ facility level
#1702: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:97:
+		printk("%s: reg=0x%02X, data=0x%02X\n", __func__, reg, b1[0]);

ERROR: do not use C99 // comments
#1721: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:116:
+	if_conf = 0x10; // AGC output on;

ERROR: spaces required around that ':' (ctx:VxV)
#1724: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:119:
+		((config->ext_adc) ? 0x80:0x00) |
 		                         ^

ERROR: spaces required around that ':' (ctx:VxV)
#1725: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:120:
+		((config->if_neg_center) ? 0x04:0x00) |
 		                               ^

ERROR: spaces required around that ':' (ctx:VxV)
#1726: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:121:
+		((config->if_freq == 0) ? 0x08:0x00) | /* Baseband */
 		                              ^

ERROR: spaces required around that ':' (ctx:VxV)
#1727: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:122:
+		((config->ext_adc && config->adc_signed) ? 0x02:0x00) |
 		                                               ^

ERROR: spaces required around that ':' (ctx:VxV)
#1728: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:123:
+		((config->ext_adc && config->if_neg_edge) ? 0x01:0x00);
 		                                                ^

WARNING: braces {} are not necessary for single statement blocks
#1773: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:168:
+	if (priv->config->prod == LGS8GXX_PROD_LGS8913) {
+		lgs8gxx_write_reg(priv, 0xC6, 0x01);
+	}

ERROR: do not use C99 // comments
#1780: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:175:
+	// clear FEC self reset

WARNING: braces {} are not necessary for single statement blocks
#1801: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:196:
+	if (priv->config->prod == LGS8GXX_PROD_LGS8G52) {
+		lgs8gxx_write_reg(priv, 0xD9, 0x40);
+	}

ERROR: trailing whitespace
#1857: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:252:
+^Iint err; $

ERROR: space required after that ',' (ctx:VxV)
#1884: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:279:
+	int i,j;
 	     ^

ERROR: spaces required around that '=' (ctx:WxV)
#1895: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:290:
+		for (j =0 ; j < 2; j++) {
 		       ^

ERROR: trailing statements should be on next line
#1898: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:293:
+			if (err) goto out;
+			if (err) goto out;
ERROR: trailing statements should be on next line
#1899: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:294:
+			if (locked) goto locked;
+			if (locked) goto locked;
ERROR: spaces required around that '=' (ctx:WxV)
#1901: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:296:
+		for (j =0 ; j < 2; j++) {
 		       ^

ERROR: trailing statements should be on next line
#1904: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:299:
+			if (err) goto out;
+			if (err) goto out;
ERROR: trailing statements should be on next line
#1905: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:300:
+			if (locked) goto locked;
+			if (locked) goto locked;
ERROR: trailing statements should be on next line
#1909: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:304:
+		if (err) goto out;
+		if (err) goto out;
ERROR: trailing statements should be on next line
#1910: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:305:
+		if (locked) goto locked;
+		if (locked) goto locked;
ERROR: do not use C99 // comments
#1938: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:333:
+	//u8 ctrl_frame = 0, mode = 0, rate = 0;

ERROR: trailing whitespace
#1952: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:347:
+^I$

WARNING: braces {} are not necessary for single statement blocks
#1961: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:356:
+	if (priv->config->prod == LGS8GXX_PROD_LGS8913) {
+		lgs8gxx_write_reg(priv, 0xC0, detected_param);
+	}

ERROR: do not use C99 // comments
#1964: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:359:
+	//lgs8gxx_soft_reset(priv);

WARNING: suspect code indent for conditional statements (8, 8)
#1969: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:364:
+	if (gi == 0x2)
+	switch(gi) {

ERROR: space required before the open parenthesis '('
#1970: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:365:
+	switch(gi) {

ERROR: trailing whitespace
#2024: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:419:
+^Ilgs8gxx_write_reg(priv, 0x2C, 0); $

WARNING: line over 80 characters
#2034: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:429:
+	struct lgs8gxx_state *priv = (struct lgs8gxx_state *)fe->demodulator_priv;

WARNING: braces {} are not necessary for single statement blocks
#2050: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:445:
+	if (config->prod == LGS8GXX_PROD_LGS8913) {
+		lgs8913_init(priv);
+	}

WARNING: suspect code indent for conditional statements (8, 8)
#2107: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:502:
+	if ((fe_params->u.ofdm.code_rate_HP == FEC_AUTO) ||
[...]
+	} else {

ERROR: space required before the open parenthesis '('
#2186: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:581:
+	switch(t & LGS_FEC_MASK) {

ERROR: space required before the open parenthesis '('
#2203: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:598:
+	switch(t & SC_MASK) {

WARNING: line over 80 characters
#2264: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:659:
+			*fe_status |= FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;

ERROR: trailing whitespace
#2281: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:676:
+^Idprintk("%s()\n", __func__);^I$

ERROR: space prohibited before that close parenthesis ')'
#2291: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:686:
+	if (v < 0x100 )

ERROR: trailing whitespace
#2305: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:700:
+^I^I$

ERROR: trailing whitespace
#2375: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:770:
+^I$

ERROR: "foo* bar" should be "foo *bar"
#2422: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:817:
+static int lgs8gxx_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)

WARNING: braces {} are not necessary for any arm of this statement
#2428: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:823:
+	if (enable) {
[...]
+	} else {
[...]

WARNING: line over 80 characters
#2429: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:824:
+		return lgs8gxx_write_reg(priv, 0x01, 0x80 | priv->config->tuner_address);

ERROR: do not use C99 // comments
#2453: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:848:
+	//.sleep = lgs8gxx_sleep,

ERROR: space required after that ',' (ctx:VxV)
#2474: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:869:
+	dprintk("%s()\n",__func__);
 	                ^

ERROR: trailing whitespace
#2668: FILE: linux/drivers/media/dvb/frontends/lgs8gxx_priv.h:58:
+#define GI_595^I0x01^I$

total: 516 errors, 115 warnings, 2599 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

