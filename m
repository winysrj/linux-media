Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm33.bullet.mail.ne1.yahoo.com ([98.138.229.26]:41723 "EHLO
	nm33.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755493AbaBTTdX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 14:33:23 -0500
Message-ID: <1392924626.38711.YahooMailNeo@web120304.mail.ne1.yahoo.com>
Date: Thu, 20 Feb 2014 11:30:26 -0800 (PST)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: PWC webcam and setpwc tool no longer working with 3.12.11 kernel
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hi,

I have an old Logitech webcam, with USB IDs 046d:08b3. When I try to use this camera now, I see this error in the dmesg log:

[ 2883.852464] pwc: isoc_init() submit_urb 0 failed with error -28


This error is apparently ENOSPC, which made me suspect that I was trying to use a mode that would require compression. However, when I tried using setpwc to configure the camera's options I received more errors:
$ setpwc -c 3
setpwc v1.3, (C) 2003-2006 by folkert@vanheusden.com
Error while doing ioctl VIDIOCPWCSCQUAL: Inappropriate ioctl for device


Has the kernel-to-userspace interface for PWC devices changed? Because how else could this IOCTL be "inappropriate"? Is there an alternative to setpwc, please?

Thanks,
Chris
