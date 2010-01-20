Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:54485 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab0ATSbP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 13:31:15 -0500
Received: by fxm20 with SMTP id 20so402015fxm.1
        for <linux-media@vger.kernel.org>; Wed, 20 Jan 2010 10:31:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <135ab3ff1001200926j9917d69x51eede94512fa664@mail.gmail.com>
References: <135ab3ff1001200926j9917d69x51eede94512fa664@mail.gmail.com>
Date: Wed, 20 Jan 2010 13:00:44 -0500
Message-ID: <829197381001201000x58aadea5wab0948691d9a4c4f@mail.gmail.com>
Subject: Re: Drivers for Eyetv hybrid
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Morten Friesgaard <friesgaard@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 20, 2010 at 12:26 PM, Morten Friesgaard
<friesgaard@gmail.com> wrote:
> Hello.
> I installed mythbuntu 9.10 this week on some old hardware, I had a
> Hauppauge 500MCE PVR in and made it work fairly easy. I'm used to
> gentoo
>
> However, I want to record HD signal, so I plugged in a Eyetv hybrid
> and followed this guide
> http://ubuntuforums.org/showthread.php?t=1015387
>
> I extracted the driver, put it in into /lib/firmware, modprobed
> em28xx, rebooted. When I plug in the device, it is not recognised. I
> tried both usb ports. The ID is "0fd9:0018", which is somewhat
> different from similar hardware e.g. Hauppauge wintv-hvr-950 (ID
> 2040:6513 http://www.linuxtv.org/wiki/index.ph..._WinTV-HVR-950 )

It's a totally different hardware design, nothing like the older
version of the EyeTV Hybrid (which was just a clone of the HVR-950).

It is unsupported currently (and nobody is working on it to my knowledge).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
