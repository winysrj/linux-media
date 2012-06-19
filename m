Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab2FSLJq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jun 2012 07:09:46 -0400
Message-ID: <4FE05DF4.7030905@redhat.com>
Date: Tue, 19 Jun 2012 08:09:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 4/6] videodev2.h: add frequency band information.
References: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl> <005651489cd5c9f832df2d5d90e19e2eee07c9b9.1338201853.git.hans.verkuil@cisco.com> <4FDFCC0F.9000208@redhat.com> <4FE037FE.7030804@redhat.com>
In-Reply-To: <4FE037FE.7030804@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-06-2012 05:27, Hans de Goede escreveu:
> Hi,
> 
> On 06/19/2012 02:47 AM, Mauro Carvalho Chehab wrote:
>> Em 28-05-2012 07:46, Hans Verkuil escreveu:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>> Acked-by: Hans de Goede <hdegoede@redhat.com>
>>> ---
>>>    include/linux/videodev2.h |   19 +++++++++++++++++--
>>>    1 file changed, 17 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>>> index 2339678..013ee46 100644
>>> --- a/include/linux/videodev2.h
>>> +++ b/include/linux/videodev2.h
>>> @@ -2023,7 +2023,8 @@ struct v4l2_tuner {
>>>        __u32            audmode;
>>>        __s32            signal;
>>>        __s32            afc;
>>> -    __u32            reserved[4];
>>> +    __u32            band;
>>> +    __u32            reserved[3];
>>>    };
>>>
>>>    struct v4l2_modulator {
>>> @@ -2033,7 +2034,8 @@ struct v4l2_modulator {
>>>        __u32            rangelow;
>>>        __u32            rangehigh;
>>>        __u32            txsubchans;
>>> -    __u32            reserved[4];
>>> +    __u32            band;
>>> +    __u32            reserved[3];
>>>    };
>>>
>>>    /*  Flags for the 'capability' field */
>>> @@ -2048,6 +2050,11 @@ struct v4l2_modulator {
>>>    #define V4L2_TUNER_CAP_RDS        0x0080
>>>    #define V4L2_TUNER_CAP_RDS_BLOCK_IO    0x0100
>>>    #define V4L2_TUNER_CAP_RDS_CONTROLS    0x0200
>>> +#define V4L2_TUNER_CAP_BAND_FM_EUROPE_US     0x00010000
>>> +#define V4L2_TUNER_CAP_BAND_FM_JAPAN         0x00020000
>>> +#define V4L2_TUNER_CAP_BAND_FM_RUSSIAN       0x00040000
>>> +#define V4L2_TUNER_CAP_BAND_FM_WEATHER       0x00080000
>>> +#define V4L2_TUNER_CAP_BAND_AM_MW            0x00100000
>>
>> Frequency band is already specified by rangelow/rangehigh.
>>
>> Why do you need to duplicate this information?
> 
> Because radio tuners may support multiple non overlapping
> bands, this is why this patch also adds a band member
> to the tuner struct, which can be used to set/get
> the current band.
> 
> One example of this are the tea5757 / tea5759
> radio tuner chips:
> 
> FM:
> tea5757 87.5 - 108 MHz

	rangelow = 87.5 * 62500;
	rangehigh = 108 * 62500;

> tea5759 76 - 91 MHz

	rangelow = 76 * 62500;
	rangehigh = 91 * 62500;

> AM:
> Both: 530 - 1710 kHz

	rangelow = 0.530 * 62500;
	rangehigh = 0.1710 * 62500;


See radio-cadet.c:

static int vidioc_g_tuner(struct file *file, void *priv,
				struct v4l2_tuner *v)
{
	struct cadet *dev = video_drvdata(file);

	v->type = V4L2_TUNER_RADIO;
	switch (v->index) {
	case 0:
		strlcpy(v->name, "FM", sizeof(v->name));
		v->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS |
			V4L2_TUNER_CAP_RDS_BLOCK_IO;
		v->rangelow = 1400;     /* 87.5 MHz */
		v->rangehigh = 1728;    /* 108.0 MHz */
		v->rxsubchans = cadet_getstereo(dev);
		switch (v->rxsubchans) {
		case V4L2_TUNER_SUB_MONO:
			v->audmode = V4L2_TUNER_MODE_MONO;
			break;
		case V4L2_TUNER_SUB_STEREO:
			v->audmode = V4L2_TUNER_MODE_STEREO;
			break;
		default:
			break;
		}
		v->rxsubchans |= V4L2_TUNER_SUB_RDS;
		break;
	case 1:
		strlcpy(v->name, "AM", sizeof(v->name));
		v->capability = V4L2_TUNER_CAP_LOW;
		v->rangelow = 8320;      /* 520 kHz */
		v->rangehigh = 26400;    /* 1650 kHz */
		v->rxsubchans = V4L2_TUNER_SUB_MONO;
		v->audmode = V4L2_TUNER_MODE_MONO;
		break;
	default:
		return -EINVAL;
	}
	v->signal = dev->sigstrength; /* We might need to modify scaling of this
 */
	return 0;
}
static int vidioc_s_tuner(struct file *file, void *priv,
				struct v4l2_tuner *v)
{
	struct cadet *dev = video_drvdata(file);

	if (v->index != 0 && v->index != 1)
		return -EINVAL;
	dev->curtuner = v->index;
	return 0;
}

Band switching are made via g_tuner/s_tuner calls. If a device have
several non-overlapping bands, just implement it there. There's no
need for a new API.

Also, this is generic enough to cover even devices with non-standard
frequency ranges.

All bands can easily be detected via a g_tuner loop, and band switching
is done via s_tuner.

Each band range can have its name ("AM", "FM", "AM-SW", "FM-Japan", ...),
and this is a way more generic than what's being proposed.

It likely makes sense to standardize the band names inside the radio core,
in order to avoid having the same band called with two different names inside
the drivers.

It should also be noticed that each band may have different properties.
On the above, the FM band can do stereo/mono and RDS, while AM is just
mono So, a change like what's proposed would keep requiring two entries.

> So an app would set as band one of DEFAULT, EUROPE_US
> (or JAPAN depending on the model) and AM_MW, and then
> get the actual range supported reported in rangelow /
> rangehigh on a subsequent G_TUNER.
> 
> Note that setting ie a band of FM_JAPAN on a 5757 would
> result in the S_TUNER failing with -EINVAL.
> 
>>
>>
>>>
>>>    /*  Flags for the 'rxsubchans' field */
>>>    #define V4L2_TUNER_SUB_MONO        0x0001
>>> @@ -2065,6 +2072,14 @@ struct v4l2_modulator {
>>>    #define V4L2_TUNER_MODE_LANG1        0x0003
>>>    #define V4L2_TUNER_MODE_LANG1_LANG2    0x0004
>>>
>>> +/*  Values for the 'band' field */
>>> +#define V4L2_TUNER_BAND_DEFAULT       0
>>
>> What does "default" mean?
> 
> Default means default. This is for compatibility with
> old apps which don't know about the new tuner band API
> extension so they will set this field to 0 (as reserved
> fields should be set to 0 by userspace). In this case
> we don't want to fail with -EINVAL based on the band
> value, so we need some value all tuners will accept.
> 
> Some tuners, ie the si470x support both selecting a
> specific FM band, as well as selecting a "universal"
> FM band of 76 - 108 MHz. For those default would be
> the universal FM band. For the tea575x devices discussed
> above default would have the range of whatever FM band
> they support.
> 
> Note that even on devices with a universal band being
> able to select a certain band is quite useful to limit
> hardware freq-seek to this band since searching freqs
> below 87.5 is useless in europe / US for example.
> 
> Thinking more about this I think we should rename
> V4L2_TUNER_BAND_DEFAULT to V4L2_TUNER_BAND_FM_UNIVERSAL,
> and document that this means the widest FM band the
> device supports, with the actual limits being reported
> in rangelow and rangehigh. Note that the mentioned ranges
> by the bands are indications of the expected range only
> the true range will still be reported through rangelow and
> rangehigh, and this is what apps are expected to use.
> 
> Defining 0 as V4L2_TUNER_BAND_FM_UNIVERSAL does cause
> a -EINVAL when doing a S_TUNER with a band value of 0
> on AM only tuners, but:
> 1) We don't support AM only tuners atm, and I don't expect
> we will in the future either
> 2) Non band aware apps don't work well with AM tuners anyways
> (as they must take much smaller frequency steps for one).
> 
>>
>>> +#define V4L2_TUNER_BAND_FM_EUROPE_US  1       /* 87.5 Mhz - 108 MHz */
>>
>> EUROPE_US is a bad name for this range. According with Wikipedia, this
>> range is used at "ITU region 1" (Europe/Africa), while America uses
>> ITU region 2 (88-108).
>>
>> In Brazil, the range from 87.5-88 were added several years ago, so it is
>> currently at the "ITU region 1" range, just like in US.
>>
>> I don't doubt that there are still some places at the 88-108 MHz range.
> 
> 87.5 - 108 MHz is very close to 88 - 108 MHz, I don't think it is worth
> creating 2 band defines for this.

Yes, it is very close, but Countries that added the extra 500 kHz bandwidth
added stations there. On those, older devices can't tune into the new channels.

In the city I used to live, two channels were added when the range got
extended, one at 87.5, and another at 87.9.

>>
>>> +#define V4L2_TUNER_BAND_FM_JAPAN      2       /* 76 MHz - 90 MHz */
>>
>> This is currently true, but wikipedia points that they may increase it
>> (from 76MHz to 108MHz?) after the end of NTSC broadcast.
>>
> 
> This would be covered by the V4L2_TUNER_BAND_FM_UNIVERSAL, however,
> on some devices V4L2_TUNER_BAND_FM_UNIVERSAL may include the weather band,
> thus going all the way from 76 - 163 Mhz, so I guess we should add a
> V4L2_TUNER_BAND_FM_JAPAN_WIDE for this. Note that the si470x already
> supports this, and indeed calls it "Japan wide band"

That's why giving them name via defines is a bad thing: the concept of 
"universal" changes from time to time: 15 years ago, an "universal" radio
is a device that were able to tune at AM-SW, AM-MW, AM-HW and FM (88-108MHz).

An "universal FM" radio used to be 76-108 MHz, but, with the weather band,
it is now 76-163 Mhz.

If a band like that is described as "FM" with a frequency range from 76
to 163 MHz, this is clearer than calling it as "FM unversal".

>> The DTV range there starts at channel 14 (473 MHz and upper). Maybe they
>> may reserve the channel 7-13 range (VHF High - starting at 177 MHz) like
>> Brazil for DTV.
>>
>> Anyway, what I mean is that calling a frequency range with a Country name
>> is dangerous, as frequency ranges can vary from time to time.
>>
> 
> So lets get back to the basis, for AM/FM switching / limiting hw-freq
> seeking, and on some devices likely even just to be able to tune to
> certain frequencies we need to select a band with various radio devices.
> 
> On some radio devices we may be able to just program the seek range, but on
> most it is hardcoded based on a band selection register.

Except due to regulatory requirements, the driver could just expose the
broadest range. That's what I did with tea5767, as it allows using either
an "universal" range from 76 to 108 MHz, or to limit it to 88.5-108MHz.

> So we need some way of naming the bands, with approx. expected ranges
> (the real range supported by the specific device will be reported on a
> G_TUNER).
> 
> Looking at:
> http://en.wikipedia.org/wiki/FM_broadcast_band
> 
> I suggest naming the bands after their standards, except for the Japanese
> bands which are special and I suggest just naming them after their
> country, resulting in:
> 
> #define V4L2_TUNER_BAND_FM_CCIR        1 /* 87.5 - 108 Mhz */

CCIR is a bad (and obsolete) name. 

It is a bad name because it is the name of the Radio committee of the ITU,
and this committee standardizes all radio ranges, not only the above.

It is an obsolete name, as CCIR was renamed to ITU-R, back in 1992[1].

Btw, take a look at ITU-R BS.450-3 spec, table 1a[2]: it defines several ranges there:
	87.5-108
	88-108
	88-100		(Norway)
	66-73		(Gambia)
	66-74		(Lithuania)
	87.8-108	(US)
	100-108		(India)
	76-90		(Japan)
	...

[1] http://en.wikipedia.org/wiki/ITU-R
[2] http://www.itu.int/dms_pubrec/itu-r/rec/bs/R-REC-BS.450-3-200111-I!!MSW-E.doc

> #define V4L2_TUNER_BAND_FM_OIRT        2 /* 65.8 MHz - 74 MHz */
> #define V4L2_TUNER_BAND_JAPAN        3 /* 76 MHz - 90 MHz */
> #define V4L2_TUNER_BAND_JAPAN_WIDE    4 /* 76 MHz - 108 MHz */
> #define V4L2_TUNER_BAND_WEATHER        5 /* 162.4 MHz - 162.55 MHz */
> 
> Note for rationale of the weather band, see:
> http://en.wikipedia.org/wiki/Weather_radio
> 
> Regards,
> 
> Hans

Regards,
Mauro
