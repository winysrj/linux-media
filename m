Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65507 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab2FVUzy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 16:55:54 -0400
Received: by obbuo13 with SMTP id uo13so2448763obb.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 13:55:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE4D5FF.70003@gmail.com>
References: <4FE4BC43.9070100@gmail.com>
	<CALF0-+VM902A0x+TNXB1qe_jhKcYOs6ti1hMZBsTuTe6Ucmpeg@mail.gmail.com>
	<4FE4C2BE.2060301@gmail.com>
	<CALF0-+V430u34yv8arUsN=N5Vh-cJs=7JJdiaEH_OonarJ065g@mail.gmail.com>
	<4FE4CA11.5030208@gmail.com>
	<CALF0-+X4gHGogHWaHUHMRGXbK5JjGZ0hgLOGRVMQx-QXV15tGg@mail.gmail.com>
	<4FE4CF8F.4050306@gmail.com>
	<CALF0-+WGL1_5ZgexDjfA6HM7D1+M3OUbu30HcaW6D4r1uOtM5w@mail.gmail.com>
	<4FE4D5FF.70003@gmail.com>
Date: Fri, 22 Jun 2012 17:55:54 -0300
Message-ID: <CALF0-+U2xcPoynRDkwodvGWoNOH0C6TUvUftKRw-AN4ZpL9h=g@mail.gmail.com>
Subject: Re: Tuner NOGANET NG-PTV FM
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Ariel Mammoli <cmammoli@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 22, 2012 at 5:30 PM, Ariel Mammoli <cmammoli@gmail.com> wrote:
> [   31.130403] saa7130/34: v4l2 driver version 0.2.16 loaded
> [   31.130543] saa7134 0000:04:05.0: PCI INT A -> GSI 16 (level, low) ->
> IRQ 16
> [   31.130548] saa7130[0]: found at 0000:04:05.0, rev: 1, irq: 16,
> latency: 64, mmio: 0xfbfffc00
> [   31.130553] saa7134: Board is currently unknown. You might try to use
> the card=<nr>
> [   31.130554] saa7134: insmod option to specify which board do you
> have, but this is
> [   31.130555] saa7134: somewhat risky, as might damage your card. It is
> better to ask
> [   31.130556] saa7134: for support at linux-media@vger.kernel.org.
>

I think this is self-explaining. It's saying the board type is
unknown. You can try with card=<nr> parameter.
I've never done this, but I guess you should try something like this:

rmmod saa7134
insmod saa7134 card=0
<try board>

rmmod saa7134
insmod saa7134 card=1
<try board>

...

rmmod saa7134
insmod saa7134 card=N
<try board>

Until it works. However, the driver itself is telling you this
procedure is *risky*,
so I don't know if you should try it :-(



> [   31.131151] saa7130[0]: subsystem: 1131:0000, board: UNKNOWN/GENERIC
> [card=0,autodetected]

Autodetected? This confuses me....



> [   31.131168] saa7130[0]: board init: gpio is 4040
> [   31.234360] saa7130[0]: Huh, no eeprom present (err=-5)?
> [   31.234680] saa7130[0]: registered device video1 [v4l2]
> [   31.234769] saa7130[0]: registered device vbi0
> [   31.244755] saa7134 ALSA driver for DMA sound loaded
> [   31.244759] saa7130[0]/alsa: UNKNOWN/GENERIC doesn't support digital
> audio
> [ 3949.521864] saa7134 ALSA driver for DMA sound unloaded
> [ 4107.188828] saa7130/34: v4l2 driver version 0.2.16 loaded
> [ 4107.188870] saa7130[0]: found at 0000:04:05.0, rev: 1, irq: 16,
> latency: 64, mmio: 0xfbfffc00
> [ 4107.188876] saa7130[0]: subsystem: 1131:0000, board: Compro VideoMate
> TV PVR/FM [card=40,insmod option]
> [ 4107.188895] saa7130[0]: board init: gpio is 4040

I guess you tried insmod saa7134 card=40 here, right?

At this point I really can't help you anymore;
let's hope someone with more experience can add something.

Sorry,
Ezequiel.
