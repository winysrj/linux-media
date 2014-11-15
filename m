Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:51962 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaKOKlo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Nov 2014 05:41:44 -0500
Received: by mail-wg0-f45.google.com with SMTP id x12so21500350wgg.18
        for <linux-media@vger.kernel.org>; Sat, 15 Nov 2014 02:41:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <525911416014537@web7h.yandex.ru>
References: <1918522.5V5b9CGsli@computer>
	<5466A606.8030805@iki.fi>
	<525911416014537@web7h.yandex.ru>
Date: Sat, 15 Nov 2014 12:41:42 +0200
Message-ID: <CAAZRmGw=uLyS+enctwq0To8Gc1dAeG6EZgE+t0v80gBEXg=H5A@mail.gmail.com>
Subject: Re: [PATCH 1/3] tuners: si2157: Si2148 support.
From: Olli Salonen <olli.salonen@iki.fi>
To: CrazyCat <crazycat69@narod.ru>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

What about defining the firmware for Si2148-A20, but since the file is
the same as Si2158-A20 just point to the same file?

#define SI2148_A20_FIRMWARE "dvb-tuner-si2158-a20-01.fw"

Then if Si2158-A20 would in the future get a new firmware that would
not work with Si2148, this would not break Si2148.

Another point that came to my mind is that we start to have quite a
list of chips there in the printouts (Si2147/Si2148/Si2157/Si2158) and
more is coming - I'm working with an Si2146 device currently. Should
we just say "Si214x/Si215x" there or something?

Cheers,
-olli

On 15 November 2014 03:22, CrazyCat <crazycat69@narod.ru> wrote:
> 2148 is 2158 without analog support. Same firmware.
>
> 15.11.2014, 03:02, "Antti Palosaari" <crope@iki.fi>:
>> I wonder if we should define own firmware for Si2148-A20 just for sure.
>> Olli?
