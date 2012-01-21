Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab2AUUHt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 15:07:49 -0500
Message-ID: <4F1B0BD8.1070009@redhat.com>
Date: Sat, 21 Jan 2012 17:02:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [RFC] dvb: Add DVBv5 properties for quality parameters
References: <1327063080-29399-1-git-send-email-mchehab@redhat.com> <4F1AF03A.9000502@iki.fi>
In-Reply-To: <4F1AF03A.9000502@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

This patch is a return of the discussions that started in 2009 with those
patches:
	http://patchwork.linuxtv.org/patch/1883/
	http://patchwork.linuxtv.org/patch/2262/
	http://patchwork.linuxtv.org/patch/2280/


Em 21-01-2012 15:04, Antti Palosaari escreveu:
> On 01/20/2012 02:38 PM, Mauro Carvalho Chehab wrote:
> 
> Basically I would like to ask slow down API changes since it causes all the problems and extra work.

In this specific case, this is an API addition. At least from my side,
I'm not planning for 3.4 to change the existing drivers for it, except 
for the ISDB-T ones, where the current statistics don't work.

So, I'm not expecting such addition to break anything on existing drivers.

> Rather than always doing API changes of our perspective I would like to ask 
> if it is possible to ask applications developers to help? Situation is very weird, 
> almost all applications are using old APIs whilst we have had newer one many years...
> If application makers are attending to API changes then most likely those APIs 
> and new features are taken use sooner.

Application feedback is always very welcome.

One of the reasons I decided to work on a library/userspace app is
due to this gap. DVBv3 is very comfortable for people using DVB-T/S/C and
ATSC, as the current applications work fine, but this is not true for
ISDB-T. 

The emulation mode is far from ideal. For example,  I can't properly
submit  scanning tables for ISDB-T to the applications, as the tables 
are not for DVB-T, but for a DVBv3 unsupported standard. So, ISDB-T
users need to seek at some Portuguese sites, where there are some
pages explaining how to make the existing applications to work with
ISDB-T, and a scanning table for 6MHz freqs is provided.

After working on such library, I think I noticed why the current 
applications weren't ported to DVBv5:

	1) Lack of DVBv5 specs. The specs for it were covering
only ISDB-T (and still with errors), until a very recent kernel.
The first kernel where the specs will likely be 100% with regards
to frontend will be Kernel 3.3, after the fixes for ISDB-T and
DVB-S;

	2) Lack of a good example on how to do it;

	3) Lack of a per-delivery system relation of properties.
I'm seriously considering to move the dvbv5-std.h header I wrote
for the libraries to the DVB frontend.h file. This can be used by
dvb_frontend.c in order to check if userspace is passing the right
properties per delivery system, returning -EINVAL if a delivery
system unsupported is passed via FE_SET_PROPERTY. Userspace apps
can also use it, in order to prepare their commands.

	4) Lack of a per-delivery-system validation/documentation
of the acceptable values for each DTV property (one application 
developer from a widely used scanning tool complained about that 
with me);

	5) It is currently not possible to use only DVBv5 for talking
with the frontend, as several DTV commands that don't seem to be
properly implemented (like, for example, DTV_DISEQC_SLAVE_REPLY,
and DTV_PILOT [1]).

(1) and (2)  were solved at the beginning of this year. (3) were
solved at library level.

So, IMHO, what we should do is the reverse: fix the issues with the
DVBv5, document it properly and create a DVBv5 library that can be
used by userspace applications.

Of course, we should avoid regressions while doing that.

On my todo list, as time allows me to do it, and if the developers 
themselves don't properly implement DVBv5 earlier, is to write
some patches for the applications I use, porting them to use the
library, and submitting such patches to the application developers
and likely merging them also into Fedora.

There aren't many things missed there. The only things related to
the frontend API that I'm aware of are:

	- Quality/Stats API (this RFC);
	- CMDB delivery system;
	- ATSC/MH delivery system;
	- DSS delivery system;
	- a flag to indicate that TMCC/TPS carrier is decoded;
	- implement the non_implemented commands (or to remove
	  them from the API);
	- a replacement for FE caps that would carry the new
	  delivery systems values and modulation types.

IMHO, we should focus on solving most of those for 3.4 and 3.5,
while discussing with application guys about what else is pending
for their adoption of DVBv5.

