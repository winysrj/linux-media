Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab3DTUpl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Apr 2013 16:45:41 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3KKjfZE008911
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 20 Apr 2013 16:45:41 -0400
Date: Sat, 20 Apr 2013 17:45:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv1] [media] V4L2 sdr API: Add fields for
 VIDIOC_[G|S]_TUNER
Message-ID: <20130420174536.64d7b095@redhat.com>
In-Reply-To: <1366488649-14168-1-git-send-email-mchehab@redhat.com>
References: <1366480274-31255-1-git-send-email-mchehab@redhat.com>
	<1366488649-14168-1-git-send-email-mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 20 Apr 2013 17:10:49 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> SDR radio requires some other things at VIDIOC_[G|S]_TUNER.
> Change the ioctl to support them.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

As a convenience for reviewers, I'm posting the SDR API patches here:
	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/sdr

PS.: I rebase my experimental branches there when needed, as this is just a
scratch repository for me to experiment new things.


> ---
>  Documentation/DocBook/media/v4l/vidioc-g-tuner.xml | 30 +++++++++++++---
>  drivers/media/tuners/tuner-xc2028.c                |  2 ++
>  include/uapi/linux/videodev2.h                     | 40 ++++++++++++++++++++--
>  3 files changed, 65 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
> index 6cc8201..b8a3bcf 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
> @@ -200,9 +200,10 @@ audio</entry>
>  <constant>_SAP</constant> flag is cleared in the
>  <structfield>capability</structfield> field, the corresponding
>  <constant>V4L2_TUNER_SUB_</constant> flag must not be set
> -here.</para><para>This field is valid only if this is the tuner of the
> +here.</para>
> +<para>This field is valid only for if this is the tuner of the
>  current video input, or when the structure refers to a radio
> -tuner.</para></entry>
> +tuner. This field is not used by SDR tuners.</para></entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> @@ -216,7 +217,7 @@ unless the requested mode is invalid or unsupported. See <xref
>  the selected and received audio programs do not
>  match.</para><para>Currently this is the only field of struct
>  <structname>v4l2_tuner</structname> applications can
> -change.</para></entry>
> +change. This field is not used by SDR tuners.</para></entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> @@ -234,7 +235,28 @@ settles at zero, &ie; range is what? --></entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> -	    <entry><structfield>reserved</structfield>[4]</entry>
> +	    <entry><structfield>sample_rate</structfield></entry>
> +	    <entry spanname="hspan">Sampling rate used by a SDR tuner, in Hz.
> +		    This value is valid only for SDR tuners.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>bandwidth</structfield></entry>
> +	    <entry spanname="hspan">Bandwidth allowed by the SDR tuner
> +		    low-pass saw filter, in Hz. This value is valid only for
> +		    SDR tuners.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>int_freq</structfield></entry>
> +	    <entry spanname="hspan">Intermediate Frequency (IF) used by
> +	    the tuner, in Hz. This value is valid only for
> +	    <constant>VIDIOC_G_TUNER</constant>, and it is valid only
> +	    on SDR tuners.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved</structfield>[3]</entry>
>  	    <entry spanname="hspan">Reserved for future extensions. Drivers and
>  applications must set the array to zero.</entry>
>  	  </row>
> diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
> index 878d2c4..c61163f 100644
> --- a/drivers/media/tuners/tuner-xc2028.c
> +++ b/drivers/media/tuners/tuner-xc2028.c
> @@ -1020,6 +1020,8 @@ static int generic_set_freq(struct dvb_frontend *fe, u32 freq /* in HZ */,
>  	 * Maybe this might also be needed for DTV.
>  	 */
>  	switch (new_type) {
> +	default:			/* SDR currently not supported */
> +		goto ret;
>  	case V4L2_TUNER_ANALOG_TV:
>  		rc = send_seq(priv, {0x00, 0x00});
>  
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 974c49d..765b646 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -160,6 +160,24 @@ enum v4l2_tuner_type {
>  	V4L2_TUNER_RADIO	     = 1,
>  	V4L2_TUNER_ANALOG_TV	     = 2,
>  	V4L2_TUNER_DIGITAL_TV	     = 3,
> +/*
> + * Even not decoding the signal, SDR tuners may require to adjust IF,
> + * low pass filters, center frequency, etc based on the signal envelope,
> + * and its bandwidth. While we might be using here the V4L2_STD_*
> + * types, plus DVB delsys, that doesn't seem to be the better thing to
> + * do, as:
> + *	1) it would require 64 bits for V4L2 std + 32 bits for DVB std;
> + *	2) non-TV types of envelopes won't work.
> + *
> + * So, add a separate enum to describe the possible types of SDR envelopes.
> + */
> +	V4L2_TUNER_SDR_RADIO,		/* Generic non-optimized Radio range */
> +	V4L2_TUNER_SDR_ATV_PAL,		/* Optimize for Analog TV, PAL */
> +	V4L2_TUNER_SDR_ATV_NTSC,	/* Optimize for Analog TV, NTSC */
> +	V4L2_TUNER_SDR_ATV_SECAM,	/* Optimize for Analog TV, SECAM */
> +	V4L2_TUNER_SDR_DTV_ATSC,	/* Optimize for Digital TV, ATSC */
> +	V4L2_TUNER_SDR_DTV_DVBT,	/* Optimize for Digital TV, DVB-T */
> +	V4L2_TUNER_SDR_DTV_ISDBT,	/* Optimize for Digital TV, ISDB-T */
>  };
>  
>  enum v4l2_memory {
> @@ -1291,6 +1309,7 @@ struct v4l2_querymenu {
>  /*
>   *	T U N I N G
>   */
> +
>  struct v4l2_tuner {
>  	__u32                   index;
>  	__u8			name[32];
> @@ -1298,11 +1317,26 @@ struct v4l2_tuner {
>  	__u32			capability;
>  	__u32			rangelow;
>  	__u32			rangehigh;
> -	__u32			rxsubchans;
> -	__u32			audmode;
> +
> +	union {
> +		/* non-SDR tuners */
> +		struct {
> +			__u32	rxsubchans;
> +			__u32	audmode;
> +		};
> +		/* SDR tuners - audio demod data makes no sense here */
> +		struct {
> +			__u32	sample_rate;	/* Sample rate, in Hz */
> +			__u32	bandwidth;	/* Bandwidth, in Hz */
> +		};
> +	};
> +
>  	__s32			signal;
>  	__s32			afc;
> -	__u32			reserved[4];
> +
> +		__u32	int_freq;	/* Read Only - IF used, in Hz */
> +	/* non-SDR tuners */
> +	__u32		reserved[3];
>  };
>  
>  struct v4l2_modulator {


-- 

Cheers,
Mauro
