Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47311 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab3DPSSM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 14:18:12 -0400
Message-ID: <516D95B1.1030009@iki.fi>
Date: Tue, 16 Apr 2013 21:17:21 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: [RFC v2013-04-11] SDR API REQUIREMENT SPECIFICATION
References: <5166CF3A.5040603@iki.fi> <20130416050928.6cf5a875@redhat.com> <516D61FE.9060601@iki.fi> <516D89B3.5090103@redhat.com>
In-Reply-To: <516D89B3.5090103@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/16/2013 08:26 PM, Mauro Carvalho Chehab wrote:
> Em 16-04-2013 11:36, Antti Palosaari escreveu:
>> On 04/16/2013 11:09 AM, Mauro Carvalho Chehab wrote:
>>> Hi Antti,
>>>
>>> See my comments below. As I already commented, IMO, we should add SDR
>>> as an extension to V4L2 API. We have enough headaches by having two
>>> different APIs that already overlaps on some places, to add yet another
>>> one.
>>>
>>> So, I'll add a few comments below with regards to that.
>>
>> I tried to study and list all requirements, without a even knowing
>> very well what is
>> possible using V4L2 API, as you has gone now totally to the
>> implementation side.
>>  Surely most those implementations you mentioned are best to implement
>> as you said.
>
> I tried to both comment the requirements and discuss about implementation.
>
>> Could you study and list requirements from the issues you mentioned?
>
> IMO, in order to study, we need to implement it first and start testing.
> Maybe keeping the experimental driver for one or two kernel cycles on a
> separate topic branch, before merging upstream.
>
> Anyway, the better is to get feedback from Amateur Radio people, as they
> have a way more experience with that than us outside the TV band.
> The better would be to get input from the ones that are authorized to
> operate at the full HAM radio range, as they have experienced the
> usage of the several types of modulation and operate at the long distance
> ranges.
>
> I know a few ones. I'll try to contact them, in order to get their
> feedback.

Here is the one =) I have had license maybe ~15 years, first ~5 years 
technician class and after CW was removed from requirements license 
upgrades to unlimited. By a change I just returned to home from our uni. 
HAM club!
I have to say I am not very experienced working with radio bands as I 
rarely do it nowadays. It is more radio technology which inspires, like 
modding old Nokia/Mobira mobile phones to HAM band.


