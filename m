Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52995 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab0DOEjC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Apr 2010 00:39:02 -0400
Received: by gyg13 with SMTP id 13so533194gyg.19
        for <linux-media@vger.kernel.org>; Wed, 14 Apr 2010 21:39:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1271303099.7643.7.camel@palomino.walls.org>
References: <4BC5FB77.2020303@vorgon.com>
	 <k2h829197381004141040n4aa69e06x7a10c7ea70be3dcf@mail.gmail.com>
	 <1271303099.7643.7.camel@palomino.walls.org>
Date: Thu, 15 Apr 2010 00:39:01 -0400
Message-ID: <h2h829197381004142139q35705f60q61dd04b05f509af6@mail.gmail.com>
Subject: Re: cx5000 default auto sleep mode
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: "Timothy D. Lenz" <tlenz@vorgon.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 14, 2010 at 11:44 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Wed, 2010-04-14 at 13:40 -0400, Devin Heitmueller wrote:
>> On Wed, Apr 14, 2010 at 1:29 PM, Timothy D. Lenz <tlenz@vorgon.com> wrote:
>> > Thanks to Andy Walls, found out why I kept loosing 1 tuner on a FusionHD7
>> > Dual express. Didn't know linux supported an auto sleep mode on the tuner
>> > chips and that it defaulted to on. Seems like it would be better to default
>> > to off.
>>
>> Regarding the general assertion that the power management should be
>> disabled by default, I disagree.  The power savings is considerable,
>> the time to bring the tuner out of sleep is negligible, and it's
>> generally good policy.
>>
>> Andy, do you have any actual details regarding the nature of the problem?
>
> Not really.  DViCo Fusion dual digital tv card.  One side of the card
> would yield "black video screen" when starting a digital capture
> sometime after (?) the VDR ATSC EPG plugin tried to suck off data.  I'm
> not sure there was a causal relationship.
>
> I hypothesized that one side of the dual-tuner was going stupid or one
> of the two channels used in the cx23885 was getting confused.  I was
> looking at how to narrow the problem down to cx23885 chip or xc5000
> tuner, or s5h14xx demod when I noted the power managment module option
> for the xc5000.  I suggested Tim try it.
>
> It was dumb luck that my guess actually made his symptoms go away.
>
> That's all I know.

We did have a similar issue with the PCTV 800i.  Basically, the GPIO
definition was improperly defined for the xc5000 reset callback.  As a
result, it was strobing the reset on both the xc5000 *and* the
s5h1411, which would then cause the s5h1411's hardware state to not
match the driver state.

After multiple round trips with the hardware engineer at PCTV, I
finally concluded that there actually wasn't a way to strobe the reset
without screwing up the demodulator, which prompted me to disable the
xc5000 reset callback (see cx88-cards:2944).

My guess is that the reset GPIO definition for that board is wrong (a
problem exposed by this change), or that it's resetting the s5h1411 as
well.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
