Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm1.telefonica.net ([213.4.138.17]:47292 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751471Ab1GWI1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2011 04:27:10 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] add support for the dvb-t part of CT-3650 v3
Date: Sat, 23 Jul 2011 10:26:56 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
References: <201106070205.08118.jareguero@telefonica.net> <201107222349.22717.jareguero@telefonica.net> <4E29F849.2040808@iki.fi>
In-Reply-To: <4E29F849.2040808@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107231026.57485.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sábado, 23 de Julio de 2011 00:23:05 Antti Palosaari escribió:
> On 07/23/2011 12:49 AM, Jose Alberto Reguero wrote:
> > On Viernes, 22 de Julio de 2011 20:12:20 Jose Alberto Reguero escribió:
> >> On Viernes, 22 de Julio de 2011 18:46:24 Antti Palosaari escribió:
> >>> On 07/22/2011 07:25 PM, Jose Alberto Reguero wrote:
> >>>> On Viernes, 22 de Julio de 2011 18:08:39 Antti Palosaari escribió:
> >>>>> On 07/22/2011 07:02 PM, Jose Alberto Reguero wrote:
> >>>>>> On Viernes, 22 de Julio de 2011 13:32:53 Antti Palosaari escribió:
> >>>>>>> Have you had to time test these?
> >>>>>>> 
> >>>>>>> And about I2C adapter, I don't see why changes are needed. As far
> >>>>>>> as I understand it is already working with TDA10023 and you have
> >>>>>>> done changes for TDA10048 support. I compared TDA10048 and
> >>>>>>> TDA10023 I2C functions and those are ~similar. Both uses most
> >>>>>>> typical access, for reg write {u8 REG, u8 VAL} and for reg read
> >>>>>>> {u8 REG}/{u8 VAL}.
> >>>>>>> 
> >>>>>>> regards
> >>>>>>> Antti
> >>>>>> 
> >>>>>> I just finish the testing. The changes to I2C are for the tuner
> >>>>>> tda827x. The MFE fork fine. I need to change the code in tda10048
> >>>>>> and ttusb2. Attached is the patch for CT-3650 with your MFE patch.
> >>>>> 
> >>>>> You still pass tda10023 fe pointer to tda10048 for I2C-gate control
> >>>>> which is wrong. Could you send USB sniff I can look what there really
> >>>>> happens. If you have raw SniffUSB2 logs I wish to check those, other
> >>>>> logs are welcome too if no raw SniffUSB2 available.
> >>>> 
> >>>> Youre chnage don't work. You need to change the function i2c gate of
> >>>> tda1048 for the one of tda1023, but the parameter of this function
> >>>> must be the fe pointer of tda1023. If this is a problem, I can
> >>>> duplicate tda1023 i2c gate in ttusb2 code and pass it to the
> >>>> tda10048. It is done this way in the first patch of this thread.
> >>> 
> >>> Yes I now see why it cannot work - since FE is given as a parameter to
> >>> i2c_gate_ctrl it does not see correct priv and used I2C addr is read
> >>> from priv. You must implement own i2c_gate_ctrl in ttusb2 driver.
> >>> Implement own ct3650_i2c_gate_ctrl and override tda10048 i2c_gate_ctrl
> >>> using that. Then call tda10023 i2c_gate_ctrl but instead of tda10048 FE
> >>> use td10023 FE. Something like
> >>> 
> >>> static int ct3650_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
> >>> {
> >>> 
> >>> 	return adap->mfe[0]->ops.i2c_gate_ctrl(POINTER_TO_TDA10023_FE,
> >>> 	enable);
> >>> 
> >>> }
> >>> 
> >>> /* tuner is behind TDA10023 I2C-gate */
> >>> adap->mfe[1]->ops.i2c_gate_ctrl = ct3650_i2c_gate_ctrl;
> >>> 
> >>> 
> >>> Could you still send USB logs? I don't see it correct behaviour you
> >>> need to change I2C-adaper when same tuner is used for DVB-T because it
> >>> was already working in DVB-C mode.
> >>> 
> >>> regards
> >>> Antti
> >> 
> >> Thanks, I try to implement that. I attach a processed log. It prints the
> >> first line of a usb command and the first line of the returned byes. If
> >> you want the full log I can upload it where you want.
> >> 
> >> Jose Alberto
> > 
> > New version with Antti's sugestion.
> 
> GOOD! As you can see implementing things correctly drops also much lines
> of code! No more ugly hacks in TDA10048 driver.
> 
> But now you must fix that I2C-adapter. I looked sniffs and tda827x
> driver. I2C is rather clear. tda827x uses a little bit unusual I2C read.
> Normally reads are done as I2C write+read combination, that tuner, as
> many other NXP tuners, uses only single read and it is starting always
> from reg "0".
> 
> It looked for my eyes that it will never do read operation as in read
> there is num = 1, msg[0].flags = I2C_M_RD
> 
> ttusb2_i2c_xfer():
> 	for (i = 0; i < num; i++) {
> 		read = i+1 < num && (msg[i+1].flags & I2C_M_RD);
> 
> But in the case it have been working for DVB-C I don't understand why it
> does not work for DVB-T. And thus I really suspect your changes to
> I2C-adapter are not needed. So whats the problem using original I2C
> adapter? What does it print when debugs are enabled. Is there some
> errors in log?
> 
> Also looking from sniffs, it seems that this could be wrong:
> 		(rlen > 0 && r[3] != rlen)) {
> 		warn("there might have been an error during control message 
transfer.
> (rlen = %d, was %d)",rlen,r[3]);
> 
> 
> regards
> Antti

The problem is in i2c read in tda827x_probe_version. Without the fix sometimes, 
when changing the code the tuner is detected as  tda827xo instead of tda827xa. 
That is because the variable where i2c read should store the value is 
initialized, and sometimes it works.

Jose Alberto
