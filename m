Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:32897 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbcHHFzA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2016 01:55:00 -0400
Received: by mail-oi0-f52.google.com with SMTP id c15so1785979oig.0
        for <linux-media@vger.kernel.org>; Sun, 07 Aug 2016 22:55:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
References: <20160626210622.5257-1-martin.blumenstingl@googlemail.com> <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
From: Kevin Hilman <khilman@baylibre.com>
Date: Sun, 7 Aug 2016 22:54:59 -0700
Message-ID: <CAOi56cV=mELtvUVAB8M=x6abfjQ-8dBj4HH8Xieuv14g8ppgWA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Add Meson 8b / GXBB support to the IR driver
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org,
	Rob Herring <robh+dt@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Carlo Caione <carlo@caione.org>, mchehab@kernel.org,
	devicetree <devicetree@vger.kernel.org>,
	Neil Armstrong <narmstrong@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Tue, Jun 28, 2016 at 12:17 PM, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> Newer Amlogic platforms (Meson 8b and GXBB) use a slightly different
> register layout for their Infrared Remoete Controller. The decoder mode
> is now configured in another register. Without the changes to the
> meson-ir driver we are simply getting incorrect "durations" reported
> from the hardware (because the hardware is not in time measurement aka
> software decode mode).
>
> This problem was also noticed by some people trying to use this on an
> ODROID-C1 and ODROID-C2 - the workaround there (probably because the
> datasheets were not publicy available yet at that time) was to switch
> to ir_raw_event_store_edge (which leaves it up to the kernel to measure
> the duration of a pulse). See [0] and [1] for the corresponding
> patches.

I tried this on meson-gxbb-p200 and I'm not seeing any button press
events with evtest or ir-keytable when using the Amlogic remote that
came with the board.  Below is the register dump you requested on IRC:

[    1.068347] Registered IR keymap rc-empty
[    1.072422] input: meson-ir as
/devices/platform/soc/c8100000.aobus/c8100580.ir/rc/rc0/input0
[    1.080814] rc rc0: meson-ir as
/devices/platform/soc/c8100000.aobus/c8100580.ir/rc/rc0
[    1.088839] input: MCE IR Keyboard/Mouse (meson-ir) as
/devices/virtual/input/input1
[    1.096519] rc rc0: lirc_dev: driver ir-lirc-codec (meson-ir)
registered at minor = 0
[    1.104119] meson-ir c8100580.ir: receiver initialized
[    1.109172] IR: reg 0x00 = 0x01d801ac
[    1.112795] IR: reg 0x04 = 0x00f800ca
[    1.116416] IR: reg 0x08 = 0x007a0066
[    1.120037] IR: reg 0x0c = 0x0044002c
[    1.123660] IR: reg 0x10 = 0x70fa0009
[    1.127278] IR: reg 0x14 = 0x00000000
[    1.130907] IR: reg 0x18 = 0x08915c00
[    1.134527] IR: reg 0x1c = 0x00009f44
[    1.138152] IR: reg 0x20 = 0x00000002

Kevin
