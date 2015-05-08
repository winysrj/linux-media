Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57968 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbbEHM6B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 08:58:01 -0400
Date: Fri, 8 May 2015 09:57:54 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Olli Salonen <olli.salonen@iki.fi>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 07/18] media controller: rename the tuner entity
Message-ID: <20150508095754.1c39a276@recife.lan>
In-Reply-To: <554CA862.8070407@xs4all.nl>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
	<6d88ece22cbbbaa72bbddb8b152b0d62728d6129.1431046915.git.mchehab@osg.samsung.com>
	<554CA862.8070407@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 08 May 2015 14:13:22 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
> > Finally, let's rename the tuner entity. inside the media subsystem,
> > a tuner can be used by AM/FM radio, SDR radio, analog TV and digital TV.
> > It could even be used on other subsystems, like network, for wireless
> > devices.
> > 
> > So, it is not constricted to V4L2 API, or to a subdev.
> > 
> > Let's then rename it as:
> > 	MEDIA_ENT_T_V4L2_SUBDEV_TUNER -> MEDIA_ENT_T_TUNER
> 
> See patch 04/18.

Mapping the tuner as a V4L2_SUBDEV is plain wrong. We can't assume
that a tuner will always be mapped via V4L2 subdev API.

> 
> 	Hans
> 
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> > index 9b3861058f0d..5c7f366bb1f4 100644
> > --- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> > +++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> > @@ -241,7 +241,7 @@
> >  	    signals.</entry>
> >  	  </row>
> >  	  <row>
> > -	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_TUNER</constant></entry>
> > +	    <entry><constant>MEDIA_ENT_T_TUNER</constant></entry>
> >  	    <entry>TV and/or radio tuner</entry>
> >  	  </row>
> >  	</tbody>
> > diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> > index 39846077045e..d6a096495035 100644
> > --- a/drivers/media/dvb-core/dvbdev.c
> > +++ b/drivers/media/dvb-core/dvbdev.c
> > @@ -393,7 +393,7 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
> >  
> >  	media_device_for_each_entity(entity, mdev) {
> >  		switch (entity->type) {
> > -		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
> > +		case MEDIA_ENT_T_TUNER:
> >  			tuner = entity;
> >  			break;
> >  		case MEDIA_ENT_T_DTV_DEMOD:
> > diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
> > index a756f74f0adc..2a7331e3c4a0 100644
> > --- a/drivers/media/usb/cx231xx/cx231xx-cards.c
> > +++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
> > @@ -1213,7 +1213,7 @@ static void cx231xx_create_media_graph(struct cx231xx *dev)
> >  
> >  	media_device_for_each_entity(entity, mdev) {
> >  		switch (entity->type) {
> > -		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
> > +		case MEDIA_ENT_T_TUNER:
> >  			tuner = entity;
> >  			break;
> >  		case MEDIA_ENT_T_ATV_DECODER:
> > diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
> > index abdcffabcb59..ecf4e8a543b3 100644
> > --- a/drivers/media/v4l2-core/tuner-core.c
> > +++ b/drivers/media/v4l2-core/tuner-core.c
> > @@ -696,7 +696,7 @@ static int tuner_probe(struct i2c_client *client,
> >  register_client:
> >  #if defined(CONFIG_MEDIA_CONTROLLER)
> >  	t->pad.flags = MEDIA_PAD_FL_SOURCE;
> > -	t->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_TUNER;
> > +	t->sd.entity.type = MEDIA_ENT_T_TUNER;
> >  	t->sd.entity.name = t->name;
> >  
> >  	ret = media_entity_init(&t->sd.entity, 1, &t->pad, 0);
> > diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > index 9b3d80e765f0..6acc4be1378c 100644
> > --- a/include/uapi/linux/media.h
> > +++ b/include/uapi/linux/media.h
> > @@ -57,7 +57,7 @@ struct media_device_info {
> >  
> >  #define MEDIA_ENT_T_ATV_DECODER	(MEDIA_ENT_T_CAM_SENSOR + 3)
> >  
> > -#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	(MEDIA_ENT_T_CAM_SENSOR + 4)
> > +#define MEDIA_ENT_T_TUNER	(MEDIA_ENT_T_CAM_SENSOR + 4)
> >  
> >  #if 1
> >  /*
> > @@ -88,6 +88,8 @@ struct media_device_info {
> >  #define MEDIA_ENT_T_V4L2_SUBDEV_LENS	MEDIA_ENT_T_CAM_LENS
> >  
> >  #define MEDIA_ENT_T_V4L2_SUBDEV_DECODER MEDIA_ENT_T_ATV_DECODER
> > +
> > +#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	MEDIA_ENT_T_TUNER
> >  #endif
> >  
> >  /* Used bitmasks for media_entity_desc::flags */
> > 
> 