>>> Em Thu, 11 Apr 2013 17:56:58 +0300
>>> Antti Palosaari <crope@iki.fi> escreveu:
>>>
>>>> I added some new parameters as described.
>>>> Comments are welcome - I haven't got almost any up to date.
>>>>
>>>> I will keep latest version of that document same old address:
>>>> http://palosaari.fi/linux/kernel_sdr_api_requirement_specification.txt
>>>>
>>>> regards
>>>> Antti
>>>>
>>>>
>>>> LINUX KERNEL SDR API REQUIREMENT SPECIFICATION
>>>> =====================================================================
>>>>
>>>>
>>>> Ideal SDR specific requirements (basics SDR settings)
>>>> *********************************************************************
>>>>
>>>> operation mode
>>>> *  values: ADC (Rx) or DAC (Tx)
>>>> *  operations
>>>>        GET, inquire what HW supports
>>>>        GET, get current value
>>>>        SET, set desired value
>>>
>>> Instead, IMO the better is to have separate devnodes, one for RX and
>>> another
>>> one for TX.
>>>
>>> For devices where TX and RX can't be used at the same time, it should
>>> return
>>> -EBUSY if the device is already streaming.
>>>
>>> My suggestion here is to use V4L2 querycap to distinguish between TX
>>> and RX.
>>>     http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-querycap.html
>>>
>>> At VIDIOC_QUERYCAP, TX devices devices have capabilities set to:
>>>     for TX devices: V4L2_CAP_MODULATOR
>>>     for RX devices: V4L2_CAP_RADIO.
>>>
>>> It makes sense a new capability to identify that the device is SDR:
>>>     V4L2_CAP_SDR
>>>
>>>>
>>>> sampling resolution
>>>> *  values: 1 - 32 (unit: bit)
>>>>        16 bit could be enough, but better to leave some room for future
>>>> *  operations
>>>>        GET, inquire what HW supports
>>>>        GET, get current value
>>>>        SET, set desired value
>>>>
>>>> sampling rate
>>>> *  values: 1 - infinity (unit: Hz, symbols per second)
>>>>        currently 500 MHz is more than enough
>>>> *  operations
>>>>        GET, inquire what HW supports
>>>>        GET, get current value
>>>>        SET, set desired value
>>>>
>>>> TODO:
>>>> *  inversion?
>>>
>>> At least GET inversion makes sense.
>>
>> I am not sure about that, study please?
>
> Well, userspace may be able to detect bandwidth inversion, for some
> types of modulation, but I'm not sure if it is always possible to
> detect it. As it doesn't hurt to inform userspace, IMHO, the better
> is to just report it there, in order to simplify userspace processing.
>
>>>
>>> There's no V4L2 ioctl to set it. My suggestion is to create a new
>>> ioctl pair for them
>>>     VIDIOC_S_SDR    - sets SDR specific parameters
>>>     VIDIOC_G_SDR    - gets SDR specific parameters
>>>
>>> Those will set/get the SDR specific stuff:
>>>     - sampling rate;
>>>     - ADC/DAC resolution;
>>>     - band inversion;
>>>     -...
>>>
>>> On VIDIOC_S_SDR, if one parameter is out of range, instead of failing,
>>> the device should return the closest allowed value.
>>>
>>> Btw, all ADC/DAC are linear, or some of them uses A-Law/u-Law? If
>>> they could use non-linear bit stepping, then we may need an extra
>>> field there for it.
>>
>> I am not sure about that too, but I have feeling that could be
>> correct. Needs confirming (not algorithm, but use in SDR ADC/DAC).
>>
>>
>>>> Practical SDR specific requirements (SDR settings for RF tuner)
>>>> *********************************************************************
>>>>
>>>> RF frequency
>>>> *  values: 1 - infinity (unit: Hz)
>>>>        currently 100 GHz is more than enough
>>>> *  operations
>>>>        GET, inquire what HW supports
>>>>          there could be unsupported ranges between lower and upper freq
>>>>        GET, get current value
>>>>        SET, set desired value
>>>
>>> For GET, IMO dealing with the frequency drift from the programmed
>>> frequency is better.
>>
>> It is implementation decision, but let me still ask why it is better?
>
> The GET value is the SET value, if everything is OK (except, of course,
> for tuner step rounding).
>
> If there are some difference, this difference tells what's happening.
>
>> Smaller numbers transferred? Is there is some very common user
>> scenario application likes to see drift rather than actual frequency?
>
> If there is a drift, there are two cases:
>      - the station is transmitting on a a different frequency.
>        in this case, the drift is constant.
>      - the drift happens due to doppler effect.

And the hell this is totally different issue. These are application 
layer problems, in SDR we are interested of only controlling radio layer.

That "drift" is usually detected by demodulator from the carrier (it is 
called carrier frequency offset). Do not mix demod / app layer here.


> In the latter case, the drift could be due to multipath reflection
> (doppler shift). Properly adjusting the antenna may reduce its
> variation, by trying to get a stronger direct path signal.
>
> The point is that the absolute frequency number is not relevant itself
> (it is just the one it was programmed), but the drift means something.
>
>> Returning drift extends possible numbers to negative too. Also app
>> needs to do some trivial calculation in order to get real value.
>
> Yes.
>
>> Basically HAM radio style application will read that value very often
>> when it updates freq seen in UI.
>>
>> Also, returning it as a drift means app needs to know what is
>> frequency set, which it surely usually knows, but not always (makes
>> dependency to value set & permission to set value first).
>>  How about remote radio you has no permission to tune?
>
> Discussing it at pure teorethical basis is useless. That's why I put
> V4L2 API under the discussion table.
>
> With V4L2, application can always read the programmed frequency and the
> frequency drift.

