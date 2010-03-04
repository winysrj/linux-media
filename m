Return-path: <linux-media-owner@vger.kernel.org>
Received: from jim.sh ([75.150.123.25]:57639 "EHLO psychosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268Ab0CDUgr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Mar 2010 15:36:47 -0500
Date: Thu, 4 Mar 2010 15:36:40 -0500
From: Jim Paris <jim@jtan.com>
To: Max Thrun <bear24rw@gmail.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	"M.Ebrahimi" <m.ebrahimi@ieee.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 10/11] ov534: Add Powerline Frequency control
Message-ID: <20100304203640.GA22620@psychosis.jim.sh>
References: <20100228205528.54d1ba69@tele>
 <1d742ad81003020326h5e02189bt6511b840dd17d7e3@mail.gmail.com>
 <20100302163937.70a15c19.ospite@studenti.unina.it>
 <7b67a5ec1003020806x65164673ue699de2067bc4fb8@mail.gmail.com>
 <1d742ad81003021827p181bf0a6mdf87ad7535bc37bd@mail.gmail.com>
 <20100303090008.f94e7789.ospite@studenti.unina.it>
 <20100304045533.GA17821@psychosis.jim.sh>
 <20100304100346.79818884.ospite@studenti.unina.it>
 <20100304201445.GA21194@psychosis.jim.sh>
 <7b67a5ec1003041222g25af69daq50fc62aeb8c85b96@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b67a5ec1003041222g25af69daq50fc62aeb8c85b96@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Max Thrun wrote:
> On Thu, Mar 4, 2010 at 3:14 PM, Jim Paris <jim@jtan.com> wrote:
> 
> > Antonio Ospite wrote:
> > > On Wed, 3 Mar 2010 23:55:33 -0500
> > > Jim Paris <jim@jtan.com> wrote:
> > >
> > > > Antonio Ospite wrote:
> > > [...]
> > > > >
> > > > > I see. It would be interesting to see how Powerline Frequency
> > filtering
> > > > > is done on PS3. I added Jim Paris on CC.
> > > >
> > > > Hi Antonio and Mosalam,
> > > >
> > > > I tried, but I can't capture that.  My USB logger only does USB 1.1,
> > > > which is too slow for the camera to run normally, but good enough to
> > > > see the initialization sequence.  However, the 50/60Hz option only
> > > > appears later, once the PS3 is receiving good frame data.
> > > >
> > > > I can open up the camera and sniff the I2C bus instead.  It'll take
> > > > a little longer.
> > > >
> > >
> > > Thanks for your time Jim.
> >
> > No problem, glad to help.
> > Looks like Mosalam's patch is correct:
> >
> > --- i2c-60hz.log        2010-03-04 15:09:23.000000000 -0500
> > +++ i2c-50hz.log        2010-03-04 15:09:27.000000000 -0500
> > @@ -69,7 +69,7 @@
> >  ov_write_verify 8C E8
> >  ov_write_verify 8D 20
> >  ov_write_verify 0C 90
> > -ov_write_verify 2B 00
> > +ov_write_verify 2B 9E
> >  ov_write_verify 22 7F
> >  ov_write_verify 23 03
> >  ov_write_verify 11 01
> >
> > I'll attach the full logs.
> >
> > -jim
> >
> 
> Jim, I'm really interested in how you went about sniffing the bus. Can you
> share some details about what you use to do it?

Sure.  I borrowed one of these from a friend:
  http://www.totalphase.com/products/beagle_ism/

and tapped the GND, SCL, and SDA pins off the camera EEPROM.
I exported a CSV from the Beagle software and used a quick Perl script
to parse it into a more useful read/write/write_verify format.

-jim
