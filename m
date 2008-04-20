Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n24.bullet.mail.ukl.yahoo.com ([87.248.110.141])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1Jnbo8-0004fP-G6
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 17:50:30 +0200
Date: Sun, 20 Apr 2008 08:51:56 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <200804190101.14457.dkuhlen@gmx.net>
	<1208607419l.6132l.0l@manu-laptop> <200804201103.55265.dkuhlen@gmx.net>
In-Reply-To: <200804201103.55265.dkuhlen@gmx.net> (from dkuhlen@gmx.net on
	Sun Apr 20 05:03:55 2008)
Message-Id: <1208695916l.6132l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : Re : Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and
 TT-Connect-S2-3600 final version
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On 04/20/2008 05:03:55 AM, Dominik Kuhlen wrote:
> Hi,
> On Saturday 19 April 2008, manu wrote:
> > On 04/18/2008 07:01:14 PM, Dominik Kuhlen wrote:
> > > Hi,
> > > =

> > > Here is my current version after quite a while of testing and
> tuning:
> > > I stripped the stb0899 tuning/searching algo to speed up tuning a
> bit
> > > now I have very fast and reliable locks (no failures, no errors)
> > > =

> > > I have also merged the TT-S2-3600 patch from Andr=E9. (I cannot =

> test
> it
> > > though.)
> > > =

> > =

> > 	Hi,
> > I will try it right away! BTW should I substract the 4MHz you =

> talked
> =

> > about in another email when using this patch or is it already fixed
> by =

> > this (I did not try yet).
> This should be fixed. The offset I liked you to test was to check
> whether my investigations went in the right direction ;)
> For DVB-S transponders I can use a frequency offset in the range from
> -7MHz to +7MHz =

>  and still get reliable locks. The actual frequency is reported by
> DVBFE_GET_PARAM ioctl =

> which could be used to update the frequency list automagically.
> =


I had to ADD 4Mhz to the frequency to get reliable locks on all =

transponders (I added that directly in mythtv sources).
BTW I only applied the part of your patch concerning the stb0899, but I =

dont know if you initialised it differently in the pctv sources than =

how it is in the budget-ci ones. Maybe that can make a difference also.
HTH
Bye
Manu



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
