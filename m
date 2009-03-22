Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:40454 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbZCVK2H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2009 06:28:07 -0400
Message-ID: <49C61274.9030202@gmail.com>
Date: Sun, 22 Mar 2009 14:27:00 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Andy Walls <awalls@radix.net>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
 and BER from HVR 4000 Lite
References: <49B9BC93.8060906@nav6.org>	 <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>	 <49B9DECC.5090102@nav6.org>	 <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>	 <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>	 <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>	 <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>	 <20090319101601.2eba0397@pedra.chehab.org>	 <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>	 <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net>	 <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>	 <49C2D4DB.6060509@gmail.com>  <49C33DE7.1050906@gmail.com> <1237689919.3298.179.camel@palomino.walls.org>
In-Reply-To: <1237689919.3298.179.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Fri, 2009-03-20 at 10:55 +0400, Manu Abraham wrote:
>> Manu Abraham wrote:
> 
>>> I have been going through this thread with much interest to see
>>> where it was going.
>>>
>>> In fact, what i found after reading the emails in this thread:
>>>
>>> People would like to see standardized Signal stats in whatever apps
>>> they like.
>>>
>>> * Some users prefer a dB scale
>>> * Some users prefer a percent scale
>>> * Some prefer a relative scale.
>>>
>>> Some need a signal monitor to do specific activity.
>>>
>>> All this needs one to require the existing format into one common
>>> format as required, which needs all drivers to be converted.
>>>
>>> The Pros:
>>>
>>> * Application can just read the value from the IOCTL and be happy
>>> dispalying the value.
>>>
>>> The Cons:
>>>
>>> * Converting all drivers is no joke. Many drivers are Reverse
>>> Engineered, Some are written from specs, Some are written from
>>> sample code.
>>>
>>> * Assuming that everything is alright, many do think that statistics
>>> can be just used in a 1:1 proportion depending on some sample code.
>>> But it has to be borne in mind that it is for a very specific
>>> reference platform that it is. Lot of things do affect it directly.
>>> Eventually what you consider statistics from a demod driver, from
>>> where you get statistics, depends on other frontend components.
>>>
>>> * Now assume that it is correct for the reference platform too..
>>> Just think how many users are really conversant with all those units
>>> and how to interpret it .. ? I would say hardly few ...
>>>
>>> * Doing format/protocol conversions in kernel is not something
>>> that's appreciated.
>>>
>>> * Different types of conversions would be needed. All the conersions
>>> need to be foolproof, else you shoot your foot, with some odd values
>>> as well..
>>>
>>> * This concept provides a single format with little or no flexibility.
>>>
>>>
>>> I had been thinking a bit on this in the large view. My idea was
>>> that it would be better not not to modify any driver as it is, but
>>> get that value out to userspace with that exact representation.
>>>
>>> The current existing API does the statistics correctly, but all it
>>> needs is that the user/application needs to be told what units it
>>> expects the statistics in.
>>>
>>> That said, i did a small implementation, with almost all parctical
>>> possible combinations.
>>>
>>> The Pros:
>>>
>>> * Application can choose whether it wants to display the statistics
>>> in a specific way the application would like
>>>
>>> * Application can also choose what format the driver provides too..
>>>
>>> * Format conversions are simple at userspace
>>>
>>> * The driver just mentions what format it is using and sends out the
>>> values are being read and calculated for the hardware requirements.
>>> No conversions are done in the driver.
>>>
>>>
>>> The Cons:
>>>
>>> * The application has to do the format conversion. ie the driver
>>> does not force the application to use a specific format. In other
>>> words, it is more flexibility to the application.
>>>
>>> That said, my thoughts follow thus. I guess it hardly needs any
>>> explanation. But if any queries, i am here around.
>>>
>>>
>>>
>>> /* Frontend General Statistics
>>>  * General parameters
>>>  * FE_*_UNKNOWN:
>>>  *	Parameter is unknown to the frontend and doesn't really
>>>  *	make any sense for an application.
>>>  *
>>>  * FE_*_RELATIVE:
>>>  *	Parameter is relative on the basis of a ceil - floor basis
>>>  *	Format is based on empirical test to determine
>>>  *	the floor and ceiling values. This format is exactly the
>>>  *	same format as the existing statistics implementation.
>>>  *
>>>  * FE_*_PAD:
>>>  *	Parameter is used as a Pad variable, not of any use to the
>>>  *	userspace world.
>>>  */
>>>
>>> /* Statistics format
>>>  * FE_FORMAT_S32		:Signed 32 bits
>>>  * FE_FORMAT_U32		:Unsigned 32 bits
>>>  * FE_FORMAT_U24		:Unsigned 24 bits
>>>  * FE_FORMAT_S24		:Signed 24 bits
>>>  * FE_FORMAT_S16		:Signed 16 bits
>>>  * FE_FORMAT_U16		:Unsigned 16 bits
>>>  * FE_FORMAT_S08		:Signed 8 bits
>>>  * FE_FORMAT_U08		:Unsigned 8 bits
>>>  */
>>> enum fecap_format {
>>> 	FE_FORMAT_UNKNOWN	= 0,
>>> 	FE_FORMAT_S32,
>>> 	FE_FORMAT_S24,
>>> 	FE_FORMAT_S16,
>>> 	FE_FORMAT_S08,
>>> 	FE_FORMAT_U32,
>>> 	FE_FORMAT_U24,
>>> 	FE_FORMAT_U16,
>>> 	FE_FORMAT_U08,
>>>
>>> 	FE_FORMAT_PAD		= 0xffffffff
>>> };
>>>
>>> /* Quality format
>>>  * FE_QUALITY_SNR_dB_100	:SNR in dB/100
>>>  * FE_QUALITY_SNR_dB_10		:SNR in dB/10
>>>  * FE_QUALITY_SNR_dB		:SNR in dB
>>>  * FE_QUALITY_CNR_dB_100	:CNR in dB/100
>>>  * FE_QUALITY_CNR_dB_10		:CNR in dB/10
>>>  * FE_QUALITY_CNR_dB		:CNR in dB
>>>  * FE_QUALITY_EsNo		:Es/No
>>>  * FE_QUALITY_EbNo		:Eb/No
>>>  */
>>> enum fecap_quality {
>>> 	/* Unknown */
>>> 	FE_QUALITY_UNKNOWN	= 0,
>>>
>>> 	/* SNR */
>>> 	FE_QUALITY_SNR_dB_100,
>>> 	FE_QUALITY_SNR_dB_10,
>>> 	FE_QUALITY_SNR_dB,
>>>
>>> 	/* CNR */
>>> 	FE_QUALITY_CNR_dB_100,
>>> 	FE_QUALITY_CNR_dB_10,
>>> 	FE_QUALITY_CNR_dB,
>>>
>>> 	/* Es/No */
>>> 	FE_QUALITY_EsNo,
>>>
>>> 	/* Eb/No */
>>> 	FE_QUALITY_EbNo,
>>>
>>> 	/* Relative */
>>> 	FE_QUALITY_RELATIVE 	= 0xffffffff,
>>> };
>>>
>>> /* Strength format
>>>  * FE_STRENGTH_dB_100		:Strength in dB/100
>>>  * FE_STRENGTH_dB_10		:Strength in dB/10
>>>  * FE_STRENGTH_dB		:Strength in dB
>>>  * FE_STRENGTH_dBmV_100		:Strength in dBmV/100
>>>  * FE_STRENGTH_dBmV_10		:Strength in dBmV/10
>>>  * FE_STRENGTH_dBmV		:Strength in dBmV
>>>  * FE_STRENGTH_dBuV_100		:Strength in dBuV/100
>>>  * FE_STRENGTH_dBuV_10		:Strength in dBuV/10
>>>  * FE_STRENGTH_dBuV		:Strength in dBuV
>>>  */
>>> enum fecap_strength {
>>> 	FE_STRENGTH_UNKNOWN	= 0,
>>> 	FE_STRENGTH_dB_100,
>>> 	FE_STRENGTH_dB_10,
>>> 	FE_STRENGTH_dB,
>>>
>>> 	/* Relative */
>>> 	FE_STRENGTH_RELATIVE	= 0xffffffff,
>>> };
>>>
>>> /* Error Rate format
>>>  * FE_ERROR_BER_ex (x = e-10 - 30)
>>>  * FE_ERROR_PER_ex (x = e-10 - 30)
>>>  */
>>> enum fecap_errors {
>>> 	FE_ERROR_UNKNOWN	= 0,
>>> 	FE_ERROR_BER_e10,
>>> 	FE_ERROR_BER_e11,
>>> 	FE_ERROR_BER_e12,
>>> 	FE_ERROR_BER_e13,
>>> 	FE_ERROR_BER_e14,
>>> 	FE_ERROR_BER_e15,
>>> 	FE_ERROR_BER_e16,
>>> 	FE_ERROR_BER_e17,
>>> 	FE_ERROR_BER_e18,
>>> 	FE_ERROR_BER_e19,
>>> 	FE_ERROR_BER_e20,
>>> 	FE_ERROR_BER_e21,
>>> 	FE_ERROR_BER_e22,
>>> 	FE_ERROR_BER_e23,
>>> 	FE_ERROR_BER_e24,
>>> 	FE_ERROR_BER_e25,
>>> 	FE_ERROR_BER_e26,
>>> 	FE_ERROR_BER_e27,
>>> 	FE_ERROR_BER_e28,
>>> 	FE_ERROR_BER_e29,
>>> 	FE_ERROR_BER_e30,
>>> 	FE_ERROR_PER_e10,
>>> 	FE_ERROR_PER_e11,
>>> 	FE_ERROR_PER_e12,
>>> 	FE_ERROR_PER_e13,
>>> 	FE_ERROR_PER_e14,
>>> 	FE_ERROR_PER_e15,
>>> 	FE_ERROR_PER_e16,
>>> 	FE_ERROR_PER_e17,
>>> 	FE_ERROR_PER_e18,
>>> 	FE_ERROR_PER_e19,
>>> 	FE_ERROR_PER_e20,
>>> 	FE_ERROR_PER_e21,
>>> 	FE_ERROR_PER_e22,
>>> 	FE_ERROR_PER_e23,
>>> 	FE_ERROR_PER_e24,
>>> 	FE_ERROR_PER_e25,
>>> 	FE_ERROR_PER_e26,
>>> 	FE_ERROR_PER_e27,
>>> 	FE_ERROR_PER_e28,
>>> 	FE_ERROR_PER_e29,
>>> 	FE_ERROR_PER_e30,
>>>
>>> 	FE_ERROR_RELATIVE	= 0xffffffff,
>>> };
>>>
>>> struct fecap {
>>> 	/* current SNR */
>>> 	enum fecap_format	quality_format;
>>> 	enum fecap_quality	quality;
>>>
>>> 	/* current strength */
>>> 	enum fecap_format	strength_format;
>>> 	enum fecap_strength	strength;
>>>
>>> 	/* current BER */
>>> 	enum fecap_format	error_format;
>>> 	enum fecap_errors	error;
>>> };
>>>
>>> /* FE_STATISTICS_CAPS
>>>  * Userspace query for frontend signal statistics capabilities
>>>  * Application uses extracted data from existing "legacy" ioctls
>>>  * in conjunction with capability definition to describe the
>>>  * exact signal statistics.
>>>  */
>>> #define FE_STATISTICS_CAPS		_IOR('o', 84, struct fecap)
>> Ok, that will give a 1:1 representation of what the hardware can
>> provide to the user space and the application can do at will for
>> the relevant "necessary resolution".
>>
>> Now, some more thoughts.
>> 1) As someone mentioned in this thread, having a higher precision
>> for positioning an antenna.
>>
>> This is not true. Why ?
>>
>> When you position an antenna, you do not get a LOCK in most cases.
>> The signal statistics for any demodulator are valid only with a
>> frontend LOCK.
>>
>> 2) Currently we do get 1 parameter precisely. The rest do not make
>> sense. Why ?
>>
>> When you request statistics, it needs to be at any given point of
>> time. Even if user space requests the parameters consecutively, it
>> won't have the nearest calls depending on the state of a system, the
>> calls might not be near in many cases.
>>
>> So, one would be forced to think what is a good way to get
>> statistics for antenna positioning.
>>
>>
>> Here are some probable thoughts.
>>
>> For positioning an antenna, generally a raw AGC value is employed
>> from the demodulator rather than SNR or Strength whatever, since the
>> SNR, Strength, xER are all valid only after the frontend has
>> acquired a LOCK. Useless parameters otherwise.
>>
>> Other than that all the parameters needs to be snapshotted at any
>> given point of time, for fine tuning the position of the antenna,
>> once the frontend can LOCK, with a coarse position. This is how you
>> do it manually.
>>
>> That said the implementation could look thus:
>>
>> /* FE_SIGNAL_LEVEL
>>  * This system call provides a direct monitor of the signal, without
>>  * passing through the relevant processing chains. In many cases, it
>>  * is simply considered as direct AGC1 scaled values. This parameter
>>  * can generally be used to position an antenna to while looking at
>>  * a peak of this value. This parameter can be read back, even when
>>  * a frontend LOCK has not been achieved. Some microntroller based
>>  * demodulators do not provide a direct access to the AGC on the
>>  * demodulator, hence this parameter will be Unsupported for such
>>  * devices.
>>  */
>> #define FE_SIGNAL_LEVEL		_IOR('o', 85, u32 signal)
>>
>> struct fesignal_stat {
>>         u32 quality;
>> 	u32 strength;
>> 	u32 error;
>> 	u32 unc;
>> };
>>
>> /* FE_SIGNAL_STATS
>>  * This system call provides a snapshot of all the receiver system
>>
>>  * at any given point of time. System signal statistics are always
>>  * computed with respect to time and is best obtained the nearest
>>  * to each of the individual parameters in a time domain.
>>  * Signal statistics are assumed, "at any given instance of time".
>>  * It is not possible to get a snapshot at the exact single instance
>>  * and hence we look at the nearest instance, in the time domain.
>>  * The statistics are described by the FE_STATISTICS_CAPS ioctl,
>>  * ie. based on the device capabilities.
>>  */
>> #define FE_SIGNAL_STATS		_IOR('o', 86, struct fesignal_stat)
>>
>>
>> That would be more or less, what it would require to position an
>> antenna fairly well, without much knowledge.
> 
> [snip]
> 
>> Regards,
>> Manu
> 
> 
> 
> There are lots of interesting ideas here.  From the implementation Manu
> has presented to explain his ideas, let me separate out the problem
> statement, concept, content, and form from each other and comment on
> those separately.
> 
> 
> 
> 1. Problem (re-)statement:
> 
> My understanding of what Manu is saying is, that there is a larger
> problem of getting useful statistics out of the drivers to userspace in
> a form applications can *understand in general* and then present to the
> user in their preferred format.  
> 
> This restatement raises the problem up a level from the original
> discussion threads.
> 
> I think Manu's restatement of the problem, as I understand it, is a
> better way to look at the problem, and hence for solutions.
> 
> 
> 
> 2. Concept:
> 
> The essential elements of Manu's concept, as I understand it, are to
> provide to userspace
> 
> a) Measurement values in their "native form" from the hardware, without
> manipulation into another form.
> 
> b) Meta-data about the various measurement values (including as to
> whether or not they are supported at all), so that the application can
> know exaclty how to process the measurement values that are provided in
> "native form" from the hardware.
> 
> 
> I'm OK with this concept.  It is easy to understand from the kernel side
> of things.  It provides flexibility to do more in userspace, which may
> come with some complexity to applications unfortunately.


