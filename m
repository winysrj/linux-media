Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms16-1.1blu.de ([89.202.0.34]:39257 "EHLO ms16-1.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab0FFTww (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jun 2010 15:52:52 -0400
Received: from [95.103.170.192] (helo=romy.gusto)
	by ms16-1.1blu.de with esmtpsa (TLS-1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.69)
	(envelope-from <lars.schotte@schotteweb.de>)
	id 1OLLtp-0002CP-Iy
	for linux-media@vger.kernel.org; Sun, 06 Jun 2010 21:52:49 +0200
Date: Sun, 6 Jun 2010 21:52:46 +0200
From: Lars Schotte <lars.schotte@schotteweb.de>
To: linux-media@vger.kernel.org
Subject: major brakethrough on HVR4000
Message-ID: <20100606215246.4f67e391@romy.gusto>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i have played w/ szap-s2 parameters and I got tuning, BUT not a picture
yet, so that only means that it can tune in, as long as i have no
picture and not a usable stream for dvb-s2 again, it means NOTHING.

here the output of:
./szap-s2 -O 20 -C 23 -M 5 -S 1 -r -c ~/.mplayer/channels.conf "arte
HD(ZDFvision)"
....
zapping to 449 'arte HD(ZDFvision)':
delivery DVB-S2, modulation 8PSK
sat 0, frequency 11361 MHz H, symbolrate 22000000, coderate 2/3,
rolloff 0.20 vpid 0x1842, apid 0x184d, sid 0x2b70
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal dac0 | snr 0000 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK status 1f | signal dac0 | snr 0000 | ber 00000000 | unc
00000000 | FE_HAS_LOCK status 1f | signal dac0 | snr fb33 | ber
00000000 | unc 00000000 | FE_HAS_LOCK status 1f | signal dac0 | snr
fb33 | ber 00000000 | unc 00000000 | FE_HAS_LOCK status 1f | signal
dac0 | snr fb33 | ber 00000000 | unc 00000000 | FE_HAS_LOCK status 1f |
signal dac0 | snr fb33 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal db40 | snr fb33 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK status 1f | signal dac0 | snr fb33 | ber 00000000 | unc
00000000 | FE_HAS_LOCK status 1f | signal dac0 | snr fccd | ber
00000000 | unc 00000000 | FE_HAS_LOCK status 1f | signal dac0 | snr
fccd | ber 00000000 | unc 00000000 | FE_HAS_LOCK status 1f | signal
dac0 | snr fccd | ber 00000000 | unc 00000000 | FE_HAS_LOCK status 1f |
signal dac0 | snr fccd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal dac0 | snr fccd | ber 00000000 | unc 00000000 |
FE_HAS_LOCK status 1f | signal db40 | snr fccd | ber 00000000 | unc
00000000 | FE_HAS_LOCK

- and this coderate 2/3 setting was it that made the difference.
