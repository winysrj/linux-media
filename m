Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:57524 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab0HPNKA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Aug 2010 09:10:00 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OkzRs-00065s-0U
	for linux-media@vger.kernel.org; Mon, 16 Aug 2010 15:09:56 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 16 Aug 2010 15:09:55 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 16 Aug 2010 15:09:55 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: saa7146 and tda100123 print debug messages at an inappropriate KERN_WARNING/KERN_ERR level
Date: Mon, 16 Aug 2010 15:09:43 +0200
Message-ID: <878w46emaw.fsf@nemi.mork.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello,

I do from time to time manage to hang my system in a way where IO-APIC
interrupt processing halts.  This is probably not related to V4L/DVB.

In this situation, the saa7146 and tda10023 will of course fail (cannot
blame them for that), and this failure makes them fill the console with
pointless debug messages.  Which I do blame them for, and is what I'd
like to avoid.


A typical example of such log messages:

Aug 14 08:04:24 canardo kernel: [33080.584008] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33080.612006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33080.640005] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33080.656005] DVB: TDA10023(1): tda10023_writereg, writereg error (reg == 0x00, val == 0x32, ret == -5)
Aug 14 08:04:24 canardo kernel: [33080.668007] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33080.696008] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33080.724018] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33080.752013] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33080.768008] DVB: TDA10023(1): tda10023_writereg, writereg error (reg == 0x00, val == 0x33, ret == -5)
Aug 14 08:04:24 canardo kernel: [33080.780007] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33080.808009] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33080.836005] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33080.864005] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33080.880005] DVB: TDA10023(1): tda10023_readreg: readreg error (reg == 0x11, ret == -5)
Aug 14 08:04:24 canardo kernel: [33080.892006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33080.920008] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33080.948006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33080.976006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33080.992041] DVB: TDA10023(1): tda10023_readreg: readreg error (reg == 0x11, ret == -5)
Aug 14 08:04:24 canardo kernel: [33081.004005] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33081.032009] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33081.060006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33081.088006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33081.104004] tda10023: lock tuner fails
Aug 14 08:04:24 canardo kernel: [33081.116007] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33081.144007] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33081.172007] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33081.200006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33081.228006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33081.256008] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33081.284006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33081.312008] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33081.328004] tda10023: unlock tuner fails
Aug 14 08:04:24 canardo kernel: [33081.340006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33081.368008] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33081.396006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33081.424005] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Aug 14 08:04:24 canardo kernel: [33081.440026] DVB: TDA10023(1): tda10023_readreg: readreg error (reg == 0x03, ret == -5)
Aug 14 08:04:24 canardo kernel: [33081.452006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
[continued forever at the same rate]


These useless debug messages obscure any relevant error messages, and
they do make further system debugging unnecessary difficult by keeping
the console occupied (I use a serial console at 9600 bps, so it can't
really handle this).

Yes, I can change the loglevel, but my point is that I should not have
to.  Other drivers print important messages at the KERN_WARNING level.

I briefly looked at saa7146_i2c.c, and I believe the printk's at
KERN_WARNING in saa7146_i2c_writeout() should be completely removed.  Or
at least be replaced by DEB_I2C() macro calls.  It does make any sense
that saa7146_i2c_transfer() silently calls saa7146_i2c_writeout()
repeatedly, while the latter will print a warning for every repeated
call (typically 4 times when called by tda10023).


And the tda10023 printk's at KERN_ERR level might have been appropriate
if the module had managed to kill further processing at this point
(i.e. managing to signal an error to its users). But since it doesn't,
then KERN_ERR is far above the acceptable printk level.  The above
output is debugging messages, and I'd like to keep them away from my
console.

Let me know if patches are welcome and I will prepare one for each
driver.


Bjørn

