Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Thu, 11 Sep 2008 02:01:48 +0200
References: <48B8400A.9030409@linuxtv.org> <20080910161222.21640@gmx.net>
	<48C85153.8010205@linuxtv.org>
In-Reply-To: <48C85153.8010205@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809110201.48935.hftom@free.fr>
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
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

Le Thursday 11 September 2008 00:59:31 Andreas Oberritter, vous avez =E9cri=
t=A0:
> Hans Werner wrote:
> >> So applications could know that these 2 frontends are exclusive.
> >> That would not require any API change, but would have to be a rule
> >> followed by
> >> all drivers.
> >
> > Yes, if we keep to that rule then only frontends which can operate truly
> > simultaneously should have a different adapter number.
>
> An adapter refers to a self-contained piece of hardware, whose parts can
> not be used by a second adapter (e.g. adapter0/demux0 can not access the
> data from adapter1/frontend1). In a commonly used setup it means that
> adapter0 is the first initialized PCI card and adapter1 is the second.
>
> Now, if you want a device with two tuners that can be accessed
> simultaneously to create a second adapter, then you would have to
> artificially divide its components so that it looks like two independant
> PCI cards. This might become very complicated and limits the functions
> of the hardware.
>
> However, on a setup with multiple accessible tuners you can expect at
> least the same amount of accessible demux devices on the same adapter
> (and also dvr devices for that matter). There is an ioctl to connect a
> frontend to a specific demux (DMX_SET_SOURCE).
>
> So, if there are demux0, frontend0 and frontend1, then the application
> knows that it can't use both frontends simultaneously. Otherwise, if =

> there are demux0, demux1, frontend0 and frontend1, then it can use both
> of them (by using both demux devices and connecting them to the
> frontends via the ioctl mentioned above).

Sounds logical. And that's why Kaffeine search for frontend/demux/dvr > 0 a=
nd =

uses demux1 with frontend1. (That was just a guess since i've never seen =

neither any such devices nor comments/recommendations/rules about such case=
).

However, all dual tuners devices drivers i know expose the 2 frontends as =

frontend0 in separate adapters. But all these devices seems to be USB.

The fact that Kaffeine works with the experimental hvr4000 driver indicates =

that this driver populates frontend1/demux1/dvr1 and then doesn't follow th=
e =

way you describe (since the tuners can't be used at once).
I would like to hear from Steve on this point.


-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
