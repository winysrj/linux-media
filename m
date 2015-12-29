Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:60655 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbbL2JCC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2015 04:02:02 -0500
Received: from [192.168.1.2] ([77.181.55.103]) by smtp.web.de (mrweb102) with
 ESMTPSA (Nemesis) id 0Lvjn6-1aCqh12LFM-017WuR for
 <linux-media@vger.kernel.org>; Tue, 29 Dec 2015 10:01:59 +0100
To: linux-media@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [media] anysee: Checking failure reporting
Message-ID: <56824C02.2040607@users.sourceforge.net>
Date: Tue, 29 Dec 2015 10:01:54 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have looked at the implementation of the function "anysee_del_i2c_dev" once more.
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/drivers/media/usb/dvb-usb-v2/anysee.c?id=80c75a0f1d81922bf322c0634d1e1a15825a89e6#n685

Is it really appropriate to end this one with the message "failed"?
Would it be useful to move such a log statement a bit?

Regards,
Markus
