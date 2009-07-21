Return-path: <linux-media-owner@vger.kernel.org>
Received: from web26904.mail.ukl.yahoo.com ([217.146.176.93]:25294 "HELO
	web26904.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750870AbZGULxP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 07:53:15 -0400
Message-ID: <244663.51282.qm@web26904.mail.ukl.yahoo.com>
Date: Tue, 21 Jul 2009 11:46:33 +0000 (GMT)
From: SebaX75 <sebax75@yahoo.it>
Subject: Problem with Pinnacle Dazzle Hybrid Stick (320E variant)
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,
as in subject I've a problem with this hardware, identified as USB device with id eb1a:2881.
I've already seen that someone has it working on different arch and kernel version (http://www.mail-archive.com/linux-media@vger.kernel.org/msg07551.html); I've no error on build time, nor in module loading, all required module are present, but the tuner don't work correctly and recognize only one MUX at 474000000 and mplayer is very slow to tune on a channel, before it was not slow as now.
Before, with kernel 2.6.27 + v4l patch + em28xx-new patch, and now only with windows, all was working. Now, with kernel 2.6.29.5 (on Fedora 11) and last patch tree (20/07/2009) from v4l is not possible to have this hardware working.
I've tried to search help on irc channel #V4L (log available at http://linuxtv.org/irc/v4l/index.php?date=2009-07-20 and http://linuxtv.org/irc/v4l/index.php?date=2009-07-21) and I've found devinheitmueller, that tried to help me checking my dmesg/lsmod/scandvb output and asking what don't work.
At the end of problem inspection, he has told that is likely a problem with the configuration for the xc3028 or zl10353 or a sort of sensitivity problem and only with debugging and a developer I can solve my problem.

Now I ask if one developer is interested and able to help me for this hardware, I'm not a programmer, but a sysadmin, and I've some basic knowledge about how to debug code and / or patches, but without help I don't know where to start.

Thanks to anyone that contact me,
Sebastian


      
