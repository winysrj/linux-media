Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n61.bullet.mail.sp1.yahoo.com ([98.136.44.37])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KetJN-000680-IX
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 17:14:55 +0200
Date: Sun, 14 Sep 2008 08:14:18 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: Steven Toth <stoth@linuxtv.org>
In-Reply-To: <48CD1F3E.6080900@linuxtv.org>
MIME-Version: 1.0
Message-ID: <564277.58085.qm@web46102.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto API/Driver Update
Reply-To: free_beer_for_all@yahoo.com
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

--- On Sun, 9/14/08, Steven Toth <stoth@linuxtv.org> wrote:

> is that the BSD folks can't port the GPL license into BSD because it's 
> not compatible.

I don't want to see any religious war here (trimmed to dvb
list), but...

There is GPL code distributed as part of *BSD sources,
as you can see by reading the licensing in, for example,
$ ls /lost+found/CVSUP/BSD/FreeBSD.cvs/src/sys/gnu/dev/sound/pci/
Attic       emu10k1-alsa.h,v  maestro3_reg.h,v  p17v-alsa.h,v
csaimg.h,v  maestro3_dsp.h,v  p16v-alsa.h,v


> I owe it to myself to spend somehime reading the BSD licencing. Maybe 
> the GPL is compatible with BSD.

It all depends on the intended use -- whether for optional
kernel components as above.  In the distributions, though,
it's kept separated.

It's also possible to dual-licence source, and I see a good
number of such files in NetBSD under, as an example,
/lost+found/CVSUP/BSD/NetBSD.cvs/src/sys/dev/ic/


There will be plenty of misinformation and FUD about which
licensing is better, and I don't want to hear any more such.
Or debates.  Or evangelism.  Or anything.

The different BSDen will handle GPLed code differently.

(By the way, it is possible to completely build NetBSD from
within Linux, though the DVB code hasn't been merged as of
this morning my time, if someone with *BSD familiarity here
wants to think about considering maybe playing with it later
sometime, perhaps, maybe)


thanks,
barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
