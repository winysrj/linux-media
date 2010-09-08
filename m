Return-path: <mchehab@pedra>
Received: from bombadil.infradead.org ([18.85.46.34]:57882 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab0IHUNW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 16:13:22 -0400
Message-ID: <4C87EE63.1040605@infradead.org>
Date: Wed, 08 Sep 2010 17:13:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: raja_mani@ti.com
CC: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	matti.j.aaltonen@nokia.com, Pramodh AG <pramodh_ag@ti.com>
Subject: Re: [RFC/PATCH 2/8] include:linux:videodev2: Define new CIDs for
 FM RX ctls
References: <1283443080-30644-1-git-send-email-raja_mani@ti.com> <1283443080-30644-2-git-send-email-raja_mani@ti.com> <1283443080-30644-3-git-send-email-raja_mani@ti.com>
In-Reply-To: <1283443080-30644-3-git-send-email-raja_mani@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 02-09-2010 12:57, raja_mani@ti.com escreveu:
> From: Raja Mani <raja_mani@ti.com>
> 
> Extend V4L2 CID list to support
>    1) FM RX Tuner controls
>    2) FM band
>    3) RSSI Threshold
>    4) Alternative Frequency

Hmm... no DocBooks for RSSI and "Alternative Frequency"... How do you expect me to review
new API additions if you aren't properly documenting and justifying the need for those
additions?

Cheers,
Mauro
> 
> Signed-off-by: Raja Mani <raja_mani@ti.com>
> Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
> ---
>  include/linux/videodev2.h |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 7c99acf..2798137 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -964,6 +964,7 @@ struct v4l2_writeback_ioctl_data {
>  #define V4L2_CTRL_CLASS_MPEG 0x00990000	/* MPEG-compression controls */
>  #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
>  #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
> +#define V4L2_CTRL_CLASS_FM_RX 0x009c0000	/* FM Tuner control class */
>  
>  #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
>  #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
> @@ -1362,6 +1363,23 @@ enum v4l2_preemphasis {
>  #define V4L2_CID_TUNE_POWER_LEVEL		(V4L2_CID_FM_TX_CLASS_BASE + 113)
>  #define V4L2_CID_TUNE_ANTENNA_CAPACITOR		(V4L2_CID_FM_TX_CLASS_BASE + 114)
>  
> +/* FM Tuner class control IDs */
> +#define V4L2_CID_FM_RX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_RX | 0x900)
> +#define V4L2_CID_FM_RX_CLASS			(V4L2_CTRL_CLASS_FM_RX | 1)
> +
> +#define V4L2_CID_FM_BAND			(V4L2_CID_FM_RX_CLASS_BASE + 1)
> +enum v4l2_fm_band {
> +	V4L2_FM_BAND_OTHER	= 0,
> +	V4L2_FM_BAND_JAPAN	= 1,
> +	V4L2_FM_BAND_OIRT	= 2
> +};
> +#define V4L2_CID_RSSI_THRESHOLD			(V4L2_CID_FM_RX_CLASS_BASE + 2)
> +#define V4L2_CID_TUNE_AF			(V4L2_CID_FM_RX_CLASS_BASE + 3)
> +enum v4l2_tune_af {
> +	V4L2_FM_AF_OFF		= 0,
> +	V4L2_FM_AF_ON		= 1
> +};
> +
>  /*
>   *	T U N I N G
>   */

