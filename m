Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:41829 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755696Ab0GAQUa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Jul 2010 12:20:30 -0400
Received: from [209.86.224.34] (helo=elwamui-hound.atl.sa.earthlink.net)
	by elasmtp-dupuy.atl.sa.earthlink.net with esmtpa (Exim 4.67)
	(envelope-from <elazarb@earthlink.net>)
	id 1OUMV3-0000Z7-VJ
	for linux-media@vger.kernel.org; Thu, 01 Jul 2010 12:20:29 -0400
Message-ID: <19515445.1278001229684.JavaMail.root@elwamui-hound.atl.sa.earthlink.net>
Date: Thu, 1 Jul 2010 12:20:29 -0400 (GMT-04:00)
From: Elazar Broad <elazarb@earthlink.net>
Reply-To: Elazar Broad <elazarb@earthlink.net>
To: linux-media@vger.kernel.org
Subject: bttv and chinese kmc-8800 clone
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
 I am having a heck of a time getting a chinese kmc-8800 clone working with bttv. My current setup setup is a Dell PowerEdge SC420(Celeron 2.53, 1.5GB RAM) running Slackware 13.1 with a 2.6.34 kernel (which was previously running a Lorex QLR460 4 port single bt878a quite stably). I don't have the exact output however, lspci states that the card has 2 bt878a rev 11 and 6 bt878a rev 2. The card has 8 bt878a in total with a PLX PCI6150 PCI bridge(Hint HB4). Modprobe options: card=102,102,102.... latency=64. The problem is as follows:

bttv hangs and the system locks hard when loading the module, either manually via modprobe/insmod or when booting. With a few printk's I tracked the hang to about 3/4 of the way through init_bt848(), around the color and hue setup, however the function never returns. The card uses IRQ 17 which is shared with the Intel I2C SMBus(i801), there are 3 PCI slots in the system wired to IRQ's 16-18 respectively. IRQ 16 is used by the USB host controller and the ethernet card and IRQ 18 is used by the on board graphics card.
 
I have yet to setup a serial console and sysrq does not work. Any ideas are much appreciated.

Thanks,
 elazar

