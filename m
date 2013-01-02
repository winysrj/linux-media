Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52375 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab3ABAX1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 19:23:27 -0500
Received: from mailout-eu.gmx.com ([10.1.101.216]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MaoLM-1TaAb92s6E-00KSs0 for
 <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 01:23:25 +0100
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Antti Palosaari" <crope@iki.fi>
Subject: Re: AverTV_A918R (af9035-af9033-tda18218) / patch proposal
References: <op.wp845xcf4bfdfw@quantal> <50E36298.3040009@iki.fi>
 <op.wp9b661h4bfdfw@quantal>
Date: Wed, 02 Jan 2013 01:23:23 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Diorser <diorser@gmx.fr>
Message-ID: <op.wp9co90r4bfdfw@quantal>
In-Reply-To: <op.wp9b661h4bfdfw@quantal>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just to compare, this is the same tzap test made on same channel with a  
AverTV 007 (saa7134) on a another PC, with same antenna.
It works perfectly.

tzap -r TEST
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '~/.tzap/channels.conf'
tuning to 586167000 Hz
video pid 0x0200, audio pid 0x028a
status 00 | signal b2b2 | snr 2929 | ber 0001fffe | unc 00000000 |
status 1f | signal b2b2 | snr fefe | ber 0000004e | unc ffffffff |  
FE_HAS_LOCK
status 1f | signal b2b2 | snr fefe | ber 00000050 | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal b2b2 | snr fefe | ber 0000005c | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal b1b1 | snr fefe | ber 00000054 | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal b2b2 | snr fefe | ber 0000004e | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal b2b2 | snr ffff | ber 00000050 | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal b1b1 | snr ffff | ber 00000052 | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal b2b2 | snr ffff | ber 00000050 | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal b1b1 | snr ffff | ber 0000004a | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal b1b1 | snr ffff | ber 00000050 | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal b1b1 | snr ffff | ber 0000004e | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal b1b1 | snr ffff | ber 00000044 | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal b2b2 | snr ffff | ber 0000004a | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal b2b2 | snr ffff | ber 0000004e | unc 00000000 |  
FE_HAS_LOCK
