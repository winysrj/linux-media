Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm1.bt.bullet.mail.ird.yahoo.com ([212.82.108.232]:37559 "HELO
	nm1.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751279Ab1IXOyU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 10:54:20 -0400
Message-ID: <4E7DEF16.6070209@yahoo.com>
Date: Sat, 24 Sep 2011 15:54:14 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: [PATCH 0/2] EM28xx patches for 3.2
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

I am resending the two patches for the em28xx driver which seem to have been 
missed for 3.2. The first one simply removes a stray bit operation on 
em28xx_devused, whereas the second tidies up the device/extension list handling.

It is possible that the first patch has been applied already. However, I cannot 
be sure because I cannot find a URL anywhere that will show me the current 
"HEAD" of the "pending for 3.2" tree.

BTW, did you implement a different solution for the DVB module trying to retake 
the dev->lock mutex? Because it looks as if both em28xx_dvb_init() and 
em28xx_usb_probe() are still calling mutex_lock().

Cheers,
Chris
