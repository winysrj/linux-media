Return-path: <linux-media-owner@vger.kernel.org>
Received: from urchin.earth.li ([193.201.200.73]:37574 "EHLO urchin.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbZGJTPz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2009 15:15:55 -0400
Received: from nick (helo=localhost)
	by urchin.earth.li with local-esmtp (Exim 4.69)
	(envelope-from <v4l@gagravarr.org>)
	id 1MPLDL-0002Ea-E1
	for linux-media@vger.kernel.org; Fri, 10 Jul 2009 19:52:55 +0100
Date: Fri, 10 Jul 2009 19:52:55 +0100 (BST)
From: Nick Burch <v4l@gagravarr.org>
To: linux-media@vger.kernel.org
Subject: KWorld USB DVB-T TV Stick II 395U almost but not quite working
Message-ID: <Pine.LNX.4.64.0907101934320.22332@urchin.earth.li>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All

I'm trying to get the KWorld 395U DVB-T usb tuner working, and failing at 
the last hurdle. I think it might be an issue with the tuner chip, but 
here's what I found:

Firstly, driver wise, I tried a stock ubuntu 9.04 2.6.28 kernel and the 
af9015 driver. This driver loaded, but didn't recognise the card as one of 
its, because my card has the newer USB id (1b80:e39b), and the kernel's 
too old for the fix.

Next, I tried with the vendor driver from tombcore.free.fr. This driver 
(AF901X) loads fine, but again won't recognise the cards as one of its. I 
tried adding in the usb ID and recompiling, but it didn't help, though 
that might be due to my DKMS foo not being up to it...

Finally, I grabbed the latest v4l-dvb code from mercurial. I unloaded all 
the old drivers, removed the AF901X driver, and compiled and installed. 
This time, the driver did find the card quite happily:

usb 2-4: new high speed USB device using ehci_hcd and address 4
usb 2-4: configuration #1 chosen from 1 choice
dvb-usb: found a 'KWorld USB DVB-T TV Stick II (VS-DVB-T 395U)' in cold 
state, will try to load a firmware
usb 2-4: firmware: requesting dvb-usb-af9015.fw
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
dvb-usb: found a 'KWorld USB DVB-T TV Stick II (VS-DVB-T 395U)' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (KWorld USB DVB-T TV Stick II (VS-DVB-T 395U))
af9013: firmware version:4.95.0
DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...

After this, /dev/dvb/adapter0/ exists, and contains the entries
     demux0  dvr0  frontend0  net0


Running dvbscan fails though:
   root@myth:/usr/share/dvb# dvbscan dvb-t/uk-Oxford
   Unable to query frontend status

Running dvbtraffic doesn't give any errors, but doesn't give any output 
either!

dvbsnoop is able to query the frontend info just fine:
   dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/

   ---------------------------------------------------------
   FrontEnd Info...
   ---------------------------------------------------------

   Device: /dev/dvb/adapter0/frontend0

   Basic capabilities:
     Name: "Afatech AF9013 DVB-T"
     Frontend-type:       OFDM (DVB-T)
     Frequency (min):     174000.000 kHz
     Frequency (max):     862000.000 kHz
     Frequency stepsiz:   250.000 kHz
     Frequency tolerance: 0.000 kHz
     Symbol rate (min):     0.000000 MSym/s
     Symbol rate (max):     0.000000 MSym/s
     Symbol rate tolerance: 0 ppm
     Notifier delay: 0 ms
     Frontend capabilities:
         auto inversion
         FEC 1/2
         FEC 2/3
         FEC 3/4
         FEC 5/6
         FEC 7/8
         FEC AUTO
         QPSK
         QAM 16
         QAM 64
         QAM AUTO
         auto transmission mode
         auto guard interval
         auto hierarchy

   Current parameters:
     Frequency:  578000.000 kHz
     Inversion:  AUTO
     Bandwidth:  6 MHz
     Stream code rate (hi prio):  FEC 1/2
     Stream code rate (lo prio):  FEC 1/2
     Modulation:  QPSK
     Transmission mode:  2k mode
     Guard interval:  1/32
     Hierarchy:  none

dvbsnoop -s pidscan doesn't return anything, and dvbsnoop -s signal
returns lots of "Sig: 0  SNR: 0  BER: 0  UBLK: 0  Stat: 0x02 [CARR ]"

Finally, trying scan, I get lots of tuning failed warnings:
   root@myth:/usr/share/dvb# scan dvb-t/uk-Oxford
   scanning dvb-t/uk-Oxford
   using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
   initial transponder 578000000 0 3 9 1 0 0 0
   initial transponder 850000000 0 2 9 3 0 0 0
   initial transponder 713833000 0 2 9 3 0 0 0
   initial transponder 721833000 0 3 9 1 0 0 0
   initial transponder 690000000 0 3 9 1 0 0 0
   initial transponder 538000000 0 3 9 1 0 0 0
   >>> tune to:
   578000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
   WARNING: >>> tuning failed!!!
   >>> tune to:
   578000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
   (tuning failed)
   WARNING: >>> tuning failed!!!
   >>> tune to:
   850000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
(etc)

Checking dmesg after a failed scan run, I see these two entries:
   af9015: command failed:2
   qt1010 I2C read failed


Am I right in thinking from this that it's the qt1010 tuner that's the 
problem? If so, can anyone suggest what I should do next to debug the 
issue further?

Thanks
Nick