I quite disagree you here! I don't see idea at all to return drift. It 
is stupid. Just return frequency where tuner is standing and let the app 
do what it likes. There is already remote radios on the net.


>>> V4L provides this via this ioctl:
>>>     http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-frequency.html
>>>
>>> What VIDIOC_G_FREQUENCY returns is the programmed frequency, with can
>>> actually be different than what userspace requested due to the tuner's
>>> scale.
>>>
>>> Currently, V4L2 unit is either 62.5 Hz or 62.5 kHz, and it uses 32 bits
>>> for frequency. All radio devices currently uses the 62.5 Hz scale.
>>>
>>> With the 62.5 Hz step, the max frequency is about 268 GHz
>>> (268,435,455,937.5)
>>> with seems good enough.
>>>
>>> As this ioctl has 8 reserved fields, it would be possible to change
>>> frequency to 64 bits and add an extra CAP to VIDIOC_G_TUNER to indicate
>>> a different scale, like Hz.
>>>
>>> Not sure if it this is needed through. I would just start with what we
>>> have, adding something else only if needed.
>>
>> 268GHz is enough and 1Hz step is not needed that high frequencies.
>> 62.5 Hz is not practical for smaller frequencies, lets say when you go
>> to the ~500 kHz or under.
>> Dunno what are target radio channel practical requirements for
>> transmitting data very low frequencies but 63 Hz off-by from target
>> channel sounds too much.
>
> My proposal is to add a V4L2_TUNER_CAP_ULTRA_LOW using lower step for
> ELF, VLF and LF frequencies. On very low frequencies, even a 1Hz step
> could be too big. Further study to define the better step is required.
>
> Devices that support those ranges should map it as a separate range using
> the V4L2_TUNER_CAP_ULTRA_LOW flag only on those ranges.
>
> Anyway, we should add it only when we start seeing devices and usages
> for such frequency ranges.
>
>>
>>>> IF frequency (intermediate frequency)
>>>> *  values: 0 - infinity (unit: Hz)
>>>>        currently 500 MHz is more than enough
>>>> *  operations
>>>>        GET, get current value
>>>
>>> While IF could be provided by a V4L2 control, IMO, adding it at
>>> VIDIOC_G_TUNER using one of the reserved fields makes more sense.
>>> At least on r820t, IF depends on the standard and bandwidth.
>>>
>>>>
>>>> tuner lock (frequency synthesizer / PLL)
>>>> *  values: yes/no
>>>> *  operations
>>>>        GET, get current value
>>>
>>> I would add it to:
>>>
>>> http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-tuner.html#tuner-rxsubchans
>>>
>>>
>>>>
>>>> tuner gains
>>>> *  gain and attenuation
>>>> *  there could be multiple places to adjust gain on tuner signal path
>>>> *  is single overall gain enough or do we want more manual fine tuning?
>>>
>>> * enable/disable auto gain
>>>
>>> IMO, tuner gain should be provided by a V4L2 control:
>>>     http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-ext-ctrls.html
>>>
>>>>
>>>> tuner filters
>>>> *  there could be multiple filters on tuner signal path (RF/IF)
>>>> *  do we need to control filters at all?
>>>
>>> Probably yes. Several analog chipsets do oversampling, in order to
>>> be able to reduce quantization noise when applying certain filters.
>>> If we allow oversampling, bandwidth lowpass filter becomes independent
>>> of the sampling rate.
>>>
>>> IMO, tuner filters should be provided by V4L2 controls:
>>>     http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-ext-ctrls.html
>>>
>>>> *  calculate from sampling rate?
>>>
>>> Calculating them from sampling rate seems better. I suggest to use it as
>>> a default using Nyquist formula (BW = sampling_freq/2), but to
>>> allow changing the filters latter if needed.
>>
>> Could you study requirements here? Some examples from existing radios
>> could be nice.
>
> See the cx2388x datasheet for an oversampling example. Those chips have
> 2 10
> bits A/D that are generally used at the same time: one for composite video
> and another one for chrominance.
>
> There, it oversamples the crominance sub-carrier (4 times the frequency),
> in order to produce ~ 1135 pixels per line on PAL. It then downsamples
> it to 768 pixels per line.
>
> Most analog video A/D do the same trick, in order to reduce the
> quantization
> noise and reduce image artifacts.
>
> Btw, it could be possible to use the cx88 driver for SDR too. It is a
> matter
> of programming its RISC code to send the raw A/D samples to userspace.
> The RISC is docummented at the datasheet, and it is code is dynamically
> generated by the cx88 driver in runtime. Not sure what's the maximum
> bandwidth supported by cx88 DMA engine through, but it could be higher
> than the one provided by an USB driver.
>
> Currently, the audio decoding there is done by a Kernel code that takes
> the samples, and applies some digital filters to identify the type of
> audio modulation (see drivers/media/pci/cx88/cx88-dsp.c).

