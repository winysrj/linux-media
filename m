Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns01.unsolicited.net ([69.10.132.115]:43762 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbZEWSX1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 14:23:27 -0400
Message-ID: <4A183E5E.1070502@unsolicited.net>
Date: Sat, 23 May 2009 19:20:14 +0100
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
References: <Pine.LNX.4.44L0.0905231109140.18397-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0905231109140.18397-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alan Stern wrote:
> On Sat, 23 May 2009, Pekka Enberg wrote:
>
>   
>> On Sat, May 23, 2009 at 12:32 AM, David <david@unsolicited.net> wrote:
>>     
>>> I reported this DVB-S card breaking between 2.6.26 and 2.6.27. I've
>>> finally had time to do some digging, and the regression is caused by:
>>>
>>>    b963801164618e25fbdc0cd452ce49c3628b46c8 USB: ehci-hcd unlink speedups
>>>
>>> ..that was introduced in 2.6.27. Reverting this change in 2.6.29-rc5
>>> makes the card work happily again.
>>>       
>> [ Note: David meant 2.6.30-rc5 here. ]
>>
>> Thanks for doing the bisect!
>>
>> On Sat, May 23, 2009 at 12:32 AM, David <david@unsolicited.net> wrote:
>>     
>>> I don't know enough about USB protocols to speculate on whether there
>>> may be a better fix, but hopefully someone cleverer than me can get to
>>> the bottom of the problem?
>>>       
>
> It's hard to see how that patch could cause any problems, provided the
> hardware is working correctly.  (There was a case where the hardware
> was _not_ working as expected.)  Is any more information available
> about this failure?
>   
Here's all I have. The device is a USB connected Technotrend TT-Connect
S-2400. Support for this was added in kernel 2.6.26. When I came to
upgrade my media PC beyond .26 the dmesg showed the following:-

Media PC (32-bit - Nvidia chipset. kernel 2.6.27)

19:13:18 s kernel: usb 1-3: new high speed USB device using ehci_hcd and
address 6
19:13:18 s kernel: usb 1-3: configuration #1 chosen from 1 choice
19:13:18 s kernel: dvb-usb: found a 'Technotrend TT-connect S-2400' in
cold state, will try to load a firmware
19:13:18 s kernel: firmware: requesting dvb-usb-tt-s2400-01.fw
19:13:18 s kernel: dvb-usb: downloading firmware from file
'dvb-usb-tt-s2400-01.fw'
19:13:18 s kernel: usb 1-3: USB disconnect, address 6
19:13:18 s kernel: dvb-usb: generic DVB-USB module successfully
deinitialized and disconnected.
19:13:20 s kernel: usb 1-3: new high speed USB device using ehci_hcd and
address 7
19:13:20 s kernel: usb 1-3: configuration #1 chosen from 1 choice
19:13:20 s kernel: dvb-usb: found a 'Technotrend TT-connect S-2400' in
warm state.
19:13:20 s kernel: dvb-usb: will pass the complete MPEG2 transport
stream to the software demuxer.
19:13:20 s kernel: DVB: registering new adapter (Technotrend TT-connect
S-2400)
19:13:20 s kernel: DVB: registering frontend 0 (Philips TDA10086 DVB-S)...
19:13:23 s kernel: dvb-usb: recv bulk message failed: -110
19:13:23 s kernel: ttusb2: there might have been an error during control
message transfer. (rlen = 0, was 0)
19:13:23 s kernel: dvb-usb: Technotrend TT-connect S-2400 successfully
initialized and connected.

The device times out. Reverting b963801164618e25fbdc0cd452ce49c3628b46c8
causes it to work again

19:09:53 s kernel: usb 1-3: new high speed USB device using ehci_hcd and
address 5
19:09:53 s kernel: usb 1-3: configuration #1 chosen from 1 choice
19:09:58 s kernel: dvb-usb: found a 'Technotrend TT-connect S-2400' in
cold state, will try to load a firmware
19:09:58 s kernel: firmware: requesting dvb-usb-tt-s2400-01.fw
19:09:59 s kernel: dvb-usb: downloading firmware from file
'dvb-usb-tt-s2400-01.fw'
19:09:59 s kernel: usb 1-3: USB disconnect, address 5
19:09:59 s kernel: dvb-usb: generic DVB-USB module successfully
deinitialized and disconnected.
19:09:59 s kernel: usbcore: registered new interface driver dvb_usb_ttusb2
19:10:00 s kernel: usb 1-3: new high speed USB device using ehci_hcd and
address 6
19:10:00 s kernel: usb 1-3: configuration #1 chosen from 1 choice
19:10:01 s kernel: dvb-usb: found a 'Technotrend TT-connect S-2400' in
warm state.
19:10:01 s kernel: dvb-usb: will pass the complete MPEG2 transport
stream to the software demuxer.
19:10:01 s kernel: DVB: registering new adapter (Technotrend TT-connect
S-2400)
19:10:01 s kernel: DVB: registering frontend 3 (Philips TDA10086 DVB-S)...
19:10:01 s kernel: dvb-usb: Technotrend TT-connect S-2400 successfully
initialized and connected.

My PC (64 bit - ATI chipset, using 2.6.30-rc5)

[12044.364021] usb 4-10: new high speed USB device using ehci_hcd and
address 5
[12044.497561] usb 4-10: configuration #1 chosen from 1 choice
[12044.881621] dvb-usb: found a 'Technotrend TT-connect S-2400' in cold
state, will try to load a firmware
[12044.881626] usb 4-10: firmware: requesting dvb-usb-tt-s2400-01.fw
[12044.918854] dvb-usb: downloading firmware from file
'dvb-usb-tt-s2400-01.fw'
[12044.980719] usbcore: registered new interface driver dvb_usb_ttusb2
[12044.981478] usb 4-10: USB disconnect, address 5
[12044.985169] dvb-usb: generic DVB-USB module successfully
deinitialized and disconnected.
[12046.744023] usb 4-10: new high speed USB device using ehci_hcd and
address 6
[12046.876980] usb 4-10: configuration #1 chosen from 1 choice
[12046.877673] dvb-usb: found a 'Technotrend TT-connect S-2400' in warm
state.
[12046.878601] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[12046.878959] DVB: registering new adapter (Technotrend TT-connect S-2400)
[12046.886861] DVB: registering adapter 0 frontend 0 (Philips TDA10086
DVB-S)...
[12046.891434] LNBx2x attached on addr=8<3>dvb-usb: recv bulk message
failed: -110
[12048.888080] ttusb2: there might have been an error during control
message transfer. (rlen = 0, was 0)
[12048.888320] dvb-usb: Technotrend TT-connect S-2400 successfully
initialized and connected.

Reverting b963801164618e25fbdc0cd452ce49c3628b46c8 (manually, as there
are conflicting changes) causes it to work again. The wierd random
frontend number looks strange though.

[ 2406.492027] usb 2-10: new high speed USB device using ehci_hcd and
address 7
[ 2406.625622] usb 2-10: configuration #1 chosen from 1 choice
[ 2406.626328] dvb-usb: found a 'Technotrend TT-connect S-2400' in cold
state, will try to load a firmware
[ 2406.626335] usb 2-10: firmware: requesting dvb-usb-tt-s2400-01.fw
[ 2406.628650] dvb-usb: downloading firmware from file
'dvb-usb-tt-s2400-01.fw'
[ 2406.690868] usb 2-10: USB disconnect, address 7
[ 2406.693282] dvb-usb: generic DVB-USB module successfully
deinitialized and disconnected.
[ 2408.453024] usb 2-10: new high speed USB device using ehci_hcd and
address 8
[ 2408.585983] usb 2-10: configuration #1 chosen from 1 choice
[ 2408.586652] dvb-usb: found a 'Technotrend TT-connect S-2400' in warm
state.
[ 2408.587727] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[ 2408.588080] DVB: registering new adapter (Technotrend TT-connect S-2400)
[ 2408.591575] DVB: registering adapter 0 frontend 42056112 (Philips
TDA10086 DVB-S)...
[ 2408.595941] LNBx2x attached on addr=8<6>dvb-usb: Technotrend
TT-connect S-2400 successfully initialized and connected.

I'm happy to do any further diagnostics if it will help.

David


