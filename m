Return-path: <mchehab@pedra>
Received: from poczta.vectranet.pl ([88.156.64.179]:45809 "EHLO
	poczta.vectranet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab1BXQJj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 11:09:39 -0500
Received: from [192.168.0.2] (088156142183.radom.vectranet.pl [88.156.142.183])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: rafalm23@tkdami.net)
	by poczta.vectranet.pl (Postfix) with ESMTP id 872D78993AA8
	for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 17:09:37 +0100 (CET)
Message-ID: <4D6682C2.10905@tkdami.net>
Date: Thu, 24 Feb 2011 17:09:38 +0100
From: "R.M." <rafalm23@tkdami.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Tevii s660 - DVB-S2 BER is always 0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,
I have tuner Tevii s660 DVB-S2 USB

with DVB-S (QPSK) i have BER > 0 but
with DVB-S2 (8PSK) i have BER = 0 (always)

this impossible because QPSK has better modulation and should have lower 
BER, also on SD channels video is perfect, but on HD channels video is 
not perfect

please help, regards,
R.M.

reading channels from file '/home/rafal/.szap/channels.conf'
zapping to 486 'TV POLONIA(CYFRA +)':
delivery DVB-S, modulation QPSK
sat 0, frequency 11488 MHz H, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00a0, apid 0x0050, sid 0x13ed
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
status 1f | signal cf08 | snr b838 | ber 00000002 | unc 0000000b | 
FE_HAS_LOCK
status 1f | signal cf08 | snr b838 | ber 00000009 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr b838 | ber 0000000e | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr b838 | ber 0000000c | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr b838 | ber 00000002 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr b838 | ber 0000000b | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr b838 | ber 00000001 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr b838 | ber 0000000e | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr b838 | ber 00000003 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr b838 | ber 00000005 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr b838 | ber 0000000a | unc 00000000 | 
FE_HAS_LOCK


reading channels from file '/home/rafal/.szap/channels.conf'
zapping to 409 'CANAL+ SPORT HD(CYFRA +)':
delivery DVB-S2, modulation 8PSK
sat 0, frequency 11278 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0169, apid 0x1fff, sid 0x32de
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
status 1f | signal cf08 | snr 7323 | ber 0000002c | unc 00000002 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr 7323 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr 7323 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr 7323 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr 7323 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr 7323 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr 7323 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr 7323 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr 7323 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr 7323 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr 7323 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr 7323 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr 7323 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal cf08 | snr 7323 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
