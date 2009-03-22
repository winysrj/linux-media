Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:48363 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbZCVCpe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2009 22:45:34 -0400
Subject: Re: The right way to interpret the content of SNR, signal strength
 and BER from HVR 4000 Lite
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>,
	Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <49C33DE7.1050906@gmail.com>
References: <49B9BC93.8060906@nav6.org>
	 <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>
	 <49B9DECC.5090102@nav6.org>
	 <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
	 <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>
	 <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>
	 <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>
	 <20090319101601.2eba0397@pedra.chehab.org>
	 <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>
	 <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net>
	 <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>
	 <49C2D4DB.6060509@gmail.com>  <49C33DE7.1050906@gmail.com>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 22:45:19 -0400
Message-Id: <1237689919.3298.179.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-03-20 at 10:55 +0400, Manu Abraham wrote:
> Manu Abraham wrote:

> > I have been going through this thread with much interest to see
> > where it was going.
> > 
> > In fact, what i found after reading the emails in this thread:
> > 
> > People would like to see standardized Signal stats in whatever apps
> > they like.
> > 
> > * Some users prefer a dB scale
> > * Some users prefer a percent scale
> > * Some prefer a relative scale.
> > 
> > Some need a signal monitor to do specific activity.
> > 
> > All this needs one to require the existing format into one common
> > format as required, which needs all drivers to be converted.
> > 
> > The Pros:
> > 
> > * Application can just read the value from the IOCTL and be happy
> > dispalying the value.
> > 
> > The Cons:
> > 
> > * Converting all drivers is no joke. Many drivers are Reverse
> > Engineered, Some are written from specs, Some are written from
> > sample code.
> > 
> > * Assuming that everything is alright, many do think that statistics
> > can be just used in a 1:1 proportion depending on some sample code.
> > But it has to be borne in mind that it is for a very specific
> > reference platform that it is. Lot of things do affect it directly.
> > Eventually what you consider statistics from a demod driver, from
> > where you get statistics, depends on other frontend components.
> > 
> > * Now assume that it is correct for the reference platform too..
> > Just think how many users are really conversant with all those units
> > and how to interpret it .. ? I would say hardly few ...
> > 
> > * Doing format/protocol conversions in kernel is not something
> > that's appreciated.
> > 
> > * Different types of conversions would be needed. All the conersions
> > need to be foolproof, else you shoot your foot, with some odd values
> > as well..
> > 
> > * This concept provides a single format with little or no flexibility.
> > 
> > 
> > I had been thinking a bit on this in the large view. My idea was
> > that it would be better not not to modify any driver as it is, but
> > get that value out to userspace with that exact representation.
> > 
> > The current existing API does the statistics correctly, but all it
> > needs is that the user/application needs to be told what units it
> > expects the statistics in.
> > 
> > That said, i did a small implementation, with almost all parctical
> > possible combinations.
> > 
> > The Pros:
> > 
> > * Application can choose whether it wants to display the statistics
> > in a specific way the application would like
> > 
> > * Application can also choose what format the driver provides too..
> > 
> > * Format conversions are simple at userspace
> > 
> > * The driver just mentions what format it is using and sends out the
> > values are being read and calculated for the hardware requirements.
> > No conversions are done in the driver.
> > 
> > 
> > The Cons:
> > 
> > * The application has to do the format conversion. ie the driver
> > does not force the application to use a specific format. In other
> > words, it is more flexibility to the application.
> > 
> > That said, my thoughts follow thus. I guess it hardly needs any
> > explanation. But if any queries, i am here around.
> > 
> > 
> > 
> > /* Frontend General Statistics
> >  * General parameters
> >  * FE_*_UNKNOWN:
> >  *	Parameter is unknown to the frontend and doesn't really
> >  *	make any sense for an application.
> >  *
> >  * FE_*_RELATIVE:
> >  *	Parameter is relative on the basis of a ceil - floor basis
> >  *	Format is based on empirical test to determine
> >  *	the floor and ceiling values. This format is exactly the
> >  *	same format as the existing statistics implementation.
> >  *
> >  * FE_*_PAD:
> >  *	Parameter is used as a Pad variable, not of any use to the
> >  *	userspace world.
> >  */
> > 
> > /* Statistics format
> >  * FE_FORMAT_S32		:Signed 32 bits
> >  * FE_FORMAT_U32		:Unsigned 32 bits
> >  * FE_FORMAT_U24		:Unsigned 24 bits
> >  * FE_FORMAT_S24		:Signed 24 bits
> >  * FE_FORMAT_S16		:Signed 16 bits
> >  * FE_FORMAT_U16		:Unsigned 16 bits
> >  * FE_FORMAT_S08		:Signed 8 bits
> >  * FE_FORMAT_U08		:Unsigned 8 bits
> >  */
> > enum fecap_format {
> > 	FE_FORMAT_UNKNOWN	= 0,
> > 	FE_FORMAT_S32,
> > 	FE_FORMAT_S24,
> > 	FE_FORMAT_S16,
> > 	FE_FORMAT_S08,
> > 	FE_FORMAT_U32,
> > 	FE_FORMAT_U24,
> > 	FE_FORMAT_U16,
> > 	FE_FORMAT_U08,
> > 
> > 	FE_FORMAT_PAD		= 0xffffffff
> > };
> > 
> > /* Quality format
> >  * FE_QUALITY_SNR_dB_100	:SNR in dB/100
> >  * FE_QUALITY_SNR_dB_10		:SNR in dB/10
> >  * FE_QUALITY_SNR_dB		:SNR in dB
> >  * FE_QUALITY_CNR_dB_100	:CNR in dB/100
> >  * FE_QUALITY_CNR_dB_10		:CNR in dB/10
> >  * FE_QUALITY_CNR_dB		:CNR in dB
> >  * FE_QUALITY_EsNo		:Es/No
> >  * FE_QUALITY_EbNo		:Eb/No
> >  */
> > enum fecap_quality {
> > 	/* Unknown */
> > 	FE_QUALITY_UNKNOWN	= 0,
> > 
> > 	/* SNR */
> > 	FE_QUALITY_SNR_dB_100,
> > 	FE_QUALITY_SNR_dB_10,
> > 	FE_QUALITY_SNR_dB,
> > 
> > 	/* CNR */
> > 	FE_QUALITY_CNR_dB_100,
> > 	FE_QUALITY_CNR_dB_10,
> > 	FE_QUALITY_CNR_dB,
> > 
> > 	/* Es/No */
> > 	FE_QUALITY_EsNo,
> > 
> > 	/* Eb/No */
> > 	FE_QUALITY_EbNo,
> > 
> > 	/* Relative */
> > 	FE_QUALITY_RELATIVE 	= 0xffffffff,
> > };
> > 
> > /* Strength format
> >  * FE_STRENGTH_dB_100		:Strength in dB/100
> >  * FE_STRENGTH_dB_10		:Strength in dB/10
> >  * FE_STRENGTH_dB		:Strength in dB
> >  * FE_STRENGTH_dBmV_100		:Strength in dBmV/100
> >  * FE_STRENGTH_dBmV_10		:Strength in dBmV/10
> >  * FE_STRENGTH_dBmV		:Strength in dBmV
> >  * FE_STRENGTH_dBuV_100		:Strength in dBuV/100
> >  * FE_STRENGTH_dBuV_10		:Strength in dBuV/10
> >  * FE_STRENGTH_dBuV		:Strength in dBuV
> >  */
> > enum fecap_strength {
> > 	FE_STRENGTH_UNKNOWN	= 0,
> > 	FE_STRENGTH_dB_100,
> > 	FE_STRENGTH_dB_10,
> > 	FE_STRENGTH_dB,
> > 
> > 	/* Relative */
> > 	FE_STRENGTH_RELATIVE	= 0xffffffff,
> > };
> > 
> > /* Error Rate format
> >  * FE_ERROR_BER_ex (x = e-10 - 30)
> >  * FE_ERROR_PER_ex (x = e-10 - 30)
> >  */
> > enum fecap_errors {
> > 	FE_ERROR_UNKNOWN	= 0,
> > 	FE_ERROR_BER_e10,
> > 	FE_ERROR_BER_e11,
> > 	FE_ERROR_BER_e12,
> > 	FE_ERROR_BER_e13,
> > 	FE_ERROR_BER_e14,
> > 	FE_ERROR_BER_e15,
> > 	FE_ERROR_BER_e16,
> > 	FE_ERROR_BER_e17,
> > 	FE_ERROR_BER_e18,
> > 	FE_ERROR_BER_e19,
> > 	FE_ERROR_BER_e20,
> > 	FE_ERROR_BER_e21,
> > 	FE_ERROR_BER_e22,
> > 	FE_ERROR_BER_e23,
> > 	FE_ERROR_BER_e24,
> > 	FE_ERROR_BER_e25,
> > 	FE_ERROR_BER_e26,
> > 	FE_ERROR_BER_e27,
> > 	FE_ERROR_BER_e28,
> > 	FE_ERROR_BER_e29,
> > 	FE_ERROR_BER_e30,
> > 	FE_ERROR_PER_e10,
> > 	FE_ERROR_PER_e11,
> > 	FE_ERROR_PER_e12,
> > 	FE_ERROR_PER_e13,
> > 	FE_ERROR_PER_e14,
> > 	FE_ERROR_PER_e15,
> > 	FE_ERROR_PER_e16,
> > 	FE_ERROR_PER_e17,
> > 	FE_ERROR_PER_e18,
> > 	FE_ERROR_PER_e19,
> > 	FE_ERROR_PER_e20,
> > 	FE_ERROR_PER_e21,
> > 	FE_ERROR_PER_e22,
> > 	FE_ERROR_PER_e23,
> > 	FE_ERROR_PER_e24,
> > 	FE_ERROR_PER_e25,
> > 	FE_ERROR_PER_e26,
> > 	FE_ERROR_PER_e27,
> > 	FE_ERROR_PER_e28,
> > 	FE_ERROR_PER_e29,
> > 	FE_ERROR_PER_e30,
> > 
> > 	FE_ERROR_RELATIVE	= 0xffffffff,
> > };
> > 
> > struct fecap {
> > 	/* current SNR */
> > 	enum fecap_format	quality_format;
> > 	enum fecap_quality	quality;
> > 
> > 	/* current strength */
> > 	enum fecap_format	strength_format;
> > 	enum fecap_strength	strength;
> > 
> > 	/* current BER */
> > 	enum fecap_format	error_format;
> > 	enum fecap_errors	error;
> > };
> > 
> > /* FE_STATISTICS_CAPS
> >  * Userspace query for frontend signal statistics capabilities
> >  * Application uses extracted data from existing "legacy" ioctls
> >  * in conjunction with capability definition to describe the
> >  * exact signal statistics.
> >  */
> > #define FE_STATISTICS_CAPS		_IOR('o', 84, struct fecap)
> 
> Ok, that will give a 1:1 representation of what the hardware can
> provide to the user space and the application can do at will for
> the relevant "necessary resolution".
> 
> Now, some more thoughts.
> 1) As someone mentioned in this thread, having a higher precision
> for positioning an antenna.
> 
> This is not true. Why ?
> 
> When you position an antenna, you do not get a LOCK in most cases.
> The signal statistics for any demodulator are valid only with a
> frontend LOCK.
> 
> 2) Currently we do get 1 parameter precisely. The rest do not make
> sense. Why ?
> 
> When you request statistics, it needs to be at any given point of
> time. Even if user space requests the parameters consecutively, it
> won't have the nearest calls depending on the state of a system, the
> calls might not be near in many cases.
> 
> So, one would be forced to think what is a good way to get
> statistics for antenna positioning.
> 
> 
> Here are some probable thoughts.
> 
> For positioning an antenna, generally a raw AGC value is employed
> from the demodulator rather than SNR or Strength whatever, since the
> SNR, Strength, xER are all valid only after the frontend has
> acquired a LOCK. Useless parameters otherwise.
> 
> Other than that all the parameters needs to be snapshotted at any
> given point of time, for fine tuning the position of the antenna,
> once the frontend can LOCK, with a coarse position. This is how you
> do it manually.
> 
> That said the implementation could look thus:
> 
> /* FE_SIGNAL_LEVEL
>  * This system call provides a direct monitor of the signal, without
>  * passing through the relevant processing chains. In many cases, it
>  * is simply considered as direct AGC1 scaled values. This parameter
>  * can generally be used to position an antenna to while looking at
>  * a peak of this value. This parameter can be read back, even when
>  * a frontend LOCK has not been achieved. Some microntroller based
>  * demodulators do not provide a direct access to the AGC on the
>  * demodulator, hence this parameter will be Unsupported for such
>  * devices.
>  */
> #define FE_SIGNAL_LEVEL		_IOR('o', 85, u32 signal)
> 
> struct fesignal_stat {
>         u32 quality;
> 	u32 strength;
> 	u32 error;
> 	u32 unc;
> };
> 
> /* FE_SIGNAL_STATS
>  * This system call provides a snapshot of all the receiver system
> 
>  * at any given point of time. System signal statistics are always
>  * computed with respect to time and is best obtained the nearest
>  * to each of the individual parameters in a time domain.
>  * Signal statistics are assumed, "at any given instance of time".
>  * It is not possible to get a snapshot at the exact single instance
>  * and hence we look at the nearest instance, in the time domain.
>  * The statistics are described by the FE_STATISTICS_CAPS ioctl,
>  * ie. based on the device capabilities.
>  */
> #define FE_SIGNAL_STATS		_IOR('o', 86, struct fesignal_stat)
> 
> 
> That would be more or less, what it would require to position an
> antenna fairly well, without much knowledge.

