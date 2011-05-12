Return-path: <mchehab@gaivota>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:37584 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755389Ab1ELAhx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 20:37:53 -0400
Message-ID: <4DCB2BD9.6090105@iki.fi>
Date: Thu, 12 May 2011 03:37:45 +0300
From: Anssi Hannula <anssi.hannula@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Peter Hutterer <peter.hutterer@who-t.net>,
	linux-media@vger.kernel.org,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	xorg-devel@lists.freedesktop.org
Subject: Re: IR remote control autorepeat / evdev
References: <4DC61E28.4090301@iki.fi> <20110510041107.GA32552@barra.redhat.com> <4DC8C9B6.5000501@iki.fi> <20110510053038.GA5808@barra.redhat.com> <4DC940E5.2070902@iki.fi> <4DCA1496.20304@redhat.com> <4DCABA42.30505@iki.fi> <4DCABEAE.4080607@redhat.com> <4DCACE74.6050601@iki.fi> <4DCB213A.8040306@redhat.com>
In-Reply-To: <4DCB213A.8040306@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 12.05.2011 02:52, Mauro Carvalho Chehab wrote:
> Em 11-05-2011 19:59, Anssi Hannula escreveu:
>>> No. It actually depends on what driver you're using. For example, for most dvb-usb
>>> devices, this is given by the logic bellow:
>>>
>>> 	if (d->props.rc.legacy.rc_interval < 40)
>>> 		d->props.rc.legacy.rc_interval = 100; /* default */
>>>
>>> 	input_dev->rep[REP_PERIOD] = d->props.rc.legacy.rc_interval;
>>> 	input_dev->rep[REP_DELAY]  = d->props.rc.legacy.rc_interval + 150;
>>>
>>> where the rc_interval defined by device entry at the dvb usb drivers.
>>
>> Isn't that function only called for DVB_RC_LEGACY mode?
> 
> I just picked one random piece of the code that covers several RC remotes (most
> dvb-usb drivers are still using the legacy mode). Similar code are there for
> other devices.

I don't see any other places:
$ git grep 'REP_PERIOD' .
dvb/dvb-usb/dvb-usb-remote.c:   input_dev->rep[REP_PERIOD] =
d->props.rc.legacy.rc_interval;

>> Maybe I wasn't clear, but I'm talking only about the devices handled by
>> rc-core.
> 
> With just a few exceptions, the repeat period/delay that were there before
> porting to rc-core were maintained. There are space for adjustments, as we
> did on a few cases.

The above is the only place where the repeat period is set in the
drivers/media tree, and it is not an rc-core device. Other devices
therefore use the 33ms kernel default.

Maybe I am missing something?

> Em 11-05-2011 22:53, Dmitry Torokhov escreveu:
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
>> autorepeat and also stops users from adjusting autorepeat parameters to
>> their liking.
> 
> Yes. A solution like the above would limit the usage. There are some remotes
> (like for example, the Hauppauge Grey remotes I have here) that a simple
> keypress generates, in general, up to 3 scancodes (the normal keypress and
> up to two "bounced" repeat keycodes). So, the software key delay also serves
> as a way to de-bounce the keypress.

I probably forgot to mention it, but I'm not suggesting removal of the
repetition delay (500ms), it can stay for this reason exactly.

>> It appears that the delay to check whether the key has been released is
>> too long (almost order of magnitude longer than our typical autorepeat
>> period).
> 
> Yes, because, for example, with NEC and RC-5 protocols, one keystroke or one
> repeat event takes 110/114 ms to be transmitted. The delay actually varies 
> from protocol to protocol, so it is possible to do some adjustments, based on
> the protocol type, but it is an order of magnitude longer than a keyboard or
> mouse.
> 
>> I think we should increase the period for remotes (both in
>> kernel and in X, and also see if the release check delay can be made
>> shorter, like 50-100 ms.
> 
> Some adjustments like that can be made, but they are device-driver specific.
> 
> For example, some in-hardware IR decoders with KS007 micro-controller just
> removes all repeat keycodes and replace them with new keystrokes. There are
> some shipped remotes that don't support the RC-5 or NEC key repeat event. So,
> on those, if you keep a key pressed, you just receive the same scancode several
> times.
> 
> The last time I double checked all remotes I have here, on all cases the auto-repeat
> logic were doing the right job, but I won't doubt that we need to add some additional
> adjustments for some boards/devices.

Does "doing the right job" mean that you are getting zero repeat (2)
events after releasing a remote button?

Because that is what I expect to happen, and that is what e.g. LIRC
(which most people seem to still use with HTPC software - like XBMC
which I'm a developer of) does.

> Anssi, what's the hardware that you're using?

I'm using ati_remote ported to rc-core (don't know yet if it makes any
sense, though).

However, as noted, reading ir-main.c I fail to see why this wouldn't
happen with all rc-core devices, as all devices seem to use same
IR_KEYPRESS_TIMEOUT and REP_PERIOD (though you seem to suggest otherwise
above, maybe you can show me wrong? :) ).

-- 
Anssi Hannula
