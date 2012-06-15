Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34353 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2FOAOn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 20:14:43 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so3255760dad.19
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 17:14:43 -0700 (PDT)
Message-ID: <4FDA7E70.5030405@gmail.com>
Date: Fri, 15 Jun 2012 05:44:40 +0530
From: Shubhadeep Chaudhuri <shubhadeepc@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Webcam Genius 1300[AF] V2 not working since kernel 2.6.39
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The webcams Genius 1300 V2 and Genius 1300AF V2 (and probably some built-in
MacBook iSight webcams) face an issue since v2.6.39. For versions before
that,
they work fine.

Every application displays a black screen for the devices except for mplayer
which displays a green screen.

Output of lsusb -vvv -d 0458:7067
http://pastebin.com/9R9atS9L

Output of mplayer tv:// -tv
driver=v4l2:width=640:height=480:device=/dev/video0
-fps 30
http://pastebin.com/pHuaKDv8

On doing git bisect, I was able to find the commit which brings the
regression.
It's commit e1620d591a75a10b15cf61dbf8243a0b7e6731a2 titled USB: Move
runtime
PM callbacks to usb_device_pm_ops.

A bug was reported with UVC on sourceforge by another user
http://sourceforge.net/mailarchive/message.php?msg_id=29030464

Please fix this. Would hate to see this remain unfixed especially since
I gave
quite an amount of time to find the commit.
