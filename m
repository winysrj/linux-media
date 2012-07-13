Return-path: <linux-media-owner@vger.kernel.org>
Received: from juliet.king.net.nz ([120.89.83.190]:37142 "EHLO
	juliet.king.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2GMCsP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 22:48:15 -0400
Received: from [118.148.196.126] (port=38423 helo=kilo)
	by juliet.king.net.nz with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <alex@king.net.nz>)
	id 1SpVGB-000575-Fa
	for linux-media@vger.kernel.org; Fri, 13 Jul 2012 14:05:36 +1200
Received: from localhost ([127.0.0.1])
	by kilo with esmtp (Exim 4.80)
	(envelope-from <alex@king.net.nz>)
	id 1SpVEU-0005qj-UM
	for linux-media@vger.kernel.org; Fri, 13 Jul 2012 14:03:51 +1200
Message-ID: <4FFF8204.5030403@king.net.nz>
Date: Fri, 13 Jul 2012 14:03:48 +1200
From: Alex King <alex@king.net.nz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Getting a webcam to work
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's labelled "V-Gear TalkCamPro"

from lsusb:

Bus 001 Device 012: ID eb1a:2711 eMPIA Technology, Inc.

and:

/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/5p, 480M
     |__ Port 1: Dev 2, If 0, Class=hub, Driver=hub/7p, 480M
         |__ Port 1: Dev 12, If 0, Class=vend., Driver=, 480M
         |__ Port 1: Dev 12, If 1, Class=audio, Driver=snd-usb-audio, 480M
         |__ Port 1: Dev 12, If 2, Class=audio, Driver=snd-usb-audio, 480M

It looks like the audio part is recognised, but the video not.

I see in 
http://lxr.linux.no/linux+*/drivers/media/video/em28xx/em28xx-cards.c 
that product ids 2710, 2750 and 2751 are recognised by the driver, but 
not 2711.

I'm tempted to add it as a  EM2800_BOARD_UNKNOWN and see if it works.

Is there some methodology I should follow to get a new webcam to work?

Thanks,
Alex

PS. I'm not subscribed.
