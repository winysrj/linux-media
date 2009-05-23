Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns01.unsolicited.net ([69.10.132.115]:60879 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbZEWTZW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 15:25:22 -0400
Message-ID: <4A184CDF.1020901@unsolicited.net>
Date: Sat, 23 May 2009 20:22:07 +0100
From: David <david@unsolicited.net>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dbrownell@users.sourceforge.net, leonidv11@gmail.com,
	Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
  down
References: <Pine.LNX.4.44L0.0905231109140.18397-100000@netrider.rowland.org> <4A183E5E.1070502@unsolicited.net>
In-Reply-To: <4A183E5E.1070502@unsolicited.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Again, hopefully with word wrap sorted out...

Media PC (32-bit - Nvidia chipset. kernel 2.6.27)

19:13:18 s kernel: usb 1-3: new high speed USB device using ehci_hcd and address 6
19:13:18 s kernel: usb 1-3: configuration #1 chosen from 1 choice
19:13:18 s kernel: dvb-usb: found a 'Technotrend TT-connect S-2400' in cold state, will try to load a firmware
19:13:18 s kernel: firmware: requesting dvb-usb-tt-s2400-01.fw
19:13:18 s kernel: dvb-usb: downloading firmware from file 'dvb-usb-tt-s2400-01.fw'
19:13:18 s kernel: usb 1-3: USB disconnect, address 6
19:13:18 s kernel: dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
19:13:20 s kernel: usb 1-3: new high speed USB device using ehci_hcd and address 7
19:13:20 s kernel: usb 1-3: configuration #1 chosen from 1 choice
19:13:20 s kernel: dvb-usb: found a 'Technotrend TT-connect S-2400' in warm state.
19:13:20 s kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
19:13:20 s kernel: DVB: registering new adapter (Technotrend TT-connect S-2400)
19:13:20 s kernel: DVB: registering frontend 0 (Philips TDA10086 DVB-S)...
19:13:23 s kernel: dvb-usb: recv bulk message failed: -110
19:13:23 s kernel: ttusb2: there might have been an error during control message transfer. (rlen = 0, was 0)
19:13:23 s kernel: dvb-usb: Technotrend TT-connect S-2400 successfully initialized and connected.

The device times out. Reverting b963801164618e25fbdc0cd452ce49c3628b46c8
causes it to work again

19:09:53 s kernel: usb 1-3: new high speed USB device using ehci_hcd and address 5
19:09:53 s kernel: usb 1-3: configuration #1 chosen from 1 choice
19:09:58 s kernel: dvb-usb: found a 'Technotrend TT-connect S-2400' in cold state, will try to load a firmware
19:09:58 s kernel: firmware: requesting dvb-usb-tt-s2400-01.fw
19:09:59 s kernel: dvb-usb: downloading firmware from file 'dvb-usb-tt-s2400-01.fw'
19:09:59 s kernel: usb 1-3: USB disconnect, address 5
19:09:59 s kernel: dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
19:09:59 s kernel: usbcore: registered new interface driver dvb_usb_ttusb2
19:10:00 s kernel: usb 1-3: new high speed USB device using ehci_hcd and address 6
19:10:00 s kernel: usb 1-3: configuration #1 chosen from 1 choice
19:10:01 s kernel: dvb-usb: found a 'Technotrend TT-connect S-2400' in warm state.
19:10:01 s kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
19:10:01 s kernel: DVB: registering new adapter (Technotrend TT-connect S-2400)
19:10:01 s kernel: DVB: registering frontend 3 (Philips TDA10086 DVB-S)...
19:10:01 s kernel: dvb-usb: Technotrend TT-connect S-2400 successfully initialized and connected.

My PC (64 bit - ATI chipset, using 2.6.30-rc5)

[12044.364021] usb 4-10: new high speed USB device using ehci_hcd and address 5
[12044.497561] usb 4-10: configuration #1 chosen from 1 choice
[12044.881621] dvb-usb: found a 'Technotrend TT-connect S-2400' in cold state, will try to load a firmware
[12044.881626] usb 4-10: firmware: requesting dvb-usb-tt-s2400-01.fw
[12044.918854] dvb-usb: downloading firmware from file 'dvb-usb-tt-s2400-01.fw'
[12044.980719] usbcore: registered new interface driver dvb_usb_ttusb2
[12044.981478] usb 4-10: USB disconnect, address 5
[12044.985169] dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
[12046.744023] usb 4-10: new high speed USB device using ehci_hcd and address 6
[12046.876980] usb 4-10: configuration #1 chosen from 1 choice
[12046.877673] dvb-usb: found a 'Technotrend TT-connect S-2400' in warm state.
[12046.878601] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[12046.878959] DVB: registering new adapter (Technotrend TT-connect S-2400)
[12046.886861] DVB: registering adapter 0 frontend 0 (Philips TDA10086 DVB-S)...
[12046.891434] LNBx2x attached on addr=8<3>dvb-usb: recv bulk message failed: -110
[12048.888080] ttusb2: there might have been an error during control message transfer. (rlen = 0, was 0)
[12048.888320] dvb-usb: Technotrend TT-connect S-2400 successfully initialized and connected.

Reverting b963801164618e25fbdc0cd452ce49c3628b46c8 (manually, as there
are conflicting changes) causes it to work again. The wierd random
frontend number looks strange though.

[ 2406.492027] usb 2-10: new high speed USB device using ehci_hcd and address 7
[ 2406.625622] usb 2-10: configuration #1 chosen from 1 choice
[ 2406.626328] dvb-usb: found a 'Technotrend TT-connect S-2400' in cold state, will try to load a firmware
[ 2406.626335] usb 2-10: firmware: requesting dvb-usb-tt-s2400-01.fw
[ 2406.628650] dvb-usb: downloading firmware from file 'dvb-usb-tt-s2400-01.fw'
[ 2406.690868] usb 2-10: USB disconnect, address 7
[ 2406.693282] dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
[ 2408.453024] usb 2-10: new high speed USB device using ehci_hcd and address 8
[ 2408.585983] usb 2-10: configuration #1 chosen from 1 choice
[ 2408.586652] dvb-usb: found a 'Technotrend TT-connect S-2400' in warm state.
[ 2408.587727] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[ 2408.588080] DVB: registering new adapter (Technotrend TT-connect S-2400)
[ 2408.591575] DVB: registering adapter 0 frontend 42056112 (Philips TDA10086 DVB-S)...
[ 2408.595941] LNBx2x attached on addr=8<6>dvb-usb: Technotrend TT-connect S-2400 successfully initialized and connected.



