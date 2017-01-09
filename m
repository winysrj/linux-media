Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35660 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752188AbdAIApJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Jan 2017 19:45:09 -0500
Received: by mail-lf0-f65.google.com with SMTP id v186so4287509lfa.2
        for <linux-media@vger.kernel.org>; Sun, 08 Jan 2017 16:45:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3322ca41-8b4a-e0a1-95d7-79891b2899ce@gmail.com>
References: <5c13f750-52d1-e8bd-d8f1-f00b8ca6c794@gmail.com>
 <CAFBinCAmdCz5UhjY148EmKAwKo=RKwz3G+J=Wme4g3HO70mCpQ@mail.gmail.com> <3322ca41-8b4a-e0a1-95d7-79891b2899ce@gmail.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Mon, 9 Jan 2017 01:44:47 +0100
Message-ID: <CAFBinCDXg3irVYk=g3LZHixdfmjciZetDozV=CvndVG6KfJ3rQ@mail.gmail.com>
Subject: Re: astrometa device driver
To: dmiosga6200@gmail.com
Cc: crope@iki.fi, mchehab@s-opensource.com,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 9, 2017 at 1:45 AM, Dieter Miosga <dmiosga6200@gmail.com> wrote:
> Here's the result of the lsusb on the HanfTek 15f4:0135
This USB ID is not registered with the cx231xx driver yet - thus the
driver simply ignores your device.
The basics steps for adding support for your card would be:
1. add new "#define CX231XX_BOARD_..." in cx231xx.h
2. add new entry to cx231xx_boards[] in cx231xx-cards.c with the
correct values (NOTE: has to figure out the correct values, maybe
Antti can give a hint which of the existing boards could be used as
staring point)
3. add a new entry to cx231xx_id_table (with USB vendor/device IDs) in
cx231xx-cards.c
4. add r820t_config to cx231xx-dvb.c (maybe you can even copy the one
from rtl28xxu.c)
5. add mn88473_config to cx231xx-dvb.c (again, copying the one from
rtl28xxu.c may work)
6. add a new case statement to dvb_init in cx231xx-dvb.c and connect
the rt820t_config and mn88473_config (you can probably use the code of
another board and adapt it accordingly)
7. test + bugfix :)


Regards,
Martin
