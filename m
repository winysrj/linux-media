Return-path: <mchehab@gaivota>
Received: from saarni.dnainternet.net ([83.102.40.136]:42537 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab1ELAR3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 20:17:29 -0400
Message-ID: <4DCB2711.5050406@iki.fi>
Date: Thu, 12 May 2011 03:17:21 +0300
From: Anssi Hannula <anssi.hannula@iki.fi>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Peter Hutterer <peter.hutterer@who-t.net>,
	linux-media@vger.kernel.org,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	xorg-devel@lists.freedesktop.org
Subject: Re: IR remote control autorepeat / evdev
References: <4DC61E28.4090301@iki.fi> <20110510041107.GA32552@barra.redhat.com> <4DC8C9B6.5000501@iki.fi> <20110510053038.GA5808@barra.redhat.com> <4DC940E5.2070902@iki.fi> <4DCA1496.20304@redhat.com> <4DCABA42.30505@iki.fi> <4DCABEAE.4080607@redhat.com> <4DCACE74.6050601@iki.fi> <20110511205332.GA11123@core.coreip.homeip.net>
In-Reply-To: <20110511205332.GA11123@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 11.05.2011 23:53, Dmitry Torokhov wrote:
> On Wed, May 11, 2011 at 08:59:16PM +0300, Anssi Hannula wrote:
>>
>> I meant replacing the softrepeat with native repeat for such devices
>> that have native repeats but no native release events:
>>
>> - keypress from device => keydown + keyup
>> - repeat from device => keydown + keyup
>> - repeat from device => keydown + keyup
>>
>> This is what e.g. ati_remote driver now does.
>>
>> Or alternatively
>>
>> - keypress from device => keydown
>> - repeat from device => repeat
>> - repeat from device => repeat
>> - nothing for 250ms => keyup
>> (doing it this way requires some extra handling in X server to stop its
>> softrepeat from triggering, though, as previously noted)
>>
>> With either of these, if one holds down volumeup, the repeat works, and
>> stops volumeup'ing immediately when user releases the button (as it is
>> supposed to).
>>
> 
> Unfortunately this does not work for devices that do not have hardware
> autorepeat

Devices that have no hardware autorepeat have hardware release events,
no? I'm only suggesting to do this for devices with hardware autorepeat.

If there are no hw repeat events and no hw release events, obviously
making repeat work at all is impossible.

> and also stops users from adjusting autorepeat parameters to
> their liking.

True. However, I don't think adjustable autorepeat parameters are much
of use for the users if the autorepeat itself is unusable (due to ghost
repeats).

> It appears that the delay to check whether the key has been released is
> too long (almost order of magnitude longer than our typical autorepeat
> period). I think we should increase the period for remotes (both in
> kernel and in X, and also see if the release check delay can be made
> shorter, like 50-100 ms.

To make the ghost repeat issue disappear, one would have to use a
release timeout of just over the native repeat rate of the remote, and a
softrepeat period of just over the release timeout, right?

This will make the repeat rate slower than the native repeats. I'm not
100% sure if that is an issue, but I'd guess there might be some devices
that already have a slowish repeat rate, where we wouldn't want to add
such additional delay.

(plus there is the issue of having to fiddle the rates for every
device/protocol)

-- 
Anssi Hannula
