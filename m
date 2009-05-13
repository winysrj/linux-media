Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:59274 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZEMGEP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2009 02:04:15 -0400
Date: Wed, 13 May 2009 08:59:02 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Cc: ext Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>
Subject: Re: [PATCH v2 0/7] [RFC] FM Transmitter (si4713) and another
	changes
Message-ID: <20090513055901.GK4639@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <53599.62.70.2.252.1242114622.squirrel@webmail.xs4all.nl> <20090512075519.GG4639@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512075519.GG4639@esdhcp037198.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 12, 2009 at 09:55:19AM +0200, Valentin Eduardo (Nokia-D/Helsinki) wrote:
> > >>
> > >> What sort of platform data do you need to pass to the i2c driver? I have
> > >> yet
> > >> to see a valid use case for this that can't be handled in a different
> > >> way.
> > >> Remember that devices like this are not limited to fixed platforms, but
> > >> can
> > >> also be used in USB or PCI devices.
> > >
> > > Yes, sure. Well, a simple "set_power" procedure is an example of things
> > > that
> > > I see as platform specific. Which may be passed by platform data
> > > structures.
> > > In some platform a set power / reset line may be done by a simple gpio.
> > > but
> > > in others it may be a different procedure.
> > 
> > The v4l2_device struct has a notify callback: you can use that one
> > instead. That way the subdev driver doesn't have to have any knowledge
> > about the platform it is used in.
> 
> Right. I see. But in that case the brigde driver would be bound to
> a board specific? For instance of this very driver, I wrote a platform
> driver just to make its radio interface. But I don't think it is a good
> idea to bound the platform driver to a board specific creating a notification
> handler just to set the power of the i2c chip. I see this procedure as a board
> specific thing. As well as the IRQ line for instance. That configuration is
> also board specific. Which is usually passed using i2c board info. Correct me
> if I'm wrong.

Even though I still can pass board specific to the platform driver using
its platform data and then use the notify callback of v4l2_device, I still
will miss the configuration for IRQ line. I don't see how to pass that to
the i2c subdev by using the current helper functions.

> 
> > 
> > Regards,
> > 
> >         Hans
> > 
> > -- 
> > Hans Verkuil - video4linux developer - sponsored by TANDBERG
> 
> -- 
> Eduardo Valentin

-- 
Eduardo Valentin
