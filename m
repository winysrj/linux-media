Return-path: <linux-media-owner@vger.kernel.org>
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:29592
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753977Ab2JHHqo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Oct 2012 03:46:44 -0400
From: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: omap3-isp-live does not allocate big enough buffers?
Date: Mon, 8 Oct 2012 07:46:35 +0000
Message-ID: <6EE9CD707FBED24483D4CB0162E8546710061917@AM2PRD0710MB375.eurprd07.prod.outlook.com>
Content-Language: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

I am working on a demo-application for displaying a videostream on a 
beagleboard. Now I have seen that you have done something similar, 
but if I run your "live" application out of the omap3-isp-live repo,
then I get the following error:

root@beagleboard:~# modprobe omap_vout video1_numbuffers=3 
video2_numbuffers=3 video1_bufsize=771200 video2_bufsize=771200 
vid1_static_vrfb_alloc=n vid2_static_vrfb_alloc=n
root@beagleboard:~# ./live
fb size is 800x480
Device /dev/video6 opened: OMAP3 ISP resizer output (media).
viewfinder configured for 2011 800x482
AEWB: #win 10x7 start 16x74 size 256x256 inc 30x30
trying to allocate 800x480
Device /dev/video7 opened: omap_vout ().
3 buffers requested.
Buffer 0 mapped at address 0xb6d68000.
Buffer 1 mapped at address 0xb6cac000.
Buffer 2 mapped at address 0xb6bf0000.
3 buffers requested.
Buffer 0 too small (771200 bytes required, 770048 bytes available).
error: unable to allocate buffers for viewfinder.
error: unable to set buffers pool

This seems to happen in the v4l2_alloc_buffers function of v4l2.c
when memtype is V4L2_MEMORY_USERPTR. Has it been broken in the
newer kernel versions? Do you have hint where I should start fixing?

I am using the following config:
beagleboard-xm
linux-omap branch, tag v3.5
leopard imaging li-5m03 with mt9p031

Greetings,
Florian

