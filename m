Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42450 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbeHBLVO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 07:21:14 -0400
Date: Thu, 2 Aug 2018 06:30:52 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 13/13] media: v4l2-mc: get rid of global pad indexes
Message-ID: <20180802063052.409f17f1@coco.lan>
In-Reply-To: <e6bd2bed-2e78-4f65-a886-85a3e9e093da@xs4all.nl>
References: <cover.1533138685.git.mchehab+samsung@kernel.org>
        <d2cdde7935ddda1773cb3127db9472fb8be2dd84.1533138685.git.mchehab+samsung@kernel.org>
        <e6bd2bed-2e78-4f65-a886-85a3e9e093da@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 2 Aug 2018 11:08:52 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/01/18 17:55, Mauro Carvalho Chehab wrote:
> > Now that all drivers are using pad signal types, we can get
> > rid of the global static definition, as routes are stablished
> > using the pad signal type.
> > 
> > The tuner and IF-PLL pads are now used only by the tuner core,
> > so move the definitions to be there.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > ---
> >  drivers/media/v4l2-core/tuner-core.c | 13 +++++
> >  include/media/v4l2-mc.h              | 76 ----------------------------
> >  2 files changed, 13 insertions(+), 76 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
> > index d4c32ccd0930..e35438ca0b50 100644
> > --- a/drivers/media/v4l2-core/tuner-core.c
> > +++ b/drivers/media/v4l2-core/tuner-core.c
> > @@ -97,6 +97,19 @@ static const struct v4l2_subdev_ops tuner_ops;
> >   * Internal struct used inside the driver
> >   */
> >  
> > +enum tuner_pad_index {
> > +	TUNER_PAD_RF_INPUT,
> > +	TUNER_PAD_OUTPUT,
> > +	TUNER_PAD_AUD_OUT,
> > +	TUNER_NUM_PADS
> > +};
> > +
> > +enum if_vid_dec_pad_index {
> > +	IF_VID_DEC_PAD_IF_INPUT,
> > +	IF_VID_DEC_PAD_OUT,
> > +	IF_VID_DEC_PAD_NUM_PADS
> > +};  
> 
> Shouldn't the enum documentation be copied as well instead of just the
> enums themselves?

I was in doubt about that too :-)

When this was global, documentation was a need, as all drivers should
do the same. Now that it is local, and all external parties use are
the sig_types, the information became less relevant, being internal to
tuner-core.

Yet, it doesn't hurt copying the documentation here, so I'll add it.

See enclosed.

Thanks,
Mauro

[PATCHv2 13/13] media: v4l2-mc: get rid of global pad indexes

Now that all drivers are using pad signal types, we can get
rid of the global static definition, as routes are stablished
using the pad signal type.

The tuner and IF-PLL pads are now used only by the tuner core,
so move the definitions to be there.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index d4c32ccd0930..47228145473f 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -94,9 +94,56 @@ static const struct v4l2_subdev_ops tuner_ops;
 } while (0)
 
 /*
- * Internal struct used inside the driver
+ * Internal enums/struct used inside the driver
  */
 
