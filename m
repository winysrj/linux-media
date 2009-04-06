Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41262 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbZDFNIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 09:08:43 -0400
Date: Mon, 6 Apr 2009 10:08:25 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Walls <awalls@radix.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
Message-ID: <20090406100825.368d6db9@pedra.chehab.org>
In-Reply-To: <1238935455.3151.64.camel@palomino.walls.org>
References: <20090404142427.6e81f316@hyperion.delvare>
	<Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	<20090405010539.187e6268@hyperion.delvare>
	<200904050746.47451.hverkuil@xs4all.nl>
	<20090405061432.4165eabf@pedra.chehab.org>
	<1238935455.3151.64.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 05 Apr 2009 08:44:15 -0400
Andy Walls <awalls@radix.net> wrote:

> The scope of a complete kernel IR infrastructure goes a bit beyond I2C
> bus devices that are only input devices.
> 
> What's the scope of what you want to tackle here?
> 
> I certainly don't want to reinvent something that's going to look just
> like the LIRC driver model:
> 
> http://www.lirc.org/html/technical.html
> 
> Which already has an infrastructure for IR driver module writers:
> http://www.lirc.org/html/technical.html#lirc_dev

As other out-of-tree drivers that have a long trip, I suspect that lirc did
some assumptions, while event and v4l did different ones. Due to kernel rules
to keep API's forever, we should take some care to avoid breaking the existing
API in favor to another one. So, this probably means some lirc redesign, in
order to get his way to kernel, on a similar path that ivtv driver did.

The part of lirc that I'm concerned with are the ones that work with GPIO and
I2C devices and the API.

> Do we just convert lirc_dev, lirc_i2c, and lirc_zilog to a cleaned up
> set of in kernel modules? 

We should cover also the lirc gpio module(s).

> lirc_i2c can certainly be broken up into
> several modules: 1 per supported device.

I don't think that breaking it into one per device is the better approach. IMO,
we need a common i2c glue (like what ir-kbd-i2c provides, if we remove the
legacy stuff) that it is IR independent. the IR dependent parts can be part of
ir-common module or eventually we can split it into sub-modules.

> Should these create an input
> device as well to maintain compatability with apps expecting an
> ir-kbd-i2c like function?

For sure. The event interface is the kernel way for input devices. There are
also other IR devices (like IR mouses and keyboards) already handled via
input/event interface.

On a first glance, I don't see the need to exporting raw data to userspace,
although I understand why lirc needs this currently.

> Or do we split up ir-kbd-i2c into per device modules and in addition to
> the input event interface, have it register with the lirc_dev module?
> 
> Do we leverage LIRC's lirc_dev infrastructure module at all? (I think it
> would be a waste of time not to do so.) 

IMO, the proper workflow would be to discuss lirc as a hole with Lirc people,
linux-media and input/event people.

Cheers,
Mauro
