Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41126 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964834AbbFJNbF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 09:31:05 -0400
Date: Wed, 10 Jun 2015 10:31:00 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/9] v4l2: rename V4L2_TUNER_ADC to V4L2_TUNER_SDR
Message-ID: <20150610103100.7d88239f@recife.lan>
In-Reply-To: <557558BD.9040607@xs4all.nl>
References: <1433592188-31748-1-git-send-email-crope@iki.fi>
	<557558BD.9040607@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 08 Jun 2015 10:56:29 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Antti,
> 
> I am not so sure about this. The situation with TUNER_ADC is similar to TUNER_RADIO:
> we use TUNER_RADIO for radio modulators, even though it is clearly not a tuner type.
> 
> Basically the tuner type is interpreted as going the reverse direction for a modulator.
> 
> Calling it TUNER_SDR means its use is restricted to SDR devices, but perhaps there will
> be other non-SDR devices in the future that have an ADC.
> 
> I wonder if we shouldn't introduce something like this:
> 
> enum v4l2_modulator_type {
> 	V4L2_MODULATOR_RADIO = V4L2_TUNER_RADIO,
> 	V4L2_MODULATOR_DAC = V4L2_TUNER_ADC,
> 	V4L2_MODULATOR_RF = V4L2_TUNER_RF,	/* is this correct? */
> };
> 
> That way apps will have modulator aliases that make sense.
> 
> Mauro, what do you think? This is your area of expertise.

I think that TUNER_SDR is good enough, provided that the caps
are properly filled for devices with RX (capture) or 
TX (output).

I don't think we'll have other "tuner" ADC or DAC devices.

IMHO, the worse case is that we might need to map ADC and DAC
as subdevs in some (likely distant) future.

So,

Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

