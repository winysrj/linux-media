Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from u15184586.onlinehome-server.com ([82.165.244.70])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mark@metrofindings.com>) id 1KohSq-00017Z-F6
	for linux-dvb@linuxtv.org; Sat, 11 Oct 2008 18:37:15 +0200
From: Mark Kimsal <mark@metrofindings.com>
To: linux-dvb@linuxtv.org
Date: Sat, 11 Oct 2008 12:37:03 -0400
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810111237.03155.mark@metrofindings.com>
Subject: [linux-dvb] Sabrent/Auvitek unknown USB device
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
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

I have this generic USB TV-ATSC, NTSC, QAM tuner/decoder.  Tiger direct lists 
the brand as "sabrent".  These are the products specs I believe

http://www.sabrent.com/products/specs/TV-USBHD.htm

When I plug it in, lsusb tells me 

Bus 001 Device 004: ID 05e1:0400 Syntek Semiconductor Co., Ltd
Bus 001 Device 001: ID 0000:0000
Bus 003 Device 001: ID 0000:0000
Bus 002 Device 001: ID 0000:0000

The 0400 product ID is unknown in my distro.  05e1 is the manufacturer ID 
for "syntek", but I think that syntek just makes the USB interface for the 
entire HDTV stick.

when I plug it in, dmesg tells me

usb 1-2: new high speed USB device using ehci_hcd and address 4
usb 1-2: configuration #1 chosen from 1 choice

Windows recognizes the device as "AUVITEK" brand and lists an auvitek audio 
and video decoder in the Windows' device manager.

I have Windows 32bit, and Mandriva 2008.1 64 bit.  What do I need to do to get 
this thing working?  I hope it's as simple as recompiling one of the auvitek 
drivers with a new USB ID, but I'm not sure.

-- 
Mark Kimsal
http://biz.metrofindings.com/
Fax: 866-375-1590

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
