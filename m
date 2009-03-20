Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:46812 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbZCTGzr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 02:55:47 -0400
Message-ID: <49C33DE7.1050906@gmail.com>
Date: Fri, 20 Mar 2009 10:55:35 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
CC: Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org
Subject: Re: The right way to interpret the content of SNR, signal strength
 	and BER from HVR 4000 Lite
References: <49B9BC93.8060906@nav6.org>	 <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>	 <49B9DECC.5090102@nav6.org>	 <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>	 <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>	 <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>	 <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>	 <20090319101601.2eba0397@pedra.chehab.org>	 <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>	 <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net> <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com> <49C2D4DB.6060509@gmail.com>
In-Reply-To: <49C2D4DB.6060509@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham wrote:
> Devin Heitmueller wrote:
>> On Thu, Mar 19, 2009 at 6:17 PM, Trent Piepho <xyzzy@speakeasy.org> wrote:
>>> On Thu, 19 Mar 2009, Trent Piepho wrote:
>>>> Since the driver often needs to use a logarithm from dvb-math to find SNR,
>>>> you have code like this in the driver (from lgdt3305.c):
>>>>         /* report SNR in dB * 10 */
>>>>         *snr = (state->snr / ((1 << 24) / 10));
>>>>
>>>>> The SNR(dB) will be given by:
>>>>>     SNR(dB) = driver_SNR_measure / 256;
>>>> For the driver side, also from lgdt3305 which has both formats with an
>>>> ifdef:
>>>>         /* convert from 8.24 fixed-point to 8.8 */
>>>>         *snr = (state->snr) >> 16;
>>>>
>>>> FWIW, converting to decimal to print using only integer math:
>>>>
>>>>       /* decimal fixed point */
>>>>       printf("%d.%d dB\n", snr / 10, snr % 10);
>>>>
>>>>       /* binary fixed point */
>>>>       printf("%d.%02d dB\n", snr >> 8, (snr & 0xff) * 100 >> 8);
>>> One more example, converting SNR into a 32-bit floating point number using
>>> only integer operations.  These don't do negative numbers but if the SNR
>>> format used a sign bit it would be very easy to add, as IEEE 754 floating
>>> point uses a sign bit too.  I would need to think about it more to do 2's
>>> complement.
>>>
>>> For binary fixed point the conversion to a float is exact.  For decimal
>>> fixed point it's not.  For example 334 (33.4 dB) will become 33.400002 dB
>>> when converted to floating point.
>>>
>>> /* For 8.8 binary fixed point, this is the no-float version of:
>>>  * float snr_to_float(u16 snr) { return snr / 256.0 } */
>>> u32 snr_to_float(u16 snr)
>>> {
>>>        unsigned int e = 23 - __fls(snr);
>>>        return snr ? ((snr << e) & 0x7fffff) | ((142 - e) << 23) : 0;
>>> }
>>>
>>> /* For .1 decimal fixed point.  NOTE:  This will overflow the 32-bit
>>>  * intermediate value if SNR is above 1638.3 dB!  This is the no-float
>>>  * version of:
>>>  * float snr_to_float(u16 snr) { return snr / 10.0 } */
>>> u32 snr10_to_float(u16 snr)
>>> {
>>>        unsigned int e = 23 - __fls(snr / 10);
>>>        return snr ? ((((snr << e) + 5) / 10) & 0x7fffff) | (150 - e) << 23 : 0;
>>> }
>>>
>>> You'd use the function like this:
>>>
>>>        float f;
>>>        *(u32 *)&f = snr_to_float(snr);
>>>
>> == rant mode on ==
>> Wow, I think we have lost our minds!
>>
>> The argument being put forth is based on the relative efficiency of
>> the multiply versus divide opcodes on modern CPU architectures??  And
>> that you're going to be able to get an SNR with a higher level of
>> precision than 0.1 dB?? (if the hardware suggests that it can then
>> it's LYING to you)
>>
>> If that is the extent of the compelling argument that can be made,
>> then so be it.  But after reading this, I'm kind of dumbfounded that
>> this is the basis for proposing 8.8 format over just sending it back
>> in 0.1dB increments.  We have officially entered the realm of
>> "ridiculous".
> 
> 
> I have been going through this thread with much interest to see
> where it was going.
> 
> In fact, what i found after reading the emails in this thread:
> 
> People would like to see standardized Signal stats in whatever apps
> they like.
> 
> * Some users prefer a dB scale
> * Some users prefer a percent scale
> * Some prefer a relative scale.
> 
> Some need a signal monitor to do specific activity.
> 
> All this needs one to require the existing format into one common
> format as required, which needs all drivers to be converted.
> 
> The Pros:
> 
> * Application can just read the value from the IOCTL and be happy
> dispalying the value.
> 
> The Cons:
> 
> * Converting all drivers is no joke. Many drivers are Reverse
> Engineered, Some are written from specs, Some are written from
> sample code.
> 
> * Assuming that everything is alright, many do think that statistics
> can be just used in a 1:1 proportion depending on some sample code.
> But it has to be borne in mind that it is for a very specific
> reference platform that it is. Lot of things do affect it directly.
> Eventually what you consider statistics from a demod driver, from
> where you get statistics, depends on other frontend components.
> 
> * Now assume that it is correct for the reference platform too..
> Just think how many users are really conversant with all those units
> and how to interpret it .. ? I would say hardly few ...
> 
> * Doing format/protocol conversions in kernel is not something
> that's appreciated.
> 
> * Different types of conversions would be needed. All the conersions
> need to be foolproof, else you shoot your foot, with some odd values
> as well..
> 
> * This concept provides a single format with little or no flexibility.
> 
> 
> I had been thinking a bit on this in the large view. My idea was
> that it would be better not not to modify any driver as it is, but
> get that value out to userspace with that exact representation.
> 
> The current existing API does the statistics correctly, but all it
> needs is that the user/application needs to be told what units it
> expects the statistics in.
> 
> That said, i did a small implementation, with almost all parctical
> possible combinations.
> 
> The Pros:
> 
> * Application can choose whether it wants to display the statistics
> in a specific way the application would like
> 
> * Application can also choose what format the driver provides too..
> 
> * Format conversions are simple at userspace
> 
> * The driver just mentions what format it is using and sends out the
> values are being read and calculated for the hardware requirements.
> No conversions are done in the driver.
> 
> 
> The Cons:
> 
> * The application has to do the format conversion. ie the driver
> does not force the application to use a specific format. In other
> words, it is more flexibility to the application.
> 
> That said, my thoughts follow thus. I guess it hardly needs any
> explanation. But if any queries, i am here around.
> 
> 
> 
> /* Frontend General Statistics
>  * General parameters
>  * FE_*_UNKNOWN:
>  *	Parameter is unknown to the frontend and doesn't really
>  *	make any sense for an application.
>  *
>  * FE_*_RELATIVE:
>  *	Parameter is relative on the basis of a ceil - floor basis
>  *	Format is based on empirical test to determine
>  *	the floor and ceiling values. This format is exactly the
>  *	same format as the existing statistics implementation.
>  *
>  * FE_*_PAD:
>  *	Parameter is used as a Pad variable, not of any use to the
>  *	userspace world.
>  */
> 
> /* Statistics format
>  * FE_FORMAT_S32		:Signed 32 bits
>  * FE_FORMAT_U32		:Unsigned 32 bits
>  * FE_FORMAT_U24		:Unsigned 24 bits
>  * FE_FORMAT_S24		:Signed 24 bits
>  * FE_FORMAT_S16		:Signed 16 bits
>  * FE_FORMAT_U16		:Unsigned 16 bits
>  * FE_FORMAT_S08		:Signed 8 bits
>  * FE_FORMAT_U08		:Unsigned 8 bits
>  */
> enum fecap_format {
> 	FE_FORMAT_UNKNOWN	= 0,
> 	FE_FORMAT_S32,
> 	FE_FORMAT_S24,
> 	FE_FORMAT_S16,
> 	FE_FORMAT_S08,
> 	FE_FORMAT_U32,
> 	FE_FORMAT_U24,
> 	FE_FORMAT_U16,
> 	FE_FORMAT_U08,
> 
> 	FE_FORMAT_PAD		= 0xffffffff
> };
> 
> /* Quality format
>  * FE_QUALITY_SNR_dB_100	:SNR in dB/100
>  * FE_QUALITY_SNR_dB_10		:SNR in dB/10
>  * FE_QUALITY_SNR_dB		:SNR in dB
>  * FE_QUALITY_CNR_dB_100	:CNR in dB/100
>  * FE_QUALITY_CNR_dB_10		:CNR in dB/10
>  * FE_QUALITY_CNR_dB		:CNR in dB
>  * FE_QUALITY_EsNo		:Es/No
>  * FE_QUALITY_EbNo		:Eb/No
>  */
> enum fecap_quality {
> 	/* Unknown */
> 	FE_QUALITY_UNKNOWN	= 0,
> 
> 	/* SNR */
> 	FE_QUALITY_SNR_dB_100,
> 	FE_QUALITY_SNR_dB_10,
> 	FE_QUALITY_SNR_dB,
> 
> 	/* CNR */
> 	FE_QUALITY_CNR_dB_100,
> 	FE_QUALITY_CNR_dB_10,
> 	FE_QUALITY_CNR_dB,
> 
> 	/* Es/No */
> 	FE_QUALITY_EsNo,
> 
> 	/* Eb/No */
> 	FE_QUALITY_EbNo,
> 
> 	/* Relative */
> 	FE_QUALITY_RELATIVE 	= 0xffffffff,
> };
> 
> /* Strength format
>  * FE_STRENGTH_dB_100		:Strength in dB/100
>  * FE_STRENGTH_dB_10		:Strength in dB/10
>  * FE_STRENGTH_dB		:Strength in dB
>  * FE_STRENGTH_dBmV_100		:Strength in dBmV/100
>  * FE_STRENGTH_dBmV_10		:Strength in dBmV/10
>  * FE_STRENGTH_dBmV		:Strength in dBmV
>  * FE_STRENGTH_dBuV_100		:Strength in dBuV/100
>  * FE_STRENGTH_dBuV_10		:Strength in dBuV/10
>  * FE_STRENGTH_dBuV		:Strength in dBuV
>  */
> enum fecap_strength {
> 	FE_STRENGTH_UNKNOWN	= 0,
> 	FE_STRENGTH_dB_100,
> 	FE_STRENGTH_dB_10,
> 	FE_STRENGTH_dB,
> 
> 	/* Relative */
> 	FE_STRENGTH_RELATIVE	= 0xffffffff,
> };
> 
> /* Error Rate format
>  * FE_ERROR_BER_ex (x = e-10 - 30)
>  * FE_ERROR_PER_ex (x = e-10 - 30)
>  */
> enum fecap_errors {
> 	FE_ERROR_UNKNOWN	= 0,
> 	FE_ERROR_BER_e10,
> 	FE_ERROR_BER_e11,
> 	FE_ERROR_BER_e12,
> 	FE_ERROR_BER_e13,
> 	FE_ERROR_BER_e14,
> 	FE_ERROR_BER_e15,
> 	FE_ERROR_BER_e16,
> 	FE_ERROR_BER_e17,
> 	FE_ERROR_BER_e18,
> 	FE_ERROR_BER_e19,
> 	FE_ERROR_BER_e20,
> 	FE_ERROR_BER_e21,
> 	FE_ERROR_BER_e22,
> 	FE_ERROR_BER_e23,
> 	FE_ERROR_BER_e24,
> 	FE_ERROR_BER_e25,
> 	FE_ERROR_BER_e26,
> 	FE_ERROR_BER_e27,
> 	FE_ERROR_BER_e28,
> 	FE_ERROR_BER_e29,
> 	FE_ERROR_BER_e30,
> 	FE_ERROR_PER_e10,
> 	FE_ERROR_PER_e11,
> 	FE_ERROR_PER_e12,
> 	FE_ERROR_PER_e13,
> 	FE_ERROR_PER_e14,
> 	FE_ERROR_PER_e15,
> 	FE_ERROR_PER_e16,
> 	FE_ERROR_PER_e17,
> 	FE_ERROR_PER_e18,
> 	FE_ERROR_PER_e19,
> 	FE_ERROR_PER_e20,
> 	FE_ERROR_PER_e21,
> 	FE_ERROR_PER_e22,
> 	FE_ERROR_PER_e23,
> 	FE_ERROR_PER_e24,
> 	FE_ERROR_PER_e25,
> 	FE_ERROR_PER_e26,
> 	FE_ERROR_PER_e27,
> 	FE_ERROR_PER_e28,
> 	FE_ERROR_PER_e29,
> 	FE_ERROR_PER_e30,
> 
> 	FE_ERROR_RELATIVE	= 0xffffffff,
> };
> 
> struct fecap {
> 	/* current SNR */
> 	enum fecap_format	quality_format;
> 	enum fecap_quality	quality;
> 
> 	/* current strength */
> 	enum fecap_format	strength_format;
> 	enum fecap_strength	strength;
> 
> 	/* current BER */
> 	enum fecap_format	error_format;
> 	enum fecap_errors	error;
> };
> 
> /* FE_STATISTICS_CAPS
>  * Userspace query for frontend signal statistics capabilities
>  * Application uses extracted data from existing "legacy" ioctls
>  * in conjunction with capability definition to describe the
>  * exact signal statistics.
>  */
> #define FE_STATISTICS_CAPS		_IOR('o', 84, struct fecap)

Ok, that will give a 1:1 representation of what the hardware can
provide to the user space and the application can do at will for
the relevant "necessary resolution".

Now, some more thoughts.
1) As someone mentioned in this thread, having a higher precision
for positioning an antenna.

