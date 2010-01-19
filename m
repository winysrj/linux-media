Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:34437 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab0ASJk6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 04:40:58 -0500
Received: by yxe17 with SMTP id 17so4705120yxe.33
        for <linux-media@vger.kernel.org>; Tue, 19 Jan 2010 01:40:58 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 19 Jan 2010 10:40:58 +0100
Message-ID: <cd5259a81001190140l230785a1lab87b0b75040d323@mail.gmail.com>
Subject: newbie using TechniSat SkyStar HD2
From: Nicolae Mihalache <xpromache@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I just started with satellite TV and purchased a TechniSat SkyStar HD2
(not a brilliant start, I agree). I installed the mantis driver from
http://linuxtv.org/hg/v4l-dvb as explained on the wiki. It somehow
seems to work, dmesg shows:

[ 3116.783103] Mantis 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 3116.784165] DVB: registering new adapter (Mantis DVB adapter)
[ 3117.652286] stb0899_attach: Attaching STB0899
[ 3117.652298] stb6100_attach: Attaching STB6100
[ 3117.652515] LNBx2x attached on addr=8
[ 3117.652522] DVB: registering adapter 0 frontend 0 (STB0899
Multistandard)...

However, when I run femon in order to get the signal level (so I can
tune the antenna), I get:

Problem retrieving frontend information: Operation not supported
status S     | signal 7f98 | snr 0000 | ber d3b53000 | unc 00000000 |

If I use the -H flag it shows signal level 49% which is not right
because the card is not even connected to the antenna.


Also dvbscan gives an error that it cannot tune to the required
frequency (or something like that). As I said, the card is not yet
connected to the antenna but I tried connecting it to a standalone LNB
(which I imagine is the same as connecting to a not tuned antenna).


Any hints?


Thanks,
nicolae
