Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm19.bullet.mail.ird.yahoo.com ([77.238.189.76]:26342 "EHLO
	nm19.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919Ab2LSXBY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Dec 2012 18:01:24 -0500
Message-ID: <1355958053.43473.YahooMailNeo@web132104.mail.ird.yahoo.com>
Date: Wed, 19 Dec 2012 23:00:53 +0000 (GMT)
From: marco caminati <marco.caminati@yahoo.it>
Reply-To: marco caminati <marco.caminati@yahoo.it>
Subject: rtl2832u+r820t dvb-t usb
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a rtl2832u+r820t dvb-t usb dongle; I use linux (x86).

There is good support for using it as sdr.
However, using it to watch dvb-t (I am in Europa) turned out to be difficult.
The only way that worked: downgrade my linux kernel to 2.6.33.3, and compiling these sources:

https://groups.google.com/d/msg/ultra-cheap-sdr/QiIo7834sLI/7YpqSRnYud4J

which forced me to using an older commit of v4l (mercurial df33bbd60225), and to comment out all references to rtl2832u_rc_keys_map_table.

In a word: it works, but the situation is disappointing.
Since such dongles are probably to be sold massively (taking the place of the dismissed e4000-based ones), can anybody help me porting this stuff to a more maintainable form?

PS: Be aware: identification of these cheap dongles can be very messy. In my case, lsusb returned 0bda:2838, which is the same as other ones having e4000 or fc0012, as ezcap EzTV646. Even the appearance can be misleading: there are e4000 looking exactly the same.

