Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:15303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab0ISNbB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 09:31:01 -0400
Message-ID: <4C96108F.3070708@redhat.com>
Date: Sun, 19 Sep 2010 10:30:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Kang Yong <kangyong@telegent.com>,
	Zhang Xiaobing <xbzhang@telegent.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: BKL removal from tlg2300 driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Kang/Zhang,

BKL will be removed from kernel soon. This means that all calls to lock_kernel/unlock_kernel
should be replaced by some other locking schema, and that the .ioctl callback should be
replaced by .unlocked_ioctl.

We're converting the existing drivers in order to avoid BKL usage. 

Unfortunately, I don't have any tlg2300 hardware for testing, and it uses lock_kernel() 
on a different way than the other drivers. I suspect that all that all it needs is to properly
use the new locking schema we're adopting at v4l2 core, just like the conversion we did for
em28xx:

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=b59117ed27706bf6059eeabf2698d1d33e2e67d0

Could you please review it and send me a patch?

Thanks,
Mauro
