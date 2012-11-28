Return-path: <linux-media-owner@vger.kernel.org>
Received: from firefly.pyther.net ([50.116.37.168]:39035 "EHLO
	firefly.pyther.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2K1CkE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 21:40:04 -0500
Received: from tux.leap.lan (c-76-18-191-214.hsd1.tn.comcast.net [76.18.191.214])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by firefly.pyther.net (Postfix) with ESMTPSA id B4BD9735F
	for <linux-media@vger.kernel.org>; Tue, 27 Nov 2012 21:31:55 -0500 (EST)
Message-ID: <50B5779A.9090807@pyther.net>
Date: Tue, 27 Nov 2012 21:31:54 -0500
From: Matthew Gyurgyik <matthew@pyther.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: em28xx: msi Digivox ATSC board id [0db0:8810]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I recently acquired a msi Digivox ATSC tuner. I believe this card has an 
em28xx chip (the windows driver included is em28xx). Looking at the 
em28xx wiki page and digging around in the code it does not seem like 
the em28xx driver has support for this card. Based on my limit 
(extremely) amount of knowledge, it doesn't look like it would be 
terribly difficult to add support for this card.

I am a complete hardware newbie (looking and willing to learn) and I 
hoping someone will be willing to help me out.

Following the bus snooping guide I was able to snoop the usb tuner 
(using usbsnoop 2.0) and collect some data from this card (Windows XP, 
using the ArcSoft TotalMedia software the card shipped with).

$ php parse-usbsnoop.php UsbSnoop.log > parsed-usbsnoop.txt
http://pyther.net/a/digivox_atsc/parsed-usbsnoop.txt

$ perl contrib_em28xx_parse_em28xx.pl parsed-usbsnoop.txt > parse_em28xx.txt
http://pyther.net/a/digivox_atsc/parse_em28xx.txt

$ lsusb -vvv (snippet)
http://pyther.net/a/digivox_atsc/lsusb.txt

Note: If necessary I can provide the entire UsbSnoop.log (however its 
~350MB)

At this point I'm not really sure how to use the above information to 
add support for my tuner. For starters I have non-existent C skills. 
 From what I've looked at, I figure I have to add the vendor id and 
product id and it looks like I need to create a struct defining the 
input devices on the tuner (just astc/dvb on this card). It also looks 
like I need to find out the reset codes?

Any help would be greatly appreciated.

Model: msi Digivox ATSC
Vendor / Product Id: [0db0:8810]
URL: http://www.msi.com/product/mm/DIGIVOX-ATSC.html

Thanks
