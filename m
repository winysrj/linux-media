Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:50194 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbZGYNNh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 09:13:37 -0400
Date: Sat, 25 Jul 2009 16:02:52 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCHv10 3/8] v4l2: video device: Add FM_TX controls default
 configurations
Message-ID: <20090725130252.GA10561@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1248453448-1668-1-git-send-email-eduardo.valentin@nokia.com>
 <1248453448-1668-3-git-send-email-eduardo.valentin@nokia.com>
 <1248453448-1668-4-git-send-email-eduardo.valentin@nokia.com>
 <200907251503.33713.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907251503.33713.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 25, 2009 at 03:03:33PM +0200, ext Hans Verkuil wrote:
> On Friday 24 July 2009 18:37:23 Eduardo Valentin wrote:
> > Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> > ---
> >  linux/drivers/media/video/v4l2-common.c |   63 ++++++++++++++++++++++++++++++-
> >  1 files changed, 62 insertions(+), 1 deletions(-)
> > 
> > diff --git a/linux/drivers/media/video/v4l2-common.c b/linux/drivers/media/video/v4l2-common.c
> > index bd13702..6fc0559 100644
> > --- a/linux/drivers/media/video/v4l2-common.c
> > +++ b/linux/drivers/media/video/v4l2-common.c
> > @@ -343,6 +343,12 @@ const char **v4l2_ctrl_get_menu(u32 id)
> >  		"Sepia",
> >  		NULL
> >  	};
> > +	static const char *fm_tx_preemphasis[] = {
> > +		"No preemphasis",
> > +		"50 useconds",
> > +		"75 useconds",
> > +		NULL,
> > +	};
> >  
> >  	switch (id) {
> >  		case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
> > @@ -381,6 +387,8 @@ const char **v4l2_ctrl_get_menu(u32 id)
> >  			return camera_exposure_auto;
> >  		case V4L2_CID_COLORFX:
> >  			return colorfx;
> > +		case V4L2_CID_FM_TX_PREEMPHASIS:
> > +			return fm_tx_preemphasis;
> >  		default:
> >  			return NULL;
> >  	}
> > @@ -479,6 +487,28 @@ const char *v4l2_ctrl_get_name(u32 id)
> >  	case V4L2_CID_ZOOM_CONTINUOUS:		return "Zoom, Continuous";
> >  	case V4L2_CID_PRIVACY:			return "Privacy";
> >  
> > +	/* FM Radio Modulator control */
> > +	case V4L2_CID_FM_TX_CLASS:		return "FM Radio Modulator Controls";
> > +	case V4L2_CID_RDS_TX_PI:		return "RDS Program ID";
> > +	case V4L2_CID_RDS_TX_PTY:		return "RDS Program Type";
> > +	case V4L2_CID_RDS_TX_DEVIATION:		return "RDS Signal Deviation";
> > +	case V4L2_CID_RDS_TX_PS_NAME:		return "RDS PS Name";
> > +	case V4L2_CID_RDS_TX_RADIO_TEXT:	return "RDS Radio Text";
> > +	case V4L2_CID_AUDIO_LIMITER_ENABLED:	return "Audio Limiter Feature Enabled";
> > +	case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME: return "Audio Limiter Release Time";
> > +	case V4L2_CID_AUDIO_LIMITER_DEVIATION:	return "Audio Limiter Deviation";
> > +	case V4L2_CID_AUDIO_COMPRESSION_ENABLED: return "Audio Compression Feature Enabled";
> > +	case V4L2_CID_AUDIO_COMPRESSION_GAIN:	return "Audio Compression Gain";
> > +	case V4L2_CID_AUDIO_COMPRESSION_THRESHOLD: return "Audio Compression Threshold";
> > +	case V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME: return "Audio Compression Attack Time";
> > +	case V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME: return "Audio Compression Release Time";
> > +	case V4L2_CID_PILOT_TONE_ENABLED:	return "Pilot Tone Feature Enabled";
> > +	case V4L2_CID_PILOT_TONE_DEVIATION:	return "Pilot Tone Deviation";
> > +	case V4L2_CID_PILOT_TONE_FREQUENCY:	return "Pilot Tone Frequency";
> > +	case V4L2_CID_FM_TX_PREEMPHASIS:	return "Pre-emphasis settings";
> > +	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
> > +	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
> > +
> >  	default:
> >  		return NULL;
> >  	}
> > @@ -500,7 +530,18 @@ EXPORT_SYMBOL(v4l2_ctrl_is_value64);
> >   * This information is used inside v4l2_compat_ioctl32. */
> >  int v4l2_ctrl_is_pointer(u32 id)
> >  {
> > -	return 0;
> > +	int is_pointer;
> > +
> > +	switch (id) {
> > +	case V4L2_CID_RDS_TX_PS_NAME:
> > +	case V4L2_CID_RDS_TX_RADIO_TEXT:
> > +		is_pointer = 1;
> > +		break;
> > +	default:
> > +		is_pointer = 0;
> > +	}
> > +
> > +	return is_pointer;
> >  }
> 
> There is no need for a temp variable. Just do this:
> 
> int v4l2_ctrl_is_pointer(u32 id)
> {
> 	switch (id) {
> 	case V4L2_CID_RDS_TX_PS_NAME:
> 	case V4L2_CID_RDS_TX_RADIO_TEXT:
> 		return 1;
> 	default:
> 		return 0;
> 	}
> }
> 
> Regards,
> 
> 	Hans


Right, resending v11 with this minor change.

> 
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

-- 
Eduardo Valentin
