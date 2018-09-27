Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbeI0QTa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 12:19:30 -0400
Date: Thu, 27 Sep 2018 07:01:38 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Brian Warner <brian.warner@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Nasser Afshin <afshin.nasser@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 02/13] media: v4l2: taint pads with the signal types for
 consumer devices
Message-ID: <20180927070138.11c04fff@coco.lan>
In-Reply-To: <3421008.de6ofXCdCx@avalon>
References: <cover.1533138685.git.mchehab+samsung@kernel.org>
        <d328b90800498d10d908c67b05bd48bfb78162c0.1533138685.git.mchehab+samsung@kernel.org>
        <3421008.de6ofXCdCx@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 26 Sep 2018 17:09:19 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> Could you please CC me on patches touching the media controller core ? I can 
> send a MAINTAINERS patch to make sure that gets handled automatically.
> 
> On Wednesday, 1 August 2018 18:55:04 EEST Mauro Carvalho Chehab wrote:
> > Consumer devices are provided with a wide diferent range of types
> > supported by the same driver, allowing different configutations.
> > 
> > In order to make easier to setup media controller links, "taint"
> > pads with the signal type it carries.
> > 
> > While here, get rid of DEMOD_PAD_VBI_OUT, as the signal it carries
> > is actually the same as the normal video output.
> > 
> > The difference happens at the video/VBI interface:
> > 	- for VBI, only the hidden lines are streamed;
> > 	- for video, the stream is usually cropped to hide the
> > 	  vbi lines.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > ---
> >  drivers/media/dvb-frontends/au8522_decoder.c |  3 ++
> >  drivers/media/i2c/msp3400-driver.c           |  2 ++
> >  drivers/media/i2c/saa7115.c                  |  2 ++
> >  drivers/media/i2c/tvp5150.c                  |  2 ++
> >  drivers/media/pci/saa7134/saa7134-core.c     |  2 ++
> >  drivers/media/tuners/si2157.c                |  3 ++
> >  drivers/media/usb/dvb-usb-v2/mxl111sf.c      |  2 ++
> >  drivers/media/v4l2-core/tuner-core.c         |  5 +++
> >  include/media/media-entity.h                 | 35 ++++++++++++++++++++
> >  9 files changed, 56 insertions(+)  
> 
> [snip]
> 
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 3aa3d58d1d58..8bfbe6b59fa9 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -155,6 +155,40 @@ struct media_link {
> >  	bool is_backlink;
> >  };
> > 
> > +/**
> > + * struct media_pad_signal_type - type of the signal inside a media pad  
> 
> I'd say "carried by a media pad" instead of "inside a media pad".

Ok.

> 
> > + *
> > + * @PAD_SIGNAL_DEFAULT  
> 
> Shouldn't we use a MEDIA_PAD_ prefix ?

Ok.
> 
> > + *	Default signal. Use this when all inputs or all outputs are
> > + *	uniquely identified by the pad number.  
> 
> How about "Use this when the pad can carry a single signal type" ? I 
> understand your formulation as meaning that all pads of the entity have to be 
> of the default type, or none can be.

Describing the MEDIA_PAD_SIGNAL_DEFAULT is not trivial.

Basically, almost all pads at the subsystem are MEDIA_PAD_SIGNAL_DEFAULT.

Only certain types of entities need to "taint" the pad (usually,
the entities related to the tuning and audio/video decoding stages).

In other words, the decision if it should either use 
MEDIA_PAD_SIGNAL_DEFAULT or not is per-entity (and not per-pad).

Typically, it is needed when a certain entity function may have
pads at the same direction with different meanings.

A real example would be a digital tuner entity that has two pad sources:
	- pad source #0 - carries a RF signal;
	- pad source #1 - carries a digital audio signal.

On this case, both pad sources should use a signal different than
MEDIA_PAD_SIGNAL_DEFAULT.

Writing it on a concise way is not a trivial task ;-)

Maybe something like would work:

"Default signal. Use this when there's no need to specify the
 signal carried inside a pad."

> 
> > + * @PAD_SIGNAL_ANALOG  
> 
> This isn't a very good name given that PAD_SIGNAL_TV_CARRIERS is also analog.
> 
> > + *	The pad contains an analog signa. It can be Radio Frequency,  
> 
> s/signa/signal/

Ok (this is actually fixed already at the version applied).

> > + *	Intermediate Frequency or baseband signal.
> > + *	Tuner inputs, composite and s-video signals should use it.
> > + *	On tuner sources, this is used for digital TV demodulators and for
> > + *	IF-PLL demodulator like tda9887.
> > + * @PAD_SIGNAL_TV_CARRIERS
> > + *	The pad contains analog signals carrying either a digital or an analog
> > + *	modulated (or baseband) signal.  
> 
> As above, maybe "The pad carries either ...".

Replaced "contains" with "carries".

> > This is provided by tuner source
> > + *	pads and used by analog TV standard decoders and by digital TV demods.
> > + * @PAD_SIGNAL_DV
> > + *	Contains a digital video signal, with can be a bitstream of samples
> > + *	taken from an analog TV video source. On such case, it usually
> > + *	contains the VBI data on it.
> > + * @PAD_SIGNAL_AUDIO
> > + *	Contains an Intermediate Frequency analog signal from an audio
> > + *	sub-carrier or an audio bitstream. IF signals are provided by tuners
> > + *	and consumed by	audio AM/FM decoders. Bitstream audio is provided by  
> 
> s/  / /
> 
> > + *	an audio decoder.  
> 
> Generally speaking the types you propose here seem quite ad-hoc, without much 
> coherency. For instance you split analog and digital video, but group all 
> audio under a single type. It's also not very clear from the description how 
> to handle analog video, as it could match both PAD_SIGNAL_ANALOG and 
> PAD_SIGNAL_TV_CARRIERS. Both of those types also accept analog baseband 
> signals. I think this should be reworked, it doesn't sound very usable except 
> for the specific use case that this series tries to address.

The goal here is to be able "taint" the signal to a certain group. It might 
have been called as "blue", "red", "green", but using a more coherent name
for a group where the signal belongs make easier to add the right taints at
the pads.

With regards with PAD_SIGNAL_ANALOG versus PAD_SIGNAL_TV_CARRIERS, fully
agreed.

Actually, I noticed the same issue you pointed: it is not clear where to use
PAD_SIGNAL_ANALOG or PAD_SIGNAL_TV_CARRIERS. So, I got rid of the
latter at the second version of this patch:

	Date: Sat, 15 Sep 2018 17:14:17 -0300
	Subject: [PATCH v2 02/14] media: v4l2: taint pads with the signal types for consumer devices

After that, there are only 3 types of signal:

  PAD_SIGNAL_ANALOG - any kind of analog signal (either baseband or RF/IF)
  PAD_SIGNAL_DV     - any kind of digital video signal
  PAD_SIGNAL_AUDIO  - any kind of audio signal (either analog or digital)

> > + */
> > +enum media_pad_signal_type {
> > +	PAD_SIGNAL_DEFAULT = 0,
> > +	PAD_SIGNAL_ANALOG,
> > +	PAD_SIGNAL_TV_CARRIERS,
> > +	PAD_SIGNAL_DV,
> > +	PAD_SIGNAL_AUDIO,
> > +};
> > +
> >  /**
> >   * struct media_pad - A media pad graph object.
> >   *
> > @@ -169,6 +203,7 @@ struct media_pad {
> >  	struct media_gobj graph_obj;	/* must be first field in struct */
> >  	struct media_entity *entity;
> >  	u16 index;
> > +	enum media_pad_signal_type sig_type;  
> 
> Missing kerneldoc and Documentation/ update ? It's important to document the 
> use cases, and in particular whether the type should be static or can vary (as 
> in whether a pad can carry different types over time).

