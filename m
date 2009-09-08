Return-path: <linux-media-owner@vger.kernel.org>
Received: from perry.mc0.hosteurope.de ([80.237.138.8]:33211 "EHLO
	perry.mc0.hosteurope.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbZIHQcp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Sep 2009 12:32:45 -0400
Received: from server03.webmailer.hosteurope.de ([10.9.0.182]);
	by mailout.hosteurope.de (perry.mc0.hosteurope.de) running EXperimental Internet Mailer with esmtps (TLS-1.0:RSA_AES_256_CBC_SHA1:32)
	id 1Ml3Oe-0006lj-OF
	for linux-media@vger.kernel.org; Tue, 08 Sep 2009 18:18:20 +0200
Received: from nobody by server03.webmailer.hosteurope.de with local (Exim 4.69)
	(envelope-from <julian@summer06.de>)
	id 1Ml3Oe-0005WY-Gu
	for linux-media@vger.kernel.org; Tue, 08 Sep 2009 18:18:20 +0200
To: <linux-media@vger.kernel.org>
Subject: LifeView LR506
MIME-Version: 1.0
Date: Tue, 08 Sep 2009 18:18:20 +0200
From: wp1013465-julian <julian@summer06.de>
Message-ID: <6d2c06f7cd14e6091997a766c5c81cab-EhVcX15CQQRaRwMFBAwJVjBXdh9XVlpBXkJHHFxYNkhQS18IQV5zB0tSVDBeQ0AAW1hfR1hV-webmailer2@server03.webmailer.hosteurope.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi all,

I'm trying to add support for the LifeView LR506. I started with the patch
by Daniel Weigl [1] and ported it to dvb-usb-cxusb as mkrufky suggested
[2]. The firmware [3] is uploaded correctly and the device reconnects as
expected. My current problem is, that the frontend is not connected.
I posted my patch & a dmesg log to the discussion page on the Wiki [4]
The patch ( against 13c47deee3b1 ) is also available from [5]

The relevant error message is:
[ 1208.092439] tda10046: chip is not answering. Giving up.

I think this is because some bulk messages fail.
How can I find out what _exactly_ is going wrong? Should I try some
USB-Logging?

Cheers,
Julian Picht

[1] http://danyserv.selfip.org/dir/LifeView/v4l-patch-lr506
[2] http://marc.info/?l=linux-dvb&m=118296620612391&w=2
[3] http://danyserv.selfip.org/dir/LifeView/dvb-usb-tvwalker-lr506.fw
[4] http://www.linuxtv.org/wiki/index.php/Talk:LifeView_LR506
[5] http://www.ep-edv.de/files/dvb-usb-cxusb-lr506.diff

