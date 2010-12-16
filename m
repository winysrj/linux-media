Return-path: <mchehab@gaivota>
Received: from lo.gmane.org ([80.91.229.12]:59648 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104Ab0LPQEt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 11:04:49 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1PTGJz-0006S9-N6
	for linux-media@vger.kernel.org; Thu, 16 Dec 2010 17:04:47 +0100
Received: from host104-244-dynamic.17-79-r.retail.telecomitalia.it ([79.17.244.104])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 17:04:47 +0100
Received: from jjjanez by host104-244-dynamic.17-79-r.retail.telecomitalia.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 17:04:47 +0100
To: linux-media@vger.kernel.org
From: Janez <jjjanez@alice.it>
Subject: Re: Terratec Cinergy HT MKII has a VHF problem.
Date: Thu, 16 Dec 2010 16:04:33 +0000 (UTC)
Message-ID: <loom.20101216T170004-738@post.gmane.org>
References: <loom.20101214T135629-694@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Janez <jjjanez <at> alice.it> writes:

> As you can see the second time the scanning of that frequency doesn't work
> anymore. It will work again only after a reboot!

There is no need to reboot the system.
Remove and reload the module cx88_dvb does the trick.

