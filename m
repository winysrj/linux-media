Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp21.orange.fr ([80.12.242.47])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1KiWYG-0005hW-I6
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 17:45:18 +0200
From: Christophe Thommeret <hftom@free.fr>
To: Darron Broad <darron@kewl.org>
Date: Wed, 24 Sep 2008 17:44:41 +0200
References: <200809211905.34424.hftom@free.fr>
	<200809241538.51217.hftom@free.fr> <4454.1222266662@kewl.org>
In-Reply-To: <4454.1222266662@kewl.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809241744.41604.hftom@free.fr>
Cc: Hans Werner <HWerner4@gmx.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] hvr4000-s2api + QAM_AUTO
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

Le Wednesday 24 September 2008 16:31:02 Darron Broad, vous avez =E9crit=A0:
> In message <200809241538.51217.hftom@free.fr>, Christophe Thommeret wrote:
>
> hi.
>
> <snip>
>
> >Btw, while cx24116 single-frontend seems pretty stable, the mfe driver is
> > n=3D ot =3D
> >here. As soon as i switch to dvb-t, the cx24116 firmware crashes (at lea=
st
> > =3D seems so: ~"Firmware doen't respond .." ) and is reloaded on next S=
/S2
> > zap, =3D and after a while, the dvb-t signal appears more and more nois=
y. I
> > have to =3D unload/reload the modules to cure this.
>
> Can you load dvb_core like this:
>
> 	dvb_core dvb_powerdown_on_sleep=3D0
>
> This will stop access to the cx24116 when the bus is in use by the cx2270=
2.
>
> This is a workaround until a better fix is found. Tell me if it solves it
> for you, Thanks.

Unfortunately, no.
I will try with newer firmware, as soon as i find it.


Btw:
Darron, all these Eutelsat spec compliant msleep are already implemented by =

applications, so adding it in driver just increases diseqc delay :)
I've removed all these in driver and diseqc works fine.


-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
