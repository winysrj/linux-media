Return-path: <linux-media-owner@vger.kernel.org>
Received: from mujunyku.leporine.io ([113.212.96.195]:42516 "EHLO
	mujunyku.leporine.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbbHAL4Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Aug 2015 07:56:16 -0400
Message-ID: <55BCB201.2060709@rabbit.us>
Date: Sat, 01 Aug 2015 13:48:17 +0200
From: Peter Rabbitson <rabbit@rabbit.us>
MIME-Version: 1.0
To: submit@bugs.debian.org
CC: linux-media@vger.kernel.org
Subject: Hardware H264 capture regression in UVC subsystem: wheezy(ok) =>
 jessie(bad)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Package: linux-image-3.16.0-4-amd64
Version: 3.16.7-ckt11-1
Tags: patch fixed-upstream

Greetings!

A little bit after the official Wheezy linux-image (3.2) a change to the 
UVC subsystem[1] was merged and subsequently released as linux 3.3. A 
long-unnoticed side effect of this patch was a regression that produced 
invalid timestamps on hardware-encoded H264 captures, which is known to 
affect at least 2 different devices: Logitech C920[2] and a builtin Acer 
Orbicam[3].

The problem was recently acknowledged by the UVC maintainer and a patch 
was produced which fixes the issue [4]. Afaik it is slated to be 
included during the Linux 4.3 merge window this month.

Since there is no way to work around this problem in userland [5], and 
there are many reports of this problem by different users [3], [6], [7], 
[8] it seems fitting to add this (rather small) patch[4] to debian's 
linux-image-3.16* quilt.

Thank you in advance!
Cheers

P.S. Adding a one-time CC to the linux-media mailing list, in case a 
part of the above is factually incorrect.

[1] 
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=66847ef
[2] http://sourceforge.net/p/linux-uvc/mailman/message/33164469/
[3] http://www.spinics.net/lists/linux-media/msg92089.html
[4] http://www.spinics.net/lists/linux-media/msg92022.html
[5] http://ffmpeg.org/pipermail/ffmpeg-user/2015-July/027630.html
[6] https://trac.ffmpeg.org/ticket/3956
[7] http://sourceforge.net/p/linux-uvc/mailman/message/33564420/
[8] 
http://askubuntu.com/questions/456175/logitech-c920-webcam-on-ubuntu-14-04-hesitates-chops-every-3-seconds
