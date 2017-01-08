Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33027 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753077AbdAHSDc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Jan 2017 13:03:32 -0500
Received: by mail-lf0-f66.google.com with SMTP id k62so7195983lfg.0
        for <linux-media@vger.kernel.org>; Sun, 08 Jan 2017 10:03:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5c13f750-52d1-e8bd-d8f1-f00b8ca6c794@gmail.com>
References: <5c13f750-52d1-e8bd-d8f1-f00b8ca6c794@gmail.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sun, 8 Jan 2017 19:03:09 +0100
Message-ID: <CAFBinCAmdCz5UhjY148EmKAwKo=RKwz3G+J=Wme4g3HO70mCpQ@mail.gmail.com>
Subject: Re: astrometa device driver
To: dmiosga6200@gmail.com
Cc: crope@iki.fi, mchehab@s-opensource.com,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Dieter,

(I CC'ed the linux-media mailing list so other users can look this up
when they run into the same problem)

On Sun, Jan 8, 2017 at 7:27 PM, Dieter Miosga <dmiosga6200@gmail.com> wrote:
> Happy 2017!
>
> One of the parts that were placed under my imaginary Christmas tree was an
> Astrometa Hybrid TV DVB-T/T2/C/FM/AV USB 2.0 stick with
> Conexant CX23102
that should be supported through the cx231xx driver

> Rafael Micro R828D
supported by the r820t driver

> Panasonic MN88473
supported by the mn88473 driver

> It was not recognized by the latest kernel versions 4.8-4.10.
> If I can ever help you to integrate this device in your work,
> I would be happy!
can you show us the USB vendor/device ID of this device (please run
"lsusb -vv" and paste the whole block which belongs to your device)?

it seems that the required card definition is missing in
drivers/media/usb/cx231xx/cx231xx-cards.c along with some code that
connects the tuner and demodulator in
drivers/media/usb/cx231xx/cx231xx-dvb.c (there may be more TODOs: for
example fiddling with GPIOs, but if you're lucky this is not required)


Regards,
Martin
