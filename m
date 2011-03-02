Return-path: <mchehab@pedra>
Received: from out1.ip05ir2.opaltelecom.net ([62.24.128.241]:57474 "EHLO
	out1.ip05ir2.opaltelecom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754327Ab1CBQ02 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2011 11:26:28 -0500
Message-Id: <9fnr6q$9ube9b@out1.ip05ir2.opaltelecom.net>
Date: Wed, 02 Mar 2011 16:16:33 +0000
To: linux-media@vger.kernel.org
From: Nick Pelling <nickpelling@nanodome.com>
Subject: Missing /dev/video[N] devices...?
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everyone,

I'm trying to bring up the 2.6.37 kernel from scratch on a new 
Samsung S5PC100-based board, but have hit a media problem. Though my 
various v4l2 devices are all registering OK during the boot process 
and end up visible in /sys/class/video4linux , they never manage to 
become visible in /dev , i.e.

	# ls /dev/video*
	ls: /dev/video*: No such file or directory

	# ls /sys/class/video4linux/
	video0   video1   video14  video2   video21  video22

	# ls /sys/class/video4linux/video0/
	dev        index      name       subsystem  uevent

	# cat /sys/class/video4linux/video0/name
	s5p-fimc.0:m2m

	# cat /sys/class/video4linux/video0/uevent
	MAJOR=81
	MINOR=0
	DEVNAME=video0

I've tried enabling everything that seems relevant in the kernel's 
menuconfig options, but it seems as though I've omitted some crucial 
piece of the v4l2 infrastructure. Any suggestions for what's missing?

Thanks!, ....Nick Pelling....

