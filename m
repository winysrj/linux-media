Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60519 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932996Ab2HPQfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 12:35:03 -0400
Date: Thu, 16 Aug 2012 19:34:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sebastian Reichel <sre@ring0.de>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Timo Kokkonen <timo.t.kokkonen@iki.fi>
Subject: Re: [git:v4l-dvb/for_v3.7] [media] media: rc: Introduce RX51 IR
 transmitter driver
Message-ID: <20120816163458.GA29636@valkosipuli.retiisi.org.uk>
References: <E1T10iu-0000Xo-L8@www.linuxtv.org>
 <20120815160621.GV29636@valkosipuli.retiisi.org.uk>
 <502BFCA3.5040905@iki.fi>
 <20120816102328.GW29636@valkosipuli.retiisi.org.uk>
 <20120816112103.GA1429@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816112103.GA1429@earth.universe>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

On Thu, Aug 16, 2012 at 01:21:04PM +0200, Sebastian Reichel wrote:
> Hi,
> 
> > > It was an requirement back then that this driver needs to be a module as
> > > 99% of the N900 owners still don't even know they have this kind of
> > > capability on their devices, so it doesn't make sense to keep the module
> > > loaded unless the user actually needs it.
> > 
> > I don't think that's so important --- currently the vast majority of the
> > N900 users using the mainline kernel compile it themselves. It's more
> > important to have a clean implementation at this point.
> 
> I would like to enable this feature for the Debian OMAP kernel,
> which is not only used for N900, but also for Pandaboard, etc.

Fair enough. Thanks for the info!

Timo: thinking this a little more, do you think the call is really needed?
AFAIU it doesn't really achieve what it's supposed to, keeping the CPU from
going to sleep. I noticed exactly the same problem you did, it was bad to
the extent irsend failed due to a timeout unless I kept the CPU busy.

So I think we can remove the call, which results in two things: the driver
can be built as a module and the platform data does not contain a function
pointer any longer.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
