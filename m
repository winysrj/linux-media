Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw2.han.skanova.net ([81.236.60.205]:60444 "EHLO
        v-smtpgw2.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728316AbeJVSCL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Oct 2018 14:02:11 -0400
Subject: Re: cec kernel oops with pulse8 usb cec adapter
To: Sean Young <sean@mess.org>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <b067e063-641c-0498-4989-3edda5296f9a@mbox200.swipnet.se>
 <e2bb2b91-861b-8cdc-4ad4-939e50019214@xs4all.nl>
 <20181022085910.2gndxc75zcqkto5z@gofer.mess.org>
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Message-ID: <1a63a5b5-644f-cef4-d0ad-9ae3bf491f9a@mbox200.swipnet.se>
Date: Mon, 22 Oct 2018 11:44:22 +0200
MIME-Version: 1.0
In-Reply-To: <20181022085910.2gndxc75zcqkto5z@gofer.mess.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-10-22 10:59, Sean Young wrote:
> On Sat, Oct 20, 2018 at 11:12:16PM +0200, Hans Verkuil wrote:
>> Hi Sean,
>>
>> Can you take a look at this, it appears to be an RC issue, see my analysis below.
>>
>> On 10/20/2018 03:26 PM, Torbjorn Jansson wrote:
>>> Hello
>>>
>>> i'm using the pulse8 usb cec adapter to control my tv.
>>> i have a few scripts that poll the power status of my tv and after a while it stops working returning errors when trying to check if tv is on or off.
>>> this i think matches a kernel oops i'm seeing that i suspect is related to this.
>>>
>>> i have sometimes been able to recover from this problem by completely cutting power to my tv and also unplugging the usb cec adapter.
>>> i have a feeling that the tv is at least partly to blame for cec-ctl not working but in any case there shouldn't be a kernel oops.
>>>
>>>
>>> also every now and then i see this in dmesg:
>>> cec cec0: transmit: failed 05
>>> cec cec0: transmit: failed 06
>>> but that doesn't appear to do any harm as far as i can tell.
>>>
>>> any idea whats causing the oops?
>>>
>>> the ops:
>>>
>>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
>>> PGD 0 P4D 0
>>> Oops: 0000 [#1] SMP PTI
>>> CPU: 9 PID: 27687 Comm: kworker/9:2 Tainted: P           OE 4.18.12-200.fc28.x86_64 #1
>>> Hardware name: Supermicro C7X99-OCE-F/C7X99-OCE-F, BIOS 2.1a 06/15/2018
>>> Workqueue: events pulse8_irq_work_handler [pulse8_cec]
>>> RIP: 0010:ir_lirc_scancode_event+0x3d/0xb0 [rc_core]
>>
>> Huh. ir_lirc_scancode_event() calls spin_lock_irqsave(&dev->lirc_fh_lock, flags);
>>
>> The spinlock dev->lirc_fh_lock is initialized in ir_lirc_register(), which is called
>> from rc_register_device(), except when the protocol is CEC:
>>
>>          /* Ensure that the lirc kfifo is setup before we start the thread */
>>          if (dev->allowed_protocols != RC_PROTO_BIT_CEC) {
>>                  rc = ir_lirc_register(dev);
>>                  if (rc < 0)
>>                          goto out_rx;
>>          }
>>
>> So it looks like ir_lirc_scancode_event() fails because dev->lirc_fh_lock was never
>> initialized.
>>
>> Could this be fall-out from the lirc changes you did not too long ago?
> 
> Yes, this is broken. My bad, sorry. I think this must have been broken since
> v4.16. I can write a patch but I don't have a patch but I'm on the train
> to ELCE in Edinburgh now, with no hardware to test on.
> 
> 
> Sean
> 

the kernel oops have been happening for a while now.
yesterday when i checked my logs i can see them at least back a couple of 
months when i was running 4.17

also my scripts to poll status of my tv and turn it on/off works for a while so 
it doesn't crash right away.
maybe it only crashes when i send cec command to turn on/off tv and only 
polling for status is no problem.


i think i have a separate issue too because i had problems even before the 
kernel oopses started.
but i suspect this is caused by my tv locking up the cec bus because unplugging 
power to tv for a few minutes (i must wait or it will still be just as broken) 
and then back used to resolve the cec errors from my scripts.
