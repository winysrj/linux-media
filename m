Return-path: <linux-media-owner@vger.kernel.org>
Received: from mis07.de ([93.186.196.80]:46222 "EHLO mis07.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbZJRKnz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Oct 2009 06:43:55 -0400
Received: from [192.168.2.121] (p5DC8EF15.dip.t-dialin.net [93.200.239.21])
	by mis07.de (Postfix) with ESMTPA id 98AB211C656B
	for <linux-media@vger.kernel.org>; Sun, 18 Oct 2009 12:43:56 +0200 (CEST)
Message-ID: <4ADAF16B.1090409@hardware-datenbank.de>
Date: Sun, 18 Oct 2009 12:43:55 +0200
From: Rath <mailings@hardware-datenbank.de>
MIME-Version: 1.0
To: Linux-Media <linux-media@vger.kernel.org>
Subject: cpu load of webcam read out with omap3/beagleboard
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have beagleboard with the OMAP3530 processor and I want to read a usb 
webcam out. But I only get usable results at 160x120 resolution.
I set the pixelformat to "V4L2_PIX_FMT_RGB24" and the resolution to 
160x120. With these settings I get 30fps at 4% cpu load. But when I set 
the resolution to 320x240 or 640x480 the cpu load is at 98% and I get 
only 17 or 4fps. Also I get at 640x480 errors like "libv4lconvert: Error 
decompressing JPEG: fill_nbits error: need 9 more bits".

Is this a normal behavior or is  there a way to fix  this?  I think the 
problem is the conversion from MJPEG to RGB, because when I set the 
pixelformat to MJPEG the cpu load is <1%.  But  I need RGB data for 
image processing.

I hope someone can help me.

Regards, Joern
