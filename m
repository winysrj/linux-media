Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm14-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.174]:38268 "HELO
	nm14-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752541Ab1HMTmZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2011 15:42:25 -0400
Message-ID: <1313264214.97761.YahooMailClassic@web121711.mail.ne1.yahoo.com>
Date: Sat, 13 Aug 2011 12:36:54 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: PCTV 290e nanostick and remote control support
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've just acquired a PCTV 290e nanostick, and have successfully tuned it into a DVB-T2 MUX. Yay! :-).

However, before declaring total victory, I have noticed that no-one has yet wired up the device's IR support in the em28xx driver. The adapter ships with a tiny RC with only 26 buttons, which would allow me to use the 290e with VDR. Does anyone know what kind of IR hardware the 290e uses, please? I tried setting:

.has_ir_i2c = 1

in the [EM28174_BOARD_PCTV_290E] section of em28xx_cards.c, but saw nothing new in the dmesg log. (Yes, the ir_kdb_i2c modules did load successfully.) The /sys/bus/i2c/devices directory contains two nodes:

em28xx #0
CXD2820R tuner I2C adapter

Any (non-destructive) suggestions for other things to try to get IR working would be gratefully received.

Thanks,
Chris

