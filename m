Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53683 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964905AbcCNNFH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 09:05:07 -0400
Date: Mon, 14 Mar 2016 10:05:01 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Any reason why media_entity_pads_init() isn't void?
Message-ID: <20160314100501.552db582@recife.lan>
In-Reply-To: <20160314085251.19698ae8@recife.lan>
References: <56E6758F.7020205@xs4all.nl>
	<20160314103643.GP11084@valkosipuli.retiisi.org.uk>
	<20160314082738.3b84ed0a@recife.lan>
	<20160314114332.GR11084@valkosipuli.retiisi.org.uk>
	<20160314085251.19698ae8@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 14 Mar 2016 08:52:51 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Mon, 14 Mar 2016 13:43:33 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > On Mon, Mar 14, 2016 at 08:27:38AM -0300, Mauro Carvalho Chehab wrote:  
> > > Em Mon, 14 Mar 2016 12:36:44 +0200
> > > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > >     
> > > > Hi Hans,
> > > > 
> > > > On Mon, Mar 14, 2016 at 09:25:51AM +0100, Hans Verkuil wrote:    
> > > > > I was fixing a sparse warning in media_entity_pads_init() and I noticed
> > > > > that that function always returns 0. Any reason why this can't be changed
> > > > > to a void function?      
> > > > 
> > > > I was thinking of the same function but I had a different question: why
> > > > would one call this *after* entity->graph_obj.mdev is set? It is set by
> > > > media_device_register_entity(), but once mdev it's set, you're not expected
> > > > to call pads_init anymore...    
> > > 
> > > Ideally, drivers should *first* create mdev, and then create the
> > > graph objects, as all objects should be registered at the mdev, in
> > > order to get their object ID and to be registered at the mdev's object
> > > lists.    
> > 
> > Right. I think it wouldn't hurt to have some comment hints in what's there
> > for legacy use cases... I can submit patches for some of these.  
> 
> Yeah, feel free to submit a patch for it. It could be good to add a
> warn_once() that would hit for the legacy case too.
> 
> > 
> > Currently what works is that you can register graph objects until the media
> > device node is exposed to the user.  
> 
> Yes.
> 
> > We don't have proper serialisation in
> > place to do that, do we? At least the framework functions leave it up to the
> > caller.
> > 
> > I think it wouldn't be a bad idea either to think about the serialisation
> > model a bit. It's been unchanged from the day one basically.  
> 
> Actually, the async logic does some sort of serialization, although it
> doesn't enforce it.
> 
> Javier touched on some cases where the logic was not right, but he
> didn't change everything. 
> 
> I agree with you here: it would be great to have this fixed in a better
> way.
> 
> That's said, this affects only non-PCI/USB devices. On PCI/USB, the
> main/bridge driver is always called first, and the subdev init only
> happens after it registers the I2C bus.
> 

Maybe we could do something like the patch below, to replace the I2C
probe routines, and then create some logic at the async ops that would
create the mdev and then call the SD-specific core.mc_probe() methods.

(patch doesn't compile yet, and it is not complete, but just to give
an idea on how we could do it).


diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index ff18444e19e4..36bf6c57eb64 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1214,6 +1214,9 @@ static const struct v4l2_ctrl_ops tvp5150_ctrl_ops = {
 	.s_ctrl = tvp5150_s_ctrl,
 };
 
+static int tvp5150_mc_probe(struct v4l2_subdev *sd);
+
+
 static const struct v4l2_subdev_core_ops tvp5150_core_ops = {
 	.log_status = tvp5150_log_status,
 	.reset = tvp5150_reset,
@@ -1221,6 +1224,9 @@ static const struct v4l2_subdev_core_ops tvp5150_core_ops = {
 	.g_register = tvp5150_g_register,
 	.s_register = tvp5150_s_register,
 #endif
+#ifdef CONFIG_MEDIA_CONTROLLER
+	.mc_probe = tvp5150_mc_probe,
+#endif
 	.registered_async = tvp5150_registered_async,
 };
 
@@ -1438,11 +1444,33 @@ static const char * const tvp5150_test_patterns[2] = {
 	"Black screen"
 };
 
-static int tvp5150_probe(struct i2c_client *c,
-			 const struct i2c_device_id *id)
+static int __maybe_unused tvp5150_mc_probe(struct v4l2_subdev *sd)
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
+static int __tvp5150_probe(struct i2c_client *c,
+			   const struct i2c_device_id *id,
+			   struct v4l2_subdev **sd_store)
 {
 	struct tvp5150 *core;
-	struct v4l2_subdev *sd;
+	struct v4l2_subdev *sd; /* FIXME: get rid of it */
 	struct device_node *np = c->dev.of_node;
 	int res;
 
@@ -1460,6 +1488,7 @@ static int tvp5150_probe(struct i2c_client *c,
 		return -ENOMEM;
 
 	sd = &core->sd;
+	*sd_store = sd;
 
 	if (IS_ENABLED(CONFIG_OF) && np) {
 		res = tvp5150_parse_dt(core, np);
@@ -1475,20 +1504,6 @@ static int tvp5150_probe(struct i2c_client *c,
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
@@ -1542,6 +1557,8 @@ err:
 	return res;
 }
 
+DECLARE_SUBDEV_PROBE(tvp5150_probe, __tvp5150_probe);
+
 static int tvp5150_remove(struct i2c_client *c)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(c);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 11e2dfec0198..f15d63ccef30 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -183,6 +183,8 @@ struct v4l2_subdev_io_pin_config {
  * @registered_async: the subdevice has been registered async.
  */
 struct v4l2_subdev_core_ops {
+	int (*mc_probe)(struct v4l2_subdev *sd);
+
 	int (*log_status)(struct v4l2_subdev *sd);
 	int (*s_io_pin_config)(struct v4l2_subdev *sd, size_t n,
 				      struct v4l2_subdev_io_pin_config *pincfg);
@@ -795,6 +797,23 @@ static inline void *v4l2_get_subdev_hostdata(const struct v4l2_subdev *sd)
 	return sd->host_priv;
 }
 
+
+/* FIXME: need an #if defined(MEDIA_CONTROLLER) */
+#define DECLARE_SUBDEV_PROBE(name, probe_fn)				\
+static int __subdev_probe(struct i2c_client *c,				\
+			  const struct i2c_device_id *id)		\
+{									\
+	int __rc;							\
+	struct v4l2_subdev *__sd;					\
+									\
+	__rc = probe_fn(c, id, &__sd);					\
+									\
+	if (!__rc && __sd->v4l2_dev->mdev && __sd->ops->core.mc_probe)	\
+		__rc = __sd->ops->core.mc_probe(__sd);			\
+									\
+	return __rc;							\
+}
+
 #ifdef CONFIG_MEDIA_CONTROLLER
 int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 				      struct media_link *link,

