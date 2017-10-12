Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:54743 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752631AbdJLAZO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 20:25:14 -0400
Received: by mail-qt0-f177.google.com with SMTP id z19so10480369qtg.11
        for <linux-media@vger.kernel.org>; Wed, 11 Oct 2017 17:25:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0D74D058-EE11-4BFF-974C-16DB6910D2CF@gmail.com>
References: <cover.1507618840.git.sean@mess.org> <176506027db4255239dc8ce192dc6652af75bd52.1507618840.git.sean@mess.org>
 <1507750996.2479.11.camel@gmail.com> <20171011210237.bpbfuhpf7om26ldi@gofer.mess.org>
 <0D74D058-EE11-4BFF-974C-16DB6910D2CF@gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Wed, 11 Oct 2017 20:25:12 -0400
Message-ID: <CAGoCfixQ6uLwbs7pQv5SzNkhP_Au18WrdNnM=Odi4JpbAn174w@mail.gmail.com>
Subject: Re: [PATCH v3 04/26] media: lirc_zilog: remove receiver
To: Andy Walls <awalls.cx18@gmail.com>
Cc: Sean Young <sean@mess.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> There's an ir_lock mutex in the driver to prevent simultaneous access to the Rx and Tx functions of the z8.  Accessing Rx and Tx functions of the chip together can cause it to do the wrong thing (sometimes hang?), IIRC.
>
> I'll see if I can dig up my old disassembly of the z8's firmware to see if that interlock is strictly necessary.
>
> Yes I know ir-kbd-i2c is in mainline, but as I said, I had reasons for avoiding it when using Tx operation of the chip.  It's been 7 years, and I'm getting too old to remember the reasons. :P

Yeah, you definitely don't want to be issuing requests to the Rx and
Tx addresses at the same time.  Very bad things will happen.

Also, what is the polling interval for ir-kbd-i2c?  If it's too high
you can wedge the I2C bus (depending on the hardware design).
Likewise, many people disable IR RX entirely (which is trivial to do
with lirc_zilog through a modprobe optoin).  This is because early
versions of the HDPVR had issues where polling too often can interfere
with traffic that configures the component receiver chip.  This was
improved in later versions of the design, but many people found it was
just easiest to disable RX since they don't use it (i.e. they would
use the blaster for controlling their STB but use a separate IR
receiver).

Are you testing with video capture actively in use?  If you're testing
the IR interface without an active HD capture in progress you're
likely to miss some of these edge cases (in particular those which
would hang the encoder).

I'm not against the removal of duplicate code in general, but you have
to tread carefully because there are plenty of non-obvious edge cases
to consider.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
