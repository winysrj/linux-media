Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f208.google.com ([209.85.217.208]:54017 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845AbZCWBAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2009 21:00:40 -0400
Received: by gxk4 with SMTP id 4so4992904gxk.13
        for <linux-media@vger.kernel.org>; Sun, 22 Mar 2009 18:00:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237689919.3298.179.camel@palomino.walls.org>
References: <49B9BC93.8060906@nav6.org>
	 <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>
	 <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>
	 <20090319101601.2eba0397@pedra.chehab.org>
	 <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>
	 <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net>
	 <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>
	 <49C2D4DB.6060509@gmail.com> <49C33DE7.1050906@gmail.com>
	 <1237689919.3298.179.camel@palomino.walls.org>
Date: Sun, 22 Mar 2009 21:00:36 -0400
Message-ID: <412bdbff0903221800j2f9e1137u7776191e2e75d9d2@mail.gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
	and BER from HVR 4000 Lite
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>,
	Manu Abraham <abraham.manu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 21, 2009 at 10:45 PM, Andy Walls <awalls@radix.net> wrote:
> There are lots of interesting ideas here.  From the implementation Manu
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
> I'm OK with this concept.  It is easy to understand from the kernel side
> of things.  It provides flexibility to do more in userspace, which may
> come with some complexity to applications unfortunately.
>
> What seemed most interesting about this concept is, per the examples
> Manu discussed and Trent provided, the ability to perform userspace
> control/tracking loops  using a) the values directly in an automated
> process or b) the values converted into human readable form in a manual
> process.
>
>
>
> 3. Content:
>
> In the presented implmentation, I saw the following data items
> identified as going from kernel space to userspace:
>
> a) Measurement values
>        "raw" signal level
>        quality (SNR, CNR, Eb/No, etc.)
>        strength (dB, dBuV, etc.)
>        error rate (BER, PER)
>        uncorrectable blocks
>
> b) Meta-data about the measurment values
>        Signedness (signed or unsigned)
>        Width (8, 16, 24, or 32 bits)
>        Units (SNR_dB, CNR_dB, PER, MER, relative/dimensionless, etc.)
>        Exponent (base 10, scales the measurement value for the unit.)
>
>
> The types of measurment values in the above, I'm assuming, come from
> Manu's fairly complete survey or knowledge of what's currently available
> in devices.  They look OK to me.
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
> ioctls, 2 new data structures, and 4 new enumerations.  I think that
> this small implementation was excellent for presenting the concept and
> communicating the ideas.
>
> I'm not so sure it the best final form for such an interface.  Possible
> drawbacks are:
>
> a. Meta-data information is combined, creating larger enumerations
> (case:s in a switch() statement) that applications have to deal with.
> Signedness is combined with Width; that's not so bad.  Units is combined
> with Exponent, making 'enum fecap_errors' rather large.  This is likely
> fixable with modification to the presented implementation.
>
> b. A new type of measurment in a new hardware device means a change in
> the message structure.  In the presented implementation, I'm not sure
> there's a good way to fix this.  (I'm not sure how much of a drawback
> this is in reality, my crystal ball is broken...)
>
> c. It makes 3 allocations from the space of possible ioctl values.  I am
> under the impression using new ioctls is to be avoided.  I don't know if
> that impression is justified.  For perspective, currently about 93 of
> the 256 type 'o' ioctl numbers are in use by dvb and 73 of the 256 type
> 'V' ioctl numbers are in use by v4l.
>
>
>
> As an alternative form for the interface between the kernel and
> userspace, I can suggest
>
> a. using the FE_GET_PROPERTY ioctl
>
> b. new defines to use for getting the measurment values and metadata
> with FE_GET_PROPERTY.  For example, for the quality measurment and
> meta-data:
>
> #define DTV_QUALITY_SIGNEDNESS 41
> #define DTV_QUALITY_WIDTH 42 (or DTV_QUALITY_SIGN_WIDTH with values like -32 meaning 32 bit signed)
> #define DTV_QUALITY_UNIT 43
> #define DTV_QUALITY_EXPONENT 44
> #define DTV_QUALITY_TOP_OF_SCALE 45
> #define DTV_QUALITY_BOTTOM_OF_SCALE 46
>
> #define DTV_QUALITY 47
>
>
> c. Variaitons of the enums Manu presented for the meta-data.  For
> example for quality:
>
> enum fe_quality_unit {
>        FE_QUALITY_UNKOWN
>        FE_QUALITY_SNR_dB,
>        FE_QUALITY_CNR_dB,
>        FE_QUALITY_EsNo,
>        FE_QUALITY_EbNo,
>        FE_QUALITY_RELATIVE,
> };
>
> Exponent is now separated out and sent as a signed integer value.
> FE_QUALITY_UNKOWN isn't really needed (I think) as the "result" value in
> the returned struct dtv_property can be set to -1 to indicate not
> available.
>
>
> I have *not* done an impact assessment on kernel internal interface
> changes for the implementation form Manu presented, nor for the form I
> have suggested here.  I'll leave that work to the guy who's thinking of
> implementing something - *cough* Devin *cough*. :)
>
> Regards,
> Andy

Wow, well this literally kept me up all night pondering the various options.

Manu's idea has alot of merit - providing a completely new API that
provides the "raw data without translation" as well as a way to query
for what that format is for the raw data, provides a great deal more
flexibility for applications that want to perform advanced analysis
and interpretation of the data.

That said, the solution takes the approach of "revolutionary" as
opposed to "evolutionary", which always worries me.  While providing a
much more powerful interface, it also means all of the applications
will have to properly support all of the various possible
representations of the data, increasing the responsibility in userland
considerably.

Let me ask this rhetorical question: if we did nothing more than just
normalize the SNR to provide a consistent value in dB, and did nothing
more than normalize the existing strength field to be 0-100%, leaving
it up to the driver author to decide the actual heuristic, what
percentage of user's needs would be fulfilled?

I bet the answer would be something like 99%.

I can see the value in an "advanced API" that could provide the
underlying raw data, but I feel like this could be provided in the
future at any point that someone cares enough to do the work.

We can spend weeks debating and trying to design the "perfect
interface" (and possibly never come to an agreement as has gone on for
years), or we can just make a decision on how to represent the two
values that is "good enough", and we can have 99% of the population
satisfied virtually overnight (with the ability to provide an advanced
API to get the raw data in the future if there is ever sufficient
need).

I'm willing to submit the patches for all the ATSC demods to conform
to the final API if the experts can just decide on what the format
should be.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
