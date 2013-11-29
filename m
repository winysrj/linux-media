Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:41875 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab3K2L0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 06:26:42 -0500
Received: by mail-vc0-f182.google.com with SMTP id lc6so6723377vcb.27
        for <linux-media@vger.kernel.org>; Fri, 29 Nov 2013 03:26:42 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 29 Nov 2013 12:26:42 +0100
Message-ID: <CAK7=TuFhuuEHL9gQmAcxphUXbYJ9AgYhC41cty94XVQfusDOzg@mail.gmail.com>
Subject: TeVii S471 issues with HotBird tp.11411h
From: Tomasz Bubel <tbubel@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,
In my htpc i have:
- 1x TeVii S471
- 1x Hauppauge WinTV-Nova-HD-S2.
- gentoo linux with 3.12.0 kernel.
- drivers from media_tree:
"Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
258d2fbf874c87830664cb7ef41f9741c1abffac Merge tag 'v3.13-rc1' into patchwork
6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae Linux 3.13-rc1
57498f9cb91be1eebea48f1dc833ebf162606ad5 Merge tag
'ecryptfs-3.13-rc1-quiet-checkers' of
git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs"

I'm using 90cm offset dish antenna with Quad LNB.

Everything works pretty well except that I can't get picture from
HotBird tp.11411h with TeVii S471.

szap -a 0 -c channelsx.conf -n 986 -H:
reading channels from file 'channelsx.conf'
zapping to 986 'DOMO+ HD(CYFRA+)':
sat 0, frequency = 11411 MHz H, symbolrate 27500000, vpid = 0x00a7,
apid = 0x006c sid = 0x379e
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal  11% | snr  47% | ber 0 | unc 0 |
status 00 | signal  11% | snr  87% | ber -1 | unc 0 |
status 00 | signal  11% | snr  87% | ber -1 | unc 0 |
status 00 | signal  11% | snr  87% | ber -1 | unc 0 |
status 00 | signal  11% | snr  87% | ber -1 | unc 0 |
status 00 | signal  11% | snr  47% | ber -1 | unc 0 |
status 00 | signal  11% | snr  31% | ber -1 | unc 0 |
status 00 | signal  11% | snr  23% | ber -1 | unc 0 |
status 00 | signal  11% | snr  87% | ber -1 | unc 0 |
status 00 | signal  11% | snr  63% | ber -1 | unc 0 |

Notice low signal value and changes of snr.

Same tp. this time hauppauge:

szap -a 1 -c channelsx.conf -n 986 -H
reading channels from file 'channelsx.conf'
zapping to 986 'DOMO+ HD(CYFRA+)':
sat 0, frequency = 11411 MHz H, symbolrate 27500000, vpid = 0x00a7,
apid = 0x006c sid = 0x379e
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
status 1f | signal  80% | snr   0% | ber 0 | unc 0 | FE_HAS_LOCK
status 1f | signal  80% | snr 100% | ber 0 | unc 0 | FE_HAS_LOCK
status 1f | signal  80% | snr 100% | ber 0 | unc 0 | FE_HAS_LOCK
status 1f | signal  80% | snr 100% | ber 0 | unc 0 | FE_HAS_LOCK
status 1f | signal  80% | snr 100% | ber 0 | unc 0 | FE_HAS_LOCK
status 1f | signal  80% | snr 100% | ber 0 | unc 0 | FE_HAS_LOCK
status 1f | signal  80% | snr 100% | ber 0 | unc 0 | FE_HAS_LOCK
status 1f | signal  80% | snr 100% | ber 0 | unc 0 | FE_HAS_LOCK
status 1f | signal  80% | snr 100% | ber 0 | unc 0 | FE_HAS_LOCK

Also in dmesg i notice  multiple firmware messages, is this normal behaviour?

[  357.134498] ds3000_firmware_ondemand: Waiting for firmware upload
(dvb-fe-ds3000.fw)...
[  357.135376] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[  459.620503] ds3000_firmware_ondemand: Waiting for firmware upload
(dvb-fe-ds3000.fw)...
[  459.620545] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[  460.534720] ds3000_firmware_ondemand: Waiting for firmware upload
(dvb-fe-ds3000.fw)...
[  460.534744] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[ 2799.910498] ds3000_firmware_ondemand: Waiting for firmware upload
(dvb-fe-ds3000.fw)...
[ 2799.910540] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[ 2896.285493] ds3000_firmware_ondemand: Waiting for firmware upload
(dvb-fe-ds3000.fw)...

Can any one help? What information I should provide?

-- 
Pozdrawiam,
Tomasz Bubel
