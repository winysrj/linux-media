Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:53673 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757795AbbGQOdl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 10:33:41 -0400
Message-ID: <55A91206.7090907@xs4all.nl>
Date: Fri, 17 Jul 2015 16:32:38 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCHv2 1/9] v4l2: rename V4L2_TUNER_ADC to V4L2_TUNER_SDR
References: <1437030298-20944-1-git-send-email-crope@iki.fi> <1437030298-20944-2-git-send-email-crope@iki.fi>
In-Reply-To: <1437030298-20944-2-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/16/2015 09:04 AM, Antti Palosaari wrote:
> SDR receiver has ADC (Analog-to-Digital Converter) and SDR transmitter
> has DAC (Digital-to-Analog Converter) . Originally I though it could
> be good idea to have own type for receiver and transmitter, but now I
> feel one common type for SDR is enough. So lets rename it.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/compat.xml  | 12 ++++++++++++
>  Documentation/DocBook/media/v4l/dev-sdr.xml |  6 +++---
>  Documentation/DocBook/media/v4l/v4l2.xml    |  7 +++++++
>  drivers/media/v4l2-core/v4l2-ioctl.c        |  6 +++---
>  include/uapi/linux/videodev2.h              |  5 ++++-
>  5 files changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index a0aef85..f56faf5 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2591,6 +2591,18 @@ and &v4l2-mbus-framefmt;.
>        </orderedlist>
>      </section>
>  
> +    <section>
> +      <title>V4L2 in Linux 4.2</title>
> +      <orderedlist>
> +	<listitem>
> +	  <para>Renamed <constant>V4L2_TUNER_ADC</constant> to
> +<constant>V4L2_TUNER_SDR</constant>. The use of
> +<constant>V4L2_TUNER_ADC</constant> is deprecated now.
> +	  </para>
> +	</listitem>
> +      </orderedlist>
> +    </section>
> +
>      <section id="other">
>        <title>Relation of V4L2 to other Linux multimedia APIs</title>
>  
> diff --git a/Documentation/DocBook/media/v4l/dev-sdr.xml b/Documentation/DocBook/media/v4l/dev-sdr.xml
> index f890356..3344921 100644
> --- a/Documentation/DocBook/media/v4l/dev-sdr.xml
> +++ b/Documentation/DocBook/media/v4l/dev-sdr.xml
> @@ -44,10 +44,10 @@ frequency.
>      </para>
>  
>      <para>
> -The <constant>V4L2_TUNER_ADC</constant> tuner type is used for ADC tuners, and
> +The <constant>V4L2_TUNER_SDR</constant> tuner type is used for SDR tuners, and
>  the <constant>V4L2_TUNER_RF</constant> tuner type is used for RF tuners. The
> -tuner index of the RF tuner (if any) must always follow the ADC tuner index.
> -Normally the ADC tuner is #0 and the RF tuner is #1.
> +tuner index of the RF tuner (if any) must always follow the SDR tuner index.
> +Normally the SDR tuner is #0 and the RF tuner is #1.
>      </para>
>  
>      <para>
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index e98caa1..c9eedc1 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -151,6 +151,13 @@ Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab,
>  structs, ioctls) must be noted in more detail in the history chapter
>  (compat.xml), along with the possible impact on existing drivers and
>  applications. -->
> +      <revision>
> +	<revnumber>4.2</revnumber>
> +	<date>2015-05-26</date>
> +	<authorinitials>ap</authorinitials>
> +	<revremark>Renamed V4L2_TUNER_ADC to V4L2_TUNER_SDR.
> +	</revremark>
> +      </revision>
>  
>        <revision>
>  	<revnumber>3.21</revnumber>
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 85de455..ef42474 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1637,7 +1637,7 @@ static int v4l_g_frequency(const struct v4l2_ioctl_ops *ops,
>  	struct v4l2_frequency *p = arg;
>  
>  	if (vfd->vfl_type == VFL_TYPE_SDR)
> -		p->type = V4L2_TUNER_ADC;
> +		p->type = V4L2_TUNER_SDR;
>  	else
>  		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
>  				V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
> @@ -1652,7 +1652,7 @@ static int v4l_s_frequency(const struct v4l2_ioctl_ops *ops,
>  	enum v4l2_tuner_type type;
>  
>  	if (vfd->vfl_type == VFL_TYPE_SDR) {
> -		if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_RF)
> +		if (p->type != V4L2_TUNER_SDR && p->type != V4L2_TUNER_RF)
>  			return -EINVAL;
>  	} else {
>  		type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
> @@ -2277,7 +2277,7 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
>  	int err;
>  
>  	if (vfd->vfl_type == VFL_TYPE_SDR) {
> -		if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_RF)
> +		if (p->type != V4L2_TUNER_SDR && p->type != V4L2_TUNER_RF)
>  			return -EINVAL;
>  		type = p->type;
>  	} else {
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 3228fbe..467816cb 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -165,10 +165,13 @@ enum v4l2_tuner_type {
>  	V4L2_TUNER_RADIO	     = 1,
>  	V4L2_TUNER_ANALOG_TV	     = 2,
>  	V4L2_TUNER_DIGITAL_TV	     = 3,
> -	V4L2_TUNER_ADC               = 4,
> +	V4L2_TUNER_SDR               = 4,
>  	V4L2_TUNER_RF                = 5,

I noticed that the new tuner types (SDR/RF) are not documented at all in the
VIDIOC_G_TUNER DocBook spec. Can you document them in vidioc-g-tuner.xml? In
fact, there is currently not even a description for the RADIO and ANALOG_TV
tuner types!

Note that DIGITAL_TV isn't documented either, but that's OK since it shouldn't
be used anymore.

While adding support for SDR output to v4l2-compliance I noticed that struct
v4l2_modulator doesn't have a type field, so there is no way to tell TUNER_SDR
and TUNER_RF apart! (I *knew* the lack of a type field would cause problems at
some point in time...)

I think a type should be added to v4l2_modulator. If it is 0 then it is set
equal to V4L2_TUNER_RADIO for backwards compatibility.

You need to know the type of the modulator because you need that when calling
ENUM_FREQ_BANDS and G/S_FREQUENCY.

Note that vidioc-g-frequency.xml and vidioc-enum-freq-bands.xml need to be
updated since they say that currently only radio modulators (V4L2_TUNER_RADIO)
are supported, which is no longer correct since TUNER_SDR/RF are now also
allowed.

Regards,

	Hans

>  };
>  
> +/* Deprecated, do not use */
> +#define V4L2_TUNER_ADC  V4L2_TUNER_SDR
> +
>  enum v4l2_memory {
>  	V4L2_MEMORY_MMAP             = 1,
>  	V4L2_MEMORY_USERPTR          = 2,
> 

