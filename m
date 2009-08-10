Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:36675 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbZHJWjA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 18:39:00 -0400
Received: by gxk9 with SMTP id 9so4603972gxk.13
        for <linux-media@vger.kernel.org>; Mon, 10 Aug 2009 15:39:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A809EE7.10009@email.it>
References: <4A79EC82.4050902@email.it> <4A809EE7.10009@email.it>
Date: Mon, 10 Aug 2009 18:39:01 -0400
Message-ID: <829197380908101539m48f17c69n119cb52f636502ab@mail.gmail.com>
Subject: Re: New device: Dikom DK-300 (maybe Kworld 323U rebranded)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: xwang1976@email.it
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 10, 2009 at 6:27 PM, <xwang1976@email.it> wrote:
> Hi,
> my brother has brought a Dikom DK-300 usb hybrid tv receiver.
> He will use it under windows, but I've tried it with the latest v4l-dvb
> driver and I've discovered that it works well as analog tv (video and audio
> work using the sox command to send audio from /dev/dsp1 to /dev/dsp).
> The digital tv doesn't work (in kaffeine the digital tv icon is not
> present).
> I post the dmesg obtained connecting the device.
> If you want I can test for the next 10 days.
> Thank you,
> Xwang
>
<snip>

Hello Xwang,

In order to add support for the digital side of the device, we would
need to know which demodulator chip is in the device (which you could
get by opening it up).

Alternatively, if you can get a SniffUSB 2.0 capture under Windows,
from the time the device is plugged in, until after the device is
tuned to a digital station, we can probably extrapolate which demod it
has.  We're going to need the Windows USB trace anyway in order to
identify what the proper GPIO configuration is.

Personally, I'm not confident I will be able to debug this issue
within the next ten days (I'm about to leave town for the next six
days and I'm already swamped with other work), although some other
developer may be willing to step in and lend a hand.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
