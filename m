Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:44858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab1ELAzS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 20:55:18 -0400
Message-ID: <4DCB2FE7.9010709@redhat.com>
Date: Thu, 12 May 2011 02:55:03 +0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Anssi Hannula <anssi.hannula@iki.fi>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Peter Hutterer <peter.hutterer@who-t.net>,
	linux-media@vger.kernel.org,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	xorg-devel@lists.freedesktop.org
Subject: Re: IR remote control autorepeat / evdev
References: <4DC61E28.4090301@iki.fi> <20110510041107.GA32552@barra.redhat.com> <4DC8C9B6.5000501@iki.fi> <20110510053038.GA5808@barra.redhat.com> <4DC940E5.2070902@iki.fi> <4DCA1496.20304@redhat.com> <4DCABA42.30505@iki.fi> <4DCABEAE.4080607@redhat.com> <4DCACE74.6050601@iki.fi> <20110511205332.GA11123@core.coreip.homeip.net> <4DCB2711.5050406@iki.fi>
In-Reply-To: <4DCB2711.5050406@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 12-05-2011 02:17, Anssi Hannula escreveu:
> On 11.05.2011 23:53, Dmitry Torokhov wrote:
>> On Wed, May 11, 2011 at 08:59:16PM +0300, Anssi Hannula wrote:
>>>
>>> I meant replacing the softrepeat with native repeat for such devices
>>> that have native repeats but no native release events:
>>>
>>> - keypress from device => keydown + keyup
>>> - repeat from device => keydown + keyup
>>> - repeat from device => keydown + keyup
>>>
>>> This is what e.g. ati_remote driver now does.
>>>
>>> Or alternatively
>>>
>>> - keypress from device => keydown
>>> - repeat from device => repeat
>>> - repeat from device => repeat
>>> - nothing for 250ms => keyup
>>> (doing it this way requires some extra handling in X server to stop its
>>> softrepeat from triggering, though, as previously noted)
>>>
>>> With either of these, if one holds down volumeup, the repeat works, and
>>> stops volumeup'ing immediately when user releases the button (as it is
>>> supposed to).
>>>
>>
>> Unfortunately this does not work for devices that do not have hardware
>> autorepeat
> 
> Devices that have no hardware autorepeat have hardware release events,
> no? I'm only suggesting to do this for devices with hardware autorepeat.

What I meant to say is that some devices produce:
	<KEY><KEY><KEY>...<KEY>
instead of:
	<KEY><REP><REP>...<REP>

In other words, there's not a solution that fits all. Adjustments need to be
done per device, and not as a change at the core.

> If there are no hw repeat events and no hw release events, obviously
> making repeat work at all is impossible.
> 
>> and also stops users from adjusting autorepeat parameters to
>> their liking.
> 
> True. However, I don't think adjustable autorepeat parameters are much
> of use for the users if the autorepeat itself is unusable (due to ghost
> repeats).
> 
>> It appears that the delay to check whether the key has been released is
>> too long (almost order of magnitude longer than our typical autorepeat
>> period). I think we should increase the period for remotes (both in
>> kernel and in X, and also see if the release check delay can be made
>> shorter, like 50-100 ms.
> 
> To make the ghost repeat issue disappear, one would have to use a
> release timeout of just over the native repeat rate of the remote, and a
> softrepeat period of just over the release timeout, right?

There's no known "ghost repeat" issue at rc-core. If you're seeing an issue, 
it is probably device-specific, and should be handle are such. Don't blame
the core [1].

On what device(s) are you noticing such ghost repeat, and with what
protocols? please provide the rc-core and driver-specific debug information
and let's work to fix on the case you've detected.

[1] I'm referring to the way input/event is providing the events. If Xorg is
discarding the in-kernel repeat logic and using its own logic, then we may
have ghost events there, as RC timings are different than keyboards. So a
250/33 would produce a crappy result with RC's.

> This will make the repeat rate slower than the native repeats. I'm not
> 100% sure if that is an issue, but I'd guess there might be some devices
> that already have a slowish repeat rate, where we wouldn't want to add
> such additional delay.

If we use the native repeat, we would have one keystroke on every 110ms, and
the initial delay would be also 110ms. On my experiences, while repeating
keys close to 110ms is generally ok, 110ms is too short for the initial events,
especially due to the debouncing. Depending on the RC device, as I said before,
a normal keypress in general produces more than just one event, due to debounce
issues.

In other words, It really doesn't makes sense to wait for 250ms at a keyboard to
start repeat, and to wait for just 110ms to start repeat at IR. The rc-core logic
does the right thing here:
	- a keystroke generates a key down and starts a timer;
	- a repeat event (or the same keypress) resets the timer;
	- at timer's timeout, it produces a keyup.

This way, the input-event knows when the key was pressed and when the key were
released, and can produce repeat events at the right way, provided that
the timer periods are compatible with the timings generated by the IR protocol.

So, all that it is needed is to adjust the two EV_REP timings (delay and period)
and the rc-core timer's timeout to remove the ghost effects.

It is possible to control two of the 2 EV_REP timers via userspace. 

For now, we're using just one timer for the rc-core logic (IR_KEYPRESS_TIMEOUT, 
currently hardcoded as 250 ms). Such value is a little bigger than 2 x 114 ms,
to avoid bouncing effects with RC-5 REPEAT events. Values smaller than 230 ms
produced ghost keystrokes on some tests I did at the time such logic were added.

> 
> (plus there is the issue of having to fiddle the rates for every
> device/protocol)
> 

