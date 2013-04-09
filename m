Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59176 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761532Ab3DIOq6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 10:46:58 -0400
Received: from mailout-eu.gmx.com ([10.1.101.214]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MGDg9-1UKtFu1Tmh-00FDKH for
 <linux-media@vger.kernel.org>; Tue, 09 Apr 2013 16:46:57 +0200
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Antti Palosaari" <crope@iki.fi>
Subject: Re: AverTV_A918R (af9035-af9033-tda18218) / patch proposal
References: <op.wp845xcf4bfdfw@quantal> <50E36298.3040009@iki.fi>
Date: Tue, 09 Apr 2013 16:46:54 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Diorser <diorser@gmx.fr>
Message-ID: <op.wu93cgqr4bfdfw@wheezy>
In-Reply-To: <50E36298.3040009@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Please find below some news for A918R
[details @  
http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_HD_Express_A918R ]

* the patch proposed to automatically load the right modules for A918R  
card is not yet available
=> http://www.mail-archive.com/linux-media@vger.kernel.org/msg56659.html
(I don't exactly know what is missing to make it accepted).
This patch would at least avoid having to modify dvb-usb-ids.h & af9035.c  
each time to test some git updates.

* previously, in December, the signal level detection was fuzzy and not  
reliable.
Now, the reported signal level is strictly at 0000 (good antenna RF signal  
confirmed with other device).

I am aware A918R card is not the most requested one (Express card), but  
that's all I can add in case it can help, even for another card.

Regards.


see details below:
------------------------------------------
UPDATE April 8th 2013: result with modules compiled from git:

tzap -r TEST
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/home/test_r/.tzap/channels.conf'
tuning to 586167000 Hz
video pid 0x0200, audio pid 0x028a
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |

kaffeine from command line

kaffeine(1584) DvbScanFilter::timerEvent: timeout while reading section;  
type = 0 pid = 0
kaffeine(1584) DvbScanFilter::timerEvent: timeout while reading section;  
type = 2 pid = 17
demux_wavpack: (open_wv_file:127) open_wv_file: non-seekable inputs aren't  
supported yet.
net_buf_ctrl: dvbspeed mode
kaffeine(1584) DvbScanFilter::timerEvent: timeout while reading section;  
type = 0 pid = 0
kaffeine(1584) DvbScanFilter::timerEvent: timeout while reading section;  
type = 2 pid = 17
net_buf_ctrl: dvbspeed OFF
kaffeine(2186) DvbLinuxDevice::getSignal: ioctl FE_READ_SIGNAL_STRENGTH  
failed for frontend "/dev/dvb/adapter0/frontend0"
kaffeine(2186) DvbLinuxDevice::getSnr:    ioctl FE_READ_SNR failed for  
frontend "/dev/dvb/adapter0/frontend0"
kaffeine(2186) DvbLinuxDevice::isTuned:   ioctl FE_READ_STATUS failed for  
frontend "/dev/dvb/adapter0/frontend0"
.../...
kaffeine(2186) DvbLinuxDevice::getSignal: ioctl FE_READ_SIGNAL_STRENGTH  
failed for frontend "/dev/dvb/adapter0/frontend0"
kaffeine(2186) DvbLinuxDevice::getSnr:    ioctl FE_READ_SNR failed for  
frontend "/dev/dvb/adapter0/frontend0"
kaffeine(2186) DvbLinuxDevice::isTuned:   ioctl FE_READ_STATUS failed for  
frontend "/dev/dvb/adapter0/frontend0"

demux_wavpack: (open_wv_file:127) open_wv_file: non-seekable inputs aren't  
supported yet.
net_buf_ctrl: dvbspeed mode
net_buf_ctrl: dvbspeed OFF
kaffeine(2215) DvbDevice::frontendEvent: tuning failed
------------------------------------------
