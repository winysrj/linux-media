Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:35703 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753556AbdGJPkf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 11:40:35 -0400
Received: by mail-wr0-f173.google.com with SMTP id k67so143326296wrc.2
        for <linux-media@vger.kernel.org>; Mon, 10 Jul 2017 08:40:35 -0700 (PDT)
Date: Mon, 10 Jul 2017 17:40:31 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, jasmin@anw.at, d_spingler@gmx.de
Subject: Re: [PATCH 1/4] [media] dvb-frontends: MaxLinear MxL5xx DVB-S/S2
 tuner-demodulator driver
Message-ID: <20170710174031.608b35b5@audiostation.wuest.de>
In-Reply-To: <22883.15775.467965.425483@morden.metzler>
References: <20170709194246.10334-1-d.scheller.oss@gmail.com>
        <20170709194246.10334-2-d.scheller.oss@gmail.com>
        <22883.15775.467965.425483@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mon, 10 Jul 2017 10:41:03 +0200
schrieb Ralph Metzler <rjkm@metzlerbros.de>:

> Daniel Scheller writes:
>  > From: Daniel Scheller <d.scheller@gmx.net>
>  > 
>  > This adds the frontend driver for the MaxLinear MxL5xx family of
>  > tuner- demodulators, as used on Digital Devices MaxS4/8
>  > four/eight-tuner cards.
>  > 
>  > The driver was picked from the dddvb vendor driver package and -
>  > judging solely from the diff - has undergone a 100% rework:
>  > 
>  >  - Silly #define's used to pass multiple values to functions were
>  >    expanded. This resulted in macro/register names not being usable
>  >    anymore for such occurences, but makes the code WAY more read-,
>  >    understand- and maintainable.  
> 
> OK, but why did you also replace all kinds of register value defines
> with numerical values? This makes the driver much less comprehensible.

I actually tried to put named identifiers back in as I don't feel very
comfortable with just plain hex numbers, there aren't even that many
registers that get accessed. But as I tried to do (based on the
original _regs.h), I quickly found out that one register can belong to
many identifiers, with the only difference being the bitshift and
bitcount, so without knowing the correct names this ends up in lottery
style, which isn't good either. If you have some documentation on this
and can provide that, we can put names back in place of course.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
