Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231]:44394 "EHLO
	smtp1.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033AbZIOCr3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 22:47:29 -0400
Message-ID: <4AAEFEC9.3080405@cogweb.net>
Date: Mon, 14 Sep 2009 19:41:13 -0700
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Reliable work-horse capture device?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


We're setting up NTSC cable television capture devices in a handfull of 
remote locations, using four devices to capture around fifty hours a day 
on each location. Capture is scripted and will be ongoing for several 
years. We want to minimize the need for human intervention.

I'm looking for advice on which capture device to use.  My main 
candidates are ivtv (WinTV PVR 500) and USB, but I've not used any of 
the supported USB devices.

Are there USB devices that are sufficiently reliable to hold up under 
continuous capture for years? Are the drivers robust?

I need zvbi-ntsc-cc support, so a big thanks to Michael Krufty for just 
now adding it to em28xx. Do any other USB device chipsets have raw 
closed captioning support?

I would also consider using the PCIe device Hauppauge WinTV-HVR-2200, 
but I need analog support.

Appreciate any advice.

Dave


