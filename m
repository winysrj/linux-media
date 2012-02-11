Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:39129 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab2BKUFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Feb 2012 15:05:35 -0500
Received: from moweb001.kundenserver.de (moweb001.kundenserver.de [172.19.20.114])
	by fmmailgate01.web.de (Postfix) with ESMTP id 0A8A31AA5A437
	for <linux-media@vger.kernel.org>; Sat, 11 Feb 2012 21:05:34 +0100 (CET)
Date: Sat, 11 Feb 2012 21:05:32 +0100
From: Sebastian Kricner <sebastian.kricner@web.de>
To: linux-media@vger.kernel.org
Subject: Problem with V4L2 IOCTLs since 2.6.39
Message-ID: <20120211210532.41755817@cluster-node1.tuxwave.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,

there must be made some changes to the V4L2 IOCTLs, also the V4L2 API
since 2.6.39.
Upon starting xawtv, i get following errors:

ioctl: VIDIOC_S_CTRL(id=9963785;value=0): Unpassender IOCTL
(I/O-Control) für das Gerät ioctl: VIDIOC_S_CTRL(id=9963785;value=1):
Unpassender IOCTL (I/O-Control) für das Gerät ioctl:
VIDIOC_S_CTRL(id=9963778;value=30801): Unpassender IOCTL (I/O-Control)
für das Gerät ioctl: VIDIOC_S_CTRL(id=9963776;value=30801): Unpassender
IOCTL (I/O-Control) für das Gerät ioctl:
VIDIOC_S_CTRL(id=9963779;value=30801): Unpassender IOCTL (I/O-Control)
für das Gerät ioctl: VIDIOC_S_CTRL(id=9963777;value=30801): Unpassender
IOCTL (I/O-Control) für das Gerät ioctl:
VIDIOC_S_CTRL(id=9963785;value=0): Unpassender IOCTL (I/O-Control) für
das Gerät

I also have made some application
(http://tuxwave.net/index.php?page=2&subpage=23) using the radio tuner
of a Hauppauge WinTV card, since 2.6.39 i can not request the tuner
range anymore.

Initializing...
Card: BT878 radio (Hauppauge (bt878))
Lowest Frequency: 0 (0 MHz)
Highest Frequency: 0 (0 MHz

The ioctls used by xawtv are related to audio settings
(mute/unmute, volume).

I tried to get more information upon this subject, but to no available.
What changes where made, so that those ioctls fail?

I also was in contact with Verkuil, he mentioned the bug on the tuner
ranges should be fixed in the kernel versions starting the 3. branch.
I am currently useing the 3.2.5 kernel, with no difference so far.

It would be very nice and helpful what changes were made to know how to
fix those issues.

Regards

Sebastian Kricner

