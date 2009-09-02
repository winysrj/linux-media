Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [89.221.175.11] (helo=cp1smtp.www1.dk)
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <thomas@rokamp.dk>) id 1MioCE-0007hN-Gu
	for linux-dvb@linuxtv.org; Wed, 02 Sep 2009 13:40:16 +0200
Received: from localhost (unknown [89.221.175.57])
	by cp1smtp.www1.dk (Postfix) with ESMTP id 94A227056A
	for <linux-dvb@linuxtv.org>; Wed,  2 Sep 2009 13:39:50 +0200 (CEST)
MIME-Version: 1.0
Message-ID: <54953.1251891572@rokamp.dk>
To: <linux-dvb@linuxtv.org>
Date: Wed, 02 Sep 2009 13:39:32 +0200
From: Thomas Rokamp <thomas@rokamp.dk>
Subject: [linux-dvb] Problems with Hauppauge Nova-T USB2
Reply-To: linux-media@vger.kernel.org, thomas@rokamp.dk
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

(sorry if you already got this mail, I think I had sent it to the wrong list to begin with)

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
Event: Frequency: 722000000
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
 

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
