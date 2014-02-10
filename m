Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1205 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaBJJLb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 04:11:31 -0500
Message-ID: <52F89799.2060606@xs4all.nl>
Date: Mon, 10 Feb 2014 10:10:49 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH 3/5] v4l2-ctl: add tuner support for SDR tuners
References: <1391925954-25975-1-git-send-email-crope@iki.fi> <1391925954-25975-4-git-send-email-crope@iki.fi>
In-Reply-To: <1391925954-25975-4-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/09/2014 07:05 AM, Antti Palosaari wrote:
> Add initial SDR support for tuner related operations.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  utils/v4l2-ctl/v4l2-ctl-tuner.cpp | 53 +++++++++++++++++++++++++++++++--------
>  1 file changed, 43 insertions(+), 10 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-tuner.cpp b/utils/v4l2-ctl/v4l2-ctl-tuner.cpp
> index 16e1652..0fc2371 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-tuner.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-tuner.cpp
> @@ -116,6 +116,8 @@ static std::string tcap2s(unsigned cap)
>  
>  	if (cap & V4L2_TUNER_CAP_LOW)
>  		s += "62.5 Hz ";
> +	else if (cap & V4L2_TUNER_CAP_1HZ)
> +		s += "1 Hz ";
>  	else
>  		s += "62.5 kHz ";
>  	if (cap & V4L2_TUNER_CAP_NORM)
> @@ -264,12 +266,24 @@ void tuner_set(int fd)
>  	if (capabilities & V4L2_CAP_MODULATOR) {
>  		type = V4L2_TUNER_RADIO;
>  		modulator.index = tuner_index;
> -		if (doioctl(fd, VIDIOC_G_MODULATOR, &modulator) == 0)
> -			fac = (modulator.capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
> +		if (doioctl(fd, VIDIOC_G_MODULATOR, &modulator) == 0) {
> +			if (modulator.capability & V4L2_TUNER_CAP_LOW)
> +				fac = 16000;
> +			else if (modulator.capability & V4L2_TUNER_CAP_1HZ)
> +				fac = 1000000;
> +			else
> +				fac = 16;
> +		}
>  	} else if (capabilities & V4L2_CAP_TUNER) {
>  		tuner.index = tuner_index;
>  		if (doioctl(fd, VIDIOC_G_TUNER, &tuner) == 0) {
> -			fac = (tuner.capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
> +			if (tuner.capability & V4L2_TUNER_CAP_LOW)
> +				fac = 16000;
> +			else if (tuner.capability & V4L2_TUNER_CAP_1HZ)
> +				fac = 1000000;
> +			else
> +				fac = 16;
> +
>  			type = tuner.type;
>  		}
>  	}
> @@ -310,6 +324,9 @@ void tuner_set(int fd)
>  			if (band.capability & V4L2_TUNER_CAP_LOW)
>  				printf("\tFrequency Range: %.3f MHz - %.3f MHz\n",
>  				     band.rangelow / 16000.0, band.rangehigh / 16000.0);
> +			else if (band.capability & V4L2_TUNER_CAP_1HZ)
> +				printf("\tFrequency Range: %.6f MHz - %.6f MHz\n",
> +				     band.rangelow / 1000000.0, band.rangehigh / 1000000.0);
>  			else
>  				printf("\tFrequency Range: %.3f MHz - %.3f MHz\n",
>  				     band.rangelow / 16.0, band.rangehigh / 16.0);
> @@ -345,13 +362,24 @@ void tuner_get(int fd)
>  		if (capabilities & V4L2_CAP_MODULATOR) {
>  			vf.type = V4L2_TUNER_RADIO;
>  			modulator.index = tuner_index;
> -			if (doioctl(fd, VIDIOC_G_MODULATOR, &modulator) == 0)
> -				fac = (modulator.capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
> +			if (doioctl(fd, VIDIOC_G_MODULATOR, &modulator) == 0) {
> +				if (modulator.capability & V4L2_TUNER_CAP_LOW)
> +					fac = 16000;
> +				else if (modulator.capability & V4L2_TUNER_CAP_1HZ)
> +					fac = 1000000;
> +				else
> +					fac = 16;
> +			}
>  		} else {
>  			vf.type = V4L2_TUNER_ANALOG_TV;
>  			tuner.index = tuner_index;
>  			if (doioctl(fd, VIDIOC_G_TUNER, &tuner) == 0) {
> -				fac = (tuner.capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
> +				if (tuner.capability & V4L2_TUNER_CAP_LOW)
> +					fac = 16000;
> +				else if (tuner.capability & V4L2_TUNER_CAP_1HZ)
> +					fac = 1000000;
> +				else
> +					fac = 16;
>  				vf.type = tuner.type;
>  			}
>  		}
> @@ -373,13 +401,18 @@ void tuner_get(int fd)
>  			if (vt.capability & V4L2_TUNER_CAP_LOW)
>  				printf("\tFrequency range      : %.3f MHz - %.3f MHz\n",
>  				     vt.rangelow / 16000.0, vt.rangehigh / 16000.0);
> +			else if (vt.capability & V4L2_TUNER_CAP_1HZ)
> +				printf("\tFrequency range      : %.6f MHz - %.6f MHz\n",
> +				     vt.rangelow / 1000000.0, vt.rangehigh / 1000000.0);
>  			else
>  				printf("\tFrequency range      : %.3f MHz - %.3f MHz\n",
>  				     vt.rangelow / 16.0, vt.rangehigh / 16.0);
> -			printf("\tSignal strength/AFC  : %d%%/%d\n", (int)((vt.signal / 655.35)+0.5), vt.afc);
> -			printf("\tCurrent audio mode   : %s\n", audmode2s(vt.audmode));
> -			printf("\tAvailable subchannels: %s\n",
> -					rxsubchans2s(vt.rxsubchans).c_str());
> +
> +			if (vt.type != V4L2_TUNER_ADC && vt.type != V4L2_TUNER_RF) {
> +				printf("\tSignal strength/AFC  : %d%%/%d\n", (int)((vt.signal / 655.35)+0.5), vt.afc);
> +				printf("\tCurrent audio mode   : %s\n", audmode2s(vt.audmode));
> +				printf("\tAvailable subchannels: %s\n", rxsubchans2s(vt.rxsubchans).c_str());
> +			}
>  		}
>  	}
>  
> 

