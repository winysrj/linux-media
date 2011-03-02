Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:52656 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168Ab1CBSyh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2011 13:54:37 -0500
References: <9fnr6q$9ube9b@out1.ip05ir2.opaltelecom.net>
In-Reply-To: <9fnr6q$9ube9b@out1.ip05ir2.opaltelecom.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Missing /dev/video[N] devices...?
From: Andy Walls <awalls@md.metrocast.net>
Date: Wed, 02 Mar 2011 13:54:39 -0500
To: Nick Pelling <nickpelling@nanodome.com>,
	linux-media@vger.kernel.org
Message-ID: <dd9effa0-f249-47da-9e76-0c10092c8976@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Nick Pelling <nickpelling@nanodome.com> wrote:

>Hi everyone,
>
>I'm trying to bring up the 2.6.37 kernel from scratch on a new 
>Samsung S5PC100-based board, but have hit a media problem. Though my 
>various v4l2 devices are all registering OK during the boot process 
>and end up visible in /sys/class/video4linux , they never manage to 
>become visible in /dev , i.e.
>
>	# ls /dev/video*
>	ls: /dev/video*: No such file or directory
>
>	# ls /sys/class/video4linux/
>	video0   video1   video14  video2   video21  video22
>
>	# ls /sys/class/video4linux/video0/
>	dev        index      name       subsystem  uevent
>
>	# cat /sys/class/video4linux/video0/name
>	s5p-fimc.0:m2m
>
>	# cat /sys/class/video4linux/video0/uevent
>	MAJOR=81
>	MINOR=0
>	DEVNAME=video0
>
>I've tried enabling everything that seems relevant in the kernel's 
>menuconfig options, but it seems as though I've omitted some crucial 
>piece of the v4l2 infrastructure. Any suggestions for what's missing?
>
>Thanks!, ....Nick Pelling....
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

I thought udev normally makes those nodes.

On embedded systems there is a different, smaller user space app responding to hotplug events including firmware load requests.

-Andy
