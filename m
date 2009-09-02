Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp1smtp.danhost.dk ([89.221.175.11]:35088 "EHLO cp1smtp.www1.dk"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZIBLaq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Sep 2009 07:30:46 -0400
Received: from localhost (unknown [89.221.175.57])
	by cp1smtp.www1.dk (Postfix) with ESMTP id 5184E70176
	for <linux-media@vger.kernel.org>; Wed,  2 Sep 2009 13:21:09 +0200 (CEST)
MIME-Version: 1.0
Message-ID: <41138.1251890451@rokamp.dk>
To: <linux-media@vger.kernel.org>
Reply-To: thomas@rokamp.dk
Content-Type: text/plain; charset="utf-8"
Date: Wed, 02 Sep 2009 13:20:51 +0200
Subject: Problems with Hauppauge Nova-T USB2
From: Thomas Rokamp <thomas@rokamp.dk>
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I have found my old Hauppauge Nova-T USB2 box. It's the old revision, with and USB ID 9301.
I'm struggling to get it to work correctly under linux (Ubuntu Intrepid 2.6.27-11-server). So far all I have read and tried has been without success.

I'm running the latest checked out v4l-dvb drivers (using hg).

I have tested the box on the same location using windows, and "everything works fine".

My setup is a bit odd though. I have TV supplied from my local cable company, yet they have decided to supply the DVB signal using DVB-T. I guess it's because most of the TV's where I live supports DVB-T only. The signal is provided through the same plu in the wall as the old analog signal, though this should not be a problem, it works in windows. 

I have tried various tools from dvb-apps, the output supplied further down...

dmesg | grep dvb:
(I'm quite sure the MAC address it suggest is random upon each boot, which sounds like trouble to me)

dvb-usb: found a 'Hauppauge WinTV-NOVA-T usb2' in cold state, will try to load a firmware
firmware: requesting dvb-usb-nova-t-usb2-02.fw
dvb-usb: downloading firmware from file 'dvb-usb-nova-t-usb2-02.fw'
usbcore: registered new interface driver dvb_usb_nova_t_usb2
dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
dvb-usb: found a 'Hauppauge WinTV-NOVA-T usb2' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
dvb-usb: MAC address: f5c9c8e4
dvb-usb: schedule remote query interval to 100 msecs.
dvb-usb: Hauppauge WinTV-NOVA-T usb2 successfully initialized and connected.

Using 'scan' I have come to a channel.conf file, out of which I have added just one line to channels.conf:
X:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_5_6:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:513:644:905

Using the above channels.conf file as input to tzap, I get the following lines:

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '.tzap/channels.conf'
tuning to 722000000 Hz
video pid 0x0201, audio pid 0x0284
status 1f | signal 7bd3 | snr 0000 | ber 001fffff | unc 00000000 | FE_HAS_LOCK
status 1f | signal 7b94 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 7b7d | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 7b77 | snr 0000 | ber 00000090 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 7b79 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 7b70 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK

As you can see from above, the signal-to-noise ratio is, well... bad. I was hoping (according to my readings) a value much higher.

Trying to record something with dvbstream:
dvbstream -n 5 -qam 64 -gi 16 -cr 5_6 -crlp 5_6 -bw 8 -tm 2 -hy NONE -f 722000000 513 644 -o > test.mpg
dvbstream v0.6 - (C) Dave Chapman 2001-2004
Released under the GPL.
Latest version available from http://www.linuxstb.org/
Tuning to 722000000 Hz
Using DVB card "DiBcom 3000MC/P", freq=722000000
tuning DVB-T (in United Kingdom) to 722000000 Hz, Bandwidth: 8
Getting frontend status
Event:  Frequency: 722000000
Bit error rate: 2097151
Signal strength: 31503
SNR: 0
UNC: 0
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC
dvbstream will stop after 5 seconds (0 minutes)
Output to stdout
Streaming 3 streams
Caught signal 1 - closing cleanly.


This 'test.mpg' output file, however, shows no video at all, despite it actually containing data. VLC reports 'nothing to play'.


Any help at this point would be highly appreciated :-)

Best regards,
Thomas Rokamp
