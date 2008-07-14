Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n44.bullet.mail.ukl.yahoo.com ([87.248.110.177])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KIU3Z-0008Tq-Ev
	for linux-dvb@linuxtv.org; Mon, 14 Jul 2008 21:49:58 +0200
Date: Mon, 14 Jul 2008 15:47:46 -0400
From: manu <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
References: <1215822101l.26120l.0l@manu-laptop> <487B7AE8.30006@kipdola.com>
In-Reply-To: <487B7AE8.30006@kipdola.com> (from skerit@kipdola.com on Mon
	Jul 14 12:12:24 2008)
Message-Id: <1216064866l.7674l.2l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : (Crude) Patch to support latest multiproto drivers
 (as of 2008-07-11
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

Le 14.07.2008 12:12:24, Jelle De Loecker a =E9crit=A0:
> =

> manu schreef:
> > 	Hi all,
> > subject says it all. This patch (that applies to trunk, but =

> probably
> =

> > also for 0.21.fixes) allows myth to tune with the latest multiproto =

> > drivers.
> > No DVB-S2 support here, its a crude patch, but it works for DVB-S.
> > Bye
> > Manu
> >   =

> As ridiculous as it might seem, I still have difficulties applying =

> patches. I know, shoot me! I never seem to get when to use the -p1 or =

> -p0 option, or whatever! Here's my output.
> =

> patch -p0 < mythtv*.patch
> patching file libs/libmythtv/dvbchannel.cpp
> Hunk #1 FAILED at 211.
> Hunk #2 FAILED at 781.
> 2 out of 2 hunks FAILED -- saving rejects to file =

> libs/libmythtv/dvbchannel.cpp.rej
> =

> =

> /Met vriendelijke groeten,/
> =

> *Jelle De Loecker*
> Kipdola Studios - Tomberg
> =


p0 is the one, but it looks like your tree does not play well with my =

patch. This patch is to be applied on trunk -latest- mythtv.
HTH
Bye
Manu



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