I don't understand that. Why that oversampling should be exposed to the 
userpsace? What I think it is just devices issue to sample what the best 
result is. If it does oversampling (like takes 2 samples for one 
returned) why it should be in API? Why we should care what kind of 
sampling techniques there is used by hw - it is enough that we know 
actual sample rate that go out from the device.

Look for example those new digital cameras. They has very large sensor, 
then DSP is responsible of oversampling and user gets low sampled photo 
back. User does not need to know if the result enhanced by oversampling 
or some other technique.


>
>>
>>
>>>> TODO:
>>>> *  pass RF standard to tuner?
>>>>      Passing standard is clearly against idea, but some RF tuners does
>>>>      "black magic" according to standard. That magic is usually setting
>>>>      filters and and gains, but it could be more...
>>>
>>> I think that this is needed, in order to optimize tuner performance.
>>
>> At the fist I would like to drop it if possible ever and try to use
>> driver
>> specific logic to determine suitable values from target RF, filters
>> and gains.
>> Maybe better to add it only if there appears some case what we could
>> not resolve without.
>
> That doesn't seem to be possible. While most tuners use the central
> frequency as
> the reference, there are others that use the initial frequency. For
> example, xc3028,
> xc4000, xc5000 and r820t uses the initial frequency as its tuning frequency
> (I think that there are more cases like that at the tree). So, in order
> to get
> the IF, you need to know the standard on those tuners, in order to
> calculate
> the frequency offset between the initial frequency and the "center"
> frequency[1].

It is up to tuner select most suitable IF. From the SDR point of view it 
does not has such much meaning. Tuner selects suitable IF because of 
demodulator needs / used band / bw.

> Also, there are other factors that may help silicon tuners to optimize for
> certain types of standard. It seems really hard to parametrize those.
>
> So, the better seems to simply pass the type of the RF standard, for the
> tuner
> to adjust for it.
>
> [1] Btw, on ISDB-T, the "center" frequency has an extra offset of about
> 493kHz, when compared with DVB-T or ATSC.
>
> So, only knowing the RF standard, it is possible to program it right.

So what? Maybe tuner could be programmed a little bit "wrong" frequency 
in case of ISDB-T, but again, it is not SDR hw problem. That kind of 
issues belongs to the upper layers, not for radio control.


