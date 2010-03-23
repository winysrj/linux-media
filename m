Return-path: <linux-media-owner@vger.kernel.org>
Received: from www49.your-server.de ([213.133.104.49]:57809 "EHLO
	www49.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0CWJfd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 05:35:33 -0400
Message-ID: <4BA88B5A.3040204@motama.com>
Date: Tue, 23 Mar 2010 10:35:22 +0100
From: Marco Lohse <mlohse@motama.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: Problems with ngene based DVB cards (Digital Devices Cine S2
 Dual 	DVB-S2 , Mystique SaTiX S2 Dual)
References: <4BA10639.3000407@motama.com> <4BA1F9C6.3020807@motama.com>	 <829197381003180709t26f76b38y7e641b8c12a2d33d@mail.gmail.com>	 <4BA2419A.4070608@motama.com> <829197381003180812n7dfe92e7v236e50d6ab7bdc0@mail.gmail.com>
In-Reply-To: <829197381003180812n7dfe92e7v236e50d6ab7bdc0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
[..]
> 
> Hi Marco,
> 
> Ok, great.  Like I said, I will see if I can reproduce it here, as
> that will help narrow down whether it's really an issue with the ngene
> bridge, or whether it's got something to do with that particular
> bridge/demod/tuner combination.
> 

We made some more tests and found some additional issues that we would
like to report.

Have fun, Marco

*Problem A revisited * *****************************

It was suggested that due to a bug the dvr should never be closed (as a
work-around)

How does this affect channel tuning times?

Test (using the latest version of the modified szap-s2)

0) su -c "rmmod ngene && modprobe ngene one_adapter=0"

1) Run szap-s2 using a channels.conf with "Das Erste" and "ZDF" on
different transponders

szap-s2 -S 1 -H -c channels_DVB-S2_transponder_switch.conf -a 0 -n 1 -i
reading channels from file 'channels_DVB-S2_transponder_switch.conf'

>>> Das Erste
zapping to 1 'Das Erste':
delivery DVB-S2, modulation QPSK
sat 0, frequency 11836 MHz H, symbolrate 27500000, coderate auto,
rolloff 0.35
vpid 0x0065, apid 0x0066, sid 0x0068
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
Opened frontend
Opened video demux
Opened audio demux
status 1f | signal  69% | snr  67% | ber 1 | unc -2 | FE_HAS_LOCK
Delay zap_to : 0.586872

>>> ZDF
zapping to 2 'ZDF':
delivery DVB-S2, modulation QPSK
sat 0, frequency 11953 MHz H, symbolrate 27500000, coderate auto,
rolloff 0.35
vpid 0x006e, apid 0x0078, sid 0x0082
status 1f | signal  67% | snr  63% | ber 1 | unc -2 | FE_HAS_LOCK
Delay zap_to : 0.580473

>>> Das Erste
zapping to 1 'Das Erste':
delivery DVB-S2, modulation QPSK
sat 0, frequency 11836 MHz H, symbolrate 27500000, coderate auto,
rolloff 0.35
vpid 0x0065, apid 0x0066, sid 0x0068
status 1f | signal  69% | snr  67% | ber 1 | unc -2 | FE_HAS_LOCK
Delay zap_to : 0.553754

=> Good, you will see low tuning times.

2) in parallel to 1) - and without terminating 1) - run a second
instance of szap-s2 that reads from the device

szap-s2 -S 1 -H -c channels_DVB-S2_transponder_switch.conf -a 1 -n 1 -r
reading channels from file 'channels_DVB-S2_transponder_switch.conf'
zapping to 1 'Das Erste':
delivery DVB-S2, modulation QPSK
sat 0, frequency 11836 MHz H, symbolrate 27500000, coderate auto,
rolloff 0.35
vpid 0x0065, apid 0x0066, sid 0x0068
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
Opened frontend
Opened video demux
Opened audio demux
..

3) while 2) is running, go back to 1) and tune to different transponders
again:

>>> ZDF
zapping to 2 'ZDF':
delivery DVB-S2, modulation QPSK
sat 0, frequency 11953 MHz H, symbolrate 27500000, coderate auto,
rolloff 0.35
vpid 0x006e, apid 0x0078, sid 0x0082
status 1f | signal  67% | snr  63% | ber 1 | unc -2 | FE_HAS_LOCK
Delay zap_to : 1.774598

>>> Das Erste
zapping to 1 'Das Erste':
delivery DVB-S2, modulation QPSK
sat 0, frequency 11836 MHz H, symbolrate 27500000, coderate auto,
rolloff 0.35
vpid 0x0065, apid 0x0066, sid 0x0068
status 1f | signal  69% | snr  67% | ber 1 | unc -2 | FE_HAS_LOCK
Delay zap_to : 1.772805

=> Not good, whenver you use both tuners you will see tuning times to
increase from approx. 0.5 secs to 1.7 secs.


*Problem B revisited * *****************************

We also found that when reading data from the dvr device immediately
after tuning was completed (e.g. the lock was successful), then approx.
once in 50 iterations, we still get "old" data from the device. With
"old" I mean from the transponder previously tuned to.

This results, for example, in the wrong "old" PAT received first.

Work-around: Simple and annoying. Add a sleep(1) before starting to read
from device.

*Remark*

Both problems can _not_ be reproduced with any other board we tested
(Tevii, KNC, ..)


