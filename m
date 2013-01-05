Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:48596 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3AENls (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2013 08:41:48 -0500
Received: by mail-ee0-f50.google.com with SMTP id b45so8700053eek.23
        for <linux-media@vger.kernel.org>; Sat, 05 Jan 2013 05:41:47 -0800 (PST)
Message-ID: <50E82DB2.4070405@googlemail.com>
Date: Sat, 05 Jan 2013 14:42:10 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/4] Some IR fixes for I2C devices on em28xx
References: <1357334152-3811-1-git-send-email-mchehab@redhat.com> <50E82900.9060701@googlemail.com>
In-Reply-To: <50E82900.9060701@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 05.01.2013 14:22, schrieb Frank Schäfer:
> Am 04.01.2013 22:15, schrieb Mauro Carvalho Chehab:
>> Frank pointed that IR was not working with I2C devices. So, I took some
>> time to fix them.
>>
>> Tested with Hauppauge WinTV USB2.
>>
>> Mauro Carvalho Chehab (4):
>>   [media] em28xx: initialize button/I2C IR earlier
>>   [media] em28xx: autoload em28xx-rc if the device has an I2C IR
>>   [media] em28xx: simplify IR names on I2C devices
>>   [media] em28xx: tell ir-kbd-i2c that WinTV uses an RC5 protocol
>>
>>  drivers/media/usb/em28xx/em28xx-cards.c |  2 +-
>>  drivers/media/usb/em28xx/em28xx-input.c | 29 ++++++++++++++++-------------
>>  2 files changed, 17 insertions(+), 14 deletions(-)
>>
> While these patches make I2C IR remote controls working again, they
> leave several issues unaddressed which should really be fixed:
> 1) the i2c client isn't unregistered on module unload. This was the
> reason for patch 2 in my series. There is also a FIXME comment about
> this in em28xx_release_resources() (although this is the wrong place to
> do it).
> 2) there is no error checking in em28xx_register_i2c_ir().
> em28xx_ir_init should really bail out if no i2c device is found.
> 3) All RC maps should be assigned at the same place, no matter if the
> receiver/demodulator is built in or external. Spreading them over the
> code is inconsistent and makes the code bug prone.
> 4) the list of known i2c devices in em28xx-i2c.c misses client address
> 0x3e >> 1 = 0x1f. See client list in em28xx_register_i2c_ir().
> 5) there should be a warning message for the case that we call
> ir-kbd-i2c with an unknown rc device.
> 6) because we use our own key polling functions with ir-kbd-i2c, we
> should also select the polling interval value manually. That makes
> things consistent and avoids confusion.
>
> The rest is a matter of taste / prefered code layout. I'm fine with it.
>
> Regards,
> Frank

It seems like already applied them... :(

While I certainly appreciate patches beeing applied as soon as possible,
I think there should really be a chance to review them before this happens.
Especially when the changes are non-trivial and someone else has posted
patches addressing the same issues before (other contributers might feel
offended ;) ).

Care to fix these issues ?

Regards,
Frank



