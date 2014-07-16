Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-box05.hrz.tu-darmstadt.de ([130.83.156.247]:60734 "EHLO
	lnx141.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751409AbaGPMTm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jul 2014 08:19:42 -0400
Received: from lnx503.hrz.tu-darmstadt.de (lnx503.hrz.tu-darmstadt.de [130.83.156.232])
	by lnx141.hrz.tu-darmstadt.de (8.14.4/8.13.8) with ESMTP id s6GCIf39031472
	for <linux-media@vger.kernel.org>; Wed, 16 Jul 2014 14:18:42 +0200
	(envelope-from johannes.werner@physik.tu-darmstadt.de)
Received: from exp1.fkp.physik.tu-darmstadt.de (exp1.fkp.physik.tu-darmstadt.de [130.83.32.161])
	by lnx503.hrz.tu-darmstadt.de (8.14.4/8.14.4/HRZ/PMX) with ESMTP id s6GCEC5T006583
	for <linux-media@vger.kernel.org>; Wed, 16 Jul 2014 14:14:12 +0200
	(envelope-from johannes.werner@physik.tu-darmstadt.de)
Received: from geo053104.klientdrift.uib.no ([129.177.53.104])
	by exp1.fkp.physik.tu-darmstadt.de with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <johannes.werner@physik.tu-darmstadt.de>)
	id 1X7NyI-0004oB-Nx
	for linux-media@vger.kernel.org; Wed, 16 Jul 2014 14:06:06 +0200
Date: Wed, 16 Jul 2014 14:14:10 +0200
From: Johannes Werner <johannes.werner@physik.tu-darmstadt.de>
To: linux-media@vger.kernel.org
Subject: Siano Rio problems (idVendor=187f, idProduct=0600)
Message-ID: <20140716141410.53d5fa5d@geo053104.klientdrift.uib.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all,

I hope this is the right place to ask for help / clarification
(linuxtv.org/ suggests it). I saw that Siano does indeed contribute to
the media drivers in the kernel (so I hope somebody relevant is reading
this). I have some questions about the Siano Rio chip that I could not
answer by asking google...

First of all, the chip seems to be supported by the kernel (modules
load), but the firmware isdbt_rio.inp is not distributed by Ubuntu. I
could find a package at
http://repo.huayra.conectarigualdad.gob.ar/huayra/pool/non-free/f/firmware-siano-rio/
and this contains a file with this name. This is the only place I could
find it on the interwebs.
Anyway, below is the actual problem (assuming the firmware mentioned
above is correct). I hope to get some hints on what I could try. I am
not afraid of building kernels, but haven't done so in a while...
Should I write a bug report? (where)?

Thanks in advance,
Jo


Description:
Changes to the siano driver between 3.11 and 3.13 removed TERRESTRIAL
support for Siano Rio chipset from the driver.


Report:

On my Netbook (Ubuntu 14.04, kernel 3.13) inserting the USB stick
results in

-- dmesg output --
[] usb 1-1: new high-speed USB device number 5 using ehci-pci
[] usb 1-1: New USB device found, idVendor=187f,idProduct=0600 
[] usb 1-1: New USB device strings: Mfr=1,Product=2, SerialNumber=0
[] usb 1-1: Product: MDTV Receiver
[] usb 1-1: Manufacturer: MDTV Receiver
[] DVB: registering new adapter (Siano Rio Digital Receiver)
[] usb 1-1: DVB: registering adapter 0 frontend 0 (Siano Mobile Digital
MDTV Receiver)...
-- end dmesg --

and the modules being loaded.

-- lsmod output
smsdvb                 18071  0 
dvb_core              101206  1 smsdvb
smsusb                 17531  0 
smsmdtv                48244  2 smsdvb,smsusb
rc_core                26724  1 smsmdtv
-- end lsmod --

This looks promising. When trying to scan for station using w_scan
however:

-- w_scan output --
w_scan version 20130331 (compiled for DVB API 5.10)
guessing country 'DE', use -c <country> to override
using settings for GERMANY
DVB aerial
DVB-T Europe
scan type TERRESTRIAL, channellist 4
output format vdr-2.0
output charset 'UTF-8', use -C <charset> to override
Info: using DVB adapter auto detection.
	/dev/dvb/adapter0/frontend0 -> "Siano Mobile Digital MDTV
Receiver" doesnt support TERRESTRIAL -> SEARCH NEXT ONE. main:3228:
FATAL: ***** NO USEABLE TERRESTRIAL CARD FOUND. ***** Please check
wether dvb driver is loaded and verify that no dvb application (i.e.
vdr) is running.
-- end w_scan --

even though this is a DVB-T receiver stick. Trying it on another machine
(where I cannot install the firmware) using Ubuntu 12.04.4, kernel 3.11
w_scan does indeed scan (but cannot find a signal because the firmware
is not loaded), see below. REMARK: even when not loading a firmware the
behaviour above (TERRESTRIAL not supported) persists.

-- wscan output on other machine --
w_scan version 20111203 (compiled for DVB API 5.4)
WARNING: could not guess your country. Falling back to 'DE'
guessing country 'DE', use -c <country> to override
using settings for GERMANY
DVB aerial
DVB-T Europe
frontend_type DVB-T, channellist 4
output format vdr-1.6
WARNING: could not guess your codepage. Falling back to 'UTF-8'
output charset 'UTF-8', use -C <charset> to override
Info: using DVB adapter auto detection.
	/dev/dvb/adapter0/frontend0 -> DVB-T "Siano Mobile Digital MDTV
Receiver": good :-) Using DVB-T frontend
(adapter /dev/dvb/adapter0/frontend0) -_-_-_-_ Getting frontend
capabilities-_-_-_-_ Using DVB API 5.a
frontend 'Siano Mobile Digital MDTV Receiver' supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
FEC_AUTO
FREQ (44.25MHz ... 867.25MHz)
[...]
-- end truncated wscan output --
