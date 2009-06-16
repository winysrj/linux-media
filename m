Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:25713 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbZFPLaf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 07:30:35 -0400
Subject: Re: [PATCHv7 7/9] FMTx: si4713: Add files to handle si4713 i2c
 device
From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Reply-To: ext-eero.nurkkala@nokia.com
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
In-Reply-To: <200906161322.13518.hverkuil@xs4all.nl>
References: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com>
	 <200906141431.55725.hverkuil@xs4all.nl>
	 <20090616110609.GC16092@esdhcp037198.research.nokia.com>
	 <200906161322.13518.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 14:30:08 +0300
Message-Id: <1245151808.3166.2.camel@eenurkka-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-06-16 at 13:22 +0200, ext Hans Verkuil wrote:
> On Tuesday 16 June 2009 13:06:09 Eduardo Valentin wrote:
> > On Sun, Jun 14, 2009 at 02:31:55PM +0200, ext Hans Verkuil wrote:
> > > > +     if (rval < 0)
> > > > +             goto exit;
> > > > +
> > > > +     /* TODO: How to set frequency to measure current signal length
> > > > */
> > >
> > > Huh? I don't understand this TODO.
> >
> > The todo is about the property this device had, to report signal length
> 
> 'signal length' or 'signal strength'? If it is the former, then I don't 
> understand what you mean with that term.
> 
> > of a freq. It used to work like: user echoes the freq on sysfs entry.
> > when reading the same entry, it reports the signal noise there.
> >
> > This is something which I still don't know the proper place to put.
> >
> > I thought in another ext control. But I don't know if this fix into
> > the fm tx controls. Maybe I should use a private one ?
> 
> I need to understand this better first.
> 
> Regards,
> 
> 	Hans
> 

Transmitter turns into a receiver and measures the RSSI level of
the frequency. If it's high (< -90 -100dB), it's probably not a good
idea to transmit any on such frequency as the interference is too great.

- Eero