An application can chose to remain with the least complexity, if
they don't try to re-interpret the format, but display it on a 1:1
scale that the driver provides.

It would be a "luxurious" application that's going to do format
translation. In such a case, the so called "complexity" in format
translation is "justified", which in other case you are going to
handle within the kernel driver. You need to handle the translation
some place, unless the application provides the information as is,
with no modifications.

In many cases this implementation is going to be broken, as it
brings a large unknown translation.

In any cases, it is not in the kernel that you should be doing
translations or protocol conversions. In many cases, one ends up in
having bad interpretations in doing such conversions in kernel.

It is of course much better to leave it to the application, that
conversion, to be handled in a generic way, "iff" it is necessary,
rather than forcing an application to have another broken
implementation for some devices.

Application authors are much smart at it, rather than to have dumb
hacks in the kernel drivers. Also it allows people to have their own
way that is thought to be better, giving rise to innovation and
flexibility, rather than forcing something broken down the throat of
 the users. Also it give the applications the freedom to implement a
certain feature as and when necessary.

> 
> What seemed most interesting about this concept is, per the examples
> Manu discussed and Trent provided, the ability to perform userspace
> control/tracking loops  using a) the values directly in an automated
> process or b) the values converted into human readable form in a manual
> process.
> 


Believe me or not, not many users are going to be conversant with
this direct decibels approach and is going to cause much ridicule even.

