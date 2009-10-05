Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:56480 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbZJEJEv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2009 05:04:51 -0400
Date: Mon, 5 Oct 2009 11:04:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
Cc: Andy Walls <awalls@radix.net>, Jarod Wilson <jarod@wilsonet.com>,
	linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV
 M116 for newer kernels
Message-ID: <20091005110402.059e9830@hyperion.delvare>
In-Reply-To: <20091005085031.GA17431@moon>
References: <1254584660.3169.25.camel@palomino.walls.org>
	<20091004222347.GA31609@moon>
	<1254707677.9896.10.camel@palomino.walls.org>
	<20091005085031.GA17431@moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 5 Oct 2009 11:50:31 +0300, Aleksandr V. Piskunov wrote:
> > Try:
> > 
> > # modprobe ivtv newi2c=1
> > 
> > to see if that works first. 
> > 
> 
> udelay=10, newi2c=0  => BAD
> udelay=10, newi2c=1  => BAD
> udelay=5,  newi2c=0  => OK
> udelay=5,  newi2c=1  => BAD

The udelay value is only used by i2c-algo-bit, not newi2c, so the last
test was not needed.

> newi2c=1 also throws some log messages, not sure if its ok or not.
> 
> Oct  5 11:41:16 moon kernel: [45430.916449] ivtv: Start initialization, version 1.4.1
> Oct  5 11:41:16 moon kernel: [45430.916618] ivtv0: Initializing card 0
> Oct  5 11:41:16 moon kernel: [45430.916628] ivtv0: Autodetected AVerTV MCE 116 Plus card (cx23416 based)
> Oct  5 11:41:16 moon kernel: [45430.918887] ivtv 0000:03:06.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> Oct  5 11:41:16 moon kernel: [45430.919229] ivtv0:  i2c: i2c init
> Oct  5 11:41:16 moon kernel: [45430.919234] ivtv0:  i2c: setting scl and sda to 1
> Oct  5 11:41:16 moon kernel: [45430.937745] cx25840 0-0044: cx25843-23 found @ 0x88 (ivtv i2c driver #0)
> Oct  5 11:41:16 moon kernel: [45430.949145] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45430.951628] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45430.954191] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45430.956724] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45430.959211] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45430.961749] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45430.964236] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45430.966722] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45430.966786] ivtv0:  i2c: i2c write to 43 failed
> Oct  5 11:41:16 moon kernel: [45430.971106] tuner 0-0061: chip found @ 0xc2 (ivtv i2c driver #0)
> Oct  5 11:41:16 moon kernel: [45430.974404] wm8739 0-001a: chip found @ 0x34 (ivtv i2c driver #0)
> Oct  5 11:41:16 moon kernel: [45430.986328] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45430.988871] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45430.991355] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45430.993904] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45430.996427] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45430.998938] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45431.001477] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45431.003968] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45431.004053] ivtv0:  i2c: i2c write to 18 failed
> Oct  5 11:41:16 moon kernel: [45431.011333] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45431.013883] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45431.016418] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45431.018911] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45431.021463] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45431.023937] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45431.026478] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45431.028998] ivtv0:  i2c: Slave did not ack
> Oct  5 11:41:16 moon kernel: [45431.029063] ivtv0:  i2c: i2c write to 71 failed
> Oct  5 11:41:16 moon kernel: [45431.031468] ivtv0:  i2c: Slave did not ack
> ....

That would be I2C probe attempts such as the ones done by ir-kbd-i2c.
Nothing to be afraid of.

-- 
Jean Delvare
