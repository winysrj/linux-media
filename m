Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:43416 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955AbZFNTIU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 15:08:20 -0400
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Muralidharan Karicheri <m-karicheri2@ti.com>,
	  Linux Media Mailing List <linux-media@vger.kernel.org>,
	  Magnus Damm <magnus.damm@gmail.com>,
	  Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	  Darius Augulis <augulis.darius@gmail.com>
Subject: Re: [PATCH] adding support for setting bus parameters in sub device
References: <62904.62.70.2.252.1244810776.squirrel@webmail.xs4all.nl>
	<Pine.LNX.4.64.0906121454410.4843@axis700.grange>
	<200906121800.51177.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.0906141719510.4412@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 14 Jun 2009 21:08:12 +0200
Message-ID: <87ab4a7hwj.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let's begin the maintainers party.

> A board designer knows what the host supports, knows what the sensor 
> supports, and knows if he added any inverters on the board, and based on 
> all that information he can just setup these parameters for the sensor 
> chip. Settings that are fixed on the sensor chip he can just ignore, he 
> only need to specify those settings that the sensor really needs.
I don't think that's true Hans.
A lot of mainline's kernel boards have been written by passionate people, having
no access to boards layout (for pxa, the includes corgi, tosa, hx4700, mioa701,
all palm series, ...)

For these people, having an "autonegociation algorithm" is one less thing to
bother about.

> > In my opinion you should always want to set this explicitly. This is not
> > something you want to leave to chance. Say you autoconfigure this. Now
> > someone either changes the autoconf algorithm, or a previously undocumented
> > register was discovered for the i2c device and it can suddenly configure the
> > polarity of some signal that was previously thought to be fixed, or something
> > else happens causing a different polarity to be negotiated.
If you're afraid of side effects, you can force the polarity in board code with
the current framework.

If we reduce the current autonegociation code to polarity (forget bus witdh,
...) :
 - if board coder sets unique polarities, they'll be chosen (1)
 - if board coder doesn't set them, the autonegociation algorithm will choose
   (2)

What you want to do is to force all board developers to explicitely polarities,
to only use subset (1) of current negociation algorithm. I see no technical
point motivating this. The existing algorithm is richer.

Personnaly, I'll consider that reducing soc_camera framework to (1) instead of
(1)+(2) is a regretable regression. As part of the board maintaineers having no
access to my board's design, I find the current framework a help.

I still don't understand clearly why delete (2) from current framework. As I
said, "the board designer knows polarities" doesn't stand in our communauty
where board are developped without prior knowledge.

So Hans, why do you want to delete (2) ?

--
Robert
