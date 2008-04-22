Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail0.scram.de ([78.47.204.202] helo=mail.scram.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jochen@scram.de>) id 1JoHLo-0004k8-2d
	for linux-dvb@linuxtv.org; Tue, 22 Apr 2008 14:12:02 +0200
Message-ID: <480DD592.7040209@scram.de>
Date: Tue, 22 Apr 2008 14:09:54 +0200
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PMKAAAAQAAAAijN3xCp8g0Kp9uKDTg5IowEAAAAA@tv-numeric.com>
	<480CD719.9010909@iki.fi>
In-Reply-To: <480CD719.9010909@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy T USB XE Rev 2, any update ?
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

Hi Antti,

> Main problem is that there is no tuner driver for Freescale MC44S803 
> silicon tuner. Looks like there is code for MC44S803 on the net 
> available (for example Terratec driver). Porting it to Linux should not 
> be too big task.

The Terratec driver *is* a linux driver, just for an older kernel version.
I just did a very quick and dirty forward port of the driver (by replacing
the included dvb-core and dvb-usb files with the ones of the current dvb
hg tree) and the result compiled OK on 2.6.24. Even better, it even works :)

Thanks,
Jochen

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
