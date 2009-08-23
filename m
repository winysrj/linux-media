Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:35108 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZHWEwh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 00:52:37 -0400
Received: by fxm17 with SMTP id 17so1002632fxm.37
        for <linux-media@vger.kernel.org>; Sat, 22 Aug 2009 21:52:37 -0700 (PDT)
Message-ID: <4A90CA6B.4080303@gmail.com>
Date: Sun, 23 Aug 2009 06:49:47 +0200
From: Markus Schuss <chaos.tugraz@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Technotrend TT-Connect S-2400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
