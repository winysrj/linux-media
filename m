Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48659 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab0GHCM7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 22:12:59 -0400
Received: by ewy23 with SMTP id 23so79228ewy.19
        for <linux-media@vger.kernel.org>; Wed, 07 Jul 2010 19:12:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C353039.4030202@gmail.com>
References: <4C353039.4030202@gmail.com>
Date: Wed, 7 Jul 2010 22:12:57 -0400
Message-ID: <AANLkTikiCtPhE8uERNoYV_UF43MZU0YQgPWxyA4X0l5U@mail.gmail.com>
Subject: Re: em28xx: success report for KWORLD DVD Maker USB 2.0 (VS-USB2800)
	[eb1a:2860]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ivan <ivan.q.public@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 7, 2010 at 9:56 PM, Ivan <ivan.q.public@gmail.com> wrote:
> I recently purchased ($20 special deal from newegg; the price has gone back
> up) the following USB stick that captures composite video and S-video (no TV
> tuner):
>
> KWORLD DVD Maker USB 2.0 (VS-USB2800)
>
> It seemed likely to be supported by the em28xx driver, and I'm pleased to
> report that, in fact, it is!

Yup, it's supported.

> Does the em28xx driver load a firmware?

No firmware is involved at all for this device.  The Merlin ROM you
are seeing is for other devices that use the same underlying driver.

> Also, any firmware that gets loaded only persists until the device is
> unplugged, right? And so my prior successful test on Windows has nothing to
> do with my later success on Linux... just want to be sure about that. I also
> tried testing with Windows in Virtualbox, but had no luck-- does anyone know
> if this should be possible? (I can provide more info about my virtualbox
> testing if anyone's interested.)

Again, no firmware involved, and there is no transient state from
Windows to Linux.  Do a cold boot into Linux and you will see the
device works fine.

VirtualBox performs poorly with devices of this nature because the USB
emulation isn't really designed for high-speed realtime delivery of
video (and an uncompressed analog stream is about 20MB/sec).

> I guess the part about the snapshot button means that I can use the push
> button on the USB stick to trigger stuff if I want (yay!), but I have no
> idea how to make that actually happen.

If your device actually has a physical button on it then yes it will
work.  The driver will generate a "KEY_CAMERA" input event via
inputdev (similar to a keyboard event).  Read up on inputdev to see
how to write a userland application which can see it.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
