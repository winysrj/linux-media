Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:35753 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbZDGJ1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2009 05:27:39 -0400
Date: Tue, 7 Apr 2009 11:27:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Mark Schultz <n9xmj@yahoo.com>,
	Brian Rogers <brian_rogers@comcast.net>,
	Oldrich Jedlicka <oldium.pro@seznam.cz>,
	Andy Walls <awalls@radix.net>, Janne Grunau <j@jannau.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
  model
Message-ID: <20090407112715.6caf2e89@hyperion.delvare>
In-Reply-To: <1239052236.4925.20.camel@pc07.localdom.local>
References: <20090404142427.6e81f316@hyperion.delvare>
	<Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	<20090405010539.187e6268@hyperion.delvare>
	<200904050746.47451.hverkuil@xs4all.nl>
	<20090405143748.GC10556@aniel>
	<1238953174.3337.12.camel@morgan.walls.org>
	<20090405183154.GE10556@aniel>
	<1238957897.3337.50.camel@morgan.walls.org>
	<20090405222250.64ed67ae@hyperion.delvare>
	<1238966523.6627.63.camel@pc07.localdom.local>
	<20090406104045.58da67c7@hyperion.delvare>
	<1239052236.4925.20.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 06 Apr 2009 23:10:36 +0200, hermann pitton wrote:
> Am Montag, den 06.04.2009, 10:40 +0200 schrieb Jean Delvare:
> > Anyone out there with a MSI TV@nywhere Plus that could help with
> > testing?
> 
> Here is a link to one of the initial reports by Henry, others are close
> to it.
> 
> http://marc.info/?l=linux-video&m=113324147429459&w=2
> 
> There are two different variants of that MSI card, but that undocumented
> KS003 chip is the same on them.

Great, thanks for the pointer. If I understand correctly, the KS003
has a state machine flow which causes the chip to stop answering when
an invalid address is used on the bus and start answering again when a
valid address other than his own is used. As the old i2c model relied a
lot on probing, I am not surprised that this was a problem in the past.
But with the new model, probes should become infrequent, so I suspect
that the workaround may no longer be needed... except when i2c_scan=1
is used.

I'd rather keep the workaround in place for the time being, and only
once the ir-kbd-i2c changes have settled, try to remove it if someone
really cares.

-- 
Jean Delvare