[snip]

> Regards,
> Manu



There are lots of interesting ideas here.  From the implementation Manu
has presented to explain his ideas, let me separate out the problem
statement, concept, content, and form from each other and comment on
those separately.



1. Problem (re-)statement:

My understanding of what Manu is saying is, that there is a larger
problem of getting useful statistics out of the drivers to userspace in
a form applications can *understand in general* and then present to the
user in their preferred format.  

This restatement raises the problem up a level from the original
discussion threads.

I think Manu's restatement of the problem, as I understand it, is a
better way to look at the problem, and hence for solutions.



2. Concept:

The essential elements of Manu's concept, as I understand it, are to
provide to userspace

a) Measurement values in their "native form" from the hardware, without
manipulation into another form.

b) Meta-data about the various measurement values (including as to
whether or not they are supported at all), so that the application can
know exaclty how to process the measurement values that are provided in
"native form" from the hardware.


I'm OK with this concept.  It is easy to understand from the kernel side
of things.  It provides flexibility to do more in userspace, which may
come with some complexity to applications unfortunately.

What seemed most interesting about this concept is, per the examples
Manu discussed and Trent provided, the ability to perform userspace
control/tracking loops  using a) the values directly in an automated
process or b) the values converted into human readable form in a manual
process.



3. Content:

