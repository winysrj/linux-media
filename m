Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:55845 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858AbZCYWCj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 18:02:39 -0400
Message-ID: <49CAA9EC.8000904@gmail.com>
Date: Thu, 26 Mar 2009 02:02:20 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
CC: Mika Laitio <lamikr@pilppa.org>, Andy Walls <awalls@radix.net>,
	linux-media@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
 	and BER from HVR 4000 Lite
References: <49B9BC93.8060906@nav6.org>	 <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>	 <49C2D4DB.6060509@gmail.com> <49C33DE7.1050906@gmail.com>	 <1237689919.3298.179.camel@palomino.walls.org>	 <412bdbff0903221800j2f9e1137u7776191e2e75d9d2@mail.gmail.com>	 <412bdbff0903241439u472be49mbc2588abfc1d675d@mail.gmail.com>	 <49C96A37.4020905@gmail.com>	 <Pine.LNX.4.64.0903250128110.11676@shogun.pilppa.org>	 <49C970C9.20407@gmail.com> <412bdbff0903250738l23a3b04fpdebbad502897bf57@mail.gmail.com>
In-Reply-To: <412bdbff0903250738l23a3b04fpdebbad502897bf57@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Tue, Mar 24, 2009 at 7:46 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
>> Mika Laitio wrote:
>>>>>> That said, the solution takes the approach of "revolutionary" as
>>>>>> opposed to "evolutionary", which always worries me.  While providing a
>>>>>> much more powerful interface, it also means all of the applications
>>>>>> will have to properly support all of the various possible
>>>>>> representations of the data, increasing the responsibility in userland
>>>>>> considerably.
>>>> Not necessarily, the application can simply chose to support what
>>>> the driver provides as is, thereby doing no translations at all.
>>>> From the end user point of view it is not very usefull if he has 2
>>> different cards and application can not show any usefull signal goodness
>>> info in a way that would be easy to compare. So I think the attempt to
>>> standardize to db is good.
>> The first part: For comparison having a standardized value is good.
>>
>> True.
>>
>> But the problem that surrounds it:
>>
>> To do this, a driver should support statistics in dB. For a device
>> which doesn't show statistics in dB, for reasons
>> (a) device uses a different format
>>
>> (b) enough information is not available to do a conversion
>>    (too less information, or a reverse engineered driver)
>>
>> (c) the conversion to be done makes things too complex in kernel land.
>>
>> So you have very less devices to do a comparison between.
>>
>> The other way to do this:
>>
>> Suppose, the driver that doesn't support a dB format (relative
>> doesn't mean unknown) provides the information in a relative format.
>> And the driver that provides the information in dB format, but that
>> information you get, can be converted in to a relative floor -
>> ceiling format (conversion handled by application, or by a library)
>>
>> This is a quick way.
>>
>> Now, which all devices do provide a scale in dB, which is really
>> comparable ? There are many different parameters, quickly hacked
>> together to be called SNR. In the terms you mention, you will be
>> comparing things like
>>
>> SNR to CNR etc based on the device type.
>>
>> So eventually your comparison is wrong.
>>
>>
>>> Maybe there could then in addition be some other optional method for
>>> also getting data in some hw specific format in a way that Manu suggested.
>>> But there should anyway be mandatory to have this one "standard goodness
>>> value" in a way that does not require apps to make any complicate
>>> comparisons... (I bet half of those apps would be broken for years)
>>
>> In the way i mentioned, it leaves to the application to choose from
>> different styles such as
>>
>> (1) display parameters from the drivers, in their own native format
>> (This is a completely human readable format, in which you can see
>> the real scales)
>>
>> (2) convert parameters to a specific format.
>> (The very important part here is that the application is free to
>> convert from format A with driver X and  format B with driver Y, to
>> get it into a unified format. if you really need the feature what
>> you mentioned, you need this feature, rather than have all drivers
>> being modified to provide one standard format)
>>
>> To make things look simple, i have a sample application which does
>> (1) to make things look simple.
>>
>> If you choose to do (2) It will be just doing the conversion one
>> time in a library or application, once rather than doing it multiple
>> times in unknown ways and formats.
> 
> Hello Manu,
> 


Hi Devin,

> First off, a large part of your argument lies in the notion that many
> of the devices do not support representing the SNR in dB.


My comment has some few points, of which the dB scale thing is just
one among them. It could be a major aspect, depending on how you
perceive it.

> However,
> when I sent around the list in an attempt to do an inventory of what
> formats were used by different demods, you didn't provide any actual
> information.


Being on the lists for quite a while and following the developments
with some amount of information, i was under the belief that it
would have been obvious and did not give much importance to the same.

> Could you please look at the following list, and if you
> know of how "unknown" demods do their SNR, provide the information?
> 
> http://www.devinheitmueller.com/snr.txt


