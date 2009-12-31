Return-path: <linux-media-owner@vger.kernel.org>
Received: from vexpert.dbai.tuwien.ac.at ([128.131.111.2]:45414 "EHLO
	vexpert.dbai.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZLaSIO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2009 13:08:14 -0500
Received: from acrux.dbai.tuwien.ac.at (acrux.dbai.tuwien.ac.at [128.131.111.60])
	by vexpert.dbai.tuwien.ac.at (Postfix) with ESMTP id 1FF3B1E058
	for <linux-media@vger.kernel.org>; Thu, 31 Dec 2009 18:58:21 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by acrux.dbai.tuwien.ac.at (Postfix) with ESMTP id 5E17B16048
	for <linux-media@vger.kernel.org>; Thu, 31 Dec 2009 18:58:24 +0100 (CET)
Date: Thu, 31 Dec 2009 18:58:24 +0100 (CET)
From: Gerald Pfeifer <gerald@pfeifer.com>
To: linux-media@vger.kernel.org
Subject: Terratec firmware / af9005.fw
Message-ID: <alpine.LSU.1.99.0912311851110.16540@acrux.dbai.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trying a Terratec "Cinergy T USB XE" USB DVB-T stick under Linux
(http://www.terratec.net/en/products/driver/produkte_treiber_en_33211.html)
it turns out that one needs specific firmware:

   usb 5-1: new full speed USB device using uhci_hcd and address 2
   usb 5-1: New USB device found, idVendor=0ccd, idProduct=0055
   usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
   usb 5-1: Product: Cinergy T USB XE
   usb 5-1: Manufacturer: AFA
   usb 5-1: configuration #1 chosen from 1 choice
   dvb-usb: found a 'TerraTec Cinergy T USB XE' in cold state, will try to
            load a firmware
   usb 5-1: firmware: requesting af9005.fw
   dvb-usb: did not find the firmware file. (af9005.fw) ...

Checking the latest openSUSE firmware package (kernel-firmware-20091215)
it seems this is still not included.

Has anyone tried working with Terratec on this?  If so, how did that go?

Would it make sense for me to give it a try?  (Any pointers on what 
exactly to ask from them in that case?)

Gerald
-- 
Gerald (Jerry) Pfeifer   gerald@pfeifer.com   http://www.pfeifer.com/gerald/
