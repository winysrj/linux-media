Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43217 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753351AbZGNQOc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2009 12:14:32 -0400
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 14 Jul 2009 18:14:28 +0200
From: aldoric@gmx.de
Message-ID: <20090714161428.49520@gmx.net>
MIME-Version: 1.0
Subject: [Question] USB-Web-Cam becomes slower as darker the image becomes
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm new to v4l-development. I was able to get the raw image into my application successfully. But the current problem is not only in limited to my self-developed application.

All of my USB-webcams will get less FPS as darker the image becomes. In optimal cases I get around 30 frames per second. But if it's really dark I only get around 2-3 FPS.

I think that it might be the software gamma-correction. On v4l2ucp I didn't find a way to disable it.

What do you think is the way to fasten up the video-recording? How can I disable software gamma-correction if this is the reason?

Thanks in advance


-- 
Jetzt kostenlos herunterladen: Internet Explorer 8 und Mozilla Firefox 3 -
sicherer, schneller und einfacher! http://portal.gmx.net/de/go/atbrowser
