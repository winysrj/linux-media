Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325AbcC2J2c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2016 05:28:32 -0400
Date: Tue, 29 Mar 2016 06:28:27 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 2/2] [media] avoid double locks with graph_mutex
Message-ID: <20160329062827.581a67d1@recife.lan>
In-Reply-To: <20160329061734.1a1a5291@recife.lan>
References: <91b3d9b66d52707ca95d996edd423c0f5e36b6ca.1459188623.git.mchehab@osg.samsung.com>
	<3cabc4b828abac3c6dea240ae22d4754a438ad1b.1459188623.git.mchehab@osg.samsung.com>
	<20160328220642.GD32125@valkosipuli.retiisi.org.uk>
	<20160329061734.1a1a5291@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 29 Mar 2016 06:17:34 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> > > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > > index 6cfa890af7b4..6af5e6932271 100644
> > > --- a/drivers/media/media-device.c
> > > +++ b/drivers/media/media-device.c
> > > @@ -93,7 +93,6 @@ static struct media_entity *find_entity(struct media_device *mdev, u32 id)
> > >  	media_device_for_each_entity(entity, mdev) {
> > >  		if (((media_entity_id(entity) == id) && !next) ||
> > >  		    ((media_entity_id(entity) > id) && next)) {
> > > -			mutex_unlock(&mdev->graph_mutex);    
> > 
> > Unrelated to this patch.  
> 
> Yes. This belongs to patch 1.
> 
> > 
> > Please do also consider compat IOCTL handling code.
> >   

Sorry, I forgot to mention this one on my previous email.

Compat32 handling is just:

        switch (cmd) {
       	case MEDIA_IOC_ENUM_LINKS32:
               	mutex_lock(&dev->graph_mutex);
                ret = media_device_enum_links32(dev,
                                (struct media_links_enum32 __user *)arg);
               	mutex_unlock(&dev->graph_mutex);
                break;

        default:
                return media_device_ioctl(filp, cmd, arg);
        }

and media_device_enum_links32() doesn't call an function with a
mutex. So, it is safe.

Thanks,
Mauro
