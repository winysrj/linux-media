Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:57967 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab3KUUyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Nov 2013 15:54:55 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWM002I9SPU0Y10@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 21 Nov 2013 15:54:54 -0500 (EST)
Date: Thu, 21 Nov 2013 18:54:49 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	LMML <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: SDR sampling rate - control or IOCTL?
Message-id: <20131121185449.1104ea67@samsung.com>
In-reply-to: <528E6B99.5030108@iki.fi>
References: <528E3D41.5010508@iki.fi> <20131121154923.32d76094@samsung.com>
 <528E4F7B.4040208@xs4all.nl> <528E51EB.2080404@iki.fi>
 <20131121171203.65719175@samsung.com> <528E6B99.5030108@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 21 Nov 2013 22:22:49 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 21.11.2013 21:12, Mauro Carvalho Chehab wrote:
> > Em Thu, 21 Nov 2013 20:33:15 +0200
> > Antti Palosaari <crope@iki.fi> escreveu:
> >
> >> On 21.11.2013 20:22, Hans Verkuil wrote:
> >>> On 11/21/2013 06:49 PM, Mauro Carvalho Chehab wrote:
> >>>> Em Thu, 21 Nov 2013 19:05:05 +0200
> >>>> Antti Palosaari <crope@iki.fi> escreveu:
> >>>>
> >>>>> Hello
> >>>>> I am adding new property for sampling rate that is ideally the only
> >>>>> obligatory parameter required by SDR. It is value that could be only
> >>>>> positive and bigger the better, lets say unsigned 64 bit is quite ideal.
> >>>>> That value sets maximum radio frequency possible to receive (ideal SDR).
> >>>>>
> >>>>> Valid values are not always in some single range from X to Y, there
> >>>>> could be some multiple value ranges.
> >>>>>
> >>>>> For example possible values: 1000-2000, 23459, 900001-2800000
> >>>>>
> >>>>> Reading possible values from device could be nice, but not necessary.
> >>>>> Reading current value is more important.
> >>>>>
> >>>>> Here is what I though earlier as a requirements:
> >>>>>
> >>>>> sampling rate
> >>>>> *  values: 1 - infinity (unit: Hz, samples per second)
> >>>>>         currently 500 MHz is more than enough
> >>>>> *  operations
> >>>>>         GET, inquire what HW supports
> >>>>>         GET, get current value
> >>>>>         SET, set desired value
> >>>>>
> >>>>>
> >>>>> I am not sure what is best way to implement that kind of thing.
> >>>>> IOCTL like frequency
> >>>>> V4L2 Control?
> >>>>> put it into stream format request?
> >>>>>
> >>>>> Sampling rate is actually frequency of ADC. As there devices has almost
> >>>>> always tuner too (practical SDR) there is need for tuner frequency too.
> >>>>> As tuner is still own entity, is it possible to use same frequency
> >>>>> parameter for both ADC and RF tuner in same device?
> >>>>
> >>>> Well, a SDR capture device will always have ADC and RF tuner.
> >>>>
> >>>> A SDR output device will always have a DAC and a RF transmitter.
> >>>>
> >>>> On both cases, the sampling rate and the sampling format are mandatory
> >>>> arguments.
> >>>>
> >>>> In any case, the V4L2 API has already support for setting the mandatory
> >>>> parameters of the expected stream, at struct v4l2_format.
> >>>>
> >>>> So, it makes sense do do:
> >>>>
> >>>>    struct v4l2_format {
> >>>>            __u32    type;
> >>>>            union {
> >>>>                    struct v4l2_pix_format          pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
> >>>>                    struct v4l2_pix_format_mplane   pix_mp;  /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
> >>>>                    struct v4l2_window              win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
> >>>>                    struct v4l2_vbi_format          vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
> >>>>                    struct v4l2_sliced_vbi_format   sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
> >>>> +                struct v4l2_sdr_format          sdr;     /* V4L2_BUF_TYPE_SDR_CAPTURE */
> >>>>                    __u8    raw_data[200];                   /* user-defined */
> >>>>            } fmt;
> >>>>    };
> >>>>
> >>>> And add the mandatory parameters for SDR inside its own structure, e. g.
> >>>> struct v4l2_sdr_format. Of course, the meta-data provided by a SDR device
> >>>> is different than the one for video or vbi, so you'll need to add a new
> >>>> streaming type for SDR anyway.
> >>>>
> >>>> Btw, that's what I proposed here:
> >>>>
> >>>> http://git.linuxtv.org/mchehab/experimental.git/blob/refs/heads/sdr:/include/uapi/linux/videodev2.h
> >>>>
> >>>> With regards to the sampling rate range, my proposal there were to add a min/max
> >>>> value for it, to be used by VIDIOC_G_FMT, as proposed on:
> >>>> 	http://git.linuxtv.org/mchehab/experimental.git/commitdiff/c3a73f84f038f043aeda5d5bfccc6fea66291451
> >>>>
> >>>> So, the v4l2_sdr_format should be like:
> >>>>
> >>>> +struct v4l2_sdr_format {
> >>>> +       __u32                           sampleformat;
> >>>> +       __u32                           sample_rate;            /* in Hz */
> >>>> +       __u32                           min_sample_rate;        /* in Hz */
> >>>> +       __u32                           max_sample_rate;        /* in Hz */
> >>>> +
> >>>> +} __attribute__ ((packed));
> >>>>
> >>>> Where sampleformat would be something similar to FOURCC, defining the
> >>>> size of each sample, its format, and if the sampling is in quadradure,
> >>>> if they're plain PCM samples, or something more complex, like DPCM, RLE,
> >>>> etc.
> >>>>
> >>>> In the specific case of enumerating the sampling rate range, if the
> >>>> sampling rate can have multiple ranges, then maybe we'll need to do
> >>>> something more complex like what was done on VIDIOC_ENUM_FRAMESIZES.
> >>>
> >>> Could this ioctl be adapted for this:
> >>>
> >>> http://hverkuil.home.xs4all.nl/spec/media.html#vidioc-enum-freq-bands
> >>>
> >>> BTW, can the sample rate change while streaming? Typically things you set
> >>> through S_FMT can not be changed while streaming.
> >>
> >> Yes, but in practice it is uncommon. When I reverse-engineered Mirics
> >> MSi2500 USB ADC I did it hundred of times. Just started streaming and
> >> injected numbers to ADC control registers, then calculated sampling rate
> >> from the stream.
> >
> > That's not an use case. It is just a developer's procedure. Anyway, you
> > could still measure the bit rate like that, if you do a stream start and
> > stop.
> >
> >> That is only use case I know currently, there still could be some others.
> >
> > Seriously? Since the Shannon theorem, all theory used on DSP assumes that
> > the samples are spaced at the very same bit rate.
> >
> >> Nothing prevents do to it, the key issue is that
> >> sampling rate is needed to known by app.
> >
> > No, it is harder than that: if the bit rate changes, then you need to pack
> > the sampling rate changes when they occur inside the stream, as otherwise
> > userspace will have no means to detect such changes.
> 
> Heh, I cannot understood you. Could you explain why it works for me? 
> Here is video I recorded just for you:
> http://palosaari.fi/linux/v4l-dvb/mirics_msi3101_sdrsharp_sampling_rate.mp4
> 
> It is Mirics MSi3101 streaming FM radio with sampling rate 2.048 Msps, 
> then I switch to 1.024 Msps and back few times - on the fly. IMHO 
> results are just as expected. Sound start cracking when DSP application 
> sampling rate does not match, but when you change it back to correct it 
> recovers.

