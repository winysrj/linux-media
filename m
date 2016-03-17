Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54342 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935556AbcCQRnV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2016 13:43:21 -0400
Date: Thu, 17 Mar 2016 14:43:11 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] [media] media-device: Don't call notify callbacks
 holding a spinlock
Message-ID: <20160317144311.78e6ab4e@recife.lan>
In-Reply-To: <1476692.TFhxKfSMEs@avalon>
References: <31ecc9d6d2f29b0bd76c03c516d12aa7d0be2f66.1457982982.git.mchehab@osg.samsung.com>
	<1476692.TFhxKfSMEs@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Mar 2016 13:38:56 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Monday 14 March 2016 16:16:29 Mauro Carvalho Chehab wrote:
> > The notify routines may sleep. So, they can't be called in spinlock
> > context. Also, they may want to call other media routines that might
> > be spinning the spinlock, like creating a link.
> > 
> > This fixes the following bug:
> > 
> > [ 1839.510587] BUG: sleeping function called from invalid context at
> > mm/slub.c:1289 [ 1839.510881] in_atomic(): 1, irqs_disabled(): 0, pid:
> > 3479, name: modprobe [ 1839.511157] 4 locks held by modprobe/3479:
> > [ 1839.511415]  #0:  (&dev->mutex){......}, at: [<ffffffff81ce8933>]
> > __driver_attach+0xa3/0x160 [ 1839.512381]  #1:  (&dev->mutex){......}, at:
> > [<ffffffff81ce8941>] __driver_attach+0xb1/0x160 [ 1839.512388]  #2: 
> > (register_mutex#5){+.+.+.}, at: [<ffffffffa10596c7>]
> > usb_audio_probe+0x257/0x1c90 [snd_usb_audio] [ 1839.512401]  #3: 
> > (&(&mdev->lock)->rlock){+.+.+.}, at: [<ffffffffa0e6051b>]
> > media_device_register_entity+0x1cb/0x700 [media] [ 1839.512412] CPU: 2 PID:
> > 3479 Comm: modprobe Not tainted 4.5.0-rc3+ #49 [ 1839.512415] Hardware
> > name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722
> > 08/12/2015 [ 1839.512417]  0000000000000000 ffff8803b3f6f288
> > ffffffff81933901 ffff8803c4bae000 [ 1839.512422]  ffff8803c4bae5c8
> > ffff8803b3f6f2b0 ffffffff811c6af5 ffff8803c4bae000 [ 1839.512427] 
> > ffffffff8285d7f6 0000000000000509 ffff8803b3f6f2f0 ffffffff811c6ce5 [
> > 1839.512432] Call Trace:
> > [ 1839.512436]  [<ffffffff81933901>] dump_stack+0x85/0xc4
> > [ 1839.512440]  [<ffffffff811c6af5>] ___might_sleep+0x245/0x3a0
> > [ 1839.512443]  [<ffffffff811c6ce5>] __might_sleep+0x95/0x1a0
> > [ 1839.512446]  [<ffffffff8155aade>] kmem_cache_alloc_trace+0x20e/0x300
> > [ 1839.512451]  [<ffffffffa0e66e3d>] ? media_add_link+0x4d/0x140 [media]
> > [ 1839.512455]  [<ffffffffa0e66e3d>] media_add_link+0x4d/0x140 [media]
> > [ 1839.512459]  [<ffffffffa0e69931>] media_create_pad_link+0xa1/0x600
> > [media] [ 1839.512463]  [<ffffffffa0fe11b3>]
> > au0828_media_graph_notify+0x173/0x360 [au0828] [ 1839.512467] 
> > [<ffffffffa0e68a6a>] ? media_gobj_create+0x1ba/0x480 [media] [ 1839.512471]
> >  [<ffffffffa0e606fb>] media_device_register_entity+0x3ab/0x700 [media]
> > 
> > Tested with an HVR-950Q, under the following testcases:
> > 
> > 1) load au0828 driver first, and then snd-usb-audio;
> > 2) load snd-usb-audio driver first, and then au0828;
> > 3) loading both drivers, and then connecting the device.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > ---
> >  drivers/media/i2c/tvp5150.c           | 39 ++++++++++++++++++++------------
> >  drivers/media/media-device.c          |  5 +++--
> >  drivers/media/v4l2-core/v4l2-common.c |  8 +++++++
> >  include/media/v4l2-subdev.h           |  4 ++++
> >  4 files changed, 40 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> > index ff18444e19e4..14004fd7d0fb 100644
> > --- a/drivers/media/i2c/tvp5150.c
> > +++ b/drivers/media/i2c/tvp5150.c
> > @@ -1208,6 +1208,28 @@ static int tvp5150_registered_async(struct
> > v4l2_subdev *sd) return 0;
> >  }
> > 
> > +static int __maybe_unused tvp5150_pad_init(struct v4l2_subdev *sd)
> > +{
> > +	struct tvp5150 *core = to_tvp5150(sd);
> > +	int res;
> > +
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > +	core->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
> > +	core->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
> > +	core->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
> > +
> > +	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
> > +
> > +	res = media_entity_pads_init(&sd->entity, DEMOD_NUM_PADS, core->pads);
> > +	if (res < 0)
> > +		return res;
> > +
> > +	sd->entity.ops = &tvp5150_sd_media_ops;
> > +#endif
> > +	return 0;
> > +}
> > +
> > +
> >  /* -----------------------------------------------------------------------
> > */
> > 
> >  static const struct v4l2_ctrl_ops tvp5150_ctrl_ops = {
> > @@ -1246,6 +1268,9 @@ static const struct v4l2_subdev_vbi_ops
> > tvp5150_vbi_ops = { };
> > 
> >  static const struct v4l2_subdev_pad_ops tvp5150_pad_ops = {
> > +#ifdef CONFIG_MEDIA_CONTROLLER
> > +	.pad_init = tvp5150_pad_init,
> > +#endif
> >  	.enum_mbus_code = tvp5150_enum_mbus_code,
> >  	.enum_frame_size = tvp5150_enum_frame_size,
> >  	.set_fmt = tvp5150_fill_fmt,
> > @@ -1475,20 +1500,6 @@ static int tvp5150_probe(struct i2c_client *c,
> >  	v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);
> >  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > 
> > -#if defined(CONFIG_MEDIA_CONTROLLER)
> > -	core->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
> > -	core->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
> > -	core->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
> > -
> > -	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
> > -
> > -	res = media_entity_pads_init(&sd->entity, DEMOD_NUM_PADS, core->pads);
> > -	if (res < 0)
> > -		return res;
> > -
> > -	sd->entity.ops = &tvp5150_sd_media_ops;
> > -#endif
> > -
> >  	res = tvp5150_detect_version(core);
> >  	if (res < 0)
> >  		return res;
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 6ba6e8f982fc..fc3c199e5500 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -587,14 +587,15 @@ int __must_check media_device_register_entity(struct
> > media_device *mdev, media_gobj_create(mdev, MEDIA_GRAPH_PAD,
> >  			       &entity->pads[i].graph_obj);
> > 
> > +	spin_unlock(&mdev->lock);
> > +
> >  	/* invoke entity_notify callbacks */
> >  	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list) {
> >  		(notify)->notify(entity, notify->notify_data);
> >  	}  
> 
> I don't think this is the right approach. There's no lock protecting the 
> entity_notify list, and nothing that prevents the notifiers from touching the 
> entity_notify list. The list_for_each_entry_safe() function doesn't help you 
> there, it only protects against deletion of the current list entry.
> 
> Locking needs to be audited and fixed, let's not push a bug fix that 
> introduces another bug.

Sakari proposed a different approach. I ran a loop 1000 times doing 
unbinding/rebinding au0828, keeping snd-usb-audio bind, and running 3
other processes calling G_TOPOLOGY. It worked 100%. Not a single
trouble.

Such patch is at:
	https://patchwork.linuxtv.org/patch/33490/

> Furthermore, I wonder if we really need notifiers. They add complexity and are 
> difficult to get right, isn't there another possible approach ?

Sorry, but I can't see any other approach to create links between the 
entities created by different and independent drivers that would be
better than notifiers.

In this specific case, the USB Audio Class driver (snd-usb-audio)
doesn't know anything about the V4L2 driver. Only the V4L2 driver
knows what links should be created to connect the audio I2S inputs.

The probing order is also random, meaning that either the V4L2
driver or the ALSA driver will be probed first.

Thanks,
Mauro
