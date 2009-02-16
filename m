Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns01.unsolicited.net ([69.10.132.115]:60642 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZBPUDx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 15:03:53 -0500
Message-ID: <4999C068.6060400@unsolicited.net>
Date: Mon, 16 Feb 2009 19:37:12 +0000
From: David <david@unsolicited.net>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Technotrend TT-connect S-2400 - worked in only one kernel release
 (2.6.26)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a bug report in bugzilla about this one, but I'm wondering if
anyone else is seeing problems with this (USB) device. I see the
following timeout in kernel versions beyond 2.6.26

[ 3086.636035] usb 3-10: new high speed USB device using ehci_hcd and
address 7
[ 3086.769507] usb 3-10: configuration #1 chosen from 1 choice
[ 3087.066065] dvb-usb: found a 'Technotrend TT-connect S-2400' in cold
state, will try to load a firmware
[ 3087.066073] usb 3-10: firmware: requesting dvb-usb-tt-s2400-01.fw
[ 3087.102717] dvb-usb: downloading firmware from file
'dvb-usb-tt-s2400-01.fw'
[ 3087.165343] usbcore: registered new interface driver dvb_usb_ttusb2
[ 3087.166071] usb 3-10: USB disconnect, address 7
[ 3087.169039] dvb-usb: generic DVB-USB module successfully
deinitialized and disconnected.
[ 3088.928027] usb 3-10: new high speed USB device using ehci_hcd and
address 8
[ 3089.061927] usb 3-10: configuration #1 chosen from 1 choice
[ 3089.062504] dvb-usb: found a 'Technotrend TT-connect S-2400' in warm
state.
[ 3089.063148] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[ 3089.063404] DVB: registering new adapter (Technotrend TT-connect S-2400)
[ 3089.074375] DVB: registering adapter 0 frontend 0 (Philips TDA10086
DVB-S)...
[ 3091.076106] dvb-usb: recv bulk message failed: -110
[ 3091.076113] ttusb2: there might have been an error during control
message transfer. (rlen = 0, was 0)
[ 3091.076349] dvb-usb: Technotrend TT-connect S-2400 successfully
initialized and connected.


the 2.6.26 trace looks normal.

usb 1-3: new high speed USB device using ehci_hcd and address 14
usb 1-3: configuration #1 chosen from 1 choice
dvb-usb: found a 'Technotrend TT-connect S-2400' in cold state, will try
to load a firmware
firmware: requesting dvb-usb-tt-s2400-01.fw
dvb-usb: downloading firmware from file 'dvb-usb-tt-s2400-01.fw'
usb 1-3: USB disconnect, address 14
dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
usb 1-3: new high speed USB device using ehci_hcd and address 15
usb 1-3: configuration #1 chosen from 1 choice
dvb-usb: found a 'Technotrend TT-connect S-2400' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (Technotrend TT-connect S-2400)
DVB: registering frontend 3 (Philips TDA10086 DVB-S)...
dvb-usb: Technotrend TT-connect S-2400 successfully initialized and
connected.


Cheers
David
