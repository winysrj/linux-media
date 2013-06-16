Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47458 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755458Ab3FPXpZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jun 2013 19:45:25 -0400
Date: Mon, 17 Jun 2013 02:44:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media ML <linux-media@vger.kernel.org>
Subject: Re: double-buffering with the omap3 parallel interface
Message-ID: <20130616234449.GB2064@valkosipuli.retiisi.org.uk>
References: <51B89EDA.90107@matrix-vision.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B89EDA.90107@matrix-vision.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Wed, Jun 12, 2013 at 06:16:26PM +0200, Michael Jones wrote:
> Hi Laurent & co.,
> 
> I'd like to look at what the maximum possible frame rates are for a
> sensor connected to the OMAP3 ISP CCDC via the parallel interface,
> writing frames directly to memory.  I understand that there is some
> minimum amount of time required between frames to pass on the
> finished frame and set up the address to be written to for the next
> frame.  From the manual it looks like a double buffering scheme
> would've been available on a different sensor interface, but isn't
> on the parallel one.
> 
> Do I see that right?  Is it impossible to use double buffering of
> any sort while using the parallel interface to memory?
> 
> I'm still using an older version of the driver, but I've browsed the
> current state of the code, too.  What behavior do you expect if the
> time between frames is too short for the buffer management?  Can it
> be recovered from?  Has this behavior changed in recent versions?
> 
> I see from the ISP block diagram that the "circular buffer" is
> between the SBL and the MMU.  Could this maybe be used to help the
> situation? It seems to currently not be used at all along this path.

The way the hardware is controlled has stayed the same for a very long time.
My recollection matches with your findings --- even if double buffering of
the buffer pointers would be available in some situations, it isn't used by
the driver. You might ask why, and the reason for that is that there are
tonds of other things that typically need to be configured (as a result of
the configuration given by the user using the private IOCTLs) at that very
time. If a block becomes busy while you're configuring it you can say good
bye to your frame in any case; whether yousd set up writing it to system
memory using DMA or not...

What comes to the minimum time per frames, I could give you a guesstimate of
1 ms. It depends a lot on how well other drivers in the system behave, but
in general that should be enough. Something must be very wrong if you need
significantly more than that.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
