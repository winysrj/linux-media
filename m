Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:51629 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071AbZJLUOR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 16:14:17 -0400
Received: by fxm27 with SMTP id 27so9587790fxm.17
        for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 13:13:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AD3821C.5050306@proekspert.ee>
References: <4AD3821C.5050306@proekspert.ee>
Date: Mon, 12 Oct 2009 16:13:40 -0400
Message-ID: <829197380910121313s50fe7d34oe3fedbf7a5182a48@mail.gmail.com>
Subject: Re: DVB support for MSI DigiVox A/D II and KWorld 320U
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Lauri Laanmets <lauri.laanmets@proekspert.ee>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 12, 2009 at 3:23 PM, Lauri Laanmets
<lauri.laanmets@proekspert.ee> wrote:
> Hello
>
> I have KWorld 320U USB DVT-T Hybrid and trying to get DVB part working. The
> code from mcentral worked pretty well but as it is closed down now I would
> like to contribute to linux-media and enable and validate the hardware
> support for this device.
>
> I have:
>
> Linux 2.6.28-15-generic x86_64 GNU/Linux
> Bus 001 Device 002: ID eb1a:e320 eMPIA Technology, Inc.
>
> This device has the same id with "MSI DigiVox A/D II" but I guess it
> shouldn't matter because it appears to be exactly the same thing just with
> the different brand label with Zarlink ZL10353 DVB-T on both boards.
>
> I have downloaded the code from v4l-dvb and commented out the "#if 0" around
> the device dvb definition ( em28xx-cards.c ), also added it to frontend
> registration ( em28xx-dvb.c) the same as KWorld 310 - just a normal Zarlink
> attach function.
>
> The trouble is that I get an error:
>
> zl10353_read_register: readreg error (reg=127, ret==-19)
>
> and I cannot understand why. I have the mcentral code still lying around and
> comparing those codes doesn't seem to have any difference. Maybe there still
> is a magic bit somewhere to set?

In em28xx-dvb.c, try using "em28xx_zl10353_with_xc3028_no_i2c_gate" in
the dvb_attach() instead of "em28xx_zl10353_with_xc3028".
Alternatively, move the case line for your board further down so it's
the same as "EM2882_BOARD_TERRATEC_HYBRID_XS" instead of being the
same as "EM2880_BOARD_KWORLD_DVB_310U"

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
