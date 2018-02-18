Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:53571 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751659AbeBRVS0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Feb 2018 16:18:26 -0500
Subject: Re: [PATCH V2 0/3] Add timers to en50221 protocol driver
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com,
        d.scheller@gmx.net
References: <1513862559-19725-1-git-send-email-jasmin@anw.at>
 <ef72a382-5d30-526c-ae09-ed50d9d4790d@anw.at>
 <23177.59478.243278.702389@morden.metzler>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <2c7a385f-2d98-a30e-6714-ab6aa86288d2@anw.at>
Date: Sun, 18 Feb 2018 22:18:19 +0100
MIME-Version: 1.0
In-Reply-To: <23177.59478.243278.702389@morden.metzler>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hallo Ralph!

> 1. The SW bit is cleared too early during the whole buffer size negotiation.
> This should be fixed.
I will look into this when I have time again. Probably end of next week.

> 2. IRQEN = CMDREG_DAIE = 0x80 is always set in the command register.
> So, they should probably only be used if both the host and module say they
> support it.
How can we know that in the driver?
I haven't seen an API for this.
There is the flag "da_irq_supported", which might be used to set the IRQEN
bit it the bit is set.

Any suggestions how to proceed with item 2?

BR,
   Jasmin