In the "rigid approach", are you going to force an upward or a
downward scale to the user ? How many driver authors are well
conversant with such scaling ? And do the Linux driver authors who
spend free time on the drivers do understand all these concepts ?
Is it possible for even card manufacturers who provide drivers to
understand all these ?

Maybe "some" chip vendors are capable of stating that, that's what i
do believe in, since it requires to have and understanding what
happens within a certain chip.

In my experience, even a chip manufacturer has to dig a lot into
their internal resources to provide precise and consistent details
on such concepts on the how and why. Just forget about drivers from
"cut and pasted" sample code from the chip manufacturer.

So as i would term this, each and every person will have an idea of
his/her own, on such rigid approaches and hence such rigid
approaches are considered broken in most situations.

As an example: in a very professional use case, i do have a very
setup that uses one specific chip and my application is specific to
that family of chips. In such a case it makes sense for me to have
such a feature, which i think is useless for the home user, as it is
not a generic one and that which the home user is never going to face.

OTOH, as an example to calculate real Signal Strengths etc, you need
to calculate on the basis of the down-link margin, LNA/LNB/LNC noise
figure/gain, Dish size etc to get a real useful figure on this.

Information like this is never available to the kernel driver, but
is very much available to the user application as a whole, with even
more information available.

Real life applications do things like these, but when it comes to
the Linux community, due to the never ending discussions and the
politics leading to nowhere, such implementations never do see
light, even if an application author is capable to do all these.
He/She would be better off writing a closed source application and
selling it for $$$$$$ for those features, with a public patch to
whatever GPL'd headers as necessary, rather than wasting his/her
energy explaining things to people who are very unlikely to
understand even the basics. For the very same reason it lags beyond
very much in terms of hardware capabilities for decades.

