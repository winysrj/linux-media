Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:39705 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab2LJQBp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 11:01:45 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so2046268lag.19
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2012 08:01:44 -0800 (PST)
Message-ID: <50C60772.2010904@googlemail.com>
Date: Mon, 10 Dec 2012 17:01:54 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Matthew Gyurgyik <matthew@pyther.net>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50BD5CC3.1030100@pyther.net> <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com> <50BD6310.8000808@pyther.net> <CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com> <50BE65F0.8020303@googlemail.com> <50BEC253.4080006@pyther.net> <50BF3F9A.3020803@iki.fi> <50BFBE39.90901@pyther.net> <50BFC445.6020305@iki.fi> <50BFCBBB.5090407@pyther.net> <50BFECEA.9060808@iki.fi> <50BFFFF6.1000204@pyther.net> <50C11301.10205@googlemail.com> <50C12302.80603@pyther.net> <50C34628.5030407@googlemail.com> <50C34A50.6000207@pyther.net> <50C35AD1.3040000@googlemail.com> <50C48891.2050903@googlemail.com> <50C4A520.6020908@pyther.net> <CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com> <50C4BA20.8060003@googlemail.com> <50C4BAFB.60304@googlemail.com> <50C4C525.6020006@googlemail.com> <50C4D011.6010700@pyther.net> <50C60220.8050908@googlemail.com> <CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com>
In-Reply-To: <CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 10.12.2012 16:46, schrieb Devin Heitmueller:
> On Mon, Dec 10, 2012 at 10:39 AM, Frank Schäfer
> <fschaefer.oss@googlemail.com> wrote:
>> Am 09.12.2012 18:53, schrieb Matthew Gyurgyik:
>>> On 12/09/2012 12:06 PM, Frank Schäfer wrote:
>>>> Forget this sh... (never do multiple things at the same time ;) )
>>>>
>>>> Reg 0x50 is set to according to rc_type specified in the selected remote
>>>> control map.
>>>> So if the correct map is selected, everything should be fine (as long as
>>>> it is RC_TYPE_NEC or RC_TYPE_RC5 because we don't support others yet).
>>>>
>>>> RC_MAP_KWORLD_315U and RC_MAP_MSI_DIGIVOX_III are both RC_TYPE_NEC, so
>>>> the stick seems to use no NEC protocol.
>>>>
>>>> Matthew, insert a line
>>>>
>>>>          ir_config = 0x01;
>>>>
>>>> before
>>>>
>>>> 380        em28xx_write_regs(dev, EM2874_R50_IR_CONFIG, &ir_config, 1);
>>>>
>>>> in em28xx-input.c and see if something shows up in the dmesg output.
>>>>
>>>> Regards,
>>>> Frank
>>> That seems to be a bit more successful!
>>>
>>> Here is the dmesg output:
>>>
>>>> [root@tux ~]# dmesg -t | sort | uniq | grep 'em28xx IR' | grep handle
>>>> em28xx IR (em28xx #0)/ir: 6em28xx_ir_handle_key: toggle: 0, count: 1,
>>>> key 0x61d6
>>>> em28xx IR (em28xx #0)/ir: 6em28xx_ir_handle_key: toggle: 0, count: 2,
>>>> key 0x61d6
>>>> em28xx IR (em28xx #0)/ir: 6em28xx_ir_handle_key: toggle: 1, count: 1,
>>>> key 0x61d6
>>>> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 0, count: 1,
>>>> key 0x61d6
>>>> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 0, count: 2,
>>>> key 0x61d6
>>>> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 1, count: 1,
>>>> key 0x61d6
>>>> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 1, count: 2,
>>>> key 0x61d6
>>> I pressed all the buttons on the remote (40 buttons).
>> Did you cut the dmesg output ? Or do you really get these messages for
>> key 0x61d6 only ?
>>
>> It seems like things are working different with reg 0x50 = 0x01. Taking
>> a look into the datasheet might help, but I don't have it. ;)
> Setting that bit turns off NEC parity checking.  I don't think we've
> ever had a need for it before, which is why it isn't exposed as
> configurable functionality in the driver.
>
> No clear answer on how this should be fixed, if that's what is really
> required.  I guess in theory we could introduce some new board config
> option, but that would likely interfere with the ability to
> reconfigure the RC protocol at runtime.  An alternative would be a new
> property of the RC profile, but that would pollute the definition of
> the struct presumably to work around some bug in a crappy remote
> control.

Adding a new property to the RC profile certainly seems to be the
cleanest solution.
Do all protocols have paritiy checking ? Otherwise we could add a new
type RC_TYPE_NEC_NO_PARITY.
OTOH, introducing a new bitfield in struct rc_map might be usefull for
other flags, too, in the future...

Regards,
Frank
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com

