Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out11.libero.it ([212.52.84.111]:51396 "EHLO
	cp-out11.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab0AIIik (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jan 2010 03:38:40 -0500
Received: from [192.168.1.2] (151.49.24.181) by cp-out11.libero.it (8.5.119)
        id 4AE04A3D10958852 for linux-media@vger.kernel.org; Sat, 9 Jan 2010 09:32:40 +0100
From: sacarde <sacarde@tiscali.it>
To: linux-media@vger.kernel.org
Subject: problem webcam gspca 2.6.32
Date: Sat, 9 Jan 2010 09:32:39 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001090932.39996.sacarde@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi,
 on my archlinux-64 I have a webcam: 0471:0322 Philips DMVC1300K PC Camera
 
 until one mounth ago this works OK with driver: gspca_sunplus
 
 now with kernel 2.6.32 not works.... 
 I start cheese and I view: http://sacarde.interfree.it/errore-cheese.png
 and this messages:
 Cheese 2.28.1
 Probing devices with HAL...
 Found device 0471:0322, getting capabilities...
 Detected v4l2 device: USB Camera (0471:0322)
 Driver: sunplus, version: 132864
 Capabilities: 0x05000001
 Probing supported video formats...
 
 
 from dmesg:
 ...
 gspca: probing 0471:0322
 gspca: probe ok
 ...
 /dev/video0 is created
 
 
 I try to downgrade previus kernel kernel26 2.6.31.6-1 and dependencies
 
 and it works:
 
 when it works 2.6.31: Driver: sunplus, version: 132608 
 
 
 thankyou



sacarde@tiscali.it
