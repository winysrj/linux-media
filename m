Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37079 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbbLGSAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2015 13:00:24 -0500
Received: by wmww144 with SMTP id w144so160892925wmw.0
        for <linux-media@vger.kernel.org>; Mon, 07 Dec 2015 10:00:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHwmhgF-pYouHctHCy-d-uF4mDm-ZRd7kjJbxXRZ_9cKWG98fQ@mail.gmail.com>
References: <CAHwmhgFyjLOT6Na6oLXQT+FiUjyjrPX_CmKvQVDP-k9kawnMHw@mail.gmail.com>
	<CALF0-+UtHzo6-vYvUWtvS0hU7jyuPU+Ku4JC85T4gn4AHLgS0w@mail.gmail.com>
	<CAHwmhgGhdH8_+_5abeJZg=sL2nrr3psqzwHz3xrL_u1aV6mNCg@mail.gmail.com>
	<CAAEAJfDzpafBTqcTqjvEJWVxOQu7j=zK6m47VhnSVgM4kWhG5Q@mail.gmail.com>
	<CAHwmhgHsPZTLgChqO05NYv7h-rD_Sex2d+jqsK=PpYJxcHi78g@mail.gmail.com>
	<CAAEAJfCBBNC_Oj-pzVQWQV-hMFY99s+C6WdY+F+fDjjRBLk+qA@mail.gmail.com>
	<CAHwmhgEr_4thdArs3pNydpS-R2squ0ZV6g0cGcTg2Gg2OrmBSw@mail.gmail.com>
	<CAAEAJfCZ38DY8wx+vdqv=wVjDf+C6GD8ggR5cqKB9zVXOPKg_Q@mail.gmail.com>
	<CAHwmhgF-pYouHctHCy-d-uF4mDm-ZRd7kjJbxXRZ_9cKWG98fQ@mail.gmail.com>
Date: Mon, 7 Dec 2015 15:00:23 -0300
Message-ID: <CAAEAJfC2QuW9Dgg1Y50D=gMaE5qufZWhZLr7P2E389rWmTv8hg@mail.gmail.com>
Subject: Re: Sabrent (stk1160) / Easycap driver problem
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Philippe Desrochers <desrochers.philippe@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(shoot, we dropped the ML somewhere along the conversation)

>> On 7 December 2015 at 12:32, Philippe Desrochers
>> <desrochers.philippe@gmail.com> wrote:
>> > Hello again,
>> >
>> > I open the device and I saw the following chips:
>> >
>> > SYNTEK:
>> > STK1160DLQG
>> > D7A155G-1513
>> >
>> > VIDEO DECODER:
>> > CJC7113
>> >
>> > AUDIO:
>> > ALC655
>> > 64231N1 L620D
>> >
>> > It seems the video decoder is a clone of the Philips SAA7113.
>> > Do you know if the CJC7113 is supported by the STK1160 linux driver ?
>> >
>>
>> It will probably work, being a clone of saa7113. But for some reason,
>> saa7115 is not detecting it. Maybe you can try to debug that and see
>> what's going on?


On 7 December 2015 at 14:45, Philippe Desrochers
<desrochers.philippe@gmail.com> wrote:
> Yes, I will try. I'm still not very experienced with linux kernel/driver...
> I think I can manage that since I have a good background in embedded system
> (Microcontroller).
>
> In just few lines, can you tell me how the STK1160 and SA7115 are related to
> each other ?
> Can I see it as 2 independent modules ? (I mean with SA7115 loaded first and
> then STK1160 loaded after only if the first module is OK ?)
>

Sure. On the hardware side, stk1160 is the USB chipset, while the
saa7115-compatible IC is the analog video decoder chip. stk1160 and
saa7115 talk through a I2C bus that's in the capture card.

On the software side, we have a similar model: the stk1160 driver
deals with the USB data and the saa7115 driver talks to the decoder
chip (through the I2C bus). Since saa7115 talks through I2C, you'll
find it under drivers/media/i2c.

stk1160 creates a subdevice that is owned by saa7115 driver. The
latter knows there's a chip on some i2c address, and then probes for
the type if chip.

I believe probing is done on saa711x_detect_chip(). To support your
device, we may have to create a new supported model here:

enum saa711x_model {
        SAA7111A,
        SAA7111,
        SAA7113,
        GM7113C,
        SAA7114,
        SAA7115,
        SAA7118,
};

If you grep GM7113C through the sources you'll be able to see how
differences between models are handled. Maybe your chip is not really
different from GM7113C or SAA7113 and all we need is to make sure it's
detected.

Don't hesitate to ask for more help over here.
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
