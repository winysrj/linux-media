Return-path: <mchehab@pedra>
Received: from alia.ip-minds.de ([84.201.38.2]:59400 "EHLO alia.ip-minds.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757067Ab1CIPwf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2011 10:52:35 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by alia.ip-minds.de (Postfix) with ESMTP id 1ACC866B1B9
	for <linux-media@vger.kernel.org>; Wed,  9 Mar 2011 16:52:39 +0100 (CET)
Received: from alia.ip-minds.de ([127.0.0.1])
	by localhost (alia.ip-minds.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JBgv3evZQx+I for <linux-media@vger.kernel.org>;
	Wed,  9 Mar 2011 16:52:39 +0100 (CET)
Received: from localhost (pD9E1A4FA.dip.t-dialin.net [217.225.164.250])
	by alia.ip-minds.de (Postfix) with ESMTPA id AEB3466B1B6
	for <linux-media@vger.kernel.org>; Wed,  9 Mar 2011 16:52:38 +0100 (CET)
Date: Wed, 9 Mar 2011 17:52:31 +0100
From: Jean-Michel Bruenn <jean.bruenn@ip-minds.de>
To: linux-media@vger.kernel.org
Subject: WinTV 1400 broken with recent versions?
Message-Id: <20110309175231.16446e92.jean.bruenn@ip-minds.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hey,

is this driver going to be fixed anytime soon? It was working fine ago a
half year/year.

lspci:
06:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI
Video and Audio Decoder (rev 02)

uname -a:
Linux lyra 2.6.37.1 #1 SMP PREEMPT Tue Feb 22 13:22:59 CET 2011 x86_64
x86_64 x86_64 GNU/Linux

dmesg:
xc2028 1-0064: i2c output error: rc = -6 (should be 64)
xc2028 1-0064: -6 returned from send
xc2028 1-0064: Error -22 while loading base firmware
xc2028 1-0064: Loading firmware for type=BASE F8MHZ (3), id
0000000000000000.
xc2028 1-0064: i2c output error: rc = -6 (should be 64)
xc2028 1-0064: -6 returned from send
xc2028 1-0064: Error -22 while loading base firmware
xc2028 1-0064: Loading firmware for type=BASE F8MHZ (3), id
0000000000000000.
xc2028 1-0064: i2c output error: rc = -6 (should be 64)
xc2028 1-0064: -6 returned from send
xc2028 1-0064: Error -22 while loading base firmware

nothing works - if i do scan it finds nothing and those messages appear on
dmesg. if i try to watch with the channels.conf from my other pc i can play
nothing, all i get is those messages above.
