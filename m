Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36360 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936647AbdDZPoC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 11:44:02 -0400
Subject: Re: [patch] autogain support for bayer10 format (was Re: [patch]
 propagating controls in libv4l2)
To: Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan> <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan> <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan> <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan> <20170426132337.GA6482@amd>
Cc: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
        abcloriens@gmail.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
Date: Wed, 26 Apr 2017 18:43:54 +0300
MIME-Version: 1.0
In-Reply-To: <20170426132337.GA6482@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 26.04.2017 16:23, Pavel Machek wrote:
> Hi!
>
>>>> I don't see why it would be hard to open files or have threads inside
>>>> a library. There are several libraries that do that already, specially
>>>> the ones designed to be used on multimidia apps.
>>>
>>> Well, This is what the libv4l2 says:
>>>
>>>    This file implements libv4l2, which offers v4l2_ prefixed versions
>>>    of
>>>       open/close/etc. The API is 100% the same as directly opening
>>>    /dev/videoX
>>>       using regular open/close/etc, the big difference is that format
>>>    conversion
>>>
>>> but if I open additional files in v4l2_open(), API is no longer the
>>> same, as unix open() is defined to open just one file descriptor.
>>>
>>> Now. There is autogain support in libv4lconvert, but it expects to use
>>> same fd for camera and for the gain... which does not work with
>>> subdevs.
>>>
>>> Of course, opening subdevs by name like this is not really
>>> acceptable. But can you suggest a method that is?
>>
>> There are two separate things here:
>>
>> 1) Autofoucs for a device that doesn't use subdev API
>> 2) libv4l2 support for devices that require MC and subdev API
>
> Actually there are three: 0) autogain. Unfortunately, I need autogain
> first before autofocus has a chance...
>
> And that means... bayer10 support for autogain.
>
> Plus, I changed avg_lum to long long. Quick calculation tells me int
> could overflow with few megapixel sensor.
>
> Oh, btw http://ytse.tricolour.net/docs/LowLightOptimization.html no
> longer works.
>
> Regards,
> 								Pavel
>
> diff --git a/lib/libv4lconvert/processing/autogain.c b/lib/libv4lconvert/processing/autogain.c
> index c6866d6..0b52d0f 100644
> --- a/lib/libv4lconvert/processing/autogain.c
> +++ b/lib/libv4lconvert/processing/autogain.c
> @@ -68,6 +71,41 @@ static void autogain_adjust(struct v4l2_queryctrl *ctrl, int *value,
>  	}
>  }
>
> +static int get_luminosity_bayer10(uint16_t *buf, const struct v4l2_format *fmt)
> +{
> +	long long avg_lum = 0;
> +	int x, y;
> +	
> +	buf += fmt->fmt.pix.height * fmt->fmt.pix.bytesperline / 4 +
> +		fmt->fmt.pix.width / 4;
> +
> +	for (y = 0; y < fmt->fmt.pix.height / 2; y++) {
> +		for (x = 0; x < fmt->fmt.pix.width / 2; x++)

That would take some time :). AIUI, we have NEON support in ARM kernels 
(CONFIG_KERNEL_MODE_NEON), I wonder if it makes sense (me) to convert 
the above loop to NEON-optimized when it comes to it? Are there any 
drawbacks in using NEON code in kernel?

> +			avg_lum += *buf++;
> +		buf += fmt->fmt.pix.bytesperline - fmt->fmt.pix.width / 2;
> +	}
> +	avg_lum /= fmt->fmt.pix.height * fmt->fmt.pix.width / 4;
> +	avg_lum /= 4;
> +	return avg_lum;
> +}
> +
> +static int get_luminosity_bayer8(unsigned char *buf, const struct v4l2_format *fmt)
> +{
> +	long long avg_lum = 0;
> +	int x, y;
> +	
> +	buf += fmt->fmt.pix.height * fmt->fmt.pix.bytesperline / 4 +
> +		fmt->fmt.pix.width / 4;
> +
> +	for (y = 0; y < fmt->fmt.pix.height / 2; y++) {
> +		for (x = 0; x < fmt->fmt.pix.width / 2; x++)

ditto.

> +			avg_lum += *buf++;
> +		buf += fmt->fmt.pix.bytesperline - fmt->fmt.pix.width / 2;
> +	}
> +	avg_lum /= fmt->fmt.pix.height * fmt->fmt.pix.width / 4;
> +	return avg_lum;
> +}
> +
>  /* auto gain and exposure algorithm based on the knee algorithm described here:
>  http://ytse.tricolour.net/docs/LowLightOptimization.html */
>  static int autogain_calculate_lookup_tables(
> @@ -100,17 +142,16 @@ static int autogain_calculate_lookup_tables(
>  	switch (fmt->fmt.pix.pixelformat) {
> +	case V4L2_PIX_FMT_SGBRG10:
> +	case V4L2_PIX_FMT_SGRBG10:
> +	case V4L2_PIX_FMT_SBGGR10:
> +	case V4L2_PIX_FMT_SRGGB10:
> +		avg_lum = get_luminosity_bayer10((void *) buf, fmt);
> +		break;
> +
>  	case V4L2_PIX_FMT_SGBRG8:
>  	case V4L2_PIX_FMT_SGRBG8:
>  	case V4L2_PIX_FMT_SBGGR8:
>  	case V4L2_PIX_FMT_SRGGB8:
> -		buf += fmt->fmt.pix.height * fmt->fmt.pix.bytesperline / 4 +
> -			fmt->fmt.pix.width / 4;
> -
> -		for (y = 0; y < fmt->fmt.pix.height / 2; y++) {
> -			for (x = 0; x < fmt->fmt.pix.width / 2; x++)
> -				avg_lum += *buf++;
> -			buf += fmt->fmt.pix.bytesperline - fmt->fmt.pix.width / 2;
> -		}
> -		avg_lum /= fmt->fmt.pix.height * fmt->fmt.pix.width / 4;
> +		avg_lum = get_luminosity_bayer8(buf, fmt);
>  		break;
>
>  	case V4L2_PIX_FMT_RGB24:
> diff --git a/lib/libv4lconvert/processing/libv4lprocessing.c b/lib/libv4lconvert/processing/libv4lprocessing.c
> index b061f50..b98d024 100644
> --- a/lib/libv4lconvert/processing/libv4lprocessing.c
> +++ b/lib/libv4lconvert/processing/libv4lprocessing.c
> @@ -164,6 +165,10 @@ void v4lprocessing_processing(struct v4lprocessing_data *data,
>  	case V4L2_PIX_FMT_SGRBG8:
>  	case V4L2_PIX_FMT_SBGGR8:
>  	case V4L2_PIX_FMT_SRGGB8:
> +	case V4L2_PIX_FMT_SGBRG10:
> +	case V4L2_PIX_FMT_SGRBG10:
> +	case V4L2_PIX_FMT_SBGGR10:
> +	case V4L2_PIX_FMT_SRGGB10:
>  	case V4L2_PIX_FMT_RGB24:
>  	case V4L2_PIX_FMT_BGR24:
>  		break;
>
>
>
