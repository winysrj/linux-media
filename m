Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35094 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbeI0Q60 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 12:58:26 -0400
Date: Thu, 27 Sep 2018 07:40:31 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pravin Shedge <pravin.shedge4linux@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH 03/13] v4l2-mc: switch it to use the new approach to
 setup pipelines
Message-ID: <20180927073928.6d950da2@coco.lan>
In-Reply-To: <6034562.6tWgEtGTRM@avalon>
References: <cover.1533138685.git.mchehab+samsung@kernel.org>
        <f3a56b9bb4210885f005c96cddf5773c2c4e0cd1.1533138685.git.mchehab+samsung@kernel.org>
        <6034562.6tWgEtGTRM@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 26 Sep 2018 17:44:53 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Wednesday, 1 August 2018 18:55:05 EEST Mauro Carvalho Chehab wrote:
> > Instead of relying on a static map for pids, use the new sig_type
> > "taint" type to setup the pipelines with the same tipe between  
> 
> s/tipe/type/
> 
> > different entities.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > ---
> >  drivers/media/media-entity.c      | 26 +++++++++++
> >  drivers/media/v4l2-core/v4l2-mc.c | 73 ++++++++++++++++++++++++-------
> >  include/media/media-entity.h      | 19 ++++++++
> >  3 files changed, 101 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index 3498551e618e..0b1cb3559140 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -662,6 +662,32 @@ static void __media_entity_remove_link(struct
> > media_entity *entity, kfree(link);
> >  }
> > 
> > +int media_get_pad_index(struct media_entity *entity, bool is_sink,
> > +			enum media_pad_signal_type sig_type)
> > +{
> > +	int i;  
> 
> is is never negative, please use an unsigned int.
> 
> > +	bool pad_is_sink;
> > +
> > +	if (!entity)
> > +		return -EINVAL;
> > +
> > +	for (i = 0; i < entity->num_pads; i++) {
> > +		if (entity->pads[i].flags == MEDIA_PAD_FL_SINK)
> > +			pad_is_sink = true;
> > +		else if (entity->pads[i].flags == MEDIA_PAD_FL_SOURCE)
> > +			pad_is_sink = false;
> > +		else
> > +			continue;	/* This is an error! */
> > +
> > +		if (pad_is_sink != is_sink)
> > +			continue;
> > +		if (entity->pads[i].sig_type == sig_type)
> > +			return i;
> > +	}
> > +	return -EINVAL;
> > +}
> > +EXPORT_SYMBOL_GPL(media_get_pad_index);
> > +
> >  int
> >  media_create_pad_link(struct media_entity *source, u16 source_pad,
> >  			 struct media_entity *sink, u16 sink_pad, u32 flags)
> > diff --git a/drivers/media/v4l2-core/v4l2-mc.c
> > b/drivers/media/v4l2-core/v4l2-mc.c index 982bab3530f6..1925e1a3b861 100644
> > --- a/drivers/media/v4l2-core/v4l2-mc.c
> > +++ b/drivers/media/v4l2-core/v4l2-mc.c
> > @@ -28,7 +28,7 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
> >  	struct media_entity *io_v4l = NULL, *io_vbi = NULL, *io_swradio = NULL;
> >  	bool is_webcam = false;
> >  	u32 flags;
> > -	int ret;
> > +	int ret, pad_sink, pad_source;
> > 
> >  	if (!mdev)
> >  		return 0;
> > @@ -97,29 +97,52 @@ int v4l2_mc_create_media_graph(struct media_device
> > *mdev) /* Link the tuner and IF video output pads */
> >  	if (tuner) {
> >  		if (if_vid) {
> > -			ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
> > -						    if_vid,
> > -						    IF_VID_DEC_PAD_IF_INPUT,
> > +			pad_source = media_get_pad_index(tuner, false,
> > +							 PAD_SIGNAL_ANALOG);
> > +			pad_sink = media_get_pad_index(if_vid, true,
> > +						       PAD_SIGNAL_ANALOG);
> > +			if (pad_source < 0 || pad_sink < 0)
> > +				return -EINVAL;
> > +			ret = media_create_pad_link(tuner, pad_source,
> > +						    if_vid, pad_sink,
> >  						    MEDIA_LNK_FL_ENABLED);
> >  			if (ret)
> >  				return ret;
> > -			ret = media_create_pad_link(if_vid, IF_VID_DEC_PAD_OUT,
> > -						decoder, DEMOD_PAD_IF_INPUT,
> > +
> > +			pad_source = media_get_pad_index(if_vid, false,
> > +							 PAD_SIGNAL_DV);
> > +			pad_sink = media_get_pad_index(decoder, true,
> > +						       PAD_SIGNAL_DV);
> > +			if (pad_source < 0 || pad_sink < 0)
> > +				return -EINVAL;
> > +			ret = media_create_pad_link(if_vid, pad_source,
> > +						decoder, pad_sink,
> >  						MEDIA_LNK_FL_ENABLED);
> >  			if (ret)
> >  				return ret;
> >  		} else {
> > -			ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
> > -						decoder, DEMOD_PAD_IF_INPUT,
> > +			pad_source = media_get_pad_index(tuner, false,
> > +							 PAD_SIGNAL_ANALOG);
> > +			pad_sink = media_get_pad_index(decoder, true,
> > +						       PAD_SIGNAL_ANALOG);
> > +			if (pad_source < 0 || pad_sink < 0)
> > +				return -EINVAL;
> > +			ret = media_create_pad_link(tuner, pad_source,
> > +						decoder, pad_sink,
> >  						MEDIA_LNK_FL_ENABLED);
> >  			if (ret)
> >  				return ret;
> >  		}
> > 
> >  		if (if_aud) {
> > -			ret = media_create_pad_link(tuner, TUNER_PAD_AUD_OUT,
> > -						    if_aud,
> > -						    IF_AUD_DEC_PAD_IF_INPUT,
> > +			pad_source = media_get_pad_index(tuner, false,
> > +							 PAD_SIGNAL_AUDIO);
> > +			pad_sink = media_get_pad_index(decoder, true,
> > +						       PAD_SIGNAL_AUDIO);
> > +			if (pad_source < 0 || pad_sink < 0)
> > +				return -EINVAL;
> > +			ret = media_create_pad_link(tuner, pad_source,
> > +						    if_aud, pad_sink,
> >  						    MEDIA_LNK_FL_ENABLED);
> >  			if (ret)
> >  				return ret;
> > @@ -131,7 +154,10 @@ int v4l2_mc_create_media_graph(struct media_device
> > *mdev)
> > 
> >  	/* Create demod to V4L, VBI and SDR radio links */
> >  	if (io_v4l) {
> > -		ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
> > +		pad_source = media_get_pad_index(decoder, false, PAD_SIGNAL_DV);
> > +		if (pad_source < 0)
> > +			return -EINVAL;
> > +		ret = media_create_pad_link(decoder, pad_source,
> >  					io_v4l, 0,
> >  					MEDIA_LNK_FL_ENABLED);
> >  		if (ret)
> > @@ -139,7 +165,10 @@ int v4l2_mc_create_media_graph(struct media_device
> > *mdev) }
> > 
> >  	if (io_swradio) {
> > -		ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
> > +		pad_source = media_get_pad_index(decoder, false, PAD_SIGNAL_DV);
> > +		if (pad_source < 0)
> > +			return -EINVAL;
> > +		ret = media_create_pad_link(decoder, pad_source,
> >  					io_swradio, 0,
> >  					MEDIA_LNK_FL_ENABLED);
> >  		if (ret)
> > @@ -147,7 +176,10 @@ int v4l2_mc_create_media_graph(struct media_device
> > *mdev) }
> > 
> >  	if (io_vbi) {
> > -		ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
> > +		pad_source = media_get_pad_index(decoder, false, PAD_SIGNAL_DV);
> > +		if (pad_source < 0)
> > +			return -EINVAL;
> > +		ret = media_create_pad_link(decoder, pad_source,
> >  					    io_vbi, 0,
> >  					    MEDIA_LNK_FL_ENABLED);
> >  		if (ret)
> > @@ -161,15 +193,22 @@ int v4l2_mc_create_media_graph(struct media_device
> > *mdev) case MEDIA_ENT_F_CONN_RF:
> >  			if (!tuner)
> >  				continue;
> > -
> > +			pad_source = media_get_pad_index(tuner, false,
> > +							 PAD_SIGNAL_ANALOG);
> > +			if (pad_source < 0)
> > +				return -EINVAL;
> >  			ret = media_create_pad_link(entity, 0, tuner,
> > -						    TUNER_PAD_RF_INPUT,
> > +						    pad_source,
> >  						    flags);
> >  			break;
> >  		case MEDIA_ENT_F_CONN_SVIDEO:
> >  		case MEDIA_ENT_F_CONN_COMPOSITE:
> > +			pad_sink = media_get_pad_index(decoder, true,
> > +						       PAD_SIGNAL_ANALOG);
> > +			if (pad_sink < 0)
> > +				return -EINVAL;
> >  			ret = media_create_pad_link(entity, 0, decoder,
> > -						    DEMOD_PAD_IF_INPUT,
> > +						    pad_sink,
> >  						    flags);
> >  			break;
> >  		default:
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 8bfbe6b59fa9..ac8b93e46167 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -675,6 +675,25 @@ static inline void media_entity_cleanup(struct
> > media_entity *entity) {} #define media_entity_cleanup(entity) do { } while
> > (false)
> >  #endif
> > 
> > +  
> 
> Extra blank line.
> 
> > +/**
> > + * media_get_pad_index() - retrieves a pad index from an entity  
> 
> I think a better name would be media_entity_find_pad(), similarly to 
> media_entity_find_link(), as the function searches for a pad given a direction 
> and signal type. A *_get_*() function name hints of reference counting.
> 
> > + *
> > + * @entity:	entity where the pads belong
> > + * @is_sink:	true if the pad is a sink, false if it is a source  
> 
> Could we use pad flags instead ? It's easier to read
> 
> 	pad = media_get_pad_index(entity, MEDIA_PAD_FL_SINK, ...);
> 
> than
> 
> 	pad = media_get_pad_index(entity, true, ...);
> 
> As an added bonus that would allow the caller to search for any pad with a 
> given signal type by specifying MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_SOURCE.
> 
> > + * @sig_type:	type of signal of the pad to be search
> > + *
> > + * This helper function finds the first pad index inside an entity that
> > + * satisfies both @is_sink and @sig_type conditions.
> > + *
> > + * Return:
> > + *
> > + * On success, return the pad number. If the pad was not found or the media
> > + * entity is a NULL pointer, return -EINVAL.
> > + */
> > +int media_get_pad_index(struct media_entity *entity, bool is_sink,
> > +			enum media_pad_signal_type sig_type);
> > +
> >  /**
> >   * media_create_pad_link() - creates a link between two entities.
> >   *  
> 

All comments make sense. follow up patch enclosed.

Thanks,
Mauro

[PATCH] media: mc: make media_get_pad_index() more generic

Instead of passing a boolean, use the pad flags. That makes
the function simpler and more generic, as it can now find
a pad that it is either sink or source.

While here, use unsigned int for the loop var.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 14e9b1db72a0..3e18a3c3e701 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -690,8 +690,9 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 						     MEDIA_LNK_FL_ENABLED,
 						     false);
 		} else {
-			pad_sink = media_get_pad_index(tuner, true,
-						       MEDIA_PAD_SIGNAL_ANALOG);
+			pad_sink = media_entity_find_pad(tuner,
+							 MEDIA_PAD_FL_SINK,
+						         MEDIA_PAD_SIGNAL_ANALOG);
 			if (pad_sink < 0)
 				return -EINVAL;
 			ret = media_create_pad_links(mdev,
@@ -707,8 +708,9 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 	}
 
 	if (ntuner && ndemod) {
-		pad_source = media_get_pad_index(tuner, true,
-						 MEDIA_PAD_SIGNAL_ANALOG);
+		pad_source = media_entity_find_pad(tuner,
+						   MEDIA_PAD_FL_SINK,
+						   MEDIA_PAD_SIGNAL_ANALOG);
 		if (pad_source)
 			return -EINVAL;
 		ret = media_create_pad_links(mdev,
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 0b1cb3559140..019cc499e986 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -662,31 +662,23 @@ static void __media_entity_remove_link(struct media_entity *entity,
 	kfree(link);
 }
 
-int media_get_pad_index(struct media_entity *entity, bool is_sink,
+int media_entity_find_pad(struct media_entity *entity, u32 flags,
 			enum media_pad_signal_type sig_type)
 {
-	int i;
+	unsigned int i;
 	bool pad_is_sink;
 
 	if (!entity)
 		return -EINVAL;
 
 	for (i = 0; i < entity->num_pads; i++) {
-		if (entity->pads[i].flags == MEDIA_PAD_FL_SINK)
-			pad_is_sink = true;
-		else if (entity->pads[i].flags == MEDIA_PAD_FL_SOURCE)
-			pad_is_sink = false;
-		else
-			continue;	/* This is an error! */
-
-		if (pad_is_sink != is_sink)
-			continue;
-		if (entity->pads[i].sig_type == sig_type)
+		if ((entity->pads[i].flags & flags) &&
+		    (entity->pads[i].sig_type == sig_type))
 			return i;
 	}
 	return -EINVAL;
 }
-EXPORT_SYMBOL_GPL(media_get_pad_index);
+EXPORT_SYMBOL_GPL(media_entity_find_pad);
 
 int
 media_create_pad_link(struct media_entity *source, u16 source_pad,
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 484b620879c0..fa42de03da38 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -266,8 +266,8 @@ static void au0828_media_graph_notify(struct media_entity *new,
 
 create_link:
 	if (decoder && mixer) {
-		ret = media_get_pad_index(decoder, false,
-					  MEDIA_PAD_SIGNAL_AUDIO);
+		ret = media_entity_find_pad(decoder, MEDIA_PAD_FL_SOURCE,
+					    MEDIA_PAD_SIGNAL_AUDIO);
 		if (ret >= 0)
 			ret = media_create_pad_link(decoder, ret,
 						    mixer, 0,
diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index f559e47cf8e8..ce80020117cb 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -105,10 +105,12 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	/* Link the tuner and IF video output pads */
 	if (tuner) {
 		if (if_vid) {
-			pad_source = media_get_pad_index(tuner, false,
+			pad_source = media_entity_find_pad(tuner,
+							   MEDIA_PAD_FL_SOURCE,
+							   MEDIA_PAD_SIGNAL_ANALOG);
+			pad_sink = media_entity_find_pad(if_vid,
+							 MEDIA_PAD_FL_SINK,
 							 MEDIA_PAD_SIGNAL_ANALOG);
-			pad_sink = media_get_pad_index(if_vid, true,
-						       MEDIA_PAD_SIGNAL_ANALOG);
 			if (pad_source < 0 || pad_sink < 0) {
 				dev_warn(mdev->dev, "Couldn't get tuner and/or PLL pad(s): (%d, %d)\n",
 					 pad_source, pad_sink);
@@ -122,10 +124,12 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 				return ret;
 			}
 
-			pad_source = media_get_pad_index(if_vid, false,
+			pad_source = media_entity_find_pad(if_vid,
+							   MEDIA_PAD_FL_SOURCE,
+							   MEDIA_PAD_SIGNAL_ANALOG);
+			pad_sink = media_entity_find_pad(decoder,
+							 MEDIA_PAD_FL_SINK,
 							 MEDIA_PAD_SIGNAL_ANALOG);
-			pad_sink = media_get_pad_index(decoder, true,
-						       MEDIA_PAD_SIGNAL_ANALOG);
 			if (pad_source < 0 || pad_sink < 0) {
 				dev_warn(mdev->dev, "get decoder and/or PLL pad(s): (%d, %d)\n",
 					 pad_source, pad_sink);
@@ -139,10 +143,12 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 				return ret;
 			}
 		} else {
-			pad_source = media_get_pad_index(tuner, false,
+			pad_source = media_entity_find_pad(tuner,
+							   MEDIA_PAD_FL_SOURCE,
+							   MEDIA_PAD_SIGNAL_ANALOG);
+			pad_sink = media_entity_find_pad(decoder,
+							 MEDIA_PAD_FL_SINK,
 							 MEDIA_PAD_SIGNAL_ANALOG);
-			pad_sink = media_get_pad_index(decoder, true,
-						       MEDIA_PAD_SIGNAL_ANALOG);
 			if (pad_source < 0 || pad_sink < 0) {
 				dev_warn(mdev->dev, "couldn't get tuner and/or decoder pad(s): (%d, %d)\n",
 					 pad_source, pad_sink);
@@ -156,10 +162,12 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 		}
 
 		if (if_aud) {
-			pad_source = media_get_pad_index(tuner, false,
+			pad_source = media_entity_find_pad(tuner,
+							   MEDIA_PAD_FL_SOURCE,
+							   MEDIA_PAD_SIGNAL_AUDIO);
+			pad_sink = media_entity_find_pad(if_aud,
+							 MEDIA_PAD_FL_SINK,
 							 MEDIA_PAD_SIGNAL_AUDIO);
-			pad_sink = media_get_pad_index(if_aud, true,
-						       MEDIA_PAD_SIGNAL_AUDIO);
 			if (pad_source < 0 || pad_sink < 0) {
 				dev_warn(mdev->dev, "couldn't get tuner and/or decoder pad(s) for audio: (%d, %d)\n",
 					 pad_source, pad_sink);
@@ -180,7 +188,9 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 
 	/* Create demod to V4L, VBI and SDR radio links */
 	if (io_v4l) {
-		pad_source = media_get_pad_index(decoder, false, MEDIA_PAD_SIGNAL_DV);
+		pad_source = media_entity_find_pad(decoder,
+						   MEDIA_PAD_FL_SOURCE,
+						   MEDIA_PAD_SIGNAL_DV);
 		if (pad_source < 0) {
 			dev_warn(mdev->dev, "couldn't get decoder output pad for V4L I/O\n");
 			return -EINVAL;
@@ -195,7 +205,9 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	}
 
 	if (io_swradio) {
-		pad_source = media_get_pad_index(decoder, false, MEDIA_PAD_SIGNAL_DV);
+		pad_source = media_entity_find_pad(decoder,
+						   MEDIA_PAD_FL_SOURCE,
+						   MEDIA_PAD_SIGNAL_DV);
 		if (pad_source < 0) {
 			dev_warn(mdev->dev, "couldn't get decoder output pad for SDR\n");
 			return -EINVAL;
@@ -210,7 +222,9 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	}
 
 	if (io_vbi) {
-		pad_source = media_get_pad_index(decoder, false, MEDIA_PAD_SIGNAL_DV);
+		pad_source = media_entity_find_pad(decoder,
+						   MEDIA_PAD_FL_SOURCE,
+						   MEDIA_PAD_SIGNAL_DV);
 		if (pad_source < 0) {
 			dev_warn(mdev->dev, "couldn't get decoder output pad for VBI\n");
 			return -EINVAL;
@@ -231,8 +245,9 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 		case MEDIA_ENT_F_CONN_RF:
 			if (!tuner)
 				continue;
-			pad_sink = media_get_pad_index(tuner, true,
-						       MEDIA_PAD_SIGNAL_ANALOG);
+			pad_sink = media_entity_find_pad(tuner,
+							 MEDIA_PAD_FL_SINK,
+							 MEDIA_PAD_SIGNAL_ANALOG);
 			if (pad_sink < 0) {
 				dev_warn(mdev->dev, "couldn't get tuner analog pad sink\n");
 				return -EINVAL;
@@ -243,8 +258,9 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 			break;
 		case MEDIA_ENT_F_CONN_SVIDEO:
 		case MEDIA_ENT_F_CONN_COMPOSITE:
-			pad_sink = media_get_pad_index(decoder, true,
-						       MEDIA_PAD_SIGNAL_ANALOG);
+			pad_sink = media_entity_find_pad(decoder,
+							 MEDIA_PAD_FL_SINK,
+							 MEDIA_PAD_SIGNAL_ANALOG);
 			if (pad_sink < 0) {
 				dev_warn(mdev->dev, "couldn't get tuner analog pad sink\n");
 				return -EINVAL;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 837f806593f5..46a955468fb2 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -675,22 +675,25 @@ static inline void media_entity_cleanup(struct media_entity *entity) {}
 #endif
 
 /**
- * media_get_pad_index() - retrieves a pad index from an entity
+ * media_entity_find_pad() - retrieves a pad index from an entity
  *
  * @entity:	entity where the pads belong
- * @is_sink:	true if the pad is a sink, false if it is a source
+ * @flags:	Link flags, as defined in
+ *		:ref:`include/uapi/linux/media.h <media_header>`
+ *		( seek for ``MEDIA_LNK_FL_*``). Shouldn't be zero.
  * @sig_type:	type of signal of the pad to be search
  *
  * This helper function finds the first pad index inside an entity that
- * satisfies both @is_sink and @sig_type conditions.
+ * satisfies contains one or more of the flags specified at @flags
+ * and whose type matches @sig_type.
  *
  * Return:
  *
  * On success, return the pad number. If the pad was not found or the media
  * entity is a NULL pointer, return -EINVAL.
  */
-int media_get_pad_index(struct media_entity *entity, bool is_sink,
-			enum media_pad_signal_type sig_type);
+int media_entity_find_pad(struct media_entity *entity, u32 flags,
+			  enum media_pad_signal_type sig_type);
 
 /**
  * media_create_pad_link() - creates a link between two entities.
