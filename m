Return-path: <linux-media-owner@vger.kernel.org>
Received: from dougal.woof94.com ([125.63.57.136]:53510 "EHLO
	dougal.woof94.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaI0BtT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 21:49:19 -0400
Message-ID: <54261797.7080509@cloud.net.au>
Date: Sat, 27 Sep 2014 11:49:11 +1000
From: Hamish Moffatt <hamish@cloud.net.au>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: problem with second tuner on Leadtek DTV dongle dual
References: <542406DE.10403@cloud.net.au> <5424627F.9010306@iki.fi>
In-Reply-To: <5424627F.9010306@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/09/14 04:44, Antti Palosaari wrote:
> Moikka
> Performance issues are fixed recently (at least I hope so), but it 
> will took some time in order to get fixes in stable. Unfortunately I 
> don't have any IT9135 BX (ver 2 chip) dual device to test like yours...
>
> Could you install that kernel tree:
> http://git.linuxtv.org/cgit.cgi/media_tree.git/log/?h=devel-3.17-rc6
> and firmwares from there:
> http://palosaari.fi/linux/v4l-dvb/firmware/IT9135/ITE_3.25.0.0/
>

OK I have 
http://git.linuxtv.org/cgit.cgi/media_tree.git/log/?h=devel-3.17-rc6 
running now (reporting itself as 3.17-rc5), with the 3.40.1.0 firmware 
from your site.

Both tuners work for all stations, except that the first tuning attempt 
on each tuner simply doesn't lock. Doesn't seem to matter what I tune to.

[Unplug & replug device]

[11:44AM] hamish@quokka:~ $ tzap -a3 'ABC'
using '/dev/dvb/adapter3/frontend0' and '/dev/dvb/adapter3/demux0'
reading channels from file '/home/hamish/.tzap/channels.conf'
tuning to 226500000 Hz
video pid 0x0200, audio pid 0x028a
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 07 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 07 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0032 | ber 00000000 | unc 00000000 |
status 07 | signal ffff | snr 0032 | ber 00000000 | unc 00000000 |
^C
[11:44AM] hamish@quokka:~ $ tzap -a3 'ABC'
using '/dev/dvb/adapter3/frontend0' and '/dev/dvb/adapter3/demux0'
reading channels from file '/home/hamish/.tzap/channels.conf'
tuning to 226500000 Hz
video pid 0x0200, audio pid 0x028a
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
^C
[11:44AM] hamish@quokka:~ $ tzap -a2 'ABC'
using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
reading channels from file '/home/hamish/.tzap/channels.conf'
tuning to 226500000 Hz
video pid 0x0200, audio pid 0x028a
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 07 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 07 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0032 | ber 00000000 | unc 00000000 |
status 07 | signal ffff | snr 0032 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0032 | ber 00000000 | unc 00000000 |
status 07 | signal ffff | snr 0032 | ber 00000000 | unc 00000000 |
status 00 | signal ffff | snr 0028 | ber 00000000 | unc 00000000 |
status 07 | signal ffff | snr 0028 | ber 00000000 | unc 00000000 |
^C
[11:45AM] hamish@quokka:~ $ tzap -a2 'ABC'
using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
reading channels from file '/home/hamish/.tzap/channels.conf'
tuning to 226500000 Hz
video pid 0x0200, audio pid 0x028a
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal ffff | snr 0122 | ber 0009a140 | unc 00002685 | 
FE_HAS_LOCK
^C


I left it trying to tune for minutes, and occasionally it would get a 
lock for one sample but then lose it again for the next.

Hamish
