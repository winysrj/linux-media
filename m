Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KvZGB-0003Rw-5q
	for linux-dvb@linuxtv.org; Thu, 30 Oct 2008 16:16:33 +0100
Date: Thu, 30 Oct 2008 16:15:57 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <200810241945.34719.zzam@gentoo.org>
Message-ID: <20081030151557.257560@gmx.net>
MIME-Version: 1.0
References: <200810241945.34719.zzam@gentoo.org>
To: liplianin@tut.by, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] compat code: Fix compile failure of
 av7110.c on	Kernel 2.6.27
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


> Hi list!
> =

> av7110.c does not compile against a 2.6.27 kernel, as the inclusion of =

> linux/byteorder/swabb.h is now conditional with
> =

> #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 27)
> =

> But the byteorder changes in kernel took place after Kernel 2.6.27, so the
> compat code needs to look like this:
> =

> #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 28)
> =

> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Igor,
this patch hasn't been applied to s2-liplianin yet so compilation fails wit=
h 2.6.27.
Could you please sync with v4l-dvb which has it?
Thanks,
Hans
-- =

Release early, release often.

GMX Download-Spiele: Preizsturz! Alle Puzzle-Spiele Deluxe =FCber 60% billi=
ger.
http://games.entertainment.gmx.net/de/entertainment/games/download/puzzle/i=
ndex.html

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
