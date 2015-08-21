Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59014 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbbHUKZg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 06:25:36 -0400
Date: Fri, 21 Aug 2015 07:25:31 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v6 6/8] [media] media: add messages when media device
 gets (un)registered
Message-ID: <20150821072531.7115aa4f@recife.lan>
In-Reply-To: <4280106.agOBtx2TYA@avalon>
References: <cover.1439981515.git.mchehab@osg.samsung.com>
	<f07fdec54485863d0db5710845d680f34709686b.1439981515.git.mchehab@osg.samsung.com>
	<4280106.agOBtx2TYA@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Aug 2015 04:35:04 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Wednesday 19 August 2015 08:01:53 Mauro Carvalho Chehab wrote:
> > We can only free the media device after being sure that no
> > graph object is used.
> 
> media_device_release() is currently broken as it should call back to the 
> driver that has allocated the media_device() structure. I think we should fix 
> that before adding more code on top of the problem.

Either that or move all allocations to happen via some MC function,
but this is out of the scope of this patch.

Whatever way we fix it, it is important to know when mdev
is supposed to cease to exist, and if this call happens
before or after the removal of all objects from the graph.

> 
> > In order to help tracking it, let's add debug messages
> > that will print when the media controller gets registered
> > or unregistered.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 065f6f08da37..0f3844470147 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -359,6 +359,7 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
> > 
> >  static void media_device_release(struct media_devnode *mdev)
> >  {
> > +	dev_dbg(mdev->parent, "Media device released\n");
> 
> As commented on patch 7/8, ftrace is a better candidate for function tracing.

Again, the problem here is to compare this with OOPs and other debug
messages, to see if the release is happening at the proper place.

Ftrace is not meant to be used for OOPS debug, nor it provides data
to the console, as it is not designed to be used for that purpose.

> 
> >  }
> > 
> >  /**
> > @@ -397,6 +398,8 @@ int __must_check __media_device_register(struct
> > media_device *mdev, return ret;
> >  	}
> > 
> > +	dev_dbg(mdev->dev, "Media device registered\n");
> > +
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(__media_device_register);
> > @@ -416,6 +419,8 @@ void media_device_unregister(struct media_device *mdev)
> > 
> >  	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
> >  	media_devnode_unregister(&mdev->devnode);
> > +
> > +	dev_dbg(mdev->dev, "Media device unregistered\n");
> >  }
> >  EXPORT_SYMBOL_GPL(media_device_unregister);
> 
