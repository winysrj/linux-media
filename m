Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway11.websitewelcome.com ([69.41.245.3])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1Ky1Hx-0003q9-FX
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 10:36:31 +0100
Message-ID: <4912BA94.8060809@kipdola.com>
Date: Thu, 06 Nov 2008 10:36:20 +0100
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: Torgeir Veimo <torgeir@pobox.com>,
	LinuxTV DVB Mailing <linux-dvb@linuxtv.org>
References: <BF8F0D96-3ED8-4D3D-8EF7-899FCAC4514E@pobox.com>
In-Reply-To: <BF8F0D96-3ED8-4D3D-8EF7-899FCAC4514E@pobox.com>
Subject: Re: [linux-dvb] dvbloopback:
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

Torgeir Veimo schreef:
> Am trying to use dvbloopback in a setup with two cards, but it seems  
> to fail, I get these errors;
>
> Nov  6 09:30:30.151 frontend: Could not open /dev/dvb/adapter2/ 
> frontend1. Error was: 14
> Open failed
> : Bad address
> Nov  6 09:30:30.151 demux: Could not open /dev/dvb/adapter2/demux1.  
> Error was: 14
> Open failed
> : Bad address
>
> Looking in /var/log/messages, I see the errors;
>
> Nov  6 09:30:30 htpc kernel: Failed to find private data during open
>
> Looking into the dvbloopback kernel module source, it looks like it's  
> not able to retrieve its private member variables;
>
> lbdev = (struct dvblb_devinfo *)dvbdev->priv;
> if (lbdev == NULL) {
>    printk("Failed to find private data during open\n");
>    return -EFAULT;
> }
>
> This would indicate something serious is happening with the kernel  
> module loading? I am using kernel 2.6.26, am not sure if there are any  
> incompatibilities there, as the compile script seems to support up to  
> 2.6.25 only?
>
> Is the dvbloopback module author subscribed to this list?
>   
Hi Torgeir,

First of all, I admire your courage for asking help about dvbloopback on 
this list.
Dvbloopback (and so sasc-ng) is kind of taboo on most MLs.

Unjust, in my opinion.
Sure, the software can be abused for signal "piracy" or whatever you 
want to call it, but in the same way can you abuse Azureus, Gift, ... 
for illegal downloading. In the same way is watching a dvd in America 
some silly patent infringment thing or what-ever.

So, to anyone, I use sasc-ng (and a couple of my friends, too) so that 
we can use 1 smartcard for several tuners.
This is in no way illegal (at least not here in Belgium). However, it 
could be a breach of contract, but that's not any worry of this list. 
(And since my provider supports settop-boxes with multiple tuners I'm 
not worried, too)

And after ALL that, just talking about using and compiling the progrem 
certainly isn't illegal.

I know nobody has said anything about "don't mention sasc-ng on this 
list" yet, I'm just preparing.

Anyway!

Are you using S2API and the S2API patch found on open-sasc-ng's trac?
Because I have the same problem ("error 14", I don't get the "private 
data" bit, though) with kernel 2.6.26 (which came with Debian Lenny) AND 
with my own compiled 2.6.27

In my case it must be an S2API thing, because when I was using 
Multiproto everything worked fine.

Or maybe it's a regression in the latest revision (r53?) I should find 
out ...

Greetings,
Jelle De Loecker

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
