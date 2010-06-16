Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56856 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab0FPKY1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jun 2010 06:24:27 -0400
Received: by gye5 with SMTP id 5so3824438gye.19
        for <linux-media@vger.kernel.org>; Wed, 16 Jun 2010 03:24:27 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 16 Jun 2010 11:24:27 +0100
Message-ID: <AANLkTiny9YXXT185VbNuw-z6aZDdIfS50UxFLERdlY-z@mail.gmail.com>
Subject: Trouble getting DVB-T working with Portuguese transmissions
From: =?UTF-8?Q?Pedro_C=C3=B4rte=2DReal?= <pedro@pedrocr.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've been trying to use the Portuguese DVB-T transmissions. These are
h264 unencrypted transmissions. I bought an Asus My Cinema U3100 mini,
which seems to be correctly recognized by the dib0700 driver in Ubuntu
10.04 (kernel 2.6.32-22-generic). I can try the latest upstream kernel
to see if anything has changed. From the dmesg:

[ 2118.910130] usb 1-3: new high speed USB device using ehci_hcd and address 6
[ 2119.061233] usb 1-3: configuration #1 chosen from 1 choice
[ 2119.062384] dvb-usb: found a 'ASUS My Cinema U3100 Mini DVBT Tuner'
in cold state, will try to load a firmware
[ 2119.062396] usb 1-3: firmware: requesting dvb-usb-dib0700-1.20.fw
[ 2119.066293] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[ 2119.273034] dib0700: firmware started successfully.
[ 2119.784908] dvb-usb: found a 'ASUS My Cinema U3100 Mini DVBT Tuner'
in warm state.
[ 2119.785018] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[ 2119.785368] DVB: registering new adapter (ASUS My Cinema U3100 Mini
DVBT Tuner)
[ 2120.027066] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[ 2120.247440] DiB0070: successfully identified
[ 2120.247609] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1a.7/usb1/1-3/input/input11
[ 2120.247724] dvb-usb: schedule remote query interval to 50 msecs.
[ 2120.247732] dvb-usb: ASUS My Cinema U3100 Mini DVBT Tuner
successfully initialized and connected.

The messages talk about MPEG2 so I don't know if there is anything in
the driver that doesn't work with MPEG4/h264.

dvb-apps doesn't include a scan file for Portugal but the relevant
line seems to be:

T 842000000 8MHz 2/3 1/2 QAM64 8k 1/4 NONE    # RTP1, RTP2, SIC, TVI

This should work for almost everywhere except in the Azores islands
where several frequencies are used. I can submit a full set of files
to be included with dvb-apps. Scanning doesn't usually work:

$ scan /usr/share/dvb/dvb-t/pt-Porto -v -o zap > channels.conf
scanning /usr/share/dvb/dvb-t/pt-Porto
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 842000000 0 2 1 3 1 3 0
>>> tune to: 842000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
>>> tuning status == 0x1b
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
dumping lists (0 services)
Done.

There was however one time where it did work. I though it was because
I had set fec_lo to 1/2 where before was NONE but after a reboot it
stopped working again. The time it did work it generated the following
channels.conf:

RTP 1:842000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:256:257:1101
RTP 2:842000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:512:513:1102
SIC:842000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:768:769:1103
TVI:842000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:1024:1025:1104
HD:842000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:3840:3841:1111

Using vlc and either this channels.conf or just tuning to 842Mhz
directly no sound or image is obtained and continuous error messages
like these come out:

libdvbpsi error (PSI decoder): TS discontinuity (received 6, expected
1) for PID 0

Using mplayer produces a similar result:

dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 1484 bytes

Any ideas on how to get this working?

Pedro
