Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38758 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbcKZTx7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Nov 2016 14:53:59 -0500
Received: by mail-wm0-f51.google.com with SMTP id f82so119811511wmf.1
        for <linux-media@vger.kernel.org>; Sat, 26 Nov 2016 11:53:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1479029376-31850-2-git-send-email-crope@iki.fi>
References: <1479029376-31850-1-git-send-email-crope@iki.fi> <1479029376-31850-2-git-send-email-crope@iki.fi>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sat, 26 Nov 2016 20:53:37 +0100
Message-ID: <CAFBinCA17B=QYAkQ-ooPne7=bC=BwQmJ5O3OxLnuGxHHYvYj0g@mail.gmail.com>
Subject: Re: [PATCH 2/2] mn88473: refactor and fix statistics
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 13, 2016 at 10:29 AM, Antti Palosaari <crope@iki.fi> wrote:
> Remove DVB-T2 BER as it does not work at all and I didn't find
> how to fix.
>
> Fix DVB-T and DVB-C BER. It seems to return new some realistic
> looking values.
>
> Use (1 << 64) base for CNR calculations to keep it in line with
> dvb logarithm functions.
>
> Move all statistic logic to mn88473_read_status() function.
>
> Use regmap_bulk_read() for reading multiple registers as a one go.
>
> And many more and less minor changes.
>
> Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Tested successfully on DVB-C (only, since DVB-T2 is unavailable and
DVB-T reception is *very* bad here).