That said, information like this always belong at the application
side, not the kernel driver. The kernel driver should simply do so
I/O, some normalization, and some basic calculations which are very
much extremely specific to that chip. If we were not to have such a
generic framework, it would be much still better to have a driver
which does only I/O operations in the kernel, such as a specific Bus
operation and let all those calculations be used in the user-space.

Just for information sake: there are even drivers that are better
implemented in user-space than in the kernel, due to the very same
reasons. That what looks different "today" might be a reality
"tomorrow" looking at industry trends.



That said, there are very specific useful use cases for what's being
discussed, but this is "definitely not" for the home user.

> 3. Content:
> 
> In the presented implmentation, I saw the following data items
> identified as going from kernel space to userspace:
> 
> a) Measurement values
> 	"raw" signal level
> 	quality (SNR, CNR, Eb/No, etc.)
> 	strength (dB, dBuV, etc.)
> 	error rate (BER, PER)
> 	uncorrectable blocks
> 
> b) Meta-data about the measurment values
> 	Signedness (signed or unsigned)
> 	Width (8, 16, 24, or 32 bits)
> 	Units (SNR_dB, CNR_dB, PER, MER, relative/dimensionless, etc.)
> 	Exponent (base 10, scales the measurement value for the unit.)
> 
> 
> The types of measurment values in the above, I'm assuming, come from
> Manu's fairly complete survey or knowledge of what's currently available
> in devices.  They look OK to me.
> 
> For the meta-data, I'll make the following suggestions:
> 
> a) It may be possible to just cast everything to a 32 bit width on the
> way out of the kernel and thus dispense with the "width" meta-data.
> 
> b) It may be useful for the driver to provide as meta-data the possible
> bottom of scale and top of scale values for the measurement values.
> 
> 
> 
> 4. Form:
> 
> The form of the solution presented in the small implementation has 3 new
> ioctls, 2 new data structures, and 4 new enumerations.  I think that
> this small implementation was excellent for presenting the concept and
> communicating the ideas.
> 
> I'm not so sure it the best final form for such an interface.  Possible
> drawbacks are:
> 
> a. Meta-data information is combined, creating larger enumerations
> (case:s in a switch() statement) that applications have to deal with.
> Signedness is combined with Width; that's not so bad.  Units is combined
> with Exponent, making 'enum fecap_errors' rather large.  This is likely
> fixable with modification to the presented implementation.


