Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n44.bullet.mail.ukl.yahoo.com ([87.248.110.177])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1K4Nzu-00010Z-1E
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 00:31:56 +0200
Date: Thu, 05 Jun 2008 18:27:32 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <1212610778l.7239l.1l@manu-laptop>
	<200806052223.10682.dkuhlen@gmx.net>
In-Reply-To: <200806052223.10682.dkuhlen@gmx.net> (from dkuhlen@gmx.net on
	Thu Jun  5 16:23:10 2008)
Message-Id: <1212704852l.9365l.2l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : No lock on a particular transponder with TT S2-3200
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Le 05.06.2008 16:23:10, Dominik Kuhlen a =E9crit=A0:
> On Wednesday 04 June 2008, manu wrote:
> > 	Hi all,
> > one more datapoint for the TT 3200 tuning problems. I solved all my =

> > locking problems by add 4MHz to the reported frequencies (coming
> from =

> > the stream tables); note that one of the transponders always locked =

> > even without this correction (its freq is 11093MHz, the others =

> are :
> =

> > 11555, 11635, 11675MHz), so as you see the others are much higher.
> > Now there is another transponder at 11495MHz but this one I cant
> lock =

> > on it even with my correction. Here are its characteristic as
> reported =

> ---snip---
> According to =

> http://www.ses-astra.com/consumer/de/Sender/
> senderlisten/2001_20080603_pdf.pdf
> this transponder is analog TV with some ADRs.
> =


Actually if you look at the position, the sat is intelsat-9
3 (somewhere above south america, I am located in the caribbean; I know =

that there is a mention of an astra sat, but this is just a confusion.
Thx
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
