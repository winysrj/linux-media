Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:43965 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbZC2LeL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 07:34:11 -0400
Received: from smtp6-g21.free.fr (localhost [127.0.0.1])
	by smtp6-g21.free.fr (Postfix) with ESMTP id 9E0DFE080AB
	for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 13:34:04 +0200 (CEST)
Received: from portable.blastor.servebeer.com (blastor.servebeer.com [88.172.101.167])
	by smtp6-g21.free.fr (Postfix) with ESMTP id A2317E08145
	for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 13:34:01 +0200 (CEST)
Received: from blastor (blastor [192.168.0.10])
	by portable.blastor.servebeer.com (Postfix) with ESMTP id 41E6BECEA3
	for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 13:34:01 +0200 (CEST)
To: linux-media@vger.kernel.org
Subject: AverMedia Volar Black HD (A850)
Content-Disposition: inline
From: Olivier MENUEL <olivier.menuel@free.fr>
Date: Sun, 29 Mar 2009 13:34:00 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200903291334.00879.olivier.menuel@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Does anyone knows how to get this card work on linux : AverMedia Volar Black HD (A850)
lsusb id is : 07ca:850a

I tried this project : http://linuxtv.org/hg/~anttip/af9015_aver_a850/ which seems to be specifically for this card but it does not work (The .num_device_descs has not been correctly set).
I tried to fix the .num_device_descs and also tried to add my card in the af9015.c file of the official v4l-dvb project.

My card is now correctly detected and dirs are created in the /dev/dvb, but it seems initialization fails :

Here is my log :
Mar 29 12:31:52 blastor kernel: [ 1158.173568] dvb-usb: AVerMedia A850 successfully deinitialized and disconnected.
Mar 29 12:31:58 blastor kernel: [ 1163.748307] usb 5-4.4: new high speed USB device using ehci_hcd and address 7
Mar 29 12:31:58 blastor kernel: [ 1163.844496] usb 5-4.4: configuration #1 chosen from 1 choice
Mar 29 12:31:58 blastor kernel: [ 1163.879653] dvb-usb: found a 'AVerMedia A850' in cold state, will try to load a firmware
Mar 29 12:31:58 blastor kernel: [ 1163.879662] firmware: requesting dvb-usb-af9015.fw
Mar 29 12:31:58 blastor kernel: [ 1163.890963] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
Mar 29 12:31:58 blastor kernel: [ 1163.969803] dvb-usb: found a 'AVerMedia A850' in warm state.
Mar 29 12:31:58 blastor kernel: [ 1163.969896] i2c-adapter i2c-0: SMBus Quick command not supported, can't probe for chips
Mar 29 12:31:58 blastor kernel: [ 1163.969905] i2c-adapter i2c-0: SMBus Quick command not supported, can't probe for chips
Mar 29 12:31:58 blastor kernel: [ 1163.969918] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Mar 29 12:31:58 blastor kernel: [ 1163.970764] DVB: registering new adapter (AVerMedia A850)
Mar 29 12:31:58 blastor kernel: [ 1163.971128] i2c-adapter i2c-1: SMBus Quick command not supported, can't probe for chips
Mar 29 12:31:58 blastor kernel: [ 1163.971139] i2c-adapter i2c-1: SMBus Quick command not supported, can't probe for chips
Mar 29 12:31:59 blastor kernel: [ 1164.363070] af9013: firmware version:4.95.0
Mar 29 12:31:59 blastor kernel: [ 1164.368956] DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
Mar 29 12:31:59 blastor kernel: [ 1164.369216] MXL5005S: Attached at address 0xc6
Mar 29 12:31:59 blastor kernel: [ 1164.369220] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Mar 29 12:31:59 blastor kernel: [ 1164.373191] DVB: registering new adapter (AVerMedia A850)
Mar 29 12:31:59 blastor kernel: [ 1164.478066] af9015: command failed:2
Mar 29 12:31:59 blastor kernel: [ 1164.478074] af9015: firmware copy to 2nd frontend failed, will disable it
Mar 29 12:31:59 blastor kernel: [ 1164.478079] dvb-usb: no frontend was attached by 'AVerMedia A850'
Mar 29 12:31:59 blastor kernel: [ 1164.478083] dvb-usb: AVerMedia A850 successfully initialized and connected.
Mar 29 12:31:59 blastor kernel: [ 1164.489385] usb 5-4.4: New USB device found, idVendor=07ca, idProduct=850a
Mar 29 12:31:59 blastor kernel: [ 1164.489392] usb 5-4.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Mar 29 12:31:59 blastor kernel: [ 1164.489395] usb 5-4.4: Product: A850 DVBT
Mar 29 12:31:59 blastor kernel: [ 1164.489397] usb 5-4.4: Manufacturer: AVerMedia
Mar 29 12:31:59 blastor kernel: [ 1164.489399] usb 5-4.4: SerialNumber: 301475400736000

I guess the problem is here :  [ 1164.478066] af9015: command failed:2
It's probably a firmware issue, I'm using this firmware http://otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/
I'm completely stuck and have no idea what else could be done.

Any help would be appreciated.
Thanks