It is delivery system dependent.

So, you don't need that "large" switch statement. The large
enumeration came from the bad design that was added on top of the v3
API, where everything was made to use a flat topology. You only need
to apply part of that enumeration into a switch which is delivery
dependent.

The drawbacks of the flat topology, have been seen in the form of
complaints from users and applications having a hard time to make
use of the driver in a sane way.


> b. A new type of measurment in a new hardware device means a change in
> the message structure.  In the presented implementation, I'm not sure
> there's a good way to fix this.  (I'm not sure how much of a drawback
> this is in reality, my crystal ball is broken...)
> 
> c. It makes 3 allocations from the space of possible ioctl values.  I am
> under the impression using new ioctls is to be avoided.  I don't know if
> that impression is justified.  For perspective, currently about 93 of
> the 256 type 'o' ioctl numbers are in use by dvb and 73 of the 256 type
> 'V' ioctl numbers are in use by v4l.


3 new ioctl's is not a problem at all, that i must say. Just look at
all the redundant and useless code in dvb-core and useless
parameters in the API, without any thought or design. Anyone cares ?
Anyway, that's not the thing i want to point out.


> As an alternative form for the interface between the kernel and
> userspace, I can suggest 
> 
> a. using the FE_GET_PROPERTY ioctl
> 
> b. new defines to use for getting the measurment values and metadata
> with FE_GET_PROPERTY.  For example, for the quality measurment and
> meta-data:


