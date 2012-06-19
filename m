Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab2FSPlc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jun 2012 11:41:32 -0400
Message-ID: <4FE09DA6.6050901@redhat.com>
Date: Tue, 19 Jun 2012 12:41:26 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: halli manjunatha <hallimanju@gmail.com>
CC: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 4/6] videodev2.h: add frequency band information.
References: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl> <005651489cd5c9f832df2d5d90e19e2eee07c9b9.1338201853.git.hans.verkuil@cisco.com> <4FDFCC0F.9000208@redhat.com> <4FE037FE.7030804@redhat.com> <4FE05DF4.7030905@redhat.com> <4FE07255.6050606@redhat.com> <CAMT6Pyfh67370=VO_hrX=s-pBOJyy=KZDP-UYnPSi6f6eOyByQ@mail.gmail.com>
In-Reply-To: <CAMT6Pyfh67370=VO_hrX=s-pBOJyy=KZDP-UYnPSi6f6eOyByQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-06-2012 10:31, halli manjunatha escreveu:
> Hi Mauro,
> 
> Please take the Patch-set 7 which I submitted by removing my set_band
> implementation (as per Hans V suggestion).
> 
> https://lkml.org/lkml/2012/5/21/294

Manju,

That doesn't solve the issue.

As I pointed on my previous email, the ranges aren't consistent among the
radio devices. The best, IMHO, would be to use several g/s_tuner ranges,
one for each supported one.

An alternative would be to write a set of ioctls specific for radio that
would do the same that g/s_tuner does at radio-cadet, but, IMHO, this is
is overdesign.

In any case, we should not apply a patch for it without having a consensus
about the right way.

Regards,
Mauro

