Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KeusC-0005ZQ-Gi
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 18:54:58 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K77009ZN2YM2J70@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sun, 14 Sep 2008 12:54:22 -0400 (EDT)
Date: Sun, 14 Sep 2008 12:54:21 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <564277.58085.qm@web46102.mail.sp1.yahoo.com>
To: free_beer_for_all@yahoo.com
Message-id: <48CD41BD.8040508@linuxtv.org>
MIME-version: 1.0
References: <564277.58085.qm@web46102.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

barry bouwsma wrote:
> --- On Sun, 9/14/08, Steven Toth <stoth@linuxtv.org> wrote:
> 
>> is that the BSD folks can't port the GPL license into BSD because it's 
>> not compatible.
> 
> I don't want to see any religious war here (trimmed to dvb
> list), but...
> 
> There is GPL code distributed as part of *BSD sources,
> as you can see by reading the licensing in, for example,
> $ ls /lost+found/CVSUP/BSD/FreeBSD.cvs/src/sys/gnu/dev/sound/pci/
> Attic       emu10k1-alsa.h,v  maestro3_reg.h,v  p17v-alsa.h,v
> csaimg.h,v  maestro3_dsp.h,v  p16v-alsa.h,v

Interesting.

> 
> 
>> I owe it to myself to spend somehime reading the BSD licencing. Maybe 
>> the GPL is compatible with BSD.
> 
> It all depends on the intended use -- whether for optional
> kernel components as above.  In the distributions, though,
> it's kept separated.
> 
> It's also possible to dual-licence source, and I see a good
> number of such files in NetBSD under, as an example,
> /lost+found/CVSUP/BSD/NetBSD.cvs/src/sys/dev/ic/

I'm be quite happy to grant a second license on my work the the BSD 
guys, as the copyright owner I can do that. The legal stuff gets messy 
quickly and I don't claim to understand all of it.

I'm an opensource developer, I chose to work on Linux because it's the 
biggest movement. I have no objections to any other projects, in fact I 
welcome them.


> 
> 
> There will be plenty of misinformation and FUD about which
> licensing is better, and I don't want to hear any more such.
> Or debates.  Or evangelism.  Or anything.

Agreed.

> 
> The different BSDen will handle GPLed code differently.
> 
> (By the way, it is possible to completely build NetBSD from
> within Linux, though the DVB code hasn't been merged as of
> this morning my time, if someone with *BSD familiarity here
> wants to think about considering maybe playing with it later
> sometime, perhaps, maybe)

The issue would be your support community. If you're working on linux 
then people here will help, if our working on something else and asking 
for help here - then people will probably be trying to fix linux first, 
so responses to questions may not arrive, or be slow coming.

Still, better TV support in BSD is good news.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
