Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from service2.sh.cvut.cz ([147.32.127.218])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janskj1@fel.cvut.cz>) id 1JvAND-0008Qm-KQ
	for linux-dvb@linuxtv.org; Sun, 11 May 2008 14:09:52 +0200
Received: from localhost (localhost [127.0.0.1])
	by service2.sh.cvut.cz (Postfix) with ESMTP id 0398C137719
	for <linux-dvb@linuxtv.org>; Sun, 11 May 2008 14:09:47 +0200 (CEST)
Received: from service2.sh.cvut.cz ([127.0.0.1])
	by localhost (service2.sh.cvut.cz [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 02030-09 for <linux-dvb@linuxtv.org>;
	Sun, 11 May 2008 14:09:39 +0200 (CEST)
Received: from [192.168.7.47] (backup.sh.cvut.cz [147.32.127.226])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by service2.sh.cvut.cz (Postfix) with ESMTP id CDF9213779B
	for <linux-dvb@linuxtv.org>; Sun, 11 May 2008 14:09:39 +0200 (CEST)
Message-ID: <4826E202.1090601@fel.cvut.cz>
Date: Sun, 11 May 2008 14:09:38 +0200
From: Jiri Jansky <janskj1@fel.cvut.cz>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Opera DVB-S1 and few problems
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

Hello,

I've get Opera DVB-S1 - external DVB box made by siemens and I'm not 
able complete install it with DiSEqC switch support. It's look almost 
same as box on this picture - 
http://forum.digitalfernsehen.de/forum/showthread.php?t=99739 (I don't 
speak german).

I opened wiki 
(http://linuxtv.org/wiki/index.php/DVB-S_USB_Devices#SIEMSSEN_.26_CO._-_Opera_S1) 
    and read that this box is supported from version 2.6.22 of linux 
kernel. So, I upgraded kernel and get firmware from internet ( 
http://www.informatik.uni-leipzig.de/~hlawit/dvb/ - files 
dvb-usb-opera1-fpga.fw and dvb-usb-opera-01.fw - I haven't CD with 
original Win driver).

After  using dvb_shutdown_timeout=0 parameter to dvb-core module, it 
seem's it runs fine, but I can't switch from one DiSEqC port to another 
using this card. I have 4 port switch and it's permanent switched to 
second one, even if I inctruct dvbscan or kaffeine to scannig from 
different DiSEqC port, it isn't able switch and if some channel is 
found, it's from satallite connected to second input of DiSEqC switch.

So, I tried more experiment with firmware version and kernel driver. I 
installed 2.6.24 kernel version and tried it with same firmware and with 
firmware get by linux-2.6.24.3/Documentation/dvb/get_dvb_firmware script 
using 2830SCap2.sys 2830SLoad2.sys files get from same page asi .fw 
files and I get new firmware files different from first one. But even 
with old or new firmware files Linux isn't able to lock on giving 
frequency(I'm not able scan or watch programs).

But loading firmware looks fine as under 2.6.22 kernel:
usb 4-3: new high speed USB device using ehci_hcd and address 16
usb 4-3: configuration #1 chosen from 1 choice
dvb-usb: found a 'Opera1 DVB-S USB2.0' in cold state, will try to load a 
firmware
dvb-usb: downloading firmware from file 'dvb-usb-opera-01.fw'
usb 4-3: USB disconnect, address 16
dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
usb 4-3: new high speed USB device using ehci_hcd and address 17
usb 4-3: configuration #1 chosen from 1 choice
opera: start downloading fpga firmware
dvb-usb: found a 'Opera1 DVB-S USB2.0' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (Opera1 DVB-S USB2.0).
dvb-usb: MAC address: 00:e0:4f:00:31:94
DVB: registering frontend 0 (ST STV0299 DVB-S)...
input: IR-receiver inside an USB DVB receiver as /class/input/input11
dvb-usb: schedule remote query interval to 200 msecs.
dvb-usb: Opera1 DVB-S USB2.0 successfully initialized and connected.

(under 2.6.22 kernel firmware files are named dvb-usb-opera-01.fw, 
dvb-usb-opera1-fpga.fw. And under 2.6.24 dvb-usb-opera-01.fw
dvb-usb-opera1-fpga-01.fw ).

Is here anybody who can help my solve this problem and get normal behavior?

Thanks you
Jiri Jansky

PS: I am not good english speeker, so I hope, that my message is 
understandable.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
