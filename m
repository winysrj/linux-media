Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2804 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207Ab2FBMP2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2012 08:15:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [git:v4l-utils/master] Add HW_SEEK and TUNER_BAND capabilities to videodev2.h
Date: Sat, 2 Jun 2012 14:15:22 +0200
References: <E1San4T-0004po-C8@www.linuxtv.org>
In-Reply-To: <E1San4T-0004po-C8@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206021415.22627.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat June 2 2012 11:11:53 Hans de Goede wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/v4l-utils.git tree:
> 
> Subject: Add HW_SEEK and TUNER_BAND capabilities to videodev2.h
> Author:  Hans de Goede <hdegoede@redhat.com>
> Date:    Sat Jun 2 11:11:53 2012 +0200
> 
> Bring in the pending (reviewed and acked) changes from:

But not merged. I think this is a bit too quick. It is good practice to wait
with making such changes to v4l-utils until Mauro has merged the videodev2.h
changes as well.

You can always make a clone of v4l-utils and keep your changes there until it
can be merged in the main v4l-utils repository.

I also have a small request:

+static const char *band_names[] = {
+       "default",
+       "fm-eur_us",
+       "fm-japan",
+       "fm-russian",
+       "fm-weather",
+       "am-mw",
+};

Can you rename "fm-eur_us" to "fm-eur-us"? That mix of '-' and '_' is very
jarring and awkward to type IMHO.

Regards,

	Hans

> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/bands
> 
> As these are needed to add support for these new API-s to v4l2-ctl.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> 
>  include/linux/videodev2.h |   22 ++++++++++++++++++++--
>  1 files changed, 20 insertions(+), 2 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/v4l-utils.git?a=commitdiff;h=034076b584e9d85fe9087e169b033c7a86706767
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 370d111..fa78098 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -2023,7 +2023,8 @@ struct v4l2_tuner {
>  	__u32			audmode;
>  	__s32			signal;
>  	__s32			afc;
> -	__u32			reserved[4];
> +	__u32			band;
> +	__u32			reserved[3];
>  };
>  
>  struct v4l2_modulator {
> @@ -2033,12 +2034,15 @@ struct v4l2_modulator {
>  	__u32			rangelow;
>  	__u32			rangehigh;
>  	__u32			txsubchans;
> -	__u32			reserved[4];
> +	__u32			band;
> +	__u32			reserved[3];
>  };
>  
>  /*  Flags for the 'capability' field */
>  #define V4L2_TUNER_CAP_LOW		0x0001
>  #define V4L2_TUNER_CAP_NORM		0x0002
> +#define V4L2_TUNER_CAP_HWSEEK_BOUNDED	0x0004
> +#define V4L2_TUNER_CAP_HWSEEK_WRAP	0x0008
>  #define V4L2_TUNER_CAP_STEREO		0x0010
>  #define V4L2_TUNER_CAP_LANG2		0x0020
>  #define V4L2_TUNER_CAP_SAP		0x0020
> @@ -2046,6 +2050,12 @@ struct v4l2_modulator {
>  #define V4L2_TUNER_CAP_RDS		0x0080
>  #define V4L2_TUNER_CAP_RDS_BLOCK_IO	0x0100
>  #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
> +#define V4L2_TUNER_CAP_BAND_FM_EUROPE_US     0x00010000
> +#define V4L2_TUNER_CAP_BAND_FM_JAPAN         0x00020000
> +#define V4L2_TUNER_CAP_BAND_FM_RUSSIAN       0x00040000
> +#define V4L2_TUNER_CAP_BAND_FM_WEATHER       0x00080000
> +#define V4L2_TUNER_CAP_BAND_AM_MW            0x00100000
> +#define V4L2_TUNER_CAP_BANDS_MASK            0x001f0000
>  
>  /*  Flags for the 'rxsubchans' field */
>  #define V4L2_TUNER_SUB_MONO		0x0001
> @@ -2063,6 +2073,14 @@ struct v4l2_modulator {
>  #define V4L2_TUNER_MODE_LANG1		0x0003
>  #define V4L2_TUNER_MODE_LANG1_LANG2	0x0004
>  
> +/*  Values for the 'band' field */
> +#define V4L2_TUNER_BAND_DEFAULT       0
> +#define V4L2_TUNER_BAND_FM_EUROPE_US  1       /* 87.5 Mhz - 108 MHz */
> +#define V4L2_TUNER_BAND_FM_JAPAN      2       /* 76 MHz - 90 MHz */
> +#define V4L2_TUNER_BAND_FM_RUSSIAN    3       /* 65.8 MHz - 74 MHz */
> +#define V4L2_TUNER_BAND_FM_WEATHER    4       /* 162.4 MHz - 162.55 MHz */
> +#define V4L2_TUNER_BAND_AM_MW         5
> +
>  struct v4l2_frequency {
>  	__u32		      tuner;
>  	__u32		      type;	/* enum v4l2_tuner_type */
> 
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
> 
