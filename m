Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:54442 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbbL0OUo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Dec 2015 09:20:44 -0500
Received: from [192.168.1.2] ([77.182.171.219]) by smtp.web.de (mrweb101) with
 ESMTPSA (Nemesis) id 0MKJ7S-1aBY1k1xTS-001hry for
 <linux-media@vger.kernel.org>; Sun, 27 Dec 2015 15:20:42 +0100
To: linux-media@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [media] af9013: Checking for register accesses?
Message-ID: <567FF3B0.1010003@users.sourceforge.net>
Date: Sun, 27 Dec 2015 15:20:32 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have looked at the implementations of functions like the following once more.
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/drivers/media/dvb-frontends/af9013.c?id=80c75a0f1d81922bf322c0634d1e1a15825a89e6#n124
* af9013_rd_regs
* af9013_wr_regs

Both functions will always return zero so far. Should they eventually forward
an error code from other function calls?

Regards,
Markus
