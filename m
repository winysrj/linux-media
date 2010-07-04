Return-path: <linux-media-owner@vger.kernel.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228]:51850 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755556Ab0GDOJT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Jul 2010 10:09:19 -0400
Message-ID: <a01de4d0f269194e62c4f2bf5cd15743.squirrel@mail.otasc.org>
Date: Sun, 4 Jul 2010 16:09:17 +0200 (CEST)
Subject: How to make working Webcam EM2750
From: g.duale@otasc.org
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,
I have a laptop with an integrated webcam, and it doesn't works.

My webcam is :

lsusb|grep -i webcam
  Bus 001 Device 004: ID eb1a:2750 eMPIA Technology, Inc. ECS Elitegroup
G220 integrated Webcam

My system is : uname -a
Linux roland-laptop 2.6.32-23-generic #37-Ubuntu SMP Fri Jun 11 07:54:58
UTC 2010 i686 GNU/Linux

In dmesg I found BUG Kernel about the webcam driver when the module is
loaded : (in em28xx-video.c:876)
 http://pastebin.com/VsSvmfM6

What can I do to solve the problem please ? :)

Thanks a lot,
Regards,
Guillaume.

