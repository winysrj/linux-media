Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:55840 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab2L2Rt3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 12:49:29 -0500
Received: from dolphin.tvdr.de (dolphin.tvdr.de [192.168.100.2])
	by racoon.tvdr.de (8.14.5/8.14.5) with ESMTP id qBTHnRtq010245
	for <linux-media@vger.kernel.org>; Sat, 29 Dec 2012 18:49:27 +0100
Received: from [192.168.100.11] (falcon.tvdr.de [192.168.100.11])
	by dolphin.tvdr.de (8.14.4/8.14.4) with ESMTP id qBTHnLux012708
	for <linux-media@vger.kernel.org>; Sat, 29 Dec 2012 18:49:22 +0100
Message-ID: <50DF2D21.7010707@tvdr.de>
Date: Sat, 29 Dec 2012 18:49:21 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-media] Re: [PATCH RFCv3] dvb: Add DVBv5 properties for
 quality parameters
References: <1356739006-22111-1-git-send-email-mchehab@redhat.com> <CAGoCfix=2-pXmTE149XvwT+f7j1F29L3Q-dse0y_Rc-3LKucsQ@mail.gmail.com>
In-Reply-To: <CAGoCfix=2-pXmTE149XvwT+f7j1F29L3Q-dse0y_Rc-3LKucsQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29.12.2012 17:36, Devin Heitmueller wrote:
> On Fri, Dec 28, 2012 at 6:56 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> The DVBv3 quality parameters are limited on several ways:
>>          - Doesn't provide any way to indicate the used measure;
>>          - Userspace need to guess how to calculate the measure;
>>          - Only a limited set of stats are supported;
>>          - Doesn't provide QoS measure for the OFDM TPS/TMCC
>>            carriers, used to detect the network parameters for
>>            DVB-T/ISDB-T;
>>          - Can't be called in a way to require them to be filled
>>            all at once (atomic reads from the hardware), with may
>>            cause troubles on interpreting them on userspace;
>>          - On some OFDM delivery systems, the carriers can be
>>            independently modulated, having different properties.
>>            Currently, there's no way to report per-layer stats;
>> This RFC adds the header definitions meant to solve that issues.
>> After discussed, I'll write a patch for the DocBook and add support
>> for it on some demods. Support for dvbv5-zap and dvbv5-scan tools
>> will also have support for those features.
>
> Hi Mauro,
>
> As I've told you multiple times in the past, where this proposal falls
> apart is in its complete lack of specificity for real world scenarios.
>
> You have a units field which is "decibels", but in what unit?  1 dB /
> unit?  0.1 db / unit?  1/255 db / unit?  This particular issue is why
> the current snr field varies across even demods where we have the
> datasheets.  Many demods reported in 0.1 dB increments, while others
> reported in 1/255 dB increments.
>
> What happens when you ask for the SNR field when there is so signal
> lock (on most demods the SNR registers return garbage in this case)?
> What is the return value to userland?  What happens when the data is
> unavailable for some other reason?  What happens when you have group
> of statistics being asked for in a single call and *one* of them
> cannot be provided for some reason (in which case you cannot rely on a
> simple errno value since it doesn't apply to the entire call)?
>
> You need to take a step back and think about this from an application
> implementors standpoint.  Most app developers for the existing apps
> look to show two data points:  a signal indicator (0-100%), and some
> form of SNR (usually in dB, plotted on a scale where something like 40
> dB=100% [of course this max varies by modulation type]).  What would I
> need to do with the data you've provided to show that info?  Do I
> really need to be a background in signal theory and understand the
> difference between SNR and CNR in order to tell the user how good his
> signal is?
>
> Since as an app developer I typically only have one or two tuners, how
> the hell am I supposed to write a piece of code that shows those two
> pieces of information given the huge number of different combinations
> of data types that demods could return given the proposed API?
>
> We have similar issues for UNC/BER values.  Is the value returned the
> number of errors since the last time the application asked?  Is it the
> number of errors in the last two seconds?  Is it the number of errors
> since I reached signal lock?  Does asking for the value clear out the
> counter?  How do we handle the case where I asked for the data for the
> first time ten minutes after I reached signal lock?  Are drivers
> internally supposed to be polling the register and updating the
> counters even when the application doesn't ask for the data (to handle
> cases where the demod's registers only have an error count for the
> last second's worth of data)?
>
> And where the examples that show "typical values" for the different
> modulation types?  For example, I'm no expert in DVB-C but I'm trying
> to write an app which can be used by those users.  What range of
> values will the API typically return for that modulation type?  What
> values are "good" values, which represent "excellent" signal
> conditions, and what values suggest that the signal will probably be
> failing?
>
> What happens when a driver doesn't support a particular statistic?
> Right now some drivers return -EINVAL, others just set the field to
> zero or 0x1fff (in which case the user is mislead to believe that
> there is no signal lock *all* the time).
>
> EXAMPLES EXAMPLES EXAMPLES.  This is the whole reason that the API
> behaves inconsistently today - somebody who did one of the early
> demods returned in 1/255 dB format, and then some other developer who
> didn't have the first piece of hardware wrote a driver and because
> he/she didn't *know* what the field was supposed to contain (and
> couldn't try it his/herself), that developer wrote a driver which
> returned in 0.1 dB format.
>
> This needs to be defined *in the spec*, or else we'll end up with
> developers (both app developers and kernel develoeprs implementing new
> demods) guessing how the API should behave based on whatever hardware
> they have, which is how we got in this mess in the first place.
>
> In short, you need to describe typical usage scenarios in terms of
> what values the API should be returning for different modulation
> types, and you need to describe in detail how the "edge cases" are
> handled such as what happens when there is only a partial signal lock
> and only some stats will be valid at that point in time.
>
> The approach you've taken is probably a reasonable framework, but in
> reality the problems you are trying to solve are the wrong ones.  The
> *real* problem isn't that we don't have the ability to show some
> obscure statistic for transport layers that nobody actually cares
> about.  The real problem is that even for the simplest cases we have
> today there is a complete lack of uniformity across demodulators.  If
> we did nothing else but fix the drivers so that the existing calls
> return the data in a normalized way, we would solve 99% of whatever
> everybody has been complaining about for years.
>
> That said, sure let's build a whole new API which deals with the new
> functionality you've described - but let's make sure that we don't
> repeat the same mistakes and end up with inconsistent data even for
> the three or four stats that typical application developers really
> care about.

I wholeheartedly agree!

With the current driver API, VDR implements a GetSignalStrength() function
that basically looks like this:


int cDvbTuner::GetSignalStrength(void) const
{
   uint16_t Signal;
   ioctl(fd_frontend, FE_READ_SIGNAL_STRENGTH, &Signal);
   uint16_t MaxSignal = 0xFFFF; // Let's assume the default is using the entire range.
   // Use the subsystemId to identify individual devices in case they need
   // special treatment to map their Signal value into the range 0...0xFFFF.
   switch (subsystemId) {
     case 0x13C21019: MaxSignal = 670; break; // TT-budget S2-3200 (DVB-S/DVB-S2)
     }
   int s = int(Signal) * 100 / MaxSignal;
   if (s > 100)
      s = 100;
   return s;
}


And the GetSignalQuality() function is even more elaborate:


int cDvbTuner::GetSignalQuality(void) const
{
   fe_status_t Status;
   if (GetFrontendStatus(Status)) {
      // Actually one would expect these checks to be done from FE_HAS_SIGNAL to FE_HAS_LOCK, but some drivers (like the stb0899) are broken, so FE_HAS_LOCK is the only one that (hopefully) is generally reliable...
      if ((Status & FE_HAS_LOCK) == 0) {
         if ((Status & FE_HAS_SIGNAL) == 0)
            return 0;
         if ((Status & FE_HAS_CARRIER) == 0)
            return 1;
         if ((Status & FE_HAS_VITERBI) == 0)
            return 2;
         if ((Status & FE_HAS_SYNC) == 0)
            return 3;
         return 4;
         }
      uint16_t Snr;
      while (1) {
            if (ioctl(fd_frontend, FE_READ_SNR, &Snr) != -1)
               break;
            if (errno == EOPNOTSUPP) {
               Snr = 0xFFFF;
               break;
               }
            if (errno != EINTR)
               return -1;
            }
      uint32_t Ber;
      while (1) {
            if (ioctl(fd_frontend, FE_READ_BER, &Ber) != -1)
               break;
            if (errno == EOPNOTSUPP) {
               Ber = 0;
               break;
               }
            if (errno != EINTR)
               return -1;
            }
      uint32_t Unc;
      while (1) {
            if (ioctl(fd_frontend, FE_READ_UNCORRECTED_BLOCKS, &Unc) != -1)
               break;
            if (errno == EOPNOTSUPP) {
               Unc = 0;
               break;
               }
            if (errno != EINTR)
               return -1;
            }
      uint16_t MaxSnr = 0xFFFF; // Let's assume the default is using the entire range.
      // Use the subsystemId to identify individual devices in case they need
      // special treatment to map their Snr value into the range 0...0xFFFF.
      switch (subsystemId) {
        case 0x13C21019: MaxSnr = 200; break; // TT-budget S2-3200 (DVB-S/DVB-S2)
        }
      int a = int(Snr) * 100 / MaxSnr;
      int b = 100 - (Unc * 10 + (Ber / 256) * 5);
      if (b < 0)
         b = 0;
      int q = LOCK_THRESHOLD + a * b * (100 - LOCK_THRESHOLD) / 100 / 100;
      if (q > 100)
         q = 100;
      return q;
      }
   return -1;
}


As you can see, there is some code for known demods to correctly set their maximum values.
However, I don't have all available demods so I can only test what I have at hand.
And AFAIK this doesn't work with USB devices, because there is no subsystemId for those
(so I'm told).
What I would really wish for is that FE_READ_SIGNAL_STRENGTH (which is already there)
would return a *normalized* value in some defined range (0..100 or 0x0000..0xFFFF),
and that some new FE_READ_SIGNAL_QUALITY would do the same for the signal quality,
internally using whatever parameters are useful for the given demod.
This doesn't have to become a bloated API that is probably only of theoretical
value in the first place. It's these two simple, straighforward functions that are
of practical value. Please make it so the we can finally have a defined interface
for this!

Klaus

