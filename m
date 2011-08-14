Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm4-vm1.bullet.mail.ne1.yahoo.com ([98.138.91.44]:29972 "HELO
	nm4-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751141Ab1HNXpo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 19:45:44 -0400
Message-ID: <1313365542.39357.YahooMailClassic@web121712.mail.ne1.yahoo.com>
Date: Sun, 14 Aug 2011 16:45:42 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: PCTV 290e - assorted problems (cont)
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Another thing I've noticed - a successful hotplug outputs the following messages into the dmesg log:

DVB: registering new adapter (em28xx #0)
DVB: registering adapter 0 frontend 0 (Sony CXD2820R (DVB-T/T2))...
DVB: registering adapter 0 frontend 1 (Sony CXD2820R (DVB-C))...
em28xx #0: Successfully loaded em28xx-dvb
Em28xx: Initialized (Em28xx dvb Extension) extension

However, I'm suspecting that the DVB adapter doesn't actually become usable until these messages have also appeared:

tda18271: performing RF tracking filter calibration
tda18271: RF tracking filter calibration complete

The most obvious example of this is when using xine's DVB plugin: xine fails on the first attempt after a fresh hotplug, saying "Sorry, No DVB input device found.". And it's also possible that trying to use xine with the device before the "tracking filter calibration" completes is what is making em28xx_usb_probe() hang...

Oh well, it's early days...

Cheers,
Chris

