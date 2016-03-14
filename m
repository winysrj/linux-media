Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53675 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbcCNLw4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 07:52:56 -0400
Date: Mon, 14 Mar 2016 08:52:51 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Any reason why media_entity_pads_init() isn't void?
Message-ID: <20160314085251.19698ae8@recife.lan>
In-Reply-To: <20160314114332.GR11084@valkosipuli.retiisi.org.uk>
References: <56E6758F.7020205@xs4all.nl>
	<20160314103643.GP11084@valkosipuli.retiisi.org.uk>
	<20160314082738.3b84ed0a@recife.lan>
	<20160314114332.GR11084@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 14 Mar 2016 13:43:33 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Mon, Mar 14, 2016 at 08:27:38AM -0300, Mauro Carvalho Chehab wrote:
> > Em Mon, 14 Mar 2016 12:36:44 +0200
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> >   
> > > Hi Hans,
> > > 
> > > On Mon, Mar 14, 2016 at 09:25:51AM +0100, Hans Verkuil wrote:  
> > > > I was fixing a sparse warning in media_entity_pads_init() and I noticed
> > > > that that function always returns 0. Any reason why this can't be changed
> > > > to a void function?    
> > > 
> > > I was thinking of the same function but I had a different question: why
> > > would one call this *after* entity->graph_obj.mdev is set? It is set by
> > > media_device_register_entity(), but once mdev it's set, you're not expected
> > > to call pads_init anymore...  
> > 
> > Ideally, drivers should *first* create mdev, and then create the
> > graph objects, as all objects should be registered at the mdev, in
> > order to get their object ID and to be registered at the mdev's object
> > lists.  
> 
> Right. I think it wouldn't hurt to have some comment hints in what's there
> for legacy use cases... I can submit patches for some of these.

Yeah, feel free to submit a patch for it. It could be good to add a
warn_once() that would hit for the legacy case too.

> 
> Currently what works is that you can register graph objects until the media
> device node is exposed to the user.

Yes.

> We don't have proper serialisation in
> place to do that, do we? At least the framework functions leave it up to the
> caller.
> 
> I think it wouldn't be a bad idea either to think about the serialisation
> model a bit. It's been unchanged from the day one basically.

Actually, the async logic does some sort of serialization, although it
doesn't enforce it.

Javier touched on some cases where the logic was not right, but he
didn't change everything. 

I agree with you here: it would be great to have this fixed in a better
way.

That's said, this affects only non-PCI/USB devices. On PCI/USB, the
main/bridge driver is always called first, and the subdev init only
happens after it registers the I2C bus.

-- 
Thanks,
Mauro
