Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:33470 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756022AbdAKROP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 12:14:15 -0500
Received: by mail-ua0-f182.google.com with SMTP id i68so411136222uad.0
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2017 09:14:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8aa6b3c4-5fcb-d67c-040e-4220e30658f2@kaa.org.ua>
References: <20170111100819.2190-1-oleg@kaa.org.ua> <CALzAhNXJYtg+wpmq48DKzznyO2NvmrQYONxK_-Ajb_UESEXrCg@mail.gmail.com>
 <8e391d70-1b4c-3bb9-08d9-409bb139ef7e@kaa.org.ua> <CALzAhNWdJRvVLRcv05eZugSR3bYZ9Tmrd+tfMGab=VadTOngJA@mail.gmail.com>
 <8aa6b3c4-5fcb-d67c-040e-4220e30658f2@kaa.org.ua>
From: Steven Toth <stoth@kernellabs.com>
Date: Wed, 11 Jan 2017 12:14:14 -0500
Message-ID: <CALzAhNXsLx42+1F+4URfhPoLO+ncjCYnjAWZyyLibL0-FQnPug@mail.gmail.com>
Subject: Re: Broken cx231xx-i2c.c
To: Oleh Kravchenko <oleg@kaa.org.ua>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Jacob Johan (Hans) Verkuil" <hverkuil@xs4all.nl>,
        Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 11, 2017 at 9:39 AM, Oleh Kravchenko <oleg@kaa.org.ua> wrote:
> Hello!
>
> So, I tried to split i2c send messages to 5, 8, 16 bytes - that cause error:
>     cx231xx 3-1:1.1: cx231xx_send_usb_command: failed with status --32
>
> This problem occurred only with Si2158 tuner,
> demodulator Si2168 eats up to 15 bytes per i2c message.
>
> I think problem in cx231xx_send_vendor_cmd() function.
> It's split reading, but not writing.
>
> PS: I use USB sniffer to capture traffic, please find it in attachment.

Do you have a logic analyzer so you can inspect the I2C bus state? I'm
speaking as someone who's done significant reverse engineering
projects on many pieces of hardware, you'll get a much better
understanding of platform specific I2C problems if you can see the bus
directly.

Any such issues tend to propagate upwards through micro-controller
interfaces (cx231xx) and its much more obvious to deal with the
controller problem when the state of the bus is absolutely known.

I have no objections to a I2C bus controller implementation splitting
reads and writes in a uniform and generic way, assuming windows is
doing the same thing, providing that approach applies to all attached
devices. We don't want board specific hacks infecting the various
drivers......... unless we're absolutely clear as to why...... and we
don't want to see I2C controller limitations infecting I2C demod/tuner
drivers where at all possible.

If its true that send_vendor_cmd() splits reads but not writes, fix
the function to be uniform for all boards. Don't do boards specific
overrides.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
