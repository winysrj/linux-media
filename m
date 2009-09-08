Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from jordan.mc0.hosteurope.de ([80.237.138.9])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <julian@summer06.de>) id 1Mkxhc-0007E5-9J
	for linux-dvb@linuxtv.org; Tue, 08 Sep 2009 12:13:33 +0200
To: <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Date: Tue, 08 Sep 2009 12:12:58 +0200
From: wp1013465-julian <julian@summer06.de>
Message-ID: <545101bcf70ce37d9151656742241c58-EhVcX15CQQRaRwMFBAwJVjBXdh9XVlpBXkJHHFxYNkhQS18IQV5zB0tSVDBeQ0AAW1pdR19d-webmailer2@server03.webmailer.hosteurope.de>
Cc: Aapo Tahkola <aet@rasterburn.org>, Daniel Weigl <danielweigl@gmx.at>
Subject: [linux-dvb] LifeView LR506
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Hi all,

I'm trying to add support for the LifeView LR506. I started with the patch
by Daniel Weigl [1] and ported it to dvb-usb-cxusb as mkrufky suggested
[2]. The firmware [3] is uploaded correctly and the device reconnects as
expected. My current problem is, that the frontend is not connected.
I posted my patch & a dmesg log to the discussion page on the Wiki [4]
The patch ( against 13c47deee3b1 ) is also available from [5]

The relevant error message is:
[ 1208.092439] tda10046: chip is not answering. Giving up.

How can I find out what _exactly_ is going wrong? Should I try some
USB-Logging?

Cheers,
Julian Picht

[1] http://danyserv.selfip.org/dir/LifeView/v4l-patch-lr506
[2] http://marc.info/?l=linux-dvb&m=118296620612391&w=2
[3] http://danyserv.selfip.org/dir/LifeView/dvb-usb-tvwalker-lr506.fw
[4] http://www.linuxtv.org/wiki/index.php/Talk:LifeView_LR506
[5] http://www.ep-edv.de/files/dvb-usb-cxusb-lr506.diff

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
