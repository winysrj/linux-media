Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:61150 "EHLO smtp2-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932748AbdGKVQj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 17:16:39 -0400
Subject: Re: Infrared support on tango boards
To: Sean Young <sean@mess.org>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>
References: <e5063c2c-52db-7d75-e090-fbc49ab76deb@free.fr>
 <20170711195058.y425mohdbzjeihgy@gofer.mess.org>
From: Mason <slash.tmp@free.fr>
Message-ID: <bc1fd24d-8568-ffe1-4eed-d3df0987176e@free.fr>
Date: Tue, 11 Jul 2017 23:16:13 +0200
MIME-Version: 1.0
In-Reply-To: <20170711195058.y425mohdbzjeihgy@gofer.mess.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/07/2017 21:50, Sean Young wrote:

> On Mon, Jul 10, 2017 at 11:44:08AM +0200, Mason wrote:
>
>> How does one know which decoder to use, out of
>> the dozen protocols available?
> 
> Well, that depends on the protocol the remote uses to send.

Is there a way to "guess" the protocol used, just by
looking at the raw bitstream?


>> Hmmm, I'm missing a step for going from
>> 00000000  a9 07 00 00 2e 72 0e 00  04 00 04 00 41 cb 04 00  |.....r......A...|
>> 00000010  a9 07 00 00 2e 72 0e 00  00 00 00 00 00 00 00 00  |.....r..........|
>> to
>> 2589.901611: event type EV_MSC(0x04): scancode = 0x4cb41
>> 2589.901611: event type EV_SYN(0x00).
>> (not the same IR frame, BTW)
> 
> The first is a hexdump of struct input_event, the second is a pretty
> print of it.

http://elixir.free-electrons.com/linux/latest/source/include/uapi/linux/input.h#L25

struct input_event {
	struct timeval time;
	__u16 type;
	__u16 code;
	__s32 value;
};

Gotcha.


>> Once we have a scancode, there is another translation pass,
>> to the higher-level concept of an actual key, such as "1",
>> which all applications can agree on.
> 
> Yep, that's what the keymaps in drivers/media/rc/keymaps/ are for.

Suppose I wrote a keymap "driver" for my remote control,

Does loading a kernel keymap change what is output on
/dev/input/event0 ?

I mean, does the output changes from 'struct input_event'
to input-event-codes? (so 4-byte int?)
Or is that sent on a different dev node?

http://elixir.free-electrons.com/linux/latest/source/include/uapi/linux/input-event-codes.h


>> Back on topic: it seems to me that Linux supports many protocol
>> decoders, including the 3 supported by block A. I am also assuming
>> that IR signals are pretty low bandwidth? Thus, it would appear
>> to make sense to only use block B, to have the widest support.
> 
> Absolutely right. That's what the winbond-cir driver does too. However,
> for wakeup from suspend the winbond-cir uses the hardware decoder.

I was later told that the "universal" HW block had not
received extensive testing; and everyone just uses the
NEC/RC5/RC6 block. So I guess I'll forget about the
UIR block for now.

Regards.
