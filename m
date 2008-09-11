Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web38803.mail.mud.yahoo.com ([209.191.125.94])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <urishk@yahoo.com>) id 1Kdf37-00024Y-5l
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 07:49:03 +0200
Date: Wed, 10 Sep 2008 22:48:27 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
To: Christophe Thommeret <hftom@free.fr>, Steven Toth <stoth@linuxtv.org>
In-Reply-To: <48C86DBD.6090108@linuxtv.org>
MIME-Version: 1.0
Message-ID: <155463.82037.qm@web38803.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
Reply-To: urishk@yahoo.com
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




--- On Thu, 9/11/08, Steven Toth <stoth@linuxtv.org> wrote:

> From: Steven Toth <stoth@linuxtv.org>
> Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
> To: "Christophe Thommeret" <hftom@free.fr>
> Cc: linux-dvb@linuxtv.org
> Date: Thursday, September 11, 2008, 4:00 AM
> Christophe Thommeret wrote:
> > Le Thursday 11 September 2008 00:59:31 Andreas
> Oberritter, vous avez =E9crit :
> >> Hans Werner wrote:
> >>>> So applications could know that these 2
> frontends are exclusive.
> >>>> That would not require any API change, but
> would have to be a rule
> >>>> followed by
> >>>> all drivers.
> >>> Yes, if we keep to that rule then only
> frontends which can operate truly
> >>> simultaneously should have a different adapter
> number.
> >> An adapter refers to a self-contained piece of
> hardware, whose parts can
> >> not be used by a second adapter (e.g.
> adapter0/demux0 can not access the
> >> data from adapter1/frontend1). In a commonly used
> setup it means that
> >> adapter0 is the first initialized PCI card and
> adapter1 is the second.
> >>
> >> Now, if you want a device with two tuners that can
> be accessed
> >> simultaneously to create a second adapter, then
> you would have to
> >> artificially divide its components so that it
> looks like two independant
> >> PCI cards. This might become very complicated and
> limits the functions
> >> of the hardware.
> >>
> >> However, on a setup with multiple accessible
> tuners you can expect at
> >> least the same amount of accessible demux devices
> on the same adapter
> >> (and also dvr devices for that matter). There is
> an ioctl to connect a
> >> frontend to a specific demux (DMX_SET_SOURCE).
> >>
> >> So, if there are demux0, frontend0 and frontend1,
> then the application
> >> knows that it can't use both frontends
> simultaneously. Otherwise, if =

> >> there are demux0, demux1, frontend0 and frontend1,
> then it can use both
> >> of them (by using both demux devices and
> connecting them to the
> >> frontends via the ioctl mentioned above).
> > =

> > Sounds logical. And that's why Kaffeine search for
> frontend/demux/dvr > 0 and =

> > uses demux1 with frontend1. (That was just a guess
> since i've never seen =

> > neither any such devices nor
> comments/recommendations/rules about such case).
> > =

> > However, all dual tuners devices drivers i know expose
> the 2 frontends as =

> > frontend0 in separate adapters. But all these devices
> seems to be USB.
> > =

> > The fact that Kaffeine works with the experimental
> hvr4000 driver indicates =

> > that this driver populates frontend1/demux1/dvr1 and
> then doesn't follow the =

> > way you describe (since the tuners can't be used
> at once).
> > I would like to hear from Steve on this point.
> > =

> > =

> =

> Correct, frontend1, demux1, dvr1 etc. All on the same
> adapter. The =

> driver and multi-frontend patches manage exclusive access
> to the single =

> internal resource.
> =

> - Steve
> =

> =

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

I wrote about it in a previous post, it's not always so. What about diversi=
ty (two frontends, single demux (or non if it's not TS based content)?


      =


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
