Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:40476 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727528AbeJVTsq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Oct 2018 15:48:46 -0400
Subject: Re: [PATCH] media: rc: cec devices do not have a lirc chardev
To: Sean Young <sean@mess.org>,
        Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        stable@vger.kernel.org
References: <b067e063-641c-0498-4989-3edda5296f9a@mbox200.swipnet.se>
 <e2bb2b91-861b-8cdc-4ad4-939e50019214@xs4all.nl>
 <20181022085910.2gndxc75zcqkto5z@gofer.mess.org>
 <1a63a5b5-644f-cef4-d0ad-9ae3bf491f9a@mbox200.swipnet.se>
 <20181022101405.v7setqacuftrafrb@gofer.mess.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <45261f15-b022-8871-b087-937988b3bf1f@xs4all.nl>
Date: Mon, 22 Oct 2018 12:30:29 +0100
MIME-Version: 1.0
In-Reply-To: <20181022101405.v7setqacuftrafrb@gofer.mess.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/22/2018 11:14 AM, Sean Young wrote:
> On Mon, Oct 22, 2018 at 11:44:22AM +0200, Torbjorn Jansson wrote:
>> On 2018-10-22 10:59, Sean Young wrote:
>>> On Sat, Oct 20, 2018 at 11:12:16PM +0200, Hans Verkuil wrote:
>>>> Hi Sean,
>>>>
>>>> Can you take a look at this, it appears to be an RC issue, see my analysis below.
>>>>
>>>> On 10/20/2018 03:26 PM, Torbjorn Jansson wrote:
>>>>> Hello
>>>>>
>>>>> i'm using the pulse8 usb cec adapter to control my tv.
>>>>> i have a few scripts that poll the power status of my tv and after a while it stops working returning errors when trying to check if tv is on or off.
>>>>> this i think matches a kernel oops i'm seeing that i suspect is related to this.
>>>>>
>>>>> i have sometimes been able to recover from this problem by completely cutting power to my tv and also unplugging the usb cec adapter.
>>>>> i have a feeling that the tv is at least partly to blame for cec-ctl not working but in any case there shouldn't be a kernel oops.
>>>>>
>>>>>
>>>>> also every now and then i see this in dmesg:
>>>>> cec cec0: transmit: failed 05
>>>>> cec cec0: transmit: failed 06
>>>>> but that doesn't appear to do any harm as far as i can tell.
>>>>>
>>>>> any idea whats causing the oops?
>>>>>
>>>>> the ops:
>>>>>
>>>>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
>>>>> PGD 0 P4D 0
>>>>> Oops: 0000 [#1] SMP PTI
>>>>> CPU: 9 PID: 27687 Comm: kworker/9:2 Tainted: P           OE 4.18.12-200.fc28.x86_64 #1
>>>>> Hardware name: Supermicro C7X99-OCE-F/C7X99-OCE-F, BIOS 2.1a 06/15/2018
>>>>> Workqueue: events pulse8_irq_work_handler [pulse8_cec]
>>>>> RIP: 0010:ir_lirc_scancode_event+0x3d/0xb0 [rc_core]
>>>>
>>>> Huh. ir_lirc_scancode_event() calls spin_lock_irqsave(&dev->lirc_fh_lock, flags);
>>>>
>>>> The spinlock dev->lirc_fh_lock is initialized in ir_lirc_register(), which is called
>>>> from rc_register_device(), except when the protocol is CEC:
>>>>
>>>>          /* Ensure that the lirc kfifo is setup before we start the thread */
>>>>          if (dev->allowed_protocols != RC_PROTO_BIT_CEC) {
>>>>                  rc = ir_lirc_register(dev);
>>>>                  if (rc < 0)
>>>>                          goto out_rx;
>>>>          }
>>>>
>>>> So it looks like ir_lirc_scancode_event() fails because dev->lirc_fh_lock was never
>>>> initialized.
>>>>
>>>> Could this be fall-out from the lirc changes you did not too long ago?
>>>
>>> Yes, this is broken. My bad, sorry. I think this must have been broken since
>>> v4.16. I can write a patch but I don't have a patch but I'm on the train
>>> to ELCE in Edinburgh now, with no hardware to test on.
>>>
>>>
>>> Sean
>>>
>>
>> the kernel oops have been happening for a while now.
>> yesterday when i checked my logs i can see them at least back a couple of
>> months when i was running 4.17
>>
>> also my scripts to poll status of my tv and turn it on/off works for a while
>> so it doesn't crash right away.
>> maybe it only crashes when i send cec command to turn on/off tv and only
>> polling for status is no problem.
>>
>>
>> i think i have a separate issue too because i had problems even before the
>> kernel oopses started.
>> but i suspect this is caused by my tv locking up the cec bus because
>> unplugging power to tv for a few minutes (i must wait or it will still be
>> just as broken) and then back used to resolve the cec errors from my
>> scripts.
> 
> 
> Would you be able to test the following patch please?

Sean,

I think you should be able to test this with the vivid driver. Load the vivid driver,
run:

cec-ctl --tv; cec-ctl -d1 --playback

Then:

cec-ctl -d1 -t0 --user-control-pressed ui-cmd=F5

That said, I tried this, but it doesn't crash for me, but perhaps I need to run
some RC command first...

Regards,

	Hans

> 
> Thanks,
> 
> Sean
> ---
> From 1b8b20b606b30c0e301c80e18af8d77194269bc1 Mon Sep 17 00:00:00 2001
> From: Sean Young <sean@mess.org>
> Date: Mon, 22 Oct 2018 10:01:50 +0100
> Subject: [PATCH] media: rc: cec devices do not have a lirc chardev
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> This fixes an oops in ir_lirc_scancode_event().
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP PTI
> CPU: 9 PID: 27687 Comm: kworker/9:2 Tainted: P           OE 4.18.12-200.fc28.x86_64 #1
> Hardware name: Supermicro C7X99-OCE-F/C7X99-OCE-F, BIOS 2.1a 06/15/2018
> Workqueue: events pulse8_irq_work_handler [pulse8_cec]
> RIP: 0010:ir_lirc_scancode_event+0x3d/0xb0 [rc_core]
> Code: 8d ae b4 07 00 00 49 81 c6 b8 07 00 00 53 e8 4a df c3 d5 48 89 ef 49 89 45 00 e8 4e 84 41 d6 49 8b 1e 49 89 c4 4c 39 f3 74 58 <8b> 43 38 8b 53 40 89 c1 2b 4b 3c 39 ca 72 41 21 d0 49 8b 7d 00 49
> RSP: 0018:ffffaa10e3c07d58 EFLAGS: 00010017
> RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000018
> RDX: 0000000000000001 RSI: 00316245397fa93c RDI: ffff966d31c8d7b4
> RBP: ffff966d31c8d7b4 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000003 R11: ffffaa10e3c07e28 R12: 0000000000000002
> R13: ffffaa10e3c07d88 R14: ffff966d31c8d7b8 R15: 0000000000000073
> FS:  0000000000000000(0000) GS:ffff966d3f440000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000038 CR3: 00000009d820a003 CR4: 00000000003606e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  ir_do_keydown+0x75/0x260 [rc_core]
>  rc_keydown+0x54/0xc0 [rc_core]
>  cec_received_msg_ts+0xaa8/0xaf0 [cec]
>  process_one_work+0x1a1/0x350
>  worker_thread+0x30/0x380
>  ? pwq_unbound_release_workfn+0xd0/0xd0
>  kthread+0x112/0x130
>  ? kthread_create_worker_on_cpu+0x70/0x70
>  ret_from_fork+0x35/0x40
> Modules linked in: rc_tt_1500 dvb_usb_dvbsky dvb_usb_v2 uas usb_storage fuse vhost_net vhost tap xt_CHECKSUM iptable_mangle ip6t_REJECT nf_reject_ipv6 tun 8021q garp mrp xt_nat macvlan xfs devlink ebta
>  si2157 si2168 cx25840 cx23885 kvm altera_ci tda18271 joydev ir_rc6_decoder rc_rc6_mce crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate intel_uncore altera_stapl m88ds3103 tveeprom cx2341
>  mxm_wmi igb crc32c_intel megaraid_sas dca i2c_algo_bit wmi vfio_pci irqbypass vfio_virqfd vfio_iommu_type1 vfio i2c_dev
> CR2: 0000000000000038
> 
> Cc: <stable@vger.kernel.org> # v4.16+
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/rc-main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 552bbe82a160..877978dbd409 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -695,7 +695,8 @@ void rc_repeat(struct rc_dev *dev)
>  			 (dev->last_toggle ? LIRC_SCANCODE_FLAG_TOGGLE : 0)
>  	};
>  
> -	ir_lirc_scancode_event(dev, &sc);
> +	if (dev->allowed_protocols != RC_PROTO_BIT_CEC)
> +		ir_lirc_scancode_event(dev, &sc);
>  
>  	spin_lock_irqsave(&dev->keylock, flags);
>  
> @@ -735,7 +736,8 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_proto protocol,
>  		.keycode = keycode
>  	};
>  
> -	ir_lirc_scancode_event(dev, &sc);
> +	if (dev->allowed_protocols != RC_PROTO_BIT_CEC)
> +		ir_lirc_scancode_event(dev, &sc);
>  
>  	if (new_event && dev->keypressed)
>  		ir_do_keyup(dev, false);
> 