> 
> Regards,
> 
> 	Hans
> 
> On 06/06/2015 02:03 PM, Antti Palosaari wrote:
> > SDR receiver has ADC (Analog-to-Digital Converter) and SDR transmitter
> > has DAC (Digital-to-Analog Converter) . Originally I though it could
> > be good idea to have own type for receiver and transmitter, but now I
> > feel one common type for SDR is enough. So lets rename it.
> > 
> > Cc: Hans Verkuil <hverkuil@xs4all.nl>
> > Signed-off-by: Antti Palosaari <crope@iki.fi>
> > ---
> >  Documentation/DocBook/media/v4l/compat.xml  | 12 ++++++++++++
> >  Documentation/DocBook/media/v4l/dev-sdr.xml |  6 +++---
> >  Documentation/DocBook/media/v4l/v4l2.xml    |  7 +++++++
> >  drivers/media/v4l2-core/v4l2-ioctl.c        |  6 +++---
> >  include/uapi/linux/videodev2.h              |  5 ++++-
> >  5 files changed, 29 insertions(+), 7 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> > index a0aef85..f56faf5 100644
> > --- a/Documentation/DocBook/media/v4l/compat.xml
> > +++ b/Documentation/DocBook/media/v4l/compat.xml
> > @@ -2591,6 +2591,18 @@ and &v4l2-mbus-framefmt;.
> >        </orderedlist>
> >      </section>
> >  
> > +    <section>
> > +      <title>V4L2 in Linux 4.2</title>
> > +      <orderedlist>
> > +	<listitem>
> > +	  <para>Renamed <constant>V4L2_TUNER_ADC</constant> to
> > +<constant>V4L2_TUNER_SDR</constant>. The use of
> > +<constant>V4L2_TUNER_ADC</constant> is deprecated now.
> > +	  </para>
> > +	</listitem>
> > +      </orderedlist>
> > +    </section>
> > +
> >      <section id="other">
> >        <title>Relation of V4L2 to other Linux multimedia APIs</title>
> >  
> > diff --git a/Documentation/DocBook/media/v4l/dev-sdr.xml b/Documentation/DocBook/media/v4l/dev-sdr.xml
> > index f890356..3344921 100644
> > --- a/Documentation/DocBook/media/v4l/dev-sdr.xml
> > +++ b/Documentation/DocBook/media/v4l/dev-sdr.xml
> > @@ -44,10 +44,10 @@ frequency.
> >      </para>
> >  
> >      <para>
> > -The <constant>V4L2_TUNER_ADC</constant> tuner type is used for ADC tuners, and
> > +The <constant>V4L2_TUNER_SDR</constant> tuner type is used for SDR tuners, and
> >  the <constant>V4L2_TUNER_RF</constant> tuner type is used for RF tuners. The
> > -tuner index of the RF tuner (if any) must always follow the ADC tuner index.
> > -Normally the ADC tuner is #0 and the RF tuner is #1.
> > +tuner index of the RF tuner (if any) must always follow the SDR tuner index.
> > +Normally the SDR tuner is #0 and the RF tuner is #1.
> >      </para>
> >  
> >      <para>
> > diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> > index e98caa1..c9eedc1 100644
> > --- a/Documentation/DocBook/media/v4l/v4l2.xml
> > +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> > @@ -151,6 +151,13 @@ Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab,
> >  structs, ioctls) must be noted in more detail in the history chapter
> >  (compat.xml), along with the possible impact on existing drivers and
> >  applications. -->
> > +      <revision>
> > +	<revnumber>4.2</revnumber>
> > +	<date>2015-05-26</date>
> > +	<authorinitials>ap</authorinitials>
> > +	<revremark>Renamed V4L2_TUNER_ADC to V4L2_TUNER_SDR.
> > +	</revremark>
> > +      </revision>
> >  
> >        <revision>
> >  	<revnumber>3.21</revnumber>
> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> > index 85de455..ef42474 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > @@ -1637,7 +1637,7 @@ static int v4l_g_frequency(const struct v4l2_ioctl_ops *ops,
> >  	struct v4l2_frequency *p = arg;
> >  
> >  	if (vfd->vfl_type == VFL_TYPE_SDR)
> > -		p->type = V4L2_TUNER_ADC;
> > +		p->type = V4L2_TUNER_SDR;
> >  	else
> >  		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
> >  				V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
> > @@ -1652,7 +1652,7 @@ static int v4l_s_frequency(const struct v4l2_ioctl_ops *ops,
> >  	enum v4l2_tuner_type type;
> >  
> >  	if (vfd->vfl_type == VFL_TYPE_SDR) {
> > -		if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_RF)
> > +		if (p->type != V4L2_TUNER_SDR && p->type != V4L2_TUNER_RF)
> >  			return -EINVAL;
> >  	} else {
> >  		type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
> > @@ -2277,7 +2277,7 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
> >  	int err;
> >  
> >  	if (vfd->vfl_type == VFL_TYPE_SDR) {
> > -		if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_RF)
> > +		if (p->type != V4L2_TUNER_SDR && p->type != V4L2_TUNER_RF)
> >  			return -EINVAL;
> >  		type = p->type;
> >  	} else {
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> > index 3d5fc72..3310ce4 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -165,10 +165,13 @@ enum v4l2_tuner_type {
> >  	V4L2_TUNER_RADIO	     = 1,
> >  	V4L2_TUNER_ANALOG_TV	     = 2,
> >  	V4L2_TUNER_DIGITAL_TV	     = 3,
> > -	V4L2_TUNER_ADC               = 4,
> > +	V4L2_TUNER_SDR               = 4,
> >  	V4L2_TUNER_RF                = 5,
> >  };
> >  
> > +/* Deprecated, do not use */
> > +#define V4L2_TUNER_ADC  V4L2_TUNER_SDR
> > +
> >  enum v4l2_memory {
> >  	V4L2_MEMORY_MMAP             = 1,
> >  	V4L2_MEMORY_USERPTR          = 2,
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