Regards,
Mauro.

[1] DTV_VOLTAGE and DTV_TONE are implemented via a DVBv3 internal
call - not sure if they're working or not. I doubt that anyone
had ever tried to implement satellite LNBf/DISEqC set using DVBv5.
Even on my DVBv5 library, I'm using DVBv3 for LNBf/DISEqC.

> 
>> The DVBv3 quality parameters are limited on several ways:
>>     - Doesn't provide any way to indicate the used measure;
>>     - Userspace need to guess how to calculate the measure;
>>     - Only a limited set of stats are supported;
>>     - Doesn't provide QoS measure for the OFDM TPS/TMCC
>>       carriers, used to detect the network parameters for
>>       DVB-T/ISDB-T;
>>     - Can't be called in a way to require them to be filled
>>       all at once (atomic reads from the hardware), with may
>>       cause troubles on interpreting them on userspace;
>>     - On some OFDM delivery systems, the carriers can be
>>       independently modulated, having different properties.
>>       Currently, there's no way to report per-layer stats;
>>
>> This RFC adds the header definitions meant to solve that issues.
>> After discussed, I'll write a patch for the DocBook and add support
>> for it on some demods. Support for dvbv5-zap and dvbv5-scan tools
>> will also have support for those features.
>>
>> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>> ---
>>   include/linux/dvb/frontend.h |   78 +++++++++++++++++++++++++++++++++++++++++-
>>   1 files changed, 77 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
>> index cb4428a..f9cdb7d 100644
>> --- a/include/linux/dvb/frontend.h
>> +++ b/include/linux/dvb/frontend.h
>> @@ -320,7 +320,21 @@ struct dvb_frontend_event {
>>
>>   #define DTV_ENUM_DELSYS        44
>>
>> -#define DTV_MAX_COMMAND                DTV_ENUM_DELSYS
>> +/* Quality parameters */
>> +#define DTV_ENUM_QUALITY    45    /* Enumerates supported QoS parameters */
>> +#define DTV_QUALITY_SNR        46
>> +#define DTV_QUALITY_CNR        47
>> +#define DTV_QUALITY_EsNo    48
>> +#define DTV_QUALITY_EbNo    49
>> +#define DTV_QUALITY_RELATIVE    50
> 
> Rather many ways to report signal quality. Is it possible to reduce?
> I have feeling having this many different ways to report single subject causes app devels to likely skip whole reporting :]

Manu proposed to have just one DTV_QUALITY and to have a parameter to specify
the type of quality. The issue with that is that it could be possible
for some frontend to provide more than one quality measure.

Yet, In practice, I think that almost all frontends use SNR or a relative
quality measure.

>> +#define DTV_ERROR_BER        51
>> +#define DTV_ERROR_PER        52
>> +#define DTV_ERROR_PARAMS    53    /* Error count at TMCC or TPS carrier */
> 
> No enumeration for two bit error rate methods like quality?

We can add it.

> I don't still see much difference if it is BER or PER. Users usually just want 
> look if there is some errors and compare to uncorrected blocks or picture to see 
> if those can be fixed be demod (inner FEC). Random running numbers for error rate 
> is just enough, unless you are not making some measurement equipment :]

That's true for PC TV card users.

Yet, the API should enable not only PC usecases, but also STB and even measurement
equipments/applications.

> 
>> +#define DTV_FE_STRENGTH        54
>> +#define DTV_FE_SIGNAL        55
> 
> What is difference these two?

This came from Manu's proposal. Signal would be:

+ * This system call provides a direct monitor of the signal, without
+ * passing through the relevant processing chains. In many cases, it
+ * is simply considered as direct AGC1 scaled values. This parameter
+ * can generally be used to position an antenna to while looking at
+ * a peak of this value. This parameter can be read back, even when
+ * a frontend LOCK has not been achieved. Some microntroller based
+ * demodulators do not provide a direct access to the AGC on the
+ * demodulator, hence this parameter will be Unsupported for such

Maybe we can add only the properties actually needed
by the first driver using this way, adding more as new
drivers need.

