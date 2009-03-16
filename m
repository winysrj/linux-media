Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51279 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbZCPPcN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 11:32:13 -0400
Date: Mon, 16 Mar 2009 12:31:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
Message-ID: <20090316123106.36704382@pedra.chehab.org>
In-Reply-To: <20090316152802.7492dd20@hyperion.delvare>
References: <200903151344.01730.hverkuil@xs4all.nl>
	<20090315181207.36d951ac@hyperion.delvare>
	<Pine.LNX.4.58.0903151038210.28292@shell2.speakeasy.net>
	<20090315185313.4c15702c@hyperion.delvare>
	<20090316063402.1b0da1f3@gaivota.chehab.org>
	<20090316121801.1c03d747@hyperion.delvare>
	<20090316095237.21775418@gaivota.chehab.org>
	<20090316152802.7492dd20@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I need to be short, since I'm about to travel.

On Mon, 16 Mar 2009 15:28:02 +0100
Jean Delvare <khali@linux-fr.org> wrote:


> Ah yeah, now I remember. You're the one who considers 2.6.18 a bleeding
> edge kernel suitable for upstream development. This explains a lot.

I have 3 separated environments, being the first with the bleeding edge Fedora
rawhide core (2.6.29-rc-git + several linux-next patches), for development. For
sure, this is not stable, and an intermediate with 2.6.27 (Fedora 10), for normal tests.

But for sure I don't want to loose time or data running my production data on
an unstable environment. Then, I use RHEL5 on my main machines: it is rock solid.

On all of those environments, I need my devices properly working with the
bleeding edge v4l/dvb drivers.
> 
> > will almost certainly cause compatibility breakages. I can't see any gain to
> > the end user of a board that it is properly supported that such change would do.
> 
> I'm literally speechless.

What's the gain of the change for a user whose card already works? If
everything went ok, he will just have what he had before. The difference
affects only users of boards not supported yet (or badly supported).

> > The reasons I see are in order to provide a more consistent internal model
> > to represent the devices, and to support devices with more complex approaches
> > like devices that have some I2C muxes and switches on their buses, to solve the
> > address problems we're currently facing with such devices.
> 
> Abstracting the numerous improvements brought by the new binding model
> for older devices, which by themselves justify the move IMHO, the key
> issue here is that the old model and the new model do not mix properly.
> The different device lifetime cycles make it pretty much impossible to
> come up with a sane locking model. This is the reason why I want the
> legacy model to die now.

Ok, that's the reason why we're changing: we need the new model for a small
subset of devices (5%? maybe even less). On those devices, I2C switches do
exist and this causes troubles with the old model. Since both models don't mix,
we're migrating even the drivers that won't need such model.

> > > Also, please let's not lose focus here. The important thing here is to
> > > finish the conversion to the new i2c device driver binding model, and
> > > quickly.
> > 
> > For finishing the conversion, I agree that we just need some kind of workaround
> > to allow both IR and Audio to work, but we shouldn't loose how it would be done
> > in the final version.
> 
> For finishing the conversion, we don't need to do anything. The
> PIC16C54 support is already broken today if I understood Hans
> correctly. We certainly want to fix that someday, but this is unrelated
> to the model conversion.

It may or may not work. With the current behaviour, someone may load either
driver (IR or audio). So, both things work, but not simultaneously.

Anyway, you got me wrong: I don't think that pic16c54 is an enough reason for
justify any changes on the i2c model.

However, there are several devices that have processors connected via i2c
(including several DVB based devices using Cypress processors). IMO, we will
need sooner or later some solution for using the sub-address as a different
device, but we may postpone such discussion to another time.

Cheers,
Mauro
