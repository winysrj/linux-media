Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:47330 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab3AFUcF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2013 15:32:05 -0500
Received: by mail-bk0-f51.google.com with SMTP id ik5so8121143bkc.10
        for <linux-media@vger.kernel.org>; Sun, 06 Jan 2013 12:32:04 -0800 (PST)
Message-ID: <50E9DF5F.8070802@googlemail.com>
Date: Sun, 06 Jan 2013 21:32:31 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 6/6] ir-kbd-i2c: fix get_key_knc1()
References: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com> <1356649368-5426-7-git-send-email-fschaefer.oss@googlemail.com> <20130105003950.5463ee70@redhat.com> <50E82B6E.3090609@googlemail.com> <20130105132548.7ad6d0aa@redhat.com>
In-Reply-To: <20130105132548.7ad6d0aa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 05.01.2013 16:25, schrieb Mauro Carvalho Chehab:
> Em Sat, 05 Jan 2013 14:32:30 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 05.01.2013 03:39, schrieb Mauro Carvalho Chehab:
>>> Em Fri, 28 Dec 2012 00:02:48 +0100
>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>
>>>> - return valid key code when button is hold
>>>> - debug: print key code only when a button is pressed
>>>>
>>>> Tested with device "Terratec Cinergy 200 USB" (em28xx).
>>>>
>>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>>>> ---
>>>>  drivers/media/i2c/ir-kbd-i2c.c |   15 +++++----------
>>>>  1 Datei geändert, 5 Zeilen hinzugefügt(+), 10 Zeilen entfernt(-)
>>>>
>>>> diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
>>>> index 08ae067..2984b7d 100644
>>>> --- a/drivers/media/i2c/ir-kbd-i2c.c
>>>> +++ b/drivers/media/i2c/ir-kbd-i2c.c
>>>> @@ -184,18 +184,13 @@ static int get_key_knc1(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
>>>>  		return -EIO;
>>>>  	}
>>>>  
>>>> -	/* it seems that 0xFE indicates that a button is still hold
>>>> -	   down, while 0xff indicates that no button is hold
>>>> -	   down. 0xfe sequences are sometimes interrupted by 0xFF */
>>>> -
>>>> -	dprintk(2,"key %02x\n", b);
>>>> -
>>>> -	if (b == 0xff)
>>>> +	if (b == 0xff) /* no button */
>>>>  		return 0;
>>>>  
>>>> -	if (b == 0xfe)
>>>> -		/* keep old data */
>>>> -		return 1;
>>>> +	if (b == 0xfe) /* button is still hold */
>>>> +		b = ir->rc->last_scancode; /* keep old data */
>>>> +
>>>> +	dprintk(2,"key %02x\n", b);
>>>>  
>>>>  	*ir_key = b;
>>>>  	*ir_raw = b;
>>> Don't do that. This piece of code is old, and it was added there 
>>> before the em28xx driver. Originally, the ir-i2c-kbd were used by
>>> bttv and saa7134 drivers and the code there were auto-detecting the
>>> I2C IR hardware decoding chips that used to be very common on media
>>> devices. I'm almost sure that the original device that started using
>>> this code is this model:
>>>
>>> drivers/media/pci/bt8xx/bttv-cards.c:             .name           = "Typhoon TView RDS + FM Stereo / KNC1 TV Station RDS",
>>>
>>> That's why it is called as KNC1, but there are other cards that use
>>> it as well. I think I have one bttv using it. Not sure.
>>>
>>> The routine on em28xx is a fork of the original one, that was changed
>>> to work with the devices there.
>> Indeed, it's a fork, 100% identical:
>>
>>
>> static int em28xx_get_key_terratec(struct IR_i2c *ir, u32 *ir_key, u32
>> *ir_raw)
>> {
>>     unsigned char b;
>>
>>     /* poll IR chip */
>>     if (1 != i2c_master_recv(ir->c, &b, 1)) {
>>         i2cdprintk("read error\n");
>>         return -EIO;
>>     }
>>
>>     /* it seems that 0xFE indicates that a button is still hold
>>        down, while 0xff indicates that no button is hold
>>        down. 0xfe sequences are sometimes interrupted by 0xFF */
>>
>>     i2cdprintk("key %02x\n", b);
>>
>>     if (b == 0xff)
>>         return 0;
>>
>>     if (b == 0xfe)
>>         /* keep old data */
>>         return 1;
>>
>>     *ir_key = b;
>>     *ir_raw = b;
>>     return 1;
>> }
>>
>>
>>
>>
>> static int get_key_knc1(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
>> {
>>     unsigned char b;
>>
>>     /* poll IR chip */
>>     if (1 != i2c_master_recv(ir->c, &b, 1)) {
>>         dprintk(1,"read error\n");
>>         return -EIO;
>>     }
>>
>>     /* it seems that 0xFE indicates that a button is still hold
>>        down, while 0xff indicates that no button is hold
>>        down. 0xfe sequences are sometimes interrupted by 0xFF */
>>
>>     dprintk(2,"key %02x\n", b);
>>
>>     if (b == 0xff)
>>         return 0;
>>
>>     if (b == 0xfe)
>>         /* keep old data */
>>         return 1;
>>
>>     *ir_key = b;
>>     *ir_raw = b;
>>     return 1;
>> }
>>
>>
>>
>> Why should we keep two 100% identical functions ? See patch 4/6.
>> I'm 99% sure that both devices are absolutely identical.
> 99% sure is not enough. A simple firmware difference at the microprocessor
> is enough to make the devices different.

I agree, but that's irrelevant. What counts is that the _code_ ist 100%
identical.

> Also, this was widely discussed several years ago, when we decided to cleanup
> the I2C code. We then invested lot of efforts to move those get_keys away
> from ir-i2c-kbd. The only things left there are the ones we identified that
> were needed by auto-detection mode on old devices that we don't have.
>
> What was decided is to move everything that we know to the *-input driver,
> keeping there only the legacy stuff.

Uhm... ok.
My assumption was, that the goal is the opposite (move as much common
code as possible to i2c-ir-kbd).
I'm a bit puzzled about this decision...

Okay.... but then... why do we still use ir-kbd-i2c in em28xx ?
We can easily get rid of it. Everything we need is already on board.

I can send a patch if you want.

>
>> Concerning the fix I'm suggesting here:
>> First of all, I have to say that the Terratec RC works even without this
>> patch.
>> Nevertheless, I think the function should really return valid values for
>> ir_key and ir_raw when 0xfe=button hold is received. Especially because
>> the function succeeds.
>> This also allows us to make u32 ir_key, ir_raw in ir_key_poll() in
>> ir-kbd-i2c.c non-static.
>> While I agree that we should be careful, I can't see how this can cause
>> any trouble.
> Ok, the net effect is the same, except that the current way is faster, as it
> will skip some code that would simply put the value that it is already at
> ir_key/ir_raw again.

Faster... ok :) How much ? ;)
I would say its ugly coding. And a potential source of a regression.

> As this polling code is known to cause performance loss on some machines,
> the quickest, the best. Also, the better is to report long press events
> on a different way, as the input core can handle those on a different way
> (that's why there are there keyup/keydown kABI calls). A patch for better
> handle rc=1 return code at ir-i2c-kbd is needed.

Sounds good.

> In any case, I don't see any need for patches 4/6 or 6/6.
>
>> The second thing is the small fix for the key code debug output. Don't
>> you think it makes sense ?
> Now that we have "ir-keycode -t", all those key/scancode printk's inside
> the driver are pretty much useless, as both are reported as events.
>
> In the past, when most of the RC code were written, those prints were

Then we should remove them.

Regards,
Frank

> needed, as the scancode weren't reported to userspace.
>
> Regards,
> Mauro