As Klaus pointed out earlier, in another thread, about delivery
system capabilities, this is definitely broken, for exactly the same
reason and for newer devices.

Any multi-standard device using this approach is definitely broken,
for the same reasons, the level of breakage will depend upon the
type of the device. For exactly the same reasons this ioctl
shouldn't be used in here.

I guess these days quite some people like to have broken devices for
others, than the hardware that they are likely to use (with a touch
of sarcasm).


> #define DTV_QUALITY_SIGNEDNESS 41
> #define DTV_QUALITY_WIDTH 42 (or DTV_QUALITY_SIGN_WIDTH with values like -32 meaning 32 bit signed)


Defining width as a whole sounds slightly more efficient, but
definitely it doesn't make much of a difference, as that enumeration
is 32 bits wide, You can either use it as a width variable directly,
even in that case. In fact even in the form right now it is exactly
that way. In any case the enumerations do provide better
documentation directly to the user than they guessing what it is. An
API should be understandable without reading too much.

Thinking again, maybe representing width just as a u32 bits
parameter is not bad either.

Instead of enum fecap_format, it could simply be u32 fecap_width.

> #define DTV_QUALITY_UNIT 43
> #define DTV_QUALITY_EXPONENT 44


This would be just ugly, for implementing within the driver, just
adding useless callbacks. These are basically static information and
do not need an additional callback, such as get_properties

The point here is to have little modifications to existing drivers.
Else you end up having more broken drivers as well, adding crap to
the way the DVB API/Core is screwed up by now.


> #define DTV_QUALITY_TOP_OF_SCALE 45
> #define DTV_QUALITY_BOTTOM_OF_SCALE 46


You wouldn't need this, as most of the drivers provides values
clamped to floor and ceiling. This is how DVB devices have generally
done till now.

But that said, maybe some devices could have provided
a broken implementation as well.

Floor and Ceiling wouldn't be necessary again, unless you loose
those already clamped information, which would mean that common code
is making things inefficient for other devices on the whole and it
really raises the question whether it makes sense to have common
code at all!

The point here, is to fix drivers that do not provide a floor and
ceiling, rather than to workaround them and break working ones to
the format of the broken ones.

> 
> #define DTV_QUALITY 47
> 
> 
> c. Variaitons of the enums Manu presented for the meta-data.  For
> example for quality:
> 
> enum fe_quality_unit {
> 	FE_QUALITY_UNKOWN
> 	FE_QUALITY_SNR_dB,
> 	FE_QUALITY_CNR_dB,
> 	FE_QUALITY_EsNo,
> 	FE_QUALITY_EbNo,
> 	FE_QUALITY_RELATIVE,
> };
> 
> Exponent is now separated out and sent as a signed integer value.
> FE_QUALITY_UNKOWN isn't really needed (I think) as the "result" value in
> the returned struct dtv_property can be set to -1 to indicate not
> available.


It is indeed required. The question is not whether this is available
or not, but it is a question whether the unit is UNKNOWN. When it is
not implemented, it is supposed to return -ENOSYS or Unsupported as
described in the specification.

Regards,
Manu

