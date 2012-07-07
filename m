Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm17-vm0.bullet.mail.ird.yahoo.com ([77.238.189.214]:30937 "HELO
	nm17-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751326Ab2GGC0f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 22:26:35 -0400
Message-ID: <1341627993.41434.YahooMailClassic@web29403.mail.ird.yahoo.com>
Date: Sat, 7 Jul 2012 03:26:33 +0100 (BST)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: unload/unplugging (Re: success! (Re: media_build and Terratec Cinergy T Black.))
To: Antti Palosaari <crope@iki.fi>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <1341627106.90091.YahooMailClassic@web29405.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

BTW, I tried just pulling the USB stick out while mplayer is running. Strangely enough mplayer did not notice it gone and kept going for some 5 to 10 seconds. Probably buffering?

The only sign about it is two lines in dmesg (other than the usual usb messages about device being unplug).

[227690.953311] rtl2832: i2c rd failed=-19 reg=01 len=1
[227710.818089] usb 1-2: dvb_usbv2: streaming_ctrl() failed=-19

I also have quite a few :

[224773.229293] DVB: adapter 0 frontend 0 frequency 2 out of range (174000000..862000000)

This seems to come from running w_scan.

The kernel seems happy while having the device physically pulled out. But the kernel module does not like to be unloaded (modprobe -r) while mplayer is running, so we need to fix that.
