Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:53271 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751507Ab2LTVhb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Dec 2012 16:37:31 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: AverMedia Satelllite Hybrid+FM A706
Date: Thu, 20 Dec 2012 22:37:11 +0100
Cc: linux-media@vger.kernel.org
References: <201212182245.50722.linux@rainbow-software.org>
In-Reply-To: <201212182245.50722.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201212202237.12376.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update:
GPIO 9 is CE6313 SLEEP signal
GPIO 23 is CE5039 SLEEP signal
GPIO 25 is CE6313 RESET# signal - this one needs to be set high for CE6313 to 
appear on I2C bus

But there is a problem with CE5039 (zl10039) - the I2C bus breaks during its 
initialization (SDA stuck low):

Here it works (communication with CE6313):
[  921.556682] start xfer
[  921.556684] send address
[  921.556687] saa7133[0]: i2c data => 0x1c
[  921.556690] saa7133[0]: i2c stat <= BUSY
[  921.556725] saa7133[0]: i2c stat <= BUSY
[  921.556759] saa7133[0]: i2c stat <= BUSY
[  921.556794] saa7133[0]: i2c stat <= BUSY
[  921.556828] saa7133[0]: i2c stat <= DONE_WRITE
[  921.556831] saa7133[0]: i2c stat <= DONE_WRITE
[  921.556833] write bytes
[  921.556836] saa7133[0]: i2c data => 0x14
[  921.556838] saa7133[0]: i2c stat <= BUSY
[  921.556873] saa7133[0]: i2c stat <= BUSY
[  921.556907] saa7133[0]: i2c stat <= BUSY
[  921.556942] saa7133[0]: i2c stat <= DONE_WRITE
[  921.556945] saa7133[0]: i2c stat <= DONE_WRITE
[  921.556948] saa7133[0]: i2c data => 0x40
[  921.556950] saa7133[0]: i2c stat <= BUSY
[  921.556985] saa7133[0]: i2c stat <= BUSY
[  921.557019] saa7133[0]: i2c stat <= BUSY
[  921.557054] saa7133[0]: i2c stat <= DONE_WRITE
[  921.557057] saa7133[0]: i2c stat <= DONE_WRITE
[  921.557058] xfer done
[  921.557060] saa7133[0]: i2c attr => STOP
[  921.557064] saa7133[0]: i2c stat <= BUSY
[  921.557098] saa7133[0]: i2c stat <= DONE_STOP
[  921.557101] saa7133[0]: i2c stat <= DONE_STOP

Here starts CE5039 communication:
[  921.564672] zl10039_read
[  921.564677] saa7133[0]: i2c stat <= DONE_STOP
[  921.564679] start xfer
[  921.564681] send address
[  921.564684] saa7133[0]: i2c data => 0xc0
[  921.564686] saa7133[0]: i2c stat <= BUSY
[  921.564721] saa7133[0]: i2c stat <= BUSY
[  921.564755] saa7133[0]: i2c stat <= BUSY
[  921.564790] saa7133[0]: i2c stat <= BUSY

And here it breaks:
[  921.564824] saa7133[0]: i2c stat <= ARB_LOST
[  921.564827] saa7133[0]: i2c stat <= ARB_LOST
[  921.564829] zl10039_read: i2c read error
[  921.564833] saa7133[0]: i2c stat <= ARB_LOST
[  921.564834] saa7133[0]: i2c reset
[  921.564837] saa7133[0]: i2c stat <= ARB_LOST
[  921.564839] saa7133[0]: i2c stat => ARB_LOST
[  921.564843] saa7133[0]: i2c stat <= ARB_LOST
[  921.564877] saa7133[0]: i2c stat <= IDLE
[  921.564879] saa7133[0]: i2c attr => NOP

And everything is broken now (until reloading saa7134 module):
[  921.564882] start xfer
[  921.564883] send address
[  921.564886] saa7133[0]: i2c data => 0x1c
[  921.564889] saa7133[0]: i2c stat <= BUSY
[  921.564923] saa7133[0]: i2c stat <= BUSY
[  921.564958] saa7133[0]: i2c stat <= BUSY
[  921.564992] saa7133[0]: i2c stat <= BUSY
[  921.565026] saa7133[0]: i2c stat <= BUSY
[  921.565061] saa7133[0]: i2c stat <= BUSY
[  921.565095] saa7133[0]: i2c stat <= BUSY
[  921.565130] saa7133[0]: i2c stat <= BUSY
[  921.565164] saa7133[0]: i2c stat <= BUSY
[  921.565199] saa7133[0]: i2c stat <= BUSY
[  921.565233] saa7133[0]: i2c stat <= BUSY
[  921.565268] saa7133[0]: i2c stat <= BUSY
[  921.565302] saa7133[0]: i2c stat <= BUSY
[  921.565336] saa7133[0]: i2c stat <= BUSY
[  921.565371] saa7133[0]: i2c stat <= BUSY
[  921.565405] saa7133[0]: i2c stat <= BUSY
[  921.565440] mt312_read: ret == -5
[  921.565450] saa7133[0]/dvb: dvb_init: No zl10039 found!



-- 
Ondrej Zary
