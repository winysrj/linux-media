Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:63333 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2L2QgR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 11:36:17 -0500
Received: by mail-qa0-f47.google.com with SMTP id a19so9913576qad.6
        for <linux-media@vger.kernel.org>; Sat, 29 Dec 2012 08:36:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1356739006-22111-1-git-send-email-mchehab@redhat.com>
References: <1356739006-22111-1-git-send-email-mchehab@redhat.com>
Date: Sat, 29 Dec 2012 11:36:16 -0500
Message-ID: <CAGoCfix=2-pXmTE149XvwT+f7j1F29L3Q-dse0y_Rc-3LKucsQ@mail.gmail.com>
Subject: Re: [PATCH RFCv3] dvb: Add DVBv5 properties for quality parameters
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 28, 2012 at 6:56 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> The DVBv3 quality parameters are limited on several ways:
>         - Doesn't provide any way to indicate the used measure;
>         - Userspace need to guess how to calculate the measure;
>         - Only a limited set of stats are supported;
>         - Doesn't provide QoS measure for the OFDM TPS/TMCC
>           carriers, used to detect the network parameters for
>           DVB-T/ISDB-T;
>         - Can't be called in a way to require them to be filled
>           all at once (atomic reads from the hardware), with may
>           cause troubles on interpreting them on userspace;
>         - On some OFDM delivery systems, the carriers can be
>           independently modulated, having different properties.
>           Currently, there's no way to report per-layer stats;
> This RFC adds the header definitions meant to solve that issues.
> After discussed, I'll write a patch for the DocBook and add support
> for it on some demods. Support for dvbv5-zap and dvbv5-scan tools
> will also have support for those features.

Hi Mauro,

As I've told you multiple times in the past, where this proposal falls
apart is in its complete lack of specificity for real world scenarios.

You have a units field which is "decibels", but in what unit?  1 dB /
unit?  0.1 db / unit?  1/255 db / unit?  This particular issue is why
the current snr field varies across even demods where we have the
datasheets.  Many demods reported in 0.1 dB increments, while others
reported in 1/255 dB increments.

What happens when you ask for the SNR field when there is so signal
lock (on most demods the SNR registers return garbage in this case)?
What is the return value to userland?  What happens when the data is
unavailable for some other reason?  What happens when you have group
of statistics being asked for in a single call and *one* of them
cannot be provided for some reason (in which case you cannot rely on a
simple errno value since it doesn't apply to the entire call)?

You need to take a step back and think about this from an application
implementors standpoint.  Most app developers for the existing apps
look to show two data points:  a signal indicator (0-100%), and some
form of SNR (usually in dB, plotted on a scale where something like 40
dB=100% [of course this max varies by modulation type]).  What would I
need to do with the data you've provided to show that info?  Do I
really need to be a background in signal theory and understand the
difference between SNR and CNR in order to tell the user how good his
signal is?

Since as an app developer I typically only have one or two tuners, how
the hell am I supposed to write a piece of code that shows those two
pieces of information given the huge number of different combinations
of data types that demods could return given the proposed API?

We have similar issues for UNC/BER values.  Is the value returned the
number of errors since the last time the application asked?  Is it the
number of errors in the last two seconds?  Is it the number of errors
since I reached signal lock?  Does asking for the value clear out the
counter?  How do we handle the case where I asked for the data for the
first time ten minutes after I reached signal lock?  Are drivers
internally supposed to be polling the register and updating the
counters even when the application doesn't ask for the data (to handle
cases where the demod's registers only have an error count for the
last second's worth of data)?

And where the examples that show "typical values" for the different
modulation types?  For example, I'm no expert in DVB-C but I'm trying
to write an app which can be used by those users.  What range of
values will the API typically return for that modulation type?  What
values are "good" values, which represent "excellent" signal
conditions, and what values suggest that the signal will probably be
failing?

What happens when a driver doesn't support a particular statistic?
Right now some drivers return -EINVAL, others just set the field to
zero or 0x1fff (in which case the user is mislead to believe that
there is no signal lock *all* the time).

EXAMPLES EXAMPLES EXAMPLES.  This is the whole reason that the API
behaves inconsistently today - somebody who did one of the early
demods returned in 1/255 dB format, and then some other developer who
didn't have the first piece of hardware wrote a driver and because
he/she didn't *know* what the field was supposed to contain (and
couldn't try it his/herself), that developer wrote a driver which
returned in 0.1 dB format.

This needs to be defined *in the spec*, or else we'll end up with
developers (both app developers and kernel develoeprs implementing new
demods) guessing how the API should behave based on whatever hardware
they have, which is how we got in this mess in the first place.

In short, you need to describe typical usage scenarios in terms of
what values the API should be returning for different modulation
types, and you need to describe in detail how the "edge cases" are
handled such as what happens when there is only a partial signal lock
and only some stats will be valid at that point in time.

The approach you've taken is probably a reasonable framework, but in
reality the problems you are trying to solve are the wrong ones.  The
*real* problem isn't that we don't have the ability to show some
obscure statistic for transport layers that nobody actually cares
about.  The real problem is that even for the simplest cases we have
today there is a complete lack of uniformity across demodulators.  If
we did nothing else but fix the drivers so that the existing calls
return the data in a normalized way, we would solve 99% of whatever
everybody has been complaining about for years.

That said, sure let's build a whole new API which deals with the new
functionality you've described - but let's make sure that we don't
repeat the same mistakes and end up with inconsistent data even for
the three or four stats that typical application developers really
care about.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
