Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f196.google.com ([209.85.216.196]:46600 "EHLO
	mail-qc0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaAOUC4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 15:02:56 -0500
Received: by mail-qc0-f196.google.com with SMTP id c9so395729qcz.7
        for <linux-media@vger.kernel.org>; Wed, 15 Jan 2014 12:02:55 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 15 Jan 2014 20:02:55 +0000
Message-ID: <CAC5ubeBq5TSO6UMubE=La8BLktOzy1_1rzR1EothtQ3A14GNbA@mail.gmail.com>
Subject: dvb-usb-dib0700-1.20.fw Issues.
From: Ray Image <imagemagic99@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have tried a couple of USB sticks which use the
dvb-usb-dib0700-1.20.fw firmware in a number of machines running
different linux distros (CentOS, Debian and Raspbian) and I simply
can't get them to work. I have put dvb-usb-dib0700-1.20.fw in
/lib/firmware. Both USB sticks are recognised and loaded (see dmesg
below) but won't tune. I have a PCTV 290e which works perfectly.

Can anyone please help?

Dmesg for Nova-T (this device fails):
[  850.170729] usb 1-2: Product: Nova-T Stick
[  850.170730] usb 1-2: Manufacturer: Hauppauge
[  850.170731] usb 1-2: SerialNumber: 4027796501
[  850.181622] dvb-usb: found a 'Hauppauge Nova-T Stick' in cold
state, will try to load a firmware
[  850.185487] usb 1-2: firmware: agent loaded dvb-usb-dib0700-1.20.fw
into memory
[  853.291628] dib0700: firmware started successfully.
[  853.794138] dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
[  853.794255] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[  853.795277] DVB: registering new adapter (Hauppauge Nova-T Stick)
[  854.350077] DVB: registering adapter 1 frontend 0 (DiBcom 7000PC)...
[  854.359052] MT2060: successfully identified (IF1 = 1220)
[  854.999066] dvb-usb: Hauppauge Nova-T Stick successfully
initialized and connected.

Dmesg for MyTV.t (this device fails):
[  505.753256] usb 1-1: Product: myTV.t
[  505.753257] usb 1-1: Manufacturer: Eskape Labs
[  505.753258] usb 1-1: SerialNumber: 4030928317
[  505.861413] dib0700: loaded with support for 21 different device-types
[  510.853328] dvb-usb: found a 'Hauppauge Nova-T MyTV.t' in cold
state, will try to load a firmware
[  510.924679] usb 1-1: firmware: agent loaded dvb-usb-dib0700-1.20.fw
into memory
[  514.327591] dib0700: firmware started successfully.
[  514.830712] dvb-usb: found a 'Hauppauge Nova-T MyTV.t' in warm state.
[  514.830796] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[  514.832785] DVB: registering new adapter (Hauppauge Nova-T MyTV.t)
[  515.335819] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[  515.789061] DiB0070: successfully identified
[  515.789065] dvb-usb: Hauppauge Nova-T MyTV.t successfully
initialized and connected.
[  515.790175] usbcore: registered new interface driver dvb_usb_dib0700

Dmesg for PCTV290e (this device works):
[  314.918928] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps
(2013:024f, interface 0, class 0)
[  314.920018] em28xx #0: chip ID is em28174
[  315.251613] em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
[  315.331134] Registered IR keymap rc-pinnacle-pctv-hd
[  315.331262] input: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:11.0/0000:02:03.0/usb1/1-1/rc/rc0/input6
[  315.331726] rc0: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:11.0/0000:02:03.0/usb1/1-1/rc/rc0
[  315.338297] em28xx #0: v4l2 driver version 0.1.3
[  315.408548] em28xx #0: V4L2 video device registered as video0
[  315.408572] usbcore: registered new interface driver em28xx
[  315.408573] em28xx driver loaded
[  315.510762] tda18271 0-0060: creating new instance
[  315.540382] TDA18271HD/C2 detected @ 0-0060
[  316.283833] tda18271 0-0060: attaching existing instance
[  316.283836] DVB: registering new adapter (em28xx #0)
[  316.283838] DVB: registering adapter 0 frontend 0 (Sony CXD2820R
(DVB-T/T2))...
[  316.284044] DVB: registering adapter 0 frontend 1 (Sony CXD2820R (DVB-C))...
[  316.284947] em28xx #0: Successfully loaded em28xx-dvb
[  316.284950] Em28xx: Initialized (Em28xx dvb Extension) extension

Output of scan for Nova-T and MyTV.t:
scanning /usr/share/dvb/dvb-t/uk-Hannington
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 706000000 0 3 9 1 0 0 0
initial transponder 650167000 0 2 9 3 0 0 0
initial transponder 626167000 0 2 9 3 0 0 0
initial transponder 674167000 0 3 9 1 0 0 0
initial transponder 658167000 0 3 9 1 0 0 0
initial transponder 634167000 0 3 9 1 0 0 0
>>> tune to: 706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 650167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 650167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 626167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 626167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 674167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 674167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 658167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 658167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 634167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 634167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)


Output of scan for PCTV290e:
root@debian:/dev/dvb# /usr/bin/scan /usr/share/dvb/dvb-t/uk-Hannington
> /home/pookerj/channels.conf
scanning /usr/share/dvb/dvb-t/uk-Hannington
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 706000000 0 3 9 1 0 0 0
initial transponder 650167000 0 2 9 3 0 0 0
initial transponder 626167000 0 2 9 3 0 0 0
initial transponder 674167000 0 3 9 1 0 0 0
initial transponder 658167000 0 3 9 1 0 0 0
initial transponder 634167000 0 3 9 1 0 0 0
>>> tune to: 706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 650167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 650167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 626167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 626167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 674167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 674167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 658167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
0x0000 0x5740: pmt_pid 0x02c1 (null) -- E4+1 (running)
8<---- SNIP! ---->8
0x0000 0x5b00: pmt_pid 0x02e0 (null) -- Proud Dating (running)
Network Name 'Berks & North Hants'
>>> tune to: 634167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
0x0000 0x3340: pmt_pid 0x0000 (null) -- QVC (running)
8<---- SNIP! ---->8
0x0000 0x3e90: pmt_pid 0x0000 (null) -- ITV3+1 (running)
Network Name 'Berks & North Hants'
>>> tune to: 658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
0x5040 0x5740: pmt_pid 0x02c1 (null) -- E4+1 (running)
8<---- SNIP! ---->8
0x5040 0x5b00: pmt_pid 0x02e0 (null) -- Proud Dating (running)
Network Name 'Berks & North Hants'
>>> tune to: 682000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
Network Name 'Berks & North Hants'
0x6040 0x6440: pmt_pid 0x03e9 (null) -- 4Music (running)
8<---- SNIP! ---->8
0x6040 0x6f40: pmt_pid 0x0418 (null) -- Sonlife (running)
>>> tune to: 666000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
0x1043 0x1043: pmt_pid 0x0064 (null) -- BBC ONE South (running)
8<---- SNIP! ---->8
0x1043 0x1c40: pmt_pid 0x0b54 (null) -- 302 (running)
Network Name 'Berks & North Hants'
>>> tune to: 642000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
0x200f 0x204f: pmt_pid 0x06a4 (null) -- ITV (running)
8<---- SNIP! ---->8
0x200f 0x20c1: pmt_pid 0x05dc (null) -- Film4 (running)
Network Name 'Berks & North Hants'
>>> tune to: 634000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
Network Name 'Berks & North Hants'
0x3006 0x3340: pmt_pid 0x010b (null) -- QVC (running)
8<---- SNIP! ---->8
0x3006 0x3e90: pmt_pid 0x01ad (null) -- ITV3+1 (running)
dumping lists (170 services)
Done.
