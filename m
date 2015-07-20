Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49998 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbbGTR2K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 13:28:10 -0400
Subject: Re: Adding support for three new Hauppauge HVR-1275 variants -
 testers reqd.
To: Steven Toth <stoth@kernellabs.com>
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
 <55AD0617.7060007@iki.fi>
 <CALzAhNVFBgEBJ8448h1WL3iDZ4zkR_k5And0-mtJ6vu97RZLTQ@mail.gmail.com>
 <55AD234E.5010904@iki.fi>
 <CAGoCfiy5Fy26EJzRPYEk_kgH0YESTXiR-E=83Rur6PWZjyi8jQ@mail.gmail.com>
 <55AD27E0.6080102@iki.fi>
 <CALzAhNV6mq6V-jYdjjwrYqtwkKQTgvAFOUhxBvHuAK0jAXZ7gQ@mail.gmail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	tonyc@wincomm.com.tw, Linux-Media <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <55AD2FA5.6000309@iki.fi>
Date: Mon, 20 Jul 2015 20:28:05 +0300
MIME-Version: 1.0
In-Reply-To: <CALzAhNV6mq6V-jYdjjwrYqtwkKQTgvAFOUhxBvHuAK0jAXZ7gQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/20/2015 08:14 PM, Steven Toth wrote:
> On Mon, Jul 20, 2015 at 12:54 PM, Antti Palosaari <crope@iki.fi> wrote:
>> On 07/20/2015 07:45 PM, Devin Heitmueller wrote:
>>>>
>>>> Look at the em28xx driver and you will probably see why it does not work
>>>> as
>>>> expected. For my eyes, according to em28xx driver, it looks like that bus
>>>> control is aimed for bridge driver. You or em28xx is wrong.
>>>
>>>
>>> Neither are wrong.  In some cases the call needs to be intercepted by
>>> the frontend in order to disable its TS output.  In other cases it
>>> needs to be intercepted by the bridge to control a MUX chip which
>>> dictates which demodulator's TS output to route from (typically by
>>> toggling a GPIO).
>>
>>
>> Quickly looking the existing use cases and I found only lgdt3306a demod
>> which uses that callback to control its TS interface. All the rest seems to
>> be somehow more related to bridge driver, mostly changing bridge TS IF or
>> leds etc.
>
> The API is flexible enough to be used by either the bridge
> intercepting the dvb_frontent_open operation, or by allowing the
> demodulator itself to act upon it. The API itself specifically
> describes the "TS BUS CONTROL" access, and whether something upstream
> of the demodulator wants a downstream device attached, or detached
> from the transport electrical interface.
>
> I see little point adding more bridge glue to route each dvb frontend
> into the cx23885-bridge and making a judgement based on the board
> type, when dvb-core is already effectively doing this, and has been
> for sometime. The caveat to this, is if you find a use-case that
> breaks the current driver in the current tip kernel. I currently do
> not see that.
>
>>
>> I don't simply see that correct solution for disabling demod TS IF - there
>> is sleep() for this kind of things - and as I pointed out it does not even
>> work for me em28xx based device because em28xx uses that routine to switch
>> own TS mode.
>
> Asking a demodulator to sleep/wake is absolutely not the same thing as
> asking it to stop/start driving electrical signals on a bus.
>
> We can agree or disagree about whether a part should be tri-stated in
> init/sleep() and under what circumstances, but why bother when someone
> has gone to the trouble of declaring a perfectly good tr-state
> interface in dvb-core, taht automatically asserts and de-asserts any
> dvb_frontend device from the bus, optionally.

Because I simply don't want to any new demod users for that callback 
unless needed for some strange reason. Disabling demod TS IF is also 
power-management issue. I didn't made any measurement how much current 
it will leak if any when left active on sleep, but it could do that.

Also as that callback is almost 100% currently used by bridge drivers, I 
don't want start using it for demods too. As you could see from em28xx 
case there is now situation it will not be called at all.

It was added by you by commit ba7e6f3e3e639de2597afffaae3fda75f6e6082d

V4L/DVB (4665): Add frontend structure callback for bus acquisition.

This patch enables generic bus arbitration callbacks enabling
dvbcore frontend_open and frontend_release to pass 'acquire'
and 'release' hardware messages back into the DVB bridge frameworks.
Frameworks like cx88 can then implement single bus multiple demod
card sharing features, which would prohibit two frontends from 
attempting to use a single transport bus at the same time.


... and commit message says it is aimed for bridge driver.


regards
Antti

-- 
http://palosaari.fi/
