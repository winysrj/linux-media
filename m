Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52843 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab3KDOZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 09:25:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] as3645a: Remove set_power() from platform data
Date: Mon, 04 Nov 2013 15:26:18 +0100
Message-ID: <153733006.kznvhivZ59@avalon>
In-Reply-To: <20131102214302.GA21655@valkosipuli.retiisi.org.uk>
References: <1337137969-30575-1-git-send-email-sakari.ailus@iki.fi> <20120523120641.GV3373@valkosipuli.retiisi.org.uk> <20131102214302.GA21655@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Saturday 02 November 2013 23:43:02 Sakari Ailus wrote:
> On Wed, May 23, 2012 at 03:06:41PM +0300, Sakari Ailus wrote:
> > On Wed, May 23, 2012 at 01:31:26PM +0200, Laurent Pinchart wrote:
> > > Hi Sakari,
> > 
> > ...
> > 
> > > > > If the chip is powered on constantly, why do we need a .s_power()
> > > > > subdev
> > > > > operation at all ?
> > > > 
> > > > I don't know why was it there in the first place. Probably to make it
> > > > easier to use the driver on boards that required e.g. a regulator for
> > > > the chip.
> > > > 
> > > > But typically they're connected to battery directly. The idle power
> > > > consumption is just some tens of µA.
> > > 
> > > What about on the N9 ?
> > 
> > That function pointer is NULL for N9. I used to configure the GPIOs but
> > that was wrong in the first place.
> 
> Ping.
> 
> Should we either remove the s_power() callback altogether or just the
> platform data callback function (which is unused)?
> 
> It is indeed possible that the device was powered from a regulator which
> isn't always on but we don't have such use cases right now.

I would remove the platform callback only. The s_power() function currently 
turns the torch when called to disable power, which is a sane thing to do. 
Your patch moves that to the call sites, but I believe it would be easier to 
keep the current __as3645a_set_power() function, especially if we later need 
to add support for regulators. Would that be fine with you ?

-- 
Regards,

Laurent Pinchart