> 
>> +#define DTV_FE_UNC        56
>> +
>> +#define DTV_MAX_COMMAND        DTV_FE_UNC
>>
>>   typedef enum fe_pilot {
>>       PILOT_ON,
>> @@ -372,12 +386,74 @@ struct dtv_cmds_h {
>>       __u32    reserved:30;    /* Align */
>>   };
>>
>> +/**
>> + * Scale types for the quality parameters.
>> + * @FE_SCALE_DECIBEL: The scale is measured in dB, typically
>> + *          used on signal measures.
>> + * @FE_SCALE_LINEAR: The scale is linear.
>> + *             typically used on error QoS parameters.
>> + * @FE_SCALE_RELATIVE: The scale is relative.
>> + */
>> +enum fecap_scale_params {
>> +    FE_SCALE_DECIBEL,
>> +    FE_SCALE_LINEAR,
>> +    FE_SCALE_RELATIVE
>> +};
> 
> If we end up defining own commands for SNR/CNR/EsNo/EbNo/RELATIVE I 
> don't see need to define scale any-more. Almost all those uses de Facto scale as dB. 
> Define scale per measurement and use that.

Makes sense.

> 
>> +
>> +/**
>> + * struct dtv_status - Used for reading a DTV status property
>> + *
>> + * @value:    value of the measure. Should range from 0 to 0xffff;
>> + * @scale:    Filled with enum fecap_scale_params - the scale
>> + *        in usage for that parameter
>> + * @min:    minimum value. Not used if the scale is relative.
>> + *        For non-relative measures, define the measure
>> + *        associated with dtv_status.value == 0.
>> + * @max:    maximum value. Not used if the scale is    relative.
>> + *        For non-relative measures, define the measure
>> + *        associated with dtv_status.value == 0xffff.
>> + *
>> + * At userspace, min/max values should be used to calculate the
>> + * absolute value of that measure, if fecap_scale_params is not
>> + * FE_SCALE_RELATIVE, using the following formula:
>> + *     measure = min + (value * (max - min) / 0xffff)
>> + *
>> + * For error count measures, typically, min = 0, and max = 0xffff,
>> + * and the measure represent the number of errors detected.
>> + *
>> + * Up to 4 status groups can be provided. This is for the
>> + * OFDM standards where the carriers can be grouped into
>> + * independent layers, each with its own modulation. When
>> + * such layers are used (for example, on ISDB-T), the status
>> + * should be filled with:
>> + *    stat.status[0] = global statistics;
>> + *    stat.status[1] = layer A statistics;
>> + *    stat.status[2] = layer B statistics;
>> + *    stat.status[3] = layer C statistics.
> 
> Are those modulations used as top of each, like inner (layer A), "next to inner" (layer B), outer (layer C)?
> Or just one modulation per stream? I think DVB-T2 have one modulation for common channel and then own 
> modulation per each transport stream (called PLP in case of DVB-T2). In case of DVB-T2 I see it is enough
> to provide current active stream statistics, not for the all possible PLPs there is transmission ongoing.
> And if needed statistics for common channel - but I don't see it very important.

On ISDB-T, they're not hierarchically modulated. 

Each layer has its own modulation, and they are decoded independently.

For example, mb86a20s frontend provides a few global stats, related to the signal 
measures, but the QoS parameters are provided per layer only. It offers 
only per-layer MER, BER and PER measures, as a global measure for them
doesn't make much sense, as each layer is independent.

>> + * and stat.len should be filled with the latest filled status + 1.
>> + * If the frontend doesn't provide a global statistics,
>> + * stat.has_global should be 0.
>> + * Delivery systems that don't use it, should just set stat.len and
>> + * stat.has_global with 1, and fill just stat.status[0].
>> + */
>> +struct dtv_status {
>> +    __u16 value;
>> +    __u16 scale;
>> +    __s16 min;
>> +    __s16 max;
>> +} __attribute__ ((packed));
>> +
>>   struct dtv_property {
>>       __u32 cmd;
>>       __u32 reserved[3];
>>       union {
>>           __u32 data;
>>           struct {
>> +            __u8 len;
>> +            __u8 has_global;
>> +            struct dtv_status status[4];
>> +        } stat;
>> +        struct {
>>               __u8 data[32];
>>               __u32 len;
>>               __u32 reserved1[3];
> 
> regards
> Antti
> 

