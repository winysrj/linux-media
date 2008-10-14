Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2b.orange.fr ([80.12.242.146])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1KpjNM-0003Wc-PO
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 14:51:50 +0200
From: Christophe Thommeret <hftom@free.fr>
To: Darron Broad <darron@kewl.org>
Date: Tue, 14 Oct 2008 14:51:02 +0200
References: <200810141133.36559.hftom@free.fr> <1985.1223980189@kewl.org>
In-Reply-To: <1985.1223980189@kewl.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810141451.02941.hftom@free.fr>
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

Le Tuesday 14 October 2008 12:29:49 Darron Broad, vous avez =E9crit=A0:
> In message <200810141133.36559.hftom@free.fr>, Christophe Thommeret wrote:
>
> hi
>
> >Hi,
> >
> >This patch makes cx24116 to behave like other dvb-s frontends.
>
> Unlike most DVB-S cards the those with a cx24116 use S2API
> this makes them somewhat different.
>
> >This is needed especially because QAM_AUTO is used in a lot of scan file=
s.
>
> What scan files are you referring to? The
> cx24116 only does PSK, not AM. QAM_AUTO
> doesn't sound right. the cx24116 can't
> auto detect anything, but that's another
> story...

dvbscan initial tuning data files for DVB-S don't have an entry for =

modulation. So an app like kaffeine simply set modulation to QAM_AUTO.
Why not QPSK, you ask? Simply because DVB-S standard allows QPSK and 16QAM. =

Maybe there is not a single 16QAM TP all over the world, but it's still a =

valid modulation for DVB-S.
So, we set modulation to QAM_AUTO when it's unknown/unspecified, like in =

dvbscan files (those being also used by kaffeine). And it works pretty well=
, =

just because most dvb-s can only do QPSK and so force modulation to QPSK =

instead of returning a notsup.
See this as software QAM_AUTO :)

P.S.
This is with s2api.

-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
