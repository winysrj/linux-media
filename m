Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.seznam.cz ([77.75.72.43])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oldium.pro@seznam.cz>) id 1KsxLL-0006mH-UU
	for linux-dvb@linuxtv.org; Thu, 23 Oct 2008 12:23:06 +0200
From: Oldrich Jedlicka <oldium.pro@seznam.cz>
To: linux-dvb@linuxtv.org
Date: Thu, 23 Oct 2008 12:21:35 +0200
References: <48C659C5.8000902@magma.ca> <48CFA104.1070602@magma.ca>
	<1221608118.4511.2.camel@palomino.walls.org>
In-Reply-To: <1221608118.4511.2.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810231221.35329.oldium.pro@seznam.cz>
Subject: Re: [linux-dvb] HVR-1500Q eeprom not being parsed correctly
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Wednesday 17 of September 2008 at 01:35:18, Andy Walls wrote:
> On Tue, 2008-09-16 at 08:05 -0400, Patrick Boisvenue wrote:
> > Markus Rechberger wrote:
> > > On Sat, Sep 13, 2008 at 3:25 AM, Andy Walls <awalls@radix.net> wrote:
> > >> On Fri, 2008-09-12 at 15:16 -0400, Patrick Boisvenue wrote:
> > >>> Patrick Boisvenue wrote:
> > >>>> Michael Krufky wrote:
> > >>>>> On Fri, Sep 12, 2008 at 2:24 PM, Patrick Boisvenue 
<patrbois@magma.ca> wrote:
> > >>>>>> Andy Walls wrote:
> > >>>>>>> On Wed, 2008-09-10 at 20:37 -0400, Patrick Boisvenue wrote:
> > >>>>>>>> Andy Walls wrote:
> > >>>>>>>>> On Tue, 2008-09-09 at 22:37 -0400, Steven Toth wrote:
> > >>>>>>>>>> Patrick Boisvenue wrote:
> > >>>>>>>>>>> Steven Toth wrote:
> > >>>>>>>>>>>> Patrick Boisvenue wrote:
> > >
> > > don't load i2c-dev
> > >
> > > Markus
>
> Markus,
>
> Nice catch.
>
> Regards,
> Andy
>
> > Good call, that was it.  Re-compiling my kenrel without I2C_DEV allowed
> > the firmware to load and dvbscan to work as expected.
> >
> > Thanks,
> > ...Patrick

Hi,

I've just got into the sane trouble with i2c-dev and firmware loading 
(saa7134-dvb wanted xc3028-v27.fw). I've solved it with 2.6.27 by making the 
firmware statically loaded in the kernel as a binary blob - Device 
Drivers/Generic Driver Options/Include in-kernel firmware blobs in kernel 
binary. The firmware loading code just takes the binary blob and doesn't load 
it dynamically (it initializes devices in the dynamically loading path - that 
was causing problems).

Regards,
Oldrich.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
