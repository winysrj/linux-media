Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:53150 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751674Ab1E1P7M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 11:59:12 -0400
To: linux-media@vger.kernel.org
Subject: Terratec T5 remote control problem
From: Alexander =?iso-8859-1?q?H=E4rtig?= <alexanderhaertig@gmx.de>
Date: Sat, 28 May 2011 17:59:05 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105281759.06006.alexanderhaertig@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I have a Terratec T5 USB DVB-T stick (similiar to TerraTec Cinergy DT USB XS 
Diversity). Receiving TV works like a charm on my OpenSUSE 11.4 (64 bit) 
machine. But I can't get the remote control to work. When I plug in the stick 
dmesg writes the following messages:

[ 8870.704120] usb 2-1: new high speed USB device using ehci_hcd and address 2
[ 8870.819427] usb 2-1: New USB device found, idVendor=0ccd, idProduct=10a1
[ 8870.819436] usb 2-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[ 8870.819443] usb 2-1: Product: TerraTec T5
[ 8870.819448] usb 2-1: Manufacturer: TerraTec
[ 8870.819452] usb 2-1: SerialNumber: 100802000436
[ 8870.820058] dvb-usb: found a 'Terratec Cinergy DT USB XS Diversity/ T5' in 
cold state, will try to load a firmware
[ 8870.871809] dvb-usb: downloading firmware from file 'dvb-usb-
dib0700-1.20.fw'
[ 8871.073143] dib0700: firmware started successfully.
[ 8871.574237] dvb-usb: found a 'Terratec Cinergy DT USB XS Diversity/ T5' in 
warm state.
[ 8871.574358] dvb-usb: will pass the complete MPEG2 transport stream to the 
software demuxer.
[ 8871.574476] DVB: registering new adapter (Terratec Cinergy DT USB XS 
Diversity/ T5)
[ 8871.793130] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[ 8872.001597] DiB0070: successfully identified
[ 8872.001605] dvb-usb: will pass the complete MPEG2 transport stream to the 
software demuxer.
[ 8872.001673] DVB: registering new adapter (Terratec Cinergy DT USB XS 
Diversity/ T5)
[ 8872.150711] DVB: registering adapter 1 frontend 0 (DiBcom 7000PC)...
[ 8872.357432] DiB0070: successfully identified
[ 8872.357447] Registered IR keymap rc-dib0700-rc5
[ 8872.357457] ir_create_table: Allocated space for 256 keycode entries (2048 
bytes)
[ 8872.357463] ir_setkeytable: Allocated space for 256 keycode entries (2048 
bytes)
[ 8872.357471] ir_update_mapping: #0: New scan 0x0700 with key 0x0071
[ 8872.357477] ir_update_mapping: #1: New scan 0x0701 with key 0x008b
[ 8872.357482] ir_update_mapping: #2: New scan 0x0739 with key 0x0074
[ 8872.357488] ir_update_mapping: #2: New scan 0x0703 with key 0x0073
...
[ 8872.358606] ir_update_mapping: #83: New scan 0x1d37 with key 0x00a7
[ 8872.358613] ir_update_mapping: #84: New scan 0x1d3b with key 0x0162
[ 8872.358621] ir_update_mapping: #85: New scan 0x1d3d with key 0x0074
[ 8872.358867] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:13.2/usb2/2-1/rc/rc0/input9
[ 8872.358991] rc0: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:13.2/usb2/2-1/rc/rc0
[ 8872.358999] __ir_input_register: Registered input device on dib0700 for rc-
dib0700-rc5 remote.
[ 8872.359371] dvb-usb: schedule remote query interval to 50 msecs.
[ 8872.359380] dvb-usb: Terratec Cinergy DT USB XS Diversity/ T5 successfully 
initialized and connected.


I followed the instruction from 
http://linuxtv.org/wiki/index.php/Remote_controllers-V4L but irrecord can't 
find the gap. When I tried a 
cat /dev/input/ir
from time to time some strange symbols were put out on repeatedly pressing 
keys on the remote. I also tried to replace the firmware with the older 
version 1.10. But then the /dev/input/ir wont stop to fire event messages even 
if just one key was pressed. 
So I had a look at 
http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_DT_USB_XS_Diversity and 
tried to change the protocol to NEC via the option dvb_usb_dib0700_ir_proto of 
the module dvb_usb_dib0700. But this option is no longer available. Where does 
it hide itself?

Has someone an idea?

Thanks in advance.

Bye,
Alexander