This is not true. Why ?

When you position an antenna, you do not get a LOCK in most cases.
The signal statistics for any demodulator are valid only with a
frontend LOCK.

2) Currently we do get 1 parameter precisely. The rest do not make
sense. Why ?

When you request statistics, it needs to be at any given point of
time. Even if user space requests the parameters consecutively, it
won't have the nearest calls depending on the state of a system, the
calls might not be near in many cases.

So, one would be forced to think what is a good way to get
statistics for antenna positioning.


Here are some probable thoughts.

For positioning an antenna, generally a raw AGC value is employed
from the demodulator rather than SNR or Strength whatever, since the
SNR, Strength, xER are all valid only after the frontend has
acquired a LOCK. Useless parameters otherwise.

Other than that all the parameters needs to be snapshotted at any
given point of time, for fine tuning the position of the antenna,
once the frontend can LOCK, with a coarse position. This is how you
do it manually.

That said the implementation could look thus:

/* FE_SIGNAL_LEVEL
 * This system call provides a direct monitor of the signal, without
 * passing through the relevant processing chains. In many cases, it
 * is simply considered as direct AGC1 scaled values. This parameter
 * can generally be used to position an antenna to while looking at
 * a peak of this value. This parameter can be read back, even when
 * a frontend LOCK has not been achieved. Some microntroller based
 * demodulators do not provide a direct access to the AGC on the
 * demodulator, hence this parameter will be Unsupported for such
 * devices.
 */
