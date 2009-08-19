Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.moviquity.com ([213.134.42.80]:45182 "EHLO
	mail.moviquity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbZHSLDR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 07:03:17 -0400
Received: from [192.168.3.64] (80.Red-80-38-94.staticIP.rima-tde.net [80.38.94.80])
	(Authenticated sender: mcm)
	by mail.moviquity.com (Postfix) with ESMTPSA id 4DEB8520205
	for <linux-media@vger.kernel.org>; Wed, 19 Aug 2009 13:03:10 +0200 (CEST)
Subject: USB Wintv HVR-900 Hauppauge
From: Miguel <mcm@moviquity.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Wed, 19 Aug 2009 13:01:25 +0200
Message-Id: <1250679685.14727.14.camel@McM>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,

I am trying to set up the dvb-t device in my ubuntu 9.04.
As far as i can see , this device has tm6000 chipset but I don't get it
works. I have followed the guide of tvlinux.org:
http://www.linuxtv.org/wiki/index.php/Trident_TM6000#TM6000_based_Devices

I have compile v4l-dvb, make, and make install and it seems that the
modules are loaded:


em28xx                 90668  0 
ir_common              57732  1 em28xx
v4l2_common            25600  1 em28xx
videobuf_vmalloc       14724  1 em28xx
videobuf_core          26244  2 em28xx,videobuf_vmalloc
tveeprom               20228  1 em28xx
videodev               44832  3 em28xx,v4l2_common,uvcvideo


But by the moment, I don't know which driver  I should you. Actually,
when I switch the usb wintv on , my so doesn't recognize it:

[11107.449900] usb 1-3: new high speed USB device using ehci_hcd and
address 8
[11107.593094] usb 1-3: configuration #1 chosen from 1 choice


how can I get this device run?

thank you in advance.

Miguel


