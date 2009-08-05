Return-path: <linux-media-owner@vger.kernel.org>
Received: from mp1-smtp-6.eutelia.it ([62.94.10.166]:54152 "EHLO
	smtp.eutelia.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751715AbZHEU4p (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 16:56:45 -0400
Received: from [192.168.1.170] (ip-173-192.sn3.eutelia.it [213.136.173.192])
	by smtp.eutelia.it (Eutelia) with ESMTP id B237A54B561
	for <linux-media@vger.kernel.org>; Wed,  5 Aug 2009 22:33:20 +0200 (CEST)
Message-ID: <4A79EC82.4050902@email.it>
Date: Wed, 05 Aug 2009 22:33:06 +0200
From: xwang1976@email.it
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Issues with Empire Dual Pen: request for help and suggestions!!!
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi to all,
I've an Empire Dual Pen usb device.
Up to now I've used Markus driver, but now I've tried to switch to the 
v4l-dvb driver.
However I've the following issues:
1) the card is  not recognized automatically so I've to modprobe the 
em28xx module with the parameter card=66
2) when scanning for analog tv channels with tvtime-scanner, the system 
hangs and since  the alt+Sys+REISUB procedure does not help, I have to 
turn off the pc (very, very, very bad)
3) digital tv channels are not tuned by kaffeine (SNR value is always zero).
So the device is not usable.
Can it be fixed or is it better to buy an already supported device? 
Inthe second case which device can you suggest me? Is this device:
http://www.terratec.net/en/products/technical-data/produkte_technische_daten_en_87128.html 

supported by the latest v4l drivers.
Thank you for your help,
Xwang

PS: I live in Italy and I use kubuntu 9.04 amd64
