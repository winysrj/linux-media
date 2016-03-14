Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53631 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbcCNL1n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 07:27:43 -0400
Date: Mon, 14 Mar 2016 08:27:38 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Any reason why media_entity_pads_init() isn't void?
Message-ID: <20160314082738.3b84ed0a@recife.lan>
In-Reply-To: <20160314103643.GP11084@valkosipuli.retiisi.org.uk>
References: <56E6758F.7020205@xs4all.nl>
	<20160314103643.GP11084@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 14 Mar 2016 12:36:44 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Hans,
> 
> On Mon, Mar 14, 2016 at 09:25:51AM +0100, Hans Verkuil wrote:
> > I was fixing a sparse warning in media_entity_pads_init() and I noticed
> > that that function always returns 0. Any reason why this can't be changed
> > to a void function?  
> 
> I was thinking of the same function but I had a different question: why
> would one call this *after* entity->graph_obj.mdev is set? It is set by
> media_device_register_entity(), but once mdev it's set, you're not expected
> to call pads_init anymore...

Ideally, drivers should *first* create mdev, and then create the
graph objects, as all objects should be registered at the mdev, in
order to get their object ID and to be registered at the mdev's object
lists.

However, some legacy drivers used to do just the reverse. So, we had
to add a code there, and at media_device_register_entity() to support
the drivers that postpone the creation of the mdev instance.

Once this gets fixed everywhere, we can remove the code that supports
the legacy behavior.

Regards,
Mauro

> 
> I'm fine making this return void.
> 
> > 
> > That return value is checked a zillion times in the media code. By making
> > it void it should simplify code all over.
> > 
> > See e.g. uvc_mc_init_entity in drivers/media/usb/uvc/uvc_entity.c: that
> > whole function can become a void function itself.  
> 


-- 
Thanks,
Mauro
