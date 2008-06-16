Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <martin@waldorfmail.homeip.net>) id 1K8FnY-0000se-At
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 16:35:09 +0200
Received: from mail-in-12-z2.arcor-online.net (mail-in-12-z2.arcor-online.net
	[151.189.8.29])
	by mail-in-08.arcor-online.net (Postfix) with ESMTP id 42A5027B242
	for <linux-dvb@linuxtv.org>; Mon, 16 Jun 2008 16:35:04 +0200 (CEST)
Received: from mail-in-12.arcor-online.net (mail-in-12.arcor-online.net
	[151.189.21.52])
	by mail-in-12-z2.arcor-online.net (Postfix) with ESMTP id 1B8AE27944C
	for <linux-dvb@linuxtv.org>; Mon, 16 Jun 2008 16:35:04 +0200 (CEST)
Received: from waldorfmail.homeip.net (ip-88-152-136-212.hsi.ish.de
	[88.152.136.212]) (Authenticated sender: waldorfmail@arcor.de)
	by mail-in-12.arcor-online.net (Postfix) with ESMTP id E66328C462
	for <linux-dvb@linuxtv.org>; Mon, 16 Jun 2008 16:35:03 +0200 (CEST)
From: siestagomez@web.de
To: linux-dvb@linuxtv.org
Date: Mon, 16 Jun 2008 16:35:03 +0200
Mime-Version: 1.0
Message-Id: <20080616143503.6C9053BC99@waldorfmail.homeip.net>
Subject: [linux-dvb]  [PATCH] experimental support for C-1501 (fwd)
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

Sigmund Augdal schrieb: 

> On Mon, 2008-06-16 at 08:14 +0300, Arthur Konovalov wrote:
>> SG wrote:
>> > The patch works quite well and nearly all channels seem to work.
>> > 
>> > But when tuning to some radio channels I'll get this kernel message:
>> > 
>> > saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
>> > 
>> > Also I'm not able to tune to 'transponder 386000000 6900000 0 3' which works
>> > smoothly when using Win32.
>> > 
>> > initial transponder 386000000 6900000 0 3
>> >  >>> tune to: 386:M64:C:6900:
>> > WARNING: >>> tuning failed!!!
>> >  >>> tune to: 386:M64:C:6900: (tuning failed)
>> > WARNING: >>> tuning failed!!!
>> > ERROR: initial tuning failed
>> > dumping lists (0 services)
>> > Done.  
>> 
>> Yes, I discovered too that tuning to frequency 386MHz has no lock.
>> VDR channels.conf: TV3:386000:C0M64:C:6875:703:803:0:0:1003:16:1:0  
>> 
>> At same time, 394MHz (and others) works.
> Hi.  
> 
> Both transponders reported to not tune here has different symbolrates
> from what I used for my testing. Maybe this is relevant in some way.
> Could you please compare this with the channels that did tune to see if
> there is a pattern?  
> 
> About the i2c message, I get that every now and then here as well, but I
> have not seen any ill effect from it. I also see that on some other TT
> cards so I think that might be unrelated to the demod/tuner.  
> 
> Regards  
> 
> Sigmund Augdal

The symbolrate is the same on all other working channels. 

Regarding the i2c message when watching video I'll get this only once but 
when tuning to a radio channel my log gets flooded and it seems to hangup. 

Martin 



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
