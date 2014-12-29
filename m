Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:38033 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaL2Neg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Dec 2014 08:34:36 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Subject: CMYG support in V4L2
Date: Mon, 29 Dec 2014 14:33:58 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201412291433.58677.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I'm working on an old driver called "qcamvc" for Connectix QuickCam VC webcams 
(parallel port and USB models), found here:
http://sourceforge.net/projects/usb-quickcam-vc/

Luckily, it was modified last year to compile with 3.x kernels.

After trivial modification (mfr and model), it works with parallel-port 
QuickCam Pro (sort of - only at 320x240 and with vertical lines on the left 
and blank part at the top). I don't have QuickCam VC (yet).

After removing a lot of code (it's now around 1200 [main] + 660 [parallel] + 
320 [usb] lines), one problem still remains: in-kernel colour conversion with 
software contrast, hue, saturation and gamma.

According to comments in the code, the camera sensor seems to have a CMYG 
filter, like no other linux-supported camera. So the proper way to support 
these cameras is to introduce a new pixel format, move the conversion to 
libv4lconvert and remove all controls not provided by hardware?

-- 
Ondrej Zary
