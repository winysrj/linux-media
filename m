Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:34024 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932204Ab1AKOKM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 09:10:12 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1PcevE-0007rO-R7
	for linux-media@vger.kernel.org; Tue, 11 Jan 2011 15:10:04 +0100
Received: from 88-149-184-250.staticnet.ngi.it ([88.149.184.250])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 11 Jan 2011 15:10:04 +0100
Received: from michele.manzato by 88-149-184-250.staticnet.ngi.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 11 Jan 2011 15:10:04 +0100
To: linux-media@vger.kernel.org
From: mmanzato <michele.manzato@gmail.com>
Subject: Re: Hauppauge WinTV-HVR-1120 on Unbuntu 10.04
Date: Tue, 11 Jan 2011 13:57:43 +0000 (UTC)
Message-ID: <loom.20110111T145340-757@post.gmane.org>
References: <259225.84971.qm@web25402.mail.ukl.yahoo.com> <201010192032.50484.albin.kauffmann@gmail.com> <968618.5175.qm@web25407.mail.ukl.yahoo.com> <201010241627.22121.albin.kauffmann@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Same behaviour here. I'm with Mythbuntu 10.10.

TDA10048 firwmare is found in the linux-firmware-nonfree Ubuntu package. From
what I can see in dmesg it is loaded correctly.

http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1120 says that support
for this card seems to be broken in recent Linux kernels (does that mean in
recent V4L drivers?)

