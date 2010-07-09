Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1679 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab0GILDe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 07:03:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH v4 1/5] V4L2: Add seek spacing and FM RX class.
Date: Fri, 9 Jul 2010 13:06:02 +0200
Cc: linux-media@vger.kernel.org, eduardo.valentin@nokia.com
References: <1275647663-20650-1-git-send-email-matti.j.aaltonen@nokia.com> <1275647663-20650-2-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1275647663-20650-2-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007091306.02082.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 04 June 2010 12:34:19 Matti J. Aaltonen wrote:
> Add spacing field to v4l2_hw_freq_seek and also add FM RX class to
> control classes.
> 
> Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> ---
>  include/linux/videodev2.h |   15 ++++++++++++++-
>  1 files changed, 14 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 418dacf..95675cd 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -935,6 +935,7 @@ struct v4l2_ext_controls {
>  #define V4L2_CTRL_CLASS_MPEG 0x00990000	/* MPEG-compression controls */
>  #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
>  #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
> +#define V4L2_CTRL_CLASS_FM_RX 0x009c0000	/* FM Tuner control class */
>  
>  #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
>  #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
> @@ -1313,6 +1314,17 @@ enum v4l2_preemphasis {
>  #define V4L2_CID_TUNE_POWER_LEVEL		(V4L2_CID_FM_TX_CLASS_BASE + 113)
>  #define V4L2_CID_TUNE_ANTENNA_CAPACITOR		(V4L2_CID_FM_TX_CLASS_BASE + 114)
>  
> +/* FM Tuner class control IDs */
> +#define V4L2_CID_FM_RX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_RX | 0x900)
> +#define V4L2_CID_FM_RX_CLASS			(V4L2_CTRL_CLASS_FM_RX | 1)
> +
> +#define V4L2_CID_FM_RX_BAND			(V4L2_CID_FM_TX_CLASS_BASE + 1)
> +enum v4l2_fm_rx_band {
> +	V4L2_FM_BAND_OTHER		= 0,
> +	V4L2_FM_BAND_JAPAN		= 1,
> +	V4L2_FM_BAND_OIRT		= 2
> +};

I've been thinking about this a bit more. Would it be possible to do this automatically
in the driver? I.e. based on the frequency you switch the device into the appropriate
band?

If that is not possible, then you shouldn't forget to document this new control in the spec.
When you document it you should give some background information as well: the freq ranges of
these bands and roughly where they are used.

Regards,

	Hans

> +
>  /*
>   *	T U N I N G
>   */
> @@ -1377,7 +1389,8 @@ struct v4l2_hw_freq_seek {
>  	enum v4l2_tuner_type  type;
>  	__u32		      seek_upward;
>  	__u32		      wrap_around;
> -	__u32		      reserved[8];
> +	__u32		      spacing;
> +	__u32		      reserved[7];
>  };
>  
>  /*
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
