Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34235 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1FLSJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 14:09:33 -0400
Received: by vxi39 with SMTP id 39so3194315vxi.19
        for <linux-media@vger.kernel.org>; Sun, 12 Jun 2011 11:09:32 -0700 (PDT)
Subject: Re: [PATCH] [media] rc-core support for Microsoft IR keyboard/mouse
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <4DF36FC9.6020803@redhat.com>
Date: Sun, 12 Jun 2011 14:09:30 -0400
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <E32E4315-D62A-47D1-A0A6-618DCC3D8662@wilsonet.com>
References: <1307136508-19455-1-git-send-email-jarod@redhat.com> <4DF36FC9.6020803@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jun 11, 2011, at 9:38 AM, Mauro Carvalho Chehab wrote:

> Em 03-06-2011 18:28, Jarod Wilson escreveu:
>> This is a custom IR protocol decoder, for the RC-6-ish protocol used by
>> the Microsoft Remote Keyboard.
>> 
>> http://www.amazon.com/Microsoft-Remote-Keyboard-Windows-ZV1-00004/dp/B000AOAAN8
>> 
>> Its a standard keyboard with embedded thumb stick mouse pointer and
>> mouse buttons, along with a number of media keys. The media keys are
>> standard RC-6, identical to the signals from the stock MCE remotes, and
>> will be handled as such. The keyboard and mouse signals will be decoded
>> and delivered to the system by an input device registered specifically
>> by this driver.
>> 
>> Successfully tested with an mceusb-driven receiver, but this should
>> actually work with any raw IR rc-core receiver.
>> 
>> This work is inspired by lirc_mod_mce:
>> 
>> http://mod-mce.sourceforge.net/
>> 
>> The documentation there and code aided in understanding and decoding the
>> protocol, but the bulk of the code is actually borrowed more from the
>> existing in-kernel decoders than anything. I did recycle the keyboard
>> keycode table and a few defines from lirc_mod_mce though.
>> 
>> Signed-off-by: Jarod Wilson <jarod@redhat.com>
>> ---
> 
> I did only a quick review, and everything looks fine for me. Just two comments:
> 
>> +#if 0
>> +	/* Adding this reference means two input devices are associated with
>> +	 * this rc-core device, which ir-keytable doesn't cope with yet */
>> +	idev->dev.parent = &dev->dev;
>> +#endif
> 
> Well, it was never tested with such config ;)

D'oh, I meant to mention that #if 0...


> Feel free to fix rc-core.

It wasn't actually rc-core that complained, it was ir-keytable that spit out
a message about not being able to handle an rc device with multiple input
devices, but the fix may well require both userspace and kernelspace changes...


>> +static unsigned char kbd_keycodes[256] = {
>> +          0,   0,   0,   0,  30,  48,  46,  32,  18,  33,  34,  35,  23,  36,  37,  38,
>> +         50,  49,  24,  25,  16,  19,  31,  20,  22,  47,  17,  45,  21,  44,   2,   3,
>> +          4,   5,   6,   7,   8,   9,  10,  11,  28,   1,  14,  15,  57,  12,  13,  26,
>> +         27,  43,  43,  39,  40,  41,  51,  52,  53,  58,  59,  60,  61,  62,  63,  64,
>> +         65,  66,  67,  68,  87,  88,  99,  70, 119, 110, 102, 104, 111, 107, 109, 106,
>> +        105, 108, 103,  69,  98,  55,  74,  78,  96,  79,  80,  81,  75,  76,  77,  71,
>> +         72,  73,  82,  83,  86, 127, 116, 117, 183, 184, 185, 186, 187, 188, 189, 190,
>> +        191, 192, 193, 194, 134, 138, 130, 132, 128, 129, 131, 137, 133, 135, 136, 113,
>> +        115, 114,   0,   0,   0, 121,   0,  89,  93, 124,  92,  94,  95,   0,   0,   0,
>> +        122, 123,  90,  91,  85,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
>> +          0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
>> +          0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
>> +          0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
>> +          0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
>> +         29,  42,  56, 125,  97,  54, 100, 126, 164, 166, 165, 163, 161, 115, 114, 113,
>> +        150, 158, 159, 128, 136, 177, 178, 176, 142, 152, 173, 140
>> +};
> 
> This table looks weird to me: too much magic numbers there. Shouldn't
> the above be replaced by KEY_* definitions?

Yeah, probably. The above is basically the same convention as hid_keyboard in
drivers/hid/hid-input.c, but that doesn't mean we can't strive to do better. ;)


> PS.: I would like to have one of those keyboards, in order to test some things here,
> in special, for the xorg input/event proposal on my TODO list ;) Is it a cheap device?
> I may try to buy one the next time I would travel to US.

Looks like Amazon has them listed for less than $40USD right now, but they're
becoming increasingly hard to find, as I believe they're discontinued. Don't
know if I've ever seen them in a brick-n-mortar store anywhere. I should really
get one for myself, I have to send this one back to the guy who loaned it to me.
I could just make it a double order and stash one on the shelf for ya.

-- 
Jarod Wilson
jarod@wilsonet.com



