Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45146 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751592AbcCNLnl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 07:43:41 -0400
Date: Mon, 14 Mar 2016 13:43:33 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Any reason why media_entity_pads_init() isn't void?
Message-ID: <20160314114332.GR11084@valkosipuli.retiisi.org.uk>
References: <56E6758F.7020205@xs4all.nl>
 <20160314103643.GP11084@valkosipuli.retiisi.org.uk>
 <20160314082738.3b84ed0a@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160314082738.3b84ed0a@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Mar 14, 2016 at 08:27:38AM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 14 Mar 2016 12:36:44 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Hans,
> > 
> > On Mon, Mar 14, 2016 at 09:25:51AM +0100, Hans Verkuil wrote:
> > > I was fixing a sparse warning in media_entity_pads_init() and I noticed
> > > that that function always returns 0. Any reason why this can't be changed
> > > to a void function?  
> > 
> > I was thinking of the same function but I had a different question: why
> > would one call this *after* entity->graph_obj.mdev is set? It is set by
> > media_device_register_entity(), but once mdev it's set, you're not expected
> > to call pads_init anymore...
> 
> Ideally, drivers should *first* create mdev, and then create the
> graph objects, as all objects should be registered at the mdev, in
> order to get their object ID and to be registered at the mdev's object
> lists.

Right. I think it wouldn't hurt to have some comment hints in what's there
for legacy use cases... I can submit patches for some of these.

Currently what works is that you can register graph objects until the media
device node is exposed to the user. We don't have proper serialisation in
place to do that, do we? At least the framework functions leave it up to the
caller.

I think it wouldn't be a bad idea either to think about the serialisation
model a bit. It's been unchanged from the day one basically.

> However, some legacy drivers used to do just the reverse. So, we had
> to add a code there, and at media_device_register_entity() to support
> the drivers that postpone the creation of the mdev instance.
> 
> Once this gets fixed everywhere, we can remove the code that supports
> the legacy behavior.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
