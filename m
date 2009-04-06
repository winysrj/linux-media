Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:38670 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756586AbZDFVPs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2009 17:15:48 -0400
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
	model
From: hermann pitton <hermann-pitton@arcor.de>
To: Jean Delvare <khali@linux-fr.org>, Mark Schultz <n9xmj@yahoo.com>,
	Brian Rogers <brian_rogers@comcast.net>,
	Oldrich Jedlicka <oldium.pro@seznam.cz>
Cc: Andy Walls <awalls@radix.net>, Janne Grunau <j@jannau.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jarod@redhat.com>
In-Reply-To: <20090406104045.58da67c7@hyperion.delvare>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	 <20090405010539.187e6268@hyperion.delvare>
	 <200904050746.47451.hverkuil@xs4all.nl> <20090405143748.GC10556@aniel>
	 <1238953174.3337.12.camel@morgan.walls.org> <20090405183154.GE10556@aniel>
	 <1238957897.3337.50.camel@morgan.walls.org>
	 <20090405222250.64ed67ae@hyperion.delvare>
	 <1238966523.6627.63.camel@pc07.localdom.local>
	 <20090406104045.58da67c7@hyperion.delvare>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 23:10:36 +0200
Message-Id: <1239052236.4925.20.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean,

Am Montag, den 06.04.2009, 10:40 +0200 schrieb Jean Delvare:
> On Sun, 05 Apr 2009 23:22:03 +0200, drunk and tired hermann pitton wrote:

don't tell me the French vine is always better.
You likely know who introduced that currency once :)

> > Hmm, I'm still "happy" with the broken DVB-T for saa7134 on 2.6.29,
> > tasting some Chianti vine now and need to sleep soon, but I'm also not
> > that confident that your saa7134 MSI TV@nywhere Plus i2c remote does
> > work addressing it directly, since previous reports always said it
> > becomes only visible at all after other devices are probed previously.
> > 
> > Unfortunately I can't test it, but will try to reach some with such
> > hardware and ask for testing, likely not on the list currently.
> 
> Thanks for the heads up. I was curious about this as well. The original
> comment said that the MSI TV@nywhere Plus IR receiver would not respond
> to _probes_ before another device on the I2C bus was accessed. I didn't
> know for sure if this only applied to the probe sequence or to any
> attempt to access the IR receiver. As we no longer need to probe for
> the device, I thought it may be OK to remove the extra code. But
> probably the removal of the extra code should be delayed until we find
> one tester to confirm the exact behavior. Here, done.
> 
> Anyone out there with a MSI TV@nywhere Plus that could help with
> testing?

Here is a link to one of the initial reports by Henry, others are close
to it.

http://marc.info/?l=linux-video&m=113324147429459&w=2

There are two different variants of that MSI card, but that undocumented
KS003 chip is the same on them.

We still have lots of for the remote unsupported cards with KS chips,
many from Kworld. Some of these chips are also seen on cx88xx cards
already and other drivers may follow.

Henry doesn't have this card anymore, but maybe Mark and Brian can test
and Oldrich might give feedback for the Avermedia.

Cheers,
Hermann




