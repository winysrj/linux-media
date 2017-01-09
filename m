Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:34260 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756374AbdAHXxb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Jan 2017 18:53:31 -0500
Received: by mail-wj0-f195.google.com with SMTP id qs7so45805948wjc.1
        for <linux-media@vger.kernel.org>; Sun, 08 Jan 2017 15:53:30 -0800 (PST)
Reply-To: dmiosga6200@gmail.com
Subject: Re: astrometa device driver
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: crope@iki.fi, mchehab@s-opensource.com,
        linux-media <linux-media@vger.kernel.org>
References: <5c13f750-52d1-e8bd-d8f1-f00b8ca6c794@gmail.com>
 <CAFBinCAmdCz5UhjY148EmKAwKo=RKwz3G+J=Wme4g3HO70mCpQ@mail.gmail.com>
From: Dieter Miosga <dmiosga6200@gmail.com>
Message-ID: <b6ddf229-38ac-3c2b-cab4-3d8650e4a0ea@gmail.com>
Date: Mon, 9 Jan 2017 00:54:28 +0000
MIME-Version: 1.0
In-Reply-To: <CAFBinCAmdCz5UhjY148EmKAwKo=RKwz3G+J=Wme4g3HO70mCpQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I already tried to load the appropriate drivers.
The device is _not_ recognized with the cx231xx, r820t, mn88473 drivers 
as well

Many thanks ahead
Dieter

On 01/08/17 18:03, Martin Blumenstingl wrote:
> Hello Dieter,
>
> (I CC'ed the linux-media mailing list so other users can look this up
> when they run into the same problem)
>
> On Sun, Jan 8, 2017 at 7:27 PM, Dieter Miosga <dmiosga6200@gmail.com> wrote:
>> Happy 2017!
>>
>> One of the parts that were placed under my imaginary Christmas tree was an
>> Astrometa Hybrid TV DVB-T/T2/C/FM/AV USB 2.0 stick with
>> Conexant CX23102
> that should be supported through the cx231xx driver
>
>> Rafael Micro R828D
> supported by the r820t driver
>
>> Panasonic MN88473
> supported by the mn88473 driver
>
>> It was not recognized by the latest kernel versions 4.8-4.10.
>> If I can ever help you to integrate this device in your work,
>> I would be happy!
> can you show us the USB vendor/device ID of this device (please run
> "lsusb -vv" and paste the whole block which belongs to your device)?
>
> it seems that the required card definition is missing in
> drivers/media/usb/cx231xx/cx231xx-cards.c along with some code that
> connects the tuner and demodulator in
> drivers/media/usb/cx231xx/cx231xx-dvb.c (there may be more TODOs: for
> example fiddling with GPIOs, but if you're lucky this is not required)
>
>
> Regards,
> Martin
>

