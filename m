Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2e.orange.fr ([80.12.242.112])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1KgP6D-0001R8-So
	for linux-dvb@linuxtv.org; Thu, 18 Sep 2008 21:23:35 +0200
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org, urishk@yahoo.com
Date: Thu, 18 Sep 2008 21:24:01 +0200
References: <793532.4521.qm@web38802.mail.mud.yahoo.com>
In-Reply-To: <793532.4521.qm@web38802.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809182124.01287.hftom@free.fr>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

Le Thursday 18 September 2008 21:11:02 Uri Shkolnik, vous avez =E9crit=A0:
> --- On Fri, 9/12/08, barry bouwsma <free_beer_for_all@yahoo.com> wrote:
> > From: barry bouwsma <free_beer_for_all@yahoo.com>
> > Subject: Re: [linux-dvb] Multiproto API/Driver Update
> > To: "linux-dvb" <linux-dvb@linuxtv.org>, urishk@yahoo.com
> > Date: Friday, September 12, 2008, 12:17 PM
> > --- On Thu, 9/11/08, Uri Shkolnik <urishk@yahoo.com>
> >
> > wrote:
> > > > It is from my perspective in Europe that I write,
> > >
> > > I'm not so sure. As I see it, if it depends on
> >
> > number
> >
> > > of users DVB-H comes last after CMMB and ISDB-T.
> >
> > Then let them add their support ;-P   I just discovered
> > that
> > I should be within reception range of a (subscription)
> > DVB-H
> > mux, though sticking a directional antenna out the window
> > did
> > not show any signal (but also not on other
> > previously-received
> > frequencies) -- but climbing a nearby hill should net me a
> > useful signal, maybe two.
> >
> > For DAB, a simple paperclip antenna will get me one
> > ensemble,
> > a second should be receivable as well, and perhaps with a
> > good
> > antenna, some others may appear.
> >
> > So, I can test real-world broadcasts and get the actual
> > hands-
> > on experience I need to understand and be able to help --
> > which is more than I can for the other missing standards,
> > as
> > I'm not so good with the theoretical...
> >
> > > I know the TerraTec device you refer to, and
> >
> > theoretically
> >
> > > it can be used as DAB radio receiver. The current
> >
> > LinuxTV
> >
> > > lacks the code to support it.
> >
> > [...]
> >
> > > There is a open source module from Siano that enable
> >
> > DAB @
> >
> > > Linux.
> >
> > Is this something I would be able to download?  (Feel free
> > to
> > mail me privately if you don't want it available to
> > other
> > developers, though they could certainly fit it into a
> > suitable
> > API much better than I could)
> >
> > I've searched with g00gle but haven't found any
> > source to
> > download.  (And if drivers under Linux for the other modes
> > (T-DMB, DVB-H) are available, they may help me to better
> > understand those modes as well)
> >
> > >   The problem is that this module is not a part of DVB
> > > and does not communicates with DVB in any way, but it
> >
> > uses
> >
> > > its own character devices in order to communicate with
> >
> > user
> >
> > > space applications. It may be converted of course to
> > > something that uses DVB, and also be more generic.
> >
> > There is another USB DAB device out there (apparently no
> > longer available, and if so, at an `early-adopter'
> > price)
> > with kernel support.
> > Perhaps there's some shared functionality that can be
> > combined, somehow, and make easier possibly adding support
> > for some of the small handful of other DAB-able devices.
> >
> >
> > Anyway, if I'm able to start to play with my device and
> > DAB
> > under linux, that should keep me busy and quiet for some
> > time
> >
> > thanks,
> > barry bouwsma
>
> [ Sorry for the late response ]
>
> Regarding DAB support -
>
> In order to add full support for DAB ( / DAB+ / T-DMB / DAB-IP / any other
> ensemble based transmission) you need to have an ensemble parser. This is
> quite a problem since I'm not familiar with any such decent open source
> parser.
>
> Anyone?

It's always possible to write one :)

-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
