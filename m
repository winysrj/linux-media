Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:50538 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391AbZDFBxN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 21:53:13 -0400
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
	model
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
Cc: Jean Delvare <khali@linux-fr.org>, Janne Grunau <j@jannau.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jarod@redhat.com>
In-Reply-To: <1238968804.4647.22.camel@morgan.walls.org>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	 <20090405010539.187e6268@hyperion.delvare>
	 <200904050746.47451.hverkuil@xs4all.nl> <20090405143748.GC10556@aniel>
	 <1238953174.3337.12.camel@morgan.walls.org> <20090405183154.GE10556@aniel>
	 <1238957897.3337.50.camel@morgan.walls.org>
	 <20090405222250.64ed67ae@hyperion.delvare>
	 <1238966523.6627.63.camel@pc07.localdom.local>
	 <1238968804.4647.22.camel@morgan.walls.org>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 03:49:57 +0200
Message-Id: <1238982597.3697.12.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Andy,

Am Sonntag, den 05.04.2009, 18:00 -0400 schrieb Andy Walls:
> On Sun, 2009-04-05 at 23:22 +0200, hermann pitton wrote:
> > Am Sonntag, den 05.04.2009, 22:22 +0200 schrieb Jean Delvare:
> > > On Sun, 05 Apr 2009 14:58:17 -0400, Andy Walls wrote:
> 
> 
> > What can not be translated to the input system I would like to know.
> > Andy seems to have closer looked into that.
> 
> 1. IR blasting: sending IR codes to transmit out to a cable convertor
> box, DTV to analog convertor box, or similar devices to change channels
> before recording starts.  An input interface doesn't work well for
> output.
> 
> 2. Sending raw IR samples to user space: user space applications can
> then decode or match an unknown or non-standard IR remote protocol in
> user space software.  Timing information to go along with the sample
> data probably needs to be preserved.   I'm assuming the input interface
> currently doesn't support that.
> 
> That's all the Gerd mentioned.
> 
> 
> One more nice feature to have, that I'm not sure how easily the input
> system could support:
> 
> 3. specifying remote control code to key/button translations with a
> configuration file instead of recompiling a module.
> 
> In effect there are actually two devices the ir-kbd-i2c input driver is
> supporting in various combinations: an IR receiver and an IR remote.
> 
> 
> Regards,
> Andy
> 

you always end up with something transmitting series of 0s and 1s.

It does not matter if the medium is infrared, infradead ;), wireless or
whats or ever.

If it spares a chip for the remote and you have to get it from IRQs
triggered, you have to do that.

It could also be some voltage change, a ultrasound beeper or what ever.

The first place for such is the input layer and nothing out of the
kernel.

Cheers,
Hermann


