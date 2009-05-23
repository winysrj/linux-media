Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:57099 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753672AbZEWVCh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 17:02:37 -0400
Date: Sat, 23 May 2009 17:02:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: David <david@unsolicited.net>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
	<linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	<dbrownell@users.sourceforge.net>, <leonidv11@gmail.com>,
	Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
  down
In-Reply-To: <4A184CDF.1020901@unsolicited.net>
Message-ID: <Pine.LNX.4.44L0.0905231657210.22430-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 23 May 2009, David wrote:

> My PC (64 bit - ATI chipset, using 2.6.30-rc5)

Let's continue to work with 2.6.30-rc for testing purposes.

> [12044.364021] usb 4-10: new high speed USB device using ehci_hcd and address 5
> [12044.497561] usb 4-10: configuration #1 chosen from 1 choice
> [12044.881621] dvb-usb: found a 'Technotrend TT-connect S-2400' in cold state, will try to load a firmware
> [12044.881626] usb 4-10: firmware: requesting dvb-usb-tt-s2400-01.fw
> [12044.918854] dvb-usb: downloading firmware from file 'dvb-usb-tt-s2400-01.fw'
> [12044.980719] usbcore: registered new interface driver dvb_usb_ttusb2
> [12044.981478] usb 4-10: USB disconnect, address 5
> [12044.985169] dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
> [12046.744023] usb 4-10: new high speed USB device using ehci_hcd and address 6
> [12046.876980] usb 4-10: configuration #1 chosen from 1 choice
> [12046.877673] dvb-usb: found a 'Technotrend TT-connect S-2400' in warm state.
> [12046.878601] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> [12046.878959] DVB: registering new adapter (Technotrend TT-connect S-2400)
> [12046.886861] DVB: registering adapter 0 frontend 0 (Philips TDA10086 DVB-S)...
> [12046.891434] LNBx2x attached on addr=8<3>dvb-usb: recv bulk message failed: -110
> [12048.888080] ttusb2: there might have been an error during control message transfer. (rlen = 0, was 0)
> [12048.888320] dvb-usb: Technotrend TT-connect S-2400 successfully initialized and connected.

Yes, there's an obvious problem.

> Reverting b963801164618e25fbdc0cd452ce49c3628b46c8 (manually, as there
> are conflicting changes) causes it to work again. The wierd random
> frontend number looks strange though.
> 
> [ 2406.492027] usb 2-10: new high speed USB device using ehci_hcd and address 7
> [ 2406.625622] usb 2-10: configuration #1 chosen from 1 choice
> [ 2406.626328] dvb-usb: found a 'Technotrend TT-connect S-2400' in cold state, will try to load a firmware
> [ 2406.626335] usb 2-10: firmware: requesting dvb-usb-tt-s2400-01.fw
> [ 2406.628650] dvb-usb: downloading firmware from file 'dvb-usb-tt-s2400-01.fw'
> [ 2406.690868] usb 2-10: USB disconnect, address 7
> [ 2406.693282] dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
> [ 2408.453024] usb 2-10: new high speed USB device using ehci_hcd and address 8
> [ 2408.585983] usb 2-10: configuration #1 chosen from 1 choice
> [ 2408.586652] dvb-usb: found a 'Technotrend TT-connect S-2400' in warm state.
> [ 2408.587727] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> [ 2408.588080] DVB: registering new adapter (Technotrend TT-connect S-2400)
> [ 2408.591575] DVB: registering adapter 0 frontend 42056112 (Philips TDA10086 DVB-S)...
> [ 2408.595941] LNBx2x attached on addr=8<6>dvb-usb: Technotrend TT-connect S-2400 successfully initialized and connected.

I don't know what's going on with that frontend number.  In fact, I 
don't know anything about DVB in general... but I am familiar with 
EHCI.

It's not obvious what could be causing this, so let's start out easy.  
Try collecting two usbmon traces (instructions are in
Documentation/usb/usbmon.txt), showing what happens with and without
the reversion.  Maybe some difference will stick out.

Alan Stern

