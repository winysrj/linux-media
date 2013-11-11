Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34509 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab3KKQIo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Nov 2013 11:08:44 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Vfu2b-0002YA-Ob
	for linux-media@vger.kernel.org; Mon, 11 Nov 2013 17:08:41 +0100
Received: from w1622.pub.fh-zwickau.de ([141.32.250.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 11 Nov 2013 17:08:41 +0100
Received: from Bassai_Dai by w1622.pub.fh-zwickau.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 11 Nov 2013 17:08:41 +0100
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: ccdc image capture interrupts
Date: Mon, 11 Nov 2013 16:08:17 +0000 (UTC)
Message-ID: <loom.20131111T170156-504@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I want to capture an image with my ov3640 camera sensor connected with a 
gumstix overo board. I tried to change the isp registers and the registers of 
the ov3640 like in an old driver which worked with kernel version 2.6.34. I 
was able to get an image but I don't understand what the problem might be. 

sudo ./media-ctl -v -r -l '"ov3640 3-003c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 
ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
sudo ./media-ctl -v -V '"ov3640 3-003c":0 [UYVY2X8 640x480], "OMAP3 ISP 
CCDC":1 [UYVY2X8 640x480]'
sudo ./yavta -p -f UYVY -s 640x480 -n 4 --skip 3 --capture=13 --file=img#.raw 
/dev/video2

the picture I got looks like this (should be a standard test pattern): 
http://s7.directupload.net/file/d/3435/2s5kuacl_png.htm

does someone know on which signal each of these 3 functions (ccdc_vd0_isr; 
ccdc_vd1_isr; ccdc_hs_vs_isr) are called. what signal has to be high?

Regards, Tom

