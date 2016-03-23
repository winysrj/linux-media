Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56680 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343AbcCWRfg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 13:35:36 -0400
Date: Wed, 23 Mar 2016 14:35:30 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Rafael =?UTF-8?B?TG91cmVuw6dv?= de Lima Chehab
	<chehabrafael@gmail.com>, <alsa-devel@alsa-project.org>
Subject: Re: [PATCH v2] [media] media-device: use kref for media_device
 instance
Message-ID: <20160323143530.695af1c3@recife.lan>
In-Reply-To: <1547540.zgadtG4fpe@avalon>
References: <9d8830150475bc4d4dde2fa1f5163aef82a35477.1458347578.git.mchehab@osg.samsung.com>
	<1547540.zgadtG4fpe@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for reviewing it.

Em Wed, 23 Mar 2016 18:57:50 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> On Friday 18 Mar 2016 21:42:16 Mauro Carvalho Chehab wrote:
> > Now that the media_device can be used by multiple drivers,
> > via devres, we need to be sure that it will be dropped only
> > when all drivers stop using it.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > ---
> > 
> > v2: The kref is now used only when media_device is allocated via
> >     the media_device*_devress. This warrants that other drivers won't be
> >     affected, and that we can keep media_device_cleanup() balanced with
> >     media_device_init().
> > 
> >  drivers/media/media-device.c           | 117 ++++++++++++++++++++++--------
> >  drivers/media/usb/au0828/au0828-core.c |   3 +-
> >  include/media/media-device.h           |  28 ++++++++
> >  sound/usb/media.c                      |   3 +-
> >  4 files changed, 118 insertions(+), 33 deletions(-)
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index c32fa15cc76e..4a97d92a7e7d 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -707,11 +707,16 @@ void media_device_init(struct media_device *mdev)
> >  }
> >  EXPORT_SYMBOL_GPL(media_device_init);
> > 
> > -void media_device_cleanup(struct media_device *mdev)
> > +static void __media_device_cleanup(struct media_device *mdev)
> >  {
> >  	ida_destroy(&mdev->entity_internal_idx);
> >  	mdev->entity_internal_idx_max = 0;
> >  	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
> > +}
> > +
> > +void media_device_cleanup(struct media_device *mdev)
> > +{
> > +	__media_device_cleanup(mdev);
> >  	mutex_destroy(&mdev->graph_mutex);
> >  }
> >  EXPORT_SYMBOL_GPL(media_device_cleanup);
> > @@ -721,6 +726,9 @@ int __must_check __media_device_register(struct
> > media_device *mdev, {
> >  	int ret;
> > 
> > +	/* Check if mdev was ever registered at all */  
> 
> This comment doesn't seem to apply to the next line, is it a leftover ? If so, 
> please remove it.

Yes, it is a left over. I'll remove it. Thanks for noticing it.

Thanks,
Mauro
