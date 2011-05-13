Return-path: <mchehab@gaivota>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:56278 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758159Ab1EMXIF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 19:08:05 -0400
Message-ID: <4DCDB9CB.7030306@iki.fi>
Date: Sat, 14 May 2011 02:07:55 +0300
From: Anssi Hannula <anssi.hannula@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Peter Hutterer <peter.hutterer@who-t.net>,
	linux-media@vger.kernel.org,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	xorg-devel@lists.freedesktop.org
Subject: Re: IR remote control autorepeat / evdev
References: <4DC61E28.4090301@iki.fi> <20110510041107.GA32552@barra.redhat.com> <4DC8C9B6.5000501@iki.fi> <20110510053038.GA5808@barra.redhat.com> <4DC940E5.2070902@iki.fi> <4DCA1496.20304@redhat.com> <4DCABA42.30505@iki.fi> <4DCABEAE.4080607@redhat.com> <4DCACE74.6050601@iki.fi> <4DCB213A.8040306@redhat.com> <4DCB2BD9.6090105@iki.fi> <4DCB336B.2090303@redhat.com> <4DCB39AF.2000807@redhat.com> <4DCC71B5.8080306@iki.fi> <4DCDB333.8000801@redhat.com>
In-Reply-To: <4DCDB333.8000801@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 14.05.2011 01:39, Mauro Carvalho Chehab wrote:
> Em 13-05-2011 01:48, Anssi Hannula escreveu:
>> On 12.05.2011 04:36, Mauro Carvalho Chehab wrote:
>>> Em 12-05-2011 03:10, Mauro Carvalho Chehab escreveu:
>>>> Em 12-05-2011 02:37, Anssi Hannula escreveu:
>>>
>>>>> I don't see any other places:
>>>>> $ git grep 'REP_PERIOD' .
>>>>> dvb/dvb-usb/dvb-usb-remote.c:   input_dev->rep[REP_PERIOD] =
>>>>> d->props.rc.legacy.rc_interval;
>>>>
>>>> Indeed, the REP_PERIOD is not adjusted on other drivers. I agree that we
>>>> should change it to something like 125ms, for example, as 33ms is too 
>>>> short, as it takes up to 114ms for a repeat event to arrive.
>>>>
>>> IMO, the enclosed patch should do a better job with repeat events, without
>>> needing to change rc-core/input/event logic.
>>
>> It will indeed reduce the amount of ghost events so it brings us in the
>> right direction.
>>
>> I'd still like to get rid of the ghost repeats entirely, or at least
>> some way for users to do it if we don't do it by default.
> 
>> Maybe we could replace the kernel softrepeat with native repeats (for
>> those protocols/drivers that have them), while making sure that repeat
>> events before REP_DELAY are ignored and repeat events less than
>> REP_PERIOD since the previous event are ignored, so the users can still
>> configure them as they like? 
>>
> 
> This doesn't seem to be the right thing to do. If the kernel will
> accept 33 ms as the value or REP_PERIOD, but it will internally 
> set the maximum repeat rate is 115 ms (no matter what logic it would
> use for that), Kernel (or X) shouldn't allow the user to set a smaller value. 
> 
> The thing is that writing a logic to block a small value is not easy, since 
> the max value is protocol-dependent (worse than that, on some cases, it is 
> device-specific). It seems better to add a warning at the userspace tools 
> that delays lower than 115 ms can produce ghost events on IR's.

>From what I see, even periods longer than 115 ms can produce ghost events.

For example with your patch softrepeat period is 125ms, release timeout
250ms, and a native rate of 110ms:

There are 4 native events transmitted at
000 ms
110 ms
220 ms
330 ms
(user stops between 330ms and 440ms)

This causes these events in the evdev interface:
000: 1
125: 2
250: 2
375: 2
500: 2
550: 0

So we got 1-2 ghost repeat events.

>> Or maybe just a module option that causes rc-core to use native repeat
>> events, for those of us that want accurate repeat events without ghosting?
> 
> If the user already knows about the possibility to generate ghost effects,
> with low delays, he can simply not pass a bad value to the kernel, instead 
> of forcing a modprobe parameter that will limit the minimal value.

There is no "good value" for REP_PERIOD (as in ghost repeats guaranteed
gone like with native repeats). Sufficiently large values will make
ghost repeats increasingly rare, but the period becomes so long the
autorepeat becomes frustratingly slow to use.

-- 
Anssi Hannula
