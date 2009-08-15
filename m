Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2636 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZHOL5S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Aug 2009 07:57:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: Re: [PATCHv15 2/8] v4l2: video device: Add V4L2_CTRL_CLASS_FM_TX controls
Date: Sat, 15 Aug 2009 13:57:05 +0200
Cc: "ext Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1249729833-24975-1-git-send-email-eduardo.valentin@nokia.com> <1249729833-24975-2-git-send-email-eduardo.valentin@nokia.com> <1249729833-24975-3-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1249729833-24975-3-git-send-email-eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908151357.06045.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 08 August 2009 13:10:27 Eduardo Valentin wrote:
> This patch adds a new class of extended controls. This class
> is intended to support FM Radio Modulators properties such as:
> rds, audio limiters, audio compression, pilot tone generation,
> tuning power levels and preemphasis properties.
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> ---
>  linux/include/linux/videodev2.h |   34 ++++++++++++++++++++++++++++++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/linux/include/linux/videodev2.h b/linux/include/linux/videodev2.h
> index b17898c..a86a575 100644
> --- a/linux/include/linux/videodev2.h
> +++ b/linux/include/linux/videodev2.h
> @@ -817,6 +817,7 @@ struct v4l2_ext_controls {
>  #define V4L2_CTRL_CLASS_USER 0x00980000	/* Old-style 'user' controls */
>  #define V4L2_CTRL_CLASS_MPEG 0x00990000	/* MPEG-compression controls */
>  #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
> +#define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
>  
>  #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
>  #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
> @@ -1156,6 +1157,39 @@ enum  v4l2_exposure_auto_type {
>  
>  #define V4L2_CID_PRIVACY			(V4L2_CID_CAMERA_CLASS_BASE+16)
>  
> +/* FM Modulator class control IDs */
> +#define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
> +#define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
> +
> +#define V4L2_CID_RDS_TX_DEVIATION		(V4L2_CID_FM_TX_CLASS_BASE + 1)
> +#define V4L2_CID_RDS_TX_PI			(V4L2_CID_FM_TX_CLASS_BASE + 2)
> +#define V4L2_CID_RDS_TX_PTY			(V4L2_CID_FM_TX_CLASS_BASE + 3)
> +#define V4L2_CID_RDS_TX_PS_NAME			(V4L2_CID_FM_TX_CLASS_BASE + 4)
> +#define V4L2_CID_RDS_TX_RADIO_TEXT		(V4L2_CID_FM_TX_CLASS_BASE + 5)
> +
> +#define V4L2_CID_AUDIO_LIMITER_ENABLED		(V4L2_CID_FM_TX_CLASS_BASE + 6)
> +#define V4L2_CID_AUDIO_LIMITER_RELEASE_TIME	(V4L2_CID_FM_TX_CLASS_BASE + 7)
> +#define V4L2_CID_AUDIO_LIMITER_DEVIATION	(V4L2_CID_FM_TX_CLASS_BASE + 8)
> +
> +#define V4L2_CID_AUDIO_COMPRESSION_ENABLED	(V4L2_CID_FM_TX_CLASS_BASE + 9)
> +#define V4L2_CID_AUDIO_COMPRESSION_GAIN		(V4L2_CID_FM_TX_CLASS_BASE + 10)
> +#define V4L2_CID_AUDIO_COMPRESSION_THRESHOLD	(V4L2_CID_FM_TX_CLASS_BASE + 11)
> +#define V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME	(V4L2_CID_FM_TX_CLASS_BASE + 12)
> +#define V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME	(V4L2_CID_FM_TX_CLASS_BASE + 13)
> +
> +#define V4L2_CID_PILOT_TONE_ENABLED		(V4L2_CID_FM_TX_CLASS_BASE + 14)
> +#define V4L2_CID_PILOT_TONE_DEVIATION		(V4L2_CID_FM_TX_CLASS_BASE + 15)
> +#define V4L2_CID_PILOT_TONE_FREQUENCY		(V4L2_CID_FM_TX_CLASS_BASE + 16)
> +
> +#define V4L2_CID_FM_TX_PREEMPHASIS		(V4L2_CID_FM_TX_CLASS_BASE + 17)
> +enum v4l2_preemphasis {
> +	V4L2_PREEMPHASIS_DISABLED	= 0,
> +	V4L2_PREEMPHASIS_50_uS		= 1,
> +	V4L2_PREEMPHASIS_75_uS		= 2,
> +};
> +#define V4L2_CID_TUNE_POWER_LEVEL		(V4L2_CID_FM_TX_CLASS_BASE + 18)
> +#define V4L2_CID_TUNE_ANTENNA_CAPACITOR		(V4L2_CID_FM_TX_CLASS_BASE + 19)
> +
>  /*
>   *	T U N I N G
>   */

Hi Eduardo,

I would like to make some small changes here: the control IDs do not have to
be consecutive so I think it is better to leave some gaps between the various
sections: e.g. let the AUDIO controls start at BASE + 64 (leaving more than
enough room for additional RDS controls). Between PTY and PS_NAME we should
skip one control since I'm sure at some time in the future a PTY_NAME will
appear. A comment like '/* placeholder for future PTY_NAME control */' would
be useful as well.

The AUDIO_COMPRESSION controls can start at BASE + 80, the PILOT controls at
BASE + 96 and the last set of controls at BASE + 112.

BTW, wouldn't it be slightly more consistent if V4L2_CID_FM_TX_PREEMPHASIS is
renamed to V4L2_CID_TUNE_PREEMPHASIS? It's a bit of an odd one out at the
moment.

Note that I've verified my compat32 implementation for strings: it's working
correctly on my 64-bit machine (I hacked a string control into vivi.c to do
the testing).

If you agree with these proposed changes, then I can modify the patch myself,
no need for a new patch series.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
