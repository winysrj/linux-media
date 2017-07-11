Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:6075 "EHLO smtp2-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933186AbdGKVvj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 17:51:39 -0400
Subject: Re: Trying to use IR driver for my SoC
To: Sean Young <sean@mess.org>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>
References: <cf82988e-8be2-1ec8-b343-7c3c54110746@free.fr>
 <20170629155557.GA12980@gofer.mess.org>
 <276e7aa2-0c98-5556-622a-65aab4b9d373@free.fr>
 <20170629175037.GA14390@gofer.mess.org>
 <204a429c-b886-63a7-4d59-522864f05030@free.fr>
 <20170629194405.GA15901@gofer.mess.org>
 <0e2089ae-23cf-33fc-7c3d-68b7ab43ef57@free.fr>
 <20170711183557.ir4h7nqx2rrr3mbf@gofer.mess.org>
From: Mason <slash.tmp@free.fr>
Message-ID: <e26579c0-6f4f-7e4f-e9ad-b2998121aac4@free.fr>
Date: Tue, 11 Jul 2017 23:51:02 +0200
MIME-Version: 1.0
In-Reply-To: <20170711183557.ir4h7nqx2rrr3mbf@gofer.mess.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/07/2017 20:35, Sean Young wrote:

> Mason wrote:
>
>> Repeating the test (pressing '1' for one second) with ir-keytable:
>>
>> # ir-keytable -p all -t -v
>> Found device /sys/class/rc/rc0/
>> Input sysfs node is /sys/class/rc/rc0/input0/
>> Event sysfs node is /sys/class/rc/rc0/input0/event0/
>> Parsing uevent /sys/class/rc/rc0/input0/event0/uevent
>> /sys/class/rc/rc0/input0/event0/uevent uevent MAJOR=13
>> /sys/class/rc/rc0/input0/event0/uevent uevent MINOR=64
>> /sys/class/rc/rc0/input0/event0/uevent uevent DEVNAME=input/event0
>> Parsing uevent /sys/class/rc/rc0/uevent
>> /sys/class/rc/rc0/uevent uevent NAME=rc-empty
>> input device is /dev/input/event0
>> /sys/class/rc/rc0/protocols protocol rc-5 (disabled)
>> /sys/class/rc/rc0/protocols protocol nec (disabled)
>> /sys/class/rc/rc0/protocols protocol rc-6 (disabled)
>> Opening /dev/input/event0
>> Input Protocol version: 0x00010001
>> /sys/class/rc/rc0//protocols: Invalid argument
>> Couldn't change the IR protocols
>> Testing events. Please, press CTRL-C to abort.
>> 1296.124872: event type EV_MSC(0x04): scancode = 0x4cb41
>> 1296.124872: event type EV_SYN(0x00).
>> 1296.178753: event type EV_MSC(0x04): scancode = 0x00
>> 1296.178753: event type EV_SYN(0x00).
>> 1296.286526: event type EV_MSC(0x04): scancode = 0x00
>> 1296.286526: event type EV_SYN(0x00).
>> 1296.394303: event type EV_MSC(0x04): scancode = 0x00
>> 1296.394303: event type EV_SYN(0x00).
>> 1296.502081: event type EV_MSC(0x04): scancode = 0x00
>> 1296.502081: event type EV_SYN(0x00).
>> 1296.609857: event type EV_MSC(0x04): scancode = 0x00
>> 1296.609857: event type EV_SYN(0x00).
>> 1296.717635: event type EV_MSC(0x04): scancode = 0x00
>> 1296.717635: event type EV_SYN(0x00).
>> 1296.825412: event type EV_MSC(0x04): scancode = 0x00
>> 1296.825412: event type EV_SYN(0x00).
>> 1296.933189: event type EV_MSC(0x04): scancode = 0x00
>> 1296.933189: event type EV_SYN(0x00).
>> 1297.040967: event type EV_MSC(0x04): scancode = 0x00
>> 1297.040967: event type EV_SYN(0x00).
>> 1297.148745: event type EV_MSC(0x04): scancode = 0x00
>> 1297.148745: event type EV_SYN(0x00).
>> 1297.256522: event type EV_MSC(0x04): scancode = 0x00
>> 1297.256522: event type EV_SYN(0x00).
>>
>> It looks like scancode 0x00 means "REPEAT" ?
> 
> This looks like nec repeat to me; nec repeats are sent every 110ms;
> however when a repeat occurs, the driver should call rc_repeat(),
> sending a scancode of 0 won't work.

IIUC, the driver requires some fixup, to behave as user-space
would expect; is that correct?

Are you the reviewer for rc drivers?


>> And 0x4cb41 would be '1' then?
>>
>> If I compile the legacy driver (which is much more cryptic)
>> it outputs 04 cb 41 be
> 
> ~0xbe = 0x41. The code in tangox_ir_handle_nec() has decoded this
> into extended nec (so the driver should send RC_TYPE_NECX), see
> https://github.com/mansr/linux-tangox/blob/master/drivers/media/rc/tangox-ir.c#L68

Another required fixup IIUC, right?

Thank you so much for all the insight you've provided.

Regards.
