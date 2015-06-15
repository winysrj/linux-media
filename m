Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:51259 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbbFOBr5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2015 21:47:57 -0400
Date: Sun, 14 Jun 2015 22:47:51 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>, sakari.ailus@iki.fi
Subject: Re: [PATCH v2] Kconfig: disable Media Controller for DVB
Message-ID: <20150614224751.4694b5e6@recife.lan>
In-Reply-To: <3796364.09HDV5HO0h@avalon>
References: <95e2a872eef0289e19e104d520abd69709899e3a.1434108678.git.mchehab@osg.samsung.com>
	<3796364.09HDV5HO0h@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,

Em Sat, 13 Jun 2015 10:36:44 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> (CC'ing Sakari)
> 
> Thank you for the patch.
> 
> On Friday 12 June 2015 08:31:26 Mauro Carvalho Chehab wrote:
> > Since when we start discussions about the usage Media Controller
> > for complex hardware, one thing become clear: the way it is, MC
> > fails to map anything more complex than a webcam.
> 
> I strongly disagree with that. The MC API works fine (albeit with entity type 
> names that are incorrect) on complex embedded video capture devices that are 
> far from being just webcams. However, I agree that the API is broken outside 
> of the V4L realm.

By assuming that all V4L devices have DMA engines, it means that MC
is broken *inside* V4L realm too.

The very first V4L devices didn't have DMA at all. Radio devices
(with is V4L realm since the beginning too) don't have DMA, or when they
have, this don't appear at the data flow at the V4L side.

Also, calling a V4L data I/O engine as DEVNODE is broken by design. 
The devnode is something else that may or may not have data I/O.
Ok, by coincidence, the V4L devices currently mapped via MC have
the data I/O engine accessible via a devnode, but this was never be
a requirement of the V4L2 API.

It is also broken for ALSA, and it is partially broken for DVB.

The only scenario where MC works properly, ATM, is just the video
path of capture/output/m2m devices.

So, no, it doesn't work for complex embedded media devices, where
audio, tuners, radio, no-dma video, etc may be present.

So, i'll rewrite (tomorrow morning) the above paragraph to:

	Since when we start discussions about the usage Media Controller
	for complex hardware, one thing become clear: the way it is, MC
	fails to map anything different than capture/output/m2m
	video-only streaming.

in order to better express that.

> 
> > The point is that MC has entities named as devnodes, but the only
> > devnode used (before the DVB patches) is MEDIA_ENT_T_DEVNODE_V4L.
> > Due to the way MC got implemented, however, this entity actually
> > doesn't represent the devnode, but the hardware I/O engine that
> > receives data via DMA.
> > 
> > By coincidence, such DMA is associated with the V4L device node
> > on webcam hardware, but this is not true even for other V4L2
> > devices. For example, on USB hardware, the DMA is done via the
> > USB controller. The data passes though a in-kernel filter that
> > strips off the URB headers. Other V4L2 devices like radio may not
> > even have DMA. When it have, the DMA is done via ALSA, and not
> > via the V4L devnode.
> > 
> > In other words, MC is broken as a whole, but tagging it as BROKEN
> > right now would do more harm than good.
> > 
> > So, instead, let's mark, for now, the DVB part as broken and
> > block all new changes to MC while we fix this mess, whith
> > we hopefully will do for the next Kernel version.
> > 
> > Requested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> I'm fine with the change, but I'd rework the commit message a bit.
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> > diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> > index 3ef0f90b128f..157099243d61 100644
> > --- a/drivers/media/Kconfig
> > +++ b/drivers/media/Kconfig
> > @@ -97,6 +97,7 @@ config MEDIA_CONTROLLER
> >  config MEDIA_CONTROLLER_DVB
> >  	bool "Enable Media controller for DVB"
> >  	depends on MEDIA_CONTROLLER
> > +	depends on BROKEN
> >  	---help---
> >  	  Enable the media controller API support for DVB.
> 
