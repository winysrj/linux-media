Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49786 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598Ab3G0S6H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Jul 2013 14:58:07 -0400
Received: from [192.168.1.101] ([146.52.53.248]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0LufbI-1U3nh63koa-00zkd3 for
 <linux-media@vger.kernel.org>; Sat, 27 Jul 2013 20:58:05 +0200
Message-ID: <51F4183C.3000505@gmx.net>
Date: Sat, 27 Jul 2013 20:58:04 +0200
From: Jan Taegert <jantaegert@gmx.net>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org, thomas.mair86@googlemail.com
Subject: Re: PROBLEM: dvb-usb-rtl28xxu and Terratec Cinergy TStickRC (rev3)
 - no signal on some frequencies
References: <51E927EC.5030701@gmx.net> <51E92A78.50706@iki.fi> <51E974DB.7010609@gmx.net> <51ED9F8F.10206@iki.fi> <51EFDF55.90500@iki.fi>
In-Reply-To: <51EFDF55.90500@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 24.07.2013 16:06, schrieb Antti Palosaari:
> Could you test attached patch?
>
> It enhances reception a little bit, you should be able to receive more
> weak signals.
>
> I was able to made test setup against modulator. Modulator + attenuator
> + attenuator + TV-stick, where I got picture using Windows driver at
> signal level -29dBm whilst on Linux -26.5dBm was needed. With that patch
> Linux driver started performing same as Windows.
>
> regards
> Antti
>


Hello,

unfortunately your patch doesn't bring any change: I rebuild the kernel 
with it but the driver still gives no signal on the two higher frequencies.

For safety I tried the channel.conf with windows and vlc and everything 
worked as it should.


Thanks,
jan



# kernel 3.8.0-26-patched1 - output of: tzap -c channels.conf -t 10 MDR
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 538000000 Hz
video pid 0x0611, audio pid 0x0612
status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc b7768b48 |
status 1f | signal bfa0 | snr 0102 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal bfa0 | snr 0104 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal bfa0 | snr 0102 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal bfa0 | snr 00fb | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal bfa0 | snr 00fd | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal bfa0 | snr 0103 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal bfa0 | snr 00ff | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal bfa0 | snr 00f9 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal bfa0 | snr 00fa | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal bfa0 | snr 00f7 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
reading channels from file 'channels.conf'

# kernel 3.8.0-26-patched1 - output of: 'dvbsnoop -s feinfo' while 
watching MDR [shortened]
Current parameters:
     Frequency:  538000.000 kHz
     Inversion:  OFF
     Bandwidth:  8 MHz
     Stream code rate (hi prio):  FEC 2/3
     Stream code rate (lo prio):  FEC 1/2
     Modulation:  QAM 64
     Transmission mode:  8k mode
     Guard interval:  1/4
     Hierarchy:  none


# kernel 3.8.0-26-patched1 - output of: tzap -c channels.conf -t 10 ZDF
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 594000000 Hz
video pid 0x0221, audio pid 0x0222
status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc b7718b48 |
status 00 | signal bfca | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal bfca | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal bfca | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal bfca | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal bfca | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal bfca | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal bfca | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal bfca | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal bfca | snr 0000 | ber 0000ffff | unc 00000000 |
reading channels from file 'channels.conf'

# kernel 3.8.0-26-patched1 - output of: 'dvbsnoop -s feinfo' while 
watching ZDF [shortened]
Current parameters:
     Frequency:  594000.000 kHz
     Inversion:  AUTO
     Bandwidth:  8 MHz
     Stream code rate (hi prio):  FEC 1/2
     Stream code rate (lo prio):  FEC 1/2
     Modulation:  QPSK
     Transmission mode:  2k mode
     Guard interval:  1/32
     Hierarchy:  none


# kernel 3.8.0-26-patched1 - output of: tzap -c channels.conf -t 10 ARD
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 618000000 Hz
video pid 0x0601, audio pid 0x0602
status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc b7767b48 |
status 00 | signal bf93 | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal bf93 | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal bf93 | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal bf93 | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal bf93 | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal bf93 | snr 007f | ber 00004ca0 | unc 00000000 |
status 00 | signal bf93 | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal bf93 | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal bf93 | snr 0000 | ber 0000ffff | unc 00000000 |
reading channels from file 'channels.conf'

# kernel 3.8.0-26-patched1 - output of: 'dvbsnoop -s feinfo' while 
watching ARD [shortened]
Current parameters:
     Frequency:  618000.000 kHz
     Inversion:  AUTO
     Bandwidth:  8 MHz
     Stream code rate (hi prio):  FEC 1/2
     Stream code rate (lo prio):  FEC 1/2
     Modulation:  QPSK
     Transmission mode:  2k mode
     Guard interval:  1/32
     Hierarchy:  none

