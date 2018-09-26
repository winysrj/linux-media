Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51768 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbeIZUWP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 16:22:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
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
Subject: Re: [PATCH 02/13] media: v4l2: taint pads with the signal types for consumer devices
Date: Wed, 26 Sep 2018 17:09:19 +0300
Message-ID: <3421008.de6ofXCdCx@avalon>
In-Reply-To: <d328b90800498d10d908c67b05bd48bfb78162c0.1533138685.git.mchehab+samsung@kernel.org>
References: <cover.1533138685.git.mchehab+samsung@kernel.org> <d328b90800498d10d908c67b05bd48bfb78162c0.1533138685.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

Could you please CC me on patches touching the media controller core ? I can 
send a MAINTAINERS patch to make sure that gets handled automatically.

On Wednesday, 1 August 2018 18:55:04 EEST Mauro Carvalho Chehab wrote:
> Consumer devices are provided with a wide diferent range of types
> supported by the same driver, allowing different configutations.
> 
> In order to make easier to setup media controller links, "taint"
> pads with the signal type it carries.
> 
> While here, get rid of DEMOD_PAD_VBI_OUT, as the signal it carries
> is actually the same as the normal video output.
> 
> The difference happens at the video/VBI interface:
> 	- for VBI, only the hidden lines are streamed;
> 	- for video, the stream is usually cropped to hide the
> 	  vbi lines.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/dvb-frontends/au8522_decoder.c |  3 ++
>  drivers/media/i2c/msp3400-driver.c           |  2 ++
>  drivers/media/i2c/saa7115.c                  |  2 ++
>  drivers/media/i2c/tvp5150.c                  |  2 ++
>  drivers/media/pci/saa7134/saa7134-core.c     |  2 ++
>  drivers/media/tuners/si2157.c                |  3 ++
>  drivers/media/usb/dvb-usb-v2/mxl111sf.c      |  2 ++
>  drivers/media/v4l2-core/tuner-core.c         |  5 +++
>  include/media/media-entity.h                 | 35 ++++++++++++++++++++
>  9 files changed, 56 insertions(+)

[snip]

> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 3aa3d58d1d58..8bfbe6b59fa9 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -155,6 +155,40 @@ struct media_link {
>  	bool is_backlink;
>  };
> 
> +/**
> + * struct media_pad_signal_type - type of the signal inside a media pad

I'd say "carried by a media pad" instead of "inside a media pad".

> + *
> + * @PAD_SIGNAL_DEFAULT

Shouldn't we use a MEDIA_PAD_ prefix ?

> + *	Default signal. Use this when all inputs or all outputs are
> + *	uniquely identified by the pad number.

How about "Use this when the pad can carry a single signal type" ? I 
understand your formulation as meaning that all pads of the entity have to be 
of the default type, or none can be.

> + * @PAD_SIGNAL_ANALOG

This isn't a very good name given that PAD_SIGNAL_TV_CARRIERS is also analog.

> + *	The pad contains an analog signa. It can be Radio Frequency,

s/signa/signal/

> + *	Intermediate Frequency or baseband signal.
> + *	Tuner inputs, composite and s-video signals should use it.
> + *	On tuner sources, this is used for digital TV demodulators and for
> + *	IF-PLL demodulator like tda9887.
> + * @PAD_SIGNAL_TV_CARRIERS
> + *	The pad contains analog signals carrying either a digital or an analog
> + *	modulated (or baseband) signal.

As above, maybe "The pad carries either ...".

> This is provided by tuner source
> + *	pads and used by analog TV standard decoders and by digital TV demods.
> + * @PAD_SIGNAL_DV
> + *	Contains a digital video signal, with can be a bitstream of samples
> + *	taken from an analog TV video source. On such case, it usually
> + *	contains the VBI data on it.
> + * @PAD_SIGNAL_AUDIO
> + *	Contains an Intermediate Frequency analog signal from an audio
> + *	sub-carrier or an audio bitstream. IF signals are provided by tuners
> + *	and consumed by	audio AM/FM decoders. Bitstream audio is provided by

s/  / /

> + *	an audio decoder.

Generally speaking the types you propose here seem quite ad-hoc, without much 
coherency. For instance you split analog and digital video, but group all 
audio under a single type. It's also not very clear from the description how 
to handle analog video, as it could match both PAD_SIGNAL_ANALOG and 
PAD_SIGNAL_TV_CARRIERS. Both of those types also accept analog baseband 
signals. I think this should be reworked, it doesn't sound very usable except 
for the specific use case that this series tries to address.

> + */
> +enum media_pad_signal_type {
> +	PAD_SIGNAL_DEFAULT = 0,
> +	PAD_SIGNAL_ANALOG,
> +	PAD_SIGNAL_TV_CARRIERS,
> +	PAD_SIGNAL_DV,
> +	PAD_SIGNAL_AUDIO,
> +};
> +
>  /**
>   * struct media_pad - A media pad graph object.
>   *
> @@ -169,6 +203,7 @@ struct media_pad {
>  	struct media_gobj graph_obj;	/* must be first field in struct */
>  	struct media_entity *entity;
>  	u16 index;
> +	enum media_pad_signal_type sig_type;

Missing kerneldoc and Documentation/ update ? It's important to document the 
use cases, and in particular whether the type should be static or can vary (as 
in whether a pad can carry different types over time).

>  	unsigned long flags;
>  };


-- 
Regards,

Laurent Pinchart
