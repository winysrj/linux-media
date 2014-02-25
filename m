Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgate.leissner.se ([212.3.1.210]:29913 "EHLO
	mailgate.leissner.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaBYIXB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 03:23:01 -0500
Received: from mailgate.leissner.se (localhost [127.0.0.1])
	by mailgate.leissner.se (8.14.8/8.14.8) with ESMTP id s1P8MxxG023400
	for <linux-media@vger.kernel.org>; Tue, 25 Feb 2014 09:22:59 +0100 (CET)
	(envelope-from pf@leissner.se)
Received: (from uucp@localhost)
	by mailgate.leissner.se (8.14.8/8.14.8/Submit) id s1P8Mxej023399
	for <linux-media@vger.kernel.org>; Tue, 25 Feb 2014 09:22:59 +0100 (CET)
	(envelope-from pf@leissner.se)
Received: from nic-i.leissner.se (localhost [127.0.0.1])
	by nic-i.leissner.se (8.14.8/8.14.7) with ESMTP id s1P8MudW031956
	for <linux-media@vger.kernel.org>; Tue, 25 Feb 2014 09:22:56 +0100 (CET)
	(envelope-from pf@leissner.se)
Received: from localhost (pf@localhost)
	by nic-i.leissner.se (8.14.8/8.14.7/Submit) with ESMTP id s1P8Muf7031953
	for <linux-media@vger.kernel.org>; Tue, 25 Feb 2014 09:22:56 +0100 (CET)
	(envelope-from pf@leissner.se)
Date: Tue, 25 Feb 2014 09:22:28 +0100 (SNT)
From: Peter Fassberg <pf@leissner.se>
To: linux-media@vger.kernel.org
Subject: Problem with PCTV Systems nanoStick T2 290e and frontends
In-Reply-To: <201402242314.s1ONEjtD003815@mailgate.leissner.se>
Message-ID: <alpine.BSF.2.00.1402250918400.31790@nic-i.leissner.se>
References: <201402242314.s1ONEjtD003815@mailgate.leissner.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi!

I have an PCTV Systems nanoStick T2 290e.

It shows up very differently with different kernels, and it seems to work better (DVB-C support) in an OLDER kernel.

Old kernel is using em28xx and showing two frontends (as stated on the wiki docs). New kernel is using em28174 and showing only a DVB-T frontend.

Is there a way to force the new kernel to use em28xx instead?


Excerpt from log:

Using Linux debian 3.2.0-4-amd64 #1 SMP Debian 3.2.54-2 x86_64 GNU/Linux:

[   90.006701] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps (2013:024f, interface 0, class 0)
[   90.007281] em28xx #0: chip ID is em28174
[   90.333600] em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
[   90.377066] em28xx #0: v4l2 driver version 0.1.3
[   90.447548] em28xx #0: V4L2 video device registered as video0
[   90.447584] usbcore: registered new interface driver em28xx
[   90.447586] em28xx driver loaded
[   90.520717] tda18271 0-0060: creating new instance
[   90.551187] TDA18271HD/C2 detected @ 0-0060
[   91.341140] tda18271 0-0060: attaching existing instance
[   91.341145] DVB: registering new adapter (em28xx #0)
[   91.341150] DVB: registering adapter 0 frontend 0 (Sony CXD2820R (DVB-T/T2))...
[   91.342477] DVB: registering adapter 0 frontend 1 (Sony CXD2820R (DVB-C))...
[   91.345700] em28xx #0: Successfully loaded em28xx-dvb
[   91.345706] Em28xx: Initialized (Em28xx dvb Extension) extension


And from Linux debian 3.12-1-amd64 #1 SMP Debian 3.12.9-1 (2014-02-01) x86_64 GNU/Linux:

[207774.334552] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps (2013:024f, interface 0, class 0)
[207774.334557] em28xx: DVB interface 0 found: isoc
[207774.335059] em28xx: chip ID is em28174
[207774.734814] em28174 #0: Identified as PCTV nanoStick T2 290e (card=78)
[207774.734821] em28174 #0: v4l2 driver version 0.2.0
[207774.814336] em28174 #0: V4L2 video device registered as video0
[207774.814341] em28174 #0: dvb set to isoc mode.
[207774.823844] usbcore: registered new interface driver em28xx
[207774.895574] tda18271 1-0060: creating new instance
[207774.926952] TDA18271HD/C2 detected @ 1-0060
[207775.290440] DVB: registering new adapter (em28174 #0)
[207775.290453] usb 1-1: DVB: registering adapter 0 frontend 0 (Sony CXD2820R)...
[207775.294597] em28174 #0: Successfully loaded em28xx-dvb
[207775.294602] Em28xx: Initialized (Em28xx dvb Extension) extension

Linux debian 3.12-1-amd64 #1 SMP Debian 3.12.9-1 (2014-02-01) x86_64 GNU/Linux


Best regards,

-- Peter


