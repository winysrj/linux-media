Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:42566 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751041AbdEaMa6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 08:30:58 -0400
Received: from mail-oi0-f51.google.com (mail-oi0-f51.google.com [209.85.218.51])
        by imap.netup.ru (Postfix) with ESMTPSA id D1DBB8B3F9F
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 15:30:56 +0300 (MSK)
Received: by mail-oi0-f51.google.com with SMTP id h4so13124764oib.3
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 05:30:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK3bHNW9sM0fZFqYEX-mEhv-Rax82u25KdgjQftGcoY6wV1O0A@mail.gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
 <20170528234738.6726df65@macbox> <CAK3bHNW9sM0fZFqYEX-mEhv-Rax82u25KdgjQftGcoY6wV1O0A@mail.gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Wed, 31 May 2017 08:30:34 -0400
Message-ID: <CAK3bHNVu9_x492P+KQQHEVe8HOCvnktPaLSyHjRgMN_svQ56+A@mail.gmail.com>
Subject: Re: [PATCH 00/19] cxd2841er/ddbridge: support Sony CXD28xx hardware
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: Kozlov Sergey <serjk@netup.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>, rjkm@metzlerbros.de
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

I have ack'ed all patches related to cxd2841er. Please check am i
missing something ?

I see some good flags (CXD2841ER_NO_WAIT_LOCK and
CXD2841ER_EARLY_TUNE). I should check it for our boards too :)

2017-05-30 10:31 GMT-04:00 Abylay Ospan <aospan@netup.ru>:
> Hi Daniel,
>
> I have checked your patches. Basically it looks good:
>  * compilation is clean (no warnings)
>  * Our card (NetUP Universal DVB Rev 1.4) works fine with this patches
>  * All patches looks reasonable and don't break other cards
>  * All patches has good comments
>
> I will send ack's to ML.
>
> Thanks for your work !
>
> 2017-05-28 17:47 GMT-04:00 Daniel Scheller <d.scheller.oss@gmail.com>:
>>
>> Am Sun,  9 Apr 2017 21:38:09 +0200
>> schrieb Daniel Scheller <d.scheller.oss@gmail.com>:
>>
>>
>> > Important note: This series depends on the stv0367/ddbridge series
>> > posted earlier (patches 12 [1] and 13 [2], depending on the I2C
>> > functions and the TDA18212 attach function).
>> >
>> > This series improves the cxd2841er demodulator driver and adds some
>> > bits to make it more versatile to be used in more scenarios. Also,
>> > the ddbridge code is updated to recognize all hardware (PCIe
>> > cards/bridges and DuoFlex modules) with Sony CXD28xx tuners,
>> > including the newly introduced MaxA8 eight-tuner C2T2 cards.
>> >
>> > The series has been tested (together with the STV0367 series) on a
>> > wide variety of cards, including CineCTv7, DuoFlex C(2)T2 modules and
>> > MaxA8 cards without any issues. Testing was done with TVHeadend, VDR
>> > and MythTV.
>> >
>> > Note that the i2c_gate_ctrl() flag is needed in this series aswell
>> > since the i2c_gate_ctrl function needs to be remapped and mutex_lock
>> > protected for the same reasons as in the STV0367 series.
>> >
>> > Besides printk() warnings, checkpatch.pl doesn't complain.
>>
>> Ping on this series aswell.
>>
>> Abylay, would you please mind taking a look at the cxd2841er changes
>> and check if you're fine with them?
>>
>> Regards,
>> Daniel
>
>
>
>
> --
> Abylay Ospan,
> NetUP Inc.
> http://www.netup.tv



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
