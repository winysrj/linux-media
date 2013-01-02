Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59904 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182Ab3ABAMg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 19:12:36 -0500
Received: from mailout-eu.gmx.com ([10.1.101.210]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Lj83k-1TJsKq3j82-00dHv1 for
 <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 01:12:34 +0100
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Antti Palosaari" <crope@iki.fi>
Subject: Re: AverTV_A918R (af9035-af9033-tda18218) / patch proposal
References: <op.wp845xcf4bfdfw@quantal> <50E36298.3040009@iki.fi>
Date: Wed, 02 Jan 2013 01:12:32 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Diorser <diorser@gmx.fr>
Message-ID: <op.wp9b661h4bfdfw@quantal>
In-Reply-To: <50E36298.3040009@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Does it show 100% even antenna is unplugged ?

It seems in fact that signal indicator is not reliable.
I have to sometimes reset dvb with:

for I in dvb_usb_af9035 af9033 tda18218 dvb_usb_v2 dvb_core rc_core; do   
rmmod $I; done
modprobe dvb-usb-af9035

The antenna signal input is fine, this is at least the point I am sure.

> You mean you see LOCK flag gained, then there is maybe error pid filter  
> timeouts ?

Not sure of that. tzap test seems to show the opposite:

tzap -r TEST
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/home/test_r/.tzap/channels.conf'
tuning to 586167000 Hz
video pid 0x0200, audio pid 0x028a
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |

I also took the kaffeine dvb files perfectly working with saa7134 card,  
but A918R card does not tune on  any channel.
Then, the lack of signal strength stability / front-end problem is may be  
the root cause.
Thanks again for your time
