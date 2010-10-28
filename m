Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34018 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab0J1O1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 10:27:34 -0400
Received: by eye27 with SMTP id 27so1490787eye.19
        for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 07:27:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinHT_XPZJU9Xq2cScJoUUCfTps4PXFU9S2_fX=Q@mail.gmail.com>
References: <AANLkTinHT_XPZJU9Xq2cScJoUUCfTps4PXFU9S2_fX=Q@mail.gmail.com>
Date: Thu, 28 Oct 2010 10:27:32 -0400
Message-ID: <AANLkTim+JUKSJyb_YE3de-F16kjsnhja8wR8b9H1mHPm@mail.gmail.com>
Subject: Re: Kworld usb 2800D audio
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Tim Stowell <stowellt@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Oct 28, 2010 at 10:18 AM, Tim Stowell <stowellt@gmail.com> wrote:
> Hi,
>
> I'm able to capture video just fine with my  Kworld usb 2800D usb
> device and the recent (I've installed the April v4l-dvb em28xx
> driver), but I can't get any audio. I tried modprobe em28xx-alsa, and
> the module loads, but alsa can't find any sound cards. Do I need the
> snd-usb-audio driver? the usb device is based on the em2860 chip. Any
> help would be greatly appreciated, thanks.

Hello Tim,

If I recall, the KWorld 2800D doesn't actually capture audio directly
via the USB.  The device has a 2.5mm cable that you are required to
connect to our sound card's line-in.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