Sure, of course. Here is an updated list based on the information
that you accumulated. I have corrected some of them, which were not
accurate.


af9013.c	0.1 dB
at76c651.c      unknown
au8522.c        0.1 dB
bcm3510.c       unknown (vals > 1000)
cinergyT2.c	dB * 256
cx22700.c       unknown
cx22702.c       unknown
cx24110.c       ESN0
cx24116.c       percent scaled to 0-0xffff, support for ESN0
cx24123.c       Inverted ESN0
dib3000mb.c     unknown
dib3000mc.c     always zero (0.1dB possible [pboettch])
dib7000m.c      always zero (0.1dB possible [pboettch])
dib7000p.c      always zero (0.1dB possible [pboettch])
drx397xD.c      always zero
dst(s/c/t)	(Inverted relative, if scaled confirms to API)
dvb_dummy_fe.c  always zero
l64781.c        (Relative, confirms to API)
lgdt330x.c      dB * 256
lgdt3304.c	always zero
lgdt3305.c      0.1 dB
lgs8gl5.c       unknown
mt312.c         (Relative, confirms to API3.3)
mt352.c         (Relative, confirms to API) (0.1dB possible in hardware)
nxt200x.c       approximated to dB (uC provides some 4 - 5 steps)
nxt6000.c       unknown
or51132.c       dB * 256
or51211.c       dB * 256
s5h1409.c	0.1 dB
s5h1411.c       0.1 dB
s5h1420.c       unsupported
si21xx.c        CNR Relative (scaled to 0-0xffff)
sp8870.c        unsupported
sp887x.c        unknown
stv0299		(Relative, confirms to API)
stv0288.c       (Relative, confirms to API)
stv0297.c       (Relative, confirms to API, floor/ceiling undefined)
stv0299.c       unknown
tda10021.c      (Relative, confirms to API)
tda10023.c      (Relative, confirms to API)
tda10048.c      0.1 dB
tda1004x.c      (Relative, confirms to API)
tda10086.c      (Relative, confirms to API)
tda8083.c       (Relative, confirms to API, floor ceiling undefined)
tda80xx.c       unknown
ves1820.c       unknown
ves1x93.c       unknown
zl10353.c       (Relative, confirms to API) (0.1dB possible in hardware)
stb0899_drv.c	CNR, Es/No
mb86a16		CNR (approximated)


> My argument for doing it in dB was based on the inventory suggesting
> that the vast majority of *known* devices do it that way.  If this is
> incorrect, then how about providing some actual data so we have better
> decision making?


Sure.


> I do agree that people should not be putting CNR data into the SNR
> field.  If there are known cases where that happens, they should be
> removed.

Hmm.. (scratching head and pulls out a few hairs)...


> The CNR can be used to represent the "strength" field, but
> it is not the same as the SNR and shouldn't be treated as such.


A bit of signal theory, here:

The Carrier in this case is the modulated signal. In some cases it
can be an IQ modulated signal, or in another case it could be a QPSK
demodulation.


Eventually, Carrier is "the Signal", at a certain stage in the whole
pipeline.

In fact, CNR (aka Carrier to Noise Ratio) is very similar to SNR
(Signal to Noise Ratio) except that CNR is obtained just before
demodulation stage and that is the only one difference between them.

Both are Signal ratios with respect to Noise, SNR is proportional
and smaller compared to CNR for the same reasons, that the "actual
Signal" might be much "smaller" in comparison to the carrier, which
is used for modulation.

In such a case you can't use CNR to represent strength, but in fact
can be used to used to represent SNR in some proportional way.

http://en.wikipedia.org/wiki/Signal-to-noise_ratio
http://en.wikipedia.org/wiki/Carrier_to_Noise_Ratio


> Also,
> things like putting AGC feedback in that field should be removed as
> well (or moved to the strength field).
> 
> I haven't raised this argument yet, but I also believe that once we
> make this change, all the cases where the format for the SNR is
> "unknown" should be "#ifdef 0" and return ENOSYS.  If nobody can tell
> us what the format is, it's better to return nothing at all then
> mislead users with garbage data.


Though it looks like a purist's approach, this would just remove
whatever feature that a driver is having currently. If you can't add
features into a driver, it's not a big deal. But it is not really a
cool thing to remove a feature which is even partially working to
some extent: a way in which it is documented a considered working to
many users. Just telling users that what statistics what they have
been seeing are going to be removed, just because it is not a dB
scale might not sound really attractive or useful.


In fact most of the drivers use that parameter scaled to what the
API currently state. Some recent drivers have been using different
formats than what the API described and hence the whole confusion.

As i mentioned earlier, the API doesn't export units for these
parameters for teh same mentioned reasons, that there are much
different units and things to be considered which would make things
too complex for a driver author and hence it has such a definition.

Regards,
Manu