In other words, changing the sampling rate while streaming breaks decoding.

> If I will add button to tell app DSP that sampling rate is changed, it 
> will work for both cases. I haven't yet implemented that settings 
> button, it is hard coded to SDRSharp plugin.
> 
> Could you explain why it works if it is impossible as you said?

I can't imagine any "magic" button that will be able to discover
on what exact sample the sampling rate changed. The hardware may
have buffers; the DMA engines and the USB stack for sure have, and
also V4L. Knowing on what exact sample the sampling rate changed
would require hardware support, to properly tag the sample where the
change started to apply.

If the hardware supports it, I don't see an reason why blocking calling
VIDIOC_S_FMT in the middle of a stream.

However, on all other hardwares, samples will be lost or will be
badly decoded, with would cause audio/video artifacts or even break
the decoding code if not properly written.

Anyway, if samples will be lost anyway, the right thing to do is to
just stop streaming, change the sampling rate and start streaming
again. This way, you'll know that all buffers received before the 
changes will have the old sampling rate, and all new buffers, the new one.

Regards,
Mauro



> 
> 
> > This is the very same problem on video streams: we currently don't allow
> > calling VIDIOC_S_FMT in the middle of some transmission, as there's no
> > way to signalize when the changes are applied.
> >
> > We used to allow it in the past, at least on bttv, as the old code, from
> > V4L1 times used to always allocate memory for the max possible resolution.
> > So, it used to support streaming resizing after start streaming.
> >
> > There were even one V4L1 application doing that, basically due to a
> > programer's mistake:
> >
> > The program used to first start streaming, and then changing the image
> > size, very quickly. I suspect that the original developer never suspected
> > about the application misbehavior, but that became a nightmare when we
> > removed V4L1 support. I ended by fixing the application in the process.
> >
> >> It is app developer choice if
> >> he wants to restart streaming when changes sampling rate.
> >>
> >> ADC sampling frequency has no direct relation to stream format. See for
> >> example those Mirics libv4lconvert patches I send earlier that week.
> >
> > The same applies to all write parameters passed via the pix_format structs:
> > they're orthogonal (e. g. one don't depend on the others).
> >
> > In the specific case of v4l2_pix_format, the parameters filled by userspace
> > are orthogonal: width, height, pixelformat, field.
> >
> > Ok, not all configs are valid, and the device may have some restrictions.
> > So, the driver can round those parameters to the closest possible value,
> > if needed.
> >
> > The bytesperline, sizeimage and colorspace are parameters filled by the
> > driver. The first two parameters are derived from the image size and
> > pixelformat.
> >
> > The colorspace parameter is a driver-dependent fixed value (Actually,
> > a few special drivers allow userspace to fill the colorspace too,
> > like the mem2mem drivers - but this is an exception).
> >
> > Regards,
> > Mauro
> >
> 
> 
> regards
> Antti
> 


-- 

Cheers,
Mauro
