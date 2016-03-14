Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44100 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755074AbcCNKgt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 06:36:49 -0400
Date: Mon, 14 Mar 2016 12:36:44 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: Any reason why media_entity_pads_init() isn't void?
Message-ID: <20160314103643.GP11084@valkosipuli.retiisi.org.uk>
References: <56E6758F.7020205@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56E6758F.7020205@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Mar 14, 2016 at 09:25:51AM +0100, Hans Verkuil wrote:
> I was fixing a sparse warning in media_entity_pads_init() and I noticed
> that that function always returns 0. Any reason why this can't be changed
> to a void function?

I was thinking of the same function but I had a different question: why
would one call this *after* entity->graph_obj.mdev is set? It is set by
media_device_register_entity(), but once mdev it's set, you're not expected
to call pads_init anymore...

I'm fine making this return void.

> 
> That return value is checked a zillion times in the media code. By making
> it void it should simplify code all over.
> 
> See e.g. uvc_mc_init_entity in drivers/media/usb/uvc/uvc_entity.c: that
> whole function can become a void function itself.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
