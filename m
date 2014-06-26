Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59764 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202AbaFZNbK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jun 2014 09:31:10 -0400
Message-ID: <53AC209B.9030707@iki.fi>
Date: Thu, 26 Jun 2014 16:31:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: David Shirley <tephra@gmail.com>
CC: Unname <linux-media@vger.kernel.org>
Subject: Re: [PATCH] af9035: override tuner id when bad value set into eeprom
References: <1403615732-9193-1-git-send-email-crope@iki.fi>	<CAM187nByJMOmOrYJPKfZ0WyrARSD1+eAyoEOKahDiGyk9no5qw@mail.gmail.com>	<53AAB68B.4010806@iki.fi>	<CAM187nBPf66kBwx6VCFLeQvJ5spiqsRF8wb7MUm8-ffGQQg0Mw@mail.gmail.com> <CAM187nBLCjrZREq3A+mNdAkVPEics_pCVVx0ZNrKjzGeR0kdqA@mail.gmail.com>
In-Reply-To: <CAM187nBLCjrZREq3A+mNdAkVPEics_pCVVx0ZNrKjzGeR0kdqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/26/2014 12:41 PM, David Shirley wrote:
> As promised results on the 9033 driver (with the patch to fix the
> tuner id/eeprom thingy):
>
> 3.42:
> Jun 26 19:30:56 crystal kernel: [  102.250152] i2c i2c-11: af9033:
> firmware version: LINK=0.0.0.0 OFDM=3.29.3.3
> root@crystal:~# tzap -c ~mythtv/channels -a 2 ONE
> using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
> reading channels from file '/home/mythtv/channels'
> tuning to 219500000 Hz
> video pid 0x0202, audio pid 0x0000
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 07 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 07 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0078 | ber 00000000 | unc 00000000 |
> status 07 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0096 | ber 00000000 | unc 00000000 |
> ^C
> root@crystal:~# tzap -c ~mythtv/channels -a 3 ONE
> using '/dev/dvb/adapter3/frontend0' and '/dev/dvb/adapter3/demux0'
> reading channels from file '/home/mythtv/channels'
> tuning to 219500000 Hz
> video pid 0x0202, audio pid 0x0000
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 07 | signal ffff | snr 0046 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 07 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0046 | ber 73ffffe3 | unc 0000270f |
> status 07 | signal ffff | snr 0000 | ber 73ffffe3 | unc 00004e1e |
> status 00 | signal ffff | snr 0046 | ber 73ffffe3 | unc 0000752d |
> status 07 | signal ffff | snr 0000 | ber 73ffffe3 | unc 00009c3c |
> status 00 | signal ffff | snr 0046 | ber ffffffff | unc 0000c34c |
>
> 3.40:
> Jun 26 19:35:06 crystal kernel: [   71.134391] i2c i2c-11: af9033:
> firmware version: LINK=0.0.0.0 OFDM=3.17.1.0
> root@crystal:~# tzap -c ~mythtv/channels -a 2 ONE
> using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
> reading channels from file '/home/mythtv/channels'
> tuning to 219500000 Hz
> video pid 0x0202, audio pid 0x0000
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 07 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 07 | signal ffff | snr 0078 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 01 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0078 | ber 00000000 | unc 00002685 |
> status 07 | signal ffff | snr 0000 | ber 00000000 | unc 00004d0a |
> status 00 | signal ffff | snr 008c | ber 00000000 | unc 0000738f |
> status 01 | signal ffff | snr 0000 | ber 00000000 | unc 00009a14 |
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 0000c099 |
> status 07 | signal ffff | snr 0078 | ber 00000000 | unc 0000e71e |
> status 00 | signal ffff | snr 0078 | ber ffffffff | unc 00010e2e |
> status 1f | signal ffff | snr 0000 | ber ffffffff | unc 0001353e | FE_HAS_LOCK
> status 00 | signal ffff | snr 0122 | ber ffffffff | unc 00015c4e |
> status 07 | signal ffff | snr 0078 | ber ffffffff | unc 0001835e |
> status 00 | signal ffff | snr 000a | ber ffffffff | unc 0001aa6e |
> status 07 | signal ffff | snr 0000 | ber ffffffff | unc 0001d17e |
> ^C
>
> root@crystal:~# tzap -c ~mythtv/channels -a 3 ONE
> using '/dev/dvb/adapter3/frontend0' and '/dev/dvb/adapter3/demux0'
> reading channels from file '/home/mythtv/channels'
> tuning to 219500000 Hz
> video pid 0x0202, audio pid 0x0000
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 01 | signal ffff | snr 00aa | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0096 | ber 00000000 | unc 00000000 |
> status 07 | signal ffff | snr 0046 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0046 | ber 00000000 | unc 00000000 |
> status 01 | signal ffff | snr 0046 | ber 00000000 | unc 00000000 |
> status 1f | signal ffff | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 001e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 07 | signal ffff | snr 00aa | ber 00000000 | unc 0000211c |
> status 07 | signal ffff | snr 00aa | ber ffffffff | unc 0000482c |
> status 07 | signal ffff | snr 0000 | ber 76aaaa8d | unc 00006f39 |
> status 07 | signal ffff | snr 0046 | ber 76aaaa8d | unc 00009646 |
> status 07 | signal ffff | snr 0046 | ber ffffffff | unc 0000bd56 |
> status 07 | signal ffff | snr 0000 | ber ffffffff | unc 0000e466 |
> status 07 | signal ffff | snr 0046 | ber ffffffff | unc 00010b76 |
> status 1f | signal ffff | snr 0118 | ber ffffffff | unc 00013286 | FE_HAS_LOCK
> status 1f | signal ffff | snr 00dc | ber ffffffff | unc 00015996 | FE_HAS_LOCK
> status 07 | signal ffff | snr 00aa | ber ffffffff | unc 000180a6 |
> status 07 | signal ffff | snr 00aa | ber ffffffff | unc 0001a7b6 |
> ^C
>
>
> stock kernel driver (ftp/extract from ite.com.tw):
> Jun 26 19:38:31 crystal kernel: [  276.422317] i2c i2c-11: af9033:
> firmware version: LINK=0.0.0.0 OFDM=3.9.1.0
> root@crystal:/lib/firmware# tzap -c ~mythtv/channels -a 2 ONE
> using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
> reading channels from file '/home/mythtv/channels'
> tuning to 219500000 Hz
> video pid 0x0202, audio pid 0x0000
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 1f | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 00d2 | ber 082496b0 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 00d2 | ber 06a6ca1a | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 00d2 | ber 05336f08 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 00d2 | ber 05c002a6 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 00d2 | ber 03d55fd6 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 00d2 | ber 04a8b336 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 00d2 | ber 05c05148 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 00d2 | ber 06a6470c | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 00d2 | ber 04e7df5c | unc 00000000 | FE_HAS_LOCK
> ^C
> root@crystal:/lib/firmware# tzap -c ~mythtv/channels -a 3 ONE
> using '/dev/dvb/adapter3/frontend0' and '/dev/dvb/adapter3/demux0'
> reading channels from file '/home/mythtv/channels'
> tuning to 219500000 Hz
> video pid 0x0202, audio pid 0x0000
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 1f | signal ffff | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> ^C
>
> As you can see the stock kernel/download-extract file gives best lock.
>
> The 3.42 doesn't lock at all, and the 3.40 has a hard time maintaining the lock.
>
> I will retest after new antenna goes on :)

Thank you for testing. Oldest firmware works, but it is not likely how 
it should perform. Tuner#0 reports SNR 21.0 dB (0.1 * 0xd2 = 21 dec) and 
tuner#1 29 dB for same signal. 21 dB is too low and bit-error counter 
(BER) is running all the time. It is likely error correction (FEC) could 
not fix all errors on long ran and then UNC counter will increase too. 
When UNC increases there is uncorrected error on stream, which is 
typically visible on picture or audio.

Did you test old it9135 driver to see how it performs using oldest and 
best working firmware?

regards
Antti

-- 
http://palosaari.fi/