I don't see any use cases where the type of the signal can vary over time.
If we ever need that, then we would need another signal type
(like MEDIA_PAD_DYNAMIC_AUDIO_OR_VIDEO).

What about this?

 * @sig_type:   Type of the signal that a media pad supports. This is used
 *              when an entity function may have different kinds of signals
 *              on different pads of the same direction (source/sink). For
 *              example, if an entity has 2 pad sinks where one carries
 *              an analog video while the other carries an audio signal.


> >  	unsigned long flags;
> >  };  
> 
> 

Thanks,
Mauro

media: improve media pad signal documentation

There are some things at the media pad signal documentation that
are not precise. Improve its documentation and rename from

	PAD_SIGNAL_* -> MEDIA_PAD_SIGNAL

in order to better document its usage inside the drivers.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index b7171bf094fb..14e9b1db72a0 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -691,7 +691,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 						     false);
 		} else {
 			pad_sink = media_get_pad_index(tuner, true,
-						       PAD_SIGNAL_ANALOG);
+						       MEDIA_PAD_SIGNAL_ANALOG);
 			if (pad_sink < 0)
 				return -EINVAL;
 			ret = media_create_pad_links(mdev,
@@ -708,7 +708,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 
 	if (ntuner && ndemod) {
 		pad_source = media_get_pad_index(tuner, true,
-						 PAD_SIGNAL_ANALOG);
+						 MEDIA_PAD_SIGNAL_ANALOG);
 		if (pad_source)
 			return -EINVAL;
 		ret = media_create_pad_links(mdev,
diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index b2dd20ffd002..1f99e6238eb8 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -719,11 +719,11 @@ static int au8522_probe(struct i2c_client *client,
 #if defined(CONFIG_MEDIA_CONTROLLER)
 
 	state->pads[AU8522_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
-	state->pads[AU8522_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
+	state->pads[AU8522_PAD_IF_INPUT].sig_type = MEDIA_PAD_SIGNAL_ANALOG;
 	state->pads[AU8522_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[AU8522_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
+	state->pads[AU8522_PAD_VID_OUT].sig_type = MEDIA_PAD_SIGNAL_DV;
 	state->pads[AU8522_PAD_AUDIO_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[AU8522_PAD_AUDIO_OUT].sig_type = PAD_SIGNAL_AUDIO;
+	state->pads[AU8522_PAD_AUDIO_OUT].sig_type = MEDIA_PAD_SIGNAL_AUDIO;
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
 	ret = media_entity_pads_init(&sd->entity, ARRAY_SIZE(state->pads),
diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index c63be01059b2..935dfec2b405 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -704,9 +704,9 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	state->pads[MSP3400_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
-	state->pads[MSP3400_PAD_IF_INPUT].sig_type = PAD_SIGNAL_AUDIO;
+	state->pads[MSP3400_PAD_IF_INPUT].sig_type = MEDIA_PAD_SIGNAL_AUDIO;
 	state->pads[MSP3400_PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[MSP3400_PAD_OUT].sig_type = PAD_SIGNAL_AUDIO;
+	state->pads[MSP3400_PAD_OUT].sig_type = MEDIA_PAD_SIGNAL_AUDIO;
 
 	sd->entity.function = MEDIA_ENT_F_IF_AUD_DECODER;
 
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 6bc278aa31fc..d74065890a80 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1841,9 +1841,9 @@ static int saa711x_probe(struct i2c_client *client,
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	state->pads[SAA711X_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
-	state->pads[SAA711X_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
+	state->pads[SAA711X_PAD_IF_INPUT].sig_type = MEDIA_PAD_SIGNAL_ANALOG;
 	state->pads[SAA711X_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[SAA711X_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
+	state->pads[SAA711X_PAD_VID_OUT].sig_type = MEDIA_PAD_SIGNAL_DV;
 
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index f5b234e4599d..45be245442e0 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1738,9 +1738,9 @@ static int tvp5150_probe(struct i2c_client *c,
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	core->pads[TVP5150_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
-	core->pads[TVP5150_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
+	core->pads[TVP5150_PAD_IF_INPUT].sig_type = MEDIA_PAD_SIGNAL_ANALOG;
 	core->pads[TVP5150_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	core->pads[TVP5150_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
+	core->pads[TVP5150_PAD_VID_OUT].sig_type = MEDIA_PAD_SIGNAL_DV;
 
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 8984b1bf57a5..f4933e5b4850 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -846,9 +846,9 @@ static void saa7134_create_entities(struct saa7134_dev *dev)
 	if (!decoder) {
 		dev->demod.name = "saa713x";
 		dev->demod_pad[SAA7134_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
-		dev->demod_pad[SAA7134_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
+		dev->demod_pad[SAA7134_PAD_IF_INPUT].sig_type = MEDIA_PAD_SIGNAL_ANALOG;
 		dev->demod_pad[SAA7134_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-		dev->demod_pad[SAA7134_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
+		dev->demod_pad[SAA7134_PAD_VID_OUT].sig_type = MEDIA_PAD_SIGNAL_DV;
 		dev->demod.function = MEDIA_ENT_F_ATV_DECODER;
 
 		ret = media_entity_pads_init(&dev->demod, SAA7134_NUM_PADS,
diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index d389f1fc237a..17992f9fab09 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -469,11 +469,11 @@ static int si2157_probe(struct i2c_client *client,
 		dev->ent.function = MEDIA_ENT_F_TUNER;
 
 		dev->pad[SI2157_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
-		dev->pad[SI2157_PAD_RF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
+		dev->pad[SI2157_PAD_RF_INPUT].sig_type = MEDIA_PAD_SIGNAL_ANALOG;
 		dev->pad[SI2157_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-		dev->pad[SI2157_PAD_VID_OUT].sig_type = PAD_SIGNAL_ANALOG;
+		dev->pad[SI2157_PAD_VID_OUT].sig_type = MEDIA_PAD_SIGNAL_ANALOG;
 		dev->pad[SI2157_PAD_AUD_OUT].flags = MEDIA_PAD_FL_SOURCE;
-		dev->pad[SI2157_PAD_AUD_OUT].sig_type = PAD_SIGNAL_AUDIO;
+		dev->pad[SI2157_PAD_AUD_OUT].sig_type = MEDIA_PAD_SIGNAL_AUDIO;
 
 		ret = media_entity_pads_init(&dev->ent, SI2157_NUM_PADS,
 					     &dev->pad[0]);
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 1fdb1601dc65..484b620879c0 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -267,7 +267,7 @@ static void au0828_media_graph_notify(struct media_entity *new,
 create_link:
 	if (decoder && mixer) {
 		ret = media_get_pad_index(decoder, false,
-					  PAD_SIGNAL_AUDIO);
+					  MEDIA_PAD_SIGNAL_AUDIO);
 		if (ret >= 0)
 			ret = media_create_pad_link(decoder, ret,
 						    mixer, 0,
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index 85cdf593a9ad..1ebe04a3e7dd 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -893,9 +893,9 @@ static int mxl111sf_attach_tuner(struct dvb_usb_adapter *adap)
 	state->tuner.function = MEDIA_ENT_F_TUNER;
 	state->tuner.name = "mxl111sf tuner";
 	state->tuner_pads[MXL111SF_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
-	state->tuner_pads[MXL111SF_PAD_RF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
+	state->tuner_pads[MXL111SF_PAD_RF_INPUT].sig_type = MEDIA_PAD_SIGNAL_ANALOG;
 	state->tuner_pads[MXL111SF_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->tuner_pads[MXL111SF_PAD_OUTPUT].sig_type = PAD_SIGNAL_ANALOG;
+	state->tuner_pads[MXL111SF_PAD_OUTPUT].sig_type = MEDIA_PAD_SIGNAL_ANALOG;
 
 	ret = media_entity_pads_init(&state->tuner,
 				     MXL111SF_NUM_PADS, state->tuner_pads);
diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 03a340cb5a9b..061b13821367 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -732,20 +732,20 @@ static int tuner_probe(struct i2c_client *client,
 	 */
 	if (t->type == TUNER_TDA9887) {
 		t->pad[IF_VID_DEC_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
-		t->pad[IF_VID_DEC_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
+		t->pad[IF_VID_DEC_PAD_IF_INPUT].sig_type = MEDIA_PAD_SIGNAL_ANALOG;
 		t->pad[IF_VID_DEC_PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
-		t->pad[IF_VID_DEC_PAD_OUT].sig_type = PAD_SIGNAL_ANALOG;
+		t->pad[IF_VID_DEC_PAD_OUT].sig_type = MEDIA_PAD_SIGNAL_ANALOG;
 		ret = media_entity_pads_init(&t->sd.entity,
 					     IF_VID_DEC_PAD_NUM_PADS,
 					     &t->pad[0]);
 		t->sd.entity.function = MEDIA_ENT_F_IF_VID_DECODER;
 	} else {
 		t->pad[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
-		t->pad[TUNER_PAD_RF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
+		t->pad[TUNER_PAD_RF_INPUT].sig_type = MEDIA_PAD_SIGNAL_ANALOG;
 		t->pad[TUNER_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
-		t->pad[TUNER_PAD_OUTPUT].sig_type = PAD_SIGNAL_ANALOG;
+		t->pad[TUNER_PAD_OUTPUT].sig_type = MEDIA_PAD_SIGNAL_ANALOG;
 		t->pad[TUNER_PAD_AUD_OUT].flags = MEDIA_PAD_FL_SOURCE;
-		t->pad[TUNER_PAD_AUD_OUT].sig_type = PAD_SIGNAL_AUDIO;
+		t->pad[TUNER_PAD_AUD_OUT].sig_type = MEDIA_PAD_SIGNAL_AUDIO;
 		ret = media_entity_pads_init(&t->sd.entity, TUNER_NUM_PADS,
 					     &t->pad[0]);
 		t->sd.entity.function = MEDIA_ENT_F_TUNER;
diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 014a2a97cadd..f559e47cf8e8 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -106,9 +106,9 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	if (tuner) {
 		if (if_vid) {
 			pad_source = media_get_pad_index(tuner, false,
-							 PAD_SIGNAL_ANALOG);
+							 MEDIA_PAD_SIGNAL_ANALOG);
 			pad_sink = media_get_pad_index(if_vid, true,
-						       PAD_SIGNAL_ANALOG);
+						       MEDIA_PAD_SIGNAL_ANALOG);
 			if (pad_source < 0 || pad_sink < 0) {
 				dev_warn(mdev->dev, "Couldn't get tuner and/or PLL pad(s): (%d, %d)\n",
 					 pad_source, pad_sink);
@@ -123,9 +123,9 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 			}
 
 			pad_source = media_get_pad_index(if_vid, false,
-							 PAD_SIGNAL_ANALOG);
+							 MEDIA_PAD_SIGNAL_ANALOG);
 			pad_sink = media_get_pad_index(decoder, true,
-						       PAD_SIGNAL_ANALOG);
+						       MEDIA_PAD_SIGNAL_ANALOG);
 			if (pad_source < 0 || pad_sink < 0) {
 				dev_warn(mdev->dev, "get decoder and/or PLL pad(s): (%d, %d)\n",
 					 pad_source, pad_sink);
@@ -140,9 +140,9 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 			}
 		} else {
 			pad_source = media_get_pad_index(tuner, false,
-							 PAD_SIGNAL_ANALOG);
+							 MEDIA_PAD_SIGNAL_ANALOG);
 			pad_sink = media_get_pad_index(decoder, true,
-						       PAD_SIGNAL_ANALOG);
+						       MEDIA_PAD_SIGNAL_ANALOG);
 			if (pad_source < 0 || pad_sink < 0) {
 				dev_warn(mdev->dev, "couldn't get tuner and/or decoder pad(s): (%d, %d)\n",
 					 pad_source, pad_sink);
@@ -157,9 +157,9 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 
 		if (if_aud) {
 			pad_source = media_get_pad_index(tuner, false,
-							 PAD_SIGNAL_AUDIO);
+							 MEDIA_PAD_SIGNAL_AUDIO);
 			pad_sink = media_get_pad_index(if_aud, true,
-						       PAD_SIGNAL_AUDIO);
+						       MEDIA_PAD_SIGNAL_AUDIO);
 			if (pad_source < 0 || pad_sink < 0) {
 				dev_warn(mdev->dev, "couldn't get tuner and/or decoder pad(s) for audio: (%d, %d)\n",
 					 pad_source, pad_sink);
@@ -180,7 +180,7 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 
 	/* Create demod to V4L, VBI and SDR radio links */
 	if (io_v4l) {
-		pad_source = media_get_pad_index(decoder, false, PAD_SIGNAL_DV);
+		pad_source = media_get_pad_index(decoder, false, MEDIA_PAD_SIGNAL_DV);
 		if (pad_source < 0) {
 			dev_warn(mdev->dev, "couldn't get decoder output pad for V4L I/O\n");
 			return -EINVAL;
@@ -195,7 +195,7 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	}
 
 	if (io_swradio) {
-		pad_source = media_get_pad_index(decoder, false, PAD_SIGNAL_DV);
+		pad_source = media_get_pad_index(decoder, false, MEDIA_PAD_SIGNAL_DV);
 		if (pad_source < 0) {
 			dev_warn(mdev->dev, "couldn't get decoder output pad for SDR\n");
 			return -EINVAL;
@@ -210,7 +210,7 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	}
 
 	if (io_vbi) {
-		pad_source = media_get_pad_index(decoder, false, PAD_SIGNAL_DV);
+		pad_source = media_get_pad_index(decoder, false, MEDIA_PAD_SIGNAL_DV);
 		if (pad_source < 0) {
 			dev_warn(mdev->dev, "couldn't get decoder output pad for VBI\n");
 			return -EINVAL;
@@ -232,7 +232,7 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 			if (!tuner)
 				continue;
 			pad_sink = media_get_pad_index(tuner, true,
-						       PAD_SIGNAL_ANALOG);
+						       MEDIA_PAD_SIGNAL_ANALOG);
 			if (pad_sink < 0) {
 				dev_warn(mdev->dev, "couldn't get tuner analog pad sink\n");
 				return -EINVAL;
@@ -244,7 +244,7 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 		case MEDIA_ENT_F_CONN_SVIDEO:
 		case MEDIA_ENT_F_CONN_COMPOSITE:
 			pad_sink = media_get_pad_index(decoder, true,
-						       PAD_SIGNAL_ANALOG);
+						       MEDIA_PAD_SIGNAL_ANALOG);
 			if (pad_sink < 0) {
 				dev_warn(mdev->dev, "couldn't get tuner analog pad sink\n");
 				return -EINVAL;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index e5f6960d92f6..837f806593f5 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -156,31 +156,31 @@ struct media_link {
 };
 
 /**
- * enum media_pad_signal_type - type of the signal inside a media pad
+ * enum media_pad_signal_type - type of the signal carried by a media pad
  *
- * @PAD_SIGNAL_DEFAULT:
- *	Default signal. Use this when all inputs or all outputs are
- *	uniquely identified by the pad number.
- * @PAD_SIGNAL_ANALOG:
- *	The pad contains an analog signal. It can be Radio Frequency,
+ * @MEDIA_PAD_SIGNAL_DEFAULT:
+ *	Default signal. Default signal. Use this when there's no need to
+ *	specify the signal carried inside a pad.
+ * @MEDIA_PAD_SIGNAL_ANALOG:
+ *	The pad carries an analog signal. It can be Radio Frequency,
  *	Intermediate Frequency, a baseband signal or sub-cariers.
  *	Tuner inputs, IF-PLL demodulators, composite and s-video signals
  *	should use it.
- * @PAD_SIGNAL_DV:
- *	Contains a digital video signal, with can be a bitstream of samples
+ * @MEDIA_PAD_SIGNAL_DV:
+ *	Pad carries a digital video signal, with can be a bitstream of samples
  *	taken from an analog TV video source. On such case, it usually
  *	contains the VBI data on it.
- * @PAD_SIGNAL_AUDIO:
- *	Contains an Intermediate Frequency analog signal from an audio
+ * @MEDIA_PAD_SIGNAL_AUDIO:
+ *	Pad carries an Intermediate Frequency analog signal from an audio
  *	sub-carrier or an audio bitstream. IF signals are provided by tuners
  *	and consumed by	audio AM/FM decoders. Bitstream audio is provided by
  *	an audio decoder.
  */
 enum media_pad_signal_type {
-	PAD_SIGNAL_DEFAULT = 0,
-	PAD_SIGNAL_ANALOG,
-	PAD_SIGNAL_DV,
-	PAD_SIGNAL_AUDIO,
+	MEDIA_PAD_SIGNAL_DEFAULT = 0,
+	MEDIA_PAD_SIGNAL_ANALOG,
+	MEDIA_PAD_SIGNAL_DV,
+	MEDIA_PAD_SIGNAL_AUDIO,
 };
 
 /**
@@ -189,7 +189,11 @@ enum media_pad_signal_type {
  * @graph_obj:	Embedded structure containing the media object common data
  * @entity:	Entity this pad belongs to
  * @index:	Pad index in the entity pads array, numbered from 0 to n
- * @sig_type:	Type of the signal inside a media pad
+ * @sig_type:	Type of the signal that a media pad supports. This is used
+ *		when an entity function may have different kinds of signals
+ *		on different pads of the same direction (source/sink). For
+ *		example, if an entity has 2 pad sinks where one carries
+ *		an analog video while the other carries an audio signal.
  * @flags:	Pad flags, as defined in
  *		:ref:`include/uapi/linux/media.h <media_header>`
  *		(seek for ``MEDIA_PAD_FL_*``)
