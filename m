Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab3DPIJl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 04:09:41 -0400
Date: Tue, 16 Apr 2013 05:09:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [RFC v2013-04-11] SDR API REQUIREMENT SPECIFICATION
Message-ID: <20130416050928.6cf5a875@redhat.com>
In-Reply-To: <5166CF3A.5040603@iki.fi>
References: <5166CF3A.5040603@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

See my comments below. As I already commented, IMO, we should add SDR
as an extension to V4L2 API. We have enough headaches by having two
different APIs that already overlaps on some places, to add yet another
one.

So, I'll add a few comments below with regards to that.

Em Thu, 11 Apr 2013 17:56:58 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> I added some new parameters as described.
> Comments are welcome - I haven't got almost any up to date.
> 
> I will keep latest version of that document same old address:
> http://palosaari.fi/linux/kernel_sdr_api_requirement_specification.txt
> 
> regards
> Antti
> 
> 
> LINUX KERNEL SDR API REQUIREMENT SPECIFICATION
> =====================================================================
> 
> 
> Ideal SDR specific requirements (basics SDR settings)
> *********************************************************************
> 
> operation mode
> *  values: ADC (Rx) or DAC (Tx)
> *  operations
>       GET, inquire what HW supports
>       GET, get current value
>       SET, set desired value

Instead, IMO the better is to have separate devnodes, one for RX and another
one for TX.

For devices where TX and RX can't be used at the same time, it should return
-EBUSY if the device is already streaming.

My suggestion here is to use V4L2 querycap to distinguish between TX and RX.
	http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-querycap.html

At VIDIOC_QUERYCAP, TX devices devices have capabilities set to:
	for TX devices: V4L2_CAP_MODULATOR
	for RX devices: V4L2_CAP_RADIO.

It makes sense a new capability to identify that the device is SDR:
	V4L2_CAP_SDR

> 
> sampling resolution
> *  values: 1 - 32 (unit: bit)
>       16 bit could be enough, but better to leave some room for future
> *  operations
>       GET, inquire what HW supports
>       GET, get current value
>       SET, set desired value
> 
> sampling rate
> *  values: 1 - infinity (unit: Hz, symbols per second)
>       currently 500 MHz is more than enough
> *  operations
>       GET, inquire what HW supports
>       GET, get current value
>       SET, set desired value
> 
> TODO:
> *  inversion?

At least GET inversion makes sense.

There's no V4L2 ioctl to set it. My suggestion is to create a new
ioctl pair for them
	VIDIOC_S_SDR	- sets SDR specific parameters
	VIDIOC_G_SDR	- gets SDR specific parameters

Those will set/get the SDR specific stuff:
	- sampling rate;
	- ADC/DAC resolution;
	- band inversion;
	-...

On VIDIOC_S_SDR, if one parameter is out of range, instead of failing,
the device should return the closest allowed value.

Btw, all ADC/DAC are linear, or some of them uses A-Law/u-Law? If
they could use non-linear bit stepping, then we may need an extra
field there for it.

> 
> Practical SDR specific requirements (SDR settings for RF tuner)
> *********************************************************************
> 
> RF frequency
> *  values: 1 - infinity (unit: Hz)
>       currently 100 GHz is more than enough
> *  operations
>       GET, inquire what HW supports
>         there could be unsupported ranges between lower and upper freq
>       GET, get current value
>       SET, set desired value

For GET, IMO dealing with the frequency drift from the programmed
frequency is better.

V4L provides this via this ioctl:
	http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-frequency.html

What VIDIOC_G_FREQUENCY returns is the programmed frequency, with can
actually be different than what userspace requested due to the tuner's
scale.

Currently, V4L2 unit is either 62.5 Hz or 62.5 kHz, and it uses 32 bits
for frequency. All radio devices currently uses the 62.5 Hz scale.

With the 62.5 Hz step, the max frequency is about 268 GHz (268,435,455,937.5)
with seems good enough.

As this ioctl has 8 reserved fields, it would be possible to change
frequency to 64 bits and add an extra CAP to VIDIOC_G_TUNER to indicate
a different scale, like Hz.

Not sure if it this is needed through. I would just start with what we
have, adding something else only if needed.

> IF frequency (intermediate frequency)
> *  values: 0 - infinity (unit: Hz)
>       currently 500 MHz is more than enough
> *  operations
>       GET, get current value

While IF could be provided by a V4L2 control, IMO, adding it at
VIDIOC_G_TUNER using one of the reserved fields makes more sense.
At least on r820t, IF depends on the standard and bandwidth.

