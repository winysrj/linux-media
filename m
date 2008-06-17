Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <scachi@gmx.de>) id 1K8iId-0006WC-2i
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 23:01:07 +0200
Date: Tue, 17 Jun 2008 23:00:31 +0200
From: Ingo Arndt <scachi@gmx.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080617230031.62106ea6@chicken.porkynet>
Mime-Version: 1.0
Subject: [linux-dvb] Pinnacle PCTV Dual DVB-T Diversity Stick built in
 IR-Receiver supported ?
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

I have a Pinnacle PCTV Dual DVB-T Diversity Stick which works fine (I use kaffeine).
The only thing I am missing is the built-in infrared receiver which is not recognized.

Am I missing a module, a module option or something else 
or is the ir receiver just not supported by now ?

I use the kernel 2.6.24 with tuxonice-patches.

lsusb output:
------------------------- lsusb output start ---
idVendor           0x2304 Pinnacle Systems, Inc. [hex]
  idProduct          0x0229 
  bcdDevice            0.01
  iManufacturer           1 PINNACLE
  iProduct                2 PCTV 2001e
  iSerial                 3 12027630
------------------------- lsusb output stop ---


mesg output:
---------------- dmesg code start ---
usb 7-3: new high speed USB device using ehci_hcd and address 9
usb 7-3: configuration #1 chosen from 1 choice
dvb-usb: found a 'Pinnacle PCTV Dual DVB-T Diversity Stick' in cold state, will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'Pinnacle PCTV Dual DVB-T Diversity Stick' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Pinnacle PCTV Dual DVB-T Diversity Stick)
DVB: registering frontend 0 (DiBcom 7000PC)...
DiB0070: successfully identified
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Pinnacle PCTV Dual DVB-T Diversity Stick)
DVB: registering frontend 1 (DiBcom 7000PC)...
DiB0070: successfully identified
dvb-usb: Pinnacle PCTV Dual DVB-T Diversity Stick successfully
initialized and connected.
----------------- dmesg code end ---

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
