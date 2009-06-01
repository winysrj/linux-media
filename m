Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:51886 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbZFAAuV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 20:50:21 -0400
Message-ID: <4A232498.2080202@retrodesignfan.eu>
Date: Mon, 01 Jun 2009 02:45:12 +0200
From: Marco Borm <linux-dvb@retrodesignfan.eu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Terratec DT USB XS Diversity/DiB0070+vdr: "URB status: Value too
 large for defined data type"+USB reset
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

yesterday I bought  a Terratec Cinergy DT USB XS Diversity and the 
device works just plug&play and without problems under Windows AND linux 
mplayer+ tzap but resets the whole USB bus very shortly after I starting 
vdr. I don't think this has something to do with vdr itself, so I 
posting here.

My configuration is Debian on testing, kernel is 
2.6.29-4.slh.1-sidux-686, DVB drivers aren't self compiled, vdr is 
"(1.6.0-2/1.6.0)", device info: ID 0ccd:0081 TerraTec Electronic GmbH.
log entries:
Jun  1 01:14:47 vdr kernel: dib0700: loaded with support for 8 different 
device-types
Jun  1 01:14:47 vdr kernel: dvb-usb: found a 'Terratec Cinergy DT USB XS 
Diversity' in warm state.
Jun  1 01:14:47 vdr kernel: dvb-usb: will pass the complete MPEG2 
transport stream to the software demuxer.
Jun  1 01:14:47 vdr kernel: DVB: registering new adapter (Terratec 
Cinergy DT USB XS Diversity)
Jun  1 01:14:47 vdr kernel: DVB: registering adapter 1 frontend 0 
(DiBcom 7000PC)...
Jun  1 01:14:47 vdr kernel: DiB0070: successfully identified
Jun  1 01:14:47 vdr kernel: dvb-usb: will pass the complete MPEG2 
transport stream to the software demuxer.
Jun  1 01:14:47 vdr kernel: DVB: registering new adapter (Terratec 
Cinergy DT USB XS Diversity)
Jun  1 01:14:47 vdr kernel: DVB: registering adapter 2 frontend 0 
(DiBcom 7000PC)...
Jun  1 01:14:47 vdr kernel: DiB0070: successfully identified
Jun  1 01:14:47 vdr kernel: dvb-usb: Terratec Cinergy DT USB XS 
Diversity successfully initialized and connected.
Jun  1 01:14:47 vdr kernel: usbcore: registered new interface driver 
dvb_usb_dib0700
vdr start -> Jun  1 01:16:24 vdr logger: runvdr get_modulenames: 
dvb_usb#012videobuf_dvb#012cx88_dvb dvb_core
USB reset -> Jun  1 01:18:00 vdr kernel: usb 1-2: USB disconnect, [... 
all devices reconnecting to the bus ....]
Jun  1 01:18:28 vdr kernel: DiB0070 I2C write failed
Jun  1 01:18:28 vdr kernel: DiB0070 I2C read failed
Jun  1 01:18:28 vdr kernel: DiB0070 I2C write failed
Jun  1 01:18:28 vdr kernel: DiB0070 I2C write failed
Jun  1 01:18:28 vdr kernel: DiB0070 I2C write failed
[...]

This logs aren't very helpful, but I find something interesting with 
Wireshark and usbmon:
device -> host
URB type: URB_COMPLETE ('C')
URB transfer type: URB_BULK (3)
Endpoint: 0x83
Device: 13
Data: present (0)
URB status: Value too large for defined data type (-EOVERFLOW) (-75)
URB length [bytes]: 39424
Data length [bytes]: 39424

after this URB I get a "URB transfer type: URB_INTERRUPT (1)" and all 
goes to hell.

Its also  interesting that the URB+data length in the failure package is 
39424 but "URB length [bytes]: 39480" in every package before that.

As I know this device works without problems under linux for other 
people, so I'm wondering why. I searched but found nothing about such a 
problem.

The wireshark capturefile is downloadable here: 
http://rapidshare.com/files/239429647/terratec-xs-usb-overflow.html


Thanks for hints,
Marco Borm
