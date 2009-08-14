Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <chaos.tugraz@gmail.com>) id 1MbqKJ-00089Q-Jy
	for linux-dvb@linuxtv.org; Fri, 14 Aug 2009 08:31:48 +0200
Received: by fg-out-1718.google.com with SMTP id 13so283991fge.2
	for <linux-dvb@linuxtv.org>; Thu, 13 Aug 2009 23:31:43 -0700 (PDT)
Message-ID: <4A8504BE.5010406@gmail.com>
Date: Fri, 14 Aug 2009 08:31:26 +0200
From: Markus Schuss <chaos.tugraz@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Technotrend TT-Connect S-2400
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

i have some problems getting a technotrend tt-connect s-2400 usb dvb-s 
card to work. the problem is not unknown (as mentioned at 
http://lkml.org/lkml/2009/5/23/95) but i have no idea how to fix this. 
(any help according to the remote of this card would also be appreciated)

dmesg:
usb 2-2.1: new high speed USB device using ehci_hcd and address 19
usb 2-2.1: configuration #1 chosen from 1 choice
dvb-usb: found a 'Technotrend TT-connect S-2400' in cold state, will try 
to load a firmware
usb 2-2.1: firmware: requesting dvb-usb-tt-s2400-01.fw
dvb-usb: downloading firmware from file 'dvb-usb-tt-s2400-01.fw'
usb 2-2.1: USB disconnect, address 19
dvb-usb: generic DVB-USB module successfully deinitialized and 
disconnected.
usb 2-2.1: new high speed USB device using ehci_hcd and address 20
usb 2-2.1: configuration #1 chosen from 1 choice
dvb-usb: found a 'Technotrend TT-connect S-2400' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (Technotrend TT-connect S-2400)
DVB: registering adapter 0 frontend 0 (Philips TDA10086 DVB-S)...
LNBx2x attached on addr=8<3>dvb-usb: recv bulk message failed: -110
ttusb2: there might have been an error during control message transfer. 
(rlen = 0, was 0)
dvb-usb: Technotrend TT-connect S-2400 successfully initialized and 
connected.

Thanks,
schuschu



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
