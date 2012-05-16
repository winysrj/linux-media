Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46960 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758490Ab2EPWUG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 18:20:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SUmZg-0001Mq-M5
	for linux-media@vger.kernel.org; Thu, 17 May 2012 00:20:04 +0200
Received: from 92-32-255-209.tn.glocalnet.net ([92.32.255.209])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 17 May 2012 00:20:04 +0200
Received: from simong by 92-32-255-209.tn.glocalnet.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 17 May 2012 00:20:04 +0200
To: linux-media@vger.kernel.org
From: Simon Gustafsson <simong@simong.se>
Subject: How fix driver for this USB camera (MT9T031 sensor and Cypress FX2LP USB bridge) 
Date: Wed, 16 May 2012 22:14:48 +0000 (UTC)
Message-ID: <loom.20120517T001241-393@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bought a rare webcam, which doesn't work in Linux, and would appreciate some
pointers of how to fix that.

1) Is someone already working on this (camera information at the bottom)

2) Where should I begin? My gut feeling is to go for media/video/gspca/ov519.c,
since it has the code for talking to the USB bridge chip (BRIDGE_OVFX2), and
since that code is so neat. If the patches needed to get it working turns out to
be non-estetic, one would have to consider alternatives. I also noticed that
there is some code at media/video/mt9t031.c for talking with my sensor (but it
suggests it can't be used outside of the soc-camera framework (I've never heard
of it before), and I don't know if those parts of the source would be relevant
anyway.

3) Is there a recommended distribution (or kernel revision) when working against
the latest driver sources, or can I just pull the latest sources from git and
expect it to play nicely with something like ubuntu in my case.


----[Hardware information]----
* 3.0MP USB2.0 Digital USB c-mount Camera for Microscopes
* VID:PID 1578:0076
* USB bridge CY7C68013A (aka Cypress FX2LP)
* Sensor: most probably an MT9T031. It responds to the same I2C address, and
when I injected I2C reads to the sensors register 0x00 and 0xFF, I get the
0x1621 response which matches “chip version” according to the datasheet.

BR
/Simon 