#define FE_SIGNAL_LEVEL		_IOR('o', 85, u32 signal)

struct fesignal_stat {
        u32 quality;
	u32 strength;
	u32 error;
	u32 unc;
};

/* FE_SIGNAL_STATS
 * This system call provides a snapshot of all the receiver system

 * at any given point of time. System signal statistics are always
 * computed with respect to time and is best obtained the nearest
 * to each of the individual parameters in a time domain.
 * Signal statistics are assumed, "at any given instance of time".
 * It is not possible to get a snapshot at the exact single instance
 * and hence we look at the nearest instance, in the time domain.
 * The statistics are described by the FE_STATISTICS_CAPS ioctl,
 * ie. based on the device capabilities.
 */
#define FE_SIGNAL_STATS		_IOR('o', 86, struct fesignal_stat)


That would be more or less, what it would require to position an
antenna fairly well, without much knowledge.

Well, that said positioning could be explained for those who on't
have an understanding on how to do it.

Let's assume, currently at position "X" there is no signal, no
frontend LOCK. You can move the antenna to the approximate X-Y
co-ordinates for the Azimuth and Elevation for your required
transponder, while having an eye on FE_SIGNAL_LEVEL.

While the FE_SIGNAL_LEVEL peaks for a given position, try to acquire
a frontend LOCK, with the transponder parameters. Most likely you
will get a frontend LOCK with the coarse positioning with AGC peak
values.

Now, with the frontend LOCK, you can look for initially the peak
again, not the FE_SIGNAL_LEVEL peak in this case, but the
FE_SIGNAL_STATS peak.

In this case you should not be looking at just the strength
parameter alone.

* At the peak, you will get the maximum quality
* falling down the slope to the left and right you will get falling
signal strengths
* Still rolling down, you will get increasing ERROR's, with still
UNCORRECTABLES being steady.
* Still falling down at the thresholds where you are about to loose
frontend LOCK, you will see UNCORRECTABLE's getting incremented.

Couple this logic into a program, with a feedback to the ROTOR and
you get an automated satellite positioner, with a good fine tuned
position.

Regards,
Manu