>>> On V4L2, standards are actually a 64 bits bitmask:
>>>
>>> http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-enumstd.html#v4l2-standard
>>>
>>>
>>> And are set/get via:
>>>     http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-std.html
>>>
>>> These don't cover digital standards (well, ATSC is actually defined
>>> there,
>>> but not used currently).
>>>
>>> One option would be to add the DVB standards here (I think we have 33
>>> bits left). However, there's a gcc issue on using more than 32 bits:
>>> switch() doesn't work on 32 bits machines. So, I'm reluctant using it.
>>>
>>> IMO, the V4L2 standard ioctls are the messier ones, as it actually
>>> defines 3 separate properties as just one bitmask:
>>>
>>>     - Color modulation (PAL, NTSC, SECAM);
>>>     - Monocromatic video standard: STD/K, STD/M, ...
>>>     - Audio modulation: AM, FM, ...
>>>
>>> This also won't cover any other non-TV standard. As SDR can be used for
>>> SSB, VSB, etc, we may need to add latter other types of SDR standards.
>>> So, perhaps we'll need an special ioctl for that.
>>
>> There is, but those are demodulated by SDR SW. I don't see reason
>> SDR HW should be aware of used modulation.
>
> Because of the location of the max freq, pilot carrier, min freq and
> other properties of the baseband envelope, that require adjusting the
> IF, PLL, filters, etc.
>
>>> We need to think carefully before start implementing it, as I suspect
>>> we'll see a lot more SDR radio in the future, and a truly universal
>>> optimized SDR tuner may need to know a lot more about the signal
>>> envelope and modulation in order to optimize for that kind of signal.
>>>
>>>
>>>> *  inversion?
>>>>
>>>>
>>>
>>> Perhaps we may need also some statistics measurements here, like
>>> signal strength, pilot carrier detected, etc.
>>
>> Could you study how tuner measures signal?
>>
>> I suspect these are things *not* to belong SDR radio HW at all - but the
>> demodulator (SW layer). Could you point any SDR HW which detects pilot
>> carrier? Isn't that demodulator...
>
> Well, the PLL should lock at the pilot carrier frequency, otherwise the
> signal won't be stable enough to decode.
>
>>
>>
>>> This is somewhat covered by VIDIOC_G_TUNER, but we may need some
>>> other SDR specifics.
>>>
>>>> Hardware specific requirements (board settings)
>>>> *********************************************************************
>>>>
>>>> antenna switch
>>>> *  values: 0 - 32 (unit: piece)
>>>> *  operations
>>>>        GET, inquire what HW supports
>>>>        GET, get current value
>>>>        SET, set desired value
>>>
>>> With V4L2, there are a few ioctls to select input:
>>>
>>> http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-enuminput.html#v4l2-input
>>>
>>>
>>> Currently, the spec says that it shouldn't be used by radio devices, as
>>> none of the current supported devices have actually more than one input,
>>> and this field were abused to select the modulation (AM or FM) on a
>>> few drivers.
>>>
>>>>
>>>> external LNA
>>>> *  values: -200000 - 200000 (unit: dB/1000)
>>>> *  operations
>>>>        GET, inquire what HW supports
>>>>        GET, get current value
>>>>        SET, set desired value
>>>> * range from -200dB to 200dB should be enough
>>>
>>> IMO, should be provided by a V4L2 control:
>>>     http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-ext-ctrls.html
>>>
>>>>
>>>> multiple ADCs / DACs on single device
>>>> *  there could be multiple ADCs and DACs on single device
>>>> *  resources could be shared which limits concurrent usage
>>>> *  eg. device has 2 ADC + 2 DAC = 4 total, but only 2 could be used
>>>>      at the time
>>>
>>> IMO, if the device allows using more than one at the same time, each
>>> A/D or D/A should have a separate devnode.
>>
>> Yeah, but that issue was asking how to deal with limited resources.
>
> The first one to request gets the resources, the other one(s) get -EBUSY.
>
>>>
>>>>
>>>> Kernel specific requirements
>>>> *********************************************************************
>>>>
>>>> device locking between multiple APIs
>>>> *  same device could support multiple APIs which could not be used at
>>>>      same time
>>>> *  for example DVB API and V4L2 API
>>>> *  locking needed
>>>>
>>>>
>>>> DOCUMENT VERSION HISTORY
>>>> =====================================================================
>>>> 2012-10-15 Antti Palosaari <crope@iki.fi>
>>>> * Initial version
>>>>
>>>> 2013-04-11 Antti Palosaari <crope@iki.fi>
>>>> * add version history
>>>> * order requirements per sections
>>>> * add IF frequency (intermediate frequency)
>>>> * add tuner lock (frequency synthesizer / PLL)
>>>> * add external LNA
>>>> * add TODOs
>>>>
>>>
>>>
>> regards
>> Antti
>>
>
> Best regards,
> Mauro


-- 
http://palosaari.fi/
