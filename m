Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:49239 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426Ab0DCLzG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Apr 2010 07:55:06 -0400
Message-ID: <32832848.1270295705043.JavaMail.ngmail@webmail10.arcor-online.net>
Date: Sat, 3 Apr 2010 13:55:05 +0200 (CEST)
From: hermann-pitton@arcor.de
To: awalls@md.metrocast.net, mchehab@redhat.com
Subject: Aw: Re: [RFC] Serialization flag example
Cc: dheitmueller@kernellabs.com, abraham.manu@gmail.com,
	hverkuil@xs4all.nl, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 


----- Original Nachricht ----
Von:     Andy Walls <awalls@md.metrocast.net>
An:      Mauro Carvalho Chehab <mchehab@redhat.com>
Datum:   03.04.2010 02:47
Betreff: Re: [RFC] Serialization flag example

> On Fri, 2010-04-02 at 18:15 -0300, Mauro Carvalho Chehab wrote:
> > Devin Heitmueller wrote:
> 
> > In the case of a V4L x DVB type of lock, this is not to protect some
> memory, but,
> > instead, to limit the usage of a hardware that is not capable of
> simultaneously
> > provide V4L and DVB streams. This is a common case on almost all devices,
> but, as
> > Hermann pointed, there are a few devices that are capable of doing both
> analog
> > and digital streams at the same time, but saa7134 driver currently doesn't
> support.

Mauro, to do digital and analog at once is not restricted to a few devices.

The only restriction, except those hybrid tuners do have, is that in dual mode only 
packed video formats are allowed for analog, since planar formats are using DMA 
channel five, which is already in use by the TS interface then.

> I know a driver that does:

Me too ;) and Trent tested on cx88xx, IIRC.
 
> cx18 can handle simultaneous streaming of DTV and analog.

Yup. Not to talk about recent PCIe devices.
During I'm writing this I watch DVB-S, DVB-T and Composite at once on a
single saa7231e on vista. Supports also S2 and HDTV, vbi and radio and can
have a dual remote interface.
http://www.creatix.de/produkte/multimedia/ctx1924.htm

> Some cards have both an analog and digital tuner, so both DTV and analog
> can come from an RF source simultaneously.  (No locking needed really.)

We have quite some such cards with two tuners on the saa7134 since 2005.
Also such with three and even four tuners, two of them hybrid.

Even the simplest variant, say with a single DVB-S only tuner, can still have external 
analog baseband at once from TV, STB, VCR or whatever.

> Some cards only have one tuner, which means simultaneous streaming is
> limited to DTV from RF and analog from baseband inputs.  Streaming
> analog from an RF source on these cards precludes streaming of DTV.  (An
> odd locking ruleset when you consider MPEG, YUV, PCM, and VBI from the
> bridge chip can independently be streamed from the selected analog
> source to 4 different device nodes.)

On that mentioned Medion Quad md8080/CTX944 it becomes even more interesting.
Each of the two PCI bridges can only handle one digital and one analog stream at once.
That one must know.

And if RF loopthrough is enabled or not is another important point for its usage configuration.
For the two hybrid tuners it is a manual switch the driver doesn't know about.

For the two DVB-S tuners it could be switchable in software and one of the LNB connectors
could even be used as RF out to another device. (Has usage restrictions)

The user can make a lot of decisions how to use such a card and for sure doesn't want
to have any limitations only because of the hybrid tuners.

Cheers,
Hermann
 
> Regards,
> Andy
> 



Frohe Ostern! Alles für's Fest der Hasen und Lämmer jetzt im Osterspecial auf Arcor.de: http://www.arcor.de/rd/footer.ostern
