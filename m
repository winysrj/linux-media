Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2a.orange.fr ([80.12.242.140])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1KfG04-0006jf-H6
	for linux-dvb@linuxtv.org; Mon, 15 Sep 2008 17:28:29 +0200
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Mon, 15 Sep 2008 17:28:51 +0200
References: <466191.65236.qm@web46110.mail.sp1.yahoo.com>
	<alpine.LFD.1.10.0809151122480.16872@areia.chehab.org>
	<141058d50809150800l73fe8b67qbc845cd6e01eafe2@mail.gmail.com>
In-Reply-To: <141058d50809150800l73fe8b67qbc845cd6e01eafe2@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809151728.51469.hftom@free.fr>
Subject: Re: [linux-dvb] xc3028 config issue. Re: Why I need to choose
	better Subject: headers [was: Re: Why (etc.)]
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

Le Monday 15 September 2008 17:00:35 Glenn McGrath, vous avez =E9crit=A0:
> On Tue, Sep 16, 2008 at 12:30 AM, Mauro Carvalho Chehab
>
> <mchehab@infradead.org> wrote:
> > You should also notice that, on Australia, you'll need an extra offset =
of
> > 500 KHz for the frequency.
>
> What is the reason behind this... it took me a week to make an
> initial-tuning-data file for my tv card.
>
> I read that Australian broadcasters are allowed to broadcast +/-
> 125kHz from the center frequency, is it anything to do with that,
> where does the 500 come from ?

Allowed shiftings are n*125 (or n*167 on 8mhz)

> I started an app called utuner (gna.org/utuner if anyone whats to take
> a look, afaik nobody else has looked at it yet, so expect it to be
> rough) still very early, i just want to make something more flexible
> than w_scan that can generate an initial-tuning-data file, dont care
> if i have to leave the channel scan going all night and scan the whole
> spectrum, it will still be quicker than the week it took me to
> generate my initial-tuning-data file.

:)

-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
