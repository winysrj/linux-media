Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53786 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbcCNSQp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 14:16:45 -0400
Date: Mon, 14 Mar 2016 15:16:38 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Any reason why media_entity_pads_init() isn't void?
Message-ID: <20160314151638.71a85e9b@recife.lan>
In-Reply-To: <20160314100501.552db582@recife.lan>
References: <56E6758F.7020205@xs4all.nl>
	<20160314103643.GP11084@valkosipuli.retiisi.org.uk>
	<20160314082738.3b84ed0a@recife.lan>
	<20160314114332.GR11084@valkosipuli.retiisi.org.uk>
	<20160314085251.19698ae8@recife.lan>
	<20160314100501.552db582@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 14 Mar 2016 10:05:01 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Mon, 14 Mar 2016 08:52:51 -0300
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
> 
> > Em Mon, 14 Mar 2016 13:43:33 +0200
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> >   
> > > Hi Mauro,
> > > 
> > > On Mon, Mar 14, 2016 at 08:27:38AM -0300, Mauro Carvalho Chehab wrote:    
> > > > Em Mon, 14 Mar 2016 12:36:44 +0200
> > > > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > > >       
> > > > > Hi Hans,
> > > > > 
> > > > > On Mon, Mar 14, 2016 at 09:25:51AM +0100, Hans Verkuil wrote:      
> > > > > > I was fixing a sparse warning in media_entity_pads_init() and I noticed
> > > > > > that that function always returns 0. Any reason why this can't be changed
> > > > > > to a void function?        
> > > > > 
> > > > > I was thinking of the same function but I had a different question: why
> > > > > would one call this *after* entity->graph_obj.mdev is set? It is set by
> > > > > media_device_register_entity(), but once mdev it's set, you're not expected
> > > > > to call pads_init anymore...      
> > > > 
> > > > Ideally, drivers should *first* create mdev, and then create the
> > > > graph objects, as all objects should be registered at the mdev, in
> > > > order to get their object ID and to be registered at the mdev's object
> > > > lists.      
> > > 
> > > Right. I think it wouldn't hurt to have some comment hints in what's there
> > > for legacy use cases... I can submit patches for some of these.    
> > 
> > Yeah, feel free to submit a patch for it. It could be good to add a
> > warn_once() that would hit for the legacy case too.
> >   
> > > 
> > > Currently what works is that you can register graph objects until the media
> > > device node is exposed to the user.    
> > 
> > Yes.
> >   
> > > We don't have proper serialisation in
> > > place to do that, do we? At least the framework functions leave it up to the
> > > caller.
> > > 
> > > I think it wouldn't be a bad idea either to think about the serialisation
> > > model a bit. It's been unchanged from the day one basically.    
> > 
> > Actually, the async logic does some sort of serialization, although it
> > doesn't enforce it.
> > 
> > Javier touched on some cases where the logic was not right, but he
> > didn't change everything. 
> > 
> > I agree with you here: it would be great to have this fixed in a better
> > way.
> > 
> > That's said, this affects only non-PCI/USB devices. On PCI/USB, the
> > main/bridge driver is always called first, and the subdev init only
> > happens after it registers the I2C bus.
> >   
> 
> Maybe we could do something like the patch below, to replace the I2C
> probe routines, and then create some logic at the async ops that would
> create the mdev and then call the SD-specific core.mc_probe() methods.
> 
> (patch doesn't compile yet, and it is not complete, but just to give
> an idea on how we could do it).

Still not tested, but, IMHO, in a better shape. See enclosed.

The idea behind it is to split the PAD init on all subdevs and let the
core call it.

For now, the core is calling it early, when v4l2_i2c_subdev_init() is
called, but, after making all subdevs use the new pad_init() callback,
we can call them later. I guess the best place for the code would be
to be called only at v4l2_device_register_subdev(), but we need to
double check if this would work on all cases.

-


diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index ff18444e19e4..14004fd7d0fb 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1208,6 +1208,28 @@ static int tvp5150_registered_async(struct v4l2_subdev *sd)
 	return 0;
 }
 
+static int __maybe_unused tvp5150_pad_init(struct v4l2_subdev *sd)
+{
+	struct tvp5150 *core = to_tvp5150(sd);
+	int res;
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	core->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	core->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	core->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
+
+	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
+
+	res = media_entity_pads_init(&sd->entity, DEMOD_NUM_PADS, core->pads);
+	if (res < 0)
+		return res;
+
+	sd->entity.ops = &tvp5150_sd_media_ops;
+#endif
+	return 0;
+}
+
+
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_ctrl_ops tvp5150_ctrl_ops = {
@@ -1246,6 +1268,9 @@ static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
 };
 
 static const struct v4l2_subdev_pad_ops tvp5150_pad_ops = {
+#ifdef CONFIG_MEDIA_CONTROLLER
+	.pad_init = tvp5150_pad_init,
+#endif
 	.enum_mbus_code = tvp5150_enum_mbus_code,
 	.enum_frame_size = tvp5150_enum_frame_size,
 	.set_fmt = tvp5150_fill_fmt,
@@ -1475,20 +1500,6 @@ static int tvp5150_probe(struct i2c_client *c,
 	v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
-#if defined(CONFIG_MEDIA_CONTROLLER)
-	core->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
-	core->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	core->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
-
-	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
-
-	res = media_entity_pads_init(&sd->entity, DEMOD_NUM_PADS, core->pads);
-	if (res < 0)
-		return res;
-
-	sd->entity.ops = &tvp5150_sd_media_ops;
-#endif
-
 	res = tvp5150_detect_version(core);
 	if (res < 0)
 		return res;
diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 5b808500e7e7..6bcdf557e027 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -112,6 +112,14 @@ EXPORT_SYMBOL(v4l2_ctrl_query_fill);
 void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
 		const struct v4l2_subdev_ops *ops)
 {
+	/*
+	 * Initialize the MC pads - for now, this will be called
+	 * unconditionally, since the current implementation will defer
+	 * the pads initialization until the media_dev is created.
+	 */
+	if (v4l2_subdev_has_op(sd, pad, pad_init))
+		sd->ops->pad->pad_init(sd);
+
 	v4l2_subdev_init(sd, ops);
 	sd->flags |= V4L2_SUBDEV_FL_IS_I2C;
 	/* the owner is the same as the i2c_client's driver owner */
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 11e2dfec0198..c9bb221029e4 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -572,6 +572,9 @@ struct v4l2_subdev_pad_config {
 /**
  * struct v4l2_subdev_pad_ops - v4l2-subdev pad level operations
  *
+ * @pad_init: callback that initializes the media-controller specific part
+ *	      of the subdev driver, creating its pads
+ *
  * @enum_mbus_code: callback for VIDIOC_SUBDEV_ENUM_MBUS_CODE ioctl handler
  *		    code.
  * @enum_frame_size: callback for VIDIOC_SUBDEV_ENUM_FRAME_SIZE ioctl handler
@@ -607,6 +610,7 @@ struct v4l2_subdev_pad_config {
  *                  may be adjusted by the subdev driver to device capabilities.
  */
 struct v4l2_subdev_pad_ops {
+	int (*pad_init)(struct v4l2_subdev *sd);
 	int (*enum_mbus_code)(struct v4l2_subdev *sd,
 			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_mbus_code_enum *code);

-- 
Thanks,
Mauro
