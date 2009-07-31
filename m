Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.work.de ([212.12.32.49]:56213 "EHLO smtp.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbZGaQvy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 12:51:54 -0400
Received: from [82.83.146.110] (helo=[192.168.0.106])
	by smtp.work.de with esmtpa (Exim 4.63)
	(envelope-from <julian@jusst.de>)
	id 1MWvDK-0001ig-0a
	for linux-media@vger.kernel.org; Fri, 31 Jul 2009 18:44:14 +0200
Message-ID: <4A731F5D.7000904@jusst.de>
Date: Fri, 31 Jul 2009 18:44:13 +0200
From: Julian Scheel <julian@jusst.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: stb0899 i2c communication broken after suspend
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I made an interesting observation with the stb0899 drivers. If the 
system was in suspend to ram state (no matter if dvb modules were 
unloaded before or not) the i2c communication of stb0899 driver and 
chipset seems to be somewhat broken. Tuning to dvb-s channels still 
works as expected, but tuning to dvb-s2 channels is completely broken.
The system log shows this error on the first tuning approach:
stb0899_write_s2reg ERR (1), Device=[0xf3fc], Base Address=[0x00000460], 
Offset=[0xf34c], Data=[0x00000000], status=-121

Has anyone seen a similar behaviour or has any ideas?
This happens on latest v4l-dvb head and kernel 2.6.29

-Julian
