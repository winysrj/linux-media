Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:39569 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbZEDUpC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 May 2009 16:45:02 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1M1526-00005o-EH
	for linux-media@vger.kernel.org; Mon, 04 May 2009 20:45:02 +0000
Received: from alltalk.demon.co.uk ([80.177.3.49])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 04 May 2009 20:45:02 +0000
Received: from drbob by alltalk.demon.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 04 May 2009 20:45:02 +0000
To: linux-media@vger.kernel.org
From: drbob <drbob@gmx.co.uk>
Subject: EC168 "dvb_usb: Unknown symbol release_firmware"
Date: Mon, 4 May 2009 20:28:24 +0000 (UTC)
Message-ID: <gtnj58$p21$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I recently tried to build and use the EC168 drivers from 
<http://linuxtv.org/hg/~anttip/ec168/>
following instructions found at
<http://www.dealextreme.com/forums/Default.dx/sku.8325~threadid.278942>

The drivers built fine but upon trying to load dvb-usb.ko 
(sudo insmod ./dvb-usb.ko) I got the following error:

  insmod: error inserting './dvb-usb.ko': -1 Unknown symbol in module

dmesg listed these additonal errors:

  [  647.189929] dvb_usb: Unknown symbol release_firmware
  [  647.190085] dvb_usb: Unknown symbol request_firmware

I am running Debian 5.0 with the stock kernel (2.6.26-2-amd64) on an HP 
ML115 server (Quad-Core AMD Opteron(tm) Processor 1352, 4GB ECC memory)

I found I was able to work around the issue like so: 

1. First load and then unload the stock dvb-core and dvb-usb included 
with lenny.

  sudo modprobe dvb-core
  sudo modprobe dvb-usb
  sudo rmmod dvb-core
  sudo rmmod dvb-usb
 
2. Then load the modules built from the EC168 tree. 

  sudo insmod ./dvb-core.ko
  sudo insmod ./dvb-usb.ko
  sudo insmod ./ec100.ko
  sudo insmod ./mxl5005s.ko
  sudo insmod ./dvb-usb-ec168.ko

The stick then works and I can use it to view tv etc, unplug/reinsert it 
and unload/reload the EC168 tree modules without carrying out step 1 
again (until the next reboot). 

The stick is a cheap generic USB stick purchased from eBay (USB id 
18b4:1001). Photos of it are here:

<http://img89.imageshack.us/gal.php?g=img1283g.jpg>

Strangely the markings on the large main chip appear to have been removed 
by the stick manufacturer (though I think it must be an EC168) The 
smaller tuner chip has also been scrubbed but the following markings can 
still be identified:

Maxline MXL5003 
D37T5:1

Thanks for your time.