> 
> Regards
> Manju
> 
> On Tue, Jun 19, 2012 at 7:36 AM, Hans de Goede <hdegoede@redhat.com> wrote:
>> Hi,
>>
>>
>> On 06/19/2012 01:09 PM, Mauro Carvalho Chehab wrote:
>>>
>>> Em 19-06-2012 05:27, Hans de Goede escreveu:
>>>>
>>>> Hi,
>>>>
>>>> On 06/19/2012 02:47 AM, Mauro Carvalho Chehab wrote:
>>>>>
>>>>> Em 28-05-2012 07:46, Hans Verkuil escreveu:
>>>>>>
>>>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>>
>>>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>> Acked-by: Hans de Goede <hdegoede@redhat.com>
>>>>>> ---
>>>>>>     include/linux/videodev2.h |   19 +++++++++++++++++--
>>>>>>     1 file changed, 17 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>>>>>> index 2339678..013ee46 100644
>>>>>> --- a/include/linux/videodev2.h
>>>>>> +++ b/include/linux/videodev2.h
>>>>>> @@ -2023,7 +2023,8 @@ struct v4l2_tuner {
>>>>>>         __u32            audmode;
>>>>>>         __s32            signal;
>>>>>>         __s32            afc;
>>>>>> -    __u32            reserved[4];
>>>>>> +    __u32            band;
>>>>>> +    __u32            reserved[3];
>>>>>>     };
>>>>>>
>>>>>>     struct v4l2_modulator {
>>>>>> @@ -2033,7 +2034,8 @@ struct v4l2_modulator {
>>>>>>         __u32            rangelow;
>>>>>>         __u32            rangehigh;
>>>>>>         __u32            txsubchans;
>>>>>> -    __u32            reserved[4];
>>>>>> +    __u32            band;
>>>>>> +    __u32            reserved[3];
>>>>>>     };
>>>>>>
>>>>>>     /*  Flags for the 'capability' field */
>>>>>> @@ -2048,6 +2050,11 @@ struct v4l2_modulator {
>>>>>>     #define V4L2_TUNER_CAP_RDS        0x0080
>>>>>>     #define V4L2_TUNER_CAP_RDS_BLOCK_IO    0x0100
>>>>>>     #define V4L2_TUNER_CAP_RDS_CONTROLS    0x0200
>>>>>> +#define V4L2_TUNER_CAP_BAND_FM_EUROPE_US     0x00010000
>>>>>> +#define V4L2_TUNER_CAP_BAND_FM_JAPAN         0x00020000
>>>>>> +#define V4L2_TUNER_CAP_BAND_FM_RUSSIAN       0x00040000
>>>>>> +#define V4L2_TUNER_CAP_BAND_FM_WEATHER       0x00080000
>>>>>> +#define V4L2_TUNER_CAP_BAND_AM_MW            0x00100000
>>>>>
>>>>>
>>>>> Frequency band is already specified by rangelow/rangehigh.
>>>>>
>>>>> Why do you need to duplicate this information?
>>>>
>>>>
>>>> Because radio tuners may support multiple non overlapping
>>>> bands, this is why this patch also adds a band member
>>>> to the tuner struct, which can be used to set/get
>>>> the current band.
>>>>
>>>> One example of this are the tea5757 / tea5759
>>>> radio tuner chips:
>>>>
>>>> FM:
>>>> tea5757 87.5 - 108 MHz
>>>
>>>
>>>         rangelow = 87.5 * 62500;
>>>         rangehigh = 108 * 62500;
>>>
>>>> tea5759 76 - 91 MHz
>>>
>>>
>>>         rangelow = 76 * 62500;
>>>         rangehigh = 91 * 62500;
>>>
>>>> AM:
>>>> Both: 530 - 1710 kHz
>>>
>>>
>>>         rangelow = 0.530 * 62500;
>>>         rangehigh = 0.1710 * 62500;
>>>
>>>
>>> See radio-cadet.c:
>>>
>>> static int vidioc_g_tuner(struct file *file, void *priv,
>>>                                 struct v4l2_tuner *v)
>>> {
>>>         struct cadet *dev = video_drvdata(file);
>>>
>>>         v->type = V4L2_TUNER_RADIO;
>>>         switch (v->index) {
>>>         case 0:
>>>                 strlcpy(v->name, "FM", sizeof(v->name));
>>>                 v->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS
>>> |
>>>                         V4L2_TUNER_CAP_RDS_BLOCK_IO;
>>>                 v->rangelow = 1400;     /* 87.5 MHz */
>>>                 v->rangehigh = 1728;    /* 108.0 MHz */
>>>                 v->rxsubchans = cadet_getstereo(dev);
>>>                 switch (v->rxsubchans) {
>>>                 case V4L2_TUNER_SUB_MONO:
>>>                         v->audmode = V4L2_TUNER_MODE_MONO;
>>>                         break;
>>>                 case V4L2_TUNER_SUB_STEREO:
>>>                         v->audmode = V4L2_TUNER_MODE_STEREO;
>>>                         break;
>>>                 default:
>>>                         break;
>>>                 }
>>>                 v->rxsubchans |= V4L2_TUNER_SUB_RDS;
>>>                 break;
>>>         case 1:
>>>                 strlcpy(v->name, "AM", sizeof(v->name));
>>>                 v->capability = V4L2_TUNER_CAP_LOW;
>>>                 v->rangelow = 8320;      /* 520 kHz */
>>>                 v->rangehigh = 26400;    /* 1650 kHz */
>>>                 v->rxsubchans = V4L2_TUNER_SUB_MONO;
>>>                 v->audmode = V4L2_TUNER_MODE_MONO;
>>>                 break;
>>>         default:
>>>                 return -EINVAL;
>>>         }
>>>         v->signal = dev->sigstrength; /* We might need to modify scaling of
>>> this
>>>   */
>>>         return 0;
>>> }
>>> static int vidioc_s_tuner(struct file *file, void *priv,
>>>                                 struct v4l2_tuner *v)
>>> {
>>>         struct cadet *dev = video_drvdata(file);
>>>
>>>         if (v->index != 0 && v->index != 1)
>>>                 return -EINVAL;
>>>         dev->curtuner = v->index;
>>>         return 0;
>>> }
>>>
>>> Band switching are made via g_tuner/s_tuner calls. If a device have
>>> several non-overlapping bands, just implement it there. There's no
>>> need for a new API.
>>
>>
>> <sigh>, this has been discussed extensively between me, Hans V and
>> Halli Manjunatha on both irc and on the list. What the cadet driver is
>> doing is an ugly hack, and really a poor match for what we want.
>>
>> Not to mention that it is a clear violation of the v4l2 spec:
>> http://linuxtv.org/downloads/v4l-dvb-apis/tuner.html
>>
>> "Radio input devices have exactly one tuner with index zero, no video
>> inputs."
>>
>> So there is supposed to be only one tuner, and s_tuner / g_tuner
>> on radio devices always expect a tuner index of 0.
>>
>> Also from the same page:
>> "Note that VIDIOC_S_TUNER does not switch the current tuner, when there is
>> more than one at all."
>>
>> So if we model discontinuous ranges as multiple tuners how do we
>> select the right tuner? Certainly *not* though s_tuner, as that would
>> violate the spec. Note that changing the spec here is not really an option,
>> S_TUNER is expected to change the properties of the tuner selected through
>> the index, and is *not* expected to change the active tuner , esp. since
>> changing the active tuner would raise the question, change the active tuner
>> for which input ? The spec is clear on this:
>> "The tuner is solely determined by the current video input."
>>
>> iow s_tuner sets tuner parameters (such as the band of a multi-band tuner),
>> but it does not select a tuner. Making s_tuner actually select 1 of multiple
>> tuners for radio devices, would cause a large discrepancy between radio and
>> tv tuners.
>>
>> For tv tuners we've a 1:1 mapping between tuners and inputs, which makes
>> sense, because
>> there are actual dual tuner devices, and the purpose of those is to be able
>> to watch /
>> record 2 "shows" at the same time. This is simply not the case with these
>> radio devices,
>> they can tune both AM and FM but *not* at the same time, so they have a
>> *single*
>> *multiple-band* tuner.
>>
>> Modeling this as multiple tuners is just wrong. Not only have we already
>> discussed
>> this in a long discussion, I've patches to extend the tea575x driver with AM
>> support,
>> and the initial revision used the multiple tuner model, but that just does
>> not work
>> well, and I'm bad Hans V. intervened and pointed out Halli Manjunatha's
>> patchset for
>> limiting hw-freq seek ranges, after which all of this has been discussed
>> extensively!
>>
>>
>>> Also, this is generic enough to cover even devices with non-standard
>>> frequency ranges.
>>>
>>> All bands can easily be detected via a g_tuner loop, and band switching
>>> is done via s_tuner.
>>>
>>> Each band range can have its name ("AM", "FM", "AM-SW", "FM-Japan", ...),
>>> and this is a way more generic than what's being proposed.
>>
>>
>> It is also very very wrong, there is only a single tuner on these devices,
>> modeling this as multiple tuners is just wrong!
>>
>>
>>> It likely makes sense to standardize the band names inside the radio core,
>>> in order to avoid having the same band called with two different names
>>> inside
>>> the drivers.
>>>
>>> It should also be noticed that each band may have different properties.
>>> On the above, the FM band can do stereo/mono and RDS, while AM is just
>>> mono So, a change like what's proposed would keep requiring two entries.
>>
>>
>> With FM we already have a situation where some channels are mono and other
>> stereo, with AM/FM the tuner capabilities would reflect what the tuner can
>> do on some bands-frequency combinations, just like it now reflects what
>> it can do on some frequencies.
>>
>> <snip>
>>
>>
>>>> 87.5 - 108 MHz is very close to 88 - 108 MHz, I don't think it is worth
>>>> creating 2 band defines for this.
>>>
>>>
>>> Yes, it is very close, but Countries that added the extra 500 kHz
>>> bandwidth
>>> added stations there. On those, older devices can't tune into the new
>>> channels.
>>
>>
>> On those older devices rangelow would get reported as 88 rather then 87.5,
>> the
>> band selection mechanism is there to select a certain range approximately,
>> the exact resulting range will be hw specific and reported in rangelow /'
>> rangehigh, as the patch documenting the new fields clearly documents.
>>
>> <snip>
>>
>>
>>>> This would be covered by the V4L2_TUNER_BAND_FM_UNIVERSAL, however,
>>>> on some devices V4L2_TUNER_BAND_FM_UNIVERSAL may include the weather
>>>> band,
>>>> thus going all the way from 76 - 163 Mhz, so I guess we should add a
>>>> V4L2_TUNER_BAND_FM_JAPAN_WIDE for this. Note that the si470x already
>>>> supports this, and indeed calls it "Japan wide band"
>>>
>>>
>>> That's why giving them name via defines is a bad thing: the concept of
>>> "universal" changes from time to time: 15 years ago, an "universal" radio
>>> is a device that were able to tune at AM-SW, AM-MW, AM-HW and FM
>>> (88-108MHz).
>>>
>>> An "universal FM" radio used to be 76-108 MHz, but, with the weather band,
>>> it is now 76-163 Mhz.
>>>
>>> If a band like that is described as "FM" with a frequency range from 76
>>> to 163 MHz, this is clearer than calling it as "FM unversal".
>>
>>
>> We will still have rangelow and rangehigh to report the actual implemented
>> band. So there is no problem here. An app can select universal and then
>> figure out what universal is on the specific device it is using with a
>> G_TUNER.
>>
>> <snip>
>>
>>
>>>> So lets get back to the basis, for AM/FM switching / limiting hw-freq
>>>> seeking, and on some devices likely even just to be able to tune to
>>>> certain frequencies we need to select a band with various radio devices.
>>>>
>>>> On some radio devices we may be able to just program the seek range, but
>>>> on
>>>> most it is hardcoded based on a band selection register.
>>>
>>>
>>> Except due to regulatory requirements, the driver could just expose the
>>> broadest range. That's what I did with tea5767, as it allows using either
>>> an "universal" range from 76 to 108 MHz, or to limit it to 88.5-108MHz.
>>>
>>>> So we need some way of naming the bands, with approx. expected ranges
>>>> (the real range supported by the specific device will be reported on a
>>>> G_TUNER).
>>>>
>>>> Looking at:
>>>> http://en.wikipedia.org/wiki/FM_broadcast_band
>>>>
>>>> I suggest naming the bands after their standards, except for the Japanese
>>>> bands which are special and I suggest just naming them after their
>>>> country, resulting in:
>>>>
>>>> #define V4L2_TUNER_BAND_FM_CCIR        1 /* 87.5 - 108 Mhz */
>>>
>>>
>>> CCIR is a bad (and obsolete) name.
>>
>>
>> Ok, so we call it V4L2_TUNER_BAND_FM_STANDARD, since it seems to
>> be what most of the world is either using or moving too (most of the
>> former USSR has also moved to a range of 87.5 - 108, rather then the
>> OIRT bands).
>>
>>
>>> It is a bad name because it is the name of the Radio committee of the ITU,
>>> and this committee standardizes all radio ranges, not only the above.
>>>
>>> It is an obsolete name, as CCIR was renamed to ITU-R, back in 1992[1].
>>>
>>> Btw, take a look at ITU-R BS.450-3 spec, table 1a[2]: it defines several
>>> ranges there:
>>>         87.5-108
>>>         88-108
>>>         88-100          (Norway)
>>
>>
>> Standard
>>
>>>         66-73           (Gambia)
>>>         66-74           (Lithuania)
>>
>>
>> OIRT
>>
>>>         87.8-108        (US)
>>>         100-108         (India)
>>
>>
>> Standard
>>
>>>         76-90           (Japan)
>>
>>
>> Japan
>>
>> Note that currently several drivers already implement a band concept in some
>> way, ie in the tea5767 driver, you expose this through a config flag called
>> japan_band,
>> and that at least the saa7134 and cx88 cards code adds a tea5767 tuner
>> with the japan_band flag set to 0, resulting in not getting the wide band,
>> but the
>> small band, and thus likely not working in japan. Also note that since the
>> tea5767
>> radio tuner driver uses the standard tuner framework, it reports a hardcoded
>> range
>> of 65-108 (radio_range in drivers/media/video/tuner-core.c) independent of
>> the
>> japan_band parameter.
>>
>> The si470x driver has a band *module* parameter instead, note though that in
>> both cases
>> the (average) user ends up with a hardcoded band, where he should be able to
>> adjust it
>> to match the country/regio he is in...
>>
>> So we really need some way to enumerate and set radio-bands, not
>> radio-tuners, but
>> radio-bands, and that is exactly what the proposed API gives us in a nice
>> and simple
>> way.
>>
>> Regards,
>>
>> Hans
>>
>>
>>
>>
>>
>>
>>
> 
> 
> 


