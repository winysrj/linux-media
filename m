Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40566 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751408Ab3KBVnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Nov 2013 17:43:37 -0400
Date: Sat, 2 Nov 2013 23:43:02 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] as3645a: Remove set_power() from platform data
Message-ID: <20131102214302.GA21655@valkosipuli.retiisi.org.uk>
References: <1337137969-30575-1-git-send-email-sakari.ailus@iki.fi>
 <5818890.hvZb7JEbAH@avalon>
 <20120523111951.GU3373@valkosipuli.retiisi.org.uk>
 <9767260.z6C75JdBQb@avalon>
 <20120523120641.GV3373@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120523120641.GV3373@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 23, 2012 at 03:06:41PM +0300, Sakari Ailus wrote:
> On Wed, May 23, 2012 at 01:31:26PM +0200, Laurent Pinchart wrote:
> > Hi Sakari,
> ...
> > > > If the chip is powered on constantly, why do we need a .s_power() subdev
> > > > operation at all ?
> > > 
> > > I don't know why was it there in the first place. Probably to make it easier
> > > to use the driver on boards that required e.g. a regulator for the chip.
> > > 
> > > But typically they're connected to battery directly. The idle power
> > > consumption is just some tens of µA.
> > 
> > What about on the N9 ?
> 
> That function pointer is NULL for N9. I used to configure the GPIOs but that
> was wrong in the first place.

Ping.

Should we either remove the s_power() callback altogether or just the
platform data callback function (which is unused)?

It is indeed possible that the device was powered from a regulator which
isn't always on but we don't have such use cases right now.

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
