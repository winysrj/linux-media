Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34242 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751294AbcHVMkV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 08:40:21 -0400
Date: Mon, 22 Aug 2016 15:40:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, m.chehab@osg.samsung.com,
        shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC v2 06/17] media: Dynamically allocate the media device
Message-ID: <20160822124018.GC12130@valkosipuli.retiisi.org.uk>
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
 <1471602228-30722-7-git-send-email-sakari.ailus@linux.intel.com>
 <b9aefadd-054e-bece-da6b-4f599d5173a2@xs4all.nl>
 <20160822123820.GB12130@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160822123820.GB12130@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 22, 2016 at 03:38:20PM +0300, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Aug 22, 2016 at 02:01:44PM +0200, Hans Verkuil wrote:
> > On 08/19/2016 12:23 PM, Sakari Ailus wrote:
> > > From: Sakari Ailus <sakari.ailus@iki.fi>
> > > 
> > > Allow allocating the media device dynamically. As the struct media_device
> > > embeds struct media_devnode, the lifetime of that object is that same than
> > > that of the media_device.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > ---
> > >  drivers/media/media-device.c | 22 ++++++++++++++++++++++
> > >  include/media/media-device.h | 38 ++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 60 insertions(+)
> > > 
> > > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > > index a431775..5a86d36 100644
> > > --- a/drivers/media/media-device.c
> > > +++ b/drivers/media/media-device.c
> > > @@ -544,7 +544,15 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
> > >  
> > >  static void media_device_release(struct media_devnode *devnode)
> > >  {
> > > +	struct media_device *mdev = to_media_device(devnode);
> > > +
> > > +	ida_destroy(&mdev->entity_internal_idx);
> > > +	mdev->entity_internal_idx_max = 0;
> > > +	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
> > > +	mutex_destroy(&mdev->graph_mutex);
> > >  	dev_dbg(devnode->parent, "Media device released\n");
> > > +
> > > +	kfree(mdev);
> > 
> > Doesn't this break bisect? mdev is now freed, but media_device_alloc isn't
> > called yet.
> > 
> > That doesn't seem right.
> 
> You're right.
> 
> media_device_release() actually may only be called for drivers that use
> media_device_init(). I'll fix that.

s/media_device_init/media_device_alloc/

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
