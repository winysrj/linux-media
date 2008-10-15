Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp23.orange.fr ([193.252.22.126])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1KqBbS-0001sI-0Z
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 21:00:16 +0200
From: Christophe Thommeret <hftom@free.fr>
To: Darron Broad <darron@kewl.org>
Date: Wed, 15 Oct 2008 20:59:26 +0200
References: <200810141133.36559.hftom@free.fr>
	<200810151846.59042.hftom@free.fr> <13726.1224091355@kewl.org>
In-Reply-To: <13726.1224091355@kewl.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810152059.27034.hftom@free.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] cx24116 DVB-S modulation fix
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

Le Wednesday 15 October 2008 19:22:35 Darron Broad, vous avez =E9crit=A0:
> In message <200810151846.59042.hftom@free.fr>, Christophe Thommeret wrote:
>
> hi.
>
> <snip>
>
> >Other subject:
> >Would you accept some patch to enhance cx24116 pilot_auto emulation?
>
> If you present your patch and it enhances or fixes something
> then I am sure people will support it.

I don't know to which tree to apply, so i give the code as is (it's pretty =

simple):

Since 8PSK (and higher mod) signals are very likely to have pilot symbols, =

pilot_auto should start with pilot_on for 8PSK.
And since QPSK signals are unlikely to have pilot, pilot_auto should start =

with pilot_off for QPSK.

Without the patch:
QPSK tuning delay: ~100ms
8PSK tuning delay: ~900ms
with patch:
QPSK tuning delay: ~100ms
8PSK tuning delay: ~100ms


static int cx24116_set_frontend(struct dvb_frontend* fe, struct =

dvb_frontend_parameters *p)
....
....
case SYS_DVBS2:
...
...
switch(c->pilot) {
				case PILOT_AUTO:	/* Not supported but emulated */
					retune =3D 2;	/* Fall-through */
					if ( c->modulation=3D=3DQPSK )
						state->dnxt.pilot_val =3D CX24116_PILOT_OFF;
					else
						state->dnxt.pilot_val =3D CX24116_PILOT_ON;
					break;
...
...
/* Toggle pilot bit when in auto-pilot */
		if(state->dcur.pilot =3D=3D PILOT_AUTO) {
			if ( state->dnxt.pilot_val=3D=3D CX24116_PILOT_OFF )
				cmd.args[0x07] ^=3D CX24116_PILOT_ON;
			else
				cmd.args[0x07] ^=3D CX24116_PILOT_OFF;
		}

....
...




-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