In the presented implmentation, I saw the following data items
identified as going from kernel space to userspace:

a) Measurement values
	"raw" signal level
	quality (SNR, CNR, Eb/No, etc.)
	strength (dB, dBuV, etc.)
	error rate (BER, PER)
	uncorrectable blocks

b) Meta-data about the measurment values
	Signedness (signed or unsigned)
	Width (8, 16, 24, or 32 bits)
	Units (SNR_dB, CNR_dB, PER, MER, relative/dimensionless, etc.)
	Exponent (base 10, scales the measurement value for the unit.)


The types of measurment values in the above, I'm assuming, come from
Manu's fairly complete survey or knowledge of what's currently available
in devices.  They look OK to me.

For the meta-data, I'll make the following suggestions:

a) It may be possible to just cast everything to a 32 bit width on the
way out of the kernel and thus dispense with the "width" meta-data.

b) It may be useful for the driver to provide as meta-data the possible
bottom of scale and top of scale values for the measurement values.



4. Form:

The form of the solution presented in the small implementation has 3 new
ioctls, 2 new data structures, and 4 new enumerations.  I think that
this small implementation was excellent for presenting the concept and
communicating the ideas.

I'm not so sure it the best final form for such an interface.  Possible
drawbacks are:

a. Meta-data information is combined, creating larger enumerations
(case:s in a switch() statement) that applications have to deal with.
Signedness is combined with Width; that's not so bad.  Units is combined
with Exponent, making 'enum fecap_errors' rather large.  This is likely
fixable with modification to the presented implementation.

