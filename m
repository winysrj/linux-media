Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Christophe Thommeret <hftom@free.fr>
To: Steven Toth <stoth@linuxtv.org>
Date: Wed, 10 Sep 2008 22:32:26 +0200
References: <48B8400A.9030409@linuxtv.org> <20080910161222.21640@gmx.net>
	<48C81627.8080409@linuxtv.org>
In-Reply-To: <48C81627.8080409@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809102232.26884.hftom@free.fr>
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] Multiple frontends on a single adapter support. (Was:
	Re: DVB-S2 / Multiproto and future modulation support)
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

Le Wednesday 10 September 2008 20:47:03 Steven Toth, vous avez =E9crit=A0:
> Hans Werner wrote:
> > -------- Original-Nachricht --------
> >
> >> Datum: Wed, 10 Sep 2008 17:10:19 +0200
> >> Von: Christophe Thommeret <hftom@free.fr>
> >> An: Steven Toth <stoth@hauppauge.com>
> >> CC: linux-dvb@linuxtv.org
> >> Betreff: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation
> >> support
> >>
> >> Le Wednesday 10 September 2008 15:38:23 Steven Toth, vous avez =E9crit=
 :
> >>>> Is this card able to deliver both S and T at the same time?
> >>>
> >>> No, the hardware can do S/S2 or T.
> >>> The driver in the S2API tree only has S/S2 enabled (for the time
> >>> being).
> >>
> >> So, maybe we have to think a bit about how to add support for this kind
> >> of device.
> >
> > Yes, absolutely, and I hope this can go in to S2API and the kernel. It
> > would be a lie to claim that linux supports the HVR4000 until this is
> > done. Fortunately Steven and Darron made experimental drivers which do
> > this.
> >
> >> I mean, if the driver provides different adapters/frontends (say
> >> adapter0/frontend0 and adapter1/frontend0), a typical application will
> >> see these as separate devices, and then when a user watch a S channel,
> >> the app assumes that the T frontend is free while in fact it's not.
> >> For example, Kaffeine updates its channels list according to which
> >> channels
> >> can be viewed (based on which frontends are free). So, if you are
> >> recording a
> >> S channel, all channels on this freq are shown as available and all T
> >> channels are also shown as available. But in the HVR4000 case, it's
> >> false, since the T tuner isn't free.
> >>
> >> Maybe a solution could be to have :
> >> - adapter0/frontend0 -> S/S2 tuner
> >> - adapter0/frontend1 -> T tuner
> >
> > This is what the multifrontend (mfe) driver at
> > http://dev.kewl.org/hauppauge does. And Kaffeine is the only major DVB
> > app which correctly finds the two frontends and uses them correctly (we=
ll
> > done!!). Or very nearly -- TV watching is perfect, but the only slight
> > problem happens when you are recording:
> >
> > (1) record a DVB-T channel:
> > -->all DVB-T channels except those in same multiplex vanish from the
> > available channels list (correct)
> > -->no satellite channels vanish (incorrect)
> >
> > (2) record a DVB-S channel;
> > -->all DVB-S channels except those on the same multiplex vanish from the
> > available channels list (correct)
> > -->no DVB-T channels vanish (incorrect)
> >
> > It's a small problem, easily fixed I would think.
> >
> >> So applications could know that these 2 frontends are exclusive.
> >> That would not require any API change, but would have to be a rule
> >> followed by
> >> all drivers.
> >
> > Yes, if we keep to that rule then only frontends which can operate truly
> > simultaneously should have a different adapter number.
>
> If everyone wants this in the S2API tree then it's pretty simple to add,
> I just didn't want to overload the tree with too much baggage that
> causes it to get stuck in the approval process.
>
> We need an S2 API in the next few weeks, and anything that delays that
> is bad news for everyone.
>
> I'll publish a mail about this in a separate thread, and seek feedback
> from everyone.

Well, i guess i should have modified the subject, since it's not directly =

related to S2API.
Do not spend your time on this at that moment, S2API has the priority.

I just wanted to get feedback about this solution, since it does not involv=
e =

any API change but only requires devs approval to follow this rule.


-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
