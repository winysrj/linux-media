Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab2FSArS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 20:47:18 -0400
Message-ID: <4FDFCC0F.9000208@redhat.com>
Date: Mon, 18 Jun 2012 21:47:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 4/6] videodev2.h: add frequency band information.
References: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl> <005651489cd5c9f832df2d5d90e19e2eee07c9b9.1338201853.git.hans.verkuil@cisco.com>
In-Reply-To: <005651489cd5c9f832df2d5d90e19e2eee07c9b9.1338201853.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-05-2012 07:46, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Hans de Goede <hdegoede@redhat.com>
> ---
>   include/linux/videodev2.h |   19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 2339678..013ee46 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -2023,7 +2023,8 @@ struct v4l2_tuner {
>   	__u32			audmode;
>   	__s32			signal;
>   	__s32			afc;
> -	__u32			reserved[4];
> +	__u32			band;
> +	__u32			reserved[3];
>   };
>   
>   struct v4l2_modulator {
> @@ -2033,7 +2034,8 @@ struct v4l2_modulator {
>   	__u32			rangelow;
>   	__u32			rangehigh;
>   	__u32			txsubchans;
> -	__u32			reserved[4];
> +	__u32			band;
> +	__u32			reserved[3];
>   };
>   
>   /*  Flags for the 'capability' field */
> @@ -2048,6 +2050,11 @@ struct v4l2_modulator {
>   #define V4L2_TUNER_CAP_RDS		0x0080
>   #define V4L2_TUNER_CAP_RDS_BLOCK_IO	0x0100
>   #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
> +#define V4L2_TUNER_CAP_BAND_FM_EUROPE_US     0x00010000
> +#define V4L2_TUNER_CAP_BAND_FM_JAPAN         0x00020000
> +#define V4L2_TUNER_CAP_BAND_FM_RUSSIAN       0x00040000
> +#define V4L2_TUNER_CAP_BAND_FM_WEATHER       0x00080000
> +#define V4L2_TUNER_CAP_BAND_AM_MW            0x00100000

Frequency band is already specified by rangelow/rangehigh.

Why do you need to duplicate this information?


>   
>   /*  Flags for the 'rxsubchans' field */
>   #define V4L2_TUNER_SUB_MONO		0x0001
> @@ -2065,6 +2072,14 @@ struct v4l2_modulator {
>   #define V4L2_TUNER_MODE_LANG1		0x0003
>   #define V4L2_TUNER_MODE_LANG1_LANG2	0x0004
>   
> +/*  Values for the 'band' field */
> +#define V4L2_TUNER_BAND_DEFAULT       0

What does "default" mean?

> +#define V4L2_TUNER_BAND_FM_EUROPE_US  1       /* 87.5 Mhz - 108 MHz */

EUROPE_US is a bad name for this range. According with Wikipedia, this
range is used at "ITU region 1" (Europe/Africa), while America uses 
ITU region 2 (88-108).

In Brazil, the range from 87.5-88 were added several years ago, so it is
currently at the "ITU region 1" range, just like in US.

I don't doubt that there are still some places at the 88-108 MHz range.

> +#define V4L2_TUNER_BAND_FM_JAPAN      2       /* 76 MHz - 90 MHz */

This is currently true, but wikipedia points that they may increase it 
(from 76MHz to 108MHz?) after the end of NTSC broadcast.

The DTV range there starts at channel 14 (473 MHz and upper). Maybe they
may reserve the channel 7-13 range (VHF High - starting at 177 MHz) like
Brazil for DTV. 

Anyway, what I mean is that calling a frequency range with a Country name
is dangerous, as frequency ranges can vary from time to time.

> +#define V4L2_TUNER_BAND_FM_RUSSIAN    3       /* 65.8 MHz - 74 MHz */

AFAIKT, this is wrong. The range used there is 65.8-104MHz.

It used to be 65.8 to 100 MHz.

Also, other ex-soviet countries are still using such range.

> +#define V4L2_TUNER_BAND_FM_WEATHER    4       /* 162.4 MHz - 162.55 MHz */
> +#define V4L2_TUNER_BAND_AM_MW         5
> +
>   struct v4l2_frequency {
>   	__u32		      tuner;
>   	__u32		      type;	/* enum v4l2_tuner_type */
> 

Regards,
Mauro
