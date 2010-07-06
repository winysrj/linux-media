Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640Ab0GFCDE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jul 2010 22:03:04 -0400
Message-ID: <4C328ED6.1070705@redhat.com>
Date: Mon, 05 Jul 2010 23:03:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com
Subject: Re: [PATCH v4 1/5] V4L2: Add seek spacing and FM RX class.
References: <1275647663-20650-1-git-send-email-matti.j.aaltonen@nokia.com> <1275647663-20650-2-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1275647663-20650-2-git-send-email-matti.j.aaltonen@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-06-2010 07:34, Matti J. Aaltonen escreveu:
> Add spacing field to v4l2_hw_freq_seek and also add FM RX class to
> control classes.

If you're adding new stuff to API, you should also patch Documentation/DocBook/v4l stuff.
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


You don't need anything special to define the bandwidth. VIDIOC_G_TUNER/VIDIOC_S_TUNER allows
negotiating rangelow/rangehigh.

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

I can't comment on your other API proposals, as you didn't send a patch documenting it
at the API spec.

Cheers,
Mauro.