> 
> tuner lock (frequency synthesizer / PLL)
> *  values: yes/no
> *  operations
>       GET, get current value

I would add it to:
	http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-tuner.html#tuner-rxsubchans

> 
> tuner gains
> *  gain and attenuation
> *  there could be multiple places to adjust gain on tuner signal path
> *  is single overall gain enough or do we want more manual fine tuning?

* enable/disable auto gain

IMO, tuner gain should be provided by a V4L2 control:
	http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-ext-ctrls.html 

> 
> tuner filters
> *  there could be multiple filters on tuner signal path (RF/IF)
> *  do we need to control filters at all?

Probably yes. Several analog chipsets do oversampling, in order to
be able to reduce quantization noise when applying certain filters.
If we allow oversampling, bandwidth lowpass filter becomes independent
of the sampling rate.

IMO, tuner filters should be provided by V4L2 controls:
	http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-ext-ctrls.html

> *  calculate from sampling rate?

Calculating them from sampling rate seems better. I suggest to use it as
a default using Nyquist formula (BW = sampling_freq/2), but to 
allow changing the filters latter if needed.

> 
> 
> TODO:
> *  pass RF standard to tuner?
>     Passing standard is clearly against idea, but some RF tuners does
>     "black magic" according to standard. That magic is usually setting
>     filters and and gains, but it could be more...

I think that this is needed, in order to optimize tuner performance.

On V4L2, standards are actually a 64 bits bitmask:
	http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-enumstd.html#v4l2-standard

And are set/get via:
	http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-std.html

These don't cover digital standards (well, ATSC is actually defined there,
but not used currently).

One option would be to add the DVB standards here (I think we have 33
bits left). However, there's a gcc issue on using more than 32 bits:
switch() doesn't work on 32 bits machines. So, I'm reluctant using it.

IMO, the V4L2 standard ioctls are the messier ones, as it actually
defines 3 separate properties as just one bitmask:

	- Color modulation (PAL, NTSC, SECAM);
	- Monocromatic video standard: STD/K, STD/M, ...
	- Audio modulation: AM, FM, ...

This also won't cover any other non-TV standard. As SDR can be used for
SSB, VSB, etc, we may need to add latter other types of SDR standards.
So, perhaps we'll need an special ioctl for that.

We need to think carefully before start implementing it, as I suspect
we'll see a lot more SDR radio in the future, and a truly universal
optimized SDR tuner may need to know a lot more about the signal
envelope and modulation in order to optimize for that kind of signal.


> *  inversion?
> 
>

Perhaps we may need also some statistics measurements here, like
signal strength, pilot carrier detected, etc.

This is somewhat covered by VIDIOC_G_TUNER, but we may need some
other SDR specifics.
 
> Hardware specific requirements (board settings)
> *********************************************************************
> 
> antenna switch
> *  values: 0 - 32 (unit: piece)
> *  operations
>       GET, inquire what HW supports
>       GET, get current value
>       SET, set desired value

With V4L2, there are a few ioctls to select input:
	http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-enuminput.html#v4l2-input

Currently, the spec says that it shouldn't be used by radio devices, as
none of the current supported devices have actually more than one input,
and this field were abused to select the modulation (AM or FM) on a few drivers.

> 
> external LNA
> *  values: -200000 - 200000 (unit: dB/1000)
> *  operations
>       GET, inquire what HW supports
>       GET, get current value
>       SET, set desired value
> * range from -200dB to 200dB should be enough

IMO, should be provided by a V4L2 control:
	http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-ext-ctrls.html 

> 
> multiple ADCs / DACs on single device
> *  there could be multiple ADCs and DACs on single device
> *  resources could be shared which limits concurrent usage
> *  eg. device has 2 ADC + 2 DAC = 4 total, but only 2 could be used
>     at the time

IMO, if the device allows using more than one at the same time, each
A/D or D/A should have a separate devnode.

> 
> Kernel specific requirements
> *********************************************************************
> 
> device locking between multiple APIs
> *  same device could support multiple APIs which could not be used at
>     same time
> *  for example DVB API and V4L2 API
> *  locking needed
> 
> 
> DOCUMENT VERSION HISTORY
> =====================================================================
> 2012-10-15 Antti Palosaari <crope@iki.fi>
> * Initial version
> 
> 2013-04-11 Antti Palosaari <crope@iki.fi>
> * add version history
> * order requirements per sections
> * add IF frequency (intermediate frequency)
> * add tuner lock (frequency synthesizer / PLL)
> * add external LNA
> * add TODOs
> 


-- 

Cheers,
Mauro
