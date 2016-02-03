Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53437 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbcBCNq4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2016 08:46:56 -0500
To: Wolfram Sang <wsa@the-dreams.de>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: tvp5150 regression after commit 9f924169c035
Cc: linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <56B204CB.60602@osg.samsung.com>
Date: Wed, 3 Feb 2016 10:46:51 -0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Wolfram,

I've a issue with a I2C video decoder driver (drivers/media/i2c/tvp5150.c).

In v4.5-rc1, the driver gets I2C read / writes timeouts when accessing the
device I2C registers:

tvp5150 1-005c: i2c i/o error: rc == -110
tvp5150: probe of 1-005c failed with error -110

The driver used to work up to v4.4 so this is a regression in v4.5-rc1:

tvp5150 1-005c: tvp5151 (1.0) chip found @ 0xb8 (OMAP I2C adapter)
tvp5150 1-005c: tvp5151 detected.

I tracked down to commit 9f924169c035 ("i2c: always enable RuntimePM for
the adapter device") and reverting that commit makes things to work again.

The tvp5150 driver doesn't have runtime PM support but the I2C controller
driver does (drivers/i2c/busses/i2c-omap.c) FWIW.

I tried adding runtime PM support to tvp5150 (basically calling pm_runtime
enable/get on probe before the first I2C read to resume the controller) but
that it did not work.

Not filling the OMAP I2C driver's runtime PM callbacks does not help either.

Any hints about the proper way to fix this issue?

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