+/**
+ * enum tuner_pad_index - tuner pad index for MEDIA_ENT_F_TUNER
+ *
+ * @TUNER_PAD_RF_INPUT:
+ *	Radiofrequency (RF) sink pad, usually linked to a RF connector entity.
+ * @TUNER_PAD_OUTPUT:
+ *	tuner video output source pad. Contains the video chrominance
+ *	and luminance or the hole bandwidth of the signal converted to
+ *	an Intermediate Frequency (IF) or to baseband (on zero-IF tuners).
+ * @TUNER_PAD_AUD_OUT:
+ *	Tuner audio output source pad. Tuners used to decode analog TV
+ *	signals have an extra pad for audio output. Old tuners use an
+ *	analog stage with a saw filter for the audio IF frequency. The
+ *	output of the pad is, in this case, the audio IF, with should be
+ *	decoded either by the bridge chipset (that's the case of cx2388x
+ *	chipsets) or may require an external IF sound processor, like
+ *	msp34xx. On modern silicon tuners, the audio IF decoder is usually
+ *	incorporated at the tuner. On such case, the output of this pad
+ *	is an audio sampled data.
+ * @TUNER_NUM_PADS:
+ *	Number of pads of the tuner.
+ */
+enum tuner_pad_index {
+	TUNER_PAD_RF_INPUT,
+	TUNER_PAD_OUTPUT,
+	TUNER_PAD_AUD_OUT,
+	TUNER_NUM_PADS
+};
+
+/**
+ * enum if_vid_dec_pad_index - video IF-PLL pad index
+ *	for MEDIA_ENT_F_IF_VID_DECODER
+ *
+ * @IF_VID_DEC_PAD_IF_INPUT:
+ *	video Intermediate Frequency (IF) sink pad
+ * @IF_VID_DEC_PAD_OUT:
+ * 	IF-PLL video output source pad. Contains the video chrominance
+ *	and luminance IF signals.
+ * @IF_VID_DEC_PAD_NUM_PADS:
+ *	Number of pads of the video IF-PLL.
+ */
+enum if_vid_dec_pad_index {
+	IF_VID_DEC_PAD_IF_INPUT,
+	IF_VID_DEC_PAD_OUT,
+	IF_VID_DEC_PAD_NUM_PADS
+};
+
 struct tuner {
 	/* device */
 	struct dvb_frontend fe;
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 7c9c781b16a9..bf5043c1ab6b 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -23,82 +23,6 @@
 #include <media/v4l2-dev.h>
 #include <linux/types.h>
 
-/**
- * enum tuner_pad_index - tuner pad index for MEDIA_ENT_F_TUNER
- *
- * @TUNER_PAD_RF_INPUT:	Radiofrequency (RF) sink pad, usually linked to a
- *			RF connector entity.
- * @TUNER_PAD_OUTPUT:	Tuner video output source pad. Contains the video
- *			chrominance and luminance or the hole bandwidth
- *			of the signal converted to an Intermediate Frequency
- *			(IF) or to baseband (on zero-IF tuners).
- * @TUNER_PAD_AUD_OUT:	Tuner audio output source pad. Tuners used to decode
- *			analog TV signals have an extra pad for audio output.
- *			Old tuners use an analog stage with a saw filter for
- *			the audio IF frequency. The output of the pad is, in
- *			this case, the audio IF, with should be decoded either
- *			by the bridge chipset (that's the case of cx2388x
- *			chipsets) or may require an external IF sound
- *			processor, like msp34xx. On modern silicon tuners,
- *			the audio IF decoder is usually incorporated at the
- *			tuner. On such case, the output of this pad is an
- *			audio sampled data.
- * @TUNER_NUM_PADS:	Number of pads of the tuner.
- */
-enum tuner_pad_index {
-	TUNER_PAD_RF_INPUT,
-	TUNER_PAD_OUTPUT,
-	TUNER_PAD_AUD_OUT,
-	TUNER_NUM_PADS
-};
-
-/**
- * enum if_vid_dec_pad_index - video IF-PLL pad index for
- *			   MEDIA_ENT_F_IF_VID_DECODER
- *
- * @IF_VID_DEC_PAD_IF_INPUT:	video Intermediate Frequency (IF) sink pad
- * @IF_VID_DEC_PAD_OUT:		IF-PLL video output source pad. Contains the
- *				video chrominance and luminance IF signals.
- * @IF_VID_DEC_PAD_NUM_PADS:	Number of pads of the video IF-PLL.
- */
-enum if_vid_dec_pad_index {
-	IF_VID_DEC_PAD_IF_INPUT,
-	IF_VID_DEC_PAD_OUT,
-	IF_VID_DEC_PAD_NUM_PADS
-};
-
-/**
- * enum if_aud_dec_pad_index - audio/sound IF-PLL pad index for
- *			   MEDIA_ENT_F_IF_AUD_DECODER
- *
- * @IF_AUD_DEC_PAD_IF_INPUT:	audio Intermediate Frequency (IF) sink pad
- * @IF_AUD_DEC_PAD_OUT:		IF-PLL audio output source pad. Contains the
- *				audio sampled stream data, usually connected
- *				to the bridge bus via an Inter-IC Sound (I2S)
- *				bus.
- * @IF_AUD_DEC_PAD_NUM_PADS:	Number of pads of the audio IF-PLL.
- */
-enum if_aud_dec_pad_index {
-	IF_AUD_DEC_PAD_IF_INPUT,
-	IF_AUD_DEC_PAD_OUT,
-	IF_AUD_DEC_PAD_NUM_PADS
-};
-
-/**
- * enum demod_pad_index - analog TV pad index for MEDIA_ENT_F_ATV_DECODER
- *
- * @DEMOD_PAD_IF_INPUT:	IF input sink pad.
- * @DEMOD_PAD_VID_OUT:	Video output source pad.
- * @DEMOD_PAD_AUDIO_OUT: Audio output source pad.
- * @DEMOD_NUM_PADS:	Maximum number of output pads.
- */
-enum demod_pad_index {
-	DEMOD_PAD_IF_INPUT,
-	DEMOD_PAD_VID_OUT,
-	DEMOD_PAD_AUDIO_OUT,
-	DEMOD_NUM_PADS
-};
-
 /* We don't need to include pci.h or usb.h here */
 struct pci_dev;
 struct usb_device;
