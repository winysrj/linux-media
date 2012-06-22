Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab2FVQPw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 12:15:52 -0400
Message-ID: <4FE49A32.3060307@redhat.com>
Date: Fri, 22 Jun 2012 13:15:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 4/6] videodev2.h: add frequency band information.
References: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl> <4FE07255.6050606@redhat.com> <4FE08942.8020603@redhat.com> <201206221607.10363.hverkuil@xs4all.nl>
In-Reply-To: <201206221607.10363.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-06-2012 11:07, Hans Verkuil escreveu:
> Sorry for the late reply, but I've been quite busy the last few days...
> 
> On Tue June 19 2012 16:14:26 Mauro Carvalho Chehab wrote:
>> Em 19-06-2012 09:36, Hans de Goede escreveu:
>>> Hi,
>>>
>>> On 06/19/2012 01:09 PM, Mauro Carvalho Chehab wrote:
>>>> Em 19-06-2012 05:27, Hans de Goede escreveu:
>>>>> Hi,
>>>>>
>>>>> On 06/19/2012 02:47 AM, Mauro Carvalho Chehab wrote:
>>>>>> Em 28-05-2012 07:46, Hans Verkuil escreveu:
>>>>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>>>
>>>>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>>> Acked-by: Hans de Goede <hdegoede@redhat.com>
>>>>>>> ---
>>>>>>>      include/linux/videodev2.h |   19 +++++++++++++++++--
>>>>>>>      1 file changed, 17 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>>>>>>> index 2339678..013ee46 100644
>>>>>>> --- a/include/linux/videodev2.h
>>>>>>> +++ b/include/linux/videodev2.h
>>>>>>> @@ -2023,7 +2023,8 @@ struct v4l2_tuner {
>>>>>>>          __u32            audmode;
>>>>>>>          __s32            signal;
>>>>>>>          __s32            afc;
>>>>>>> -    __u32            reserved[4];
>>>>>>> +    __u32            band;
>>>>>>> +    __u32            reserved[3];
>>>>>>>      };
>>>>>>>
>>>>>>>      struct v4l2_modulator {
>>>>>>> @@ -2033,7 +2034,8 @@ struct v4l2_modulator {
>>>>>>>          __u32            rangelow;
>>>>>>>          __u32            rangehigh;
>>>>>>>          __u32            txsubchans;
>>>>>>> -    __u32            reserved[4];
>>>>>>> +    __u32            band;
>>>>>>> +    __u32            reserved[3];
>>>>>>>      };
>>>>>>>
>>>>>>>      /*  Flags for the 'capability' field */
>>>>>>> @@ -2048,6 +2050,11 @@ struct v4l2_modulator {
>>>>>>>      #define V4L2_TUNER_CAP_RDS        0x0080
>>>>>>>      #define V4L2_TUNER_CAP_RDS_BLOCK_IO    0x0100
>>>>>>>      #define V4L2_TUNER_CAP_RDS_CONTROLS    0x0200
>>>>>>> +#define V4L2_TUNER_CAP_BAND_FM_EUROPE_US     0x00010000
>>>>>>> +#define V4L2_TUNER_CAP_BAND_FM_JAPAN         0x00020000
>>>>>>> +#define V4L2_TUNER_CAP_BAND_FM_RUSSIAN       0x00040000
>>>>>>> +#define V4L2_TUNER_CAP_BAND_FM_WEATHER       0x00080000
>>>>>>> +#define V4L2_TUNER_CAP_BAND_AM_MW            0x00100000
>>>>>>
>>>>>> Frequency band is already specified by rangelow/rangehigh.
>>>>>>
>>>>>> Why do you need to duplicate this information?
>>>>>
>>>>> Because radio tuners may support multiple non overlapping
>>>>> bands, this is why this patch also adds a band member
>>>>> to the tuner struct, which can be used to set/get
>>>>> the current band.
>>>>>
>>>>> One example of this are the tea5757 / tea5759
>>>>> radio tuner chips:
>>>>>
>>>>> FM:
>>>>> tea5757 87.5 - 108 MHz
>>>>
>>>>      rangelow = 87.5 * 62500;
>>>>      rangehigh = 108 * 62500;
>>>>
>>>>> tea5759 76 - 91 MHz
>>>>
>>>>      rangelow = 76 * 62500;
>>>>      rangehigh = 91 * 62500;
>>>>
>>>>> AM:
>>>>> Both: 530 - 1710 kHz
>>>>
>>>>      rangelow = 0.530 * 62500;
>>>>      rangehigh = 0.1710 * 62500;
>>>>
>>>>
>>>> See radio-cadet.c:
>>>>
>>>> static int vidioc_g_tuner(struct file *file, void *priv,
>>>>                  struct v4l2_tuner *v)
>>>> {
>>>>      struct cadet *dev = video_drvdata(file);
>>>>
>>>>      v->type = V4L2_TUNER_RADIO;
>>>>      switch (v->index) {
>>>>      case 0:
>>>>          strlcpy(v->name, "FM", sizeof(v->name));
>>>>          v->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS |
>>>>              V4L2_TUNER_CAP_RDS_BLOCK_IO;
>>>>          v->rangelow = 1400;     /* 87.5 MHz */
>>>>          v->rangehigh = 1728;    /* 108.0 MHz */
>>>>          v->rxsubchans = cadet_getstereo(dev);
>>>>          switch (v->rxsubchans) {
>>>>          case V4L2_TUNER_SUB_MONO:
>>>>              v->audmode = V4L2_TUNER_MODE_MONO;
>>>>              break;
>>>>          case V4L2_TUNER_SUB_STEREO:
>>>>              v->audmode = V4L2_TUNER_MODE_STEREO;
>>>>              break;
>>>>          default:
>>>>              break;
>>>>          }
>>>>          v->rxsubchans |= V4L2_TUNER_SUB_RDS;
>>>>          break;
>>>>      case 1:
>>>>          strlcpy(v->name, "AM", sizeof(v->name));
>>>>          v->capability = V4L2_TUNER_CAP_LOW;
>>>>          v->rangelow = 8320;      /* 520 kHz */
>>>>          v->rangehigh = 26400;    /* 1650 kHz */
>>>>          v->rxsubchans = V4L2_TUNER_SUB_MONO;
>>>>          v->audmode = V4L2_TUNER_MODE_MONO;
>>>>          break;
>>>>      default:
>>>>          return -EINVAL;
>>>>      }
>>>>      v->signal = dev->sigstrength; /* We might need to modify scaling of this
>>>>    */
>>>>      return 0;
>>>> }
>>>> static int vidioc_s_tuner(struct file *file, void *priv,
>>>>                  struct v4l2_tuner *v)
>>>> {
>>>>      struct cadet *dev = video_drvdata(file);
>>>>
>>>>      if (v->index != 0 && v->index != 1)
>>>>          return -EINVAL;
>>>>      dev->curtuner = v->index;
>>>>      return 0;
>>>> }
>>>>
>>>> Band switching are made via g_tuner/s_tuner calls. If a device have
>>>> several non-overlapping bands, just implement it there. There's no
>>>> need for a new API.
>>>
>>> <sigh>, this has been discussed extensively between me, Hans V and
>>> Halli Manjunatha on both irc and on the list. What the cadet driver is
>>> doing is an ugly hack, and really a poor match for what we want.
>>>
>>> Not to mention that it is a clear violation of the v4l2 spec:
>>> http://linuxtv.org/downloads/v4l-dvb-apis/tuner.html
>>>
>>> "Radio input devices have exactly one tuner with index zero, no video inputs."
>>>
>>> So there is supposed to be only one tuner, and s_tuner / g_tuner
>>> on radio devices always expect a tuner index of 0.
>>>
>>> Also from the same page:
>>> "Note that VIDIOC_S_TUNER does not switch the current tuner, when there is more than one at all."
>>>
>>> So if we model discontinuous ranges as multiple tuners how do we
>>> select the right tuner? Certainly *not* though s_tuner, as that would
>>> violate the spec. Note that changing the spec here is not really an option,
>>> S_TUNER is expected to change the properties of the tuner selected through
>>> the index, and is *not* expected to change the active tuner , esp. since
>>> changing the active tuner would raise the question, change the active tuner
>>> for which input ? The spec is clear on this:
>>> "The tuner is solely determined by the current video input."
>>
>> Well the specs need to be changed anyway, as there's no "video input" on a radio
>> device.
>>
>> As I said several times, we need to have a "profiles" section at the V4L2 API
>> saying how ioctls should be implemented by each type of device: radio, tv tuners,
>> webcams, media-based cameras, etc. Without that, API compilance is not really
>> possible.
>>
>> A clear example is that the omap3/s5p drivers don't work with an existent V4L2
>> API, as they don't implement video inputs via V4L2 API. The video input selection is
>> via the media API.
>>
>>> iow s_tuner sets tuner parameters (such as the band of a multi-band tuner),
>>> but it does not select a tuner. Making s_tuner actually select 1 of multiple
>>> tuners for radio devices, would cause a large discrepancy between radio and
>>> tv tuners.
>>
>> So what? This is a very small discrepancy if you compare with what we currently have
>> with omap3/s5p, where there's no way for a generic userspace application to work
>> with those devices, and a libv4l generic plugin to properly implement the video input
>> selection is still a dream.
>>
>> It doesn't make any sense to implement video input selection on radio devices, as
>> radio doesn't have video. So, g_input/s_input should not be implemented there at all.
>>
>> I think they're implemented with some bogus code, as otherwise some userspace apps would
>> break - but it doesn't make any sense to select a video input on a device without video!!!
> 
> v4l2-compliance will complain about radio devices implementing any of the input/output
> ioctls. I've removed them from most of those drivers by now.

This should be easy to fix.

>> Ok, hybrid radio/TV devices may have an "input" for FM, that actually selects the "no-video"
>> video input, but this is there only because, in the past, it was allowed to get radio using
>> the /dev/video0 device node. Thankfully, we get rid of this weird behavior on a few kernel
>> versions ago.
>>
>>> For tv tuners we've a 1:1 mapping between tuners and inputs, which makes sense, because
>>> there are actual dual tuner devices, and the purpose of those is to be able to watch /
>>> record 2 "shows" at the same time.
>>
>> No, there isn't an 1:1 mapping. A typical TV tuner has several inputs (TV, S-Video,
>> Composite 1, ...) plus one radio "video" input.
>>
>> They also have several audio inputs (managed via the audio routing ioctl's). On some
>> devices, it is even possible to select a TV channel while listening to the FM radio
>> (devices with tea5767 tuner). Of course, this is weird and never officially supported.
>>
>> Most of the hybrid radio/TV devices actually have a single tuner that can be used
>> at the VHF frequencies. So, they allow getting FM, as it is part of their tuning range.
>>
>> Even so, they're mapped as 2 separate tuners, one for TV and another for radio.
> 
> We *fake* them as two tuners. And that's fairly painful as you have to keep track
> of the last-used frequency for each faked tuner and check what mode the tuner is in.

There was never a 1:1 relation between the number of tuners and how they're exposed on
userspace. See for example the cases of video devices with FM: devices with a separate
radio tuner are exported the same way as devices with a single tuner by tuner-core.

There are a few reasons for that, but the main one is that it doesn't make any practical
sense to use both tuners at the same time, as, on almost all board design, the FM audio
output is wired to the same dual-channel output as the TV one. Besides that, who would
listen to FM radio while seeing/listening TV?

> Now, this is understandable given the clear difference between radio and TV, but
> that doesn't make it a smart choice when you are talking about discrete frequency
> ranges within a single faked tuner (radio/TV).
> 
>>> Modeling this as multiple tuners is just wrong.
>>
>> It is just the way it is since the beginning of V4L2: TV range is mapped as one tuner;
>> FM radio is mapped as another one.
>>
>> The cadet radio is one of the few devices that have FM and AM. It basically followed the
>> same model already adopted by bttv, cx88, saa7134, ... devices with radio support.
> 
> The problem is that it doesn't really work. For each fake tuner you add you need to
> keep track of the last-used frequency at the very least.

Well, the per-frequency range last-used frequency makes sense: if the last frequency at
the AM range is 570 kHz, and the radio is switched to the Japan range, the 570kHz doesn't
make any sense there.

The same is true if the radio changes from the Japan range (76-90 MHz) to the European
Range, as, if the frequency is below 87.5 MHz, it is invalid at the European range.

> And users should also
> be able to detect whether the e.g. signal strength they get back from a tuner is
> valid for the current band or is unavailable because another fake tuner is actually
> selected.

It also makes sense: if the range is switched, the tuning frequency is switched to
the new one, and signal strength should get the signal at the new range, not at the
old one.

>> A change from that model will require changes at the radio implementation on all
>> TV drivers, in order to prevent them to use a separate tuner for radio.
>>
>> The struct v4l2_tuner/v4l2_modulator structs would likely need to be converted into
>> something else or passed as an array, as each tuning band usage (TV, AM, FM, Weather,
>> digital FM, digital AM) can have different properties:
>> 	- range low/high;
>> 	- modulation (AM, FM, ...);
>> 	- sub-carriers (mono, stereo, lang1, lang2);
>> 	- properties (RDS, seek caps, ...).
>>
>>> This is simply not the case with these radio devices,
>>> they can tune both AM and FM but *not* at the same time, so they have a *single*
>>> *multiple-band* tuner.
>>
>> A chip with both AM and FM tuners are, internally, a dual tuner.
> 
> No, it is one tuner with two modes. When in one mode you can't get any information
> from the other mode. A true dual tuner would be able to set each tuner block to it's
> own frequency and get back signal strength information etc. from each of them.

A device with true dual-mode tuners should be mapped as two independent radio nodes.
AFAIKT, g_tuner/s_tuner API were never meant to be used by such devices, as they're
independent nodes.

> AFAIK some car radios can do this: the main tuner is used for audio and RDS, and it
> collects from RDS the alternate frequencies the current station is transmitting on,
> and a second tuner is used to try those frequencies and determine which has the
> strongest signal. That's something you would model as two tuners.

Ok, this is a new use-case. Is there any driver implementing it? If not, let's only
take care of it when the first use case for it arrives.

>> Anyway, on most
>> devices, there's just a single dual-channel audio output. So, even on devices with
>> 2 independent tuners, users can't really use both independently. There are, of course
>> exceptions (ivtv devices can likely record a TV show while listening to radio, as they
>> can use the MPEG encoder for TV).
> 
> If I remember correctly ivtv can't due to other limitations. It can select the audio from
> the radio instead of the audio from the TV, though :-)

cx88 devices with a separate audio tuner could do that, but this is something that is 
not officially supported by the device manufacturer. As it will power more devices that
planned, if the board is not well-designed, it may overheat the device or cause some other
problems there. I don't think we should officially support it. 

> 
>>
>>> Not only have we already discussed
>>> this in a long discussion, I've patches to extend the tea575x driver with AM support,
>>> and the initial revision used the multiple tuner model, but that just does not work
>>> well, and I'm bad Hans V. intervened and pointed out Halli Manjunatha's patchset for
>>> limiting hw-freq seek ranges, after which all of this has been discussed extensively!
>>
>> Sorry but I missed this discussion.
>>
>>>> Also, this is generic enough to cover even devices with non-standard
>>>> frequency ranges.
>>>>
>>>> All bands can easily be detected via a g_tuner loop, and band switching
>>>> is done via s_tuner.
>>>>
>>>> Each band range can have its name ("AM", "FM", "AM-SW", "FM-Japan", ...),
>>>> and this is a way more generic than what's being proposed.
>>>
>>> It is also very very wrong, there is only a single tuner on these devices,
>>> modeling this as multiple tuners is just wrong!
>>>
>>>> It likely makes sense to standardize the band names inside the radio core,
>>>> in order to avoid having the same band called with two different names inside
>>>> the drivers.
>>>>
>>>> It should also be noticed that each band may have different properties.
>>>> On the above, the FM band can do stereo/mono and RDS, while AM is just
>>>> mono So, a change like what's proposed would keep requiring two entries.
>>>
>>> With FM we already have a situation where some channels are mono and other
>>> stereo, with AM/FM the tuner capabilities would reflect what the tuner can
>>> do on some bands-frequency combinations, just like it now reflects what
>>> it can do on some frequencies.
>>
>> Mixing an AM tuner with an FM tuner is really really wrong. Only the PLL
>> stage is identical.
>>
>> The AM demodulator is generally just an envelope detector, while the FM
>> demodulator is a way more complex and completely different from what's
>> done with AM.
>>
>> Digital FM band and digital AM band radio is also completely different from
>> analog AM/analog FM. The only thing in comon with "standard" AM/FM is the
>> band.
>>
>> The fact that all 5 types of tuner (TV, analog AM, analog FM, digital AM band,
>> digital FM band) are implemented by just one PLL or not is irrelevant. Each
>> one is a different tuner, as the tuning demodulation is different.
> 
> The struct v4l2_tuner basically abstracts a PLL: it has an associated frequency,
> signal strength and audio mode detection. So it is IMHO a crucially important
> fact that these bands are all implemented by one PLL: it means that it has to
> be represented by one tuner struct.

No. It abstracts the PLL plus the demod. Audio mode detection is part of the demod
block. For example, on analog FM, stereo is indicated only if the 19 kHz pilot
is present and it is above a certain threshold. RDS will require a 57kHz sub-carrier.

If/when digital radio is implemented, in order to get the audio mode, decoding
the sub-carriers will also be needed.

So, what I'm saying is that, despite its name, v4l2_tuner struct is not a per-tuner
data. It is something else. It sets/gets the tuner+demod data.

> The radio-cadet driver fakes with with two structs, and I've worked with that
> for a bit and it is just a poor mapping. Using one struct makes it all fall
> neatly into place.

No. Using just one struct is WRONG: The tuner range for AM is completely different
from the one for FM; there's no support for stereo on AM; tuning name is different
(one is "AM"; the other one is "FM"), etc.

> Frankly, we never got the radio/tv fake tuner mapping working well. I actually
> think that faking it like it is today is a bad idea as well. Instead it should
> be seen as a single resource, and if it is in use by the TV, then any attempt
> to access it from the radio side should return -EBUSY and vice versa.

Returning -EBUSY when TV is streaming and radio tries to use a shared resource
makes sense, but a shared resource is not just a tuner (or a PLL).

> Anyway, that's a discussion for a later time.
> 
>> What I'm saying is that just adding a "band" field inside a single tuner
>> struct is plain wrong, as each type has different properties.
> 
> See my proposal below.
> 
>>
>>>
>>> <snip>
>>>
>>>>> 87.5 - 108 MHz is very close to 88 - 108 MHz, I don't think it is worth
>>>>> creating 2 band defines for this.
>>>>
>>>> Yes, it is very close, but Countries that added the extra 500 kHz bandwidth
>>>> added stations there. On those, older devices can't tune into the new channels.
>>>
>>> On those older devices rangelow would get reported as 88 rather then 87.5, the
>>> band selection mechanism is there to select a certain range approximately,
>>> the exact resulting range will be hw specific and reported in rangelow /'
>>> rangehigh, as the patch documenting the new fields clearly documents.
>>
>> Why to implement a "band" field that:
>> 	1) can provide a wrong information (87.5 instead of 88);
>> 	2) duplicates an existing information implemented at rangelow/rangehigh
>> ?
> 
> I agree here. Using fixed bands is too limiting.
> 
>>
>>>
>>> <snip>
>>>
>>>>> This would be covered by the V4L2_TUNER_BAND_FM_UNIVERSAL, however,
>>>>> on some devices V4L2_TUNER_BAND_FM_UNIVERSAL may include the weather band,
>>>>> thus going all the way from 76 - 163 Mhz, so I guess we should add a
>>>>> V4L2_TUNER_BAND_FM_JAPAN_WIDE for this. Note that the si470x already
>>>>> supports this, and indeed calls it "Japan wide band"
>>>>
>>>> That's why giving them name via defines is a bad thing: the concept of
>>>> "universal" changes from time to time: 15 years ago, an "universal" radio
>>>> is a device that were able to tune at AM-SW, AM-MW, AM-HW and FM (88-108MHz).
>>>>
>>>> An "universal FM" radio used to be 76-108 MHz, but, with the weather band,
>>>> it is now 76-163 Mhz.
>>>>
>>>> If a band like that is described as "FM" with a frequency range from 76
>>>> to 163 MHz, this is clearer than calling it as "FM unversal".
>>>
>>> We will still have rangelow and rangehigh to report the actual implemented
>>> band. So there is no problem here. An app can select universal and then
>>> figure out what universal is on the specific device it is using with a
>>> G_TUNER.
>>
>> If rangelow/rangehigh is the actual band, why does it need something else?
>>
>> Reusing G_TUNER/S_TUNER or not, the issue is that a bitfield parameter for
>> frequency range is not actually able to express what are the supported
>> ranges. As I said before, the tuner ranges can only be properly expressed
>> by an array with:
>> 	- range low/high;
>> 	- modulation (AM, FM, ...);
>> 	- sub-carriers (mono, stereo, lang1, lang2);
>> 	- properties (RDS, seek caps, ...).
> 
> Agreed.
> 
> So, in my opinion we still need the band field, but instead of this being a
> fixed band it is an index.
> 
> In order to enumerate over all bands I propose a new ioctl:
> 
> VIDIOC_ENUM_TUNER_BAND
> 
> with struct:
> 
> struct v4l2_tuner_band {
> 	__u32 tuner;
> 	__u32 index;
> 	char name[32];
> 	__u32 capability;	/* The same as in v4l2_tuner */
> 	__u32 rangelow;
> 	__u32 rangehigh;
> 	__u32 reserved[7];
> };
> 
> It enumerates the supported bands by the tuner, each with a human readable name,
> frequency range and capabilities.
> 
> If you change the band using S_TUNER, then G_TUNER will return the frequency range
> and capabilities from the corresponding v4l2_tuner_band struct.
> 
> The only capability that needs to be added is one that tells the application that
> the tuner has the capability to do band enumeration (V4L2_TUNER_CAP_HAS_BANDS or
> something).
> 
> I am not 100% certain about the name field: it is very nice for apps, but we do
> need some guidelines here.
> 
> A similar struct would be needed for modulators if we ever need to add support for
> modulators with multiple bands.
> 
> We could perhaps rename v4l2_tuner_band to just v4l2_band to make it tuner/modulator
> agnostic.

The above proposal would be great if we were starting to write the radio API today, but
your proposal is not backward compatible with the status quo.

Regards,
Mauro