b. A new type of measurment in a new hardware device means a change in
the message structure.  In the presented implementation, I'm not sure
there's a good way to fix this.  (I'm not sure how much of a drawback
this is in reality, my crystal ball is broken...)

c. It makes 3 allocations from the space of possible ioctl values.  I am
under the impression using new ioctls is to be avoided.  I don't know if
that impression is justified.  For perspective, currently about 93 of
the 256 type 'o' ioctl numbers are in use by dvb and 73 of the 256 type
'V' ioctl numbers are in use by v4l.



As an alternative form for the interface between the kernel and
userspace, I can suggest 

a. using the FE_GET_PROPERTY ioctl

b. new defines to use for getting the measurment values and metadata
with FE_GET_PROPERTY.  For example, for the quality measurment and
meta-data:

#define DTV_QUALITY_SIGNEDNESS 41
#define DTV_QUALITY_WIDTH 42 (or DTV_QUALITY_SIGN_WIDTH with values like -32 meaning 32 bit signed)
#define DTV_QUALITY_UNIT 43
#define DTV_QUALITY_EXPONENT 44
#define DTV_QUALITY_TOP_OF_SCALE 45
#define DTV_QUALITY_BOTTOM_OF_SCALE 46

#define DTV_QUALITY 47


c. Variaitons of the enums Manu presented for the meta-data.  For
example for quality:

enum fe_quality_unit {
	FE_QUALITY_UNKOWN
	FE_QUALITY_SNR_dB,
	FE_QUALITY_CNR_dB,
	FE_QUALITY_EsNo,
	FE_QUALITY_EbNo,
	FE_QUALITY_RELATIVE,
};

Exponent is now separated out and sent as a signed integer value.
FE_QUALITY_UNKOWN isn't really needed (I think) as the "result" value in
the returned struct dtv_property can be set to -1 to indicate not
available.


I have *not* done an impact assessment on kernel internal interface
changes for the implementation form Manu presented, nor for the form I
have suggested here.  I'll leave that work to the guy who's thinking of
implementing something - *cough* Devin *cough*. :)

Regards,
Andy

