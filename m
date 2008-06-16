Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [213.161.191.158] (helo=patton.snap.tv)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sigmund@snap.tv>) id 1K8E10-00089F-33
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 14:40:54 +0200
From: Sigmund Augdal <sigmund@snap.tv>
To: Arthur Konovalov <artlov@gmail.com>
In-Reply-To: <4855F6B0.8060507@gmail.com>
References: <20080615192300.90886244.SiestaGomez@web.de>
	<4855F6B0.8060507@gmail.com>
Date: Mon, 16 Jun 2008 14:40:50 +0200
Message-Id: <1213620050.6543.6.camel@pascal>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
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

On Mon, 2008-06-16 at 08:14 +0300, Arthur Konovalov wrote:
> SG wrote:
> > The patch works quite well and nearly all channels seem to work.
> > 
> > But when tuning to some radio channels I'll get this kernel message:
> > 
> > saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
> > 
> > Also I'm not able to tune to 'transponder 386000000 6900000 0 3' which works
> > smoothly when using Win32.
> > 
> > initial transponder 386000000 6900000 0 3
> >  >>> tune to: 386:M64:C:6900:
> > WARNING: >>> tuning failed!!!
> >  >>> tune to: 386:M64:C:6900: (tuning failed)
> > WARNING: >>> tuning failed!!!
> > ERROR: initial tuning failed
> > dumping lists (0 services)
> > Done.
> 
> Yes, I discovered too that tuning to frequency 386MHz has no lock.
> VDR channels.conf: TV3:386000:C0M64:C:6875:703:803:0:0:1003:16:1:0
> 
> At same time, 394MHz (and others) works.
Hi.

Both transponders reported to not tune here has different symbolrates
from what I used for my testing. Maybe this is relevant in some way.
Could you please compare this with the channels that did tune to see if
there is a pattern?

About the i2c message, I get that every now and then here as well, but I
have not seen any ill effect from it. I also see that on some other TT
cards so I think that might be unrelated to the demod/tuner.

Regards

Sigmund Augdal
> 
> Regards,
> AK
> 
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
