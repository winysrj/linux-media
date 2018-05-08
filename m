Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46088 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754223AbeEHJQl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 05:16:41 -0400
Date: Tue, 8 May 2018 12:16:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sami Tolvanen <samitolvanen@google.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Kees Cook <keescook@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] media: media-device: fix ioctl function types
Message-ID: <20180508091638.td5soyelqhdarkaf@valkosipuli.retiisi.org.uk>
References: <20180507104509.lq4ep22fm6h53gra@valkosipuli.retiisi.org.uk>
 <20180507180946.104340-1-samitolvanen@google.com>
 <829b07f9-a41f-9c0f-c4c3-32056c91cd72@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <829b07f9-a41f-9c0f-c4c3-32056c91cd72@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 08, 2018 at 10:08:41AM +0200, Hans Verkuil wrote:
> Hi Sami,
> 
> This is unchanged from the previous version, right? I've already added that to a
> pull request.

Casting has been removed from the void pointers as I suggested. That's the
difference.

> 
> If this v2 has changes, then let me know asap.
> 
> Regards,
> 
> 	Hans
> 
> On 05/07/2018 08:09 PM, Sami Tolvanen wrote:
> > This change fixes function types for media device ioctls to avoid
> > indirect call mismatches with Control-Flow Integrity checking.
> > 
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > ---
> >  drivers/media/media-device.c | 21 +++++++++++----------
> >  1 file changed, 11 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 35e81f7c0d2f1..ae59c31775557 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -54,9 +54,10 @@ static int media_device_close(struct file *filp)
> >  	return 0;
> >  }
> >  
> > -static int media_device_get_info(struct media_device *dev,
> > -				 struct media_device_info *info)
> > +static long media_device_get_info(struct media_device *dev, void *arg)
> >  {
> > +	struct media_device_info *info = arg;
> > +
> >  	memset(info, 0, sizeof(*info));
> >  
> >  	if (dev->driver_name[0])
> > @@ -93,9 +94,9 @@ static struct media_entity *find_entity(struct media_device *mdev, u32 id)
> >  	return NULL;
> >  }
> >  
> > -static long media_device_enum_entities(struct media_device *mdev,
> > -				       struct media_entity_desc *entd)
> > +static long media_device_enum_entities(struct media_device *mdev, void *arg)
> >  {
> > +	struct media_entity_desc *entd = arg;
> >  	struct media_entity *ent;
> >  
> >  	ent = find_entity(mdev, entd->id);
> > @@ -146,9 +147,9 @@ static void media_device_kpad_to_upad(const struct media_pad *kpad,
> >  	upad->flags = kpad->flags;
> >  }
> >  
> > -static long media_device_enum_links(struct media_device *mdev,
> > -				    struct media_links_enum *links)
> > +static long media_device_enum_links(struct media_device *mdev, void *arg)
> >  {
> > +	struct media_links_enum *links = arg;
> >  	struct media_entity *entity;
> >  
> >  	entity = find_entity(mdev, links->entity);
> > @@ -195,9 +196,9 @@ static long media_device_enum_links(struct media_device *mdev,
> >  	return 0;
> >  }
> >  
> > -static long media_device_setup_link(struct media_device *mdev,
> > -				    struct media_link_desc *linkd)
> > +static long media_device_setup_link(struct media_device *mdev, void *arg)
> >  {
> > +	struct media_link_desc *linkd = arg;
> >  	struct media_link *link = NULL;
> >  	struct media_entity *source;
> >  	struct media_entity *sink;
> > @@ -225,9 +226,9 @@ static long media_device_setup_link(struct media_device *mdev,
> >  	return __media_entity_setup_link(link, linkd->flags);
> >  }
> >  
> > -static long media_device_get_topology(struct media_device *mdev,
> > -				      struct media_v2_topology *topo)
> > +static long media_device_get_topology(struct media_device *mdev, void *arg)
> >  {
> > +	struct media_v2_topology *topo = arg;
> >  	struct media_entity *entity;
> >  	struct media_interface *intf;
> >  	struct media_pad *pad;
> > 
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
