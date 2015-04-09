Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37015 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbbDITeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2015 15:34:31 -0400
Received: by wiaa2 with SMTP id a2so896806wia.0
        for <linux-media@vger.kernel.org>; Thu, 09 Apr 2015 12:34:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150406184100.GA23493@hardeman.nu>
References: <CAK-SLvBcZG5VN4BkUV+jS0z_xqXpVwJFMXfMaQF7kfFxJ7En9A@mail.gmail.com>
	<20150406184100.GA23493@hardeman.nu>
Date: Thu, 9 Apr 2015 21:34:30 +0200
Message-ID: <CAK-SLvCOeL+9Sa20KcDjhsa3t0jho73gdjuLYjXKVYr4P1KzcQ@mail.gmail.com>
Subject: Re: using TSOP receiver without lircd
From: Sergio Serrano <sergio.badalona@gmail.com>
To: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you David

I'm following your clues

I've contacted Jarod Wilson (redhat), too. If it can be useful to the
list, bellow you can find his thoughts.

Thank you both!

Sergio

On Mon, Apr 06, 2015 at 06:08:51PM +0200, Sergio Serrano wrote:
> Thank you Jarod for promptly reply.
> Great to hear that!
>
> I'm using omap2 (interrupt+gpio) and
> https://github.com/hani93/lirc_bbb module (I've got already  /dev/lirc
> device).

That driver isn't going to work, its written for lirc. You need a driver
written for the in-kernel IR subsystem. See drivers/media/rc/fintek-cir.c
and friends (iguanair.c, imon.c, winbond-cir.c, nuvoton-cir.c, etc).

> Using the method you mention is it still possible? Or it is only
> possible for usb receivers ?

Physical interface doesn't matter. The driver interfaces do. You'd have to
rewrite lirc_bbb to rc-core interfaces instead of lirc interfaces.

2015-04-06 20:41 GMT+02:00 David Härdeman <david@hardeman.nu>:
> On Mon, Apr 06, 2015 at 06:01:52PM +0200, Sergio Serrano wrote:
>>Hi members!
>>
>>In the hope that someone can help me, I has come to this mailing list after
>>contacting David Hardeman (thank you!).
>>He has already given me some clues. This is my scenario.
>>
>>I'm using a OMAP2 processor and capturing TSOP34836 (remote RC5 compatible)
>>signals through GPIO+interrupt. I have created the /dev/lirc0 device , here
>>comes my question: If possible I don't want to deal with LIRC and irrecord
>>stuff. Is it possible? What will be the first steps?
>
> Your next step would be a kernel driver that receives the GPIO
> interrupts and feeds them into rc-core as "edge" events.
>
> drivers/media/rc/gpio-ir-recv.c is probably what you want as a starting
> point (though you'll need to find a way to feed it the right
> parameters...)
>
> Regards,
> David
>
