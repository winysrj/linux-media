Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm1.bullet.mail.ird.yahoo.com ([77.238.189.58]:41953 "EHLO
	nm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753605Ab3FBQFe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Jun 2013 12:05:34 -0400
References: <1367840892.39557.YahooMailNeo@web28904.mail.ir2.yahoo.com> <5187D1BC.8030204@gmail.com> <1367880378.47575.YahooMailNeo@web28901.mail.ir2.yahoo.com>
Message-ID: <1370189132.73195.YahooMailNeo@web28906.mail.ir2.yahoo.com>
Date: Sun, 2 Jun 2013 17:05:32 +0100 (BST)
From: marco caminati <marco.caminati@yahoo.it>
Reply-To: marco caminati <marco.caminati@yahoo.it>
Subject: rtl2832u+r820t working
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <1367880378.47575.YahooMailNeo@web28901.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This usb dongle (0bda:2838) now works for me. 
Thanks to all people who worked on it, especially to Gianluca.
Built from git://linuxtv.org/media_build under Linux box 3.8.10-tinycore #3810 SMP Tue Apr 30 15:45:26 UTC 2013 i686 GNU/Linux.

---INFRARED REMOTE---

I also ask if ir remote will be supported. 
With some old version of v4l (not supporting r820t) I managed to have the infrared working as a hid (/dev/input/eventX) device.
So it should be possible to merge the code from that old version into the current one to have everything supported.
The problem is that I can't remember which version was that, can anybody help me?

Alternatively, I patched as from  [1], and successfully built, current v4l: however, resulting .ko do not support ir remote, it seems (not even as an option to pass to modprobe).
Any indication, please?

Cheers

[1] https://patchwork.kernel.org/patch/2468671/
