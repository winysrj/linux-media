Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail0.scram.de ([78.47.204.202] helo=mail.scram.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jochen@scram.de>) id 1JqsT8-0007wS-T1
	for linux-dvb@linuxtv.org; Tue, 29 Apr 2008 18:14:15 +0200
Message-ID: <4817492B.2070601@scram.de>
Date: Tue, 29 Apr 2008 18:13:31 +0200
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Thierry Lelegard <thierry.lelegard@tv-numeric.com>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAvS+B+Nz04k29X/weWcnp3gEAAAAA@tv-numeric.com>
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAvS+B+Nz04k29X/weWcnp3gEAAAAA@tv-numeric.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] RE :  RE :  Terratec Cinergy T USB XE Rev 2,
 any update ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Thierry,

> Any idea when those two drivers will be integrated in the main tree?
> Concerning the Terratec's driver, I have not seen any licence note,
> neither GPL nor proprietary. Any chance to make it GPL?

No idea

However, in the meantime i also got a combination of the AF9015 drivers
in http://linuxtv.org/hg/~anttip/af9015-mxl500x-copy-fw/ and the MC44S802
drivers in http://jusst.de/hg/af901x working with this USB device.

The i2c functions of AF9015 seem to only work for 1byte register addresses
the way they are coded right now and MC44S802 seems to be able to operate
in different endian modes (i had to swap endianess of all registers). This
and the output selection should probably be a config option to be passed
during tuner attach.

The (quick and dirty ported) tree is on git://git.bocc.de/cinergy.git 
(or http://git.bocc.de/cgi-bin/gitweb.cgi?p=cinergy.git;a=summary for a 
web interface).

Thanks,
Jochen

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
