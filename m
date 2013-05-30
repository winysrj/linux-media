Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54014 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab3E3Lj5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 May 2013 07:39:57 -0400
Received: from mailout-de.gmx.net ([10.1.76.17]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LsMuE-1UJz1A1GZs-01232l for
 <linux-media@vger.kernel.org>; Thu, 30 May 2013 13:39:56 +0200
Message-ID: <51A73A88.9000601@gmx.de>
Date: Thu, 30 May 2013 13:39:52 +0200
From: Torsten Seyffarth <t.seyffarth@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Cinergy TStick RC rev.3 (rtl2832u) only 4 programs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hallo all,

I have a problem with a Cinergy TStick RC rev.3 (rtl2832u) DVB-T 
USB-Stick, that I only get 4 programs, all on one transponder. This is 
the full story:

Before I used OpenSUSE 12.2 with a 3.4 Kernel and compiled this driver 
by myself: 
https://github.com/tmair/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0 

This worked fine.

After a hard disk crash I had to install my system anyway so I switched 
to OpenSUSE 12.3 with a 3.7 Kernel, because this should support the 
rtl2832u directly.
Basically this is working. The Stick is detected:
May 30 13:15:37 server kernel: usb 1-3: new high-speed USB device number 
10 using ehci_hcd
May 30 13:15:37 server kernel: usb 1-3: New USB device found, 
idVendor=0ccd, idProduct=00d3
May 30 13:15:37 server kernel: usb 1-3: New USB device strings: Mfr=1, 
Product=2, SerialNumber=3
May 30 13:15:37 server kernel: usb 1-3: Product: RTL2838UHIDIR
May 30 13:15:37 server kernel: usb 1-3: Manufacturer: Realtek
May 30 13:15:37 server kernel: usb 1-3: SerialNumber: 00000001
May 30 13:15:37 server kernel: usb 1-3: dvb_usb_v2: found a 'TerraTec 
Cinergy T Stick RC (Rev. 3)' in warm state
May 30 13:15:37 server mtp-probe[12243]: checking bus 1, device 10: 
"/sys/devices/pci0000:00/0000:00:12.2/usb1/1-3"
May 30 13:15:37 server mtp-probe[12243]: bus: 1, device: 10 was not an 
MTP device
May 30 13:15:37 server kernel: usb 1-3: dvb_usb_v2: will pass the 
complete MPEG2 transport stream to the software demuxer
May 30 13:15:37 server kernel: DVB: registering new adapter (TerraTec 
Cinergy T Stick RC (Rev. 3))
May 30 13:15:37 server kernel: usb 1-3: DVB: registering adapter 0 
frontend 0 (Realtek RTL2832 (DVB-T))...
May 30 13:15:37 server kernel: i2c i2c-5: e4000: Elonics E4000 
successfully identified
May 30 13:15:37 server kernel: Registered IR keymap rc-empty
May 30 13:15:37 server kernel: input: TerraTec Cinergy T Stick RC (Rev. 
3) as /devices/pci0000:00/0000:00:12.2/usb1/1-3/rc/rc7/input23
May 30 13:15:37 server kernel: rc7: TerraTec Cinergy T Stick RC (Rev. 3) 
as /devices/pci0000:00/0000:00:12.2/usb1/1-3/rc/rc7
May 30 13:15:37 server kernel: usb 1-3: dvb_usb_v2: schedule remote 
query interval to 400 msecs
May 30 13:15:37 server kernel: usb 1-3: dvb_usb_v2: 'TerraTec Cinergy T 
Stick RC (Rev. 3)' successfully initialized and connected

These kernel moduls are loaded:
rtl2832                18542  1
dvb_usb_rtl28xxu       28608  0
dvb_usb_v2             34564  2 dvb_usb_af9015,dvb_usb_rtl28xxu
rc_core                30555  4 dvb_usb_af9015,dvb_usb_rtl28xxu,dvb_usb_v2
rtl2830                18316  1 dvb_usb_rtl28xxu
dvb_core              109206  3 rtl2832,dvb_usb_v2,rtl2830


The problem is, that only four DVB-T programs on one transponder can be 
received, but these in a very good quality. It should be around 20 
programs. I tested this with MythTV and Kaffeine and both only find the 
same 4 programs. With a Windows 7 PC and the antenna on the same 
position I get all programs in good quality. So I do not think the stick 
is broken or the quality of the antenna signal is the problem.

Has anyone an idea?

Best
Torsten


