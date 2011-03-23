Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:56567 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911Ab1CWNkI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 09:40:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Q2OIA-0002CS-BW
	for linux-media@vger.kernel.org; Wed, 23 Mar 2011 14:40:06 +0100
Received: from c80-216-217-200.bredband.comhem.se ([80.216.217.200])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 23 Mar 2011 14:40:06 +0100
Received: from daniel.lundborg by c80-216-217-200.bredband.comhem.se with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 23 Mar 2011 14:40:06 +0100
To: linux-media@vger.kernel.org
From: Daniel Lundborg <daniel.lundborg@prevas.se>
Subject: OMAP3 isp single-shot
Date: Wed, 23 Mar 2011 13:28:23 +0000 (UTC)
Message-ID: <loom.20110323T141429-496@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I am successfully using the gumstix overo board together with a camera sensor
Aptina MT9V034 with the kernel 2.6.35 and patches from
http://git.linuxtv.org/pinchartl/media.git (isp6).

I can use the media-ctl program and yavta to take pictures in continous
streaming mode.

media-ctl -r -l '"mt9034 3-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
CCDC":1->"OMAP3 ISP CCDC output":0[1]'
media-ctl -f '"mt9v034 3-0048":0[SGRBG10 752x480], "OMAP3 ISP CCDC":1[SGRBG10
752x480]

and then:

yavta -f SGRBG10 -s 752x480 -n 1 --capture=1 -F /dev/video2


Is there a way to set the ISP in single shot mode?

I have tested setting the mt9v034 in snapshot mode and manually trigger the
camera, but the ISP does not send a picture. Is there a way to solve this with
the current OMAP3 isp code?

I have before successfully used the isp parts from the Nokia N900 project..

/Daniel

