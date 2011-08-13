Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48962 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab1HMWbb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2011 18:31:31 -0400
Message-ID: <4E46FB3C.7060402@iki.fi>
Date: Sun, 14 Aug 2011 01:31:24 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: PCTV 290e nanostick and remote control support
References: <1313264214.97761.YahooMailClassic@web121711.mail.ne1.yahoo.com>
In-Reply-To: <1313264214.97761.YahooMailClassic@web121711.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

On 08/13/2011 10:36 PM, Chris Rankin wrote:
> I've just acquired a PCTV 290e nanostick, and have successfully tuned it into a DVB-T2 MUX. Yay! :-).
> 
> However, before declaring total victory, I have noticed that no-one has yet wired up the device's IR support in the em28xx driver. The adapter ships with a tiny RC with only 26 buttons, which would allow me to use the 290e with VDR. Does anyone know what kind of IR hardware the 290e uses, please? I tried setting:
> 
> .has_ir_i2c = 1
> 
> in the [EM28174_BOARD_PCTV_290E] section of em28xx_cards.c, but saw nothing new in the dmesg log. (Yes, the ir_kdb_i2c modules did load successfully.) The /sys/bus/i2c/devices directory contains two nodes:
> 
> em28xx #0
> CXD2820R tuner I2C adapter
> 
> Any (non-destructive) suggestions for other things to try to get IR working would be gratefully received.

Remote is already supported, but from the 3.1 or maybe 3.2 (I am not
sure if Mauro was hurry to sent it 3.1). Anyhow, if you need it please
install latest v4l-dvb drivers.

Thank you for the report.

regards,
Antti

-- 
http://palosaari.fi/
