Return-path: <linux-media-owner@vger.kernel.org>
Received: from firefly.pyther.net ([50.116.37.168]:36496 "EHLO
	firefly.pyther.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab2LJQBe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 11:01:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Mon, 10 Dec 2012 11:01:34 -0500
From: Matthew Gyurgyik <matthew@pyther.net>
To: =?UTF-8?Q?Frank_Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
In-Reply-To: <50C60220.8050908@googlemail.com>
References: <50B5779A.9090807@pyther.net> <50BB6451.7080601@iki.fi>
 <50BB8D72.8050803@googlemail.com> <50BCEC60.4040206@googlemail.com>
 <50BD5CC3.1030100@pyther.net>
 <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com>
 <50BD6310.8000808@pyther.net>
 <CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com>
 <50BE65F0.8020303@googlemail.com> <50BEC253.4080006@pyther.net>
 <50BF3F9A.3020803@iki.fi> <50BFBE39.90901@pyther.net>
 <50BFC445.6020305@iki.fi> <50BFCBBB.5090407@pyther.net>
 <50BFECEA.9060808@iki.fi> <50BFFFF6.1000204@pyther.net>
 <50C11301.10205@googlemail.com> <50C12302.80603@pyther.net>
 <50C34628.5030407@googlemail.com> <50C34A50.6000207@pyther.net>
 <50C35AD1.3040000@googlemail.com> <50C48891.2050903@googlemail.com>
 <50C4A520.6020908@pyther.net>
 <CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com>
 <50C4BA20.8060003@googlemail.com> <50C4BAFB.60304@googlemail.com>
 <50C4C525.6020006@googlemail.com> <50C4D011.6010700@pyther.net>
 <50C60220.8050908@googlemail.com>
Message-ID: <8947ebce0443a0f9dbf26d90a02d9df7@snail.pyther.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-12-10 10:39, Frank Schäfer wrote:
> Am 09.12.2012 18:53, schrieb Matthew Gyurgyik:
>> On 12/09/2012 12:06 PM, Frank Schäfer wrote:
>>> Forget this sh... (never do multiple things at the same time ;) )
>>>
>>> Reg 0x50 is set to according to rc_type specified in the selected 
>>> remote
>>> control map.
>>> So if the correct map is selected, everything should be fine (as 
>>> long as
>>> it is RC_TYPE_NEC or RC_TYPE_RC5 because we don't support others 
>>> yet).
>>>
>>> RC_MAP_KWORLD_315U and RC_MAP_MSI_DIGIVOX_III are both RC_TYPE_NEC, 
>>> so
>>> the stick seems to use no NEC protocol.
>>>
>>> Matthew, insert a line
>>>
>>>          ir_config = 0x01;
>>>
>>> before
>>>
>>> 380        em28xx_write_regs(dev, EM2874_R50_IR_CONFIG, &ir_config, 
>>> 1);
>>>
>>> in em28xx-input.c and see if something shows up in the dmesg 
>>> output.
>>>
>>> Regards,
>>> Frank
>>
>> That seems to be a bit more successful!
>>
>> Here is the dmesg output:
>>
>>> [root@tux ~]# dmesg -t | sort | uniq | grep 'em28xx IR' | grep 
>>> handle
>>> em28xx IR (em28xx #0)/ir: 6em28xx_ir_handle_key: toggle: 0, count: 
>>> 1,
>>> key 0x61d6
>>> em28xx IR (em28xx #0)/ir: 6em28xx_ir_handle_key: toggle: 0, count: 
>>> 2,
>>> key 0x61d6
>>> em28xx IR (em28xx #0)/ir: 6em28xx_ir_handle_key: toggle: 1, count: 
>>> 1,
>>> key 0x61d6
>>> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 0, count: 
>>> 1,
>>> key 0x61d6
>>> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 0, count: 
>>> 2,
>>> key 0x61d6
>>> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 1, count: 
>>> 1,
>>> key 0x61d6
>>> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 1, count: 
>>> 2,
>>> key 0x61d6
>>
>> I pressed all the buttons on the remote (40 buttons).
>
> Did you cut the dmesg output ? Or do you really get these messages 
> for
> key 0x61d6 only ?
>

Correct, I got these messages for key 0x61d6 regardless of the physical 
key pressed.

> It seems like things are working different with reg 0x50 = 0x01. 
> Taking
> a look into the datasheet might help, but I don't have it. ;)
>
> Regards,
> Frank
>
>>
>> Thanks,
>> Matthew

