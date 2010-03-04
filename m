Return-path: <linux-media-owner@vger.kernel.org>
Received: from jim.sh ([75.150.123.25]:33077 "EHLO psychosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab0CDEzo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Mar 2010 23:55:44 -0500
Date: Wed, 3 Mar 2010 23:55:33 -0500
From: Jim Paris <jim@jtan.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: "M.Ebrahimi" <m.ebrahimi@ieee.org>, Max Thrun <bear24rw@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 10/11] ov534: Add Powerline Frequency control
Message-ID: <20100304045533.GA17821@psychosis.jim.sh>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
 <1267302028-7941-11-git-send-email-ospite@studenti.unina.it>
 <20100228194951.1c1e26ce@tele>
 <20100228201850.81f7904a.ospite@studenti.unina.it>
 <20100228205528.54d1ba69@tele>
 <1d742ad81003020326h5e02189bt6511b840dd17d7e3@mail.gmail.com>
 <20100302163937.70a15c19.ospite@studenti.unina.it>
 <7b67a5ec1003020806x65164673ue699de2067bc4fb8@mail.gmail.com>
 <1d742ad81003021827p181bf0a6mdf87ad7535bc37bd@mail.gmail.com>
 <20100303090008.f94e7789.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303090008.f94e7789.ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antonio Ospite wrote:
> On Wed, 3 Mar 2010 02:27:38 +0000
> "M.Ebrahimi" <m.ebrahimi@ieee.org> wrote:
> 
> > On 2 March 2010 16:06, Max Thrun <bear24rw@gmail.com> wrote:
> > >
> > >
> > > On Tue, Mar 2, 2010 at 10:39 AM, Antonio Ospite <ospite@studenti.unina.it>
> > > wrote:
> [...]
> > >> Mosalam did you spot the register from a PS3 usb dump or by looking at
> > >> the sensor datasheet?
> > 
> > None, I got that register from sniffing a Windows driver for another
> > camera that turned out to be using ov7620 or something similar, though
> > I thought it has the same sensor. I double checked, this register is
> > for frame rate adjustment (decreasing frame rate / increasing
> > exposure) . And this has been used in some other drivers (e.g.
> > gspca_sonixb) to remove light flicker as well.
> > 
> 
> I see. It would be interesting to see how Powerline Frequency filtering
> is done on PS3. I added Jim Paris on CC.

Hi Antonio and Mosalam,

I tried, but I can't capture that.  My USB logger only does USB 1.1,
which is too slow for the camera to run normally, but good enough to
see the initialization sequence.  However, the 50/60Hz option only
appears later, once the PS3 is receiving good frame data.

I can open up the camera and sniff the I2C bus instead.  It'll take
a little longer.

Interesting side note, the only change in the initialization sequence
between PS3 firmware 1.93 and 3.15 is 0x0C bit 6 -- horizontal flip :)
So they haven't made any improvements that we can borrow.

-jim
