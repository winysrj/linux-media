Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42252 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab2JGNw4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Oct 2012 09:52:56 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1618676bkc.19
        for <linux-media@vger.kernel.org>; Sun, 07 Oct 2012 06:52:55 -0700 (PDT)
Message-ID: <5071893F.9030002@googlemail.com>
Date: Sun, 07 Oct 2012 15:53:03 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: How to add support for the em2765 webcam Speedlink VAD Laplace
 to the kernel ?
References: <5032225A.9080305@googlemail.com> <50323559.7040107@redhat.com> <50328E22.4090805@redhat.com> <50337293.8050808@googlemail.com> <50337FF4.2030200@redhat.com> <5033B177.8060609@googlemail.com> <5033C573.2000304@redhat.com> <50349017.4020204@googlemail.com> <503521B4.6050207@redhat.com> <503A7097.4050709@googlemail.com> <505F16AD.8010909@googlemail.com> <20121006085624.128f7f2c@redhat.com> <CAGoCfiycAyFDpTvX+kJ9xChJdbQg+A-PLWencL6GN8PJYW546g@mail.gmail.com>
In-Reply-To: <CAGoCfiycAyFDpTvX+kJ9xChJdbQg+A-PLWencL6GN8PJYW546g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 07.10.2012 04:56, schrieb Devin Heitmueller:
> On Sat, Oct 6, 2012 at 7:56 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> AFAIKT, newer em28xx chips are using this concept. The em28xx-i2c code require
>> changes to support two I2C buses, and to handle 16 bit eeproms. We never cared
>> of doing that because we never needed, so far, to read anything from those
>> devices' eeproms.
> I actually wrote the code to read the 16-bit eeprom from the em2874,
> but removed it before submitting it upstream because I was afraid
> well-intentioned em28xx users trying to add support for their boards
> would trash their eeprom.  This is because performing a read against a
> 16-bit eeprom is equivalent to a write on an 8-bit eeprom.  Hence if
> the user didn't know what he/she was doing, and used the 16-bit eeprom
> code against an older eeprom, the eeprom would get trashed (this
> actually happened to me once when I was doing the em2874 device
> support originally).

Yes, I've read the comment in the code...

According to the (possibly outdated) em2580/em2585 datasheet I've found,
these chips support 16bit eeproms ONLY.
What do we know about the others ? Are there any chips which support
both 8bit and 16bit eeproms ?
Maybe we can make it depending on the chip_id.

With regards to eeprom type probing:
I've made some experiments to find out what happens when trying to
access the 16bit eeprom in my device as 8bit eeprom.
My hope was to get a clear result like an i2c error, no data or all
bytes beeing 0x00 or 0xff.
Unfortunately, there is no error and I'm getting random data (would have
to cerify if it's really "random").
So probing will be difficult.

> If we really want that code back in the tree, I can dig it up -- but I
> won't be responsible for users killing their devices.

Indeed, we should be very careful.

Regards,
Frank

> Devin
>


