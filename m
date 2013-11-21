Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49908 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab3KUSvR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Nov 2013 13:51:17 -0500
Message-ID: <528E5621.1020301@iki.fi>
Date: Thu, 21 Nov 2013 20:51:13 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: SDR sampling rate - control or IOCTL?
References: <528E3D41.5010508@iki.fi> <20131121154923.32d76094@samsung.com>
In-Reply-To: <20131121154923.32d76094@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21.11.2013 19:49, Mauro Carvalho Chehab wrote:
> Em Thu, 21 Nov 2013 19:05:05 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> Hello
>> I am adding new property for sampling rate that is ideally the only
>> obligatory parameter required by SDR. It is value that could be only
>> positive and bigger the better, lets say unsigned 64 bit is quite ideal.
>> That value sets maximum radio frequency possible to receive (ideal SDR).
>>
>> Valid values are not always in some single range from X to Y, there
>> could be some multiple value ranges.
>>
>> For example possible values: 1000-2000, 23459, 900001-2800000
>>
>> Reading possible values from device could be nice, but not necessary.
>> Reading current value is more important.
>>
>> Here is what I though earlier as a requirements:
>>
>> sampling rate
>> *  values: 1 - infinity (unit: Hz, samples per second)
>>        currently 500 MHz is more than enough
>> *  operations
>>        GET, inquire what HW supports
>>        GET, get current value
>>        SET, set desired value
>>
>>
>> I am not sure what is best way to implement that kind of thing.
>> IOCTL like frequency
>> V4L2 Control?
>> put it into stream format request?
>>
>> Sampling rate is actually frequency of ADC. As there devices has almost
>> always tuner too (practical SDR) there is need for tuner frequency too.
>> As tuner is still own entity, is it possible to use same frequency
>> parameter for both ADC and RF tuner in same device?
>
> Well, a SDR capture device will always have ADC and RF tuner.

No, no no! Look for example Ettus USRP. It is fully modular and you 
could select different RF boards. I think you could even feed I/O from 
your DTV modulator to that that, having no tuner at all.


> A SDR output device will always have a DAC and a RF transmitter.

Nope! Usually you could feed baseband too, no "tuner" at all.

>
> On both cases, the sampling rate and the sampling format are mandatory
> arguments.

Yeah, app needs to know sampling rate and of course stream format. 
Application stream format is typically pair of floats, whilst hardware 
offers integer numbers as a ADC sampling levels.

> In any case, the V4L2 API has already support for setting the mandatory
> parameters of the expected stream, at struct v4l2_format.
>
> So, it makes sense do do:
>
>   struct v4l2_format {
>           __u32    type;
>           union {
>                   struct v4l2_pix_format          pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
>                   struct v4l2_pix_format_mplane   pix_mp;  /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
>                   struct v4l2_window              win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
>                   struct v4l2_vbi_format          vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
>                   struct v4l2_sliced_vbi_format   sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
> +                struct v4l2_sdr_format          sdr;     /* V4L2_BUF_TYPE_SDR_CAPTURE */
>                   __u8    raw_data[200];                   /* user-defined */
>           } fmt;
>   };
>
> And add the mandatory parameters for SDR inside its own structure, e. g.
> struct v4l2_sdr_format. Of course, the meta-data provided by a SDR device
> is different than the one for video or vbi, so you'll need to add a new
> streaming type for SDR anyway.
>
> Btw, that's what I proposed here:
>
> http://git.linuxtv.org/mchehab/experimental.git/blob/refs/heads/sdr:/include/uapi/linux/videodev2.h
>
> With regards to the sampling rate range, my proposal there were to add a min/max
> value for it, to be used by VIDIOC_G_FMT, as proposed on:
> 	http://git.linuxtv.org/mchehab/experimental.git/commitdiff/c3a73f84f038f043aeda5d5bfccc6fea66291451
>
> So, the v4l2_sdr_format should be like:
>
> +struct v4l2_sdr_format {
> +       __u32                           sampleformat;
> +       __u32                           sample_rate;            /* in Hz */
> +       __u32                           min_sample_rate;        /* in Hz */
> +       __u32                           max_sample_rate;        /* in Hz */
> +
> +} __attribute__ ((packed));
>
> Where sampleformat would be something similar to FOURCC, defining the
> size of each sample, its format, and if the sampling is in quadradure,
> if they're plain PCM samples, or something more complex, like DPCM, RLE,
> etc.

Personally I would like to implement that a way driver returns some 
known integer formats. That means, driver does some small conversion, 
reads device specific numbers from device and outputs those to some 
known formats like integers.

But I already moved all that stuff to libv4lconvert.

> In the specific case of enumerating the sampling rate range, if the
> sampling rate can have multiple ranges, then maybe we'll need to do
> something more complex like what was done on VIDIOC_ENUM_FRAMESIZES.
>
> Regards,
> Mauro
>

regards
Antti

-- 
http://palosaari.fi/
