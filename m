Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49229 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1DEQJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 12:09:43 -0400
Received: by bwz15 with SMTP id 15so433418bwz.19
        for <linux-media@vger.kernel.org>; Tue, 05 Apr 2011 09:09:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1302015521.4529.17.camel@morgan.silverblock.net>
References: <BANLkTim2MQcHw+T_2g8wSpGkVnOH_OeXzg@mail.gmail.com>
	<1301922737.5317.7.camel@morgan.silverblock.net>
	<BANLkTikqBPdr2M8jyY1zmu4TPLsXo0y5Xw@mail.gmail.com>
	<BANLkTi=dVYRgUbQ5pRySQLptnzaHOMKTqg@mail.gmail.com>
	<1302015521.4529.17.camel@morgan.silverblock.net>
Date: Tue, 5 Apr 2011 12:09:40 -0400
Message-ID: <BANLkTikeOGqcPOTmdGNcgUnJ0xx8qKSphw@mail.gmail.com>
Subject: Re: HVR-1600 (model 74351 rev F1F5) analog Red Screen
From: Eric B Munson <emunson@mgebm.net>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, mchehab@infradead.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Apr 5, 2011 at 10:58 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Mon, 2011-04-04 at 14:36 -0400, Eric B Munson wrote:
>> On Mon, Apr 4, 2011 at 11:16 AM, Eric B Munson <emunson@mgebm.net> wrote:
>> > On Mon, Apr 4, 2011 at 9:12 AM, Andy Walls <awalls@md.metrocast.net> wrote:
>> >> On Mon, 2011-04-04 at 08:20 -0400, Eric B Munson wrote:
>> >>> I the above mentioned capture card and the digital side of the card
>> >>> works well.  However, when I try to get video from the analog side of
>> >>> the card, all I get is a red screen and no sound regardless of channel
>> >>> requested.  This is a problem I see in 2.6.39-rc1 though I typically
>> >>> run the ubuntu 10.10 kernel with the newest drivers built from source.
>> >>>  Is there something in setup or configuration that I may be missing?
>> >>
>> >> Eric,
>> >>
>> >> You are likely missing the last 3 fixes here:
>> >>
>> >> http://git.linuxtv.org/awalls/media_tree.git?a=shortlog;h=refs/heads/cx18_39
>> >>
>> >> (one of which is critical for analog to work).
>> >>
>> >> Also check the ivtv-users and ivtv-devel list for past discussions on
>> >> the "red screen" showing up for known well supported models and what to
>> >> try.
>> >>
>> > Thanks, I will try hand applying these.
>> >
>>
>> I don't have a red screen anymore, now all get from analog static and
>> mythtv's digital channel scanner now seems broken.
>
> Hmmm.
>
> 1. Please provide the output of dmesg when the cx18 driver loads.
>
> 2. Please provide the output of v4l2-ctl -d /dev/video0 --log status
> when tuned to an analog channel.
>
> 3. Please provide the relevant portion of the mythbackend log where
> where the digital scanner starts and then fails.
>
> 4. Does digital tuning still work in MythTV despite the digital scanner
> not working?
>
> 5. Please don't use MythTV to troubleshoot; it is too complex to
> properly eliminate variables.  Test digital with the dvb utilities
> described here:
>
> http://www.linuxtv.org/wiki/index.php/LinuxTV_dvb-apps
> http://www.linuxtv.org/wiki/index.php/Testing_your_DVB_device
>
> Once I have a channels.conf file made, I usually use azap (ATSC) and
> femon to check that I can tune to a digital channel and get a lock.
> Then I use mplayer to check that the content is viewable.
>
>
> The things that spring to mind that could be wrong:
>
> 1. I didn't check that digital still worked when I added my analog
> changes.  Shame on me, but honestly they *shouldn't* have broken it.
> (Famous last words...)
>
> 2. The tda8290 driver module for the new analog demodulator had an I2C
> address bug introduced recently (hardcoded to the wrong address in
> tda8290 module), but a fix was also applied recently.  You may have the
> bug, but not the fix.
>
> 3. The new HVR-1600 has a worldwide analog tuner that the cx18 driver
> defaults to NTSC-M.  If you use another analog standard, you will need
> to use v4l2-ctl to set the proper standard (PAL-B/G/H/I, SECAM-L/L',
> etc.)
>
>
> (Be advised, I have no time to look at any of this at the moment. The
> soonest would be 11 April.)
>
> Regards,
> Andy
>

No worries on the April 11 date, hard to get upset over the scheduling
of free help :)

I will fetch everything that you requested and make sure to post it
before the 11th.

Thanks for your help.
Eric
