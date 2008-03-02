Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from anchor-post-30.mail.demon.net ([194.217.242.88])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1JVxPl-00047f-Hh
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 00:16:17 +0100
Received: from youmustbejoking.demon.co.uk ([80.176.152.238]
	helo=pentagram.youmustbejoking.demon.co.uk)
	by anchor-post-30.mail.demon.net with esmtp (Exim 4.67)
	id 1JVxPh-0004SL-37
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 23:16:14 +0000
Received: from [192.168.0.5] (helo=flibble.youmustbejoking.demon.co.uk)
	by pentagram.youmustbejoking.demon.co.uk with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1JVxPa-0007Vo-90
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 23:16:10 +0000
Date: Sun, 02 Mar 2008 23:07:59 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-dvb@linuxtv.org
Message-ID: <4F7F67AF4C%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <47CB20ED.5070403@philpem.me.uk>
References: <47A98F3D.9070306@raceme.org>
	<1202403104.5780.42.camel@eddie.sth.aptilo.com>
	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>
	<47C4661C.4030408@philpem.me.uk>
	<8ad9209c0802261137g1677a745h996583b2facb4ab6@mail.gmail.com>
	<8ad9209c0802271138o2e0c00d3o36ec16332d691953@mail.gmail.com>
	<47C7076B.6060903@philpem.me.uk> <47C879BA.7080002@philpem.me.uk>
	<1204356192.6583.0.camel@youkaida> <47CA609F.3010209@philpem.me.uk>
	<8ad9209c0803020419s49e9f9f0i883f48cf857fb20c@mail.gmail.com>
	<47CAB51F.9030103@philpem.me.uk> <1204479088.6236.32.camel@youkaida>
	<47CAEFC3.2020305@philpem.me.uk> <47CB20ED.5070403@philpem.me.uk>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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

I demand that Philip Pemberton may or may not have written...

> And now the icing on the cake:
[snip]
> [17302.420405] BUG: unable to handle kernel paging request at virtual add=
ress =

> fa23bda0
> [17302.420412] printing eip: f89bd162 *pde =3D 374ac067 *pte =3D 00000000
> [17302.420417] Oops: 0000 [#1] SMP
> [17302.420420] Modules linked in: [...] ath_hal(P) [...] nvidia(P) [...]
> [17302.420481] Pid: 9917, comm: kdvb-ad-1-fe-0 Tainted: P =

> (2.6.24-11-generic #1)
[snip]

You lose. Twice.

Can you cause that oops *without* the taintware? If not, do not pass Go, do
not collect =A3200, go directly to the two relevant vendors and (possibly) =
get
passed back and forth :-)

(You may be able to remove one of the taintware modules by upgrading to
2.6.25-rc3; you can remove the other by using nv or nouveau.)

-- =

| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Buy local produce. Try to walk or cycle. TRANSPORT CAUSES GLOBAL WARMIN=
G.

Kix are for trids.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
