Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56346 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab1DKThI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 15:37:08 -0400
Received: by eyx24 with SMTP id 24so1819738eyx.19
        for <linux-media@vger.kernel.org>; Mon, 11 Apr 2011 12:37:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110411192951.GD4324@mgebm.net>
References: <1301922737.5317.7.camel@morgan.silverblock.net>
	<BANLkTikqBPdr2M8jyY1zmu4TPLsXo0y5Xw@mail.gmail.com>
	<BANLkTi=dVYRgUbQ5pRySQLptnzaHOMKTqg@mail.gmail.com>
	<1302015521.4529.17.camel@morgan.silverblock.net>
	<BANLkTimQkDHmDsqSsQ9jiYnHWXnc7umeWw@mail.gmail.com>
	<1302481535.2282.61.camel@localhost>
	<20110411191252.GB4324@mgebm.net>
	<BANLkTi=98Ypy+NJ8KDSPm4K9G+h2OfamAQ@mail.gmail.com>
	<20110411192437.GC4324@mgebm.net>
	<BANLkTimMcYdx562+dMT4hy+qXCwNg1FSyA@mail.gmail.com>
	<20110411192951.GD4324@mgebm.net>
Date: Mon, 11 Apr 2011 15:37:06 -0400
Message-ID: <BANLkTim7ivS9GdafHgogdwbqKz5R2hLgGA@mail.gmail.com>
Subject: Re: HVR-1600 (model 74351 rev F1F5) analog Red Screen
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Apr 11, 2011 at 3:29 PM, Eric B Munson <emunson@mgebm.net> wrote:
> On Mon, 11 Apr 2011, Devin Heitmueller wrote:
>
>> On Mon, Apr 11, 2011 at 3:24 PM, Eric B Munson <emunson@mgebm.net> wrote:
>> > I mean the /usr/bin/scan tool.  Most of the channels seem to be missing the EIT
>> > information and two channels were missing completely.  The two missing channels
>> > could be a result of poor signal quality (the wiring here is not the best but
>> > as it is university housing there isn't much I can do).
>>
>> Wait a second:  you're on ClearQAM, right?  You're lucky if you are
>> receiving any EIT data at all.  Many cable providers strip out the
>> PSIP info on ClearQAM broadcasts, and non-OTA equivalent stations are
>> unlikely to have any PSIP data at all (the ATSC A/65c spec provides
>> the capability, but cable settop boxes typically use an out-of-band
>> tuner instead).
>>
>> Are you comparing the tuning results against some other tuner product?
>>  Or is this based entirely on what you know "should be there" in terms
>> of the scan results?
>>
>
> I just must be lucky for the one channel that gets it.  I am comparing the list
> to what I know should be there, not the output of someother product.

Adding linux-media back onto the cc: as I did not intend to remove it
(and the information could be useful for others participating on the
thread).

Indeed, it's entirely likely that the channels.conf will contain just
a frequency and video/audio pids, while not containing any of the
"identifying information" for the channel such as the callsign.  Also,
you will likely also get encrypted channels in your results, so you
will try to tune, it will lock successfully, but then mplayer won't
show you video on any of the PIDs.

We really should add some additional logic to /usr/bin/scan to filter
out encrypted channels (or at least put something in the name that
makes it clear they aren't going to work).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
