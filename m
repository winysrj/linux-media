Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:54286 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322Ab2EBNt7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 09:49:59 -0400
Received: from [209.86.224.30] (helo=mswamui-chipeau.atl.sa.earthlink.net)
	by elasmtp-kukur.atl.sa.earthlink.net with esmtpa (Exim 4.67)
	(envelope-from <sitten74490@mypacks.net>)
	id 1SPZf3-0003b6-Kn
	for linux-media@vger.kernel.org; Wed, 02 May 2012 09:32:05 -0400
Message-ID: <2923357.1335965525570.JavaMail.root@mswamui-chipeau.atl.sa.earthlink.net>
Date: Wed, 2 May 2012 09:32:05 -0400 (GMT-04:00)
From: sitten74490@mypacks.net
To: linux-media@vger.kernel.org
Subject: HVR-1800 Analog Driver: MPEG video broken
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have been testing the latest cx23885 driver built from http://git.kernellabs.com/?p=stoth/cx23885-hvr1850-fixups.git;a=summary running on kernel 3.3.4 with my HVR-1800 (model 78521).  I am able to watch analog TV with tvtime using the raw device, /dev/video0.  But if I try to use it with the MPEG device, /dev/video1, I briefly get a blue screen and then tvtime segfaults.  cat /dev/video1 > /tmp/foo.mpg gives video with moving, distorted, mostly black and white diagonal lines just like @Britney posted here: http://www.kernellabs.com/blog/?p=1636.

My dmesg shows video0 being set up like this:

[    8.697567] cx23885[0]: registered device video0 [v4l2]
[    8.697647] cx23885[0]: registered device vbi0
[    8.697840] cx23885[0]: registered ALSA audio device

and video1 like this:

[    9.779115] cx23885[0]: registered device video1 [mpeg]
[    9.779133] Firmware and/or mailbox pointer not initialized or corrupted, signature = 0xd857f5e9, cmd = PING_FW

Could the broken MPEG video be related to this firmware error?  I am using firmware from here: http://steventoth.net/linux/hvr1800/

BTW, digital video works fine on this card.

Jonathan
