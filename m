Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail2.elion.ee ([88.196.160.58] helo=mail1.elion.ee)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artlov@gmail.com>) id 1K873Y-0004jG-CF
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 07:15:15 +0200
Message-ID: <4855F6B0.8060507@gmail.com>
Date: Mon, 16 Jun 2008 08:14:24 +0300
From: Arthur Konovalov <artlov@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20080615192300.90886244.SiestaGomez@web.de>
In-Reply-To: <20080615192300.90886244.SiestaGomez@web.de>
Subject: Re: [linux-dvb] [PATCH] experimental support for C-1501
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

SG wrote:
> The patch works quite well and nearly all channels seem to work.
> 
> But when tuning to some radio channels I'll get this kernel message:
> 
> saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
> 
> Also I'm not able to tune to 'transponder 386000000 6900000 0 3' which works
> smoothly when using Win32.
> 
> initial transponder 386000000 6900000 0 3
>  >>> tune to: 386:M64:C:6900:
> WARNING: >>> tuning failed!!!
>  >>> tune to: 386:M64:C:6900: (tuning failed)
> WARNING: >>> tuning failed!!!
> ERROR: initial tuning failed
> dumping lists (0 services)
> Done.

Yes, I discovered too that tuning to frequency 386MHz has no lock.
VDR channels.conf: TV3:386000:C0M64:C:6875:703:803:0:0:1003:16:1:0

At same time, 394MHz (and others) works.

Regards,
AK



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
