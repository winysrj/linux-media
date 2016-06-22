Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:59522 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbcFVXKJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2016 19:10:09 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Shuah Khan <shuahkh@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org
Subject: [BUG] au0828: dev->lock in au0828_usb_probe()
Date: Thu, 23 Jun 2016 00:11:04 +0100
Message-Id: <1466637064-4662-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is not quite clear what does mutex_lock(&dev->lock) defend against.

If there is a chance that some other code can try to lock the mutex during probe(),
then 
  mutex_unlock(&dev->lock);
  kfree(dev);
looks suspicious, because when that code get control form mutex_lock(dev->lock)
the dev could be already freed.

Otherwise, dev->lock should not be acquired so early.

Another problem is that on the path going via goto done
there is no mutex_unlock(&dev->lock).

Found by Linux Driver Verification project (linuxtesting.org).

--
Alexey Khoroshilov
Linux Verification Center, ISPRAS
web: http://linuxtesting.org

