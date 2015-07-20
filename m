Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:33299 "EHLO
	mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbbGTROC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 13:14:02 -0400
Received: by qkdl129 with SMTP id l129so116308582qkd.0
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2015 10:14:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55AD27E0.6080102@iki.fi>
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
	<55AD0617.7060007@iki.fi>
	<CALzAhNVFBgEBJ8448h1WL3iDZ4zkR_k5And0-mtJ6vu97RZLTQ@mail.gmail.com>
	<55AD234E.5010904@iki.fi>
	<CAGoCfiy5Fy26EJzRPYEk_kgH0YESTXiR-E=83Rur6PWZjyi8jQ@mail.gmail.com>
	<55AD27E0.6080102@iki.fi>
Date: Mon, 20 Jul 2015 13:14:01 -0400
Message-ID: <CALzAhNV6mq6V-jYdjjwrYqtwkKQTgvAFOUhxBvHuAK0jAXZ7gQ@mail.gmail.com>
Subject: Re: Adding support for three new Hauppauge HVR-1275 variants -
 testers reqd.
From: Steven Toth <stoth@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	tonyc@wincomm.com.tw, Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 20, 2015 at 12:54 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 07/20/2015 07:45 PM, Devin Heitmueller wrote:
>>>
>>> Look at the em28xx driver and you will probably see why it does not work
>>> as
>>> expected. For my eyes, according to em28xx driver, it looks like that bus
>>> control is aimed for bridge driver. You or em28xx is wrong.
>>
>>
>> Neither are wrong.  In some cases the call needs to be intercepted by
>> the frontend in order to disable its TS output.  In other cases it
>> needs to be intercepted by the bridge to control a MUX chip which
>> dictates which demodulator's TS output to route from (typically by
>> toggling a GPIO).
>
>
> Quickly looking the existing use cases and I found only lgdt3306a demod
> which uses that callback to control its TS interface. All the rest seems to
> be somehow more related to bridge driver, mostly changing bridge TS IF or
> leds etc.

The API is flexible enough to be used by either the bridge
intercepting the dvb_frontent_open operation, or by allowing the
demodulator itself to act upon it. The API itself specifically
describes the "TS BUS CONTROL" access, and whether something upstream
of the demodulator wants a downstream device attached, or detached
from the transport electrical interface.

I see little point adding more bridge glue to route each dvb frontend
into the cx23885-bridge and making a judgement based on the board
type, when dvb-core is already effectively doing this, and has been
for sometime. The caveat to this, is if you find a use-case that
breaks the current driver in the current tip kernel. I currently do
not see that.

>
> I don't simply see that correct solution for disabling demod TS IF - there
> is sleep() for this kind of things - and as I pointed out it does not even
> work for me em28xx based device because em28xx uses that routine to switch
> own TS mode.

Asking a demodulator to sleep/wake is absolutely not the same thing as
asking it to stop/start driving electrical signals on a bus.

We can agree or disagree about whether a part should be tri-stated in
init/sleep() and under what circumstances, but why bother when someone
has gone to the trouble of declaring a perfectly good tr-state
interface in dvb-core, taht automatically asserts and de-asserts any
dvb_frontend device from the bus, optionally.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
